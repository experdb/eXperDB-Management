/**
 * <pre>
 * Copyright (c) 2014 K4M, Inc.
 * All right reserved.
 *
 * This software is the confidential and proprietary information of K4M, Inc. 
 * You shall not disclose such confidential information and
 * shall use it only in accordance with the terms of the license agreement
 * you entered into with K4M.
 * </pre>
 */
package com.k4m.dx.tcontrol.cmmn.serviceproxy;

/**
 * TODO add description
 * @date 2014. 12. 15.
 * @author Kim, Sunho
 */

/**
 * @brief 전역 코드와 상수 정의
 * 
 *        시스템 전역에서 사용하는 코드와 기본값 등의 상수에 대한 정의를 포함한다. 서버 시스템의 SystemCode와 필요한 상수들에 대해 함께 관리되어야 한다.
 * @date 2015. 1. 4.
 * @author Kim, Sunho
 */
public class SystemCode {

	private SystemCode() {
	}
	
	public static class BitMask {

		public static final int		BACKUP_INCLUDE_CRYPTO_KEY					= 0x1;

		public static final int		BACKUP_INCLUDE_POLICY						= 0x2;

		public static final int		BACKUP_INCLUDE_SERVER						= 0x4;

		public static final int		BACKUP_INCLUDE_ADMIN_USER					= 0x10000;

		public static final int		BACKUP_INCLUDE_CONFIG						= 0x20000;

		public static final int		BACKUP_INCLUDE_SITE_LOG						= 0x100000;

		public static final int		BACKUP_INCLUDE_CORE_LOG						= 0x200000;

		public static final int		BACKUP_INCLUDE_BACKUP_LOG					= 0x400000;

		public static final int		BACKUP_INCLUDE_MONITOR_SYSTEM_USAGE_LOG		= 0x800000;

		public static final int		BACKUP_INCLUDE_MONITOR_SYSTEM_STATUS_LOG	= 0x1000000;

		public static final int		BACKUP_INCLUDE_TABLE_CRYPT_LOG				= 0x2000000;

		public static final int		BACKUP_INCLUDE_ALL_LOG						= 0x7FF00000;

		public static final long	POLICY_OPT_NO_AUDIT_LOG_ON_SUCCESS			= 0x100;

		public static final long	POLICY_OPT_NO_AUDIT_LOG_ON_FAIL				= 0x200;

		public static final long	POLICY_OPT_DISABLE_AUDIT_LOG				= 0x300;

		public static final long	POLICY_OPT_COMPRESS_AUDIT_LOG				= 0x80;

		private BitMask() {
		}
	}

	public static final String	SSL_PROTOCOL	= "TLS";
	public static final String	DATETIME_FORMAT					= "yyyy-MM-dd HH:mm:ss.SSS";

	public class ServiceName {
		private ServiceName() {
		}

		public static final String	AUTH_SERVICE	= "authService";

		public static final String	ENTITY_SERVICE	= "entityService";

		public static final String	POLICY_SERVICE	= "policyService";
		public static final String	SYSTEM_SERVICE	= "systemService";
		public static final String	AGENT_SERVICE	= "agentService";
		public static final String	KEY_SERVICE		= "keyService";
		public static final String	RESOURCE_SERVICE	= "resourceService";
		public static final String	SCHEMA_SERVICE		= "schemaService";
		public static final String	CRYPTO_SERVICE		= "cryptoService";
		public static final String	LOG_SERVICE			= "logService";
		public static final String	BACKUP_SERVICE		= "backupService";
		public static final String	SYNC_SERVICE		= "syncService";
		public static final String	MONITOR_SERVICE		= "monitorService";
		public static final String	TOGGLE_SERVICE		= "toggleLogger";
	}
	
	public class ServiceCommand {
		private ServiceCommand() {
		}
		
