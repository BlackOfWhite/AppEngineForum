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
<script>
	$(function() {
		$("#datepicker").datepicker()
	});
</script>
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
			url = userService.createLogoutURL("/MainView.jsp");
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
			if (user != null && !user.getEmail().equals(Properties.ADMIN_EMAIL_ADDRESS)) {
		%>
		<h3>All events</h3>
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
					<%
						boolean signed = false;
								String key = "";
								List<Participant> participants = event.getParticipants();
								for (Participant p1 : participants) {
									if (user.getUserId().equals(p1.getPId())) {
										signed = true;
										key = KeyFactory.keyToString(p1.getKey());
									}
								}
								if (!signed) {
					%>

					<td>
						<form action="/addEventParticipant?eventId=<%=event.getId()%>"
							method="post" accept-charset="utf-8">
							<input type="submit" value="Sign Up" class="btn btn-primary" />
						</form>
					</td>
					<%
						} else {
					%>
					<td><a class="btn btn-primary"
						href="/removeEventParticipant?id=<%=key%>&eventId=<%=event.getId()%>">Sign Out</a></td>
					
					<%
						}
					%>
				</tr>
			</tbody>
			<%
				}
			%>
		</table>

		<h3>Saved events</h3>
		<table class="table default">
			<%
				List<Participant> savedEvents = dao.getParticipantEvents(user.getUserId());
			%>
			<thead class="thead-inverse">
				<tr>
					<th>Contents</th>
					<th>Date</th>
				</tr>
			</thead>
			<tbody>
				<%
					for (Participant p2 : savedEvents) {
				%>
				<tr>
					<td><%=p2.getEventName()%></td>
					<td><%=p2.getEventDate()%></td>
				</tr>
				<%
					}
				%>
			</tbody>
		</table>
		<%
			}
		%>
	</div>
</body>
</html>