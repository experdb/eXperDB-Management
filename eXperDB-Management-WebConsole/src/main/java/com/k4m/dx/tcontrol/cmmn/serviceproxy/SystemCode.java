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

	public static final String	MODULE_NAME					= "experdb-agent";

	public static final String	BUILTIN_PROPERTIES_PATH		= "builtin.properties";

	public static final String	PROPERTIES_PATH				= "conf/agent.properties";

	public static final String	LOG_READ_PROPERTIES_PATH	= "conf/logread.properties";

	public static final String	NODE_LIST_PROPERTIES_PATH	= "conf/nodelist.properties";

	public static final String	DATETIME_FORMAT				= "yyyy-MM-dd HH:mm:ss.SSS";

	public static final String	SSL_PROTOCOL				= "TLS";

	public static final String	TRIGGER_REQUEST_TO_SERVER	= "RequestToServer";

	public class NodeStatusCode {
		private NodeStatusCode() {
		}

		public static final String	PRE_SYNC	= "NS10";

		public static final String	INCLUDED	= "NS50";

		public static final String	EXCLUDED	= "NS70";
	}

	public class IntegrityResult {
		private IntegrityResult() {
		}

		public static final String	NO_INTEGRITY_CHECKSUM	= "-";

		public static final String	NORMAL					= "NORMAL";

		public static final String	SITE_INTEGRITY_ERROR	= "SITE INTEGRITY ERROR";
	}

	public class MonitorResultLevel {
		private MonitorResultLevel() {
		}

		public static final String	NORMAL	= "NORMAL";

		public static final String	INFO	= "INFO";

		public static final String	WARN	= "WARN";

		public static final String	ERROR	= "ERROR";
	}

	/**
	 * @brief properties 로 관리되는 속성에 접근하기 위한 키 정의
	 * 
	 *        agent.properties 파일과 시스템 속성의 속성 키를 정의한다.
	 * @date 2015. 1. 4.
	 * @author Kim, Sunho
	 */
	public class PropertyKey {

		private PropertyKey() {
		}

		public static final String	LOG_PATH_KEY							= "experdb-agent.log_path";

		public static final String	SERVER_ADDRESS_KEY						= "experdb-agent.server_address";

		public static final String	SERVER_PORT_KEY							= "experdb-agent.server_port";

		public static final String	AGENT_UID_KEY							= "experdb-agent.agent_uid";

		public static final String	AGENT_PASSWORD_KEY						= "experdb-agent.agent_password";

		public static final String	PROTECTION_PROFILES_KEY					= "experdb-agent.protection_profiles";

		public static final String	INSTALL_COMPLETE_KEY					= "experdb-agent.installed";

		public static final String	AGENT_JAVA_VENDOR						= "java.vm.vendor";

		public static final String	AGENT_JAVA_VERSION						= "java.version";

		public static final String	AGENT_JAVA_OS_ARCH						= "os.arch";

		public static final String	AGENT_JAVA_OS_NAME						= "os.name";

		public static final String	AGENT_JAVA_USER_DIR						= "user.dir";

		public static final String	AGENT_JAVA_USER_NAME					= "user.name";

		public static final String	AGENT_JAVA_OS_VERSION					= "os.version";

		public static final String	AGENT_JAVA_USER_HOME					= "user.home";

		public static final String	LOG_INFO								= "experdb-agent.info";

		public static final String	AGENT_VERSION							= "experdb-agent.version";

		public static final String	AUDIT_LOG_RETENTION_TIME				= "experdb-agent.log_retention_time";

		public static final String	AUDIT_LOG_SIZE_THRESHOLD				= "experdb-agent.log_size_threshold";

		public static final String	AUDIT_LOG_COMPRESS_LIMIT				= "experdb-agent.log_compress_limit";

		public static final String	AUDIT_LOG_COMPRESS_DURATION				= "experdb-agent.log_compress_duration";

		public static final String	AGENT_IP_ADDR							= "experdb-agent.ip_addr";						/*
																															 * as agent IP & for audit
																															 * log and access control.
																															 */

		public static final String	AGENT_MAC_ADDR							= "experdb-agent.mac_addr";						/*
																															 * for audit log and
																															 * access control.
																															 */

		public static final String	SERVER_RETRY							= "experdb-agent.server_retry";

		public static final String	EXPERDB_HOME								= "experdb-agent.experdb_home";

		public static final String	SHMPATH									= "experdb-agent.shmpath";

		public static final String	SHMID									= "experdb-agent.shmid";

		public static final String	PRIMARY_SERVER_CHECK_TRIGGER_COUNT_KEY	= "experdb-agent.server_check_trigger_count";
	}

	public class FieldName {
		private FieldName() {
		}

		public static final String	LOGIN_ID						= "experdb-loginid";

		public static final String	PASSWORD						= "experdb-password";

		public static final String	ENTITY_UID						= "experdb-entity-uid";

		public static final String	TOKEN_VALUE						= "experdb-token-value";

		public static final String	ADDRESS							= "experdb-address";

		public static final String	QUERY_CONVERSION_VERSION		= "QUERY_CONVERSION_VERSION";

		public static final String	PROFILE_PROTECTION_VERSION		= "PROFILE_PROTECTION_VERSION";

		public static final String	MONITOR_POLLING_AGENT			= "MONITOR_POLLING_AGENT";

		public static final String	MONITOR_AGENT_AUDIT_LOG_HMAC	= "MONITOR_AGENT_AUDIT_LOG_HMAC";

		public static final String	FILE_PATH						= "FILE_PATH";

		public static final String	RESULT_CODE						= "experdb-result-code";			//used when return type is application/octet-stream to return result code

		public static final String	RESULT_MESSAGE					= "experdb-result-message";			//used when return type is application/octet-stream to return result message

		public static final String	SYNC_NODE						= "SyncNode";

		public static final String	SERVER_VERSION					= "experdb-server.version";

		public static final String	SERVER_STATUS					= "SERVER_STATUS";

		public static final String	CONFIG_FOR_AGENT				= "ConfigForAgent";

		public static final String	SERVER_BUSY_TRY_AGAIN_AFTER		= "SERVER_BUSY_TRY_AGAIN_AFTER";
	}

	/**
	 * @brief 시스템 구동에 필요한 속성을 파일에서 읽을 지 여부를 결정하기 위한 비트 마스크.
	 * 
	 *        StartUp.determineReadBitMask 메소드와 StartUp.readProperties 메소드에서 속성을 파일에서 읽어 올 지를 결정하기 위해 사용되는 비트 마스크로 StartUp.determineReadBitMask 에서 비트를
	 *        결정하고, StartUp.readProperties 에서 비트 연산으로 읽어 올 속성을 확인한다.
	 * @date 2015. 1. 4.
	 * @author Kim, Sunho
	 */
	public class BitMask {
		private BitMask() {
		}

		public static final int	READ_ADDRESS_MASK	= 0x1;

		public static final int	READ_PORT_MASK		= 0x2;

		public static final int	READ_PASSWORD_MASK	= 0x4;

		public static final int	READ_UID_MASK		= 0x8;

		public static final int	READ_LOG_PATH_MASK	= 0x10;
	}

	/**
	 * @brief 서버 서비스 URL 정의
	 * 
	 *        서버에 처리 요청을 하기 위한 서비스 URL 문자열에 대한 정의로 서버에 정의된 서비스 경로(클래스 수준)와 메소드 경로(메소드 수준)를 포함하는 형식으로 정의된다.
	 * @date 2015. 1. 4.
	 * @author Kim, Sunho
	 */
	public class ServicePath {
		private ServicePath() {
		}

		public static final String	INSERT_AGENT_SELF				= "agentService/insertAgentSelf";				//agent register request

		//public static final String	SELECT_AGENT_STATUS_SELF	= "agentService/selectAgentStatusSelf";	//agent register status

		//public static final String	LOGIN				= "authService/login";					//login with ID/PW via agent

		public static final String	SELECT_PROFILE_LIST				= "agentService/selectPolicyListForAgent";		//profile request

		public static final String	DOWNLOAD_QUERY_CONVERSION_URL	= "agentService/downloadQueryConversionFile";

		public static final String	DOWNLOAD_APP_BINARY_URL			= "agentService/downloadAppBinaryFile";

		public static final String	APPEND_AUDIT_LOG_SITE_LIST		= "logService/appendAuditLogSiteList";

		public static final String	SELECT_PROFILE_ACL_LIST			= "agentService/selectAclListForAgent";

		public static final String	SELECT_PROFILE_DBO_LIST			= "agentService/selectDboListForAgent";

		public static final String	PING							= "agentService/ping";

	}

	public class InitialVectorType {
		private InitialVectorType() {
		}

		public static final String	FIXED	= "IVFX";

		public static final String	RANDOM	= "IVRD";
	}

	/**
	 * @brief 엔티티의 상태
	 * 
	 *        PREACTIVE 는 활성화되기 이전의 주로 최초 등록된 상태이고, ACTIVE 는 활성화되어 사용이 가능한 상태, INACTIVE 는 관리 목적으로 잠시 사용이 중지된 상태로 다시 활성화될 수 있는 상태, DEACTIVE 는 사용이 중지되고
	 *        다시 활성화될 수 없는 상태, DESTROYED 는 폐기되어 관련 데이터가 삭제되거나 폐기된 상태를 의미한다.
	 *
	 *        현재 사용가능한 status는 ACTIVE, INACTIVE뿐이다.
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

	public class MonitorTargetResourceType {
		private MonitorTargetResourceType() {
		}

		public static final String	DISK	= "DISK";

		public static final String	CPU		= "CPU";

		public static final String	RAM		= "RAM";
	}
}
