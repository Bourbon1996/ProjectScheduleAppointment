package patients.dao;

import java.util.List;

import patients.entity.Patient;
import utils.GenericDAO;

public interface PatientsDAO extends GenericDAO<Patient> {

	public boolean insert(Patient patient);
	
	public List<Patient> findByUserId(Long id);
}
