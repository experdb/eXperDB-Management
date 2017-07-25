package com.k4m.dx.tcontrol.tree.transfer.service;

public class TransferDetailVO {
	private String trf_trg_cnn_nm;
	public String getTrf_trg_cnn_nm() {
		return trf_trg_cnn_nm;
	}
	public void setTrf_trg_cnn_nm(String trf_trg_cnn_nm) {
		this.trf_trg_cnn_nm = trf_trg_cnn_nm;
	}
	public int getCnr_id() {
		return cnr_id;
	}
	public void setCnr_id(int cnr_id) {
		this.cnr_id = cnr_id;
	}
	public String getDb_nm() {
		return db_nm;
	}
	public void setDb_nm(String db_nm) {
		this.db_nm = db_nm;
	}
	private int cnr_id;
	private String db_nm;

}
