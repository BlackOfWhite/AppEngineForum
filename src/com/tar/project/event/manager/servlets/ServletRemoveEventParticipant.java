package com.tar.project.event.manager.servlets;

import java.io.IOException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.tar.project.event.manager.dao.Dao;

public class ServletRemoveEventParticipant extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		String id = req.getParameter("id");
		Dao.INSTANCE.removeParticipantFromEvent(id);
		String eventId = req.getParameter("eventId");
		resp.sendRedirect("/EventDetailsView.jsp?eventId=" + eventId);
		//resp.sendRedirect("/MainView.jsp");
	}
}