package com.dhakcare.service.impl;

import java.math.BigDecimal;
import java.util.List;

import com.dhakcare.dao.DepartmentDAO;
import com.dhakcare.dao.impl.DepartmentDaoImpl;
import com.dhakcare.entity.Department;
import com.dhakcare.entity.Doctor;
import com.dhakcare.service.DepartmentService;

public class DepartmentServiceImpl implements DepartmentService{
	private final DepartmentDAO dao = new DepartmentDaoImpl();
	
	public List<Department> getAllDepartmentParent(){
		
		return dao.findDepartmentsParent();
	}
	
	
	public List<Department> getAllDepartmentChild(){
		
		return dao.findAllDepartmentChild();
	}
	
	
	public BigDecimal getFinalExamFee(Doctor doctor, Department department) {
	    // 1. Nếu bác sĩ có set giá riêng (VIP / Giáo sư / Tiến sĩ) -> Lấy giá của Bác sĩ
	    if (doctor.getExaminationFee() != null && doctor.getExaminationFee().compareTo(BigDecimal.ZERO) > 0) {
	        return doctor.getExaminationFee();
	    }
	    
	    return department.getBasePrice();
	}


	@Override
	public boolean deleteById(String id) {
		
		return dao.delete(id);
	}


	@Override
	public Long getTotalDepartment() {
		return dao.countTotalDepartment();
	}


	@Override
	public Department findById(Long id) {
		// TODO Auto-generated method stub
		return dao.findById(id);
	}


	@Override
	public boolean update(Department department) {
		// TODO Auto-generated method stub
		return dao.update(department) != null;
	}


	@Override
	public boolean create(Department department) {
		// TODO Auto-generated method stub
		return dao.create(department);
	}
	
}
