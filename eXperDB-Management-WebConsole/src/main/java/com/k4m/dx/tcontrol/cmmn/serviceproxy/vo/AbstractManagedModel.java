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

import java.text.SimpleDateFormat;
import java.util.Date;

import com.google.gson.annotations.Expose;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.SystemCode;


/**
 * @brief 처리 결과 본문으로 전송되는, 서비스 로직과 관련된 데이터(모델)의 상위 클래스
 * 
 *        모든 모델이 포함하는 생성일시, 수정일시, 생성자 식별자, 수정자 식별자 필드와 이들 필드의 getter/setter 를 포함한다.
 * @date 2014. 11. 17.
 * @author Kim, Sunho
 */

public abstract class AbstractManagedModel extends AbstractJSONAwareModel {

	@Expose
	private String	createDateTime;

	@Expose
	private String	updateDateTime;

	@Expose
	private String	createUid;

	@Expose
	private String	updateUid;

	@Expose
	private String	createName;

	@Expose
	private String	updateName;

	public String getCreateDateTime() {
		return createDateTime;
	}

	public void setCreateDateTime(Date createDateTime) {
		SimpleDateFormat format = new SimpleDateFormat(SystemCode.DATETIME_FORMAT);
		this.createDateTime = format.format(createDateTime);
	}

	public String getUpdateDateTime() {
		return updateDateTime;
	}

	public void setUpdateDateTime(Date updateDateTime) {
		SimpleDateFormat format = new SimpleDateFormat(SystemCode.DATETIME_FORMAT);
		this.updateDateTime = format.format(updateDateTime);
	}

	public String getCreateUid() {
		return createUid;
	}

	public void setCreateUid(String createUid) {
		this.createUid = createUid;
	}

	public String getCreateName() {
		return createName;
	}

	public void setCreateName(String createName) {
		this.createName = createName;
	}

	public String getUpdateUid() {
		return updateUid;
	}

	public void setUpdateUid(String updateUid) {
		this.updateUid = updateUid;
	}

	public String getUpdateName() {
		return updateName;
	}

	public void setUpdateName(String updateName) {
		this.updateName = updateName;
	}

}
