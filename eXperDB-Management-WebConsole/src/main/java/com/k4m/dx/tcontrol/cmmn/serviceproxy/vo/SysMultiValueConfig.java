package com.k4m.dx.tcontrol.cmmn.serviceproxy.vo;

import java.math.BigDecimal;

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
public class SysMultiValueConfig extends AbstractManagedModel {

	@Expose
	private String		configKey;

	@Expose
	private String		configNote;

	@Expose
	private Boolean		valueTrueFalse;

	@Expose
	private String		valueString;

	@Expose
	private BigDecimal	valueNumber;

	@Expose
	private BigDecimal	valueNumber2;

	public static SysMultiValueConfig fromString(String jsonString) {
		return fromString(jsonString, SysMultiValueConfig.class);
	}

	public String getConfigKey() {
		return configKey;
	}

	public void setConfigKey(String configKey) {
		this.configKey = configKey;
	}

	public String getConfigNote() {
		return configNote;
	}

	public void setConfigNote(String configNote) {
		this.configNote = configNote;
	}

	public Boolean isValueTrueFalse() {
		return valueTrueFalse;
	}

	public void setValueTrueFalse(Boolean valueTrueFalse) {
		this.valueTrueFalse = valueTrueFalse;
	}

	public String getValueString() {
		return valueString;
	}

	public void setValueString(String valueString) {
		this.valueString = valueString;
	}

	public BigDecimal getValueNumber() {
		return valueNumber;
	}

	public void setValueNumber(BigDecimal valueNumber) {
		this.valueNumber = valueNumber;
	}

	public BigDecimal getValueNumber2() {
		return valueNumber2;
	}

	public void setValueNumber2(BigDecimal valueNumber2) {
		this.valueNumber2 = valueNumber2;
	}

}
