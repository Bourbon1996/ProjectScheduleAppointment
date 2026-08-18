package com.dhakcare.servlet;

import java.io.IOException;
import java.util.UUID;

import com.dhakcare.entity.User;
import com.dhakcare.service.UserService;
import com.dhakcare.service.impl.UserServiceImpl;
import com.dhakcare.utils.XAttr;
import com.dhakcare.utils.XAuth;
import com.dhakcare.utils.XHttp;
import com.dhakcare.utils.XMail;
import com.dhakcare.utils.XParam;
import com.dhakcare.utils.XPath;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

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

    	    Cookie cookie =
    	            new Cookie(
    	                "remember_user",
    	                ""
    	            );

    	    var contextPath =
    	            XPath.getContextPath();

    	    cookie.setPath(
    	        contextPath == null
    	        || contextPath.isBlank()
    	            ? "/"
    	            : contextPath
    	    );

    	    cookie.setMaxAge(0);

    	    cookie.setHttpOnly(true);

    	    XHttp.getResponse()
    	         .addCookie(cookie);

    	    XAuth.logoff();

    	    XAttr.setSession(
    	        "logoutMessage",
    	        "Đăng xuất thành công"
    	    );

    	    String referer = request.getHeader("Referer");

    	    if (
    	        referer != null
    	        && referer.contains("/admin")
    	    ) {

    	        XPath.redirect("/home/index");
    	        return;
    	    }

    	    if (
    	        referer != null
    	        && !referer.isBlank()
    	    ) {

    	        response.sendRedirect(referer);
    	        return;
    	    }

    	    XPath.redirect("/home/index");
    	    return;
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
		var remember = XParam.getString("remember");
		boolean isRemember = "true".equals(remember);
		
		var user = userService.login(phone, password);
		
		String referer = request.getHeader("Referer");
		
		if(user == null) {
			XAttr.setRequest("loginError", "Số điện thoại hoặc mật khẩu không chính xác");
			
			XAttr.setRequest("loginPhone", phone);
			
			if (referer != null && !referer.isEmpty()) {

		    	XPath.redirect(referer);
		    	return;
		    } else {
		        XPath.redirect("/home/index");
		        return;
		    }
		}
		
		XAuth.setUser(user);
		
		if (isRemember) {

		    Cookie cookie =
		            new Cookie(
		                "remember_user",
		                String.valueOf(user.getId())
		            );

		    cookie.setHttpOnly(true);

		    cookie.setPath(
		        XPath.getContextPath().isEmpty()
		            ? "/"
		            : XPath.getContextPath()
		    );

		    cookie.setMaxAge(
		        7 * 24 * 60 * 60
		    );

		    XHttp.getResponse()
		         .addCookie(cookie);
		}
		
		if (XAuth.isAdmin()) {
			XPath.redirect("/admin/dashboard");
			return;
		}
		
		if (XAuth.isDoctor()) {
			XPath.redirect("/doctor-portal");
			return;
		}
		
		String savedUrl = (String) XAttr.getSession("saved-url");
		if (savedUrl != null && !savedUrl.isBlank()) {
			XAttr.removeSession("saved-url");
			if (!savedUrl.contains("forgot-password") && 
			    !savedUrl.contains("login") && 
			    !savedUrl.contains("register")) {
				XPath.redirect(savedUrl);
				return;
			}
		}
	
	    if (referer != null && !referer.isEmpty() && 
	        !referer.contains("forgot-password") && 
	        !referer.contains("login") && 
	        !referer.contains("register")) {
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
		
		if(user != null) {
			XMail.sendWelcome(user);
		}
		
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
