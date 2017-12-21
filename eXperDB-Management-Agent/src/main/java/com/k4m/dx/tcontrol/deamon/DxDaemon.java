package com.k4m.dx.tcontrol.deamon;

/**
 * <p>SimpleDaemon 인터페이스</p>
 * 
 * <p>SimpleDaemon으로 구동될 프로그램은 이 인터페이스를 구현해야 한다.</p>
 * 
 */
public interface DxDaemon {
	/**
	 * <p>실제로 실행할 코드가 들어가는 곳</p>
	 */
	public void startDaemon();

	/**
	 * <p>데몬이 종료될 때 실행할 구문들</p>
	 */
	public void shutdown();
	
	
	public void chkDir();

}