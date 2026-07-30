package com.dhakcare.servlet;

import java.io.IOException;
import java.util.List;

import com.dhakcare.entity.Department;
import com.dhakcare.entity.Doctor;
import com.dhakcare.service.DepartmentService;
import com.dhakcare.service.DoctorService;
import com.dhakcare.service.impl.DepartmentServiceImpl;
import com.dhakcare.service.impl.DoctorServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class HomeServlet
 */
@WebServlet({"/home/index", "/home/about", "/home/contact", "/home/departments", "/home/doctor"})
public class HomeServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	private DepartmentService departmentService = new DepartmentServiceImpl();
	private DoctorService doctorservice = new DoctorServiceImpl();
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public HomeServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		String path = request.getServletPath();
        
        List<Department> listDepartments = departmentService.getAllDepartmentParent();
        List<Department> listChildren = departmentService.getAllDepartmentChild();
        
        

        // Tạo biến list chuyên khoa
        request.setAttribute("listDepartmentsParent", listDepartments);
        request.setAttribute("listDepartmentsChild", listChildren);
        
        if(path.equals("/home/doctor")) {
        	
        	List<Doctor> listDoctor = doctorservice.getAll();
        	// Tạo biến list bác sĩ
            request.setAttribute("listDoctor", listDoctor);
            
        	 request.getRequestDispatcher("/site/views/doctor.jsp").forward(request, response);
        	 return;
        }
        
        
		request.getRequestDispatcher("/site/views/index.jsp").forward(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
