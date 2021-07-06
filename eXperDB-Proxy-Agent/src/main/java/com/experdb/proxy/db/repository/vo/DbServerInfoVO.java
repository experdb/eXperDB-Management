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
public class DbServerInfoVO {
	private int DB_SVR_ID;
	private String DB_SVR_NM;
	private String IPADR;
	private int PORTNO;
	private String DFT_DB_NM;
	private String SVR_SPR_USR_ID;
	private String SVR_SPR_SCM_PWD;
	private String FRST_REGR_ID;
	private String FRST_REG_DTM;
	private String LST_MDFR_ID;
	private String LST_MDF_DTM;
	private String DB_CNDT;
	private String MASTER_GBN;
	private String INTL_IPADR;
	
	private String SEARCH_IPADR;

	public String getSEARCH_IPADR() {
		return SEARCH_IPADR;
	}
	public void setSEARCH_IPADR(String sEARCH_IPADR) {
		SEARCH_IPADR = sEARCH_IPADR;
	}
	public String getINTL_IPADR() {
		return INTL_IPADR;
	}
	public void setINTL_IPADR(String iNTL_IPADR) {
		INTL_IPADR = iNTL_IPADR;
	}
	public String getDB_CNDT() {
		return DB_CNDT;
	}
	public void setDB_CNDT(String dB_CNDT) {
		DB_CNDT = dB_CNDT;
	}
	public String getMASTER_GBN() {
		return MASTER_GBN;
	}
	public void setMASTER_GBN(String mASTER_GBN) {
		MASTER_GBN = mASTER_GBN;
	}
	public int getDB_SVR_ID() {
		return DB_SVR_ID;
	}
	public void setDB_SVR_ID(int dB_SVR_ID) {
		DB_SVR_ID = dB_SVR_ID;
	}
	public String getDB_SVR_NM() {
		return DB_SVR_NM;
	}
	public void setDB_SVR_NM(String dB_SVR_NM) {
		DB_SVR_NM = dB_SVR_NM;
	}
	public String getIPADR() {
		return IPADR;
	}
	public int getPORTNO() {
		return PORTNO;
	}
	public void setPORTNO(int pORTNO) {
		PORTNO = pORTNO;
	}
	public void setIPADR(String iPADR) {
		IPADR = iPADR;
	}

	public String getDFT_DB_NM() {
		return DFT_DB_NM;
	}
	public void setDFT_DB_NM(String dFT_DB_NM) {
		DFT_DB_NM = dFT_DB_NM;
	}
	public String getSVR_SPR_USR_ID() {
		return SVR_SPR_USR_ID;
	}
	public void setSVR_SPR_USR_ID(String sVR_SPR_USR_ID) {
		SVR_SPR_USR_ID = sVR_SPR_USR_ID;
	}
	public String getSVR_SPR_SCM_PWD() {
		return SVR_SPR_SCM_PWD;
	}
	public void setSVR_SPR_SCM_PWD(String sVR_SPR_SCM_PWD) {
		SVR_SPR_SCM_PWD = sVR_SPR_SCM_PWD;
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
