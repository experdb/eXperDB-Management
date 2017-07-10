package com.k4m.dx.tcontrol.common.service;

public class AgentInfoVO {
	private int DB_SVR_ID;
	private int SOCKET_PORT;
	private String AGT_CNDT_CD;
	private String STRT_DTM;
	private String ISTCNF_YN;
	private String FRST_REGR_ID;
	private String FRST_REG_DTM;
	private String LST_MDFR_ID;
	private String LST_MDF_DTM;
	
	public static String TC001101 = "TC001101"; //실행
	public static String TC001102 = "TC001102"; //중지
	

	public int getDB_SVR_ID() {
		return DB_SVR_ID;
	}
	public void setDB_SVR_ID(int dB_SVR_ID) {
		DB_SVR_ID = dB_SVR_ID;
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
