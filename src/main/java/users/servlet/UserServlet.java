package users.servlet;

import java.io.IOException;
import java.util.List;



import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import users.entity.User;
import users.service.UserService;
import users.service.UserServiceImpl;


/**
 * Servlet implementation class UserServlet
 */
@WebServlet({"/user/index","/user/login"})
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
			}

	}
