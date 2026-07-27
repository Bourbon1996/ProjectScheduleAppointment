package com.dhakcare.servlet;

import java.io.IOException;

import com.dhakcare.entity.Doctor;
import com.dhakcare.service.DoctorService;
import com.dhakcare.service.impl.DoctorServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class PaymentServlet
 */
@WebServlet({"/doctor", "/doctor/detail/*"})
public class DoctorsServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private DoctorService doctorservice = new DoctorServiceImpl();

    /**
     * Default constructor. 
     */
    public DoctorsServlet() {
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		String path = request.getServletPath();
	    
	    if (path.equals("/doctor/detail")) {
	        String pathInfo = request.getPathInfo();
	        
	        // Kiểm tra an toàn: Đảm bảo pathInfo không null và có độ dài > 1 (ví dụ: "/1")
	        if (pathInfo != null && pathInfo.length() > 1) {
	            String idStr = pathInfo.substring(1); // Cắt bỏ dấu "/" để lấy chuỗi ID
	            
	            try {
	                // LƯU Ý: Nếu ID của bác sĩ trong DB là kiểu Long/Integer, hãy bỏ comment dòng dưới:
	                // Long id = Long.parseLong(idStr);
	                // Doctor doctor = doctorservice.getById(id);
	                
	                // Hiện tại code của bạn đang dùng String ID:
	                Doctor doctor = doctorservice.getById(idStr);
	                
	                if (doctor != null) {
	                    request.setAttribute("doctor", doctor);
	                    request.getRequestDispatcher("/views/client/doctor-detail.jsp").forward(request, response);
	                    return;
	                }
	            } catch (NumberFormatException e) {
	                // Chặn trường hợp ID trên URL không phải là số hợp lệ (ví dụ: /doctor/detail/abc)
	                System.out.println("ID bác sĩ không hợp lệ: " + idStr);
	            }
	        }
	        
	        // Nếu không tìm thấy bác sĩ hoặc URL thiếu ID, tự động quay về trang danh sách bác sĩ
	        response.sendRedirect(request.getContextPath() + "/doctor");
	        return;
	    }
	    
	    // Mặc định hiển thị trang danh sách bác sĩ
	    request.getRequestDispatcher("/views/client/doctor.jsp").forward(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
