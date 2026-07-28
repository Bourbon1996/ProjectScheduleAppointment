package com.dhakcare.listeners;

import java.util.List;

import com.dhakcare.entity.Department;
import com.dhakcare.entity.Doctor;
import com.dhakcare.service.DepartmentService;
import com.dhakcare.service.DoctorService;
import com.dhakcare.service.impl.DepartmentServiceImpl;
import com.dhakcare.service.impl.DoctorServiceImpl;

import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

@WebListener
public class ParamListener implements ServletContextListener{
	@Override
    public void contextInitialized(ServletContextEvent sce) {
        
        try {
            
            DepartmentService departmentService = new DepartmentServiceImpl();
        	DoctorService doctorservice = new DoctorServiceImpl();
            
            List<Department> listDepartments = departmentService.getAllDepartmentParent();
            List<Department> listChildren = departmentService.getAllDepartmentChild();
            
            List<Doctor> listDoctor = doctorservice.getAll();
            
            
            
            
            
            ServletContext application = sce.getServletContext();
            
            // Tạo biến list chuyên khoa
            application.setAttribute("listDepartmentsParent", listDepartments);
            application.setAttribute("listDepartmentsChild", listChildren);
            
            // Tạo biến list bác sĩ
            application.setAttribute("listDoctor", listDoctor);
            
            
            System.out.println("✅ [WebListener] Đã tải thành công danh sách chuyên khoa và bác sĩ vào bộ nhớ!");
        } catch (Exception e) {
            System.out.println("❌ [WebListener] Lỗi khi tải danh sách: " + e.getMessage());
            e.printStackTrace();
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        // Hàm này chạy khi ông tắt Tomcat (Xóa bộ nhớ)
        System.out.println("🛑 [WebListener] Đã giải phóng bộ nhớ Application Scope.");
    }
}
