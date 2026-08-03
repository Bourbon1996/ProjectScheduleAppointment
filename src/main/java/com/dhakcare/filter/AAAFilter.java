package com.dhakcare.filter;

import java.io.IOException;

import com.dhakcare.utils.XHttp;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;

@WebFilter("/*") // chay qua tat ca cac request 
		//nham gi nhan rq,rp de phuc vu cho cac cong vie hdong trong pham vi rq

public class AAAFilter implements Filter {

	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {
		request.setCharacterEncoding("utf-8");
		response.setCharacterEncoding("utf-8");
		// truoc khi di toi servlet
		XHttp.add(request, response);
		chain.doFilter(request, response);
		// sau khi di toi servlet
		XHttp.remove();
	}

}
