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
@WebServlet({"/admin/dashboard", "/admin/doctor", "/admin/user", "/admin/department", "/admin/appointment", "/admin/patient"})
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
			List<com.dhakcare.entity.Patient> listPatient = patientService.findAll();
			String search = request.getParameter("search");
			
			if (search != null && !search.isBlank()) {
			    String s = search.toLowerCase();
			    listPatient.removeIf(p -> !(p.getFullName().toLowerCase().contains(s) || p.getPhone().contains(s)));
			}
			
			request.setAttribute("listPatients", listPatient);
			request.getRequestDispatcher("/admin/views/patient-manager.jsp").forward(request, response);
		}else if(path.contains("/dashboard")) {
			request.setAttribute("totalUser", userService.getTotalUser());
			request.setAttribute("totalDoctor", doctorService.getTotalDoctor());
			request.setAttribute("totalPatient", patientService.getTotalPatient());
			request.setAttribute("totalDepartment", departmentService.getTotalDepartment());
			
			// Analytics data
			int currentYear = java.time.LocalDate.now().getYear();
			java.util.List<java.math.BigDecimal> monthlyRevenue = paymentService.getMonthlyRevenue(currentYear);
			request.setAttribute("monthlyRevenue", monthlyRevenue);
			request.setAttribute("currentYear", currentYear);
			
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
		// TODO Auto-generated method stub
		
	}

}