		public static final String LOGIN =	"login";
		public static final String LOGOUT =	"logout";
		public static final String UPDATEPASSWORD =	"updatePassword";
		public static final String INSERTENTITY =	"insertEntity";
		public static final String INSERTENTITYWITHPERMISSION =	"insertEntityWithPermission";
		public static final String UPDATEENTITY =	"updateEntity";
		public static final String UPDATEENTITYWITHPERMISSION =	"updateEntityWithPermission";
		public static final String DELETEENTITY =	"deleteEntity";
		public static final String SELECTENTITYPERMISSION =	"selectEntityPermission";
		public static final String SELECTENTITYLIST =	"selectEntityList";
		public static final String SELECTENTITYCONTENTS =	"selectEntityContents";
		public static final String SELECTPROFILELIST =	"selectProfileList";
		public static final String SELECTPROFILEPROTECTION =	"selectProfileProtection";
		public static final String SELECTPROFILEPROTECTIONVERSION =	"selectProfileProtectionVersion";
		public static final String SELECTPROFILEPROTECTIONLIST =	"selectProfileProtectionList";
		public static final String SELECTPROFILECIPHERSPECLIST =	"selectProfileCipherSpecList";
		public static final String SELECTPROFILEACLSPECLIST =	"selectProfileAclSpecList";
		public static final String INSERTPROFILEPROTECTION =	"insertProfileProtection";
		public static final String UPDATEPROFILEPROTECTION =	"updateProfileProtection";
		public static final String DELETEPROFILEPROTECTION =	"deleteProfileProtection";
		public static final String SELECTPROFILEPROTECTIONCONTENTS =	"selectProfileProtectionContents";
		public static final String INSERTQUERYCONVERSION =	"insertQueryConversion";
		public static final String UPDATEQUERYCONVERSION =	"updateQueryConversion";
		public static final String DELETEQUERYCONVERSION =	"deleteQueryConversion";
		public static final String SELECTQUERYCONVERSIONLIST =	"selectQueryConversionList";
		public static final String SELECTSYSCODELIST =	"selectSysCodeList";
		public static final String SELECTCIPHERSYSCODELIST =	"selectCipherSysCodeList";
		public static final String SELECTPARAMSYSCODELIST =	"selectParamSysCodeList";
		
		
		public static final String SELECTSYSCONFIGLIST =	"selectSysConfigList";
		public static final String SELECTSERVERVERSION =	"selectServerVersion";
		public static final String SELECTPERMISSIONPRESETLIST =	"selectPermissionPresetList";
		public static final String SELECTSYSCONFIGLISTLIKE =	"selectSysConfigListLike";
		public static final String UPDATESYSCONFIGLIST =	"updateSysConfigList";
		public static final String SELECTSYSMULTIVALUECONFIGLISTLIKE =	"selectSysMultiValueConfigListLike";
		public static final String UPDATESYSMULTIVALUECONFIGLIST =	"updateSysMultiValueConfigList";
		public static final String SELECTSERVERSTATUS =	"selectServerStatus";
		public static final String LOADSERVERKEY =	"loadServerKey";
		public static final String CHANGESERVERKEY =	"changeServerKey";
		public static final String UPLOADAPPBINARY =	"uploadAppBinary";
		public static final String UPDATEAPPBINARY =	"updateAppBinary";
		public static final String DELETEAPPBINARY =	"deleteAppBinary";
		public static final String SELECTAPPBINARYLIST =	"selectAppBinaryList";
		public static final String INSERTAGENTSELF =	"insertAgentSelf";
		public static final String SELECTPOLICYLISTFORAGENT =	"selectPolicyListForAgent";
		public static final String PING =	"ping";
		public static final String DOWNLOADQUERYCONVERSIONFILE =	"downloadQueryConversionFile";
		public static final String DOWNLOADAPPBINARYFILE =	"downloadAppBinaryFile";
		public static final String SAVECRYPTOKEYEXTERNAL =	"saveCryptoKeyExternal";
		public static final String SELECTCRYPTOKEYEXTERNALLIST =	"selectCryptoKeyExternalList";
		public static final String SELECTCRYPTOKEYLIST =	"selectCryptoKeyList";
		public static final String SELECTCRYPTOKEYSYMMETRICLIST =	"selectCryptoKeySymmetricList";
		public static final String INSERTCRYPTOKEYSYMMETRIC =	"insertCryptoKeySymmetric";
		public static final String UPDATECRYPTOKEYSYMMETRIC =	"updateCryptoKeySymmetric";
		public static final String DELETECRYPTOKEYSYMMETRIC =	"deleteCryptoKeySymmetric";
		public static final String IMPORTCRYPTOKEYSYMMETRIC =	"importCryptoKeySymmetric";
		public static final String IMPORTCRYPTOKEYEXTERNALLIST =	"importCryptoKeyExternalList";
		public static final String SELECTRESOURCESERVERLIST =	"selectResourceServerList";
		public static final String INSERTRESOURCESERVER =	"insertResourceServer";
		public static final String UPDATERESOURCESERVER =	"updateResourceServer";
		public static final String DELETERESOURCESERVER =	"deleteResourceServer";
		public static final String INSERTRESOURCESERVERDATABASE =	"insertResourceServerDatabase";
		public static final String APPENDRESOURCESERVERDATABASEOBJECT =	"appendResourceServerDatabaseObject";
		public static final String UPDATERESOURCESERVERDATABASE =	"updateResourceServerDatabase";
		public static final String DELETERESOURCESERVERDATABASE =	"deleteResourceServerDatabase";
		public static final String SELECTRESOURCESERVERDATABASELIST =	"selectResourceServerDatabaseList";
		public static final String SELECTRESOURCESERVERDATABASEOBJECTLIST =	"selectResourceServerDatabaseObjectList";
		public static final String SELECTRESOURCESERVERDATABASEOBJECT =	"selectResourceServerDatabaseObject";
		public static final String SELECTDBMSVERSION =	"selectDbmsVersion";
		public static final String SELECTSCHEMALIST =	"selectSchemaList";
		public static final String SELECTTABLELISTWITHTABLESPACE =	"selectTableListWithTableSpace";
		public static final String SELECTTABLESPACELIST =	"selectTableSpaceList";
		public static final String SELECTTABLELIST =	"selectTableList";
		public static final String SELECTDBINDEXCOLUMNLIST =	"selectDbIndexColumnList";
		public static final String SELECTDBINDEXLIST =	"selectDbIndexList";
		public static final String SELECTCOLUMNLIST =	"selectColumnList";
		public static final String SELECTCOLUMNLISTWITHPROPERTIES =	"selectColumnListWithProperties";
		public static final String SELECTDBUSERLIST =	"selectDbUserList";
		public static final String SEARCHCOLUMNLIST =	"searchColumnList";
		public static final String TESTTABLE =	"testTable";
		public static final String SELECTDBTRIGGERLIST =	"selectDbTriggerList";
		public static final String SELECTDBPRIVILEGELIST =	"selectDbPrivilegeList";
		public static final String SELECTDBCONSTRAINTLIST =	"selectDbConstraintList";
		public static final String EXECUTETABLECRYPT =	"executeTableCrypt";
		public static final String SELECTENCRYPTEDVALUEANDSIZE =	"selectEncryptedValueAndSize";
		public static final String LOG =	"log";
		public static final String SELECTAUDITLOGLIST =	"selectAuditLogList";
		public static final String SELECTSYSTEMUSAGELOGLIST =	"selectSystemUsageLogList";
		public static final String SELECTSYSTEMSTATUSLOGLIST =	"selectSystemStatusLogList";
		public static final String APPENDAUDITLOGSITELIST =	"appendAuditLogSiteList";
		public static final String SELECTAUDITLOGSITELIST =	"selectAuditLogSiteList";
		public static final String SELECTAUDITLOGSITEHOURFORSTAT =	"selectAuditLogSiteHourForStat";
		public static final String SELECTTABLECRYPTLOGLIST =	"selectTableCryptLogList";
		public static final String DOWNLOADFILE =	"downloadFile";
		public static final String BACKUPDATA =	"backupData";
		public static final String BACKUPLOG =	"backupLog";
		public static final String EXPORTLOG =	"exportLog";
		public static final String RESTOREDATA =	"restoreData";
		public static final String SELECTBACKUPLOGLIST =	"selectBackupLogList";
		public static final String DELETEBACKUPLOG =	"deleteBackupLog";
		public static final String SELECTSYNCNODELIST =	"selectSyncNodeList";
		public static final String SAVESYNCNODE =	"saveSyncNode";
		public static final String SYNCFORCED =	"syncForced";
		public static final String SYNCVOTED =	"syncVoted";
		public static final String REQUESTSYNCSTATUS =	"requestSyncStatus";
		public static final String SELECTSYSTEMUSAGE =	"selectSystemUsage";
		public static final String SELECTSYSTEMSTATUS =	"selectSystemStatus";
		public static final String SELECTFORDASHBOARD =	"selectForDashboard";
		public static final String DELETESYSTEMSTATUS =	"deleteSystemStatus";

	}

