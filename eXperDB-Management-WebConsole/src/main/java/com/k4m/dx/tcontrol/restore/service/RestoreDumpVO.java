package com.k4m.dx.tcontrol.restore.service;

public class RestoreDumpVO {
	private int rownum;
	private int idx;
	private int restore_sn;
	private int db_svr_id;
	private String restore_nm;
	private String restore_exp;
	private int wrk_id;
	private int wrkexe_sn;
	private String restore_strtdtm;
	private String restore_enddtm;
	private String restore_cndt;
	private String exelog;
	private String format;
	private String filename;
	private String jobs;
	private String role;
	private String pre_data_yn;
	private String data_yn;
	private String post_data_yn;
	private String data_only_yn;
	private String schema_only_yn;
	private String no_owner_yn;
	private String no_privileges_yn;
	private String no_tablespaces_yn;
	private String create_yn;
	private String clean_yn;
	private String single_transaction_yn;
	private String disable_triggers_yn;
	private String no_data_for_failed_tables_yn;
	private String verbose_yn;
	private String use_set_sesson_auth_yn;
	private String exit_on_error_yn;
	private String regr_id;
	private String reg_dtm;
	private String bck_file_pth;
	private int db_id;
	private String db_nm;
	private String file_sz;
	private String bck_filenm;
	
	//2020.08.07 추가
	private String blobs_only_yn;
	private String no_unlogged_table_data_yn;
	private String use_column_inserts_yn;
	private String use_column_commands_yn;
	private String oids_yn;
	private String identifier_quotes_apply_yn;
	private String obj_cmd;

	public String getObj_cmd() {
		return obj_cmd;
	}

	public void setObj_cmd(String obj_cmd) {
		this.obj_cmd = obj_cmd;
	}

	public String getIdentifier_quotes_apply_yn() {
		return identifier_quotes_apply_yn;
	}

	public void setIdentifier_quotes_apply_yn(String identifier_quotes_apply_yn) {
		this.identifier_quotes_apply_yn = identifier_quotes_apply_yn;
	}

	public String getBlobs_only_yn() {
		return blobs_only_yn;
	}

	public void setBlobs_only_yn(String blobs_only_yn) {
		this.blobs_only_yn = blobs_only_yn;
	}

	public String getNo_unlogged_table_data_yn() {
		return no_unlogged_table_data_yn;
	}

	public void setNo_unlogged_table_data_yn(String no_unlogged_table_data_yn) {
		this.no_unlogged_table_data_yn = no_unlogged_table_data_yn;
	}

	public String getUse_column_inserts_yn() {
		return use_column_inserts_yn;
	}

	public void setUse_column_inserts_yn(String use_column_inserts_yn) {
		this.use_column_inserts_yn = use_column_inserts_yn;
	}

	public String getUse_column_commands_yn() {
		return use_column_commands_yn;
	}

	public void setUse_column_commands_yn(String use_column_commands_yn) {
		this.use_column_commands_yn = use_column_commands_yn;
	}

	public String getOids_yn() {
		return oids_yn;
	}

	public void setOids_yn(String oids_yn) {
		this.oids_yn = oids_yn;
	}

	public int getRownum() {
		return rownum;
	}

	public void setRownum(int rownum) {
		this.rownum = rownum;
	}

	public int getIdx() {
		return idx;
	}

	public void setIdx(int idx) {
		this.idx = idx;
	}

	public int getRestore_sn() {
		return restore_sn;
	}

	public void setRestore_sn(int restore_sn) {
		this.restore_sn = restore_sn;
	}

	public int getDb_svr_id() {
		return db_svr_id;
	}

	public void setDb_svr_id(int db_svr_id) {
		this.db_svr_id = db_svr_id;
	}

	public String getRestore_nm() {
		return restore_nm;
	}

	public void setRestore_nm(String restore_nm) {
		this.restore_nm = restore_nm;
	}

	public String getRestore_exp() {
		return restore_exp;
	}

	public void setRestore_exp(String restore_exp) {
		this.restore_exp = restore_exp;
	}

	public int getWrk_id() {
		return wrk_id;
	}

	public void setWrk_id(int wrk_id) {
		this.wrk_id = wrk_id;
	}

	public int getWrkexe_sn() {
		return wrkexe_sn;
	}

	public void setWrkexe_sn(int wrkexe_sn) {
		this.wrkexe_sn = wrkexe_sn;
	}

	public String getRestore_strtdtm() {
		return restore_strtdtm;
	}

	public void setRestore_strtdtm(String restore_strtdtm) {
		this.restore_strtdtm = restore_strtdtm;
	}

	public String getRestore_enddtm() {
		return restore_enddtm;
	}

	public void setRestore_enddtm(String restore_enddtm) {
		this.restore_enddtm = restore_enddtm;
	}

	public String getRestore_cndt() {
		return restore_cndt;
	}

	public void setRestore_cndt(String restore_cndt) {
		this.restore_cndt = restore_cndt;
	}

