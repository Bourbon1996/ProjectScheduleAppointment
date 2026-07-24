package patients.service;

import java.util.List;

import patients.entity.Patient;

public interface PatientService {
	public boolean createPatient(Patient patient);
	public List<Patient> findPatientbyUserId(Long id);
}
