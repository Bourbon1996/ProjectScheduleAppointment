package com.dhakcare.servlet;

import java.io.IOException;
import java.util.List;

import com.dhakcare.entity.User;
import com.dhakcare.service.UserService;
import com.dhakcare.service.impl.UserServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;


/**
 * Servlet implementation class UserServlet
 */
@WebServlet({"/user/index","/user/login","/user/register","/user/logout"})
public class UserServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	UserService service = new UserServiceImpl();

    /**
     * Default constructor. 
     */
    public UserServlet() {
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		String path = request.getServletPath();
		
		if("/user/index".equals(path)) {
			
			List<User> list = service.findAll();
			request.setAttribute("list", list);
			request.getRequestDispatcher("views/client/index.jsp").forward(request, response);
		}
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		// doGet(request, response);
		
		String path = request.getServletPath();
		if("/user/login".equals(path)) {
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
		
		if("/user/register".equals(path)) {
			String fullName = request.getParameter("fullname");
			String phone = request.getParameter("phone");
			String email = request.getParameter("email");
	        String password = request.getParameter("password");
	        String confirmPassword = request.getParameter("confirmPassword");
	        
	        // service kiem tra dulieu 
	        //kiem tra trung  va tao User
	         User user = service.register(fullName, phone, email, password, confirmPassword);
	         
	         // dang ky that bai 
	         if(user == null) {
	        	 request.getAttribute("\"registerError\",\r\n"+ ""
	        	 		+ " \"Thông tin không hợp lệ hoặc số điện thoại/email đã tồn tại.\"");
	        	 request.setAttribute( "registerFullName", fullName );

	             request.setAttribute("registerPhone",phone );

	             request.setAttribute("registerEmail",email );

	             request.getRequestDispatcher("/home/index").forward(request, response);
	        	 
	        	 return;
	         }
	         HttpSession session = request.getSession();
	         session.setAttribute("user", user);

	         response.sendRedirect(request.getContextPath()+"/home/index");
	         return;
		}
		
		if ("/user/logout".equals(path)) {

	        // false nghĩa là không tạo session mới
	        // nếu session hiện tại không tồn tại
	        HttpSession session = request.getSession(false);

	        if (session != null) { 
	        	session.invalidate();
	        }

	        response.sendRedirect(request.getContextPath() +"/home/index" );

	        return;
	    }

	    // Không tìm thấy chức năng tương ứng
	    response.sendError( HttpServletResponse.SC_NOT_FOUND );
			}

	}
