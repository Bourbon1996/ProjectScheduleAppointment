<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<table boder = 1>
		<thead>
			<tr>
				<th>Id</th>
				<th>Fullname</th>
				<th>Phone</th>
				<th>Email</th>
				<th>Password</th>
				<th>Role</th>
			
			</tr>
			
			
		</thead>
	
	<tbody>
			<c:forEach var = "user" items = "${list}">
				<tr>
					<td>${user.id}</td>
					<td>${user.fullname}</td>
					<td>${user.phone}</td>
					<td>${user.email}</td>
					<td>${user.passwordHash}</td>
					<td>${user.role}</td>
				</tr> 
			</c:forEach>
	</tbody>
	
	</table>
</body>
</html>