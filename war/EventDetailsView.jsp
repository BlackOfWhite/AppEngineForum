<%@page import="com.tar.project.event.manager.constants.Properties"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="java.util.List"%>
<%@ page import="com.google.appengine.api.users.User"%>
<%@ page import="com.google.appengine.api.users.UserService"%>
<%@ page import="com.google.appengine.api.users.UserServiceFactory"%>
<%@ page import="com.tar.project.event.manager.dao.*"%>
<%@ page import="com.tar.project.event.manager.model.*"%>
<%@ page import="com.google.appengine.api.datastore.KeyFactory"%>

<!DOCTYPE html>

<%@page import="java.util.ArrayList"%>

<html>
<head>
<title>Grouper</title>
<link
	href="//netdna.bootstrapcdn.com/bootstrap/3.1.0/css/bootstrap.min.css"
	rel="stylesheet">
<script
	src="//netdna.bootstrapcdn.com/bootstrap/3.1.0/js/bootstrap.min.js"></script>
<meta charset="utf-8">
</head>
<body>
	<div class="container">
		<%
			Dao dao = Dao.INSTANCE;

			UserService userService = UserServiceFactory.getUserService();
			User user = userService.getCurrentUser();

			String url = userService.createLoginURL(request.getRequestURI());
			String urlLinktext = "Login";
			List<Participant> participants = new ArrayList<Participant>();
			String eventId = request.getParameter("eventId");

			if (user != null) {
				url = userService.createLogoutURL("/MainView.jsp"); //(request.getRequestURI());
				urlLinktext = "Logout";
				participants = dao.getEventParticipants(Long.parseLong(eventId));
			}
		%>
		<div class="nav navbar-nav navbar-right">
			<span class="glyphicon glyphicon-user"></span>
			<%=(user == null ? "" : user.getNickname())%>
			<a href="<%=url%>"><%=urlLinktext%></a>
		</div>
		<div class="page-header">
			<h1>Grouper</h1>
		</div>
		<h2>Participants</h2>
		<table class="table default">
			<thead class="thead-inverse">
				<tr>
					<th>ID</th>
					<th>Email</th>
				</tr>
			</thead>
			<tbody>

				<%
					for (Participant p : participants) {
				%>
				<tr>
					<td><%=p.getPId()%></td>
					<td><%=p.getName()%></td>
					<%
						if (user.getEmail().equals(Properties.ADMIN_EMAIL_ADDRESS) || p.getPId().equals(user.getUserId())) {
					%>
					<td><a class="btn btn-primary"
						href="/removeEventParticipant?id=<%=KeyFactory.keyToString(p.getKey())%>&eventId=<%=eventId%>">Sign
							Out</a></td>
					<%
						}
					%>
				</tr>
				<%
					}
				%>
			</tbody>
		</table>
		<hr>
		<%
			if (user != null) {
				boolean alreadySigned = false;
				for (Participant p1 : participants) {
					if (p1.getPId().equals(user.getUserId())) {
						alreadySigned = true;
					}
				}
				if (!alreadySigned) {
		%>
		<form action="/addEventParticipant?eventId=<%=eventId%>" method="post"
			accept-charset="utf-8">
			<input type="submit" value="Sign up" class="btn btn-primary" />
		</form>
		<p></p>

		<form action="/MainView.jsp" class="fixedButton">
			<input type="submit" value="Back" class="btn btn-primary" />
		</form>
		<%
			} else {
		%>

		<form action="/addEventParticipant?eventId=<%=eventId%>" method="post"
			accept-charset="utf-8">
			<input type="submit" value="Sign up" class="btn btn-primary"
				disabled="" />
		</form>
		<p></p>

		<form action="/MainView.jsp" class="fixedButton">
			<input type="submit" value="Back" class="btn btn-primary" />
		</form>
		<%
			}

			} else {
		%>

		Please login with your Google account

		<%
			}
		%>
	</div>
</body>
</html>