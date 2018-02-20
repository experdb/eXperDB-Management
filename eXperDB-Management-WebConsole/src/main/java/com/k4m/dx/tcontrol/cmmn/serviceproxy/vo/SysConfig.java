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
 * @date 2015. 2. 3.
 * @author Kim, Sunho
 */

public class SysConfig extends AbstractManagedModel {
	@Expose
	private String	configKey;

	@Expose
	private String	valueTypeCode;

	@Expose
	private String	configCateKey;

	@Expose
	private String	configSysCode;

	@Expose
	private String	configValue;

	@Expose
	private String	sysStatusCode;

	public String getConfigKey() {
		return configKey;
	}

	public void setConfigKey(String configKey) {
		this.configKey = configKey;
	}

	public String getValueTypeCode() {
		return valueTypeCode;
	}

	public void setValueTypeCode(String valueTypeCode) {
		this.valueTypeCode = valueTypeCode;
	}

	public String getConfigCateKey() {
		return configCateKey;
	}

	public void setConfigCateKey(String configCateKey) {
		this.configCateKey = configCateKey;
	}

	public String getConfigSysCode() {
		return configSysCode;
	}

	public void setConfigSysCode(String configSysCode) {
		this.configSysCode = configSysCode;
	}

	public String getConfigValue() {
		return configValue;
	}

	public void setConfigValue(String configValue) {
		this.configValue = configValue;
	}

	public String getSysStatusCode() {
		return sysStatusCode;
	}

	public void setSysStatusCode(String sysStatusCode) {
		this.sysStatusCode = sysStatusCode;
	}

	public static SysConfig fromString(String jsonString) {
		return fromString(jsonString, SysConfig.class);
	}

}
