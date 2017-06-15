package com.k4m.dx.tcontrol.deamon;

/**
 * <p>화면에 로그 메시지를 출력한다.</p>
 * 
 * <p>"net.kldp.jsd.log" 시스템 프라퍼티가 on 일 때만 로그를 출력한다.
 * 기본값은 off이다.</p>
 * 
 * <p>DxDaemon을 사용하는 Java 프로그램을 실행 시킬때 JVM 옵션으로 로깅을
 * 끄고 켤 수 있다.<br />
 *  <code>$ java -Dnet.kldp.jsd.log=true net.kldp.jsd.sample.ShowTime<code>
 * </p>
 * 
 * @@author Son KwonNam(kwon37xi@@yahoo.co.kr)
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

