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
import com.dhakcare.ws.AdminDashboardWS;

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
			
			 Patient patient = patientDao.findById(patientId);
			    Department dept = deptDao.findById(deptId);
			    Doctor doctor = doctorDao.findById(doctorId);
			    DoctorScheduleSlot slot = slotDao.findById(slotId);
			    
			    LocalDate bookingDate = slot.getWorkDate();
			    Integer maxQueue = dao.findMaxQueueNumberByDoctorAndDate(doctor, bookingDate);
			    int nextQueueNumber = maxQueue + 1;

			    Appointment appointment = new Appointment();
			    appointment.setPatient(patient);
			    appointment.setDoctor(doctor);
			    appointment.setDepartment(dept);
			    appointment.setSlot(slot);
			    appointment.setQueueNumber(nextQueueNumber);
			    appointment.setBookedBy(loggedInUser);
			    appointment.setStatus(AppointmentStatus.PENDING);
			    appointment.setPaymentStatus(PaymentStatus.UNPAID);
			    appointment.setCreatedAt(LocalDateTime.now());

			    dao.create(appointment);
			    Long totalAppointments = dao.count();
			    
			    trans.commit();
			    
			    Map<String, Object> statsData = new HashMap<>();
		        statsData.put("totalAppointments", totalAppointments);
		        
		        AdminDashboardWS.broadcast(WsEventType.NEW_APPOINTMENT, statsData);
		        
			    return appointment;
			    
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
			trans.rollback();
			return null;
		} finally {
			em.close();
		}
		
	   
	}

	@Override
	public List<Appointment> getAppointmentsByUser(User user) {
		// TODO Auto-generated method stub
		return dao.findByUser(user);
	}
}
