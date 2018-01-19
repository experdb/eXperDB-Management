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

	public static final String	SSL_PROTOCOL	= "TLS";
	

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
}
