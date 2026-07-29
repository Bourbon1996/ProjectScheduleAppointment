package com.dhakcare.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

import com.dhakcare.entity.User;
import com.dhakcare.service.UserService;
import com.dhakcare.service.impl.UserServiceImpl;

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
	UserService service = new UserServiceImpl();
	
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AuthServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String path = request.getServletPath();
		if("/auth/login".equals(path)) {
			String phone = request.getParameter("phone");
			String password = request.getParameter("password");
			 // Gọi Service kiểm tra đăng nhập
	        // Thành công trả về User, thất bại trả về null
			User user = service.login(phone, password);
			
			if(user == null) {
				request.setAttribute("loginError","Số điện thoại hoặc mật khẩu không chính xác." );
				
				request.setAttribute("loginPhone", phone);
				
				 request.getRequestDispatcher("/home/index").forward(request, response);

	          return;
			}
			
			

		      HttpSession session = request.getSession();
		
		      session.setAttribute("user", user);
		
		      response.sendRedirect( request.getContextPath() + "/home/index" );
		  }
		
		if("/auth/register".equals(path)) {
			String fullName = request.getParameter("fullName");
			String phone = request.getParameter("phone");
			String email = request.getParameter("email");
	        String password = request.getParameter("password");
	        String gender = request.getParameter("gender");
	        String confirmPassword = request.getParameter("confirmPassword");
	        
	        // service kiem tra dulieu 
	        //kiem tra trung  va tao User
	         User user = service.register(fullName,gender, phone, email, password, confirmPassword);
	         
	         // dang ky that bai 
	         if(user == null) {
	        	 request.setAttribute("registerError","Thông tin không hợp lệ hoặc số điện thoại/email đã tồn tại.");
	        	 request.setAttribute( "registerFullName", fullName );

	             request.setAttribute("registerPhone",phone );
	             
	             request.setAttribute("registerGender", gender );

	             request.setAttribute("registerEmail",email );

	             request.getRequestDispatcher("/home/index").forward(request, response);
	        	 
	        	 return;
	         }
	         HttpSession session = request.getSession();
	         session.setAttribute("user", user);

	         response.sendRedirect(request.getContextPath()+"/home/index");
	         return;
		}
		
		if ("/auth/logout".equals(path)) {

	        // false nghĩa là không tạo session mới
	        // nếu session hiện tại không tồn tại
	        HttpSession session = request.getSession(false);

	        if (session != null) { 
	        	session.invalidate();
	        }

	        response.sendRedirect(request.getContextPath() +"/home/index" );

	        return;
	    }
	}

}
