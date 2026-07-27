package com.dhakcare.service.impl;

import java.util.List;

import com.dhakcare.dao.DoctorDAO;
import com.dhakcare.dao.impl.DoctorDAOImpl;
import com.dhakcare.entity.Doctor;
import com.dhakcare.service.DoctorService;

public class DoctorServiceImpl implements DoctorService {
	DoctorDAO dao = new DoctorDAOImpl();
	
	public List<Doctor> getAll(){
		return dao.findAll();
	}

	@Override
	public Doctor getById(String id) {
		// TODO Auto-generated method stub
		return dao.findById(id);
	}
}
