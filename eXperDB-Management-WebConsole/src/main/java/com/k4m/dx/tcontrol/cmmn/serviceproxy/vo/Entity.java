package com.k4m.dx.tcontrol.cmmn.serviceproxy.vo;

import com.google.gson.annotations.Expose;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.TypeUtility;

import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;

/**
* Entity
* 
* 
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
public class Entity extends AbstractManagedModel {
	@Expose
	private String		entityUid;

	@Expose
	private String		entityName;

	@Expose
	private String		loginId;

	private String		password;

	@Expose
	private String		parentUid;

	@Expose
	private String		entityTypeCode;

	@Expose
	private String		entityTypeName;

	@Expose
	private String		containerTypeCode;

	@Expose
	private String		containerTypeName;

	@Expose
	private String		entityStatusCode;

	@Expose
	private String		entityStatusName;

	@Expose
	private String		latestAddress;

	@Expose
	private String		latestDateTime;

	@Expose
	private int			loginFailCount;

	@Expose
	private String		extendedField;

	@Expose
	private Long		receivedPolicyVersion;

	@Expose
	private Long		sentPolicyVersion;

	private JSONObject	extendedFieldObject;

	@Expose
	private String		appVersion;

	public String getEntityUid() {
		return entityUid;
	}

	public void setEntityUid(String entityUid) {
		this.entityUid = entityUid;
	}

	public String getEntityName() {
		return entityName;
	}

	public void setEntityName(String entityName) {
		this.entityName = entityName;
	}

	public String getLoginId() {
		return loginId;
	}

	public void setLoginId(String loginId) {
		this.loginId = loginId;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getParentUid() {
		return parentUid;
	}

	public void setParentUid(String parentUid) {
		this.parentUid = parentUid;
	}

	public String getEntityTypeCode() {
		return entityTypeCode;
	}

	public void setEntityTypeCode(String entityTypeCode) {
		this.entityTypeCode = entityTypeCode;
	}

	public String getEntityTypeName() {
		return entityTypeName;
	}

	public void setEntityTypeName(String entityTypeName) {
		this.entityTypeName = entityTypeName;
	}

	public String getContainerTypeCode() {
		return containerTypeCode;
	}

	public void setContainerTypeCode(String containerTypeCode) {
		this.containerTypeCode = containerTypeCode;
	}

	public String getContainerTypeName() {
		return containerTypeName;
	}

	public void setContainerTypeName(String containerTypeName) {
		this.containerTypeName = containerTypeName;
	}

	public String getEntityStatusCode() {
		return entityStatusCode;
	}

	public void setEntityStatusCode(String entityStatusCode) {
		this.entityStatusCode = entityStatusCode;
	}

	public String getEntityStatusName() {
		return entityStatusName;
	}

	public void setEntityStatusName(String entityStatusName) {
		this.entityStatusName = entityStatusName;
	}

	public String getLatestAddress() {
		return latestAddress;
	}

	public void setLatestAddress(String latestAddress) {
		this.latestAddress = latestAddress;
	}

	public String getLatestDateTime() {
		return latestDateTime;
	}

	public void setLatestDateTime(String latestDateTime) {
		this.latestDateTime = latestDateTime;
	}

	public int getLoginFailCount() {
		return loginFailCount;
	}

	public void setLoginFailCount(int loginFailCount) {
		this.loginFailCount = loginFailCount;
	}

	public String getExtendedField() {
		return this.extendedField;
	}

	public JSONObject getExtendedFieldObject() {
		return extendedFieldObject;
	}

	public void setExtendedField(String jsonString) {
		if (!TypeUtility.isEmpty(jsonString)) {
			this.extendedField = jsonString;
			this.extendedFieldObject = (JSONObject) JSONSerializer.toJSON(jsonString);
		} else {
			this.extendedField = null;
			this.extendedFieldObject = null;
		}
	}

	public void setExtendedFieldObject(JSONObject obj) {
		this.extendedFieldObject = obj;
		if (obj != null) {
			this.extendedField = obj.toString();
			//this.extendedField = obj.toJSONString();
		} else {
			this.extendedField = null;
		}
	}

	/**
	 * 입력된 JSON 문자열을 객체로 변환한다. 서비스 메소드 호출 시 객체로 매개변수를 변환 할 때 사용된다.
	 * @param jsonString - JSON 문자열
	 * @return Entity - 변환된 객체
	 */
	public static Entity fromString(String jsonString) {
		return fromString(jsonString, Entity.class);
	}

	public Long getReceivedPolicyVersion() {
		return receivedPolicyVersion;
	}

	public void setReceivedPolicyVersion(Long receivedPolicyVersion) {
		this.receivedPolicyVersion = receivedPolicyVersion;
	}

	public Long getSentPolicyVersion() {
		return sentPolicyVersion;
	}

	public void setSentPolicyVersion(Long sentPolicyVersion) {
		this.sentPolicyVersion = sentPolicyVersion;
	}

	public String getAppVersion() {
		return appVersion;
	}

	public void setAppVersion(String appVersion) {
		this.appVersion = appVersion;
	}
}
