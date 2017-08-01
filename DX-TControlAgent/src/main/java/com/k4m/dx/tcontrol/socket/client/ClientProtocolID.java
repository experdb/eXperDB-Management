package com.k4m.dx.tcontrol.socket.client;

/*
 * 전문에서 사용되는 코드값
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
	
	public static final String SCD_ID = "SCD_ID"; //스캐쥴ID
	public static final String WORK_ID = "WORK_ID"; //작업ID
	public static final String EXD_ORD = "EXD_ORD"; //실행순서
	public static final String NXT_EXD_YN = "NXT_EXD_YN"; //다음실행여부
	public static final String REQ_CMD = "REQ_CMD"; //명령어
	public static final String ARR_CMD = "ARR_CMD"; //명령어 Array
	
	public static final String COMMAND_CODE = "COMMAND_CODE"; // CRUD
	public static final String COMMAND_CODE_C = "COMMAND_CODE_C"; // C
	public static final String COMMAND_CODE_R = "COMMAND_CODE_R"; // R
	public static final String COMMAND_CODE_U = "COMMAND_CODE_U"; // U
	public static final String COMMAND_CODE_D = "COMMAND_CODE_D"; // D
	public static final String COMMAND_CODE_V = "COMMAND_CODE_V"; // view
	public static final String COMMAND_CODE_DL = "COMMAND_CODE_DL"; // download
	
	public static final String ACCESS_CONTROL_INFO = "ACCESS_CONTROL_INFO";
	public static final String AC_SEQ = "Seq";
	public static final String AC_SET = "Set";
	public static final String AC_TYPE = "Type";
	public static final String AC_DATABASE = "Database";
	public static final String AC_USER = "User";
	public static final String AC_IP = "Ip";
	public static final String AC_METHOD = "Method";
	public static final String AC_OPTION = "Option";
	public static final String AC_COMMENT = "Comment";
	
	public static final String EXTNAME = "extname"; //extension 명
	
	public static final String ARR_AC_SEQ = "arrSeq";
	
	//감사로그 종류
	public static final String SETTING_INFO = "setting_info";
	public static final String AUDIT_USE_YN = "use_yn";
	
	public static final String AUDIT_LOG = "log";
	public static final String AUDIT_LEVEL = "level";
	public static final String AUDIT_CATALOG = "catalog";
	public static final String AUDIT_PARAMETER = "parameter";
	public static final String AUDIT_RELATION = "relation";
	public static final String AUDIT_STATEMENT_ONCE = "statement_once";
	public static final String AUDIT_ROLE = "role";
	
	//감사로그 조회조건
	public static final String OBJECT_NAME = "object_name";
	public static final String USER_NAME = "user_name";
	public static final String START_DATE = "start_date";
	public static final String END_DATE = "end_date";
	public static final String FILE_NAME = "file_name";
	public static final String FILE_SIZE = "file_size";
	public static final String FILE_LASTMODIFIED = "file_lastmodified";
	public static final String FILE_DIRECTORY = "file_directory";
	public static final String SEARCH_INFO = "search_info";
	
	//KAFKA CONNECT
	public static final String CONNECTOR_INFO = "CONNECTOR_INFO";
	public static final String CONNECTOR_NAME = "CONNECTOR_NAME";
	public static final String HDFS_URL = "HDFS_URL";
	public static final String CONNECTOR_CLASS = "CONNECTOR_CLASS";
	public static final String TASK_MAX = "TASK_MAX";
	public static final String HADOOP_CONF_DIR = "HADOOP_CONF_DIR";
	public static final String HADOOP_HOOM = "HADOOP_HOOM";
	public static final String FLUSH_SIZE = "FLUSH_SIZE";
	public static final String ROTATE_INTERVAL_MS = "ROTATE_INTERVAL_MS";
	public static final String TOPIC = "TOPIC";
	
	
	public static final String EXEC_TXT = "EXEC_TXT";
	public static final String RUN = "RUN";
	public static final String STOP = "STOP";


}
