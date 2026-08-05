package com.dhakcare.servlet;

import java.io.IOException;

import com.dhakcare.service.UserService;
import com.dhakcare.service.impl.UserServiceImpl;
import com.dhakcare.utils.RandomPassWordUtil;
import com.dhakcare.utils.XAttr;
import com.dhakcare.utils.XAuth;
import com.dhakcare.utils.XHttp;
import com.dhakcare.utils.XMail;
import com.dhakcare.utils.XParam;
import com.dhakcare.utils.XPath;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet ({
	"/account/edit-profile",
	"/account/forgot-password",
	"/account/change-password",	
})
public class AccountServlet extends HttpServlet {
	
	private final UserService userService = new UserServiceImpl();
	@Override
	protected void service(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		var path = req.getServletPath();
		if(path.contains("edit-profile")) {
			this.doEditProfile();
		}
		else if(path.contains("forgot-password")) {
			this.doForgotPassword();
		}
		else if(path.contains("change-password")) {
			this.doChangePassword();
		}
	}
	
	private void setMessage(String message, String type) {
	    XAttr.setRequest("msg", message);
	    XAttr.setRequest("messageType", type);
	}
	
	private void doEditProfile() throws ServletException, IOException {
		if(XHttp.is("POST")) {
			var user = XAuth.getUser();

			var fullName = XParam.getString("fullName");

			var email = XParam.getString("email");

			var phone = XParam.getString("phone");

			var gender = XParam.getString("gender");

			XAttr.setRequest("formFullName", fullName);
	        XAttr.setRequest("formPhone", phone);
	        XAttr.setRequest("formEmail", email);
	        XAttr.setRequest("formGender", gender);

	        if (fullName == null || fullName.isBlank()) {

	            setMessage("Họ và tên không được để trống.","danger");

	        } else if (phone == null || phone.isBlank()) {

	            setMessage( "Số điện thoại không được để trống.","danger");

	        } else if (email == null || email.isBlank()) {

	            setMessage("Email không được để trống.","danger");

	        } else if (gender == null || gender.isBlank()) {

	            setMessage("Vui lòng chọn giới tính.","danger");

	        } else {	            
	            var oldFullName = user.getFullName();
	            var oldPhone = user.getPhone();
	            var oldEmail = user.getEmail();
	            var oldGender = user.getGender();

	            try {
	                user.setFullName(fullName.trim());
	                user.setPhone(phone.trim());
	                user.setEmail(email.trim());
	                user.setGender(gender);

	                userService.update(user);
	               
	                XAuth.setUser(user);
	                
	                XAttr.removeRequest("formFullName");
	                XAttr.removeRequest("formPhone");
	                XAttr.removeRequest("formEmail");
	                XAttr.removeRequest("formGender");

	                setMessage( "Cập nhật hồ sơ thành công.","success");

	            } catch (Exception e) {
	                
	                user.setFullName(oldFullName);
	                user.setPhone(oldPhone);
	                user.setEmail(oldEmail);
	                user.setGender(oldGender);

	                e.printStackTrace();

	                setMessage("Không thể cập nhật. Email hoặc số điện thoại có thể đã tồn tại.","danger");
	            }
	        }
	    }
			
			XPath.forward("/site/views/account/edit-profile.jsp");
		
			
	}

	private void doChangePassword()	throws ServletException, IOException {

		if (XHttp.is("POST")) {

			var user = XAuth.getUser();

			var currentPassword =
					XParam.getString("currentPassword");

			var newPassword =
					XParam.getString("newPassword");

			var confirmPassword =
					XParam.getString("confirmPassword");
			
			if (currentPassword == null || currentPassword.isBlank()) {

				setMessage("Vui lòng nhập mật khẩu hiện tại.","danger");

			} else if (newPassword == null || newPassword.isBlank()) {

				setMessage("Vui lòng nhập mật khẩu mới.","danger");

			} else if (confirmPassword == null|| confirmPassword.isBlank()) {

				setMessage("Vui lòng xác nhận mật khẩu mới.", "danger");
			
			} else if (!currentPassword.equals(user.getPasswordHash())) {

				setMessage("Mật khẩu hiện tại không chính xác.","danger");

			
			} else if (newPassword.length() < 6) {

				setMessage("Mật khẩu mới phải có ít nhất 6 ký tự.","danger");

			
			} else if (newPassword.equals(currentPassword)) {

				setMessage("Mật khẩu mới phải khác mật khẩu hiện tại.","danger");

		
			} else if (!newPassword.equals(confirmPassword)) {

				setMessage("Xác nhận mật khẩu mới không khớp.","danger");

			} else {

				var oldPassword = user.getPasswordHash();

				try {
					user.setPasswordHash(newPassword);

					userService.update(user);
				
					XAuth.setUser(user);

					setMessage("Đổi mật khẩu thành công.","success");

				} catch (Exception e) {
				
					user.setPasswordHash(oldPassword);

					e.printStackTrace();

					setMessage("Không thể đổi mật khẩu. Vui lòng thử lại.","danger");
				}
			}
		}

		XPath.forward("/site/views/account/change-password.jsp");
	
	}

