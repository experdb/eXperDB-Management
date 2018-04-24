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
public class ProfileProtection extends Profile {

	@Expose
	private int		plainMaxSize;

	@Expose
	private int		cipherMaxSize;

	@Expose
	private String	nullEncryptYesNo;

	@Expose
	private String	base64YesNo;

	@Expose
	private String	dataTypeCode;

	@Expose
	private String	dataTypeName;

	@Expose
	private String	preventDoubleYesNo;

	@Expose
	private String	denyResultTypeCode;

	@Expose
	private String	maskingValue;

	@Expose
	private Long	optionBits;

	@Expose
	private Boolean	defaultAccessAllowTrueFalse;

	public static ProfileProtection fromString(String jsonString) {
		return fromString(jsonString, ProfileProtection.class);
	}

	public int getPlainMaxSize() {
		return plainMaxSize;
	}

	public void setPlainMaxSize(int plainMaxSize) {
		this.plainMaxSize = plainMaxSize;
	}

	public int getCipherMaxSize() {
		return cipherMaxSize;
	}

	public void setCipherMaxSize(int cipherMaxSize) {
		this.cipherMaxSize = cipherMaxSize;
	}

	public String getNullEncryptYesNo() {
		return nullEncryptYesNo;
	}

	public void setNullEncryptYesNo(String nullEncryptYesNo) {
		this.nullEncryptYesNo = nullEncryptYesNo;
	}

	public String getBase64YesNo() {
		return base64YesNo;
	}

	public void setBase64YesNo(String base64YesNo) {
		this.base64YesNo = base64YesNo;
	}

	public String getDataTypeCode() {
		return dataTypeCode;
	}

	public void setDataTypeCode(String dataTypeCode) {
		this.dataTypeCode = dataTypeCode;
	}

	public String getDataTypeName() {
		return dataTypeName;
	}

	public void setDataTypeName(String dataTypeName) {
		this.dataTypeName = dataTypeName;
	}

	public String getPreventDoubleYesNo() {
		return preventDoubleYesNo;
	}

	public void setPreventDoubleYesNo(String preventDoubleYesNo) {
		this.preventDoubleYesNo = preventDoubleYesNo;
	}

	public Boolean getDefaultAccessAllowTrueFalse() {
		return defaultAccessAllowTrueFalse;
	}

	public void setDefaultAccessAllowTrueFalse(Boolean defaultAccessAllowTrueFalse) {
		this.defaultAccessAllowTrueFalse = defaultAccessAllowTrueFalse;
	}

	public String getDenyResultTypeCode() {
		return denyResultTypeCode;
	}

	public void setDenyResultTypeCode(String denyResultTypeCode) {
		this.denyResultTypeCode = denyResultTypeCode;
	}

	public String getMaskingValue() {
		return maskingValue;
	}

	public void setMaskingValue(String maskingValue) {
		this.maskingValue = maskingValue;
	}

	public Long getOptionBits() {
		return optionBits;
	}

	public void setOptionBits(Long optionBits) {
		this.optionBits = optionBits;
	}
}
