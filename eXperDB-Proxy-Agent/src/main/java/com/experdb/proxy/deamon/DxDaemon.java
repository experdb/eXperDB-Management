package com.experdb.proxy.deamon;

/**
* @author 최정환
* @see
* 
*      <pre>
* == 개정이력(Modification Information) ==
*
*   수정일       수정자           수정내용
*  -------     --------    ---------------------------
*  2021.02.24   최정환 	최초 생성
*      </pre>
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