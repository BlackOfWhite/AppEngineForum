package com.tar.project.event.manager.servlets;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Properties;
import java.util.logging.Logger;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.tar.project.event.manager.dao.Dao;
import com.tar.project.event.manager.model.Event;
import com.tar.project.event.manager.model.Participant;

@SuppressWarnings("serial")
public class ServletNotifications extends HttpServlet {
	private static final Logger log = Logger.getLogger(ServletNotifications.class.getName());

	public void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		List<Event> events = new ArrayList<Event>();
		List<Participant> users = new ArrayList<Participant>();
		events = Dao.INSTANCE.listEvents();
		log.warning("EVENTS SIZE: " + events.size());
		Date current = new Date();
		current.setHours(0);
		current.setMinutes(0);
		current.setSeconds(0);
		for (Event event : events) {
			log.warning("Event date: " + event.getDate() + ", current date: " + current);
			log.warning("Comparison: " + event.getDate().compareTo(current));
			if (event.getDate().getDate() == current.getDate() && event.getDate().getMonth() == current.getMonth()
					&& event.getDate().getYear() == current.getYear()) {
				log.warning("Date condition passed: " + event.getDate());
				users = event.getParticipants();
				for (Participant participant : users) {
					try {
						String recipient = participant.getName();
						Session session = Session.getDefaultInstance(new Properties(), null);
						Message msg = new MimeMessage(session);
						msg.setFrom(new InternetAddress(
								com.tar.project.event.manager.constants.Properties.ADMIN_EMAIL_ADDRESS,
								"Grouper Manager"));
						msg.addRecipient(Message.RecipientType.TO, new InternetAddress(recipient, "Participant"));
						msg.setSubject("Grouper - Event notification");
						msg.setText("Don't forget about today's event!\n\n\"" + event.getText() + "\"");
						Transport.send(msg);
						log.warning("Message sent");
					} catch (MessagingException e) {
						log.warning("Error while sending message!");
						e.printStackTrace();
					}
				}
				break;
			}
		}
		resp.sendRedirect("/MainView.jsp");
	}
}
