<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ include file="/shared/home/page.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Danh sách bác sĩ</title>

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
</head>
<body>
	<%@ include file="/shared/home/header.jsp" %>
	
	<main>
		<h1>Danh sách bác sĩ</h1>
		
		<div> 
			<c:forEach items = "${listDoctor}" var = "doctor">
				<article>
					<div>
						<img alt="Hình ảnh bác sĩ ${doctor.user.fullName}" src="${ctx}/${doctor.avtUrl}">
					</div>
					
					<div>
						<div>${doctor.title}</div>
						<div>${doctor.user.fullName}</div>
						<div>${doctor.department.name}</div>
					</div>
					
					<div>
						<a href = "${ctx}/doctor/detail/${doctor.id}">Xem hồ sơ</a>
						<a href = "${ctx}/appointment/${doctor.id}">Đặt lịch khám</a>
					</div>
				</article>
			</c:forEach>
		
		</div>
	</main>
	
	<%@ include file="/shared/home/footer.jsp" %>
</body>
</html>