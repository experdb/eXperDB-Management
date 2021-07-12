package com.experdb.proxy.socket;

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
public class TranCodeType {
	public static final String PsP001 = "PsP001"; // proxy 에이전트 setting
	public static final String PsP002 = "PsP002"; // proxy 에이전트 연결 Test
	public static final String PsP003 = "PsP003"; // proxy, keepalived conf 파일 가져오기
	public static final String PsP004 = "PsP004"; // proxy conf 파일 백업 & 신규 생성 
	public static final String PsP005 = "PsP005"; // proxy service restart
	public static final String PsP006 = "PsP006"; // proxy service start/stop
	public static final String PsP007 = "PsP007"; // proxy agent interface 목록 조회
	public static final String PsP008 = "PsP008"; // proxy log 파일 가져오기
	public static final String PsP009 = "PsP009"; // proxy conf 파일 searh 후 데이터 입력 요청
	public static final String PsP010 = "PsP010"; // Keepavlied 설치 여부 확인
	public static final String PsP011 = "PsP011"; // Config Backup 폴더 삭제 
	public static final String PsP012 = "PsP012";
	public static final String PsP013 = "PsP013";// backup 폴더 삭제
	
	public static final String STATUS = "STATUS";
	public static final String STOP = "STOP";
	public static final String CLOSE = "CLOSE";

	/**
	 * 결과
	 */
	public static final String RESULT = "RESULT";								  //결과	

}