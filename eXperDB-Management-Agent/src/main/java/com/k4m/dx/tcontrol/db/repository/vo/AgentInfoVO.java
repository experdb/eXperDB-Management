package com.k4m.dx.tcontrol.db.repository.vo;

/**
* @author 박태혁
* @see
* 
*      <pre>
* == 개정이력(Modification Information) ==
*
*   수정일       수정자           수정내용
*  -------     --------    ---------------------------
*  2018.04.23   박태혁 최초 생성
*      </pre>
*/

public class AgentInfoVO {
	private int AGT_SN;
	private String IPADR;
	private int SOCKET_PORT;
	private String AGT_CNDT_CD;
	private String STRT_DTM;
	private String ISTCNF_YN;
	private String AGT_VERSION;
	private String MASTER_GBN;
	private String FRST_REGR_ID;
	private String FRST_REG_DTM;
	private String LST_MDFR_ID;
	private String LST_MDF_DTM;
	private String INTL_IPADR;

	public String TC001101 = "TC001101"; //실행
	public String TC001102 = "TC001102"; //중지

	public String getINTL_IPADR() {
		return INTL_IPADR;
	}
	public void setINTL_IPADR(String iNTL_IPADR) {
		INTL_IPADR = iNTL_IPADR;
	}
	public String getMASTER_GBN() {
		return MASTER_GBN;
	}
	public void setMASTER_GBN(String mASTER_GBN) {
		MASTER_GBN = mASTER_GBN;
	}
	public String getAGT_VERSION() {
		return AGT_VERSION;
	}
	public void setAGT_VERSION(String aGT_VERSION) {
		AGT_VERSION = aGT_VERSION;
	}
	public int getAGT_SN() {
		return AGT_SN;
	}
	public void setAGT_SN(int aGT_SN) {
		AGT_SN = aGT_SN;
	}
	public String getIPADR() {
		return IPADR;
	}
	public void setIPADR(String iPADR) {
		IPADR = iPADR;
	}
	public int getSOCKET_PORT() {
		return SOCKET_PORT;
	}
	public void setSOCKET_PORT(int sOCKET_PORT) {
		SOCKET_PORT = sOCKET_PORT;
	}
	public String getAGT_CNDT_CD() {
		return AGT_CNDT_CD;
	}
	public void setAGT_CNDT_CD(String aGT_CNDT_CD) {
		AGT_CNDT_CD = aGT_CNDT_CD;
	}
	public String getSTRT_DTM() {
		return STRT_DTM;
	}
	public void setSTRT_DTM(String sTRT_DTM) {
		STRT_DTM = sTRT_DTM;
	}
	public String getISTCNF_YN() {
		return ISTCNF_YN;
	}
	public void setISTCNF_YN(String iSTCNF_YN) {
		ISTCNF_YN = iSTCNF_YN;
	}
	public String getFRST_REGR_ID() {
		return FRST_REGR_ID;
	}
	public void setFRST_REGR_ID(String fRST_REGR_ID) {
		FRST_REGR_ID = fRST_REGR_ID;
	}
	public String getFRST_REG_DTM() {
		return FRST_REG_DTM;
	}
	public void setFRST_REG_DTM(String fRST_REG_DTM) {
		FRST_REG_DTM = fRST_REG_DTM;
	}
	public String getLST_MDFR_ID() {
		return LST_MDFR_ID;
	}
	public void setLST_MDFR_ID(String lST_MDFR_ID) {
		LST_MDFR_ID = lST_MDFR_ID;
	}
	public String getLST_MDF_DTM() {
		return LST_MDF_DTM;
	}
	public void setLST_MDF_DTM(String lST_MDF_DTM) {
		LST_MDF_DTM = lST_MDF_DTM;
	}
}