/**
 * <pre>
 * Copyright (c) 2015 K4M, Inc.
 * All right reserved.
 *
 * This software is the confidential and proprietary information of K4M, Inc. 
 * You shall not disclose such confidential information and
 * shall use it only in accordance with the terms of the license agreement
 * you entered into with K4M.
 * </pre>
 */
package com.k4m.dx.tcontrol.cmmn.serviceproxy.vo;


/**
 * @brief
 * 
 *        TODO add description
 * @date 2015. 4. 7.
 * @author Kim, Sunho
 */

public class AdminServerPasswordRequest extends AbstractJSONAwareModel {

	private String	oldPassword;

	private String	newPassword;

	private String	saltBase64;

	private int		iterationCount;

	public static AdminServerPasswordRequest fromString(String jsonString) {
		return fromString(jsonString, AdminServerPasswordRequest.class);
	}

	public String getOldPassword() {
		return oldPassword;
	}

	public void setOldPassword(String oldPassword) {
		this.oldPassword = oldPassword;
	}

	public String getNewPassword() {
		return newPassword;
	}

	public void setNewPassword(String newPassword) {
		this.newPassword = newPassword;
	}

	public String getSaltBase64() {
		return saltBase64;
	}

	public void setSaltBase64(String saltBase64) {
		this.saltBase64 = saltBase64;
	}

	public int getIterationCount() {
		return iterationCount;
	}

	public void setIterationCount(int iterationCount) {
		this.iterationCount = iterationCount;
	}
}
