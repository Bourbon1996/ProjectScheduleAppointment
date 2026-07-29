package com.dhakcare.servlet;

import java.io.IOException;
import java.time.LocalDate;
import java.time.YearMonth;
import java.util.ArrayList;
import java.util.List;

import com.dhakcare.dto.CalendarDay;
import com.dhakcare.dto.MonthCalendar;
import com.dhakcare.entity.Patient;
import com.dhakcare.entity.User;
import com.dhakcare.service.PatientService;
import com.dhakcare.service.impl.PatientServiceImpl;
import com.dhakcare.utils.HolidayUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet implementation class PaymentServlet
 */
@WebServlet({"/appointment"})
public class AppointmentsServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	private PatientService patientService = new PatientServiceImpl();
    /**
     * Default constructor. 
     */
    public AppointmentsServlet() {
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession();
	    User loggedInUser = (User) session.getAttribute("user");
	    
	    if (loggedInUser != null) {
	        
	        List<Patient> patientList = patientService.findPatientbyUserId(loggedInUser.getId());
	        
	        request.setAttribute("patientList", patientList);
	    }
	    
	    
	    
	    //TỰ ĐỘNG SINH RA 4 THÁNG LỊCH
	    List<MonthCalendar> fourMonthsList = new ArrayList<>();
	    YearMonth currentYM = YearMonth.now();
	    String[] weekdays = {"Chủ Nhật", "Thứ 2", "Thứ 3", "Thứ 4", "Thứ 5", "Thứ 6", "Thứ 7"};

	    for (int i = 0; i <= 3; i++) {
	        YearMonth targetYM = currentYM.plusMonths(i);
	        List<CalendarDay> calendarGrid = new ArrayList<>();
	        
	        LocalDate firstDay = targetYM.atDay(1);
	        int daysInMonth = targetYM.lengthOfMonth();
	        int offset = firstDay.getDayOfWeek().getValue() % 7; // Thụt đầu dòng cho ngày mùng 1

	       
	        for (int j = 0; j < offset; j++) {
	            calendarGrid.add(new CalendarDay(0, "", "", false, false, false, false));
	        }

	        
	        for (int day = 1; day <= daysInMonth; day++) {
	            LocalDate dateObj = targetYM.atDay(day);
	            String dateStr = dateObj.toString();
	            
	            boolean isPast = dateObj.isBefore(LocalDate.now());
	            boolean isToday = dateObj.isEqual(LocalDate.now());

	            boolean isSunday = (dateObj.getDayOfWeek().getValue() == 7);

	            boolean isHoliday = HolidayUtil.isHoliday(dateObj);

	            boolean isAvailable = !isPast && !isSunday && !isHoliday;

	            int dow = dateObj.getDayOfWeek().getValue() % 7;
	            String displayStr = String.format("%02d/%02d/%04d (%s)", day, targetYM.getMonthValue(), targetYM.getYear(), weekdays[dow]);

	            calendarGrid.add(new CalendarDay(day, dateStr, displayStr, isAvailable, isToday, isSunday, isHoliday));
	        }

	        String label = "Tháng " + targetYM.getMonthValue() + " năm " + targetYM.getYear();
	        fourMonthsList.add(new MonthCalendar(label, i, calendarGrid));
	    }

	    
	    request.setAttribute("fourMonthsList", fourMonthsList);
	    
	    request.getRequestDispatcher("/site/views/appointment.jsp").forward(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
