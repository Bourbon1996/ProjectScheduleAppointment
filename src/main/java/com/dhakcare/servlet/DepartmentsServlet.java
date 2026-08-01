package com.dhakcare.servlet;

import java.io.IOException;
import java.math.BigDecimal;

import com.dhakcare.entity.Department;
import com.dhakcare.service.DepartmentService;
import com.dhakcare.service.impl.DepartmentServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

/**
 * Servlet implementation class PaymentServlet
 */
@MultipartConfig
@WebServlet({"/department", "/department/update"})
public class DepartmentsServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private DepartmentService departmentservice = new DepartmentServiceImpl();

    /**
     * Default constructor. 
     */
    public DepartmentsServlet() {
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		String path = request.getServletPath();
		if (path.equals("/department/update")) {
			
			//1. Lấy id từ From
			Long id = Long.parseLong(request.getParameter("id"));
			
			//2. Tìm department cũ trong database
			Department department = departmentservice.findById(id);
			if (department == null) {
				response.sendRedirect(request.getContextPath() + "/admin/department");
				return;
			}
			
			//3. Lấy dữ liệu mới từ From
			String name = request.getParameter("name");
			String description = request.getParameter("description");
			String status = request.getParameter("status");
			Part imagePart = request.getPart("imageFile");
			String basePrice = request.getParameter("basePrice");
			String parentId = request.getParameter("parentId");
			
			Department parent = departmentservice.findById(Long.parseLong(parentId));
			
			//4. Gán dữ liệu mới vào department cũ
			department.setName(name);
			department.setDescription(description);
			department.setStatus(status);
			department.setParent(parent);
			department.setBasePrice(new BigDecimal(basePrice.trim()));
			if (imagePart != null
			        && imagePart.getSize() > 0
			        && imagePart.getSubmittedFileName() != null
			        && !imagePart.getSubmittedFileName().trim().isEmpty()) {

			    String newImageUrl =
			            saveDepartmentImage(imagePart);

			    department.setImageUrl(newImageUrl);
			}
			
			
			//5. Cập nhật database
			departmentservice.update(department);
			
			//6.Quay lại trang
			response.sendRedirect(request.getContextPath() + "/admin/department");
		} esle if (path.equals("/department/create")) {
			
			//1. Lấy id từ From
			Long id = Long.parseLong(request.getParameter("id"));
			
			//2. Tìm department cũ trong database
			Department department = departmentservice.findById(id);
			if (department == null) {
				response.sendRedirect(request.getContextPath() + "/admin/department");
				return;
			}
			
			//3. Lấy dữ liệu mới từ From
			String name = request.getParameter("name");
			String description = request.getParameter("description");
			String status = request.getParameter("status");
			Part imagePart = request.getPart("imageFile");
			String basePrice = request.getParameter("basePrice");
			String parentId = request.getParameter("parentId");
			
			Department parent = departmentservice.findById(Long.parseLong(parentId));
			
			//4. Gán dữ liệu mới vào department cũ
			department.setName(name);
			department.setDescription(description);
			department.setStatus(status);
			department.setParent(parent);
			department.setBasePrice(new BigDecimal(basePrice.trim()));
			if (imagePart != null
			        && imagePart.getSize() > 0
			        && imagePart.getSubmittedFileName() != null
			        && !imagePart.getSubmittedFileName().trim().isEmpty()) {

			    String newImageUrl =
			            saveDepartmentImage(imagePart);

			    department.setImageUrl(newImageUrl);
			}
			
			
			//5. Cập nhật database
			departmentservice.create(department);
			
			//6.Quay lại trang
			response.sendRedirect(request.getContextPath() + "/admin/department");
		}
	}
	
	private String saveDepartmentImage(Part imagePart)
	        throws IOException {

	    String originalFileName =
	            imagePart.getSubmittedFileName();

	    originalFileName = java.nio.file.Paths
	            .get(originalFileName)
	            .getFileName()
	            .toString();

	    int dotIndex =
	            originalFileName.lastIndexOf(".");

	    if (dotIndex == -1) {
	        throw new IllegalArgumentException(
	            "File ảnh không có phần mở rộng"
	        );
	    }

	    String extension =
	            originalFileName
	                .substring(dotIndex)
	                .toLowerCase();

	    if (!extension.equals(".jpg")
	            && !extension.equals(".jpeg")
	            && !extension.equals(".png")
	            && !extension.equals(".webp")) {

	        throw new IllegalArgumentException(
	            "Chỉ chấp nhận ảnh JPG, JPEG, PNG hoặc WEBP"
	        );
	    }

	    String newFileName =
	            java.util.UUID.randomUUID()
	            + extension;

	    String uploadPath =
	            getServletContext().getRealPath(
	            	"/assets/img/departments"
	            );

	    if (uploadPath == null) {
	        throw new IOException(
	            "Không xác định được thư mục lưu ảnh"
	        );
	    }

	    java.nio.file.Path uploadDirectory =
	            java.nio.file.Paths.get(uploadPath);

	    java.nio.file.Files.createDirectories(
	        uploadDirectory
	    );

	    java.nio.file.Path targetFile =
	            uploadDirectory.resolve(newFileName);

	    try (java.io.InputStream inputStream =
	            imagePart.getInputStream()) {

	        java.nio.file.Files.copy(
	            inputStream,
	            targetFile,
	            java.nio.file.StandardCopyOption.REPLACE_EXISTING
	        );
	    }

	    /*
	     * Database sẽ lưu:
	     * /images/departments/ten-anh.jpg
	     */
	    return "/assets/img/departments/" + newFileName;
	}
}