	public class FieldName {

		private FieldName() {
		}

		public static final String	LOGIN_ID						= "experdb-loginid";

		public static final String	PASSWORD						= "experdb-password";

		public static final String	TOKEN_VALUE						= "experdb-token-value";

		public static final String	ADDRESS							= "experdb-address";

		public static final String	PORT							= "experdb-port";

		public static final String	ENTITY_NAME						= "experdb-entity-name";

		public static final String	ENTITY_STATUS_CODE				= "experdb-entity-status-code";

		public static final String	ENTITY_STATUS_NAME				= "experdb-entity-status-name";

		public static final String	ENTITY_TYPE_CODE				= "experdb-entity-type-code";

		public static final String	ENTITY_TYPE_NAME				= "experdb-entity-type-name";

		public static final String	ENTITY_UID						= "experdb-entity-uid";

		public static final String	REQUEST_UID						= "experdb-request-uid";

		public static final String	REMOTE_ADDR						= "experdb-remote-address";

		public static final String	REMOTE_HOST						= "experdb-remote-host";

		public static final String	REQUEST_PATH					= "experdb-request-path";

		public static final String	REQUEST_CALL_SIGNATURE			= "experdb-request-call-signature";

		public static final String	HEADER							= "experdb-header";

		public static final String	PARAMETER						= "experdb-parameter";

