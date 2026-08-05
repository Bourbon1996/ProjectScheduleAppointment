package com.dhakcare.service;

import java.util.List;

import com.dhakcare.entity.Patient;

public interface PatientService {
	public boolean createPatient(Patient patient);
	public List<Patient> findPatientbyUserId(Long id);
	public Long getTotalPatient();
	public boolean deleteByUserId(String id);
	public Patient getById(String id);
}
