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
@WebServlet({"/admin/dashboard", "/admin/doctor", "/admin/user", "/admin/department", "/admin/appointment", "/admin/patient", "/admin/patients/history", "/admin/revenue", "/admin/schedules", "/admin/schedules/auto-generate", "/admin/schedules/approve"})
public class AdminServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private UserService userService = new UserServiceImpl();
	private PatientService patientService = new PatientServiceImpl();
	
	private DoctorService doctorService = new DoctorServiceImpl();
	private DepartmentService departmentService = new DepartmentServiceImpl();
	private com.dhakcare.service.AppointmentService appointmentService = new com.dhakcare.service.impl.AppointmentServiceImpl();
	private com.dhakcare.service.PaymentService paymentService = new com.dhakcare.service.impl.PaymentServiceImpl();
	
       
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
			
			// KPI Calculation
			java.time.LocalDate now = java.time.LocalDate.now();
			int currentMonth = now.getMonthValue();
			int currentYear = now.getYear();
			
			com.dhakcare.service.DoctorScheduleSlotService slotService = new com.dhakcare.service.impl.DoctorScheduleSlotServiceImpl();
			List<com.dhakcare.entity.DoctorScheduleSlot> allSlots = slotService.getAllSlots();
			
			com.dhakcare.service.AppointmentService aptService = new com.dhakcare.service.impl.AppointmentServiceImpl();
			List<com.dhakcare.entity.Appointment> allApts = aptService.findAll();
			
			java.util.Map<Long, java.util.Map<String, Integer>> kpiMap = new java.util.HashMap<>();
			for (Doctor d : listDoctor) {
				int workedHours = 0;
				java.util.Set<java.time.LocalDate> workedDaysSet = new java.util.HashSet<>();
				for (com.dhakcare.entity.DoctorScheduleSlot s : allSlots) {
					if (s.getDoctor().getId().equals(d.getId()) && s.getWorkDate().getMonthValue() == currentMonth && s.getWorkDate().getYear() == currentYear && s.getStatus() != com.dhakcare.enums.SlotStatus.PENDING_DELETE) {
						workedDaysSet.add(s.getWorkDate());
						workedHours += java.time.temporal.ChronoUnit.HOURS.between(s.getStartTime(), s.getEndTime());
					}
				}
				
				int completedPatients = 0;
				for (com.dhakcare.entity.Appointment a : allApts) {
					if (a.getDoctor().getId().equals(d.getId()) && a.getStatus() == com.dhakcare.enums.AppointmentStatus.COMPLETED) {
						if (a.getSlot() != null && a.getSlot().getWorkDate().getMonthValue() == currentMonth && a.getSlot().getWorkDate().getYear() == currentYear) {
							completedPatients++;
						}
					}
				}
				
				java.util.Map<String, Integer> stats = new java.util.HashMap<>();
				stats.put("workedDays", workedDaysSet.size());
				stats.put("workedHours", workedHours);
				stats.put("completedPatients", completedPatients);
				kpiMap.put(d.getId(), stats);
			}
			request.setAttribute("kpiMap", kpiMap);
			
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
		}else if(path.contains("/appointment")) {
			List<com.dhakcare.entity.Appointment> listApt = appointmentService.findAll();
			String search = request.getParameter("search");
			String status = request.getParameter("status");
			
			if (search != null && !search.isBlank()) {
			    String s = search.toLowerCase();
			    listApt.removeIf(a -> !((a.getId() + "").contains(s) || a.getPatient().getFullName().toLowerCase().contains(s) || a.getPatient().getPhone().contains(s)));
			}
			if (status != null && !status.isBlank()) {
			    listApt.removeIf(a -> !a.getStatus().name().equals(status));
			}
			
			request.setAttribute("listAppointments", listApt);
			request.getRequestDispatcher("/admin/views/appointment-manager.jsp").forward(request, response);
		}else if(path.contains("/patient")) {
			if (path.contains("/patients/history")) {
				String id = request.getParameter("id");
				if (id != null) {
					try {
						List<com.dhakcare.entity.Appointment> history = appointmentService.getAppointmentsByPatient(Long.parseLong(id));
						request.setAttribute("history", history);
						request.getRequestDispatcher("/admin/views/patient-timeline.jsp").forward(request, response);
						return;
					} catch(Exception e) {}
				}
			}
			
			List<com.dhakcare.entity.Patient> listPatient = patientService.findAll();
			String search = request.getParameter("search");
			
			if (search != null && !search.isBlank()) {
			    String s = search.toLowerCase();
			    listPatient.removeIf(p -> {
					boolean matchName = p.getFullName() != null && p.getFullName().toLowerCase().contains(s);
					boolean matchPhone = p.getPhone() != null && p.getPhone().contains(s);
					return !(matchName || matchPhone);
				});
			}
			
			request.setAttribute("listPatients", listPatient);
			request.getRequestDispatcher("/admin/views/patient-manager.jsp").forward(request, response);
		}else if(path.contains("/revenue")) {
			List<com.dhakcare.entity.Payment> listPayment = paymentService.findAll();
			String filterDate = request.getParameter("filterDate");
			
			if (filterDate != null && !filterDate.isBlank()) {
				listPayment.removeIf(p -> p.getPaidAt() != null && !p.getPaidAt().toString().contains(filterDate));
			}
			
			listPayment.sort((p1, p2) -> {
				if(p1.getPaidAt() != null && p2.getPaidAt() != null) return p2.getPaidAt().compareTo(p1.getPaidAt());
				return 0;
			});
			
			request.setAttribute("listPayment", listPayment);
			request.getRequestDispatcher("/admin/views/revenue-manager.jsp").forward(request, response);
		}else if(path.contains("/schedules")) {
			com.dhakcare.service.DoctorScheduleSlotService slotService = new com.dhakcare.service.impl.DoctorScheduleSlotServiceImpl();
			List<com.dhakcare.entity.DoctorScheduleSlot> allSlots = slotService.getAllSlots();
			List<com.dhakcare.entity.DoctorScheduleSlot> pendingSlots = new java.util.ArrayList<>();
			for (com.dhakcare.entity.DoctorScheduleSlot s : allSlots) {
				if (s.getStatus() == com.dhakcare.enums.SlotStatus.PENDING_DELETE) {
					pendingSlots.add(s);
				}
			}
			request.setAttribute("pendingSlots", pendingSlots);
			request.setAttribute("allSlots", allSlots);
			request.getRequestDispatcher("/admin/views/schedule-manager.jsp").forward(request, response);
		}else if(path.contains("/dashboard")) {
			request.setAttribute("totalUser", userService.getTotalUser());
			request.setAttribute("totalDoctor", doctorService.getTotalDoctor());
			request.setAttribute("totalPatient", patientService.getTotalPatient());
			request.setAttribute("totalDepartment", departmentService.getTotalDepartment());
			
			String filterTime = request.getParameter("filterTime");
			java.time.LocalDate now = java.time.LocalDate.now();
			
			List<com.dhakcare.entity.Payment> payments = paymentService.findAll();
			java.math.BigDecimal filteredRevenue = java.math.BigDecimal.ZERO;
			for (com.dhakcare.entity.Payment p : payments) {
				if (p.getStatus() == com.dhakcare.enums.TransactionStatus.SUCCESS && p.getPaidAt() != null) {
					boolean include = true;
					if ("today".equals(filterTime)) {
						include = p.getPaidAt().toLocalDate().equals(now);
					} else if ("month".equals(filterTime)) {
						include = p.getPaidAt().getYear() == now.getYear() && p.getPaidAt().getMonthValue() == now.getMonthValue();
					} else if ("year".equals(filterTime)) {
						include = p.getPaidAt().getYear() == now.getYear();
					}
					if (include) {
						filteredRevenue = filteredRevenue.add(p.getAmount());
					}
				}
			}
			
			List<com.dhakcare.entity.Appointment> appointments = appointmentService.findAll();
			long filteredAppointments = 0;
			for (com.dhakcare.entity.Appointment a : appointments) {
				if (a.getCreatedAt() != null) {
					boolean include = true;
					if ("today".equals(filterTime)) {
						include = a.getCreatedAt().toLocalDate().equals(now);
					} else if ("month".equals(filterTime)) {
						include = a.getCreatedAt().getYear() == now.getYear() && a.getCreatedAt().getMonthValue() == now.getMonthValue();
					} else if ("year".equals(filterTime)) {
						include = a.getCreatedAt().getYear() == now.getYear();
					}
					if (include) {
						filteredAppointments++;
					}
				}
			}
			
			request.setAttribute("filteredRevenue", filteredRevenue);
			request.setAttribute("filteredAppointments", filteredAppointments);
			request.setAttribute("filterTime", filterTime == null ? "all" : filterTime);
			
			// Analytics data
			int currentYear = java.time.LocalDate.now().getYear();
			java.util.List<java.math.BigDecimal> monthlyRevenue = paymentService.getMonthlyRevenue(currentYear);
			request.setAttribute("monthlyRevenue", monthlyRevenue);
			request.setAttribute("currentYear", currentYear);
			
			java.util.List<Long> monthlyAppointments = new java.util.ArrayList<>();
			for (int i=0; i<12; i++) monthlyAppointments.add(0L);
			for (com.dhakcare.entity.Appointment a : appointments) {
				if (a.getCreatedAt() != null && a.getCreatedAt().getYear() == currentYear) {
					int m = a.getCreatedAt().getMonthValue();
					monthlyAppointments.set(m-1, monthlyAppointments.get(m-1) + 1);
				}
			}
			request.setAttribute("monthlyAppointments", monthlyAppointments);
			
			java.util.List<Object[]> topDepartments = appointmentService.getTopDepartments(5);
			request.setAttribute("topDepartments", topDepartments);
			
			java.util.List<Object[]> topDoctors = appointmentService.getTopDoctors(5);
			request.setAttribute("topDoctors", topDoctors);
			
			List<com.dhakcare.entity.Appointment> allAppointments = appointmentService.findAll();
			if (allAppointments.size() > 5) {
			    allAppointments = allAppointments.subList(0, 5);
			}
			request.setAttribute("latestAppointments", allAppointments);
			
			request.getRequestDispatcher("/admin/views/dashboard.jsp").forward(request, response);
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String path = request.getServletPath();
		if (path.contains("/schedules/approve")) {
			String id = request.getParameter("id");
			String action = request.getParameter("action");
			com.dhakcare.service.DoctorScheduleSlotService slotService = new com.dhakcare.service.impl.DoctorScheduleSlotServiceImpl();
			com.dhakcare.entity.DoctorScheduleSlot slot = slotService.getById(id);
			if (slot != null && slot.getStatus() == com.dhakcare.enums.SlotStatus.PENDING_DELETE) {
				if ("APPROVE".equals(action)) {
					if (slot.getBookedCount() > 0) {
						slot.setStatus(com.dhakcare.enums.SlotStatus.CLOSED);
						slotService.updateSlot(slot);
					} else {
						slotService.deleteSlot(id);
					}
				} else if ("REJECT".equals(action)) {
					if (slot.getBookedCount() >= slot.getMaxPatients()) {
						slot.setStatus(com.dhakcare.enums.SlotStatus.FULL);
					} else {
						slot.setStatus(com.dhakcare.enums.SlotStatus.AVAILABLE);
					}
					slotService.updateSlot(slot);
				}
			}
			response.sendRedirect(request.getContextPath() + "/admin/schedules");
		} else if (path.contains("/schedules/auto-generate")) {
			try {
				String monthStr = request.getParameter("month");
				String morningStartStr = request.getParameter("morningStart");
				String morningEndStr = request.getParameter("morningEnd");
				String afternoonStartStr = request.getParameter("afternoonStart");
				String afternoonEndStr = request.getParameter("afternoonEnd");
				int maxPatients = Integer.parseInt(request.getParameter("maxPatients"));
				
				if (monthStr != null && !monthStr.isEmpty()) {
					java.time.YearMonth yearMonth = java.time.YearMonth.parse(monthStr);
					java.time.LocalTime mStart = java.time.LocalTime.parse(morningStartStr);
					java.time.LocalTime mEnd = java.time.LocalTime.parse(morningEndStr);
					java.time.LocalTime aStart = java.time.LocalTime.parse(afternoonStartStr);
					java.time.LocalTime aEnd = java.time.LocalTime.parse(afternoonEndStr);
					
					List<com.dhakcare.entity.Doctor> doctors = doctorService.getAll();
					com.dhakcare.service.DoctorScheduleSlotService slotService = new com.dhakcare.service.impl.DoctorScheduleSlotServiceImpl();
					
					for (int day = 1; day <= yearMonth.lengthOfMonth(); day++) {
						java.time.LocalDate date = yearMonth.atDay(day);
						if (date.getDayOfWeek() != java.time.DayOfWeek.SUNDAY) {
							for (com.dhakcare.entity.Doctor doc : doctors) {
								com.dhakcare.entity.DoctorScheduleSlot mSlot = new com.dhakcare.entity.DoctorScheduleSlot();
								mSlot.setDoctor(doc);
								mSlot.setWorkDate(date);
								mSlot.setStartTime(mStart);
								mSlot.setEndTime(mEnd);
								mSlot.setMaxPatients(maxPatients);
								mSlot.setBookedCount(0);
								mSlot.setStatus(com.dhakcare.enums.SlotStatus.AVAILABLE);
								slotService.createSlot(mSlot);
								
								com.dhakcare.entity.DoctorScheduleSlot aSlot = new com.dhakcare.entity.DoctorScheduleSlot();
								aSlot.setDoctor(doc);
								aSlot.setWorkDate(date);
								aSlot.setStartTime(aStart);
								aSlot.setEndTime(aEnd);
								aSlot.setMaxPatients(maxPatients);
								aSlot.setBookedCount(0);
								aSlot.setStatus(com.dhakcare.enums.SlotStatus.AVAILABLE);
								slotService.createSlot(aSlot);
							}
						}
					}
					request.getSession().setAttribute("message", "Đã xếp lịch tự động thành công cho tháng " + monthStr);
				}
			} catch(Exception e) {
				request.getSession().setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
			}
			response.sendRedirect(request.getContextPath() + "/admin/schedules");
		}
	}

}