		public static final String	RESULT_CODE						= "experdb-result-code";					//used when return type is application/octet-stream to return result code

		public static final String	RESULT_MESSAGE					= "experdb-result-message";					//used when return type is application/octet-stream to return result message

		public static final String	SITE_UID						= "experdb-site-uid";

		public static final String	PROFILE_PROTECTION_VERSION		= "PROFILE_PROTECTION_VERSION";

		public static final String	QUERY_CONVERSION_VERSION		= "QUERY_CONVERSION_VERSION";

		public static final String	SERVER_VERSION					= "experdb-server.version";

		public static final String	LICENSE_CUSTOMER_NAME_KEY		= "CUSTOMER";

		public static final String	LICENSE_EXPIRE_DATE_KEY			= "EXPIRE_DATE";

		public static final String	LICENSE_MAX_CORE_COUNT_KEY		= "MAX_CORES";

		public static final String	LICENSE_MAX_AGENT_COUNT_KEY		= "MAX_AGENTS";

		public static final String	FILE_UPLOAD_DIR_KEY				= "experdb-server.fileupload.dir";

		public static final String	DATA_BACKUP_FILE_DIR_KEY		= "experdb-server.databackup.dir";

		public static final String	LOG_BACKUP_FILE_DIR_KEY			= "experdb-server.logbackup.dir";

		public static final String	QUERY_CONVERSION_FILE_DIR_KEY	= "experdb-server.queryconversion.dir";

		public static final String	DATABASE_BACKUP_FILE_DIR_KEY	= "experdb-server.databasebackup.dir";

		public static final String	CORE_DB_PATH_KEY				= "experdb-server.coredb.path";

		public static final String	SITELOG_DB_PATH_KEY				= "experdb-server.sitelogdb.path";

