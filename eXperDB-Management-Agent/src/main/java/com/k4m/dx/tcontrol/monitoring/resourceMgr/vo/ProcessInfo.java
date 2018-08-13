package com.k4m.dx.tcontrol.monitoring.resourceMgr.vo;

import org.apache.commons.lang.StringUtils;

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
public class ProcessInfo implements Comparable<ProcessInfo>{

	public static enum STATE {
		IDLE("D","Idle"), RUN("R","Run"),  SLEEP("S","Sleep"), STOP("T","Stop"), ZOMBIE("Z","Zombie");
		private String code;
		private String description;
		STATE(String code, String description){
			this.code = code;
			this.description = description;
		}
		public String getCode(){ return code;}
		public String getDescription(){ return description;}
		public static STATE get(String code){
			for(STATE obj : STATE.values()){
				if( StringUtils.equals(obj.getCode(), code)){
					return obj;
				}
			}
			return null;
		}
	}
	
	private long pid;
	private String name;
	private String argument;
	private String state;
	
	public String getState() {
		return state;
	}
	public void setState(String state) {
		this.state = state;
	}
	public long getPid() {
		return pid;
	}
	public void setPid(long pid) {
		this.pid = pid;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getArgument() {
		return argument;
	}
	public void setArgument(String argument) {
		this.argument = argument;
	}



	@Override
	public int compareTo(ProcessInfo info) {
		if ( StringUtils.equals(getName(), info.getName()) ){
			if(  StringUtils.equals(getArgument(), info.getArgument()) ){
				return new Long(getPid()).compareTo(new Long(info.getPid()));	
			}
			else {
				return getArgument().compareTo(info.getArgument());
			}
		}
		else {
			return getName().compareTo(info.getName());
		}
	}
	
	public static void main(String args[]){
		
		

	}

}
