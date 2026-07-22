<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/shared/home/page.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Home</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css"
          rel="stylesheet">

    <!-- Bootstrap Icons -->
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">

    <!-- CSS của bạn: phải đặt sau Bootstrap -->
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/index.css">
          
    
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
		<%@ include file="/layouts/banner.jsp" %>
		    
		    
		<!-- SECTION MENU(HÙNG) -->
		<section>
		
		</section>
		    
		    
		<!-- SECTION DEPARTMENTS(KA) -->
		<section>
			<%@ include file="/layouts/section-departments.jsp" %>
		</section>
		
		
	</main>
	
	<footer>
		<jsp:include page="/shared/home/footer.jsp"/>
	</footer>
	
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>