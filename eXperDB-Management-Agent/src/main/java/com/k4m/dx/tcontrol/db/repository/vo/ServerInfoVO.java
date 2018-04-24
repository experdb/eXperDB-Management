package com.k4m.dx.tcontrol.db.repository.vo;

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
public class ServerInfoVO {
	
	private String HOSTNAME;
	private String POSTGRESQL_VERSION;
	private String DBMS_PATH;
	private String DATA_PATH;
	private String BACKUP_PATH;
	private String ARCHIVE_PATH;
	private String DATABASE_INFO;
	        
	private String LISTEN_ADDRESSES;
	private String PORT;
	private String MAX_CONNECTIONS;
	private String SHARED_BUFFERS;
	private String EFFECTIVE_CACHE_SIZE;
	private String WORK_MEM;
	private String MAINTENANCE_WORK_MEM;
	private String MIN_WAL_SIZE;
	private String MAX_WAL_SIZE;
	private String WAL_LEVEL;
	private String WAL_BUFFERS;
	private String WAL_KEEP_SEGMENTS;
	private String ARCHIVE_MODE;
	private String ARCHIVE_COMMAND;
	private String CONFIG_FILE;
	private String DATA_DIRECTORY;
	private String HOT_STANDBY;
	private String TIMEZONE;
	private String SHARED_PRELOAD_LIBRARIES;
	private String TABLESPACE_INFO;
	private String SKEY;
	private String SDATA;
	
	
	public String getSKEY() {
		return SKEY;
	}
	public void setSKEY(String sKEY) {
		SKEY = sKEY;
	}
	public String getSDATA() {
		return SDATA;
	}
	public void setSDATA(String sDATA) {
		SDATA = sDATA;
	}
	public String getHOSTNAME() {
		return HOSTNAME;
	}
	public void setHOSTNAME(String hOSTNAME) {
		HOSTNAME = hOSTNAME;
	}
	
