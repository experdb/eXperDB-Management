package com.k4m.dx.tcontrol.monitoring.resourceMgr.vo;

import org.snmp4j.smi.Integer32;

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
public class MemoryInfo {

	private Integer32 usageVariable = new Integer32(0);

	public Integer32 getUsageVariable() {
		return usageVariable;
	}

	public void setUsage(int usage) {
		this.usageVariable.setValue(usage);
	}
	
	public int getUsage(){
		return this.usageVariable.getValue();
	}
	
}
