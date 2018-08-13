package com.k4m.dx.tcontrol.monitoring.resourceMgr.vo;

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
public class DiskInfo implements Comparable<DiskInfo> {

	private String name;
	private int usage;
	private long usedKbyte;
	private long totalKbyte;
	private String type;

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public int getUsage() {
		return usage;
	}

	public void setUsage(int usage) {
		this.usage = usage;
	}


	public long getUsedKbyte() {
		return usedKbyte;
	}

	public void setUsedKbyte(long usedKbyte) {
		this.usedKbyte = usedKbyte;
	}

	public long getTotalKbyte() {
		return totalKbyte;
	}

	public void setTotalKbyte(long totalKbyte) {
		this.totalKbyte = totalKbyte;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	@Override
	public int compareTo(DiskInfo diskInfo) {
		return getName().compareTo(diskInfo.getName());
	}
}
