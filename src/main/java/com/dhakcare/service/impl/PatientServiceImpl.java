package com.dhakcare.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.dhakcare.dao.PatientsDAO;
import com.dhakcare.dao.impl.PatientDAOImpl;
import com.dhakcare.entity.Patient;
import com.dhakcare.enums.WsEventType;
import com.dhakcare.service.PatientService;
import com.dhakcare.websocket.AdminDashboardWS;

public class PatientServiceImpl implements PatientService {
	
	private PatientsDAO patientsDAO = new PatientDAOImpl();
	@Override
	public boolean createPatient(Patient patient) {
		
        if (patient.getFullName() == null || patient.getFullName().trim().isEmpty()) {
            System.out.println("Lỗi: Tên bệnh nhân không được để trống!");
            return false;
        }
        if (patient.getPhone() == null || patient.getPhone().trim().isEmpty()) {
            System.out.println("Lỗi: Số điện thoại không được để trống!");
            return false;
        }
        patient.setFullName(patient.getFullName().trim().toUpperCase());
        patient.setPhone(patient.getPhone().trim());
        if (patient.getAddress() != null) patient.setAddress(patient.getAddress().trim());
        if (patient.getCccd() != null) patient.setCccd(patient.getCccd().trim());
        if (patient.getEmail() != null) patient.setEmail(patient.getEmail().trim());
        if (patient.getHealthInsuranceCode() != null) patient.setHealthInsuranceCode(patient.getHealthInsuranceCode().trim());
        if (patient.getEmergencyContact() != null) patient.setEmergencyContact(patient.getEmergencyContact().trim());

        var newPatient = patientsDAO.insert(patient);
        
        Long totalPatient = patientsDAO.countTotalPatients();
        
        Map<String, Object> statsData = new HashMap<>();
        statsData.put("totalPatient", totalPatient);

        AdminDashboardWS.broadcast(WsEventType.NEW_PATIENT, statsData);
        
        return newPatient;
	}
	@Override
	public List<Patient> findPatientbyUserId(Long id) {
		
		return patientsDAO.findByUserId(id);
	}
	@Override
	public Long getTotalPatient() {
		return patientsDAO.countTotalPatients();
	}
	@Override
	public boolean deleteByUserId(String id) {
		
		return patientsDAO.deleteByUserId(id);
	}
	@Override
	public Patient getById(String id) {
		// TODO Auto-generated method stub
		return patientsDAO.findById(id);
	}

	@Override
	public boolean updatePatient(Patient patient) {
		return patientsDAO.update(patient) != null;
	}

	@Override
	public boolean deleteById(Long id) {
		return patientsDAO.delete(id);
	}

	@Override
	public java.util.List<Patient> findAll() {
		return patientsDAO.findAll();
	}

}
