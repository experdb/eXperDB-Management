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
public class DxLogger {
	/** 로그 출력 여부를 결정하는 시스템 프라퍼티 */
	private static String DXLOGGER_PROPERTY = "net.kldp.jsd.log";

	/** 로거 인스턴스. */
	private static DxLogger instance = null;
	
	/** 로그 출력 여부 */
	private boolean log = false;
	
	private DxLogger() {
		// 아무나 생성 불가
	}
	
	/**
	 * DxLogger 객체 생성.
	 * 
	 * @@return DxLogger 객체
	 */
	public static synchronized DxLogger getLogger() {
		if (instance != null) {
			return instance;
		}
		
		instance = new DxLogger();
		
		instance.log = Boolean.getBoolean(DXLOGGER_PROPERTY);
		
		return instance;
	}
	
	/**
	 * 오류 로그 출력
	 * 
	 * @@param message 로그 내용
	 */
	public void err(String message) {
		System.err.println(getErrHeader() + message);
	}
	
	/**
	 * 일반 로그 출력
	 * 
	 * @@param message 로그 내용
	 */
	
	public void out(String message) {
		if (log == true) {
			System.out.println(getOutHeader() + message);
		}
	}

	protected String getErrHeader() {
		return "[DxDaemon Error!!] ";
	}
	
	protected String getOutHeader() {
		return "[DxDaemon] ";
	}
	
}

