/**
 * <pre>
 * Copyright (c) 2014 K4M, Inc.
 * All right reserved.
 *
 * This software is the confidential and proprietary information of K4M, Inc. 
 * You shall not disclose such confidential information and
 * shall use it only in accordance with the terms of the license agreement
 * you entered into with K4M.
 * </pre>
 */
package com.k4m.dx.tcontrol.cmmn.serviceproxy.vo;

import net.sf.json.JSONObject;

import com.google.gson.annotations.Expose;

/**
 * TODO add description
 * @date 2014. 12. 27.
 * @author Kim, Sunho
 */

public class Profile extends AbstractPageModel {

	@Expose
	private String		profileUid;

	@Expose
	private String		profileName;

	@Expose
	private String		profileTypeCode;

	@Expose
	private String		profileTypeName;

	@Expose
	private String		profileNote;

	@Expose
	private String		profileStatusCode;

	@Expose
	private String		profileStatusName;

	@Expose
	private String		profileExtendedField;

	private JSONObject	profileExtendedFieldObject;

	public String getProfileUid() {
		return profileUid;
	}

	public void setProfileUid(String profileUid) {
		this.profileUid = profileUid;
	}

	public String getProfileName() {
		return profileName;
	}

	public void setProfileName(String profileName) {
		this.profileName = profileName;
	}

	public String getProfileTypeCode() {
		return profileTypeCode;
	}

	public void setProfileTypeCode(String profileTypeCode) {
		this.profileTypeCode = profileTypeCode;
	}

	public String getProfileTypeName() {
		return profileTypeName;
	}

	public void setProfileTypeName(String profileTypeName) {
		this.profileTypeName = profileTypeName;
	}

	public String getProfileNote() {
		return profileNote;
	}

	public void setProfileNote(String profileNote) {
		this.profileNote = profileNote;
	}

	public String getProfileStatusCode() {
		return profileStatusCode;
	}

	public void setProfileStatusCode(String profileStatusCode) {
		this.profileStatusCode = profileStatusCode;
	}

	public String getProfileStatusName() {
		return profileStatusName;
	}

	public void setProfileStatusName(String profileStatusName) {
		this.profileStatusName = profileStatusName;
	}

	public String getProfileExtendedField() {
		return profileExtendedField;
	}

	public void setProfileExtendedField(String jsonString) {
		this.profileExtendedField = jsonString;
		if (jsonString != null && "".equals(jsonString)) {
			//this.profileExtendedFieldObject = (JSONObject) JSONSerializer.toJSON(jsonString);
		} else {
			//this.profileExtendedFieldObject = null;
		}
	}

	public JSONObject getProfileExtendedFieldObject() {
		return profileExtendedFieldObject;
	}

	public void setProfileExtendedFieldObject(JSONObject obj) {
		this.profileExtendedFieldObject = obj;
		if (obj != null) {
			this.profileExtendedField = obj.toString();
		} else {
			this.profileExtendedField = null;
		}
	}

	public static Profile fromString(String jsonString) {
		return fromString(jsonString, Profile.class);
	}
}