		public static final String	CORELOG_DB_PATH_KEY				= "experdb-server.corelogdb.path";

		public static final String	BACKUPLOG_DB_PATH_KEY			= "experdb-server.backuplogdb.path";

		public static final String	MONITORLOG_DB_PATH_KEY			= "experdb-server.monitorlogdb.path";

		public static final String	BOOTSTRAP_KEY					= "experdb-bootstrap-token";

		public static final String	SYNC_NODE						= "SyncNode";

		public static final String	SERVER_STATUS					= "SERVER_STATUS";

		public static final String	SITELOG_DB_DRIVER_KEY			= "experdb-server.sitelogdb.driver";

		public static final String	RUNNING_MODE_KEY				= "experdb-server.mode";

		public static final String	SERVER_BUSY_TRY_AGAIN_AFTER		= "SERVER_BUSY_TRY_AGAIN_AFTER";

		public static final String	SERVER_DBMS_KEY					= "experdb-server.dbms";

		public static final String	EXPORT_PARALLEL_DEGREE_KEY		= "experdb-server.export.paralleldegree";

	}
	
	public class ResultCode {

		private ResultCode() {
		}

		public static final String	SUCCESS									= "0000000000";

		public static final String	ITEM_NOT_FOUND_ERROR					= "0000000001";

		public static final String	AUTHENTICATION_ERROR					= "0000000003";

		public static final String	INVALID_FIELD_ERROR						= "0000000007";

		public static final String	CRYPTOGRAPHIC_ERROR						= "0000000010";

		public static final String	ILLEGAL_OPERATION_ERROR					= "0000000011";

		public static final String	PERMISSION_DENIED_ERROR					= "0000000012";

		public static final String	GENERAL_ERROR							= "0000000256";

		public static final String	SERVER_OPERATION_ERROR					= "8000000001";

		public static final String	SERVER_INVALID_LICENSE_ERROR			= "8000000002";

		public static final String	SERVER_KEY_INVALID_ERROR				= "8000000003";

		public static final String	SERVER_INCONSISTENT_SYNC_ERROR			= "8000000004";

		public static final String	SERVER_TO_SERVER_CONNECTION_ERROR		= "8000000005";

		public static final String	SERVER_CORE_LOG_ERROR					= "8100000001";

		public static final String	SERVER_EXTERNAL_KEY_CONNECTION_ERROR	= "8200000001";

		public static final String	SERVER_BUSY_TRY_AGAIN_ERROR				= "8300000001";

		public static final String	ADMIN_PASSWORD_EXPIRED_ERROR			= "8000000010";

		public static final String	ADMIN_TOKEN_EXPIRED_ERROR				= "8000000011";

		public static final String	ADMIN_PASSWORD_COMPLEXITY_ERROR			= "8000000012";

		public static final String	AGENT_INVALID_STATUS_ERROR				= "9000000001";

		public static final String	AGENT_EXPIRED_ERROR						= "9000000002";

		public static final String	AGENT_OPERATION_ERROR					= "9000000003";

		public static final String	AGENT_INVALID_ERROR						= "9000000004";

		public static final String	AGENT_SELF_REGISTRATION_ERROR			= "9000000005";

		public static final String	UNMANAGED_ERROR							= "9999999999";
	}

	/**
	 * @brief 엔티티의 상태
	 * 
	 *        PREACTIVE 는 활성화되기 이전의 주로 최초 등록된 상태이고, ACTIVE 는 활성화되어 사용이 가능한 상태, INACTIVE 는 관리 목적으로 잠시 사용이 중지된 상태로 다시 활성화될 수 있는 상태, DEACTIVE 는 사용이 중지되고
	 *        다시 활성화될 수 없는 상태, DESTROYED 는 폐기되어 관련 데이터가 삭제되거나 폐기된 상태를 의미한다.
	 * @date 2015. 1. 4.
	 * @author Kim, Sunho
	 */
	public class EntityStatusCode {
		private EntityStatusCode() {
		}

		public static final String	PREACTIVE	= "ES10";

		public static final String	ACTIVE		= "ES50";

