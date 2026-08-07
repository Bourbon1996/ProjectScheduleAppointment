package com.dhakcare.service.impl;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.dhakcare.dao.UserDAO;
import com.dhakcare.dao.impl.UserDAOImpl;
import com.dhakcare.entity.User;
import com.dhakcare.enums.UserRole;
import com.dhakcare.enums.UserStatus;
import com.dhakcare.enums.WsEventType;
import com.dhakcare.service.UserService;
import com.dhakcare.websocket.AdminDashboardWS;


public class UserServiceImpl implements UserService {
	
	private final UserDAO dao = new UserDAOImpl();
	
	@Override
	public List<User> findAll() {
		
		return dao.findAll();   
		
	}
	
	@Override
	public User login(String phone, String password) {
		
		//kiem tra so dien thoai
		if(phone == null || phone.trim().isEmpty()) {
			return null;
		}
		
		//kiem tra mat khau 
		if(password == null || password.isEmpty()) {
			return null;
		}
		
		//loai bo khoang trang o dau va cuoi dien thoai
		phone = phone.trim();
		
		//goi DAO de tim tai khoan
		User user = dao.findByPhone(phone);
		
		// khong tim thay tai khoan
		if(user == null) {
			return null;
		}
		
		//chi tai khoan ACTIVE moi dc dang nhap
		if(user.getStatus() != UserStatus.ACTIVE) {
			return null;
		}
		
		// kiem tra mat khau
		if(!password.equals(user.getPasswordHash())) {
			return null;
		}
		
		// dang nhap thanh cong
		return user;
	}

	@Override
	public User register(String fullName, String gender, String phone, String email, String password, String confirmPassword) {
		
		// kiem tra ho ten
		if(fullName == null || fullName.trim().isEmpty()) {
			return null;
		}
		
		// kiem tra sdt 
		if(phone == null || phone.trim().isEmpty()) {
			return null;
		}
		
		// kiem tra email 
		if(email ==  null || email.trim().isEmpty()) {
			return null;
		}
		
		// kiem tra mat khau 
		if(password == null || password.length() < 6) {
			return null;
		}
		
		// kiem tra mat khau xac nhan
		if(!password.equals(confirmPassword)) {
			return null;
		}
		
		//chuan hoa du lieu 
		fullName = fullName.trim();
	    phone = phone.trim();
	    email = email.trim().toLowerCase();

	    // kiem tra  dinh dang sdt vietnam
	    if (!phone.matches("^0\\d{9}$")) {
	        return null;
	    }
	    
	    //kiem tra so dt da ton tai
	    if(dao.findByPhone(phone) != null) {
	    	return null;
	    }
	    
	    //kiem tra email da ton tai
	    if(dao.findByEmail(email) != null) {
	    	return null;
	    }
	    
	    // tao tai khoan moi 
	    User user = User.builder()
	    		.fullName(fullName)
	            .phone(phone)
	            .email(email)
	            .gender(gender)
	            .passwordHash(password)
	            .role(UserRole.PATIENT)
	            .status(UserStatus.ACTIVE)
	            .createdAt(LocalDateTime.now())
	            .build();
	    
	    //luu xuong database
	    boolean created = dao.create(user);
		    if (!created) {
		        return null;
		    }
		    
		    Long totalUser = dao.countTotalUser();
		    
		    Map<String, Object> statsData = new HashMap<>();
	        statsData.put("totalUser", totalUser);
		    		
	        AdminDashboardWS.broadcast(WsEventType.NEW_USER, statsData);
		    return user;
	}
	
	public boolean deleteById(String id) {
		return dao.delete(id);
	}

	@Override
	public Long getTotalUser() {
		return dao.countTotalUser();
	}

	@Override
	public User findById(Long id) {
		return dao.findById(id);
	}

	@Override
	public boolean update(User user) {
		return dao.update(user) != null;
	}

	@Override
	public boolean create(User user) {
		// TODO Auto-generated method stub
		return dao.create(user);
	}

	@Override
	public User findByEmail(String email) {
		// TODO Auto-generated method stub
		return dao.findByEmail(email);
	}

}
