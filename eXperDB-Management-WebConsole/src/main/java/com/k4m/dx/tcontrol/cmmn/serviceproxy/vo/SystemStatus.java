package com.k4m.dx.tcontrol.cmmn.serviceproxy.vo;

import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

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
public class SystemStatus extends SystemAbstractModel {

	@Expose
	private String	targetType;

	@Expose
	private String	targetUid;

	@Expose
	private String	targetName;

	@Expose
	private String	monitorType;

	@Expose
	private Long	resultCount;

	public static SystemStatus fromString(String jsonString) {
		return fromString(jsonString, SystemStatus.class);
	}

	public String getTargetType() {
		return targetType;
	}

	public void setTargetType(String targetType) {
		this.targetType = targetType;
	}

	public String getTargetUid() {
		return targetUid;
	}

	public void setTargetUid(String targetUid) {
		this.targetUid = targetUid;
	}

	public String getTargetName() {
		return targetName;
	}

	public void setTargetName(String targetName) {
		this.targetName = targetName;
	}

	public String getMonitorType() {
		return monitorType;
	}

	public void setMonitorType(String monitorType) {
		this.monitorType = monitorType;
	}

	public Long getResultCount() {
		return resultCount;
	}

	public void setResultCount(Long resultCount) {
		this.resultCount = resultCount;
	}

	private static final Object[]	exportHeader	= { "기록 일시", "발생 일시", "모니터링 대상 주소", "모니터링 대상 식별자", "모니터링 대상 이름", "대상 유형", "대상 식별자", "대상 이름",
													"모니터링 유형", "모니터링 결과", "결과 건수", "메세지" };

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
		retval.add(getTargetType());
		retval.add(getTargetUid());
		retval.add(getTargetName());
		retval.add(getMonitorType());
		retval.add(getResultLevel());
		retval.add(getResultCount());
		retval.add(getLogMessage());
		return retval;
	}

	private static final String	createStatement	= "CREATE TABLE T_SYSTEM_STATUS_LOG(SERVER_LOG_DTM TEXT, SITE_LOG_DTM TEXT, MONITORED_ADDRESS TEXT, MONITORED_UID TEXT, MONITORED_NM TEXT, TARGET_TYPE TEXT, TARGET_UID TEXT, TARGET_NM TEXT, MONITOR_TYPE TEXT, RESULT_LEVEL TEXT, LOG_MESSAGE TEXT, RESULT_COUNT NUMERIC)";

	@Override
	public String getCreateStatement() {
		return createStatement;
	}

	private static final String	insertStatement	= "INSERT INTO T_SYSTEM_STATUS_LOG (SERVER_LOG_DTM, SITE_LOG_DTM, MONITORED_ADDRESS, MONITORED_UID, MONITORED_NM, TARGET_TYPE, TARGET_UID, TARGET_NM, MONITOR_TYPE, RESULT_LEVEL, LOG_MESSAGE, RESULT_COUNT) VALUES (?,?,?,?,?,?,?,?,?,?,?,?)";

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
		insertStmt.setString(++i, getTargetType());
		insertStmt.setString(++i, getTargetUid());
		insertStmt.setString(++i, getTargetName());
		insertStmt.setString(++i, getMonitorType());
		insertStmt.setString(++i, getResultLevel());
		insertStmt.setString(++i, getLogMessage());
		if (getResultCount() == null) {
			insertStmt.setNull(++i, java.sql.Types.INTEGER);
		} else {
			insertStmt.setLong(++i, getResultCount());
		}

		return insertStmt;
	}
}
