package com.k4m.dx.tcontrol.cmmn.rest.service;

import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.AbstractJSONAwareModel;

public class TestVO extends AbstractJSONAwareModel {
	private String testMessage;

	public String getTestMessage() {
		return testMessage;
	}

	public void setTestMessage(String testMessage) {
		this.testMessage = testMessage;
	}
	
	

}
