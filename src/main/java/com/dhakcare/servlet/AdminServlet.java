package com.dhakcare.servlet;

import java.io.IOException;
import java.util.List;

import com.dhakcare.entity.Department;
import com.dhakcare.entity.Doctor;
import com.dhakcare.entity.User;
import com.dhakcare.service.DepartmentService;
import com.dhakcare.service.DoctorService;
import com.dhakcare.service.PatientService;
import com.dhakcare.service.UserService;
import com.dhakcare.service.impl.DepartmentServiceImpl;
import com.dhakcare.service.impl.DoctorServiceImpl;
import com.dhakcare.service.impl.PatientServiceImpl;
import com.dhakcare.service.impl.UserServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class AdminServlet
 */
@WebServlet({"/admin/dashboard", "/admin/doctor", "/admin/user", "/admin/department"})
public class AdminServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private UserService userService = new UserServiceImpl();
	private PatientService patientService = new PatientServiceImpl();
	
	private DoctorService doctorService = new DoctorServiceImpl();
	private DepartmentService departmentService = new DepartmentServiceImpl();
	
       
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
			List<Doctor> listDoctor = doctorService.getAll();
			request.setAttribute("listDoctor", listDoctor);
			request.getRequestDispatcher("/admin/views/doctor-manager.jsp").forward(request, response);
		}else if(path.contains("/department")) {
			List<Department> listChildren = departmentService.getAllDepartmentChild();
			List<Department> listParent = departmentService.getAllDepartmentParent();
			
			request.setAttribute("listDepartmentsParent", listParent);
			request.setAttribute("listDepartmentsChild", listChildren);
			request.getRequestDispatcher("/admin/views/department-manager.jsp").forward(request, response);
		}else if(path.contains("/user")) {
			List<User> listUser = userService.findAll();
			request.setAttribute("listAccount", listUser);
			request.getRequestDispatcher("/admin/views/user-manager.jsp").forward(request, response);
		}else if(path.contains("/dashboard")) {
			request.setAttribute("totalUser", userService.getTotalUser());
			request.setAttribute("totalDoctor", doctorService.getTotalDoctor());
			request.setAttribute("totalPatient", patientService.getTotalPatient());
			request.setAttribute("totalDepartment", departmentService.getTotalDepartment());
			request.getRequestDispatcher("/admin/views/dashboard.jsp").forward(request, response);
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
	}

}
