package com.dhakcare.filter;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

import com.dhakcare.service.UserService;
import com.dhakcare.service.impl.UserServiceImpl;
import com.dhakcare.utils.XAuth;
import com.dhakcare.utils.XHttp;
import com.dhakcare.utils.XPath;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.Cookie;

@WebFilter({
	"/appointment",
	"/appointment/*",
	"/account/edit-profile",
	"/account/change-password"
})
public class AuthFilter implements Filter {

	private final UserService userService =
			new UserServiceImpl();

	@Override
	public void doFilter(
			ServletRequest request,
			ServletResponse response,
			FilterChain chain)
			throws IOException, ServletException {

		if (!XAuth.isAuthenticated()) {

			Cookie[] cookies =
					XHttp.getRequest()
						 .getCookies();

			if (cookies != null) {

				for (Cookie cookie : cookies) {

					if ("remember_user"
							.equals(cookie.getName())) {

						try {

							Long userId =
									Long.valueOf(
										cookie.getValue()
									);

							var user =
									userService
										.findById(userId);

							if (user != null) {

								XAuth.setUser(user);
							}

						} catch (Exception e) {

							e.printStackTrace();
						}

						break;
					}
				}
			}
		}

		if (!XAuth.isAuthenticated()) {

			redirectToLogin(
				"Vui lòng đăng nhập trước khi truy cập trang này"
			);

			return;
		}
		chain.doFilter(request, response);
	}


	private void redirectToLogin(String message)
			throws IOException, ServletException {

		XAuth.saveUrl();

		var encodedMessage =
				URLEncoder.encode(
					message,
					StandardCharsets.UTF_8
				);

		XPath.redirect(
			"/auth/login?msg="
			+ encodedMessage
		);
	}
}