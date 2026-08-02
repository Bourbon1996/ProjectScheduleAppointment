package com.dhakcare.filter;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

import com.dhakcare.utils.XAuth;
import com.dhakcare.utils.XPath;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;

@WebFilter({
	"/appointment",
	"/appointment/*",
	"/account/edit-profile",
	"/account/change-password"
})
public class AuthFilter implements Filter {

	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {
		//nguoi dung chua dang nhap 
		if(!XAuth.isAuthenticated()) {
			redirectToLogin(
					"Vui lòng đăng nhập trước khi truy cập trang này"
				);
		}else {
			chain.doFilter(request, response);
		}
	}

	private void redirectToLogin(String message)
			throws IOException, ServletException {

		XAuth.saveUrl();

		var encodedMessage = URLEncoder.encode(message,StandardCharsets.UTF_8);

		XPath.redirect("/auth/login?msg=" + encodedMessage);
		
	
	}
	
	
}
