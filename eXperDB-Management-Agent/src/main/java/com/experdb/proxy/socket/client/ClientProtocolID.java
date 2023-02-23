package com.experdb.proxy.socket.client;

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
public class ClientProtocolID {

	public static final String DX_EX_CODE = "DX_EX_CODE";
	public static final String SERVER_INFO = "SERVER_INFO";
	public static final String SERVER_NAME = "SERVER_NAME";
	public static final String SERVER_IP = "SERVER_IP";
	public static final String SERVER_PORT = "SERVER_PORT";
	public static final String DATABASE_NAME = "DATABASE_NAME";
	public static final String USER_ID = "USER_ID";
	public static final String USER_PWD = "USER_PWD";

	public static final String RESULT_CODE = "RESULT_CODE";
	public static final String ERR_CODE = "ERR_CODE";
	public static final String ERR_MSG = "ERR_MSG";
	public static final String RESULT_DATA = "RESULT_DATA";
	public static final String SCHEMA = "SCHEMA";
	
	public static final String FILE_NAME = "FILE_NAME";
	public static final String FILE_SIZE = "FILE_SIZE";
	public static final String FILE_DIRECTORY = "FILE_DIRECTORY";
	
	public static final String START_LEN = "START_LEN";
	public static final String DW_LEN = "DW_LEN";
	public static final String END_FLAG = "END_FLAG";

	public static final String SEEK = "SEEK";
	public static final String READLINE = "READLINE";
	
	public static final String CMD_HOSTNAME = "CMD_HOSTNAME";
	public static final String CMD_OS_VERSION = "CMD_OS_VERSION";
	public static final String CMD_OS_KERNUL = "CMD_OS_KERNUL";
	public static final String CMD_CPU = "CMD_CPU";
	public static final String CMD_MEMORY = "CMD_MEMORY";
	public static final String CMD_MACADDRESS = "CMD_MACADDRESS";
	public static final String CMD_NETWORK_IP = "CMD_NETWORK_IP";
	public static final String CMD_NETWORK = "CMD_NETWORK";
	public static final String CMD_NETWORK_INTERFACE = "CMD_NETWORK_INTERFACE";

	public static final String AGT_CNDT_CD = "AGT_CNDT_CD";
	public static final String RESULT_SUB_DATA = "RESULT_SUB_DATA";
	public static final String SEARCH_GBN = "SEARCH_GBN";
	public static final String REQ_CMD = "REQ_CMD"; //명령어
	
	public static final String PRY_ACT_RESULT = "PRY_ACT_RESULT"; //haproxy 실행 결과
	public static final String KAL_ACT_RESULT = "KAL_ACT_RESULT"; //keepalived 실행 결과
	public static final String EXECUTE_RESULT = "EXECUTE_RESULT"; //실행 결과
	public static final String PRY_PTH = "PRY_PTH"; //haproxy config 백업 경로
	public static final String KAL_PTH = "KAL_PTH"; //keepalived config 백업 경로
	public static final String INTERFACE_LIST = "INTERFACE_LIST";//Agent network Interface 목록 결과
	public static final String INTERFACE = "INTERFACE";//Agent network Interface 목록 결과
	
	public static final String DB_CHK = "DB_CHK";
	
	public static final String BACKUP_CONF = "BACKUP_CONF";
	public static final String PRESENT_CONF = "PRESENT_CONF";
	public static final String KAL_INSTALL_YN = "KAL_INSTALL_YN"; //keepalived 설치 여부
}
