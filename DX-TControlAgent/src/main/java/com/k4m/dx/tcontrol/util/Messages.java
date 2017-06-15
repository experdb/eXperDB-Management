package com.k4m.dx.tcontrol.util;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.support.MessageSourceAccessor;

public class Messages {


	 private static final Logger logger = LoggerFactory.getLogger(Messages.class);
	
	
	private MessageSourceAccessor messageSourceAccessor;
	
	private static Messages instance = new Messages();
	
	private Messages() {
	}

	public MessageSourceAccessor getMessageSourceAccessor() {
		return messageSourceAccessor;
	}

	public void setMessageSourceAccessor(MessageSourceAccessor messageSourceAccessor) {
		this.messageSourceAccessor = messageSourceAccessor;
	}

	public String getString(String code, String defaultMessage){
		try{
			return messageSourceAccessor.getMessage(code);
		}
		catch(Exception e){
			logger.error("cann't load message ["+code+"]", e);
		}
		return defaultMessage;
	}	

	public static synchronized Messages getInstance(){
		return instance;
	}
	public static synchronized Messages getInstance(MessageSourceAccessor messageSourceAccessor){
		instance.setMessageSourceAccessor(messageSourceAccessor);
		return instance;
	}

	public static String getString(String key) {
		return getMessage(key);
	}

	public static String getMessage(String code){
		return getMessage(code, "");
	}
	
	public static String getMessage(String code, String defaultMessage){
		return Messages.getInstance().getString(code, defaultMessage);
	}
	
}
