package com.k4m.dx.tcontrol.cmmn.serviceproxy.vo;

/**
* MasterKeyFile
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

public class MasterKeyFile extends AbstractPageModel{
	private String mas;
	private String ter;
	private String key;
	
	public String getMas() {
		return mas;
	}
	public void setMas(String mas) {
		this.mas = mas;
	}
	public String getTer() {
		return ter;
	}
	public void setTer(String ter) {
		this.ter = ter;
	}
	public String getKey() {
		return key;
	}
	public void setKey(String key) {
		this.key = key;
	}
	
}
