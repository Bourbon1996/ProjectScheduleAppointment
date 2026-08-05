package com.dhakcare.service;

import java.util.List;

import com.dhakcare.entity.Appointment;
import com.dhakcare.entity.User;

public interface AppointmentService {
	public boolean deleteByDoctorId(String id);
	public boolean removeDepartmentByDepartmentId(String id);
	public Boolean insert(Appointment appointment);
	public Appointment createAppointment(Long patientId, Long deptId, Long doctorId, Long slotId, User loggedInUser);
	public List<Appointment> getAppointmentsByUser(User user);
}
