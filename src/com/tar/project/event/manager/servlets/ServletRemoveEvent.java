package com.tar.project.event.manager.servlets;

import java.io.IOException;
import java.util.logging.Logger;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.tar.project.event.manager.dao.Dao;

public class ServletRemoveEvent extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static final Logger log = Logger.getLogger(ServletRemoveEvent.class.getName());

	// CHECK IF NULL, may throw exceptions
	public void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		String id = req.getParameter("id");
		Dao.INSTANCE.removeEvent(Long.parseLong(id));
		log.info("Deleting event.");
		resp.sendRedirect("/MainView.jsp");
	}
}
