package patients.dao;

import jakarta.persistence.EntityManager;
import patients.entity.Patient;
import utils.GenericCRUDUtil;
import utils.JpaUtil;

public class PatientDAOIplm implements PatientsDAO{
	EntityManager em =  JpaUtil.getEntityManager();

	GenericCRUDUtil<Patient> patientDAO =
	        new GenericCRUDUtil<>(em, Patient.class);
}
