package com.dhakcare.servlet;

import java.io.IOException;
import java.util.List;

import com.dhakcare.entity.Department;
import com.dhakcare.entity.Doctor;
import com.dhakcare.service.DepartmentService;
import com.dhakcare.service.DoctorService;
import com.dhakcare.service.impl.DepartmentServiceImpl;
import com.dhakcare.service.impl.DoctorServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/chuyen-khoa/*")
public class ClientDepartmentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private DepartmentService departmentService = new DepartmentServiceImpl();
    private DoctorService doctorService = new DoctorServiceImpl();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        if (pathInfo != null && pathInfo.length() > 1) {
            String deptIdStr = pathInfo.substring(1);
            try {
                Long deptId = Long.parseLong(deptIdStr);
                Department department = departmentService.findById(deptId);
                
                if (department != null) {
                    List<Doctor> listDoctor = doctorService.getDoctorbyDeptId(deptIdStr);
                    request.setAttribute("department", department);
                    request.setAttribute("listDoctor", listDoctor);
                    
                    List<Department> listDepartments = departmentService.getAllDepartmentParent();
                    List<Department> listChildren = departmentService.getAllDepartmentChild();
                    request.setAttribute("listDepartmentsParent", listDepartments);
                    request.setAttribute("listDepartmentsChild", listChildren);
                    
                    request.getRequestDispatcher("/site/views/department-detail.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                // Ignore and redirect to home
            }
        }
        response.sendRedirect(request.getContextPath() + "/home/index");
    }
}
