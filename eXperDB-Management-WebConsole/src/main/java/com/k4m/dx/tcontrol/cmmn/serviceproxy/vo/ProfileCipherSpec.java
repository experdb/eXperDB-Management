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

import com.google.gson.annotations.Expose;

/**
 * TODO add description
 * @date 2014. 12. 27.
 * @author Kim, Sunho
 */

public class ProfileCipherSpec extends AbstractManagedModel {

	@Expose
	private String	profileUid;

	@Expose
	private int		specIndex;

	@Expose
	private String	cipherAlgorithmCode;

	@Expose
	private String	cipherAlgorithmName;

	@Expose
	private String	operationModeCode;

	@Expose
	private String	operationModeName;

	@Expose
	private String	paddingMethodCode;

	@Expose
	private String	paddingMethodName;

	@Expose
	private String	initialVectorTypeCode;

	@Expose
	private String	initialVectorTypeName;

	@Expose
	private int		offset;

	@Expose
	private Integer	length;				//-1 : 끝까지

	@Expose
	private String	binUid;

	@Expose
	private String	binName;

	public String getProfileUid() {
		return profileUid;
	}

	public void setProfileUid(String profileUid) {
		this.profileUid = profileUid;
	}

	public int getSpecIndex() {
		return specIndex;
	}

	public void setSpecIndex(int specIndex) {
		this.specIndex = specIndex;
	}

	public String getCipherAlgorithmCode() {
		return cipherAlgorithmCode;
	}

	public void setCipherAlgorithmCode(String cipherAlgorithmCode) {
		this.cipherAlgorithmCode = cipherAlgorithmCode;
	}

	public String getCipherAlgorithmName() {
		return cipherAlgorithmName;
	}

	public void setCipherAlgorithmName(String cipherAlgorithmName) {
		this.cipherAlgorithmName = cipherAlgorithmName;
	}

	public String getOperationModeCode() {
		return operationModeCode;
	}

	public void setOperationModeCode(String operationModeCode) {
		this.operationModeCode = operationModeCode;
	}

	public String getOperationModeName() {
		return operationModeName;
	}

	public void setOperationModeName(String operationModeName) {
		this.operationModeName = operationModeName;
	}

	public String getPaddingMethodCode() {
		return paddingMethodCode;
	}

	public void setPaddingMethodCode(String paddingMethodCode) {
		this.paddingMethodCode = paddingMethodCode;
	}

	public String getPaddingMethodName() {
		return paddingMethodName;
	}

	public void setPaddingMethodName(String paddingMethodName) {
		this.paddingMethodName = paddingMethodName;
	}

	public String getInitialVectorTypeName() {
		return initialVectorTypeName;
	}

	public void setInitialVectorTypeName(String initialVectorTypeName) {
		this.initialVectorTypeName = initialVectorTypeName;
	}

	public String getInitialVectorTypeCode() {
		return initialVectorTypeCode;
	}

	public void setInitialVectorTypeCode(String initialVectorTypeCode) {
		this.initialVectorTypeCode = initialVectorTypeCode;
	}

	public int getOffset() {
		return offset;
	}

	public void setOffset(int offset) {
		this.offset = offset;
	}

	public Integer getLength() {
		return length;
	}

	public void setLength(Integer length) {
		this.length = length;
	}

	public String getBinUid() {
		return binUid;
	}

	public void setBinUid(String binUid) {
		this.binUid = binUid;
	}

	public String getBinName() {
		return binName;
	}

	public void setBinName(String binName) {
		this.binName = binName;
	}

	public static ProfileCipherSpec fromString(String jsonString) {
		return fromString(jsonString, ProfileCipherSpec.class);
	}
}
