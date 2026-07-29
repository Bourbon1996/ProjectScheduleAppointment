package com.dhakcare.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

import com.dhakcare.entity.User;
import com.dhakcare.service.PatientService;
import com.dhakcare.service.UserService;
import com.dhakcare.service.impl.PatientServiceImpl;
import com.dhakcare.service.impl.UserServiceImpl;

/**
 * Servlet implementation class AdminServlet
 */
@WebServlet({"/admin/dashboard", "/admin/doctor", "/admin/account", "/admin/account/*", "/admin/department"})
public class AdminServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private UserService userservice = new UserServiceImpl();
	private PatientService patientservice = new PatientServiceImpl();
	
       
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
		String path = request.getServletPath();
		
		
		if(path.contains("/doctor")) {
			request.getRequestDispatcher("/admin/views/doctor-manager.jsp").forward(request, response);
		}if(path.contains("/department")) {
			request.getRequestDispatcher("/admin/views/department-manager.jsp").forward(request, response);
		}if(path.contains("/account")) {
			List<User> listUser = userservice.findAll();
			request.setAttribute("listAccount", listUser);
			request.getRequestDispatcher("/admin/views/account-manager.jsp").forward(request, response);
		}if(path.contains("/dashboard")) {
			request.getRequestDispatcher("/admin/views/dashboard.jsp").forward(request, response);
		}if(path.contains("/account/delete")) {
			String id = request.getParameter("id");
			patientservice.deleteByUserId(id);
			System.out.println("Id: "+id);
			userservice.deleteById(id);
			request.getRequestDispatcher("/admin/views/account-manager.jsp").forward(request, response);


	
			
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
	}

}
