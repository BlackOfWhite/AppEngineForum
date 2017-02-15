package com.tar.project.event.manager.model;

import java.util.Date;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.ManyToOne;

import com.google.appengine.api.datastore.Key;

@Entity
public class Participant {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Key key;

	@ManyToOne(cascade = CascadeType.ALL)
	private Event event;
	private String pId;
	private String pName;
	private String eventName;
	private Date eventDate;

	public Participant(String pId, String pName, String eventName, Date eventDate) {
		this.pId = pId;
		this.pName = pName;
		this.eventName = eventName;
		this.eventDate = eventDate;
	}

	public Key getKey() {
		return key;
	}

	public void setKey(Key key) {
		this.key = key;
	}

	public String getPId() {
		return pId;
	}

	public void setForumUserId(String pId) {
		this.pId = pId;
	}

	public String getName() {
		return pName;
	}

	public void setName(String pName) {
		this.pName = pName;
	}

	public Event getEvent() {
		return event;
	}

	public void setEvent(Event adminEvent) {
		this.event = adminEvent;
	}

	public String getEventName() {
		return eventName;
	}

	public void setEventName(String eventName) {
		this.eventName = eventName;
	}

	public Date getEventDate() {
		return eventDate;
	}

	public void setEventDate(Date eventDate) {
		this.eventDate = eventDate;
	}

}
