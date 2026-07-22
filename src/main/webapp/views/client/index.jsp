<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ include file="/shared/home/page.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Home</title>
    
    <!-- Cài đặt Favicon cho web -->
	<link rel="icon" type="image/png" href="${ctx}/img/logo.png">

    <!-- Bootstrap CSS: vẫn giữ để dùng cho navbar -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css"
          rel="stylesheet">

    <!-- Bootstrap Icons: dùng icon người dùng và icon con mắt -->
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">

    <!-- CSS trang chủ -->
    <link rel="stylesheet"
          href="${ctx}/css/client/index.css">
          
    <!-- CSS popup đăng nhập -->
    <link rel="stylesheet"
          href="${ctx}/css/client/auth.css">
          
    
	<link rel="preconnect" href="https://fonts.googleapis.com">
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
	
	<link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">

</head>

<body>

	<!-- HEADER(Q.ANH) -->
	<header>
		<jsp:include page="/shared/home/header.jsp"/>
	</header>

	<main>
		<!-- SECTION BANNER -->
		<section>
			<%@ include file="/layouts/client/banner.jsp" %>
		</section>
		    
		<!-- SECTION MENU(HÙNG) -->
		<section>
			<%@ include file="/layouts/client/section-menu.jsp" %>
		</section>
		    
		    
		<!-- SECTION DEPARTMENTS(KA) -->
		<section>
			<%@ include file="/layouts/client/section-departments.jsp" %>
		</section>
		
		
	</main>
	
	<footer>
		<jsp:include page="/shared/home/footer.jsp"/>
	</footer>

    <!-- Popup Auth -->
    <jsp:include page="/shared/home/Auth.jsp"/>
    
    
    
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>

<script src="${ctx}/js/auth.js"></script>