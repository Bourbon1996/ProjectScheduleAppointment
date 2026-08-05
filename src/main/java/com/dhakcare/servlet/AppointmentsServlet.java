package com.dhakcare.servlet;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.YearMonth;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.dhakcare.dto.CalendarDay;
import com.dhakcare.dto.MonthCalendar;
import com.dhakcare.entity.Appointment;
import com.dhakcare.entity.Department;
import com.dhakcare.entity.Doctor;
import com.dhakcare.entity.Patient;
import com.dhakcare.entity.User;
import com.dhakcare.service.AppointmentService;
import com.dhakcare.service.DepartmentService;
import com.dhakcare.service.DoctorService;
import com.dhakcare.service.PatientService;
import com.dhakcare.service.PaymentService;
import com.dhakcare.service.impl.AppointmentServiceImpl;
import com.dhakcare.service.impl.DepartmentServiceImpl;
import com.dhakcare.service.impl.DoctorServiceImpl;
import com.dhakcare.service.impl.PatientServiceImpl;
import com.dhakcare.service.impl.PaymentServiceImpl;
import com.dhakcare.utils.HolidayUtil;
import com.dhakcare.utils.VNPayConfig;
import com.dhakcare.utils.VNPayUtil;
import com.dhakcare.utils.XAuth;
import com.dhakcare.utils.XParam;
import com.dhakcare.utils.XPath;
import com.fasterxml.jackson.databind.ObjectMapper;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
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
	"/appointment/create",
	"/appointment/history",
	"/appointment/cancel",
	"/appointment/complete"
})
@MultipartConfig
public class AppointmentsServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	private PatientService patientService = new PatientServiceImpl();
	private DepartmentService departmentService = new DepartmentServiceImpl();
	private DoctorService doctorservice = new DoctorServiceImpl();
	private AppointmentService appointmentService = new AppointmentServiceImpl();
	private PaymentService paymentService = new PaymentServiceImpl();
	private final ObjectMapper objectMapper = new ObjectMapper();
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
		
	    User loggedInUser = XAuth.getUser();
	    
	    if (XPath.is("/appointment/history")) {
            if (loggedInUser == null) {
                response.sendRedirect(request.getContextPath() + "/auth/login");
                return;
            }

            List<Appointment> historyList = appointmentService.getAppointmentsByUser(loggedInUser);
            
            request.setAttribute("historyList", historyList);
            request.getRequestDispatcher("/site/views/appointment-history.jsp").forward(request, response);
            return;
        }
	    
	    String status = request.getParameter("status");
	    if ("success".equals(status)) {
	        String code = request.getParameter("code");
	        request.setAttribute("isPaymentSuccess", true);
	        request.setAttribute("txnCode", code);
	    }
	    
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
	    request.setCharacterEncoding("UTF-8");
	    response.setContentType("application/json");
	    response.setCharacterEncoding("UTF-8");

	    if (XPath.is("/appointment/create")) {
	        try {
	            
	            Long doctorId = XParam.getLong("doctorId");
	            Long deptId = XParam.getLong("departmentId");
	            Long patientId = XParam.getLong("patientId");
	            Long slotId = XParam.getLong("slotId");
	            String paymentMethod = XParam.getString("paymentMethod") ;

	           
	            User loggedInUser = XAuth.getUser();
	            if (loggedInUser == null) {
	                Map<String, Object> errMap = new HashMap<>();
	                errMap.put("status", "ERROR");
	                errMap.put("message", "Vui lòng đăng nhập lại!");
	                response.getWriter().write(objectMapper.writeValueAsString(errMap));
	                return;
	            }

	            
	            Doctor doctor = doctorservice.getById(doctorId);
	            BigDecimal finalPrice = doctor.getExaminationFee();

	           
	            Appointment appointment = appointmentService.createAppointment(patientId, deptId, doctorId, slotId, loggedInUser);
	            Long newAppointmentId = appointment.getId();

	           
	            String txnRef = VNPayConfig.getRandomNumber(8);
	            paymentService.createPayment(appointment, finalPrice, paymentMethod, txnRef);

	            
	            Map<String, Object> jsonMap = new HashMap<>();
	            if ("VNPAY".equals(paymentMethod)) {
	               
	                double amountDouble = finalPrice.doubleValue();
	                String paymentUrl = VNPayUtil.createPaymentUrl(amountDouble, txnRef, request);

	                jsonMap.put("status", "VNPAY");
	                jsonMap.put("redirectUrl", paymentUrl);
	            } else {
	                jsonMap.put("status", "SUCCESS");
	                jsonMap.put("appointmentId", newAppointmentId);
	                
	                // Send Email and WebSocket Notification since no VNPAY callback will happen
	                com.dhakcare.utils.XMail.sendBookingSuccess(appointment);
	                if (appointment.getDoctor() != null) {
	                	com.dhakcare.websocket.NotificationWebSocket.sendNotification(
	                			appointment.getDoctor().getId(), 
	                			"{\"type\": \"NEW_APPOINTMENT\", \"message\": \"Bạn có một lịch hẹn mới!\"}");
	                }
	            }
	            response.getWriter().write(objectMapper.writeValueAsString(jsonMap));

	        } catch (Exception e) {
	            e.printStackTrace();
	            Map<String, Object> errMap = new HashMap<>();
	            errMap.put("status", "ERROR");
	            errMap.put("message", "Đã xảy ra lỗi khi đặt lịch. Vui lòng thử lại.");
	            response.getWriter().write(objectMapper.writeValueAsString(errMap));
	        }
	    } else if (XPath.is("/appointment/cancel")) {
	        try {
	            Long id = XParam.getLong("id");
	            boolean success = appointmentService.cancelAppointment(id);
	            Map<String, Object> res = new HashMap<>();
	            if (success) {
	                res.put("status", "SUCCESS");
	                res.put("message", "Đã hủy lịch thành công.");
	            } else {
	                res.put("status", "ERROR");
	                res.put("message", "Hủy lịch thất bại.");
	            }
	            response.getWriter().write(objectMapper.writeValueAsString(res));
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    } else if (XPath.is("/appointment/complete")) {
	        try {
	            Long id = XParam.getLong("id");
	            boolean success = appointmentService.completeAppointment(id);
	            Map<String, Object> res = new HashMap<>();
	            if (success) {
	                res.put("status", "SUCCESS");
	                res.put("message", "Đã cập nhật trạng thái hoàn thành.");
	            } else {
	                res.put("status", "ERROR");
	                res.put("message", "Cập nhật thất bại.");
	            }
	            response.getWriter().write(objectMapper.writeValueAsString(res));
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    }
	}

}
