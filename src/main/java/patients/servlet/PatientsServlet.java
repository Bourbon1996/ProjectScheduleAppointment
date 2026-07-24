package patients.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDate;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import patients.dao.PatientDAOImpl;
import patients.entity.Patient;
import patients.service.PatientService;
import patients.service.PatientServiceImpl;
import users.entity.User;

/**
 * Servlet implementation class PaymentServlet
 */
@WebServlet({"/patient/create"})
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
		HttpSession session = request.getSession();
	    User loggedInUser = (User) session.getAttribute("user");
	    
	    if (loggedInUser != null) {
	        // Gọi DAO lấy toàn bộ danh sách Patient của User này từ SQL Server
	        List<Patient> patientList = patientService.findPatientbyUserId(loggedInUser.getId());
	        // Truyền danh sách sang cho trang JSP
	        request.setAttribute("patientList", patientList);
	    }
	    
	    request.getRequestDispatcher("/views/client/appointment.jsp").forward(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// 1. Cấu hình tiếng Việt
		request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        try {
            // 2. Lấy User đang đăng nhập
            User loggedInUser = (User) session.getAttribute("user");
            if (loggedInUser == null) {
                session.setAttribute("ERROR_MSG", "Vui lòng đăng nhập để tạo hồ sơ!");
                response.sendRedirect(request.getContextPath() + "/user/login");
                return;
            }

            // 3. Lấy tham số theo đúng "name" đã đặt trong thẻ input
            String fullName = request.getParameter("fullName");
            String phone = request.getParameter("phone");
            String dobStr = request.getParameter("dob");
            String gender = request.getParameter("gender");
            String address = request.getParameter("address");
            String bhyt = request.getParameter("bhyt");
            String emergency = request.getParameter("emergency");

            // 4. Tạo Entity Patient
            Patient newPatient = Patient.builder()
                    .user(loggedInUser)
                    .fullName(fullName)
                    .phone(phone)
                    .dateOfBirth(LocalDate.parse(dobStr))
                    .gender(gender)
                    .address(address)
                    .healthInsuranceCode(bhyt != null && !bhyt.isEmpty() ? bhyt : null)
                    .emergencyContact(emergency != null && !emergency.isEmpty() ? emergency : null)
                    .build();

            // 5. Gọi Service lưu vào SQL Server
            boolean isSaved = patientService.createPatient(newPatient);

            if (isSaved) {
                // Lưu thông báo thành công vào Session để trang /appointment hiện thông báo đẹp
                session.setAttribute("SUCCESS_MSG", "🎉 Thêm hồ sơ bệnh nhân thành công!");
            } else {
                session.setAttribute("ERROR_MSG", "❌ Lỗi: Không thể lưu hồ sơ vào cơ sở dữ liệu!");
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("ERROR_MSG", "❌ Lỗi: Dữ liệu gửi lên không hợp lệ!");
        }

        // 6. CHUYỂN HƯỚNG VỀ TRANG ĐẶT LỊCH (/appointment) NHƯ Ý ÔNG
        response.sendRedirect(request.getContextPath() + "/appointment");
	}

}
