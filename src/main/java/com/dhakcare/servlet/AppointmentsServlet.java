package com.dhakcare.servlet;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.YearMonth;
import java.util.ArrayList;
import java.util.List;

import com.dhakcare.dto.CalendarDay;
import com.dhakcare.dto.MonthCalendar;
import com.dhakcare.entity.Appointment;
import com.dhakcare.entity.Department;
import com.dhakcare.entity.Doctor;
import com.dhakcare.entity.DoctorScheduleSlot;
import com.dhakcare.entity.Patient;
import com.dhakcare.entity.Payment;
import com.dhakcare.entity.User;
import com.dhakcare.enums.AppointmentStatus;
import com.dhakcare.enums.PaymentStatus;
import com.dhakcare.enums.TransactionStatus;
import com.dhakcare.service.AppointmentService;
import com.dhakcare.service.DepartmentService;
import com.dhakcare.service.DoctorScheduleSlotService;
import com.dhakcare.service.DoctorService;
import com.dhakcare.service.PatientService;
import com.dhakcare.service.PaymentService;
import com.dhakcare.service.impl.AppointmentServiceImpl;
import com.dhakcare.service.impl.DepartmentServiceImpl;
import com.dhakcare.service.impl.DoctorScheduleSlotServiceImpl;
import com.dhakcare.service.impl.DoctorServiceImpl;
import com.dhakcare.service.impl.PatientServiceImpl;
import com.dhakcare.service.impl.PaymentServiceImpl;
import com.dhakcare.utils.HolidayUtil;
import com.dhakcare.utils.VNPayConfig;
import com.dhakcare.utils.XAuth;
import com.dhakcare.utils.XParam;
import com.dhakcare.utils.XPath;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet implementation class PaymentServlet
 */
@WebServlet({
	"/appointment",
	"/appointment/create"
	
})
public class AppointmentsServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	private PatientService patientService = new PatientServiceImpl();
	private DepartmentService departmentService = new DepartmentServiceImpl();
	private DoctorService doctorservice = new DoctorServiceImpl();
//	private DoctorScheduleSlotService slotService = new DoctorScheduleSlotServiceImpl();
//	private AppointmentService appointmentService = new AppointmentServiceImpl();
//	private PaymentService paymentService = new PaymentServiceImpl();
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
		
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		response.setCharacterEncoding("UTF-8");
		
		HttpSession session = request.getSession();
	    User loggedInUser = (User) session.getAttribute("user");
	    
	    List<Department> listDepartments = departmentService.getAllDepartmentParent();
        List<Department> listChildren = departmentService.getAllDepartmentChild();
        List<Doctor> listDoctor = doctorservice.getAll();
        
        
	    
	    if (loggedInUser != null) {
	        
	        List<Patient> patientList = patientService.findPatientbyUserId(loggedInUser.getId());
	        
	        request.setAttribute("patientList", patientList);
	    }
	    
	 
	    List<MonthCalendar> fourMonthsList = new ArrayList<>();
	    this.getCanlender(fourMonthsList);
	    
	    request.setAttribute("listDepartmentsParent", listDepartments);
        request.setAttribute("listDepartmentsChild", listChildren);
        request.setAttribute("listDoctor", listDoctor);
	    request.setAttribute("fourMonthsList", fourMonthsList);
	    
	    request.getRequestDispatcher("/site/views/appointment.jsp").forward(request, response);
	}

	private void getCanlender(List<MonthCalendar> fourMonthsList) {
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
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		
//		
//		if (XPath.is("/appointment/create")) {
//		    
//		    try {
//		       
//		    	String doctorId = XParam.getString("doctorId");
//		    	String deptId = XParam.getString("departmentId");
//		    	String patientId = XParam.getString("patientId");
//		    	String slotId = XParam.getString("slotId");
//		    	String paymentMethod = XParam.getString("paymentMethod");
//		    	
//		    	User loggedInUser = XAuth.getUser();
//		        if (loggedInUser == null) {
//		            
//		            XPath.redirect("/auth/login");
//		            return;
//		        }
//		    	
//		    	Patient patient = patientService.getById(patientId);
//		    	Department dept = departmentService.getById(deptId);
//		    	Doctor doctor = doctorservice.getById(doctorId);
//		    	DoctorScheduleSlot slot = slotService.getById(slotId);
//
//		        BigDecimal finalPrice = doctor.getExaminationFee();
//
//		        
//		        Appointment appointment = new Appointment();
//		        appointment.setPatient(patient);
//		        appointment.setDoctor(doctor);
//		        appointment.setDepartment(dept);
//		        appointment.setSlot(slot);
//		        appointment.setBookedBy(loggedInUser);
//		        
//		        // Trạng thái mặc định khi vừa tạo
//		        appointment.setStatus(AppointmentStatus.PENDING);
//		        appointment.setPaymentStatus(PaymentStatus.UNPAID);
//		        appointment.setCreatedAt(LocalDateTime.now());
//
//		        appointmentService.insert(appointment);
//
//		        Long newAppointmentId = appointment.getId(); 
//
//		        // TẠO THANH TOÁN (PAYMENT)
//		        String txnRef = VNPayConfig.getRandomNumber(8);
//
//		        Payment payment = new Payment();
//		        
//		        payment.setAppointment(appointment); 
//		        payment.setAmount(finalPrice);
//		        payment.setMethod(paymentMethod); 
//		        payment.setStatus(TransactionStatus.PENDING); 
//		        payment.setTransactionCode(txnRef);
//
//		        paymentService.insert(payment);
//		         5. RẼ NHÁNH XỬ LÝ THEO PHƯƠNG THỨC THANH TOÁN
//		        if ("VNPAY".equals(paymentMethod)) {
//
//		        	String paymentUrl = VNPayConfig.vnp_PayUrl + "?" + queryUrl; // (Đoạn tạo link VNPAY của ông)
//		            
//		            String jsonResponse = "{\"status\":\"VNPAY\", \"redirectUrl\":\"" + paymentUrl + "\"}";
//		            response.getWriter().write(jsonResponse);
//		            
//		        } else {
//		            
//		            response.sendRedirect(request.getContextPath() + "/dat-lich-thanh-cong?id=" + newAppointmentId);
//		            
//		        }

//		    } catch (Exception e) {
//		        e.printStackTrace();
//		        
//		    }
//		}
		
	}

}
