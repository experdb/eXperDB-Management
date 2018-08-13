package com.k4m.dx.tcontrol.monitoring.schedule.util;

public class SystemCode {
	public static String	SSL_PROTOCOL	= "TLS";
	public static final String	DATETIME_FORMAT					= "yyyy-MM-dd HH:mm:ss.SSS";
	
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
}
