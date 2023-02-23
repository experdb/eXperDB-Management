package com.experdb.proxy.db.datastructure;

/*
 * DB 접속 및 기타 정보 저장 클래스
 */
public class ConfigInfo implements java.io.Serializable{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	/**
	 * 접속 유저명
	 */
	public String USERID;	
	
	/**
	 * 서버 IP
	 */
	public String SERVERIP;		//서버 IP
	
	/**
	 * DB명
	 */
	public String DBNAME;		//DB명
	
	/**
	 * 포트
	 */
	public String PORT;			//포트
	
	/**
	 * 스키마명
	 */
	public String SCHEMA_NAME;	//스키마명
	
	/**
	 * DB타입
	 */
	public String DB_TYPE;		//DB타입
	
	/**
	 * 서버명
	 */
	public String SERVER_NAME;	//서버명
	
	/**
	 * DB 패스워드
	 */
	public String DB_PW;		//패스워드
	
	/**
	 * DB 캐릭터셋
	 */
	public String CHARSET;		//캐릭터셋
	
	/**
	 * 프로젝트 ID
	 */
	public String PJT_ID;  //프로젝트 ID
	
	/**
	 * 시스템명
	 */
	public String SYS_NM;  //시스템명
	
	/**
	 * DB 버전
	 */
	public String DB_VER;  //DB버전
	
	public String HOSTIP;		//SSH 접속 IP
	public String HOSTUSER;		//SSH 접속 OSID 
	public String HOSTUSERPW;  //SSH OS 패스워드
	public String LOAD_MODE;
	public String ORG_SCHEMA_NM;  //Repository DB에 저장되는 이름이 아닌 실제 DB에 저장되는 스키마명(대소문자 구분때문에 사용)
	//public Properties props = new Properties();
	
	public ConfigInfo(){		
	}
	
	public ConfigInfo(String strUSERID, String strDbPw, String strSERVERIP, String strDBNAME, String strPORT, String strSCHEMA_NAME, String strDB_TYPE, String strSERVER_NAME, String strCHARSET, String strHostIP, String strHostUser, String HostUserPWD) {
        USERID = strUSERID;
        //USERPW = strUSERPW;
        SERVERIP = strSERVERIP;
        DBNAME = strDBNAME;
        PORT = strPORT;
        SCHEMA_NAME = strSCHEMA_NAME;
        DB_TYPE = strDB_TYPE;
        SERVER_NAME = strSERVER_NAME;
        //COMMENT = strCOMMENT;
        DB_PW = strDbPw;
        CHARSET = strCHARSET;
        //GRANTED_SCHEMA_NM = strGRANTED_SCHEMA_NM;
        HOSTIP = strHostIP;
        HOSTUSER = strHostUser;
        HOSTUSERPW = HostUserPWD;
        
        /*
        // ID and Password
        props.put("user", USERID);
        props.put("password", DB_PW);
        props.put("charset", CHARSET);
        */
	}
}
