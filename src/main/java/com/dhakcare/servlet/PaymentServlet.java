package com.dhakcare.servlet;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
            
            // --- BẮT ĐẦU: Xác minh chữ ký VNPay ---
            // Lấy tất cả tham số VNPay trả về (trừ vnp_SecureHash)
            Map<String, String> fields = new HashMap<>();
            Enumeration<String> params = request.getParameterNames();
            while (params.hasMoreElements()) {
                String fieldName = params.nextElement();
                String fieldValue = request.getParameter(fieldName);
                if (fieldValue != null && !fieldValue.isEmpty()
                        && !fieldName.equals("vnp_SecureHash") 
                        && !fieldName.equals("vnp_SecureHashType")
                        && !fieldName.equals("action")) {
                    fields.put(fieldName, URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
                }
            }

            // Tính lại chữ ký từ các tham số nhận được
            String signValue = VNPayConfig.hashAllFields(fields);
            // Lấy chữ ký VNPay gửi về
            String vnpSecureHash = request.getParameter("vnp_SecureHash");
            
            String responseCode = request.getParameter("vnp_ResponseCode");
            String txnRef = request.getParameter("vnp_TxnRef");

            // So sánh chữ ký: nếu khớp → dữ liệu chưa bị giả mạo
            if (signValue != null && signValue.equals(vnpSecureHash)) {
                if ("00".equals(responseCode)) {
                    paymentService.updatePaymentSuccess(txnRef);
                    response.sendRedirect(request.getContextPath() + "/appointment?status=success&code=" + txnRef);
                } else {
                    response.sendRedirect(request.getContextPath() + "/appointment?status=failed");
                }
            } else {
                // Chữ ký không khớp → dữ liệu bị giả mạo!
                System.err.println("VNPay: Chữ ký không hợp lệ! txnRef=" + txnRef);
                response.sendRedirect(request.getContextPath() + "/appointment?status=failed");
            }
            // --- KẾT THÚC: Xác minh chữ ký VNPay ---
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