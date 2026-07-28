package com.dhakcare.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

import com.dhakcare.entity.User;
import com.dhakcare.service.UserService;
import com.dhakcare.service.impl.UserServiceImpl;

/**
 * Servlet implementation class AdminServlet
 */
@WebServlet("/admin/*")
public class AdminServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private UserService userservice = new UserServiceImpl();
	
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AdminServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String uri = request.getRequestURI();
		
		
		if(uri.contains("/admin/doctor")) {
			request.getRequestDispatcher("/views/admin/doctor-manager.jsp").forward(request, response);
		}if(uri.contains("/admin/department")) {
			request.getRequestDispatcher("/views/admin/department-manager.jsp").forward(request, response);
		}if(uri.contains("/admin/account")) {
			List<User> listUser = userservice.findAll();
			request.setAttribute("listAccount", listUser);
			request.getRequestDispatcher("/views/admin/account-manager.jsp").forward(request, response);
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
