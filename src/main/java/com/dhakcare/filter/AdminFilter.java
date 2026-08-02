package com.dhakcare.filter;

import java.io.IOException;

import com.dhakcare.utils.XAuth;
import com.dhakcare.utils.XPath;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletResponse;

@WebFilter("/admin/*")
public class AdminFilter implements Filter {

	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {
		if (!XAuth.isAuthenticated()) {
			XAuth.saveUrl();
			XPath.redirect("/auth/login?msg=Vui+lòng+đăng+nhập");
			return;
		}

		if (!XAuth.isAdmin()) {
			var httpResponse =(HttpServletResponse) response;
			httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN,"Bạn không có quyền truy cập trang quản trị");
			return;
		}
		
		chain.doFilter(request, response);		
	}
	
}
