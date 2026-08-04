package com.dhakcare.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.dhakcare.dao.PatientsDAO;
import com.dhakcare.dao.impl.PatientDAOImpl;
import com.dhakcare.entity.Patient;
import com.dhakcare.enums.WsEventType;
import com.dhakcare.service.PatientService;
import com.dhakcare.ws.AdminDashboardWS;

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
        if (patient.getDateOfBirth() == null) {
            System.out.println("Lỗi: Ngày sinh không hợp lệ!");
            return false;
        }

        patient.setFullName(patient.getFullName().trim().toUpperCase());
        patient.setPhone(patient.getPhone().trim());
        patient.setAddress(patient.getAddress().trim());

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


}
