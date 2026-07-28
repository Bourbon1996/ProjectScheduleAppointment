package com.dhakcare.service.impl;

import java.util.List;

import com.dhakcare.dao.PatientsDAO;
import com.dhakcare.dao.impl.PatientDAOImpl;
import com.dhakcare.entity.Patient;
import com.dhakcare.service.PatientService;

public class PatientServiceImpl implements PatientService {
	
	private PatientsDAO patientsDAO = new PatientDAOImpl();
	@Override
	public boolean createPatient(Patient patient) {
		
		// 1. Kiểm tra các trường bắt buộc không được để trống hoặc null
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

        // 2. Chuẩn hóa dữ liệu trước khi lưu (Tên viết hoa, xóa khoảng trắng thừa)
        patient.setFullName(patient.getFullName().trim().toUpperCase());
        patient.setPhone(patient.getPhone().trim());
        patient.setAddress(patient.getAddress().trim());

        // 3. Gọi DAO lưu xuống DB
        return patientsDAO.insert(patient);
	}
	@Override
	public List<Patient> findPatientbyUserId(Long id) {
		
		return patientsDAO.findByUserId(id);
	}
	@Override
	public Integer getTotalPatient() {
		
		return patientsDAO.countTotalPatients();
	}


}
