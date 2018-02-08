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

import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

import com.google.gson.annotations.Expose;

/**
 * @brief
 * 
 *        TODO add description
 * @date 2015. 4. 16.
 * @author Kim, Sunho
 */

public class SystemUsage extends SystemAbstractModel {

	@Expose
	private String	targetResourceType;

	@Expose
	private String	targetResource;

	@Expose
	private Float	usageRate;

	@Expose
	private Float	limitRate;

	public String getTargetResourceType() {
		return targetResourceType;
	}

	public void setTargetResourceType(String targetResourceType) {
		this.targetResourceType = targetResourceType;
	}

	public static SystemUsage fromString(String jsonString) {
		return fromString(jsonString, SystemUsage.class);
	}

	public String getTargetResource() {
		return targetResource;
	}

	public void setTargetResource(String targetResource) {
		this.targetResource = targetResource;
	}

	public Float getUsageRate() {
		return usageRate;
	}

	public void setUsageRate(Float usageRate) {
		this.usageRate = usageRate;
	}

	public Float getLimitRate() {
		return limitRate;
	}

	public void setLimitRate(Float limitRate) {
		this.limitRate = limitRate;
	}

	private static final Object[]	exportHeader	= { "기록 일시", "발생 일시", "모니터링 대상 주소", "모니터링 대상 식별자", "모니터링 대상 이름", "자원 유형", "자원", "모니터링 결과", "사용률",
													"임계치", "메세지" };

	@Override
	public Object[] getExportHeader() {
		return exportHeader;
	}

	@Override
	public Iterable<?> getExportRecord() {
		List<Object> retval = new ArrayList<Object>(exportHeader.length);
		retval.add(getServerLogDateTime());
		retval.add(getSiteLogDateTime());
		retval.add(getMonitoredAddress());
		retval.add(getMonitoredUid());
		retval.add(getMonitoredName());
		retval.add(getTargetResourceType());
		retval.add(getTargetResource());
		retval.add(getResultLevel());
		retval.add(getUsageRate());
		retval.add(getLimitRate());
		retval.add(getLogMessage());
		return retval;
	}

	private static final String	createStatement	= "CREATE TABLE T_SYSTEM_USAGE_LOG( SERVER_LOG_DTM TEXT, SITE_LOG_DTM TEXT, MONITORED_ADDRESS TEXT, MONITORED_UID TEXT, MONITORED_NM TEXT, TARGET_RESOURCE_TYPE TEXT, TARGET_RESOURCE TEXT, RESULT_LEVEL TEXT, USAGE_RATE NUMERIC, LIMIT_RATE NUMERIC, LOG_MESSAGE TEXT)";

	@Override
	public String getCreateStatement() {
		return createStatement;
	}

	private static final String	insertStatement	= "INSERT INTO T_SYSTEM_USAGE_LOG (SERVER_LOG_DTM, SITE_LOG_DTM, MONITORED_ADDRESS, MONITORED_UID, MONITORED_NM, TARGET_RESOURCE_TYPE, TARGET_RESOURCE, RESULT_LEVEL, USAGE_RATE, LIMIT_RATE, LOG_MESSAGE) VALUES (?,?,?,?,?,?,?,?,?,?,?)";

	@Override
	public String getInsertStatement() {
		return insertStatement;
	}

	@Override
	public PreparedStatement setStatementParameters(PreparedStatement insertStmt) throws SQLException {
		int i = 0;
		insertStmt.setString(++i, getServerLogDateTime());
		insertStmt.setString(++i, getSiteLogDateTime());
		insertStmt.setString(++i, getMonitoredAddress());
		insertStmt.setString(++i, getMonitoredUid());
		insertStmt.setString(++i, getMonitoredName());
		insertStmt.setString(++i, getTargetResourceType());
		insertStmt.setString(++i, getTargetResource());
		insertStmt.setString(++i, getResultLevel());
		if (getUsageRate() == null) {
			insertStmt.setNull(++i, Types.FLOAT);
		} else {
			insertStmt.setFloat(++i, getUsageRate());
		}

		if (getLimitRate() == null) {
			insertStmt.setNull(++i, Types.FLOAT);
		} else {
			insertStmt.setFloat(++i, getLimitRate());
		}
		insertStmt.setString(++i, getLogMessage());

		return insertStmt;
	}
}
