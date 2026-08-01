package com.dhakcare.servlet;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

import com.dhakcare.entity.User;
import com.dhakcare.service.PatientService;
import com.dhakcare.service.UserService;
import com.dhakcare.service.impl.PatientServiceImpl;
import com.dhakcare.service.impl.UserServiceImpl;

import jakarta.persistence.EnumType;
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
@WebServlet({"/user/index","/user/create","/user/edit/*","/user/delete"})
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
			response.sendRedirect(request.getContextPath() + "/admin/user");
		}
	}
		
	

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		String path = request.getServletPath();
		if (path.equals("/user/edit")) {
			
			//1. Lấy id từ From
			Long id = Long.parseLong(request.getParameter("id"));
			
			//2. Tìm user cũ trong database
			User user = userservice.findById(id);
			if (user == null) {
				response.sendRedirect(request.getContextPath() + "/admin/accont");
				return;
			}
			
			//3. Lấy dữ liệu mới từ From
			String fullName = request.getParameter("fullName");
			String gender = request.getParameter("gender");
			String email = request.getParameter("email");
			String phone = request.getParameter("phone");
	        String password = request.getParameter("password");
	        String role = request.getParameter("role");
	        String status = request.getParameter("status");
	        
	        //4. Gán dữ liệu mới vào user cũ
	        user.setFullName(fullName);
	        user.setGender(gender);
	        user.setEmail(email);
	        user.setPhone(phone);
	        user.setPasswordHash(password);
	        user.setRole(UserRole.valueOf(role));
	        user.setStatus(UserStatus.valueOf(status));
	        
	        //5. Cập nhật database
	        userservice.update(user);
	        
	        //6.Quay lại trang
	        response.sendRedirect(request.getContextPath() + "/admin/user");
	        
		} else if (path.equals("/user/create")) {
			
			User user = new User();
			
			//3. Lấy dữ liệu mới từ From
			String fullName = request.getParameter("fullName");
			String gender = request.getParameter("gender");
			String email = request.getParameter("email");
			String phone = request.getParameter("phone");
	        String password = request.getParameter("password");
	        String role = request.getParameter("role");
	        String status = request.getParameter("status");
	        
	        
	        //4. Gán dữ liệu mới vào user cũ
	        user.setFullName(fullName);
	        user.setGender(gender);
	        user.setEmail(email);
	        user.setPhone(phone);
	        user.setPasswordHash(password);
	        user.setRole(UserRole.valueOf(role));
	        user.setStatus(UserStatus.valueOf(status));
	        user.setCreatedAt(LocalDateTime.now());
	        
	        //5. Cập nhật database
	        userservice.create(user);
	        
	        //6.Quay lại trang
	        response.sendRedirect(request.getContextPath() + "/admin/user");
	        
		}				
	}
}