		public static final String	INACTIVE	= "ES55";

		public static final String	DEACTIVE	= "ES70";

		public static final String	DESTROYED	= "ES90";

	}

	/**
	 * @brief 엔티티의 유형
	 * 
	 *        작업의 주체가 되는 엔티티의 종류를 정의한다.
	 * @date 2015. 1. 4.
	 * @author Kim, Sunho
	 */
	public class EntityTypeCode {
		private EntityTypeCode() {
		}

		public static final String	ADMIN_USER	= "ETAD";

		public static final String	AGENT		= "ETAG";

		public static final String	APPLICATION	= "ETAP";

		public static final String	DB_USER		= "ETDU";

		public static final String	SYSTEM		= "ETST";
	}

	/**
	 * @brief 엔티티의 컨테이너 유형
	 * 
	 *        엔티티의 컨테이너 유형을 정의한다. ELEMENT 는 컨테이너가 아닌 요소이고, GROUP 은 동질한 요소로 이루어진 집합, SET 은 이질적인 요소들로 이루어진 집합을 의미한다.
	 * @date 2015. 1. 4.
	 * @author Kim, Sunho
	 */
	public class ContainerTypeCode {
		private ContainerTypeCode() {
		}

		public static final String	ELEMENT	= "CTEL";

		public static final String	GROUP	= "CTGP";

		public static final String	SET		= "CTST";
	}

	/**
	 * @brief 로그 유형
	 * 
	 *        로그 유형을 정의한다. IN 은 서비스 요청 전처리에 기록되는 로그, OUT 은 서비스 요청 후처리에 기록되는 로그를 의미한다.
	 * @date 2015. 1. 4.
	 * @author Kim, Sunho
	 */
	public class AuditTypeCode {
		private AuditTypeCode() {
		}

		public static final String	IN	= "ADIN";

		public static final String	OUT	= "ADOU";
	}

	public class KeyStatusCode {

		private KeyStatusCode() {
		}

		public static final String	PREACTIVE				= "KS10";

		public static final String	ACTIVE					= "KS50";

		public static final String	DEACTIVE				= "KS70";

		public static final String	COMPROMISED				= "KS80";

		public static final String	DESTROYED				= "KS90";

		public static final String	DESTROYED_COMPROMISED	= "KS99";
	}

	public class KeyTypeCode {
		private KeyTypeCode() {
		}

		public static final String	SYMMETRIC	= "KTSY";

		public static final String	ASYMMETRIC	= "KTAS";
	}

	public class ResourceStatusCode {
		private ResourceStatusCode() {
		}

		public static final String	PREACTIVE	= "RS10";

		public static final String	ACTIVE		= "RS50";

		public static final String	INACTIVE	= "RS55";

		public static final String	DEACTIVE	= "RS70";

		public static final String	DESTROYED	= "RS90";
	}

	public class ResourceTypeCode {
		private ResourceTypeCode() {
		}

		public static final String	MENU			= "RTME";	//Admin Console Menu

		public static final String	API				= "RTPI";	//REST API

		public static final String	DB_OBJECT		= "RTDB";	//DB

		public static final String	SERVER			= "RTSV";	//Server

		public static final String	KEY				= "RTKY";	//Key

		public static final String	EXTERNAL_KEY	= "RTEK";	//External Key

	}

	public class ServerTypeCode {
		private ServerTypeCode() {
		}

		public static final String	WAS	= "STWA";

		public static final String	DB	= "STDB";
	}

	public class SystemStatusCode {
		private SystemStatusCode() {
		}

		public static final String	ACTIVE		= "SS50";

		public static final String	INACTIVE	= "SS55";
	}

	public class NodeStatusCode {
		private NodeStatusCode() {
		}

		public static final String	PRE_SYNC	= "NS10";

		public static final String	INCLUDED	= "NS50";

		public static final String	EXCLUDED	= "NS70";
	}

	public class ValueTypeCode {
		private ValueTypeCode() {
		}

		public static final String	INTEGER		= "VTIT";

		public static final String	DECIMAL		= "VTDC";

