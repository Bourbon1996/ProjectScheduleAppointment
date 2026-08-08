package com.dhakcare.servlet;

import java.io.IOException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import com.dhakcare.entity.Doctor;
import com.dhakcare.entity.DoctorScheduleSlot;
import com.dhakcare.service.DoctorScheduleSlotService;
import com.dhakcare.service.DoctorService;
import com.dhakcare.service.impl.DoctorScheduleSlotServiceImpl;
import com.dhakcare.service.impl.DoctorServiceImpl;
import com.dhakcare.utils.XPath;
/**
 * Servlet implementation class DoctorApiServlet
 */
import com.fasterxml.jackson.databind.ObjectMapper;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet({"/api/get-doctors", "/api/get-available-dates", "/api/get-unique-time-slots", "/api/resolve-slot"})
public class DoctorApiServlet extends HttpServlet {
    private DoctorService doctorService = new DoctorServiceImpl();
    private DoctorScheduleSlotService slotService = new DoctorScheduleSlotServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        if (XPath.is("/api/get-available-dates")) {
            String doctorIdStr = request.getParameter("doctorId");
            String deptIdStr = request.getParameter("deptId");
            String timeSlotStr = request.getParameter("timeSlot");
            List<String> availableDates = new java.util.ArrayList<>();
            LocalDate today = LocalDate.now();
            
            java.util.function.Predicate<DoctorScheduleSlot> filterPredicate = slot -> {
                if (slot.getWorkDate().isBefore(today)) return false;
                if (slot.getStatus() == com.dhakcare.enums.SlotStatus.CLOSED) return false;
                if (timeSlotStr != null && !timeSlotStr.isEmpty()) {
                    String slotTime = slot.getStartTime().toString() + " - " + slot.getEndTime().toString();
                    if (!slotTime.equals(timeSlotStr)) return false;
                }
                return true;
            };

            if (doctorIdStr != null && !doctorIdStr.isEmpty()) {
                Doctor doctor = doctorService.getById(Long.parseLong(doctorIdStr));
                if (doctor != null && doctor.getUser() != null) {
                    List<DoctorScheduleSlot> slots = slotService.findByDoctorUser(doctor.getUser());
                    availableDates.addAll(slots.stream()
                        .filter(filterPredicate)
                        .map(slot -> slot.getWorkDate().toString())
                        .distinct()
                        .collect(java.util.stream.Collectors.toList()));
                }
            } else if (deptIdStr != null && !deptIdStr.isEmpty()) {
                List<Doctor> docs = doctorService.getDoctorbyDeptId(deptIdStr);
                for (Doctor doc : docs) {
                    if (doc.getUser() != null) {
                        List<DoctorScheduleSlot> slots = slotService.findByDoctorUser(doc.getUser());
                        slots.stream()
                            .filter(filterPredicate)
                            .map(slot -> slot.getWorkDate().toString())
                            .forEach(d -> {
                                if (!availableDates.contains(d)) availableDates.add(d);
                            });
                    }
                }
            } else {
                List<Doctor> docs = doctorService.getAll();
                if (docs != null) {
                    for (Doctor doc : docs) {
                        if (doc.getUser() != null) {
                            List<DoctorScheduleSlot> slots = slotService.findByDoctorUser(doc.getUser());
                            if (slots != null) {
                                slots.stream()
                                    .filter(filterPredicate)
                                    .map(slot -> slot.getWorkDate().toString())
                                    .forEach(d -> {
                                        if (!availableDates.contains(d)) availableDates.add(d);
                                    });
                            }
                        }
                    }
                }
            }
            
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write(new ObjectMapper().writeValueAsString(availableDates));
            return;
        }

