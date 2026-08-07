package com.dhakcare.servlet;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
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
	"/doctor-portal/schedule/delete",
	"/doctor-portal/schedule/close",
	"/doctor-portal/patients"
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
			
			String filterDate = request.getParameter("filterDate");
			if (filterDate != null && !filterDate.isBlank()) {
			    try {
			        LocalDate dDate = LocalDate.parse(filterDate);
			        doctorAppointments.removeIf(apt -> apt.getSlot() == null || !apt.getSlot().getWorkDate().equals(dDate));
			    } catch (Exception e) {
			        // Ignore parse error
			    }
			}
			
			doctorAppointments.sort((a1, a2) -> {
			    if (a1.getSlot() == null || a1.getSlot().getWorkDate() == null) return 1;
			    if (a2.getSlot() == null || a2.getSlot().getWorkDate() == null) return -1;
			    int dateCmp = a2.getSlot().getWorkDate().compareTo(a1.getSlot().getWorkDate());
			    if (dateCmp != 0) return dateCmp;
			    if (a1.getSlot().getStartTime() == null) return 1;
			    if (a2.getSlot().getStartTime() == null) return -1;
			    return a1.getSlot().getStartTime().compareTo(a2.getSlot().getStartTime());
			});
			
			request.setAttribute("historyList", doctorAppointments);
			XPath.forward("/doctor/views/appointments.jsp");
			return;
		}

		if (XPath.is("/doctor-portal/schedule")) {
			List<DoctorScheduleSlot> slots = slotService.findByDoctorUser(loggedInUser);
			
			// Group by Date for UI Rendering (Descending order: future -> past)
			java.util.Map<LocalDate, List<DoctorScheduleSlot>> groupedSlots = new java.util.TreeMap<>(java.util.Collections.reverseOrder());
			for (DoctorScheduleSlot slot : slots) {
			    groupedSlots.computeIfAbsent(slot.getWorkDate(), k -> new java.util.ArrayList<>()).add(slot);
			}
			
			// Sort slots by time within each day
			for (List<DoctorScheduleSlot> daySlots : groupedSlots.values()) {
			    daySlots.sort(java.util.Comparator.comparing(DoctorScheduleSlot::getStartTime));
			}
			
			request.setAttribute("groupedSlots", groupedSlots);
			request.setAttribute("slotList", slots); // Keep original list just in case
			XPath.forward("/doctor/views/schedule.jsp");
			return;
		}

		if (XPath.is("/doctor-portal/patients")) {
			List<Appointment> doctorAppointments = appointmentService.getAppointmentsByDoctorUser(loggedInUser);
			java.util.Map<Long, com.dhakcare.entity.Patient> uniquePatients = new java.util.HashMap<>();
			for (Appointment apt : doctorAppointments) {
			    if (apt.getPatient() != null) {
			        uniquePatients.put(apt.getPatient().getId(), apt.getPatient());
			    }
			}
			request.setAttribute("uniquePatients", uniquePatients.values());
			XPath.forward("/doctor/views/patients.jsp");
			return;
		}

		// Default dashboard — compute stats
		List<Appointment> allDoctorApts = appointmentService.getAppointmentsByDoctorUser(loggedInUser);
		LocalDate today = LocalDate.now();

		int todayBooked = 0;
		int todayCompleted = 0;
		int todayWaiting = 0;
		int allTimeCompleted = 0;
		int todayCancelled = 0;
		java.util.List<Appointment> todayAppointments = new java.util.ArrayList<>();

		for (Appointment apt : allDoctorApts) {
		    boolean isToday = apt.getSlot() != null && apt.getSlot().getWorkDate() != null && apt.getSlot().getWorkDate().equals(today);

		    if (apt.getStatus() == com.dhakcare.enums.AppointmentStatus.COMPLETED) {
		        allTimeCompleted++;
		    }

		    if (isToday) {
		        if (apt.getStatus() != com.dhakcare.enums.AppointmentStatus.CANCELLED) {
		            todayBooked++;
		            todayAppointments.add(apt);
		        }
		        if (apt.getStatus() == com.dhakcare.enums.AppointmentStatus.COMPLETED) {
		            todayCompleted++;
		        }
		        if (apt.getStatus() == com.dhakcare.enums.AppointmentStatus.PENDING || apt.getStatus() == com.dhakcare.enums.AppointmentStatus.CONFIRMED) {
		            todayWaiting++;
		        }
		        if (apt.getStatus() == com.dhakcare.enums.AppointmentStatus.CANCELLED) {
		            todayCancelled++;
		        }
		    }
		}

		// Sort by slot start time, then take top 5
		todayAppointments.sort((a, b) -> {
		    if (a.getSlot() == null || b.getSlot() == null) return 0;
		    return a.getSlot().getStartTime().compareTo(b.getSlot().getStartTime());
		});
		java.util.List<Appointment> top5Earliest = todayAppointments.subList(0, Math.min(5, todayAppointments.size()));

		request.setAttribute("todayBooked", todayBooked);
		request.setAttribute("todayCompleted", todayCompleted);
		request.setAttribute("todayWaiting", todayWaiting);
		request.setAttribute("allTimeCompleted", allTimeCompleted);
		request.setAttribute("todayCancelled", todayCancelled);
		request.setAttribute("top5Earliest", top5Earliest);

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
					String[] recurDaysStr = request.getParameterValues("recurDays");
					String maxPatientsStr = request.getParameter("maxPatients");
					int maxPatients = (maxPatientsStr != null && !maxPatientsStr.isBlank()) ? Integer.parseInt(maxPatientsStr) : 10;
					
					List<Integer> validDays = new ArrayList<>();
					if (recurDaysStr != null) {
						for (String rd : recurDaysStr) {
							validDays.add(Integer.parseInt(rd));
						}
					}

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
							boolean shouldCreateForThisDay = false;
							if ("DAY".equals(recurrence)) {
								shouldCreateForThisDay = true;
							} else {
								shouldCreateForThisDay = validDays.contains(currentDate.getDayOfWeek().getValue());
							}
							
							if (shouldCreateForThisDay) {
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
								} // end if times.length == 2
							} // end for slotRange
						} // end if shouldCreateForThisDay
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
			if (slot != null) {
				if (slot.getDoctor().getUser().getId().equals(loggedInUser.getId())) {
					if (slot.getBookedCount() == 0) {
						// Set slot to null for any cancelled appointments that might still reference it
						List<Appointment> slotApts = appointmentService.getAppointmentsBySlot(slot.getId());
						for (Appointment apt : slotApts) {
							apt.setSlot(null);
							appointmentService.updateAppointment(apt);
						}
						
						boolean deleted = slotService.deleteSlot(id);
						if (deleted) {
							request.getSession().setAttribute("message", "Xóa khung giờ rảnh thành công!");
						} else {
							request.getSession().setAttribute("error", "Lỗi CSDL khi xóa khung giờ!");
						}
					} else {
						request.getSession().setAttribute("error", "Không thể xóa khung giờ đã có bệnh nhân đặt!");
					}
				} else {
					request.getSession().setAttribute("error", "Bạn không có quyền xóa khung giờ này!");
				}
			} else {
				request.getSession().setAttribute("error", "Không tìm thấy khung giờ cần xóa!");
			}
			XPath.redirect("/doctor-portal/schedule");
			return;
		}

		if (XPath.is("/doctor-portal/schedule/close")) {
			String id = XParam.getString("id");
			DoctorScheduleSlot slot = slotService.getById(id);
			if (slot != null && slot.getDoctor().getUser().getId().equals(loggedInUser.getId())) {
				slot.setStatus(SlotStatus.CLOSED);
				slotService.updateSlot(slot);
				
				// Cancel all existing appointments and send email
				List<Appointment> slotAppointments = appointmentService.getAppointmentsBySlot(slot.getId());
				for (Appointment apt : slotAppointments) {
				    if (apt.getStatus() == com.dhakcare.enums.AppointmentStatus.PENDING || apt.getStatus() == com.dhakcare.enums.AppointmentStatus.CONFIRMED) {
				        appointmentService.cancelAppointment(apt.getId());
				        
				        // Send Email notification
				        try {
				            String subject = "[DHAKCare] THÔNG BÁO HỦY LỊCH KHÁM ĐỘT XUẤT";
				            String body = "<h3>Kính chào quý khách " + apt.getPatient().getFullName() + ",</h3>"
				                    + "<p>Chúng tôi rất tiếc phải thông báo rằng lịch khám của quý khách vào <b>" + apt.getSlot().getStartTime() + " - " + apt.getSlot().getEndTime() + " (" + apt.getSlot().getWorkDate() + ")</b> đã bị hủy do bác sĩ có việc đột xuất không thể phục vụ.</p>"
				                    + "<p>Thành thật xin lỗi vì sự bất tiện này. Quý khách vui lòng đặt lại một lịch hẹn khác.</p>"
				                    + "<p>Trân trọng,<br>Đội ngũ DHAKCare</p>";
				            com.dhakcare.utils.XMail.send(apt.getBookedBy().getEmail(), subject, body);
				        } catch (Exception e) {
				            System.out.println("Lỗi gửi email khi hủy lịch: " + e.getMessage());
				        }
				    }
				}
				
				com.dhakcare.websocket.NotificationWebSocket.sendToAdmins(
						"{\"type\": \"SLOT_CLOSED\", \"message\": \"Bác sĩ " + slot.getDoctor().getUser().getFullName() + " vừa xin nghỉ ca khám ngày " + slot.getWorkDate() + ".\"}");
				
				request.getSession().setAttribute("message", "Đã xin nghỉ ca khám này thành công! Các lịch hẹn (nếu có) đã bị hủy.");
			}
			XPath.redirect("/doctor-portal/schedule");
			return;
		}

		doGet(request, response);
	}
}
