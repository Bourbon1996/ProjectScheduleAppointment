package com.dhakcare.servlet;

import java.io.IOException;
import java.util.List;

import com.dhakcare.entity.User;
import com.dhakcare.service.PatientService;
import com.dhakcare.service.UserService;
import com.dhakcare.service.impl.PatientServiceImpl;
import com.dhakcare.service.impl.UserServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.dhakcare.enums.UserRole;
import com.dhakcare.enums.UserStatus;


/**
 * Servlet implementation class UserServlet
 */
@WebServlet({"/user/index","/user/create","/user/edit","/user/delete", "/user/delete/*"})
public class UserServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private PatientService patientservice = new PatientServiceImpl();
	private UserService userservice = new UserServiceImpl();
	
    /**
     * Default constructor. 
     */
    public UserServlet() {
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		String path = request.getServletPath();
		
		if(path.equals("/user/delete")) {
			String id = request.getParameter("id");
			patientservice.deleteByUserId(id);
			userservice.deleteById(id);
			response.sendRedirect(request.getContextPath() + "/admin/account");
		}
	}
		
	

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");

        String path = request.getServletPath();

        if (path.equals("/user/edit")) {
            updateUser(request, response);
        }
    }

	private void updateUser(
	        HttpServletRequest request,
	        HttpServletResponse response
	) throws IOException {

	    try {
	        Long id = Long.parseLong(request.getParameter("id"));

	        String fullName = request.getParameter("fullName");
	        String gender = request.getParameter("gender");
	        String email = request.getParameter("email");
	        String phone = request.getParameter("phone");
	        String password = request.getParameter("password");
	        String role = request.getParameter("role");
	        String status = request.getParameter("status");

	        // Tìm user cũ theo ID
	        User user = userservice.findById(id);

	        if (user == null) {
	            response.sendError(
	                HttpServletResponse.SC_NOT_FOUND,
	                "Không tìm thấy tài khoản có ID: " + id
	            );
	            return;
	        }

	        // Cập nhật thông tin mới
	        user.setFullName(fullName);
	        user.setGender(gender);
	        user.setEmail(email);
	        user.setPhone(phone);

	        // role và status trong User.java là enum
	        user.setRole(UserRole.valueOf(role));
	        user.setStatus(UserStatus.valueOf(status));

	        // Để trống mật khẩu thì giữ mật khẩu cũ
	        if (password != null && !password.isBlank()) {
	            user.setPasswordHash(password);
	        }

	        boolean updated = userservice.update(user);

	        if (!updated) {
	            response.sendError(
	                HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
	                "Cập nhật tài khoản thất bại"
	            );
	            return;
	        }

	        // Quay lại danh sách, dữ liệu mới sẽ được tải lại
	        response.sendRedirect(
	            request.getContextPath() + "/admin/account"
	        );

	    } catch (NumberFormatException e) {

	        response.sendError(
	            HttpServletResponse.SC_BAD_REQUEST,
	            "ID tài khoản không hợp lệ"
	        );

	    } catch (IllegalArgumentException e) {

	        response.sendError(
	            HttpServletResponse.SC_BAD_REQUEST,
	            "Vai trò hoặc trạng thái không hợp lệ"
	        );
	    }
	}
}