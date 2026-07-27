<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ include file="/shared/home/page.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Quản lý bác sĩ</title>
<%@ include file="/shared/home/link.jsp" %>

<link rel="stylesheet" type="text/css" href="/css/client/doctor-manager.css">

</head>
<body>
	<%@ include file="/shared/home/header.jsp" %>
	
	<main>
		<!-- Quỳnh Anh làm ở đây -->
		<h1>Quản lý bác sĩ</h1>
		
		<div> 
			<ul>
				<li>Id</li>
				<li>Họ và tên</li>
				<li>Giới tính</li>
				<li>Email</li>
				<li>Chuyên khoa</li>
				<li>Bằng cấp(title)</li>
				<li>Số năm kinh nghiệm</li>
				<li>Tiền khám</li>
			</ul>
			<c:forEach items = "${listDoctor}" var = "doctor">
				
			</c:forEach>
		
		</div>
		
		
	</main>
	
	<%@ include file="/shared/home/footer.jsp" %>
</body>
</html>