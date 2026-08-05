package com.dhakcare.service.impl;

import com.dhakcare.dao.AppointmentsDAO;
import com.dhakcare.dao.impl.AppointmentDAOImpl;
import com.dhakcare.entity.Appointment;
import com.dhakcare.service.AppointmentService;

public class AppointmentServiceImpl implements AppointmentService {
	AppointmentsDAO dao = new AppointmentDAOImpl();

	@Override
	public boolean deleteByDoctorId(String id) {
		// TODO Auto-generated method stub
		return dao.deleteByDoctorId(id);
	}

	@Override
	public boolean removeDepartmentByDepartmentId(String id) {
		// TODO Auto-generated method stub
		return dao.removeDepartmentByDepartmentId(id);
	}

	@Override
	public Boolean insert(Appointment appointment) {
		// TODO Auto-generated method stub
		return dao.create(appointment);
	}

}
