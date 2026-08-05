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
	public List<Appointment> getAppointmentsByDoctorUser(User user);
	public boolean cancelAppointment(Long id);
	public boolean completeAppointment(Long id);
	public java.util.List<Object[]> getTopDepartments(int limit);
	public java.util.List<Object[]> getTopDoctors(int limit);
}
