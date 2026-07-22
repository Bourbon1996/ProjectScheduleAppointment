<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ include file="/shared/home/page.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Home</title>

    <!-- Bootstrap CSS: vẫn giữ để dùng cho navbar -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css"
          rel="stylesheet">

    <!-- Bootstrap Icons: dùng icon người dùng và icon con mắt -->
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">

    <!-- CSS trang chủ -->
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/index.css">

    <!-- CSS popup đăng nhập -->
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/auth.css">
</head>

<body>

    <!-- Thanh navbar có icon tài khoản -->
    <jsp:include page="/shared/home/header.jsp"/>

    <!-- Nội dung popup đăng nhập -->
    <jsp:include page="/shared/home/Auth.jsp"/>

    <!-- Bootstrap JS: vẫn có thể giữ cho navbar -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>

    <!-- JavaScript tự viết để mở và đóng popup -->
    <script src="${pageContext.request.contextPath}/js/auth.js"></script>

</body>
</html>