	public String getExelog() {
		return exelog;
	}

	public void setExelog(String exelog) {
		this.exelog = exelog;
	}

	public String getFormat() {
		return format;
	}

	public void setFormat(String format) {
		this.format = format;
	}

	public String getFilename() {
		return filename;
	}

	public void setFilename(String filename) {
		this.filename = filename;
	}

	public String getJobs() {
		return jobs;
	}

	public void setJobs(String jobs) {
		this.jobs = jobs;
	}

	public String getRole() {
		return role;
	}

	public void setRole(String role) {
		this.role = role;
	}

	public String getPre_data_yn() {
		return pre_data_yn;
	}

	public void setPre_data_yn(String pre_data_yn) {
		this.pre_data_yn = pre_data_yn;
	}

	public String getData_yn() {
		return data_yn;
	}

	public void setData_yn(String data_yn) {
		this.data_yn = data_yn;
	}

	public String getPost_data_yn() {
		return post_data_yn;
	}

	public void setPost_data_yn(String post_data_yn) {
		this.post_data_yn = post_data_yn;
	}

	public String getData_only_yn() {
		return data_only_yn;
	}

	public void setData_only_yn(String data_only_yn) {
		this.data_only_yn = data_only_yn;
	}

	public String getSchema_only_yn() {
		return schema_only_yn;
	}

	public void setSchema_only_yn(String schema_only_yn) {
		this.schema_only_yn = schema_only_yn;
	}

	public String getNo_owner_yn() {
		return no_owner_yn;
	}

	public void setNo_owner_yn(String no_owner_yn) {
		this.no_owner_yn = no_owner_yn;
	}

	public String getNo_privileges_yn() {
		return no_privileges_yn;
	}

	public void setNo_privileges_yn(String no_privileges_yn) {
		this.no_privileges_yn = no_privileges_yn;
	}

	public String getNo_tablespaces_yn() {
		return no_tablespaces_yn;
	}

	public void setNo_tablespaces_yn(String no_tablespaces_yn) {
		this.no_tablespaces_yn = no_tablespaces_yn;
	}

	public String getCreate_yn() {
		return create_yn;
	}

	public void setCreate_yn(String create_yn) {
		this.create_yn = create_yn;
	}

	public String getClean_yn() {
		return clean_yn;
	}

	public void setClean_yn(String clean_yn) {
		this.clean_yn = clean_yn;
	}

	public String getSingle_transaction_yn() {
		return single_transaction_yn;
	}

	public void setSingle_transaction_yn(String single_transaction_yn) {
		this.single_transaction_yn = single_transaction_yn;
	}

	public String getDisable_triggers_yn() {
		return disable_triggers_yn;
	}

	public void setDisable_triggers_yn(String disable_triggers_yn) {
		this.disable_triggers_yn = disable_triggers_yn;
	}

	public String getNo_data_for_failed_tables_yn() {
		return no_data_for_failed_tables_yn;
	}

	public void setNo_data_for_failed_tables_yn(String no_data_for_failed_tables_yn) {
		this.no_data_for_failed_tables_yn = no_data_for_failed_tables_yn;
	}

	public String getVerbose_yn() {
		return verbose_yn;
	}

	public void setVerbose_yn(String verbose_yn) {
		this.verbose_yn = verbose_yn;
	}

	public String getUse_set_sesson_auth_yn() {
		return use_set_sesson_auth_yn;
	}

	public void setUse_set_sesson_auth_yn(String use_set_sesson_auth_yn) {
		this.use_set_sesson_auth_yn = use_set_sesson_auth_yn;
	}

	public String getExit_on_error_yn() {
		return exit_on_error_yn;
	}

	public void setExit_on_error_yn(String exit_on_error_yn) {
		this.exit_on_error_yn = exit_on_error_yn;
	}

	public String getRegr_id() {
		return regr_id;
	}

	public void setRegr_id(String regr_id) {
		this.regr_id = regr_id;
	}

	public String getReg_dtm() {
		return reg_dtm;
	}

	public void setReg_dtm(String reg_dtm) {
		this.reg_dtm = reg_dtm;
	}

	public String getBck_file_pth() {
		return bck_file_pth;
	}

	public void setBck_file_pth(String bck_file_pth) {
		this.bck_file_pth = bck_file_pth;
	}

	public int getDb_id() {
		return db_id;
	}

	public void setDb_id(int db_id) {
		this.db_id = db_id;
	}

	public String getDb_nm() {
		return db_nm;
	}

	public void setDb_nm(String db_nm) {
		this.db_nm = db_nm;
	}

	public String getFile_sz() {
		return file_sz;
	}

	public void setFile_sz(String file_sz) {
		this.file_sz = file_sz;
	}

	public String getBck_filenm() {
		return bck_filenm;
	}

	public void setBck_filenm(String bck_filenm) {
		this.bck_filenm = bck_filenm;
	}

}
