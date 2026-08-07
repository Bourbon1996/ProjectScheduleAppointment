package com.dhakcare.service.impl;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.dhakcare.dao.AppointmentsDAO;
import com.dhakcare.dao.DepartmentDAO;
import com.dhakcare.dao.DoctorDAO;
import com.dhakcare.dao.DoctorscheduleslotsDAO;
import com.dhakcare.dao.PatientsDAO;
import com.dhakcare.dao.impl.AppointmentDAOImpl;
import com.dhakcare.dao.impl.DepartmentDaoImpl;
import com.dhakcare.dao.impl.DoctorDAOImpl;
import com.dhakcare.dao.impl.DoctorscheduleslotsDAOImpl;
import com.dhakcare.dao.impl.PatientDAOImpl;
import com.dhakcare.entity.Appointment;
import com.dhakcare.entity.Department;
import com.dhakcare.entity.Doctor;
import com.dhakcare.entity.DoctorScheduleSlot;
import com.dhakcare.entity.Patient;
import com.dhakcare.entity.User;
import com.dhakcare.enums.AppointmentStatus;
import com.dhakcare.enums.PaymentStatus;
import com.dhakcare.enums.WsEventType;
import com.dhakcare.service.AppointmentService;
import com.dhakcare.utils.JpaUtil;
import com.dhakcare.websocket.AdminDashboardWS;

public class AppointmentServiceImpl implements AppointmentService {
	AppointmentsDAO dao = new AppointmentDAOImpl();
	PatientsDAO patientDao = new PatientDAOImpl();
	DepartmentDAO deptDao = new DepartmentDaoImpl();
	DoctorscheduleslotsDAO slotDao = new DoctorscheduleslotsDAOImpl();
	DoctorDAO doctorDao = new DoctorDAOImpl();
	

	@Override
	public boolean deleteByDoctorId(String id) {
		// TODO Auto-generated method stub
		return dao.deleteByDoctorId(id);
	}

	@Override
	public boolean removeDepartmentByDepartmentId(String id) {
		// TODO Auto-generated method stub
		return dao.removeDepartmentByDepartmentId(id);
	}

	@Override
	public Boolean insert(Appointment appointment) {
		// TODO Auto-generated method stub
		return dao.create(appointment);
	}

	@Override
	public Appointment createAppointment(Long patientId, Long deptId, Long doctorId, Long slotId, User loggedInUser) {
		
		var em = JpaUtil.getEntityManager();
		var trans = em.getTransaction();
		
		try {
			
			trans.begin();
			
			// Dùng chính EntityManager này để tất cả nằm trong 1 transaction
			Patient patient = em.find(Patient.class, patientId);
			Department dept = em.find(Department.class, deptId);
			Doctor doctor = em.find(Doctor.class, doctorId);
			DoctorScheduleSlot slot = em.find(DoctorScheduleSlot.class, slotId);
			
			if (slot.getStatus() == com.dhakcare.enums.SlotStatus.FULL || slot.getStatus() == com.dhakcare.enums.SlotStatus.CLOSED) {
				if (trans != null && trans.isActive()) trans.rollback();
				return null;
			}
			
			// Re-attach loggedInUser vào persistence context hiện tại
			User managedUser = em.find(User.class, loggedInUser.getId());
			    
			LocalDate bookingDate = slot.getWorkDate();
			
			// Tìm queue number lớn nhất trong cùng EM
			String jpql = "SELECT MAX(a.queueNumber) FROM Appointment a "
			            + "WHERE a.doctor = :doctor AND a.slot.workDate = :date";
			Integer maxQueue = em.createQuery(jpql, Integer.class)
			        .setParameter("doctor", doctor)
			        .setParameter("date", bookingDate)
			        .getSingleResult();
			int nextQueueNumber = (maxQueue != null ? maxQueue : 0) + 1;

			Appointment appointment = new Appointment();
			appointment.setPatient(patient);
			appointment.setDoctor(doctor);
			appointment.setDepartment(dept);
			appointment.setSlot(slot);
			appointment.setQueueNumber(nextQueueNumber);
			appointment.setBookedBy(managedUser);
			appointment.setStatus(AppointmentStatus.PENDING);
			appointment.setPaymentStatus(PaymentStatus.UNPAID);
			appointment.setCreatedAt(LocalDateTime.now());

			em.persist(appointment);
			
			// Cập nhật số lượng đã đặt của slot
			slot.setBookedCount(slot.getBookedCount() + 1);
			if (slot.getBookedCount() >= slot.getMaxPatients()) {
				slot.setStatus(com.dhakcare.enums.SlotStatus.FULL);
			}
			em.merge(slot);
			
			// Đếm tổng appointments trong cùng EM
			Long totalAppointments = em.createQuery(
			        "SELECT COUNT(a) FROM Appointment a", Long.class)
			        .getSingleResult();
			    
			trans.commit();
			    
			Map<String, Object> statsData = new HashMap<>();
			statsData.put("totalAppointments", totalAppointments);
			AdminDashboardWS.broadcast(WsEventType.NEW_APPOINTMENT, statsData);
			        
			return appointment;
			    
		} catch (Exception e) {
			e.printStackTrace();
			if (trans != null && trans.isActive()) {
				trans.rollback();
			}
			return null;
		} finally {
			if (em != null && em.isOpen()) {
				em.close();
			}
		}
	}

