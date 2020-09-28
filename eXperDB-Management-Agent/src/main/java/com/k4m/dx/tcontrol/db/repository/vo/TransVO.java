package com.k4m.dx.tcontrol.db.repository.vo;

public class TransVO {

	private int trans_id;
	private String exe_status;

	private String trans_com_id;
	private String plugin_name;
	private String heartbeat_interval_ms;
	private String heartbeat_action_query;
	private String max_batch_size;
	private String max_queue_size;
	private String offset_flush_interval_ms;
	private String offset_flush_timeout_ms;
	private String auto_create;
	private String transforms_yn;
	
	private String column_name;
	private String table_name;
	private String db_name;

	public String getColumn_name() {
		return column_name;
	}

	public void setColumn_name(String column_name) {
		this.column_name = column_name;
	}

	public String getTable_name() {
		return table_name;
	}

	public void setTable_name(String table_name) {
		this.table_name = table_name;
	}

	public String getDb_name() {
		return db_name;
	}

	public void setDb_name(String db_name) {
		this.db_name = db_name;
	}

	public String getTransforms_yn() {
		return transforms_yn;
	}

	public void setTransforms_yn(String transforms_yn) {
		this.transforms_yn = transforms_yn;
	}

	public String getTrans_com_id() {
		return trans_com_id;
	}

	public void setTrans_com_id(String trans_com_id) {
		this.trans_com_id = trans_com_id;
	}

	public String getPlugin_name() {
		return plugin_name;
	}

	public void setPlugin_name(String plugin_name) {
		this.plugin_name = plugin_name;
	}

	public String getHeartbeat_interval_ms() {
		return heartbeat_interval_ms;
	}

	public void setHeartbeat_interval_ms(String heartbeat_interval_ms) {
		this.heartbeat_interval_ms = heartbeat_interval_ms;
	}

	public String getHeartbeat_action_query() {
		return heartbeat_action_query;
	}

	public void setHeartbeat_action_query(String heartbeat_action_query) {
		this.heartbeat_action_query = heartbeat_action_query;
	}

	public String getMax_batch_size() {
		return max_batch_size;
	}

	public void setMax_batch_size(String max_batch_size) {
		this.max_batch_size = max_batch_size;
	}

	public String getMax_queue_size() {
		return max_queue_size;
	}

	public void setMax_queue_size(String max_queue_size) {
		this.max_queue_size = max_queue_size;
	}

	public String getOffset_flush_interval_ms() {
		return offset_flush_interval_ms;
	}

	public void setOffset_flush_interval_ms(String offset_flush_interval_ms) {
		this.offset_flush_interval_ms = offset_flush_interval_ms;
	}

	public String getOffset_flush_timeout_ms() {
		return offset_flush_timeout_ms;
	}

	public void setOffset_flush_timeout_ms(String offset_flush_timeout_ms) {
		this.offset_flush_timeout_ms = offset_flush_timeout_ms;
	}

	public String getAuto_create() {
		return auto_create;
	}

	public void setAuto_create(String auto_create) {
		this.auto_create = auto_create;
	}

	public int getTrans_id() {
		return trans_id;
	}

	public void setTrans_id(int trans_id) {
		this.trans_id = trans_id;
	}

	public String getExe_status() {
		return exe_status;
	}

	public void setExe_status(String exe_status) {
		this.exe_status = exe_status;
	}

}
