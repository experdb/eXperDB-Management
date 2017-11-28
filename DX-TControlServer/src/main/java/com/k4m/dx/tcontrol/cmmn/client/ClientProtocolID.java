package com.k4m.dx.tcontrol.cmmn.client;

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
	public static final String COMMAND_CODE_D_A = "COMMAND_CODE_D_A"; // delete all
	
	public static final String ACCESS_CONTROL_INFO = "ACCESS_CONTROL_INFO";
	public static final String AC_SEQ = "Seq";
	public static final String AC_SET = "Set";
	public static final String AC_TYPE = "Type";
	public static final String AC_DATABASE = "Database";
	public static final String AC_USER = "User";
	public static final String AC_IP = "Ip";
	public static final String AC_IPMASK = "Ipmask";
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
	public static final String TRF_TRG_ID = "TRF_TRG_ID";
	
	
	public static final String EXEC_TXT = "EXEC_TXT";
	public static final String RUN = "RUN";
	public static final String STOP = "STOP";

	public static final String TABLE_INFO = "TABLE_INFO";
	public static final String TABLE_NAME = "TABLE_NAME";
	public static final String TABLE_SCHEMA= "TABLE_SCHEMA";
	public static final String TOPIC_NAME = "TOPIC_NAME";
	public static final String CONNECT_NAME = "CONNECT_NAME";
	public static final String CONTENTS = "CONTENTS";
	public static final String REMARK = "REMARK";
	
	public static final String BCK_OPT_CD = "BCK_OPT_CD";
	public static final String DB_ID = "DB_ID";
	public static final String BCK_FILE_PTH = "BCK_FILE_PTH";
	public static final String LOG_YN = "LOG_YN";
	public static final String BCK_FILENM = "BCK_FILENM";
	
	public static final String IS_DIRECTORY = "IS_DIRECTORY";
	public static final String CAPACITY = "CAPACITY";
	
	public static final String SLOT = "SLOT";
	
	public static final String MASTER_GBN = "MASTER_GBN";
	public static final String ARR_SERVER_INFO = "ARR_SERVER_INFO";
	public static final String CONNECT_YN = "CONNECT_YN";
	
	public static final String CMD_HOSTNAME = "CMD_HOSTNAME";
	public static final String CMD_OS_VERSION = "CMD_OS_VERSION";
	public static final String CMD_OS_KERNUL = "CMD_OS_KERNUL";
	public static final String CMD_CPU = "CMD_CPU";
	public static final String CMD_MEMORY = "CMD_MEMORY";
	public static final String CMD_MACADDRESS = "CMD_MACADDRESS";
	public static final String CMD_IPADDRESS = "CMD_IPADDRESS";
	public static final String CMD_NETWORK = "CMD_NETWORK";
	public static final String CMD_NETWORK_INTERFACE = "CMD_NETWORK_INTERFACE";
	
	public static final String CMD_DBMS_PATH = "CMD_DBMS_PATH";
	public static final String CMD_DATA_PATH = "CMD_DATA_PATH";
	public static final String CMD_BACKUP_PATH = "CMD_BACKUP_PATH";
	public static final String CMD_ARCHIVE_PATH = "CMD_ARCHIVE_PATH";
	public static final String CMD_DATABASE_INFO = "CMD_DATABASE_INFO";
	
	public static final String CMD_LISTEN_ADDRESSES = "CMD_LISTEN_ADDRESSES";
	public static final String CMD_PORT = "CMD_PORT";
	public static final String CMD_MAX_CONNECTIONS = "CMD_MAX_CONNECTIONS";
	public static final String CMD_SHARED_BUFFERS = "CMD_SHARED_BUFFERS";
	public static final String CMD_EFFECTIVE_CACHE_SIZE = "CMD_EFFECTIVE_CACHE_SIZE";
	public static final String CMD_WORK_MEM = "CMD_WORK_MEM";
	public static final String CMD_MAINTENANCE_WORK_MEM = "CMD_MAINTENANCE_WORK_MEM";
	public static final String CMD_MIN_WAL_SIZE = "CMD_MIN_WAL_SIZE";
	public static final String CMD_MAX_WAL_SIZE = "CMD_MAX_WAL_SIZE";
	public static final String CMD_WAL_LEVEL = "CMD_WAL_LEVEL";
	public static final String CMD_WAL_BUFFERS = "CMD_WAL_BUFFERS";
	public static final String CMD_WAL_KEEP_SEGMENTS = "CMD_WAL_KEEP_SEGMENTS";
	public static final String CMD_ARCHIVE_MODE = "CMD_ARCHIVE_MODE";
	public static final String CMD_ARCHIVE_COMMAND = "CMD_ARCHIVE_COMMAND";
	public static final String CMD_CONFIG_FILE = "CMD_CONFIG_FILE";
	public static final String CMD_DATA_DIRECTORY = "CMD_DATA_DIRECTORY";
	public static final String CMD_HOT_STANDBY = "CMD_HOT_STANDBY";
	public static final String CMD_TIMEZONE = "CMD_TIMEZONE";
	public static final String CMD_SHARED_PRELOAD_LIBRARIES = "CMD_SHARED_PRELOAD_LIBRARIES";
	public static final String CMD_TABLESPACE_INFO = "CMD_TABLESPACE_INFO";
	
	public static final String START_LEN = "START_LEN";
	public static final String DW_LEN = "DW_LEN";
	public static final String END_FLAG = "END_FLAG";

}
