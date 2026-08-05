package com.dhakcare.servlet;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

import com.dhakcare.entity.Appointment;
import com.dhakcare.entity.Doctor;
import com.dhakcare.entity.DoctorScheduleSlot;
import com.dhakcare.entity.User;
import com.dhakcare.enums.SlotStatus;
import com.dhakcare.service.AppointmentService;
import com.dhakcare.service.DoctorScheduleSlotService;
import com.dhakcare.service.DoctorService;
import com.dhakcare.service.impl.AppointmentServiceImpl;
import com.dhakcare.service.impl.DoctorScheduleSlotServiceImpl;
import com.dhakcare.service.impl.DoctorServiceImpl;
import com.dhakcare.utils.XAuth;
import com.dhakcare.utils.XParam;
import com.dhakcare.utils.XPath;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet({
	"/doctor-portal",
	"/doctor-portal/appointments",
	"/doctor-portal/schedule",
	"/doctor-portal/schedule/add",
	"/doctor-portal/schedule/delete"
})
public class DoctorPortalServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	private AppointmentService appointmentService = new AppointmentServiceImpl();
	private DoctorScheduleSlotService slotService = new DoctorScheduleSlotServiceImpl();
	private DoctorService doctorService = new DoctorServiceImpl();

    public DoctorPortalServlet() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		response.setCharacterEncoding("UTF-8");
		
		User loggedInUser = XAuth.getUser();
		if (loggedInUser == null || !XAuth.isDoctor()) {
			XPath.redirect("/auth/login");
			return;
		}

		if (XPath.is("/doctor-portal/appointments")) {
			List<Appointment> doctorAppointments = appointmentService.getAppointmentsByDoctorUser(loggedInUser);
			request.setAttribute("historyList", doctorAppointments);
			XPath.forward("/doctor/views/appointments.jsp");
			return;
		}

		if (XPath.is("/doctor-portal/schedule")) {
			List<DoctorScheduleSlot> slots = slotService.findByDoctorUser(loggedInUser);
			request.setAttribute("slotList", slots);
			XPath.forward("/doctor/views/schedule.jsp");
			return;
		}

		// Default dashboard
		XPath.forward("/doctor/views/dashboard.jsp");
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		response.setCharacterEncoding("UTF-8");
		
		User loggedInUser = XAuth.getUser();
		if (loggedInUser == null || !XAuth.isDoctor()) {
			XPath.redirect("/auth/login");
			return;
		}

		if (XPath.is("/doctor-portal/schedule/add")) {
			Doctor doctor = doctorService.getByUser(loggedInUser);
			
			// Auto-create Doctor profile for testing if it doesn't exist
			if (doctor == null) {
				doctor = new Doctor();
				doctor.setUser(loggedInUser);
				doctor.setTitle("BS");
				doctor.setDescription("Auto generated profile");
				// Need to save it using an EntityManager or DAO.
				// For quick fix, I will use JpaUtil directly here.
				jakarta.persistence.EntityManager em = com.dhakcare.utils.JpaUtil.getEntityManager();
				try {
					em.getTransaction().begin();
					em.persist(doctor);
					em.getTransaction().commit();
				} catch(Exception e) {
					if(em.getTransaction().isActive()) em.getTransaction().rollback();
				} finally {
					em.close();
				}
			}

			if (doctor != null) {
				try {
					String dateStr = request.getParameter("workDate");
					String recurrence = request.getParameter("recurrence"); // "DAY", "WEEK", "MONTH"
					String[] timeSlots = request.getParameterValues("timeSlots");
					String maxPatientsStr = request.getParameter("maxPatients");
					int maxPatients = (maxPatientsStr != null && !maxPatientsStr.isBlank()) ? Integer.parseInt(maxPatientsStr) : 10;

					if (timeSlots != null && timeSlots.length > 0) {
						LocalDate selectedDate = LocalDate.parse(dateStr, DateTimeFormatter.ofPattern("yyyy-MM-dd"));
						LocalDate startDate = selectedDate;
						LocalDate endDate = selectedDate;

						if ("WEEK".equals(recurrence)) {
							int dayOfWeek = selectedDate.getDayOfWeek().getValue();
							startDate = selectedDate.minusDays(dayOfWeek - 1);
							endDate = startDate.plusDays(6);
						} else if ("MONTH".equals(recurrence)) {
							startDate = selectedDate.withDayOfMonth(1);
							endDate = selectedDate.withDayOfMonth(selectedDate.lengthOfMonth());
						}

						// Loop through all dates in the range
						LocalDate currentDate = startDate;
						while (!currentDate.isAfter(endDate)) {
							for (String slotRange : timeSlots) {
								String[] times = slotRange.split("-");
								if (times.length == 2) {
									LocalTime st = LocalTime.parse(times[0].trim());
									LocalTime et = LocalTime.parse(times[1].trim());

									// Check if slot already exists for this doctor, date, and start time
									boolean exists = false;
									List<DoctorScheduleSlot> existingSlots = slotService.getByDoctorAndDate(String.valueOf(doctor.getId()), currentDate);
									for (DoctorScheduleSlot eSlot : existingSlots) {
										if (eSlot.getStartTime().equals(st)) {
											exists = true;
											break;
										}
									}

									if (!exists) {
										DoctorScheduleSlot slot = new DoctorScheduleSlot();
										slot.setDoctor(doctor);
										slot.setWorkDate(currentDate);
										slot.setStartTime(st);
										slot.setEndTime(et);
										slot.setMaxPatients(maxPatients);
										slot.setBookedCount(0);
										slot.setStatus(SlotStatus.AVAILABLE);
										slotService.createSlot(slot);
									}
								}
							}
							currentDate = currentDate.plusDays(1);
						}
					}
					request.getSession().setAttribute("message", "Thêm khung giờ rảnh thành công!");
				} catch (Exception e) {
					request.getSession().setAttribute("error", "Vui lòng nhập đúng định dạng dữ liệu: " + e.getMessage());
					e.printStackTrace();
				}
			} else {
				request.getSession().setAttribute("error", "Không tìm thấy hồ sơ Bác sĩ (Doctor) cho User này!");
			}
			XPath.redirect("/doctor-portal/schedule");
			return;
		}

		if (XPath.is("/doctor-portal/schedule/delete")) {
			String id = XParam.getString("id");
			DoctorScheduleSlot slot = slotService.getById(id);
			if (slot != null && slot.getDoctor().getUser().getId().equals(loggedInUser.getId())) {
				if (slot.getBookedCount() == 0) {
					slotService.deleteSlot(id);
				} else {
					request.getSession().setAttribute("error", "Không thể xóa khung giờ đã có bệnh nhân đặt!");
				}
			}
			XPath.redirect("/doctor-portal/schedule");
			return;
		}

		doGet(request, response);
	}
}