        if (XPath.is("/api/get-unique-time-slots")) {
            String doctorIdStr = request.getParameter("doctorId");
            String deptIdStr = request.getParameter("deptId");
            List<String> timeSlots = new java.util.ArrayList<>();
            LocalDate today = LocalDate.now();

            if (doctorIdStr != null && !doctorIdStr.isEmpty()) {
                Doctor doctor = doctorService.getById(Long.parseLong(doctorIdStr));
                if (doctor != null && doctor.getUser() != null) {
                    List<DoctorScheduleSlot> slots = slotService.findByDoctorUser(doctor.getUser());
                    timeSlots.addAll(slots.stream()
                        .filter(slot -> !slot.getWorkDate().isBefore(today))
                        .filter(slot -> slot.getStatus() != com.dhakcare.enums.SlotStatus.CLOSED)
                        .map(slot -> slot.getStartTime().toString() + " - " + slot.getEndTime().toString())
                        .distinct()
                        .sorted()
                        .collect(java.util.stream.Collectors.toList()));
                }
            } else if (deptIdStr != null && !deptIdStr.isEmpty()) {
                List<Doctor> docs = doctorService.getDoctorbyDeptId(deptIdStr);
                for (Doctor doc : docs) {
                    if (doc.getUser() != null) {
                        List<DoctorScheduleSlot> slots = slotService.findByDoctorUser(doc.getUser());
                        slots.stream()
                            .filter(slot -> !slot.getWorkDate().isBefore(today))
                            .filter(slot -> slot.getStatus() != com.dhakcare.enums.SlotStatus.CLOSED)
                            .map(slot -> slot.getStartTime().toString() + " - " + slot.getEndTime().toString())
                            .distinct()
                            .forEach(t -> {
                                if (!timeSlots.contains(t)) timeSlots.add(t);
                            });
                    }
                }
                java.util.Collections.sort(timeSlots);
            } else {
                List<Doctor> docs = doctorService.getAll();
                if (docs != null) {
                    for (Doctor doc : docs) {
                        if (doc.getUser() != null) {
                            List<DoctorScheduleSlot> slots = slotService.findByDoctorUser(doc.getUser());
                            if (slots != null) {
                                slots.stream()
                                    .filter(slot -> !slot.getWorkDate().isBefore(today))
                                    .filter(slot -> slot.getStatus() != com.dhakcare.enums.SlotStatus.CLOSED)
                                    .map(slot -> slot.getStartTime().toString() + " - " + slot.getEndTime().toString())
                                    .distinct()
                                    .forEach(t -> {
                                        if (!timeSlots.contains(t)) timeSlots.add(t);
                                    });
                            }
                        }
                    }
                }
                java.util.Collections.sort(timeSlots);
            }

            request.setAttribute("timeSlots", timeSlots);
            request.getRequestDispatcher("/site/layouts/ajax-time-slots.jsp").forward(request, response);
            return;
        }

        if (XPath.is("/api/resolve-slot")) {
            String dateStr = request.getParameter("date");
            String timeStr = request.getParameter("timeSlot");
            String doctorIdStr = request.getParameter("doctorId");
            
            if (dateStr != null && timeStr != null && doctorIdStr != null) {
                LocalDate date = LocalDate.parse(dateStr);
                List<DoctorScheduleSlot> slots = slotService.getByDoctorAndDate(doctorIdStr, date);
                for (DoctorScheduleSlot slot : slots) {
                    String sTime = slot.getStartTime().toString() + " - " + slot.getEndTime().toString();
                    if (sTime.equals(timeStr)) {
                        String json = String.format("{\"slotId\": \"%d\", \"doctorId\": \"%s\"}", slot.getId(), doctorIdStr);
                        response.setContentType("application/json;charset=UTF-8");
                        response.getWriter().write(json);
                        return;
                    }
                }
            }
            
            // Should not reach here if strictly enforced by frontend
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write("{}");
            return;
        }
        
        String deptId = request.getParameter("deptId");
        String workdateStr = request.getParameter("workdate"); 
        String filterDoctorId = request.getParameter("doctorId");
        
        LocalDate workdate = LocalDate.parse(workdateStr);
        
        List<Doctor> listDoctors = doctorService.getDoctorbyDeptId(deptId);
        
        if (filterDoctorId != null && !filterDoctorId.isEmpty()) {
            listDoctors.removeIf(doc -> doc.getId() != Long.parseLong(filterDoctorId));
        }
        
        for (Doctor doc : listDoctors) {
            
            List<DoctorScheduleSlot> slots = slotService.getByDoctorAndDate(String.valueOf(doc.getId()), workdate);
            doc.setSlots(slots);
        }
        
        
        request.setAttribute("listDoctors", listDoctors);
        
        
        String[] weekdays = {"Chủ Nhật", "Thứ 2", "Thứ 3", "Thứ 4", "Thứ 5", "Thứ 6", "Thứ 7"};
	    
	    int dow = workdate.getDayOfWeek().getValue() % 7; 
	
	    String formattedDateStr = String.format("%02d/%02d/%04d (%s)", 
	             workdate.getDayOfMonth(), 
	             workdate.getMonthValue(), 
	             workdate.getYear(), 
	             weekdays[dow]);
	
	    request.setAttribute("selectedDateStr", formattedDateStr);
        
        request.getRequestDispatcher("/site/layouts/ajax-doctor-list.jsp").forward(request, response);
    }
}
