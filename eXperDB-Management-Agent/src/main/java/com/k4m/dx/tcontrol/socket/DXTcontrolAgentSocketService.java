package com.k4m.dx.tcontrol.socket;

/**
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