	@Override
	public List<Appointment> getAppointmentsByUser(User user) {
		return dao.findByUser(user);
	}

    @Override
    public List<Appointment> getAppointmentsByDoctorUser(User user) {
        return dao.findByDoctorUser(user);
    }

    @Override
    public List<Appointment> getAppointmentsBySlot(Long slotId) {
        return dao.findBySlotId(slotId);
    }

    @Override
    public Appointment getById(Long id) {
        return dao.findById(id);
    }

    @Override
    public List<Appointment> findAll() {
        return dao.findAll();
    }

	@Override
	public boolean cancelAppointment(Long id) {
		var em = JpaUtil.getEntityManager();
		var trans = em.getTransaction();
		try {
			trans.begin();
			Appointment appointment = em.find(Appointment.class, id);
			if (appointment != null) {
				appointment.setStatus(AppointmentStatus.CANCELLED);
				
				// Giảm số lượng đã đặt của slot
				DoctorScheduleSlot slot = appointment.getSlot();
				if (slot != null && slot.getBookedCount() > 0) {
					slot.setBookedCount(slot.getBookedCount() - 1);
					if (slot.getStatus() == com.dhakcare.enums.SlotStatus.FULL && slot.getBookedCount() < slot.getMaxPatients()) {
						slot.setStatus(com.dhakcare.enums.SlotStatus.AVAILABLE);
					}
					em.merge(slot);
				}
				
				em.merge(appointment);
			}
			trans.commit();
			return true;
		} catch (Exception e) {
			if (trans != null && trans.isActive()) trans.rollback();
			e.printStackTrace();
			return false;
		} finally {
			if (em != null && em.isOpen()) em.close();
		}
	}

	@Override
	public boolean completeAppointment(Long id) {
		var em = JpaUtil.getEntityManager();
		var trans = em.getTransaction();
		try {
			trans.begin();
			Appointment appointment = em.find(Appointment.class, id);
			if (appointment != null) {
				appointment.setStatus(AppointmentStatus.COMPLETED);
				em.merge(appointment);
			}
			trans.commit();
			return true;
		} catch (Exception e) {
			if (trans != null && trans.isActive()) trans.rollback();
			e.printStackTrace();
			return false;
		} finally {
			if (em != null && em.isOpen()) em.close();
		}
	}

	@Override
	public java.util.List<Object[]> getTopDepartments(int limit) {
		return dao.getTopDepartments(limit);
	}

	@Override
	public java.util.List<Object[]> getTopDoctors(int limit) {
		return dao.getTopDoctors(limit);
	}

	@Override
	public boolean updateAppointment(Appointment appointment) {
		return dao.update(appointment) != null;
	}
}
