package com.k4m.dx.tcontrol.transfer.service.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.json.simple.JSONArray;
import org.json.simple.parser.JSONParser;
import org.springframework.stereotype.Service;

import com.k4m.dx.tcontrol.cmmn.AES256;
import com.k4m.dx.tcontrol.cmmn.AES256_KEY;
import com.k4m.dx.tcontrol.common.service.impl.CmmnServerInfoDAO;
import com.k4m.dx.tcontrol.transfer.service.TransDbmsService;
import com.k4m.dx.tcontrol.transfer.service.TransDbmsVO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;



@Service("transDbmsServiceImpl")
public class TransDbmsServiceImpl extends EgovAbstractServiceImpl implements TransDbmsService{

	@Resource(name = "TransDAO")
	private TransDAO transDAO;

	@Resource(name = "cmmnServerInfoDAO")
	private CmmnServerInfoDAO cmmnServerInfoDAO;

	/**
	 * trans DBMS시스템 명 체크
	 * 
	 * @param transDbmsVO
	 * @return String
	 * @throws Exception
	 */
	@Override
	public String trans_sys_nmCheck(String db2pg_sys_nm) throws Exception {
		int resultCnt = 0;
		String resultStr = "true";

		try {
			resultCnt = transDAO.trans_sys_nmCheck(db2pg_sys_nm);
			
			if (resultCnt > 0) {
				// 중복값이 존재함.
				resultStr = "false";
			} else {
				resultStr = "true";
			}

		} catch (Exception e) {
			resultStr = "false";
			e.printStackTrace();
		}
	
		return resultStr;
	}

	/**
	 * trans DBMS시스템 등록
	 * 
	 * @param transDbmsVO
	 * @return String
	 * @throws Exception
	 */
	@Override
	public String insertTransDBMS(TransDbmsVO transDbmsVO) throws Exception {
		String result = "S";
		String resultMsg = "";

		try {
			//시스템명 중복체크
			String trans_sys_nm = transDbmsVO.getTrans_sys_nm();
			if (trans_sys_nm != null && !"".equals(trans_sys_nm)) {
				resultMsg = trans_sys_nmCheck(trans_sys_nm);
			}

			if (!"true".equals(resultMsg)) {
				result = "O";
			}

			if ("S".equals(result) ) {
				AES256 aes = new AES256(AES256_KEY.ENC_KEY);
				
				String pwd = aes.aesEncode(transDbmsVO.getPwd());
				transDbmsVO.setPwd(pwd);

				
				if ("TC002204".equals(transDbmsVO.getDbms_dscd())) {
					transDbmsVO.setScm_nm(transDbmsVO.getScm_nm());
					transDbmsVO.setDtb_nm(transDbmsVO.getDtb_nm());
				} else {
					transDbmsVO.setScm_nm(transDbmsVO.getScm_nm().toUpperCase());
					transDbmsVO.setDtb_nm(transDbmsVO.getDtb_nm().toUpperCase());
				}

				transDAO.insertTransDBMS(transDbmsVO);

			}
		} catch (SQLException e) {
			result = "F";
			e.printStackTrace();
		} catch (Exception e) {
			result = "F";
			e.printStackTrace();
		}
		
		return result;
	}

	/**
	 * trans dbms 사용여부 확인
	 * 
	 * @param param
	 * @return String
	 * @throws Exception
	 */
	@Override
	public String selectTransDbmsIngChk(TransDbmsVO transDbmsVO) throws Exception {
		String result = "";
		
		Map<String, Object> resultChk = null;
		int rstCnt = 0;

		try {
			JSONArray trans_dbms_ids = (JSONArray) new JSONParser().parse(transDbmsVO.getTrans_dbms_id_Rows());
			if (trans_dbms_ids != null && trans_dbms_ids.size() > 0) {
				for(int i=0; i<trans_dbms_ids.size(); i++){
					TransDbmsVO transDbmsPrmVO = new TransDbmsVO();	
					transDbmsPrmVO.setTrans_trg_sys_id(trans_dbms_ids.get(i).toString());

					resultChk = (Map<String, Object>) transDAO.selectTransDbmsIngChk(transDbmsPrmVO);
					if (resultChk != null) {
						String exeGbn = (String)transDbmsVO.getExeGbn();
						int ingCnt = 0;
	
						if ("update".equals(exeGbn)) {
							ingCnt = Integer.parseInt(resultChk.get("ing_cnt").toString());
						} else {
							ingCnt = Integer.parseInt(resultChk.get("tot_cnt").toString());
						}
						
						rstCnt = rstCnt + ingCnt;
					}
				}
			}

			if (rstCnt > 0) {
				result = "O";
			} else {
				result = "S";
			}
		} catch (SQLException e) {
			result = "F";
			e.printStackTrace();
		} catch (Exception e) {
			result = "F";
			e.printStackTrace();
		}

		return result;
	}

	/**
	 * trans DBMS시스템 리스트 조회
	 * 
	 * @param transDbmsVO
	 * @return List<TransDbmsVO>
	 * @throws Exception
	 */
	@Override
	public List<TransDbmsVO> selectTransDBMS(TransDbmsVO transDbmsVO) throws Exception {
		return transDAO.selectTransDBMS(transDbmsVO);
	}
	
	/**
	 * trans DBMS시스템 수정
	 * 
	 * @param transDbmsVO
	 * @return String
	 * @throws Exception
	 */
	@Override
	public String updateTransDBMS(TransDbmsVO transDbmsVO) throws Exception {
		String result = "S";

		try {
			AES256 aes = new AES256(AES256_KEY.ENC_KEY);
			
			String pwd = aes.aesEncode(transDbmsVO.getPwd());
			transDbmsVO.setPwd(pwd);
			
			if ("TC002204".equals(transDbmsVO.getDbms_dscd())) {
				transDbmsVO.setScm_nm(transDbmsVO.getScm_nm());
				transDbmsVO.setDtb_nm(transDbmsVO.getDtb_nm());
			} else {
				transDbmsVO.setScm_nm(transDbmsVO.getScm_nm().toUpperCase());
				transDbmsVO.setDtb_nm(transDbmsVO.getDtb_nm().toUpperCase());
			}

			transDAO.updateTransDBMS(transDbmsVO);
		} catch (Exception e) {
			result = "F";
			e.printStackTrace();
		}
		
		return result;
	}

	/**
	 * trans DBMS시스템 삭제
	 * 
	 * @param transDbmsVO
	 * @throws Exception
	 */
	@Override
	public void deleteTransDBMS(TransDbmsVO transDbmsVO) throws Exception {
		try{
			JSONArray trans_dbms_ids = (JSONArray) new JSONParser().parse(transDbmsVO.getTrans_dbms_id_Rows());

			if (trans_dbms_ids != null && trans_dbms_ids.size() > 0) {
				for(int i=0; i<trans_dbms_ids.size(); i++){
					TransDbmsVO transDbmsPrmVO = new TransDbmsVO();	
					transDbmsPrmVO.setTrans_sys_id(Integer.parseInt(trans_dbms_ids.get(i).toString()));
					
					transDAO.deleteTransDBMS(transDbmsPrmVO);
				}
			}
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	
	
	
}
