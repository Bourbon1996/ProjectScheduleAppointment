package com.dhakcare.listeners;

import java.util.List;

import com.dhakcare.entity.Department;
import com.dhakcare.service.impl.DepartmentServiceImpl;

import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

@WebListener
public class DepartmentListener implements ServletContextListener{
	@Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("⏳ [WebListener] Đang tải danh sách Chuyên khoa vào Application Scope...");
        
        try {
            
            DepartmentServiceImpl departmentService = new DepartmentServiceImpl();
            List<Department> listDepartments = departmentService.getAllDepartmentParent();
            List<Department> listChildren = departmentService.getAllDepartmentChild();
            
            
            // 🔥 2. ĐƯA VÀO APPLICATION SCOPE (Bộ nhớ toàn cục của web)
            ServletContext application = sce.getServletContext();
            
            application.setAttribute("listDepartmentsParent", listDepartments);
            application.setAttribute("listDepartmentsChild", listChildren);
            
            System.out.println("✅ [WebListener] Đã tải thành công " + listDepartments.size() + " chuyên khoa vào bộ nhớ!");
        } catch (Exception e) {
            System.out.println("❌ [WebListener] Lỗi khi tải chuyên khoa: " + e.getMessage());
            e.printStackTrace();
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        // Hàm này chạy khi ông tắt Tomcat (Xóa bộ nhớ)
        System.out.println("🛑 [WebListener] Đã giải phóng bộ nhớ Application Scope.");
    }
}
