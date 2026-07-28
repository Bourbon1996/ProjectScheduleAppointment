package com.dhakcare.service;

import java.util.List;

import com.dhakcare.entity.Patient;

public interface PatientService {
	public boolean createPatient(Patient patient);
	public List<Patient> findPatientbyUserId(Long id);
	public Integer getTotalPatient();
	public boolean deleteById(String id);
}
