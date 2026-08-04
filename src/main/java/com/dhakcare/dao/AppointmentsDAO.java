package com.dhakcare.dao;

import java.time.LocalDate;
import java.util.List;

import com.dhakcare.entity.Appointment;
import com.dhakcare.entity.Doctor;
import com.dhakcare.entity.User;
import com.dhakcare.utils.GenericDAO;


public interface AppointmentsDAO extends GenericDAO<Appointment> {
	
	public boolean deleteByDoctorId(String id);
    public boolean removeDepartmentByDepartmentId(String id);
    public Integer findMaxQueueNumberByDoctorAndDate(Doctor doctor, LocalDate date);
    public List<Appointment> findByUser(User user);
}
