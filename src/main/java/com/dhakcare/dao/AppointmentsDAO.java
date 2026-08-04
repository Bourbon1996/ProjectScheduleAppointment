package com.dhakcare.dao;

import com.dhakcare.entity.Appointment;
import com.dhakcare.utils.GenericDAO;


public interface AppointmentsDAO extends GenericDAO<Appointment> {
	
	public boolean deleteByDoctorId(String id);
    public boolean removeDepartmentByDepartmentId(String id);
}