		public static final String	STRING		= "VTST";

		public static final String	BOOL		= "VTBO";

		public static final String	CODE		= "VTCD";

		public static final String	DATE_TIME	= "VTDT";

		public static final String	EXTERNAL	= "VTEX";
	}

	public class DbmsProductPrefix {

		private DbmsProductPrefix() {
		}

		public static final String	ORACLE	= "DPO";

		public static final String	MSSQL	= "DPS";

		public static final String	MARIADB	= "DPR";

		public static final String	MYSQL	= "DPY";

		public static final String	POSTGRESQL= "DPP";
	}

	public class DbmsTypeCode {
		private DbmsTypeCode() {
		}

		public static final String	ORACLE		= "DBOR";

		public static final String	MARIADB		= "DBMA";

		public static final String	MSSQL		= "DBMS";

		public static final String	MYSQL		= "DBMY";

		public static final String	SYBASE		= "DBSY";

		public static final String	INFORMIX	= "DBIF";

		public static final String	POSTGRESQL	= "DBPG";

	}

	public class ProfileTypeCode {
		private ProfileTypeCode() {
		}

		public static final String	PROTECTION	= "PTPR";

		public static final String	CONTEXT		= "PTCX";

		public static final String	AUDIT		= "PTAD";

		public static final String	CREDENTIAL	= "PTCR";
	}

	public class ProfileStatusCode {
		private ProfileStatusCode() {
		}

		public static final String	PREACTIVE	= "PS10";

		public static final String	ACTIVE		= "PS50";

		public static final String	INACTIVE	= "PS55";

		public static final String	DEACTIVE	= "PS70";

		public static final String	DESTROYED	= "PS90";
	}

	public class CipherAlgorithmCode {
		private CipherAlgorithmCode() {
		}

		public static final String	ARIA_128	= "CAR1";

		public static final String	ARIA_192	= "CAR2";

		public static final String	ARIA_256	= "CAR3";

		public static final String	AES_128		= "CAA1";

		public static final String	AES_192		= "CAA2";

		public static final String	AES_256		= "CAA3";

		public static final String	SEED_128	= "CAD1";

		public static final String	SEED_256	= "CAD2";

		public static final String	OPE			= "CAOP";

		public static final String	SHA_256		= "CAS2";

		public static final String	TDES		= "CATD";

		public static final String	LPE_NUM		= "CALN";

	}

	public class DenyResultTypeCode
	{
		private DenyResultTypeCode() {
		}

		public static final String	ERROR		= "DRER";

		public static final String	MASKING		= "DRMS";

		public static final String	REPLACE		= "DRRP";

		public static final String	ORIGINAL	= "DROR";

	}

	public class BackupWorkType {
		private BackupWorkType() {

		}

		public static final String	BACKUP				= "BACKUP";

		public static final String	RESTORE				= "RESTORE";

		public static final String	SCHEDULED_BACKUP	= "SCHEDULED_BACKUP";

	}

	public class BackupType {
		private BackupType() {

		}

		public static final String	FULL		= "FULL";

		public static final String	INCREMENTAL	= "INCREMENTAL";

		public static final String	PERIOD		= "PERIOD";
	}

	public class Weekday
	{
		private Weekday() {
		}

		public static final int	NONE		= 0x0;

		public static final int	SUNDAY		= 0x1;

		public static final int	MONDAY		= 0x2;

		public static final int	TUESDAY		= 0x4;

		public static final int	WEDNESDAY	= 0x8;

		public static final int	THURSDAY	= 0x10;

		public static final int	FRIDAY		= 0x20;

		public static final int	SATURDAY	= 0x40;
	}

	public class ScheduleKey {
		private ScheduleKey() {
		}

		public static final String	SERVER_JOB_NAME		= "ServerJob";

		public static final String	SERVER_GROUP_NAME	= "ServerJob";

		public static final String	SERVER_TRIGGER_NAME	= "ServerTrigger";
	}

	public class IntegrityResult {
		private IntegrityResult() {
		}

