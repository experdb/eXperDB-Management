package com.k4m.dx.tcontrol.db;

import com.k4m.dx.tcontrol.db.datastructure.DataTable;

public class Constant {
	private Constant(){}
	public static String S = System.getProperty("file.separator"); // system file separator : "/" on UNIX, "\\" on WINDOWS
	public static String R = System.getProperty("line.separator");

    //SEED설정정보
    //public static int NONFIXED_SEED = 0;
    public static int FIXED_SEED = 0;
    
    public static String REPOSITORY_DB_TYPE;
    /*
    public final static String REPLACE_ORG_COL_NM = "$ORG_COLUMN$";
    public final static String REPLACE_COL_NM = "$COLUMN$";
    public final static String REPLACE_TBL_NM = "$TABLE$";
    public final static String REPLACE_SCHEMA_NM = "$SCHEMA$";
    public final static String REPLACE_COL_VAL = "$COLUMN_VALUE$";
    */
    
    public static final String CONVENTIONAL = "CONVENTIONAL";
    public static final String DIRECT_PATH_LOAD = "DIRECT PATH LOAD";
    
    public static final String SOURCE_POOL_ID = "SOURCE";   //소스 POOL을 식별하기 위한 스트링
    public static final String TARGET_POOL_ID = "TARGET";   //타겟 POOL을 식별하기 위한 스트링
        
    public static final String ORA_STAT_TABLE_NM = "DX$_$STAT"; //오라클  인덱스 통계정보 저장 테이블 명 
    
    //DB암호화 타입
	public class EncType{
		public final static String SAFEDB = "@SAFEDB@";
		public final static String DIAMO = "@DIAMO@";
	}
	
	/*
	public class EncArgType{
		public final static String ORG_COLUMN = "$ORG_COLUMN$";
		public final static String COLUMN = "$COLUMN$";
		public final static String ORG_TABLE = "$TABLE$";
		public final static String TABLE = "$TABLE$";
		public final static String COLUMN_VALUE = "$COLUMN_VALUE$";
		public final static String ERR_BYTE = "$ERR_BYTE$";
		public final static String SCHEMA = "$SCHEMA$";
	}
	*/
	
	//DB 종류 타입
    public class DB_TYPE
    {
    	public static final String ORA = "ORA";
    	public static final String POG = "POG";
    	public static final String POG_REP = "POG_REP";
	    public static final String MSS = "MSS";
	    public static final String TBR = "TBR";
	    public static final String DB2 = "DB2";
	    public static final String ASE = "ASE";
	    public static final String MYSQL = "MYSQL";
	    public static final String IQ = "IQ";
    }
    
    public class DAEMON_EXEC_ARGS
    {
    	public static final String ALL_TABLE = "-E";        //JOB 실행
    	public static final String EACH_TABLE = "-T";       //테이블 개별 실행
    	public static final String REMOVE = "-R";	        //데이터 삭제
    	public static final String COLLECT_CATALOG = "-C";  //데이터 삭제
    	public static final String BACKUP_CATALOG = "-B";   //데이터 백업
    	public static final String PRSN_PRIV_DATA = "-D";   //개인정보검출
    }

    public class DAEMON_ARGS
    {
    	public static final int ALL_TABLE = 0;         //JOB 실행
    	public static final int EACH_TABLE = 5;        //테이블 개별 실행
    	public static final int REMOVE = 15;	        //데이터 삭제
    	public static final int COLLECT_CATALOG = 16;  //데이터 삭제
    	public static final int BACKUP_CATALOG = 17;   //데이터 백업
    	public static final int PRSN_PRIV_DATA = 18;   //개인정보검출
    }
    
    public class DAEMON_NAME
    {
    	public static final String MIGRATION = "MIGRATION";        //JOB 실행
    	public static final String COLLECT_CATALOG = "COLLECT_CATALOG";       //테이블 개별 실행
    	public static final String REMOVE = "REMOVE";	        //데이터 삭제
    	public static final String BACKUP_CATALOG = "BACKUP_CATALOG";   //데이터 백업
    	public static final String DETECT_PRIV_DATA = "DETECT_PRIV_DATA";   //데이터 백업
    }
    
    public class DAEMON_JOB_ID
    {
    	public static final int SCHEDULER = -1;        //스케쥴러
    	public static final int COLLECT_CATALOG = -2;       //수집
    	public static final int BACKUP_CATALOG = -3;   //데이터 백업
    }
    
