package com.dhakcare.servlet;

import java.io.IOException;

import com.dhakcare.service.PaymentService;
import com.dhakcare.service.impl.PaymentServiceImpl;
import com.dhakcare.utils.VNPayConfig;
import com.dhakcare.utils.VNPayUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/payment")
public class PaymentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private PaymentService paymentService = new PaymentServiceImpl();

    public PaymentServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        String action = request.getParameter("action");

        if ("vnpay_return".equals(action)) {
           
            String responseCode = request.getParameter("vnp_ResponseCode");
            String txnRef = request.getParameter("vnp_TxnRef");

            if ("00".equals(responseCode)) {
            	
            		paymentService.updatePaymentSuccess(txnRef);
            		
                response.sendRedirect(request.getContextPath() + "/appointment?status=success&code=" + txnRef);
            } else {
                
                response.sendRedirect(request.getContextPath() + "/appointment?status=failed");
            }
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("create_vnpay".equals(action)) {
           
            String amountStr = request.getParameter("amount");
            double amount = amountStr != null ? Double.parseDouble(amountStr) : 150000;
            
            String vnp_TxnRef = VNPayConfig.getRandomNumber(8);

            String paymentUrl = VNPayUtil.createPaymentUrl(amount, vnp_TxnRef, request);
            
            if (paymentUrl != null) {
                response.sendRedirect(paymentUrl);
            } else {
                response.getWriter().write("Lỗi tạo đường dẫn thanh toán VNPAY!");
            }
        }
    }
}