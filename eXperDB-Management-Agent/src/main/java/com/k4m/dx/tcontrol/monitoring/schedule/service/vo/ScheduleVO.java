package com.k4m.dx.tcontrol.monitoring.schedule.service.vo;

import java.util.Date;

/**
* @author 박태혁
* @see
* 
*      <pre>
* == 개정이력(Modification Information) ==
*
*   수정일       수정자           수정내용
*  -------     --------    ---------------------------
*  2018.06.28   박태혁 최초 생성
*      </pre>
*/

public class ScheduleVO {


	private int scd_id;
	private String scd_nm;
	private String scd_cmd;
	private String scd_code;
	private String scd_H;
	private String scd_M;
	private String scd_S;
	
	public int getScd_id() {
		return scd_id;
	}
	public void setScd_id(int scd_id) {
		this.scd_id = scd_id;
	}
	public String getScd_nm() {
		return scd_nm;
	}
	public void setScd_nm(String scd_nm) {
		this.scd_nm = scd_nm;
	}
	public String getScd_cmd() {
		return scd_cmd;
	}
	public void setScd_cmd(String scd_cmd) {
		this.scd_cmd = scd_cmd;
	}
	public String getScd_code() {
		return scd_code;
	}
	public void setScd_code(String scd_code) {
		this.scd_code = scd_code;
	}
	public String getScd_H() {
		return scd_H;
	}
	public void setScd_H(String scd_H) {
		this.scd_H = scd_H;
	}
	public String getScd_M() {
		return scd_M;
	}
	public void setScd_M(String scd_M) {
		this.scd_M = scd_M;
	}
	public String getScd_S() {
		return scd_S;
	}
	public void setScd_S(String scd_S) {
		this.scd_S = scd_S;
	}
	
	
	

}
