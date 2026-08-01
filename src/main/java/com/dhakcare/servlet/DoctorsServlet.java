package com.dhakcare.servlet;

import java.io.IOException;
import java.util.List;

import com.dhakcare.entity.Doctor;
import com.dhakcare.entity.DoctorScheduleSlot;
import com.dhakcare.service.AppointmentService;
import com.dhakcare.service.DoctorScheduleSlotService;
import com.dhakcare.service.DoctorService;
import com.dhakcare.service.impl.AppointmentServiceImpl;
import com.dhakcare.service.impl.DoctorScheduleSlotServiceImpl;
import com.dhakcare.service.impl.DoctorServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class PaymentServlet
 */
@WebServlet({"/doctor", "/doctor/detail/*","/doctor/delete/*"})
public class DoctorsServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private DoctorService doctorservice = new DoctorServiceImpl();
	private DoctorScheduleSlotService slotService = new DoctorScheduleSlotServiceImpl();
	private AppointmentService appointmentService = new AppointmentServiceImpl();

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

	                Doctor doctor = doctorservice.getById(idStr);

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
	    	
	    	appointmentService.deleteByDoctorId(id);
	    	slotService.deleteByDoctorId(id);
	    	doctorservice.deleteById(id);
	    	
	    	response.sendRedirect(request.getContextPath()+"/admin/doctor");
	    	return;
	    }
	   
	    request.getRequestDispatcher("/admin/views/doctor-manager.jsp").forward(request, response);
	   
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
