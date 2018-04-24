package com.k4m.dx.tcontrol.cmmn.serviceproxy.vo;

import com.google.gson.annotations.Expose;

/**
* @author 박태혁
* @see
* 
*      <pre>
* == 개정이력(Modification Information) ==
*
*   수정일       수정자           수정내용
*  -------     --------    ---------------------------
*  2018.04.23   박태혁 최초 생성
*      </pre>
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
