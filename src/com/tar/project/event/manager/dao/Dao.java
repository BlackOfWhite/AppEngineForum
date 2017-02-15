package com.tar.project.event.manager.dao;

import java.util.Date;
import java.util.List;
import java.util.logging.Logger;

import javax.persistence.EntityManager;
import javax.persistence.Query;

import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.tar.project.event.manager.model.Event;
import com.tar.project.event.manager.model.Participant;

public enum Dao {
	INSTANCE;
	private static final Logger log = Logger.getLogger(Dao.class.getName());

	public List<Event> listEvents() {
		//log.info("Your information log message");
		//log.warning("Your warning log message");
		//log.severe("Your severe log message");
		EntityManager em = EMFService.get().createEntityManager();
		// read the existing entries
		Query q = em.createQuery("select m from Event m");
		return q.getResultList();
	}

	public void addEvent(String userId, String text, Date date) {
		synchronized (this) {
			EntityManager em = EMFService.get().createEntityManager();
			Event event = new Event(userId, text, date);
			em.persist(event);
			em.close();
		}
	}

	// WTF
	public List<Event> getEvents(String userId) {
		EntityManager em = EMFService.get().createEntityManager();
		Query q = em.createQuery("select t from Event t where t.author = :userId");
		q.setParameter("userId", userId);
		return q.getResultList();
	}

	// WAS without *Id
	public List<Participant> getParticipantEvents(String userId) {
		EntityManager em = EMFService.get().createEntityManager();
		Query q = em.createQuery("select t from Participant t where t.pId = :userId");
		q.setParameter("userId", userId);
		return q.getResultList();
	}

	public void removeEvent(long id) {
		EntityManager em = EMFService.get().createEntityManager();
		try {
			Event adminEvent = em.find(Event.class, id);
			em.remove(adminEvent);
			log.info("Your information log message");
			log.warning("Your warning log message");
			log.severe("Your severe log message");
		} finally {
			em.close();
		}
	}

	public void removeParticipantFromEvent(String id) {
		EntityManager em = EMFService.get().createEntityManager();
		Key key = KeyFactory.stringToKey(id);
		try {
			Participant user = em.find(Participant.class, key);
			em.remove(user);
		} finally {
			em.close();
		}
	}

	// TO DO TO REMOVE
	public List<Participant> listEventParticipants() {
		EntityManager em = EMFService.get().createEntityManager();
		// read the existing entries
		Query q = em.createQuery("select m from Participant m");
		List<Participant> users = q.getResultList();
		log.info("Your information log message");
		log.warning("Your warning log message");
		log.severe("Your severe log message");
		return users;
	}

	public void addParticipantToEvent(String text, String username, long eventId) {
		synchronized (this) {
			EntityManager em = EMFService.get().createEntityManager();
			Event event = em.find(Event.class, eventId);
			Participant user = new Participant(text, username, event.getText(), event.getDate());
			event.getParticipants().add(user);
			em.close();
		}
	}

	public List<Participant> getEventParticipants(long eventId) {
		EntityManager em = EMFService.get().createEntityManager();
		Event event = em.find(Event.class, eventId);
		return event.getParticipants();
	}

}
