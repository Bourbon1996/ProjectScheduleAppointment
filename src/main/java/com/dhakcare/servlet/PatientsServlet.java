package com.dhakcare.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDate;
import java.util.List;

import com.dhakcare.dao.impl.PatientDAOImpl;
import com.dhakcare.entity.Patient;
import com.dhakcare.entity.User;
import com.dhakcare.enums.Relationship;
import com.dhakcare.service.PatientService;
import com.dhakcare.service.impl.PatientServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet implementation class PaymentServlet
 */
@WebServlet({"/patient/create", "/patient/update", "/patient/delete"})
public class PatientsServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

    /**
     * Default constructor. 
     */
	
	private PatientService patientService = new PatientServiceImpl();
    public PatientsServlet() {
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// 1. Cấu hình tiếng Việt
		request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        String path = request.getServletPath();

        User loggedInUser = (User) session.getAttribute("user");
        if (loggedInUser == null) {
            session.setAttribute("ERROR_MSG", "Vui lòng đăng nhập!");
            response.sendRedirect(request.getContextPath() + "/user/login");
            return;
        }

        if (path.contains("/patient/delete")) {
            doDeletePatient(request, response, loggedInUser);
            return;
        }
        
        if (path.contains("/patient/update")) {
            doUpdatePatient(request, response, loggedInUser);
            return;
        }

        // Default: create
        doCreatePatient(request, response, loggedInUser);
	}

	private void doCreatePatient(HttpServletRequest request, HttpServletResponse response, User loggedInUser) throws IOException {
        HttpSession session = request.getSession();
        try {
            String fullName = request.getParameter("fullName");
            String phone = request.getParameter("phone");
            String dobStr = request.getParameter("dob");
            String gender = request.getParameter("gender");
            String address = request.getParameter("address");
            String bhyt = request.getParameter("bhyt");
            String emergency = request.getParameter("emergency");
            String relStr = request.getParameter("relationship");
            String cccd = request.getParameter("cccd");
            String email = request.getParameter("email");
            
            Relationship relEnum = null;
            if (relStr != null && !relStr.isEmpty()) {
                try {
                    relEnum = Relationship.valueOf(relStr);
                } catch (IllegalArgumentException e) {
                    System.out.println("Lỗi: Giá trị relationship không hợp lệ!");
                }
            }

            Patient newPatient = Patient.builder()
                    .user(loggedInUser)
                    .fullName(fullName)
                    .relationship(relEnum)
                    .phone(phone)
                    .email(email != null && !email.isEmpty() ? email : null)
                    .cccd(cccd != null && !cccd.isEmpty() ? cccd : null)
                    .dateOfBirth(dobStr != null && !dobStr.isEmpty() ? LocalDate.parse(dobStr) : null)
                    .gender(gender != null && !gender.isEmpty() ? gender : null)
                    .address(address != null && !address.isEmpty() ? address : null)
                    .healthInsuranceCode(bhyt != null && !bhyt.isEmpty() ? bhyt : null)
                    .emergencyContact(emergency != null && !emergency.isEmpty() ? emergency : null)
                    .build();

            boolean isSaved = patientService.createPatient(newPatient);
            if (isSaved) {
                session.setAttribute("SUCCESS_MSG", "Thêm hồ sơ bệnh nhân thành công!");
            } else {
                session.setAttribute("ERROR_MSG", "Lỗi: Không thể lưu hồ sơ vào cơ sở dữ liệu!");
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("ERROR_MSG", "Lỗi: Dữ liệu gửi lên không hợp lệ!");
        }
        response.sendRedirect(request.getContextPath() + "/appointment");
    }

    private void doUpdatePatient(HttpServletRequest request, HttpServletResponse response, User loggedInUser) throws IOException {
        HttpSession session = request.getSession();
        try {
            String idStr = request.getParameter("patientId");
            Patient existing = patientService.getById(idStr);

            if (existing == null || !existing.getUser().getId().equals(loggedInUser.getId())) {
                session.setAttribute("ERROR_MSG", "Không có quyền chỉnh sửa hồ sơ này!");
                response.sendRedirect(request.getContextPath() + "/appointment");
                return;
            }

            existing.setFullName(request.getParameter("fullName"));
            existing.setPhone(request.getParameter("phone"));
            String email = request.getParameter("email");
            existing.setEmail(email != null && !email.isEmpty() ? email : null);
            String cccd = request.getParameter("cccd");
            existing.setCccd(cccd != null && !cccd.isEmpty() ? cccd : null);

            String dobStr = request.getParameter("dob");
            if (dobStr != null && !dobStr.isEmpty()) {
                existing.setDateOfBirth(LocalDate.parse(dobStr));
            } else {
                existing.setDateOfBirth(null);
            }
            String gender = request.getParameter("gender");
            existing.setGender(gender != null && !gender.isEmpty() ? gender : null);
            String address = request.getParameter("address");
            existing.setAddress(address != null && !address.isEmpty() ? address : null);

            String bhyt = request.getParameter("bhyt");
            existing.setHealthInsuranceCode(bhyt != null && !bhyt.isEmpty() ? bhyt : null);
            String emergency = request.getParameter("emergency");
            existing.setEmergencyContact(emergency != null && !emergency.isEmpty() ? emergency : null);

            String relStr = request.getParameter("relationship");
            if (relStr != null && !relStr.isEmpty()) {
                try { existing.setRelationship(Relationship.valueOf(relStr)); } catch (Exception ignored) {}
            }

            boolean updated = patientService.updatePatient(existing);
            if (updated) {
                session.setAttribute("SUCCESS_MSG", "Cập nhật hồ sơ thành công!");
            } else {
                session.setAttribute("ERROR_MSG", "Lỗi: Không thể cập nhật hồ sơ!");
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("ERROR_MSG", "Lỗi: Dữ liệu không hợp lệ!");
        }
        response.sendRedirect(request.getContextPath() + "/appointment");
    }

    private void doDeletePatient(HttpServletRequest request, HttpServletResponse response, User loggedInUser) throws IOException {
        HttpSession session = request.getSession();
        try {
            String idStr = request.getParameter("patientId");
            Patient existing = patientService.getById(idStr);

            if (existing == null || !existing.getUser().getId().equals(loggedInUser.getId())) {
                session.setAttribute("ERROR_MSG", "Không có quyền xóa hồ sơ này!");
                response.sendRedirect(request.getContextPath() + "/appointment");
                return;
            }

            boolean deleted = patientService.deleteById(existing.getId());
            if (deleted) {
                session.setAttribute("SUCCESS_MSG", "Xóa hồ sơ thành công!");
            } else {
                session.setAttribute("ERROR_MSG", "Lỗi: Không thể xóa hồ sơ (có thể đã có lịch khám liên kết)!");
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("ERROR_MSG", "Lỗi: Không thể xóa hồ sơ!");
        }
        response.sendRedirect(request.getContextPath() + "/appointment");
    }
}
