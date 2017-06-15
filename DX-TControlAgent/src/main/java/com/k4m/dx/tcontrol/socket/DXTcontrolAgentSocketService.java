package com.k4m.dx.tcontrol.socket;

public interface DXTcontrolAgentSocketService {
	
	/**
	 * Socket 시작
	 * @throws Exception
	 */
	public void start() throws Exception;
	
	/**
	 * Socket 종료
	 * @throws Exception
	 */
	public void stop() throws Exception;

}