	private void doForgotPassword() throws ServletException, IOException {
		if (XHttp.is("POST")) {
			String step = XParam.getString("step");
			String email = XParam.getString("email");
			XAttr.setRequest("email", email);

			if ("send_otp".equals(step) || step == null) {
				if (email == null || email.isBlank()) {
					setMessage("Vui lòng nhập địa chỉ email.", "danger");
					XAttr.setRequest("step", "send_otp");
				} else {
					var user = userService.findByEmail(email.trim());
					if (user == null) {
						setMessage("Không tìm thấy tài khoản với email này.", "danger");
						XAttr.setRequest("step", "send_otp");
					} else {
						// Tạo OTP và gửi email
						String otp = com.dhakcare.utils.OtpService.generateOtp(email.trim());
						try {
							XMail.sendOtp(email.trim(), otp);
							XAttr.setRequest("step", "verify_otp");
							setMessage("Đã gửi mã OTP đến email của bạn.", "success");
						} catch (Exception e) {
							e.printStackTrace();
							setMessage("Không thể gửi email. Vui lòng thử lại.", "danger");
							XAttr.setRequest("step", "send_otp");
						}
					}
				}
			} else if ("verify_otp".equals(step)) {
				String otpInput = XParam.getString("otp");
				XAttr.setRequest("otp", otpInput);
				
				if (com.dhakcare.utils.OtpService.validateOtp(email.trim(), otpInput)) {
					XAttr.setRequest("step", "reset_password");
					setMessage("Xác thực OTP thành công. Vui lòng nhập mật khẩu mới.", "success");
				} else {
					XAttr.setRequest("step", "verify_otp");
					setMessage("Mã OTP không hợp lệ hoặc đã hết hạn.", "danger");
				}
			} else if ("reset_password".equals(step)) {
				String newPassword = XParam.getString("newPassword");
				String confirmPassword = XParam.getString("confirmPassword");
				
				if (newPassword == null || newPassword.length() < 6) {
					XAttr.setRequest("step", "reset_password");
					setMessage("Mật khẩu mới phải có ít nhất 6 ký tự.", "danger");
				} else if (!newPassword.equals(confirmPassword)) {
					XAttr.setRequest("step", "reset_password");
					setMessage("Xác nhận mật khẩu không khớp.", "danger");
				} else {
					var user = userService.findByEmail(email.trim());
					if (user != null) {
						// Chú ý: Ở đây bạn đã được cấp file hướng dẫn Password Hashing
						// Dự án vẫn đang lưu plaintext theo hiện trạng, nhưng ta sẽ để comment
						user.setPasswordHash(newPassword); 
						userService.update(user);
						
						// Xóa session OTP
						com.dhakcare.utils.OtpService.removeOtp(email.trim());
						
						XAttr.setRequest("openLoginPopup", true);
						XAttr.setRequest("loginSuccess", "Đổi mật khẩu thành công. Vui lòng đăng nhập lại.");
						XAttr.setRequest("loginPhone", user.getPhone());
						
						XPath.forward("/home/index");
						return;
					} else {
						setMessage("Lỗi không tìm thấy người dùng.", "danger");
						XAttr.setRequest("step", "send_otp");
					}
				}
			}
		} else {
			XAttr.setRequest("step", "send_otp"); // Mặc định vào step 1
		}

		XPath.forward("/site/views/account/forgot-password.jsp");
	}	
}
