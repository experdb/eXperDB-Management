package com.k4m.dx.tcontrol.db2pg.setting.service;

public class DataConfigVO {
	private String wrk_nm;
	private String wrk_exp;
	
	private String source_info;
	private String target_info;
	private String src_rows_export;
	private String src_include_tables;
	private String src_exclude_tables;
	private String src_statement_fetch_size;
	private String src_buffer_size;
	private String src_select_on_parallel;
	private String src_lob_buffer_size;
	private String tar_constraint_rebuild;
	private String tar_file_append;
	private String tar_constraint_ddl;
	private String src_where_condition;
	private String src_file_query_dir_path;
	
	public String getWrk_nm() {
		return wrk_nm;
	}
	public void setWrk_nm(String wrk_nm) {
		this.wrk_nm = wrk_nm;
	}
	public String getWrk_exp() {
		return wrk_exp;
	}
	public void setWrk_exp(String wrk_exp) {
		this.wrk_exp = wrk_exp;
	}
	public String getSource_info() {
		return source_info;
	}
	public void setSource_info(String source_info) {
		this.source_info = source_info;
	}
	public String getTarget_info() {
		return target_info;
	}
	public void setTarget_info(String target_info) {
		this.target_info = target_info;
	}
	public String getSrc_rows_export() {
		return src_rows_export;
	}
	public void setSrc_rows_export(String src_rows_export) {
		this.src_rows_export = src_rows_export;
	}
	public String getSrc_include_tables() {
		return src_include_tables;
	}
	public void setSrc_include_tables(String src_include_tables) {
		this.src_include_tables = src_include_tables;
	}
	public String getSrc_exclude_tables() {
		return src_exclude_tables;
	}
	public void setSrc_exclude_tables(String src_exclude_tables) {
		this.src_exclude_tables = src_exclude_tables;
	}
	public String getSrc_statement_fetch_size() {
		return src_statement_fetch_size;
	}
	public void setSrc_statement_fetch_size(String src_statement_fetch_size) {
		this.src_statement_fetch_size = src_statement_fetch_size;
	}
	public String getSrc_buffer_size() {
		return src_buffer_size;
	}
	public void setSrc_buffer_size(String src_buffer_size) {
		this.src_buffer_size = src_buffer_size;
	}
	public String getSrc_select_on_parallel() {
		return src_select_on_parallel;
	}
	public void setSrc_select_on_parallel(String src_select_on_parallel) {
		this.src_select_on_parallel = src_select_on_parallel;
	}
	public String getSrc_lob_buffer_size() {
		return src_lob_buffer_size;
	}
	public void setSrc_lob_buffer_size(String src_lob_buffer_size) {
		this.src_lob_buffer_size = src_lob_buffer_size;
	}
	public String getTar_constraint_rebuild() {
		return tar_constraint_rebuild;
	}
	public void setTar_constraint_rebuild(String tar_constraint_rebuild) {
		this.tar_constraint_rebuild = tar_constraint_rebuild;
	}
	public String getTar_file_append() {
		return tar_file_append;
	}
	public void setTar_file_append(String tar_file_append) {
		this.tar_file_append = tar_file_append;
	}
	public String getTar_constraint_ddl() {
		return tar_constraint_ddl;
	}
	public void setTar_constraint_ddl(String tar_constraint_ddl) {
		this.tar_constraint_ddl = tar_constraint_ddl;
	}
	public String getSrc_where_condition() {
		return src_where_condition;
	}
	public void setSrc_where_condition(String src_where_condition) {
		this.src_where_condition = src_where_condition;
	}
	public String getSrc_file_query_dir_path() {
		return src_file_query_dir_path;
	}
	public void setSrc_file_query_dir_path(String src_file_query_dir_path) {
		this.src_file_query_dir_path = src_file_query_dir_path;
	}
	

}
