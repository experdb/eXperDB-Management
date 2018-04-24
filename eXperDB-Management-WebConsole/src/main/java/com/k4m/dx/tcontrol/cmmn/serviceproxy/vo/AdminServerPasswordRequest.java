package com.k4m.dx.tcontrol.cmmn.serviceproxy.vo;

/**
* AdminServerPasswordRequest
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
public class AdminServerPasswordRequest extends AbstractJSONAwareModel {

	private String	oldPassword;

	private String	newPassword;

	private String	saltBase64;

	private int		iterationCount;

	public static AdminServerPasswordRequest fromString(String jsonString) {
		return fromString(jsonString, AdminServerPasswordRequest.class);
	}

	public String getOldPassword() {
		return oldPassword;
	}

	public void setOldPassword(String oldPassword) {
		this.oldPassword = oldPassword;
	}

	public String getNewPassword() {
		return newPassword;
	}

	public void setNewPassword(String newPassword) {
		this.newPassword = newPassword;
	}

	public String getSaltBase64() {
		return saltBase64;
	}

	public void setSaltBase64(String saltBase64) {
		this.saltBase64 = saltBase64;
	}

	public int getIterationCount() {
		return iterationCount;
	}

	public void setIterationCount(int iterationCount) {
		this.iterationCount = iterationCount;
	}
}