    public static enum POOLNAME
    {
    	REPOSITORY, SOURCE, TARGET;
    }    
    
    //로그 DB 저장 타입 enum 
    public static enum LOG_TYPE
    {
    	NONE, MAIN_DAEMON, SUB_DAEMON;
    }    
    
    public class JOBTYPE
    {
    	public static final String MIGRATION = "M";
    	public static final String DECTECT = "D";
    }
    
    public class JOBSTATUS 
    {
    	public static final int READY = 0;
    	public static final int RUNNING = 1;
    	public static final int SUCCESS_COMPLETE = 2;
    	public static final int JOB_ERROR = 3;
    	public static final int IMMEDIATELY_EXECUTE = 4;
    	public static final int EACH_EXECUTE = 5;
    	public static final int EXPIRED = 7;
    	public static final int CANCEL = 8;
    	public static final int CANCELED = 9;     
    	public static final int JOB_PARTIAL_SUCCESS = 10;
    }

    public class PREPARED_STMT_RESULT
    {
    	public static final int NORMAL = 0;
    	public static final int INCLUDE_LOB = 1;
    }
    
    public class JOB_APPROVE
    {
    	public static final int COMPLETE_APPROVE = 2;
    }   
    
	public static DataTable GetMaskTemplDt() throws Exception{
		DataTable dt = new DataTable();
		dt.SetTableName("TEMPLDT");
		dt.AddColumns(Constant.colNmList.MASKING_TYPE);
		dt.AddColumns(Constant.colNmList.MAPPING_TYPE);
		dt.AddColumns(Constant.colNmList.NOR_CHAR);
		dt.AddColumns(Constant.colNmList.START_POS);
		dt.AddColumns(Constant.colNmList.END_POS);
		
		return dt;
	}
	
    public static final char SYS_SPLIT_STR = (char)16;
    /*
    public static final String REPOSQL_XML_PATH = "src/com/dxmig/config/RepositoryQuery.xml";
    public static final String MIGSQL_XML_PATH = "src/com/dxmig/config/MigDbQuery.xml";
    public static final String COLLECT_XML_PATH = "src/com/dxmig/config/CollectMetaQuery.xml";
    public static final String WEBSQL_XML_PATH = "config/WebMetaQuery.xml";
    */
    public static final String SERVER_LOCAL_IP = "127.0.0.1";
    public static final String REPOSQL_XML_PATH = "com/dxmig/svr/sql/config/RepositoryQuery.xml";
    public static final String MIGSQL_XML_PATH = "com/dxmig/svr/sql/config/MigDbQuery.xml";
    public static final String COLLECT_XML_PATH = "com/dxmig/svr/sql/config/CollectMetaQuery.xml";
    public static final String WEBSQL_XML_PATH = "com/dxmig/svr/sql/config/WebMetaQuery.xml";
    public static final String LOG_PATH = ".." + Constant.S + "log";
    public static final String ANTHOLOGY_PATH = ".." + Constant.S + "config" + Constant.S + "anthlogy.bin";
    public static final String DXCONFIG_PATH = ".." + Constant.S + "config" + Constant.S + "DXConfig.config";
    public static final String LIBRARY_PATH = ".." + Constant.S + "lib";
    public static final String XML_SQL_ELEMENT = "SQL";
    public static final String XML_DESC_ELEMENT = "DESCRIPTION";
    public static final int REPOSITORY_DB_CONN_CNT = 5;    //RepositoryDB 커넥션풀 갯수
    public static final int MIG_DB_CONN_CNT = 4;    //RepositoryDB 커넥션풀 갯수

    public class ErrorCode
    {
    	public static final String NORMAL_ERROR = "600";   //범용 에러
    	public static final String PROCESS_CREATE_ERROR = "650";   //프로세스 생성 에러
    	public static final String DB_CLOSE_ERROR = "750";
    	public static final String INDEX_RECREATE_ERROR = "800";
    	public static final String MASKING_ERROR = "900";
    	public static final String NOT_SUPPORTED_DB = "1000";
    	public static final String DB_CONNECTION_TIMEOUT = "760";
    	
    }
    
