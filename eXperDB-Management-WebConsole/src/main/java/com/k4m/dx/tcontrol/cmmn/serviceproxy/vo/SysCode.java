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

import com.google.gson.annotations.Expose;

/**
 * @brief
 * 
 *        TODO add description
 * @date 2015. 1. 8.
 * @author Kim, Sunho
 */

public class SysCode {

	@Expose
	private String	categoryKey;

	@Expose
	private String	sysCode;

	@Expose
	private String	sysCodeName;

	@Expose
	private String	sysCodeValue;

	private String	sysCodeNote;

	@Expose
	private int		displayOrder;

	@Expose
	private String	sysStatusCode;

	@Expose
	private String	extendedField;

	public String getCategoryKey() {
		return categoryKey;
	}

	public void setCategoryKey(String categoryKey) {
		this.categoryKey = categoryKey;
	}

	public String getSysCode() {
		return sysCode;
	}

	public void setSysCode(String sysCode) {
		this.sysCode = sysCode;
	}

	public String getSysCodeName() {
		return sysCodeName;
	}

	public void setSysCodeName(String sysCodeName) {
		this.sysCodeName = sysCodeName;
	}

	public String getSysCodeValue() {
		return sysCodeValue;
	}

	public void setSysCodeValue(String sysCodeValue) {
		this.sysCodeValue = sysCodeValue;
	}

	public String getSysCodeNote() {
		return sysCodeNote;
	}

	public void setSysCodeNote(String sysCodeNote) {
		this.sysCodeNote = sysCodeNote;
	}

	public int getDisplayOrder() {
		return displayOrder;
	}

	public void setDisplayOrder(int displayOrder) {
		this.displayOrder = displayOrder;
	}

	public String getSysStatusCode() {
		return sysStatusCode;
	}

	public void setSysStatusCode(String sysStatusCode) {
		this.sysStatusCode = sysStatusCode;
	}

	public String getExtendedField() {
		return extendedField;
	}

	public void setExtendedField(String extendedField) {
		this.extendedField = extendedField;
	}
}
