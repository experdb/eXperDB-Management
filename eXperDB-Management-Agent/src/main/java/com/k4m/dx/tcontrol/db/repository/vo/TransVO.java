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
	private String topic_nm;
	private String start_gbn;
	private String topic_gbn;
	private int topic_id;
	private int kc_port;
	private String kc_ip;
	private int src_trans_id;
	private int tar_trans_id;
	private String src_topic_use_yn;
	private int topic_overlap_cnt;
	private int topic_overlap_src_ing_cnt;
	private int topic_overlap_tar_cnt;
	private int tar_topic_overlap_ing_cnt;
	private int tar_topic_ing_cnt;
	private int tar_trans_id_cnt;
	private String exrt_trg_tb_nm;
	private int trans_exrt_trg_tb_id;
	private String write_use_yn;
	
	private int kc_id;
	private String kc_nm;
	private String con_gbn;
	private String connect_nm;
	private int db_svr_id;

	public String getCon_gbn() {
		return con_gbn;
	}

	public void setCon_gbn(String con_gbn) {
		this.con_gbn = con_gbn;
	}

	public String getConnect_nm() {
		return connect_nm;
	}

	public void setConnect_nm(String connect_nm) {
		this.connect_nm = connect_nm;
	}

	public int getDb_svr_id() {
		return db_svr_id;
	}

	public void setDb_svr_id(int db_svr_id) {
		this.db_svr_id = db_svr_id;
	}

	public int getKc_id() {
		return kc_id;
	}

	public void setKc_id(int kc_id) {
		this.kc_id = kc_id;
	}

	public String getKc_nm() {
		return kc_nm;
	}

	public void setKc_nm(String kc_nm) {
		this.kc_nm = kc_nm;
	}

	public String getWrite_use_yn() {
		return write_use_yn;
	}

	public void setWrite_use_yn(String write_use_yn) {
		this.write_use_yn = write_use_yn;
	}

	public String getExrt_trg_tb_nm() {
		return exrt_trg_tb_nm;
	}

	public void setExrt_trg_tb_nm(String exrt_trg_tb_nm) {
		this.exrt_trg_tb_nm = exrt_trg_tb_nm;
	}

	public int getTrans_exrt_trg_tb_id() {
		return trans_exrt_trg_tb_id;
	}

	public void setTrans_exrt_trg_tb_id(int trans_exrt_trg_tb_id) {
		this.trans_exrt_trg_tb_id = trans_exrt_trg_tb_id;
	}

	public int getTar_trans_id_cnt() {
		return tar_trans_id_cnt;
	}

	public void setTar_trans_id_cnt(int tar_trans_id_cnt) {
		this.tar_trans_id_cnt = tar_trans_id_cnt;
	}

	public int getSrc_trans_id() {
		return src_trans_id;
	}

	public void setSrc_trans_id(int src_trans_id) {
		this.src_trans_id = src_trans_id;
	}

	public int getTar_trans_id() {
		return tar_trans_id;
	}

	public void setTar_trans_id(int tar_trans_id) {
		this.tar_trans_id = tar_trans_id;
	}

	public String getSrc_topic_use_yn() {
		return src_topic_use_yn;
	}

	public void setSrc_topic_use_yn(String src_topic_use_yn) {
		this.src_topic_use_yn = src_topic_use_yn;
	}

	public int getTopic_overlap_cnt() {
		return topic_overlap_cnt;
	}

	public void setTopic_overlap_cnt(int topic_overlap_cnt) {
		this.topic_overlap_cnt = topic_overlap_cnt;
	}

	public int getTopic_overlap_src_ing_cnt() {
		return topic_overlap_src_ing_cnt;
	}

	public void setTopic_overlap_src_ing_cnt(int topic_overlap_src_ing_cnt) {
		this.topic_overlap_src_ing_cnt = topic_overlap_src_ing_cnt;
	}

	public int getTopic_overlap_tar_cnt() {
		return topic_overlap_tar_cnt;
	}

	public void setTopic_overlap_tar_cnt(int topic_overlap_tar_cnt) {
		this.topic_overlap_tar_cnt = topic_overlap_tar_cnt;
	}

	public int getTar_topic_overlap_ing_cnt() {
		return tar_topic_overlap_ing_cnt;
	}

	public void setTar_topic_overlap_ing_cnt(int tar_topic_overlap_ing_cnt) {
		this.tar_topic_overlap_ing_cnt = tar_topic_overlap_ing_cnt;
	}

	public int getTar_topic_ing_cnt() {
		return tar_topic_ing_cnt;
	}

	public void setTar_topic_ing_cnt(int tar_topic_ing_cnt) {
		this.tar_topic_ing_cnt = tar_topic_ing_cnt;
	}

	public int getKc_port() {
		return kc_port;
	}

	public void setKc_port(int kc_port) {
		this.kc_port = kc_port;
	}

	public String getKc_ip() {
		return kc_ip;
	}

	public void setKc_ip(String kc_ip) {
		this.kc_ip = kc_ip;
	}

	public int getTopic_id() {
		return topic_id;
	}

	public void setTopic_id(int topic_id) {
		this.topic_id = topic_id;
	}

	public String getTopic_gbn() {
		return topic_gbn;
	}

	public void setTopic_gbn(String topic_gbn) {
		this.topic_gbn = topic_gbn;
	}

	public String getStart_gbn() {
		return start_gbn;
	}

	public void setStart_gbn(String start_gbn) {
		this.start_gbn = start_gbn;
	}

	public String getTopic_nm() {
		return topic_nm;
	}

	public void setTopic_nm(String topic_nm) {
		this.topic_nm = topic_nm;
	}

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
