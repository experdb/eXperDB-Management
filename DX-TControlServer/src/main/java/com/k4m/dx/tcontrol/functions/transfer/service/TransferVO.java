package com.k4m.dx.tcontrol.functions.transfer.service;

public class TransferVO {
	private int rownum; // rownum
	private int idx; // idx
	private int trf_cng_id;//전송_설정_ID
	private String kafka_broker_ip;//ZOOKEEPER_IP
	private int kafka_broker_port;//ZOOKEEPER_PORT
	private String schema_registry_ip;//SCHEMA_REGISTRY_IP
	private int schema_registry_port;//SCHEMA_REGISTRY_PORT
	private String zookeeper_ip;//ZOOKEEPER_IP
	private int zookeeper_port;//ZOOKEEPER_PORT
	private String bw_home;//BW_HOME
	private String frst_regr_id;//최초_등록자_ID
	private String frst_reg_dtm;//최초_등록_일시
	private String lst_mdfr_id;//최종_수정자_ID
	private String lst_mdf_dtm;;//최초_수정_일시
	
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
	public int getTrf_cng_id() {
		return trf_cng_id;
	}
	public void setTrf_cng_id(int trf_cng_id) {
		this.trf_cng_id = trf_cng_id;
	}
	public String getKafka_broker_ip() {
		return kafka_broker_ip;
	}
	public void setKafka_broker_ip(String kafka_broker_ip) {
		this.kafka_broker_ip = kafka_broker_ip;
	}
	public int getKafka_broker_port() {
		return kafka_broker_port;
	}
	public void setKafka_broker_port(int kafka_broker_port) {
		this.kafka_broker_port = kafka_broker_port;
	}
	public String getSchema_registry_ip() {
		return schema_registry_ip;
	}
	public void setSchema_registry_ip(String schema_registry_ip) {
		this.schema_registry_ip = schema_registry_ip;
	}
	public int getSchema_registry_port() {
		return schema_registry_port;
	}
	public void setSchema_registry_port(int schema_registry_port) {
		this.schema_registry_port = schema_registry_port;
	}
	public String getZookeeper_ip() {
		return zookeeper_ip;
	}
	public void setZookeeper_ip(String zookeeper_ip) {
		this.zookeeper_ip = zookeeper_ip;
	}
	public int getZookeeper_port() {
		return zookeeper_port;
	}
	public void setZookeeper_port(int zookeeper_port) {
		this.zookeeper_port = zookeeper_port;
	}
	public String getBw_home() {
		return bw_home;
	}
	public void setBw_home(String bw_home) {
		this.bw_home = bw_home;
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