	public String getPOSTGRESQL_VERSION() {
		return POSTGRESQL_VERSION;
	}
	public void setPOSTGRESQL_VERSION(String pOSTGRESQL_VERSION) {
		POSTGRESQL_VERSION = pOSTGRESQL_VERSION;
	}
	public String getDBMS_PATH() {
		return DBMS_PATH;
	}
	public void setDBMS_PATH(String dBMS_PATH) {
		DBMS_PATH = dBMS_PATH;
	}
	public String getDATA_PATH() {
		return DATA_PATH;
	}
	public void setDATA_PATH(String dATA_PATH) {
		DATA_PATH = dATA_PATH;
	}
	public String getBACKUP_PATH() {
		return BACKUP_PATH;
	}
	public void setBACKUP_PATH(String bACKUP_PATH) {
		BACKUP_PATH = bACKUP_PATH;
	}
	public String getARCHIVE_PATH() {
		return ARCHIVE_PATH;
	}
	public void setARCHIVE_PATH(String aRCHIVE_PATH) {
		ARCHIVE_PATH = aRCHIVE_PATH;
	}
	public String getDATABASE_INFO() {
		return DATABASE_INFO;
	}
	public void setDATABASE_INFO(String dATABASE_INFO) {
		DATABASE_INFO = dATABASE_INFO;
	}
	public String getLISTEN_ADDRESSES() {
		return LISTEN_ADDRESSES;
	}
	public void setLISTEN_ADDRESSES(String lISTEN_ADDRESSES) {
		LISTEN_ADDRESSES = lISTEN_ADDRESSES;
	}
	public String getPORT() {
		return PORT;
	}
	public void setPORT(String pORT) {
		PORT = pORT;
	}
	public String getMAX_CONNECTIONS() {
		return MAX_CONNECTIONS;
	}
	public void setMAX_CONNECTIONS(String mAX_CONNECTIONS) {
		MAX_CONNECTIONS = mAX_CONNECTIONS;
	}
	public String getSHARED_BUFFERS() {
		return SHARED_BUFFERS;
	}
	public void setSHARED_BUFFERS(String sHARED_BUFFERS) {
		SHARED_BUFFERS = sHARED_BUFFERS;
	}
	public String getEFFECTIVE_CACHE_SIZE() {
		return EFFECTIVE_CACHE_SIZE;
	}
	public void setEFFECTIVE_CACHE_SIZE(String eFFECTIVE_CACHE_SIZE) {
		EFFECTIVE_CACHE_SIZE = eFFECTIVE_CACHE_SIZE;
	}
	public String getWORK_MEM() {
		return WORK_MEM;
	}
	public void setWORK_MEM(String wORK_MEM) {
		WORK_MEM = wORK_MEM;
	}
	public String getMAINTENANCE_WORK_MEM() {
		return MAINTENANCE_WORK_MEM;
	}
	public void setMAINTENANCE_WORK_MEM(String mAINTENANCE_WORK_MEM) {
		MAINTENANCE_WORK_MEM = mAINTENANCE_WORK_MEM;
	}
	public String getMIN_WAL_SIZE() {
		return MIN_WAL_SIZE;
	}
	public void setMIN_WAL_SIZE(String mIN_WAL_SIZE) {
		MIN_WAL_SIZE = mIN_WAL_SIZE;
	}
	public String getMAX_WAL_SIZE() {
		return MAX_WAL_SIZE;
	}
	public void setMAX_WAL_SIZE(String mAX_WAL_SIZE) {
		MAX_WAL_SIZE = mAX_WAL_SIZE;
	}
	public String getWAL_LEVEL() {
		return WAL_LEVEL;
	}
	public void setWAL_LEVEL(String wAL_LEVEL) {
		WAL_LEVEL = wAL_LEVEL;
	}
	public String getWAL_BUFFERS() {
		return WAL_BUFFERS;
	}
	public void setWAL_BUFFERS(String wAL_BUFFERS) {
		WAL_BUFFERS = wAL_BUFFERS;
	}
	public String getWAL_KEEP_SEGMENTS() {
		return WAL_KEEP_SEGMENTS;
	}
	public void setWAL_KEEP_SEGMENTS(String wAL_KEEP_SEGMENTS) {
		WAL_KEEP_SEGMENTS = wAL_KEEP_SEGMENTS;
	}
	public String getARCHIVE_MODE() {
		return ARCHIVE_MODE;
	}
	public void setARCHIVE_MODE(String aRCHIVE_MODE) {
		ARCHIVE_MODE = aRCHIVE_MODE;
	}
	public String getARCHIVE_COMMAND() {
		return ARCHIVE_COMMAND;
	}
	public void setARCHIVE_COMMAND(String aRCHIVE_COMMAND) {
		ARCHIVE_COMMAND = aRCHIVE_COMMAND;
	}
	public String getCONFIG_FILE() {
		return CONFIG_FILE;
	}
	public void setCONFIG_FILE(String cONFIG_FILE) {
		CONFIG_FILE = cONFIG_FILE;
	}
	public String getDATA_DIRECTORY() {
		return DATA_DIRECTORY;
	}
	public void setDATA_DIRECTORY(String dATA_DIRECTORY) {
		DATA_DIRECTORY = dATA_DIRECTORY;
	}
	public String getHOT_STANDBY() {
		return HOT_STANDBY;
	}
	public void setHOT_STANDBY(String hOT_STANDBY) {
		HOT_STANDBY = hOT_STANDBY;
	}
	public String getTIMEZONE() {
		return TIMEZONE;
	}
	public void setTIMEZONE(String tIMEZONE) {
		TIMEZONE = tIMEZONE;
	}
	public String getSHARED_PRELOAD_LIBRARIES() {
		return SHARED_PRELOAD_LIBRARIES;
	}
	public void setSHARED_PRELOAD_LIBRARIES(String sHARED_PRELOAD_LIBRARIES) {
		SHARED_PRELOAD_LIBRARIES = sHARED_PRELOAD_LIBRARIES;
	}
	public String getTABLESPACE_INFO() {
		return TABLESPACE_INFO;
	}
	public void setTABLESPACE_INFO(String tABLESPACE_INFO) {
		TABLESPACE_INFO = tABLESPACE_INFO;
	}
	
	


}
