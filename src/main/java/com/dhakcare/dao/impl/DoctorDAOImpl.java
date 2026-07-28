package com.dhakcare.dao.impl;

import com.dhakcare.dao.DoctorDAO;
import com.dhakcare.entity.Doctor;
import com.dhakcare.utils.GenericDAOImpl;

public class DoctorDAOImpl extends GenericDAOImpl<Doctor> implements DoctorDAO{

	public DoctorDAOImpl() {
		super(Doctor.class);
	}
	
}
