<%@page import="com.tar.project.event.manager.constants.Properties"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="java.util.List"%>
<%@ page import="com.google.appengine.api.users.User"%>
<%@ page import="com.google.appengine.api.users.UserService"%>
<%@ page import="com.google.appengine.api.users.UserServiceFactory"%>
<%@ page import="com.google.appengine.api.datastore.KeyFactory"%>
<%@ page import="com.tar.project.event.manager.dao.*"%>
<%@ page import="com.tar.project.event.manager.model.*"%>
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
			url = userService.createLogoutURL("/MainView.jsp"); //(request.getRequestURI());
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
			if (user != null && user.getEmail().equals(Properties.ADMIN_EMAIL_ADDRESS)) {//admin view
		%>

		<table class="table default">
			<thead class="thead-inverse">
				<tr>
					<th>Contents</th>
					<th>Date</th>
					<th>Participants</th>
				</tr>
			</thead>
			<tbody>
				<%
					for (Event event : events) {
				%>
				<tr>
					<td><%=event.getText()%></td>
					<td><%=event.getDate()%></td>
					<td><a href="/EventDetailsView.jsp?eventId=<%=event.getId()%>">
							<%=event.getParticipants().size()%>
					</a></td>
					<td><a class="btn btn-primary"
						href="/removeEvent?id=<%=event.getId()%>">Remove</a></td>
				</tr>
			</tbody>
			<%
				}
			%>
		</table>

		<div class="main">
			<h3>Create new event</h3>
			<form action="createEvent" method="post" accept-charset="utf-8">
				<div class="form-group">
					<label for="summary">Contents</label> <input type="text"
						name="summary" id="summary" class="form-control" /> <label
						for="datepicker">Date</label> <input type="text" id="datepicker"
						name="datepicker" class="form-control"> <br>
					<button type="submit" class="btn btn-primary">Create</button>
				</div>
			</form>
			<%
				}
			%>
		</div>
	</div>
</body>
</html>