package com.k4m.dx.tcontrol.cmmn.serviceproxy.vo;

import com.google.gson.GsonBuilder;
import com.google.gson.annotations.Expose;

/**
* AuthCredentialToken
* 
* 인증에 필요한 필드를 포함하는 모델
*  인증에 필요한 필드와 getter/setter 를 포함하는 모델로 outbound로는 사용되지 않고, inbound로만 사용된다.
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

public class AuthCredentialToken extends AbstractManagedModel {

	@Expose
	private String	loginId;

	private String	password;

	private int		loginFailCount;

	private String	latestPasswordChangeDateTime;

	private String	entityUid;

	private String	tokenValue;

	private int		tokenUsedCount;

	//private Date	tokenUsableDateTime;

	private String	latestTokenUsedDateTime;

	private String	entityStatusCode;

	private String	entityStatusName;

	private String	entityTypeCode;

	private String	entityTypeName;

	private String	entityName;

	/**
	 * 입력된 JSON 문자열을 객체로 변환한다. 서비스 메소드 호출 시 객체로 매개변수를 변환 할 때 사용된다.
	 * @param - JSON 문자열
	 * @return AuthCredentialToken - 변환된 객체
	 */
	public static AuthCredentialToken fromString(String jsonString) {
		return (new GsonBuilder().disableHtmlEscaping().create()).fromJson(jsonString, AuthCredentialToken.class);
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

	public int getLoginFailCount() {
		return loginFailCount;
	}

	public void setLoginFailCount(int loginFailCount) {
		this.loginFailCount = loginFailCount;
	}

	public String getLatestPasswordChangeDateTime() {
		return latestPasswordChangeDateTime;
	}

	public void setLatestPasswordChangeDateTime(String latestPasswordChangeDateTime) {
		this.latestPasswordChangeDateTime = latestPasswordChangeDateTime;
	}

	public String getEntityUid() {
		return entityUid;
	}

	public void setEntityUid(String entityUid) {
		this.entityUid = entityUid;
	}

	public String getTokenValue() {
		return tokenValue;
	}

	public void setTokenValue(String tokenValue) {
		this.tokenValue = tokenValue;
	}

	public int getTokenUsedCount() {
		return tokenUsedCount;
	}

	public void setTokenUsedCount(int tokenUsedCount) {
		this.tokenUsedCount = tokenUsedCount;
	}

	public String getLatestTokenUsedDateTime() {
		return latestTokenUsedDateTime;
	}

	public void setLatestTokenUsedDateTime(String latestTokenUsedDateTime) {
		this.latestTokenUsedDateTime = latestTokenUsedDateTime;
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

	public String getEntityName() {
		return entityName;
	}

	public void setEntityName(String entityName) {
		this.entityName = entityName;
	}
}
