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
			
			//1
			Long id = Long.parseLong(request.getParameter("id"));
			
			//2
			User user = userservice.findById(id);
			if (user == null) {
				response.sendRedirect(request.getContextPath() + "/admin/accont");
				return;
			}
			
			//3
			String fullName = request.getParameter("fullName");
			String gender = request.getParameter("gender");
			String email = request.getParameter("email");
			String phone = request.getParameter("phone");
	        String password = request.getParameter("password");
	        String role = request.getParameter("role");
	        String status = request.getParameter("status");
	        
	        //4
	        user.setFullName(fullName);
	        user.setGender(gender);
	        user.setEmail(email);
	        user.setPhone(phone);
	        
	        //5
	        userservice.update(user);
	        
	        //6
	        response.sendRedirect(request.getContextPath() + "/admin/account");
			
	        
	        
		}				
	}
}