package com.dhakcare.servlet;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDateTime;

import com.dhakcare.entity.Doctor;
import com.dhakcare.entity.User;
import com.dhakcare.enums.UserRole;
import com.dhakcare.enums.UserStatus;
import com.dhakcare.service.AppointmentService;
import com.dhakcare.service.DepartmentService;
import com.dhakcare.service.DoctorScheduleSlotService;
import com.dhakcare.service.DoctorService;
import com.dhakcare.service.UserService;
import com.dhakcare.service.impl.AppointmentServiceImpl;
import com.dhakcare.service.impl.DepartmentServiceImpl;
import com.dhakcare.service.impl.DoctorScheduleSlotServiceImpl;
import com.dhakcare.service.impl.DoctorServiceImpl;
import com.dhakcare.service.impl.UserServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

/**
 * Servlet implementation class PaymentServlet
 */
@MultipartConfig
@WebServlet({"/doctor", "/doctor/detail/*","/doctor/delete/*", "/doctor/create", "/doctor/update"})
public class DoctorsServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private DoctorService doctorservice = new DoctorServiceImpl();
	private DoctorScheduleSlotService slotService = new DoctorScheduleSlotServiceImpl();
	private AppointmentService appointmentService = new AppointmentServiceImpl();
	private UserService userService = new UserServiceImpl();
	private DepartmentService departmentService = new DepartmentServiceImpl();

    /**
     * Default constructor. 
     */
    public DoctorsServlet() {
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		String path = request.getServletPath();
	    
	    if (path.equals("/doctor/detail")) {
	        String pathInfo = request.getPathInfo();

	        if (pathInfo != null && pathInfo.length() > 1) {
	            String idStr = pathInfo.substring(1);
	            
	            try {

	                Doctor doctor = doctorservice.getById(Long.parseLong(idStr));

	                if (doctor != null) {
	                    request.setAttribute("doctor", doctor);
	                    request.getRequestDispatcher("/site/views/doctor-detail.jsp").forward(request, response);
	                    return;
	                }
	            } catch (NumberFormatException e) {
	                
	                System.out.println("ID bác sĩ không hợp lệ: " + idStr);
	            }
	        }
	        
	        
	        response.sendRedirect(request.getContextPath() + "/doctor");
	        return;
	    }else if (path.equals("/doctor/delete")) {
	    	String id = request.getParameter("id");
	    	
	    	Doctor doctor = doctorservice.getById(Long.parseLong(id));
	    	if (doctor != null) {
	    		User user = doctor.getUser();
	    		
	    		appointmentService.deleteByDoctorId(id);
	    		slotService.deleteByDoctorId(id);
	    		doctorservice.deleteById(Long.parseLong(id));
	    		
	    		if (user != null) {
	    			userService.deleteById(String.valueOf(user.getId()));
	    		}
	    		request.getSession().setAttribute("message", "Đã xóa bác sĩ và tài khoản liên kết thành công!");
	    	} else {
	    		request.getSession().setAttribute("error", "Không tìm thấy bác sĩ cần xóa.");
	    	}
	    	
	    	response.sendRedirect(request.getContextPath()+"/admin/doctor");
	    	return;
	    }
	   
	    request.getRequestDispatcher("/admin/views/doctor-manager.jsp").forward(request, response);
	   
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		String path = request.getServletPath();
		
		if (path.equals("/doctor/create")) {
			String fullName = request.getParameter("userFullName");
			String phone = request.getParameter("userPhone");
			String email = request.getParameter("userEmail");
			String password = request.getParameter("userPassword");
			String gender = request.getParameter("userGender");
			
			User existingEmail = userService.findByEmail(email);
			if (existingEmail != null) {
				request.getSession().setAttribute("error", "Email đã tồn tại!");
				response.sendRedirect(request.getContextPath() + "/admin/doctor");
				return;
			}
			
			User user = User.builder()
	    		.fullName(fullName)
	            .phone(phone)
	            .email(email)
	            .gender(gender)
	            .passwordHash(password)
	            .role(UserRole.DOCTOR)
	            .status(UserStatus.ACTIVE)
	            .createdAt(LocalDateTime.now())
	            .build();
			
			userService.create(user);
			User createdUser = userService.findByEmail(email);
			
			String departmentId = request.getParameter("departmentId");
			String title = request.getParameter("title");
			String experienceYears = request.getParameter("experienceYears");
			String examinationFee = request.getParameter("examinationFee");
			String description = request.getParameter("description");
			Part avtFile = request.getPart("avtFile");
			
			Doctor doctor = new Doctor();
			doctor.setUser(createdUser);
			doctor.setDepartment(departmentService.findById(Long.parseLong(departmentId)));
			doctor.setTitle(title);
			doctor.setExperienceYears(experienceYears != null && !experienceYears.isEmpty() ? Integer.parseInt(experienceYears) : 0);
			doctor.setExaminationFee(new BigDecimal(examinationFee));
			doctor.setDescription(description);
			
			if (avtFile != null && avtFile.getSize() > 0 && avtFile.getSubmittedFileName() != null && !avtFile.getSubmittedFileName().trim().isEmpty()) {
			    doctor.setAvtUrl(saveAvatarImage(avtFile));
			}
			
			boolean createdDoc = doctorservice.create(doctor);
			if (createdDoc) {
				request.getSession().setAttribute("message", "Thêm bác sĩ thành công!");
			} else {
				request.getSession().setAttribute("error", "Đã xảy ra lỗi khi tạo Bác sĩ.");
			}
			response.sendRedirect(request.getContextPath() + "/admin/doctor");
			return;
			
		} else if (path.equals("/doctor/update")) {
			Long doctorId = Long.parseLong(request.getParameter("id"));
			Doctor doctor = doctorservice.getById(doctorId);
			if (doctor != null) {
				User user = doctor.getUser();
				
				String fullName = request.getParameter("userFullName");
				String phone = request.getParameter("userPhone");
				String email = request.getParameter("userEmail");
				String password = request.getParameter("userPassword");
				String gender = request.getParameter("userGender");
				
				User existingEmail = userService.findByEmail(email);
				if (existingEmail != null && !existingEmail.getId().equals(user.getId())) {
					request.getSession().setAttribute("error", "Email đã tồn tại ở tài khoản khác!");
					response.sendRedirect(request.getContextPath() + "/admin/doctor");
					return;
				}
				
				user.setFullName(fullName);
				user.setPhone(phone);
				user.setEmail(email);
				user.setGender(gender);
				if (password != null && !password.trim().isEmpty()) {
					user.setPasswordHash(password);
				}
				userService.update(user);
				
				String departmentId = request.getParameter("departmentId");
				String title = request.getParameter("title");
				String experienceYears = request.getParameter("experienceYears");
				String examinationFee = request.getParameter("examinationFee");
				String description = request.getParameter("description");
				Part avtFile = request.getPart("avtFile");
				
				doctor.setDepartment(departmentService.findById(Long.parseLong(departmentId)));
				doctor.setTitle(title);
				doctor.setExperienceYears(experienceYears != null && !experienceYears.isEmpty() ? Integer.parseInt(experienceYears) : 0);
				doctor.setExaminationFee(new BigDecimal(examinationFee));
				doctor.setDescription(description);
				
				if (avtFile != null && avtFile.getSize() > 0 && avtFile.getSubmittedFileName() != null && !avtFile.getSubmittedFileName().trim().isEmpty()) {
				    doctor.setAvtUrl(saveAvatarImage(avtFile));
				}
				
				boolean updatedDoc = doctorservice.update(doctor);
				if (updatedDoc) {
					request.getSession().setAttribute("message", "Cập nhật bác sĩ thành công!");
				} else {
					request.getSession().setAttribute("error", "Đã xảy ra lỗi khi cập nhật Bác sĩ.");
				}
			} else {
				request.getSession().setAttribute("error", "Không tìm thấy bác sĩ này.");
			}
			response.sendRedirect(request.getContextPath() + "/admin/doctor");
			return;
		}
		
		doGet(request, response);
	}

	private String saveAvatarImage(Part imagePart) throws IOException {
	    String originalFileName = imagePart.getSubmittedFileName();
	    originalFileName = java.nio.file.Paths.get(originalFileName).getFileName().toString();
	    int dotIndex = originalFileName.lastIndexOf(".");
	    if (dotIndex == -1) {
	        throw new IllegalArgumentException("File ảnh không có phần mở rộng");
	    }
	    String extension = originalFileName.substring(dotIndex).toLowerCase();
	    if (!extension.equals(".jpg") && !extension.equals(".jpeg") && !extension.equals(".png") && !extension.equals(".webp")) {
	        throw new IllegalArgumentException("Chỉ chấp nhận ảnh JPG, JPEG, PNG hoặc WEBP");
	    }
	    String newFileName = java.util.UUID.randomUUID() + extension;
	    String uploadPath = getServletContext().getRealPath("/assets/img/doctors");
	    if (uploadPath == null) {
	        throw new IOException("Không xác định được thư mục lưu ảnh");
	    }
	    java.nio.file.Path uploadDirectory = java.nio.file.Paths.get(uploadPath);
	    java.nio.file.Files.createDirectories(uploadDirectory);
	    java.nio.file.Path targetFile = uploadDirectory.resolve(newFileName);
	    try (java.io.InputStream inputStream = imagePart.getInputStream()) {
	        java.nio.file.Files.copy(inputStream, targetFile, java.nio.file.StandardCopyOption.REPLACE_EXISTING);
	    }
	    return "/assets/img/doctors/" + newFileName;
	}
}