    public class colNmList
    {
        public static final String ID  = "ID";
        public static final String PATH  = "PATH";
        public static final String JOB_ID  = "JOB_ID";
        public static final String JOB_NM  = "JOB_NM";
        public static final String SRC_PJT_ID  = "SRC_PJT_ID";
        public static final String SRC_SYS_NM  = "SRC_SYS_NM";
        public static final String SRC_SCHEMA_NM  = "SRC_SCHEMA_NM";
        public static final String TAR_PJT_ID  = "TAR_PJT_ID";
        public static final String TAR_SYS_NM  = "TAR_SYS_NM";
        public static final String TAR_COL_SNO  = "TAR_COL_SNO";
        public static final String TAR_DATA_TYPE  = "TAR_DATA_TYPE";
        public static final String TAR_DATA_PZN_LEN  = "TAR_DATA_PZN_LEN";
        public static final String TAR_DATA_DCL_LEN  = "TAR_DATA_DCL_LEN";
        public static final String SRC_DATA_TYPE  = "SRC_DATA_TYPE";
        public static final String SRC_DATA_PZN_LEN  = "SRC_DATA_PZN_LEN";
        public static final String SRC_DATA_DCL_LEN  = "SRC_DATA_DCL_LEN";
        public static final String TAR_SCHEMA_NM  = "TAR_SCHEMA_NM";
        public static final String MAPP_DEF_NM  = "MAPP_DEF_NM";
        public static final String MAPP_DEF_SEQ  = "MAPP_DEF_SEQ";
        public static final String SRC_COL_ENM  = "SRC_COL_ENM";
        public static final String SRC_COL_NM  = "SRC_COL_NM";
        public static final String TAR_COL_ENM  = "TAR_COL_ENM";
        public static final String SRC_COL_SNO  = "SRC_COL_SNO";
        public static final String SELECT_SQL  = "SELECT_SQL";
        public static final String TAR_TBL_ENM  = "TAR_TBL_ENM";
        public static final String SRC_TBL_ENM  = "SRC_TBL_ENM";
        public static final String COL_CV_LGIC  = "COL_CV_LGIC";
        public static final String COL_CV_PRC_CNTN  = "COL_CV_PRC_CNTN";
        public static final String FROM_SQL  = "FROM_SQL";
        public static final String WHERE_SQL  = "WHERE_SQL";
        public static final String ETC_INS_SQL  = "ETC_INS_SQL";
        public static final String ETC_SEL_SQL  = "ETC_SEL_SQL";
        public static final String HEAD_SQL  = "HEAD_SQL";
        public static final String TAIL_SQL  = "TAIL_SQL";
        public static final String TBL_RUL_CNTN  = "TBL_RUL_CNTN";
        public static final String TBL_GAP_CNTN  = "TBL_GAP_CNTN";
        public static final String TBL_GAP_PRC_PLAN  = "TBL_GAP_PRC_PLAN";
        public static final String FUNC_NAME  = "FUNC_NAME";
        public static final String FUNC_SNO  = "FUNC_SNO";
        public static final String FUNC_ID  = "FUNC_ID";
        public static final String ARGS_SNO  = "ARGS_SNO";
        public static final String ARGS_VALUE  = "ARGS_VALUE";
        public static final String LOAD_MODE  = "LOAD_MODE";
        public static final String INPUT_MODE  = "INPUT_MODE";
        public static final String FETCH_SIZE  = "FETCH_SIZE";
        public static final String EXE_DEGREE  = "EXE_DEGREE";
        public static final String COLUMN_NAME  = "COLUMN_NAME";
        public static final String EXE_YM_DD  = "EXE_YM_DD";
        public static final String REGI_TIME  = "REGI_TIME";
        public static final String JOB_EXE_GB  = "JOB_EXE_GB";
        public static final String JOB_DEGREE  = "JOB_DEGREE";
        public static final String JOB_STS = "JOB_STS";
        public static final String NEXT_DATE  = "NEXT_DATE";
        public static final String EXE_TIME  = "EXE_TIME";
        public static final String JOB_GB  = "JOB_GB";
        public static final String ITER_GB  = "ITER_GB";
        public static final String START_DATE  = "START_DATE";
        public static final String END_DATE  = "END_DATE";
        public static final String COUNT  = "COUNT";
        public static final String CHECK  = "CHECK";
        public static final String TEMP_CELL  = "TEMP_CELL";
        public static final String PJT_ID  = "PJT_ID";
        public static final String PJT_NM  = "PJT_NM";
        public static final String SYS_NM  = "SYS_NM";
        public static final String SCHEMA_NM  = "SCHEMA_NM";
        public static final String SRC_TBL_ALIAS  = "SRC_TBL_ALIAS";
        public static final String USE_YN  = "USE_YN";
        public static final String EXPIRED_DATA_TRUNC_YN  = "EXPIRED_DATA_TRUNC_YN";
        public static final String EXPIRED_DATA_TRUNC_DATE  = "EXPIRED_DATA_TRUNC_DATE";
        public static final String SEED  = "SEED";
        public static final String EXPIRED_DATA_TRUNC_EXE_GB  = "EXPIRED_DATA_TRUNC_EXE_GB";
        public static final String CONSTRAINT_NAME  = "CONSTRAINT_NAME";
        public static final String CONSTRAINT_TYPE  = "CONSTRAINT_TYPE";
        public static final String TABLE_NAME  = "TABLE_NAME";
        public static final String R_TABLE_NAME  = "R_TABLE_NAME";
        public static final String CONSTRAINT_STATUS  = "CONSTRAINT_STATUS";
        public static final String ST_TM_DISABLED  = "ST_TM_DISABLED";
        public static final String ED_TM_DISABLED  = "ED_TM_DISABLED";
        public static final String ST_TM_ENABLED  = "ST_TM_ENABLED";
        public static final String ED_TM_ENABLED  = "ED_TM_ENABLED";
        public static final String EXE_TM  = "EXE_TM";
        public static final String EXE_STS  = "EXE_STS";
        public static final String DATA  = "DATA";
        public static final String PWD_MDFC_DT  = "PWD_MDFC_DT";
        public static final String CHARSET  = "CHARSET";
        public static final String DB_TYPE  = "DB_TYPE";
        public static final String LT_WK_DTTI  = "LT_WK_DTTI";
        public static final String LT_WK_PRSN  = "LT_WK_PRSN";
        public static final String TBL_ENM  = "TBL_ENM";
        public static final String TBL_KNM  = "TBL_KNM";
        public static final String MDL_ID  = "MDL_ID";
        public static final String CVSN_DV  = "CVSN_DV";
        public static final String TBL_DTL_DEF  = "TBL_DTL_DEF";
        public static final String COL_ENM  = "COL_ENM";
        public static final String COL_KNM  = "COL_KNM";
        public static final String COL_SNO  = "COL_SNO";
        public static final String PK_YN  = "PK_YN";
        public static final String DATA_TYPE  = "DATA_TYPE";
        public static final String DATA_PZN_LEN  = "DATA_PZN_LEN";
        public static final String DATA_DCL_LEN  = "DATA_DCL_LEN";
        public static final String NULL_YN  = "NULL_YN";
        public static final String DEF_VAL  = "DEV_VAL";
        public static final String COL_DTL_DEF  = "COL_DTL_DEF";
        public static final String CD_DV  = "CD_DV";
        public static final String OBJECT_NAME  = "OBJECT_NAME";
        public static final String OBJECT_TYPE  = "OBJECT_TYPE";
        public static final String OBJ_NAME  = "OBJ_NAME";
        public static final String OBJ_TYPE  = "OBJ_TYPE";
        public static final String RECREATE_SCRIPT  = "RECREATE_SCRIPT";
        public static final String INDX_ENM  = "INDX_ENM";
        public static final String INDX_OTH_ENTR  = "INDX_OTH_ENTR";
        public static final String IDX_DR_REB_YN  = "IDX_DR_REB_YN";
        public static final String NOLOGGING_YN  = "NOLOGGING_YN";
        public static final String SEL_DEGREE  = "SEL_DEGREE";
        public static final String LOGG_YN  = "LOGG_YN";
        public static final String FIR_REG_YM_DD  = "FIR_REG_YM_DD";
        public static final String TEMPL_NM  = "TEMPL_NM";
        public static final String SPT_NM  = "SPT_NM";
        public static final String SEQUENCE_NAME  = "SEQUENCE_NAME";
        public static final String GRANTED_SCHEMA_NM  = "GRANTED_SCHEMA_NM";
        public static final String OWNER  = "OWNER";
        public static final String SRC_GRANTED_SCHEMA_NM  = "SRC_GRANTED_SCHEMA_NM";
        public static final String TAR_GRANTED_SCHEMA_NM  = "TAR_GRANTED_SCHEMA_NM";
        public static final String SNGL_ATHR_YN  = "SNGL_ATHR_YN";
        public static final String IDX_DEGREE  = "IDX_DEGREE";
        public static final String IDX_THREAD  = "IDX_THREAD";
        public static final String COMMIT_ROW_CNT  = "COMMIT_ROW_CNT";
        public static final String SRC_ENC_FUNC_NM  = "SRC_ENC_FUNC_NM";
        public static final String TAR_ENC_FUNC_NM  = "TAR_ENC_FUNC_NM";
        public static final String SRC_ENC_FUNC_NM_ORG  = "SRC_ENC_FUNC_NM_ORG";
        public static final String TAR_ENC_FUNC_NM_ORG  = "TAR_ENC_FUNC_NM_ORG";
        public static final String REGI_DTTI  = "REGI_DTTI";
        public static final String REGI_ID  = "REGI_ID";
        public static final String MASKING_TYPE  = "MASKING_TYPE";
        public static final String MAPPING_TYPE  = "MAPPING_TYPE";
        public static final String NOR_CHAR  = "NOR_CHAR";
        public static final String START_POS  = "START_POS";
        public static final String END_POS  = "END_POS";
        public static final String SEQ_NO  = "SEQ_NO";
        public static final String TEMPL_DESCRIPT  = "TEMPL_DESCRIPT";
        public static final String CONS_ERR_CNT  = "CONS_ERR_CNT";        
        public static final String ST_TM = "ST_TM";
        public static final String ED_TM = "ED_TM";
        public static final String CNT_CHK = "CNT_CHK";
        public static final String EXE_CNT = "EXE_CNT";
        public static final String SEQ = "SEQ";
        public static final String TYPE = "TYPE";        
        public static final String DB_NM = "DB_NM";
        public static final String DRV_NM = "DRV_NM";
        public static final String IP = "IP";
        public static final String PORT = "PORT";
        public static final String OWNER_NM = "OWNER_NM";
        public static final String DB_PW = "DB_PW";
        public static final String INS_CNT = "INS_CNT";
        public static final String SEL_CNT = "SEL_CNT";
        public static final String LOG_MSG = "LOG_MSG";
        public static final String LOG_TIME = "LOG_TIME";
        public static final String DOMAIN = "DOMAIN";
        public static final String CODE = "CODE";
        public static final String AFTER_SCRIPT = "AFTER_SCRIPT";
        public static final String DDL_SCRIPT = "DDL_SCRIPT";
        public static final String DROP_INDEX_SCRIPT = "DROP_INDEX_SCRIPT";
        public static final String DROP_STATUS = "DROP_STATUS";
        public static final String CREATE_STATUS = "CREATE_STATUS";
        public static final String ORG_DDL_SCRIPT = "ORG_DDL_SCRIPT";
        public static final String DROP_DDL_SCRIPT = "DROP_DDL_SCRIPT";
        public static final String CREATE_DDL_SCRIPT = "CREATE_DDL_SCRIPT";
        public static final String ENABLE_CONS_DDL_SCRIPT = "ENABLE_CONS_DDL_SCRIPT";
        public static final String DISABLE_CONS_DDL_SCRIPT = "DISABLE_CONS_DDL_SCRIPT";
        public static final String SEQUENCE_OWNER = "SEQUENCE_OWNER";
        public static final String MIN_VALUE = "MIN_VALUE";
        public static final String MAX_VALUE = "MAX_VALUE";
        public static final String INCREMENT_BY = "INCREMENT_BY";
        public static final String CYCLE_FLAG = "CYCLE_FLAG";
        public static final String ORDER_FLAG = "ORDER_FLAG";
        public static final String CACHE_SIZE = "CACHE_SIZE";
        public static final String LAST_NUMBER = "LAST_NUMBER";
        public static final String INSTANCE_ID = "INSTANCE_ID";
        public static final String STATUS = "STATUS";
        public static final String LICENSE = "LICENSE";
        public static final String JOB_TYPE = "JOB_TYPE";
        public static final String REPOSITORY_NAME = "REPOSITORY_NAME";
        public static final String DATA_SEL_CNT = "DATA_SEL_CNT";
        public static final String ENC_TEMPL_NM = "ENC_TEMPL_NM";
        public static final String ENC_JOB_GB = "ENC_JOB_GB";
        