		public static final String	NO_INTEGRITY_CHECKSUM	= "-";

		public static final String	NORMAL					= "NORMAL";

		public static final String	SITE_INTEGRITY_ERROR	= "SITE INTEGRITY ERROR";

		public static final String	SERVER_INTEGRITY_ERROR	= "SERVER INTEGRITY ERROR";

	}

	public class TableCryptCode {
		public static final String	STAGE_CTAS			= "CRYPTING";

		public static final String	STAGE_INDEX			= "INDEXING";

		public static final String	STAGE_SUCCESS		= "SUCCESS";

		public static final String	STAGE_FAIL			= "FAIL";

		public static final String	STAGE_STARTING		= "STARTING";

		public static final String	TAG_HEADER			= "--EXPERDB_TAG";

		public static final String	REVERT_TAG_HEADER	= "--EXPERDB_REVERT_TAG";
	}

	public class AppTypeCode {
		private AppTypeCode() {
		}

		public static final String	AGENT	= "ATAG";

		public static final String	SERVER	= "ATSV";
	}
	
	public class Default {

		public static final String	DEFAULT_FILE_UPLOAD_DIR						= "files/upload";

		public static final String	DEFAULT_DATA_BACKUP_FILE_DIR				= "files/databak";

		public static final String	DEFAULT_LOG_BACKUP_FILE_DIR					= "files/logbak";

		public static final String	DEFAULT_QUERY_CONVERSION_FILE_DIR			= "files/queryconversion";

		public static final String	DEFAULT_DATABASE_BACKUP_FILE_DIR			= "files/databasebak";

		public static final String	DEFAULT_CORE_DB_PATH						= "data/experdb.core";

		public static final String	DEFAULT_CORELOG_DB_PATH						= "data/experdb.corelog";

		public static final String	DEFAULT_SITELOG_DB_PATH						= "data/experdb.sitelog";

		public static final String	DEFAULT_BACKUPLOG_DB_PATH					= "data/experdb.backuplog";

		public static final String	DEFAULT_MONITORLOG_DB_PATH					= "data/experdb.monitorlog";

		public static final String	DEFAULT_HASH_ALGORITHM						= "SHA-256";

		public static final String	DEFAULT_DIGEST_ALGORITHM					= "SHA-1";

		public static final String	DEFAULT_RANDOM_BIT_GENERATOR_ALGORITHM		= "SHA1PRNG";

		public static final String	DEFAULT_PSUEDO_RANDOM_FUNCTION				= "HmacSHA256";

		public static final int		DEFAULT_PSUEDO_RANDOM_OUTPUT_BIT_LENGTH		= 256;

		public static final int		DEFAULT_PSUEDO_RANDOM_OUTPUT_BYTE_LENGTH	= DEFAULT_PSUEDO_RANDOM_OUTPUT_BIT_LENGTH
																						/ Byte.SIZE;

		public static final String	DEFAULT_CHARACTER_SET						= "utf-8";

		public static final String	DEFAULT_KEY_CIPHER_ALGORITHM				= "AESWrap";

		public static final String	DEFAULT_DATA_CIPHER_ALGORITHM				= "AES/CBC/PKCS5PADDING";

		public static final String	DEFAULT_KEY_SPEC_ALGORITHM					= "AES";

		public static final int		DEFAULT_KEY_BIT_LENGTH						= 128;

		public static final int		DEFAULT_IV_BYTE_LENGTH						= 16;

		public static final int		DEFAULT_TOKEN_BIT_LENGTH					= 256;

		public static final int		DEFAULT_TOKEN_USABLE_HOUR					= 168;

		public static final String	DEFAULT_SYSTEM_UUID							= "00000000-0000-0000-0000-000000000000";

		public static final String	DEFAULT_SYSTEM_NAME							= "SYSTEM";

		public static final String	DEFAULT_ADMIN_UUID							= "00000000-0000-0000-0000-000000000001";

		public static final String	DEFAULT_START_DATE_TIME						= "2015-01-01 00:00:00.000";

		private Default() {
		}
	}
}
