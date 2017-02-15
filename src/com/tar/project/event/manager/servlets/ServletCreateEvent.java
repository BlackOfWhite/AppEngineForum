package com.tar.project.event.manager.servlets;

import java.io.IOException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;
import com.tar.project.event.manager.dao.Dao;

@SuppressWarnings("serial")
public class ServletCreateEvent extends HttpServlet {
	private static final Logger log = Logger.getLogger(ServletCreateEvent.class.getName());

	public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		User user = (User) req.getAttribute("user");
		log.info("Creating event");
		if (user == null) {
			UserService userService = UserServiceFactory.getUserService();
			user = userService.getCurrentUser();
		}

		// Parse time
		String datePicker = ((req.getParameter("datepicker")) == null) ? "" : req.getParameter("datepicker");
		//String timePicker = ((req.getParameter("timepicker")) == null) ? "" : req.getParameter("timepicker");
		String summary = (req.getParameter("summary")) == null ? "" : req.getParameter("summary");
		
		DateFormat format = new SimpleDateFormat("MM/dd/yy");
		//DateFormat timeFormat = new SimpleDateFormat("hh:mm aa");
		Date date, time;
		try {
			date = format.parse(datePicker);
		   //time = timeFormat.parse(timePicker);
		   //date.setTime(time.getTime());
			Dao.INSTANCE.addEvent(user.getUserId(), summary, date);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		
		log.setLevel(Level.INFO);
		log("Event created!");

		resp.sendRedirect("/MainView.jsp");
	}
}