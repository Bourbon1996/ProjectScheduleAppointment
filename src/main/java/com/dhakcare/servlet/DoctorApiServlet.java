package com.dhakcare.servlet;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

import com.dhakcare.entity.Doctor;
import com.dhakcare.entity.DoctorScheduleSlot;
import com.dhakcare.service.DoctorScheduleSlotService;
import com.dhakcare.service.DoctorService;
import com.dhakcare.service.impl.DoctorScheduleSlotServiceImpl;
import com.dhakcare.service.impl.DoctorServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class DoctorApiServlet
 */
@WebServlet("/api/get-doctors")
public class DoctorApiServlet extends HttpServlet {
    private DoctorService doctorService = new DoctorServiceImpl();
    private DoctorScheduleSlotService slotService = new DoctorScheduleSlotServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String deptId = request.getParameter("deptId");
        String workdateStr = request.getParameter("workdate"); 
        
        LocalDate workdate = LocalDate.parse(workdateStr);
        
        List<Doctor> listDoctors = doctorService.getDoctorbyDeptId(deptId);
        
        for (Doctor doc : listDoctors) {
            
            List<DoctorScheduleSlot> slots = slotService.getByDoctorAndDate(String.valueOf(doc.getId()), workdate);
            doc.setSlots(slots);
        }
        
        
        request.setAttribute("listDoctors", listDoctors);
        
        
        String[] weekdays = {"Chủ Nhật", "Thứ 2", "Thứ 3", "Thứ 4", "Thứ 5", "Thứ 6", "Thứ 7"};
	    
	    int dow = workdate.getDayOfWeek().getValue() % 7; 
	
	    String formattedDateStr = String.format("%02d/%02d/%04d (%s)", 
	             workdate.getDayOfMonth(), 
	             workdate.getMonthValue(), 
	             workdate.getYear(), 
	             weekdays[dow]);
	
	    request.setAttribute("selectedDateStr", formattedDateStr);
        
        request.getRequestDispatcher("/site/layouts/ajax-doctor-list.jsp").forward(request, response);
    }
}
