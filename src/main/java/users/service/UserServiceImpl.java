package users.service;

import java.util.List;

import enums.UserStatus;
import users.dao.UserDAO;
import users.dao.UserDAOImpl;
import users.entity.User;


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

}
