package com.k4m.dx.tcontrol.tree.transfer.service;

public class TransferTargetVO {
	private int rownum;
	private int idx;
	private int trf_trg_id; //전송_대상_ID
	private String trf_trg_cnn_nm; //전송_대상_연결_명
	private String trf_trg_url; //전송_대상_URL
	private String connector_class;
	private int task_max;
	private String hadoop_conf_dir;
	private String hadoop_home;
	private int flush_size;
	private int rotate_interval_ms;
	private int cnr_id; //커넥터_ID
	private String frst_regr_id; //최초_등록자_ID
	private String frst_reg_dtm; //최초_등록_일시
	private String lst_mdfr_id; //최종_수정자_ID
	private String lst_mdf_dtm; //최종_수정_일시
	
	
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
	public int getTrf_trg_id() {
		return trf_trg_id;
	}
	public void setTrf_trg_id(int trf_trg_id) {
		this.trf_trg_id = trf_trg_id;
	}
	public String getTrf_trg_cnn_nm() {
		return trf_trg_cnn_nm;
	}
	public void setTrf_trg_cnn_nm(String trf_trg_cnn_nm) {
		this.trf_trg_cnn_nm = trf_trg_cnn_nm;
	}
	public String getTrf_trg_url() {
		return trf_trg_url;
	}
	public void setTrf_trg_url(String trf_trg_url) {
		this.trf_trg_url = trf_trg_url;
	}
	public String getConnector_class() {
		return connector_class;
	}
	public void setConnector_class(String connector_class) {
		this.connector_class = connector_class;
	}
	public int getTask_max() {
		return task_max;
	}
	public void setTask_max(int task_max) {
		this.task_max = task_max;
	}
	public String getHadoop_conf_dir() {
		return hadoop_conf_dir;
	}
	public void setHadoop_conf_dir(String hadoop_conf_dir) {
		this.hadoop_conf_dir = hadoop_conf_dir;
	}
	public String getHadoop_home() {
		return hadoop_home;
	}
	public void setHadoop_home(String hadoop_home) {
		this.hadoop_home = hadoop_home;
	}
	public int getFlush_size() {
		return flush_size;
	}
	public void setFlush_size(int flush_size) {
		this.flush_size = flush_size;
	}
	public int getRotate_interval_ms() {
		return rotate_interval_ms;
	}
	public void setRotate_interval_ms(int rotate_interval_ms) {
		this.rotate_interval_ms = rotate_interval_ms;
	}
	public int getCnr_id() {
		return cnr_id;
	}
	public void setCnr_id(int cnr_id) {
		this.cnr_id = cnr_id;
	}
	public String getFrst_regr_id() {
		return frst_regr_id;
	}
	public void setFrst_regr_id(String frst_regr_id) {
		this.frst_regr_id = frst_regr_id;
	}
	public String getFrst_reg_dtm() {
		return frst_reg_dtm;
	}
	public void setFrst_reg_dtm(String frst_reg_dtm) {
		this.frst_reg_dtm = frst_reg_dtm;
	}
	public String getLst_mdfr_id() {
		return lst_mdfr_id;
	}
	public void setLst_mdfr_id(String lst_mdfr_id) {
		this.lst_mdfr_id = lst_mdfr_id;
	}
	public String getLst_mdf_dtm() {
		return lst_mdf_dtm;
	}
	public void setLst_mdf_dtm(String lst_mdf_dtm) {
		this.lst_mdf_dtm = lst_mdf_dtm;
	}

}
