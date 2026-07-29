<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ include file="/site/shared/page.jsp" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Đặt Lịch Khám</title>
	
		<link rel="icon" type="image/png" href="${ctx}/assets/img/logo.png">
	
	    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css"
	          rel="stylesheet">
	
	    <link rel="stylesheet"
	          href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">
	
	    <link rel="stylesheet"
	          href="${ctx}/assets/css/client/appointment.css">
	    <link rel="stylesheet"
	          href="${ctx}/assets/css/client/index.css">
	          
	    
		<link rel="preconnect" href="https://fonts.googleapis.com">
		<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
		
		<link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">

</head>
<body>
	<header>
		<jsp:include page="/site/shared/header.jsp"/>
	</header>
	
	
	<main>
	
		<jsp:include page="/site/layouts/appointment-section.jsp"/>
	
	</main>
	
	
	<footer>
		<jsp:include page="/site/shared/footer.jsp"/>
	</footer>

	<script src="${ctx}/assets/js/client/appointment.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>