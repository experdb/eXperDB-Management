package com.experdb.proxy.db.repository.vo;

/**
* @author 최정환
* @see
* 
*      <pre>
* == 개정이력(Modification Information) ==
*
*   수정일       수정자           수정내용
*  -------     --------    ---------------------------
*  2021.02.24   최정환 	최초 생성
*      </pre>
*/
public class AgentInfoVO {
	private int agt_sn; 
	private String ipadr; 
	private String domain_nm; 
	private int socket_port; 
	private String agt_cndt_cd; 
	private String svr_use_yn; 
	private String strt_dtm; 
	private String istcnf_yn; 
	private String agt_version; 
	private String frst_regr_id; 
	private String frst_reg_dtm; 
	private String lst_mdfr_id; 
	private String lst_mdf_dtm;
	private String kal_install_yn;
	
	public String TC001501 = "TC001501"; //실행
	public String TC001502 = "TC001502"; //중지

	public String getKal_install_yn() {
		return kal_install_yn;
	}
	public void setKal_install_yn(String kal_install_yn) {
		this.kal_install_yn = kal_install_yn;
	}
	public int getAgt_sn() {
		return agt_sn;
	}
	public void setAgt_sn(int agt_sn) {
		this.agt_sn = agt_sn;
	}
	public String getIpadr() {
		return ipadr;
	}
	public void setIpadr(String ipadr) {
		this.ipadr = ipadr;
	}
	public String getDomain_nm() {
		return domain_nm;
	}
	public void setDomain_nm(String domain_nm) {
		this.domain_nm = domain_nm;
	}
	public int getSocket_port() {
		return socket_port;
	}
	public void setSocket_port(int socket_port) {
		this.socket_port = socket_port;
	}
	public String getAgt_cndt_cd() {
		return agt_cndt_cd;
	}
	public void setAgt_cndt_cd(String agt_cndt_cd) {
		this.agt_cndt_cd = agt_cndt_cd;
	}
	public String getSvr_use_yn() {
		return svr_use_yn;
	}
	public void setSvr_use_yn(String svr_use_yn) {
		this.svr_use_yn = svr_use_yn;
	}
	public String getStrt_dtm() {
		return strt_dtm;
	}
	public void setStrt_dtm(String strt_dtm) {
		this.strt_dtm = strt_dtm;
	}
	public String getIstcnf_yn() {
		return istcnf_yn;
	}
	public void setIstcnf_yn(String istcnf_yn) {
		this.istcnf_yn = istcnf_yn;
	}
	public String getAgt_version() {
		return agt_version;
	}
	public void setAgt_version(String agt_version) {
		this.agt_version = agt_version;
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
