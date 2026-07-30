package com.dhakcare.dao;

import com.dhakcare.entity.Doctor;
import com.dhakcare.utils.GenericDAO;

public interface DoctorDAO extends GenericDAO<Doctor>{


	public Long countTotalDoctor();
	public boolean deleteById(String Id);

  
}
