package com.dhakcare.dao;

import java.util.List;

import com.dhakcare.entity.Patient;
import com.dhakcare.utils.GenericDAO;

public interface PatientsDAO extends GenericDAO<Patient> {

	public boolean insert(Patient patient);
	
	public List<Patient> findByUserId(Long id);
	
	public Integer countTotalPatients();
	

}
