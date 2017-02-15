<%@page import="com.tar.project.event.manager.model.Participant"%>
<%@page import="com.tar.project.event.manager.constants.Properties"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="java.util.List"%>
<%@ page import="com.google.appengine.api.users.User"%>
<%@ page import="com.google.appengine.api.users.UserService"%>
<%@ page import="com.google.appengine.api.users.UserServiceFactory"%>
<%@ page import="com.google.appengine.api.datastore.KeyFactory"%>
<%@ page import="com.tar.project.event.manager.dao.*"%>
<%@ page import="com.tar.project.event.manager.model.*"%>
<%@ page import="javax.servlet.http.HttpServletResponse.*"%>
<%@page import="java.util.ArrayList"%>

<!DOCTYPE html>
<html>
<head>
<title>Grouper</title>

<link
	href="//netdna.bootstrapcdn.com/bootstrap/3.1.0/css/bootstrap.min.css"
	rel="stylesheet">
<script
	src="//netdna.bootstrapcdn.com/bootstrap/3.1.0/js/bootstrap.min.js"></script>
<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<link rel="stylesheet"
	href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<link rel="stylesheet" href="/resources/demos/style.css">
<meta charset="utf-8">
</head>
<body>
	<%
		Dao dao = Dao.INSTANCE;
		UserService userService = UserServiceFactory.getUserService();
		User user = userService.getCurrentUser();
		String url = userService.createLoginURL(request.getRequestURI());
		String urlLinktext = "Log in";
		List<Event> events = new ArrayList<Event>();
		events = dao.listEvents();

		if (user != null) {
			url = userService.createLogoutURL(request.getRequestURI());
			urlLinktext = "Log out";
		}
	%>
	<div class="container">
		<div style="width: 100%;">
			<div class="nav navbar-nav navbar-right">
				<span class="glyphicon glyphicon-user"></span>
				<%=(user == null ? "" : user.getNickname())%>
				<a href="<%=url%>"><%=urlLinktext%></a>
			</div>
			<div class="page-header">
				<h1>Grouper</h1>
			</div>
		</div>
		<div style="clear: both;"></div>
		<%
			if (user != null) {
				if (user.getEmail().equals(Properties.ADMIN_EMAIL_ADDRESS)) {//admin view
					response.sendRedirect("/AdminView.jsp");
				} else {
					response.sendRedirect("/SignedInUserView.jsp");
				}
			} else {
		%>

		<h2>Log in to join an event</h2>

		<table class="table default">
			<thead class="thead-inverse">
				<tr>
					<th>Contents</th>
					<th>Date</th>
				</tr>
			</thead>
			<tbody>
				<%
					for (Event event : events) {
				%>
				<tr>
					<td><%=event.getText()%></td>
					<td><%=event.getDate()%></td>
				</tr>
			</tbody>
			<%
				}
			%>
		</table>

		<%
			}
		%>
	</div>
</body>
</html>