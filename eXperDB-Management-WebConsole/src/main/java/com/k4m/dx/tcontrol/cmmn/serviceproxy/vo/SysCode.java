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
