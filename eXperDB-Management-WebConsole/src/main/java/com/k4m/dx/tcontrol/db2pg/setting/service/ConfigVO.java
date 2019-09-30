package com.k4m.dx.tcontrol.db2pg.setting.service;

public class ConfigVO {
	private String wrk_nm;
	private String wrk_exp;
	
	private String source_info;
	private String src_classify_string;
	private String src_table_ddl;
	private String src_include_tables;
	private String src_exclude_tables;
	private String src_file_output_path;
	
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
	public String getSrc_classify_string() {
		return src_classify_string;
	}
	public void setSrc_classify_string(String src_classify_string) {
		this.src_classify_string = src_classify_string;
	}
	public String getSrc_table_ddl() {
		return src_table_ddl;
	}
	public void setSrc_table_ddl(String src_table_ddl) {
		this.src_table_ddl = src_table_ddl;
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
	public String getSrc_file_output_path() {
		return src_file_output_path;
	}
	public void setSrc_file_output_path(String src_file_output_path) {
		this.src_file_output_path = src_file_output_path;
	}

	

	

}