        //MigDbCtl
        public static final String PT_YN = "PT_YN";
        public static final String TBL_SPCE_NM = "TBL_SPCE_NM";
        public static final String CMPR_YN = "CMPR_YN";
        public static final String CLUSTERED = "P_CLUSTERED";
        public static final String FILL_FACTOR = "P_FILL_FACTOR";
        public static final String MAXROWSPERPAGE = "P_MAXROWSPERPAGE";
        public static final String RESERVED_GAP_PAGE = "P_RESERVED_GAP_PAGE";
        public static final String SORTED_DATA_YN = "P_SORTED_DATA_YN";
        public static final String ALLOW_DUP_ROW_YN = "P_ALLOW_DUP_ROW_YN";
        public static final String DESCEND = "DESCEND";
        public static final String IDX_COL_INFO = "IDX_COL_INFO";
        public static final String PT_MST_INFO = "PT_MST_INFO";
        public static final String LOCAL_YN = "LOCAL_YN";
        public static final String PARTITION_NAME= "PARTITION_NAME";
        public static final String EXP_TBL_STAT = "EXP_TBL_STAT";    //오라클 통계정보 추출
        public static final String IMP_TBL_STAT = "IMP_TBL_STAT";    //오라클 통계정보 입력
        public static final String GENERATED = "P_GENERATED";
        public static final String VALIDATED = "P_VALIDATED";
        public static final String CONS_INDEX_NM = "P_CONS_INDEX_NM";
        public static final String CONS_BY_CREATED_IDX = "CONS_BY_CREATED_IDX";
        public static final String INDX_TYPE = "INDX_TYPE";
        public static final String IS_PADDED = "P_IS_PADDED";
        public static final String IGNORE_DUP_KEY = "P_IGNORE_DUP_KEY";
        public static final String STATISTICS_NORECOMPUTE = "P_STATISTICS_NORECOMPUTE";
        public static final String STATISTICS_INCREMENTAL = "P_STATISTICS_INCREMENTAL";
        public static final String ALLOW_ROW_LOCKS = "P_ALLOW_ROW_LOCKS";
        public static final String ALLOW_PAGE_LOCKS = "P_ALLOW_PAGE_LOCKS";
        public static final String FILTER_DEFINITION = "P_FILTER_DEFINITION";
        public static final String PARTITION_SCHEMA_NM = "P_PARTITION_SCHEMA_NM";
        public static final String PARTITION_COL_ENM = "P_PARTITION_COL_ENM";
        public static final String CMPR_DESC = "P_CMPR_DESC";
        public static final String FILESTREAM_FILEGROUP_NAME = "P_FILESTREAM_FILEGROUP_NAME";
        public static final String PCTFREE = "P_PCTFREE";
        public static final String LV2_PCTFREE = "P_LV2_PCTFREE";
        public static final String MINPCTUSED = "P_MINPCTUSED";
        public static final String REVERSE_SCANS = "P_REVERSE_SCANS";
        public static final String PAGE_SPLIT = "P_PAGE_SPLIT";
        public static final String COLLECT = "P_COLLECT";
        public static final String XML_PATTERN = "P_XML_PATTERN";
        public static final String TB_PT_YN = "P_TB_PT_YN";
        public static final String INI_TRANS = "P_INI_TRANS";
        public static final String P_STATUS = "P_STATUS";
        public static final String INITIAL_EXTENT = "P_INITIAL_EXTENT";
        public static final String NEXT_EXTENT = "P_NEXT_EXTENT";
        public static final String REVERSE = "P_REVERSE";
        public static final String PARTITION_TYPE = "PARTITION_TYPE";
        public static final String HIGH_VALUE = "P_HIGH_VALUE";
        public static final String PREFIXED = "P_PREFIXED";
        public static final String MAXEXTENTS = "P_MAXEXTENTS";
        public static final String SUBPARTITION_NAME = "SUBPARTITION_NAME";
        public static final String SUBPARTITION_COUNT = "SUBPARTITION_COUNT";
        public static final String SUBPARTITION_TYPE = "SUBPARTITION_TYPE";
        //prsn
        public static final String PRSN_CD = "PRSN_CD";
        public static final String DATA_RSLT_CNT = "DATA_RSLT_CNT";
        public static final String RSLT_DATA = "RSLT_DATA";
        
      }
}