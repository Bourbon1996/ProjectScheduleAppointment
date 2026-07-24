package home;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

import departments.entity.Department;
import departments.service.DepartmentServiceImpl;

/**
 * Servlet implementation class HomeServlet
 */
@WebServlet({"/home/index", "/home/about", "/home/contact", "/home/departments", "/home/doctor"})
public class HomeServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public HomeServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		DepartmentServiceImpl departmentService = new DepartmentServiceImpl();
		
		List<Department> listDepartments = departmentService.getAllDepartmentParent();
		
		request.setAttribute("listDepartmentsParent", listDepartments);
		
		request.getRequestDispatcher("/views/client/index.jsp").forward(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
