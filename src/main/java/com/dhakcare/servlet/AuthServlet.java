package com.dhakcare.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;


import java.io.IOException;

import com.dhakcare.service.UserService;
import com.dhakcare.service.impl.UserServiceImpl;
import com.dhakcare.utils.XAttr;
import com.dhakcare.utils.XAuth;
import com.dhakcare.utils.XParam;
import com.dhakcare.utils.XPath;

/**
 * Servlet implementation class AuthServlet
 */
@WebServlet({
	"/auth/login",
	"/auth/logout",
	"/auth/register"
	
})
public class AuthServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private final UserService userService = new UserServiceImpl();
	
    public AuthServlet() {
        super();        
    }

   
    protected void doGet(HttpServletRequest request,HttpServletResponse response) throws ServletException, IOException {

    	if (XPath.contains("logout")) {

    		XAuth.logoff();

    		XAttr.setRequest(
    			"logoutMessage",
    			"Đăng xuất thành công"
    		);
    		
    		
    		
    		String referer = request.getHeader("Referer");

    	    if (referer != null && !referer.isEmpty()) {

    	    	response.sendRedirect(referer);
    	    	return;
    	    } else {
    	        XPath.redirect("/home/index");
    	        return;
    	    }
    	}

    	if (XPath.contains("login")) {

    		var message = XParam.getString("msg");

    		if (message == null || message.isBlank()) {
    			message = "Vui lòng đăng nhập để tiếp tục";
    		}

    		XAttr.setRequest("loginError",message);// popup dang nhap 

    		XPath.forward("/home/index");
    		return;
    	}

    	response.sendError(HttpServletResponse.SC_NOT_FOUND);
    }
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		if(XPath.contains("login")) {
			this.doLogin(request);
			return;
		}
		
		else if(XPath.contains("register")) {
			this.doRegister();
			return;
		}
		
		response.sendError(HttpServletResponse.SC_NOT_FOUND);
		
	}

	private void doLogin(HttpServletRequest request) throws ServletException, IOException {
		//check co sdt co mat khau
		var phone = XParam.getString("phone");
		var password = XParam.getString("password");
		
		var user = userService.login(phone, password);
		
		if(user == null) {
			XAttr.setRequest("loginError", "Số điện thoại hoặc mật khẩu không chính xác");
			
			XAttr.setRequest("loginPhone", phone);
			
			XPath.forward("/home/index");
			return;
		}
		
		XAuth.setUser(user);
		
		if (XAuth.isAdmin()) {
			XPath.redirect("/admin/dashboard");// neu la admin se dua ve dasboard
			return;
		}
		
		if(XAuth.backToSavedUrl()) { //dang nhap thanh cong tra ve URL da luu 
			return;
		}

		String referer = request.getHeader("Referer");

	    if (referer != null && !referer.isEmpty()) {

	    	XPath.redirect(referer);
	    } else {
	        XPath.redirect("/home/index");
	    }
	}
	
	private void doRegister() throws ServletException, IOException {
		var fullName = XParam.getString("fullName");
		var phone = XParam.getString("phone");
		var email = XParam.getString("email");
		var password = XParam.getString("password");
		var gender = XParam.getString("gender");
		var confirmPassword = XParam.getString("confirmPassword");	
		
		var user = userService.register(fullName, gender, phone, email, password, confirmPassword);
		
		if(user == null) {
			XAttr.setRequest("registerError", "Thông tin không hợp lệ hoặc email/số điện thoại đã tồn tại");
			
			XAttr.setRequest("registerFullName", fullName);
			XAttr.setRequest("registerGender", gender);
			XAttr.setRequest("registerPhone", phone);
			XAttr.setRequest("registerEmail", email);

			XPath.forward("/home/index");
			return;
		}
		
		XAuth.setUser(user);
		XPath.redirect("/home/index");
	}

}
