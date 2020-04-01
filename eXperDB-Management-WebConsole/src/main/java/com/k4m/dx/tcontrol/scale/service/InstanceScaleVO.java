package com.k4m.dx.tcontrol.scale.service;

/**
* @author 
* @see aws scale vo
* 
*      <pre>
* == 개정이력(Modification Information) ==
*
*   수정일                 수정자                   수정내용
*  -------     --------    ---------------------------
*  2020.03.24              최초 생성
*      </pre>
*/
public class InstanceScaleVO {
	private int rownum;
	private String RequesterId;
	private int db_svr_id;
	private String scale_id;
	private String login_id;

	public String getLogin_id() {
		return login_id;
	}
	public void setLogin_id(String login_id) {
		this.login_id = login_id;
	}

	public int getRownum() {
		return rownum;
	}
	public void setRownum(int rownum) {
		this.rownum = rownum;
	}

	public String getRequesterId() {
		return RequesterId;
	}
	public void setRequesterId(String RequesterId) {
		this.RequesterId = RequesterId;
	}

	public int getDb_svr_id() {
		return db_svr_id;
	}
	public void setDb_svr_id(int db_svr_id) {
		this.db_svr_id = db_svr_id;
	}

	public String getScale_id() {
		return scale_id;
	}
	public void setScale_id(String scale_id) {
		this.scale_id = scale_id;
	}
}