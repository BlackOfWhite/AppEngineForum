package com.tar.project.event.manager.servlets;

import java.io.IOException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;
import com.tar.project.event.manager.dao.Dao;

@SuppressWarnings("serial")
public class ServletAddEventParticipant extends HttpServlet {
	public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		User user = (User) req.getAttribute("user");
		if (user == null) {
			UserService userService = UserServiceFactory.getUserService();
			user = userService.getCurrentUser();
		}
		String eventId = req.getParameter("eventId");
		Dao.INSTANCE.addParticipantToEvent(user.getUserId(), user.getEmail(), Long.parseLong(eventId));
		resp.sendRedirect("/EventDetailsView.jsp?eventId=" + eventId);
	}
}
