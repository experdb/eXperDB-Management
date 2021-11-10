package com.k4m.dx.tcontrol.transfer.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.k4m.dx.tcontrol.admin.dbserverManager.service.DbServerVO;
import com.k4m.dx.tcontrol.cmmn.AES256;
import com.k4m.dx.tcontrol.cmmn.AES256_KEY;
import com.k4m.dx.tcontrol.cmmn.client.ClientInfoCmmn;
import com.k4m.dx.tcontrol.common.service.AgentInfoVO;
import com.k4m.dx.tcontrol.common.service.impl.CmmnServerInfoDAO;
import com.k4m.dx.tcontrol.login.service.LoginVO;
import com.k4m.dx.tcontrol.transfer.service.TransConService;
import com.k4m.dx.tcontrol.transfer.service.TransDbmsVO;
import com.k4m.dx.tcontrol.transfer.service.TransMappVO;
import com.k4m.dx.tcontrol.transfer.service.TransRegiVO;
import com.k4m.dx.tcontrol.transfer.service.TransService;
import com.k4m.dx.tcontrol.transfer.service.TransVO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("transConServiceImpl")
public class TransConServiceImpl extends EgovAbstractServiceImpl implements TransConService{

	@Resource(name = "TransConDAO")
	private TransConDAO transConDAO;

	@Resource(name = "cmmnServerInfoDAO")
	private CmmnServerInfoDAO cmmnServerInfoDAO;
	
	/**
	 * kafka-Connection 연결 테스트
	 * 
	 * @param response, request
	 * @return result
	 * @throws Exception
	 */
	@Override
	public Map<String, Object> kafkaConnectionTest(Map<String, Object> paramMap) throws Exception {

		Map<String, Object> result = new HashMap<String, Object>();
		
		try {
			int db_svr_id = Integer.parseInt(String.valueOf(paramMap.get("db_svr_id")));
			String connect_gbn = String.valueOf(paramMap.get("connect_gbn"));
			
			String kafkaIp = "";
			String kafkaPort = "";
			String regiIP = "";
			String regiPort = "";
			String cmd = "";
			
			if ("kafka".equals(connect_gbn)) {
				kafkaIp = String.valueOf(paramMap.get("kafkaIp"));
				kafkaPort = String.valueOf(paramMap.get("kafkaPort"));
				
				cmd = "curl -H 'Accept:application/json' "+kafkaIp+":"+kafkaPort+"/";
			} else {
				regiIP = String.valueOf(paramMap.get("regiIP"));
				regiPort = String.valueOf(paramMap.get("regiPort"));
				
				cmd = "curl -X GET http://"+regiIP+":"+regiPort+"/subjects";
			}

			System.out.println("명령어 = "+cmd);
			
			DbServerVO schDbServerVO = new DbServerVO();
			schDbServerVO.setDb_svr_id(db_svr_id);
			DbServerVO dbServerVO = (DbServerVO) cmmnServerInfoDAO.selectServerInfo(schDbServerVO);

			String strIpAdr = dbServerVO.getIpadr();
			AgentInfoVO vo = new AgentInfoVO();
			vo.setIPADR(strIpAdr);
			AgentInfoVO agentInfo = (AgentInfoVO) cmmnServerInfoDAO.selectAgentInfo(vo);

			String IP = dbServerVO.getIpadr();
			int PORT = agentInfo.getSOCKET_PORT();

			ClientInfoCmmn cic = new ClientInfoCmmn();
			result = cic.kafkaConnectionTest(IP, PORT, cmd);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return result;
	}
	

	/**
	 * trans kafka 사용여부 확인
	 * 
	 * @param param
	 * @return String
	 * @throws Exception
	 */
	@Override
	public String selectTransKafkaConIngChk(TransDbmsVO transDbmsVO) throws Exception {
		String result = "";
		
		Map<String, Object> resultChk = null;
		int rstCnt = 0;

		try {
			JSONArray trans_connect_ids = (JSONArray) new JSONParser().parse(transDbmsVO.getTrans_connect_id_Rows());
			if (trans_connect_ids != null && trans_connect_ids.size() > 0) {
				for(int i=0; i<trans_connect_ids.size(); i++){
					TransDbmsVO transDbmsPrmVO = new TransDbmsVO();	
					transDbmsPrmVO.setKc_id(trans_connect_ids.get(i).toString());

					resultChk = (Map<String, Object>) transConDAO.selectTransKafkaConIngChk(transDbmsPrmVO);
					if (resultChk != null) {
						int ingCnt = 0;
	
						ingCnt = Integer.parseInt(resultChk.get("tot_cnt").toString());
						
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
	 * trans Schema Registry 사용여부 확인
	 * 
	 * @param transRegiVO
	 * @return String
	 * @throws Exception
	 */
	@Override
	public String selectTransSchemRegiIngChk(TransRegiVO transRegiVO) throws Exception {
		String result = "";
		
		Map<String, Object> resultChk = null;
		int rstCnt = 0;

		try {
			JSONArray trans_regi_ids = (JSONArray) new JSONParser().parse(transRegiVO.getTrans_regi_id_Rows());
			if (trans_regi_ids != null && trans_regi_ids.size() > 0) {
				for(int i=0; i<trans_regi_ids.size(); i++){
					TransDbmsVO transDbmsPrmVO = new TransDbmsVO();	
					transDbmsPrmVO.setRegi_id(trans_regi_ids.get(i).toString());

					resultChk = (Map<String, Object>) transConDAO.selectTransSchemRegiIngChk(transDbmsPrmVO);
					if (resultChk != null) {
						int ingCnt = 0;
	
						ingCnt = Integer.parseInt(resultChk.get("tot_cnt").toString());
						
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
	 * trans Schema Registry 정보 수정
	 * 
	 * @param transDbmsVO
	 * @return String
	 * @throws Exception
	 */
	@Override
	public String updateTransShcemaRegistry(TransRegiVO transRegiVO) throws Exception {
		String result = "S";

		try {
			transConDAO.updateTransSchemaRegistry(transRegiVO);

			//kafka connect 이력 등록
			
		} catch (Exception e) {
			result = "F";
			e.printStackTrace();
		}
		
		return result;
	}
	
	/**
	 * Schema Registry list 조회
	 * 
	 * @param transDbmsVO
	 * @return List<TransRegiVO>
	 * @throws Exception
	 */
	@Override
	public List<TransRegiVO> selectTransRegiList(TransRegiVO transRegiVO) throws Exception {
		return transConDAO.selectTransRegiList(transRegiVO);
	}
	
	/**
	 * trans kafka connect list 조회
	 * 
	 * @param transDbmsVO
	 * @return List<TransDbmsVO>
	 * @throws Exception
	 */
	@Override
	public List<TransDbmsVO> selectTransKafkaConList(TransDbmsVO transDbmsVO) throws Exception {
		return transConDAO.selectTransKafkaConList(transDbmsVO);
	}

	/**
	 * trans kafka connect 설정 삭제
	 * 
	 * @param transRegiVO
	 * @throws Exception
	 */
	@Override
	public void deleteTransSchemaRegistry(TransRegiVO transRegiVO) throws Exception {
		try{
			JSONArray trans_connect_ids = (JSONArray) new JSONParser().parse(transRegiVO.getTrans_regi_id_Rows());

			if (trans_connect_ids != null && trans_connect_ids.size() > 0) {
				for(int i=0; i<trans_connect_ids.size(); i++){
					TransRegiVO transRegiPrmVO = new TransRegiVO();	
					transRegiPrmVO.setRegi_id(trans_connect_ids.get(i).toString());
					
					transConDAO.deleteTransSchemaRegistry(transRegiPrmVO);
					transConDAO.deleteTransSchemaRegistryLog(transRegiPrmVO);
				}
			}
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	
	/**
	 * trans kafka connect 설정 삭제
	 * 
	 * @param transDbmsVO
	 * @throws Exception
	 */
	@Override
	public void deleteTransKafkaConnect(TransDbmsVO transDbmsVO) throws Exception {
		try{
			JSONArray trans_connect_ids = (JSONArray) new JSONParser().parse(transDbmsVO.getTrans_connect_id_Rows());

			if (trans_connect_ids != null && trans_connect_ids.size() > 0) {
				for(int i=0; i<trans_connect_ids.size(); i++){
					TransDbmsVO transDbmsPrmVO = new TransDbmsVO();	
					transDbmsPrmVO.setKc_id(trans_connect_ids.get(i).toString());
					
					transConDAO.deleteTransKafkaConnect(transDbmsPrmVO);

					transConDAO.deleteTransKafkaConnectLog(transDbmsPrmVO);
				}
			}
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	
	/**
	 * TRANS Schema Registry 설정 등록
	 * 
	 * @param TransRegiVO
	 * @return String
	 * @throws Exception
	 */
	@Override
	public String insertTransSchemaRegistry(TransRegiVO transRegiVO) throws Exception {
		String result = "S";
		String resultMsg = "";

		try {
			//커넥트명 중복체크
			String regi_nm = transRegiVO.getRegi_nm();
			if (regi_nm != null && !"".equals(regi_nm)) {
				resultMsg = trans_Registry_nmCheck(regi_nm);
			}

			if (!"true".equals(resultMsg)) {
				result = "O";
			}

			if ("S".equals(result) ) {
				transConDAO.insertTransSchemaRegistry(transRegiVO);
				
			    transRegiVO.setAct_type("A");			//활성화
				transRegiVO.setAct_exe_type("TC004001");//manual
				transRegiVO.setExe_rslt_cd("TC001501");

				transConDAO.insertTransSchemaRegistryLog(transRegiVO);
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
	 * TRANS kafka connect 설정 등록
	 * 
	 * @param transDbmsVO
	 * @return String
	 * @throws Exception
	 */
	@Override
	public String insertTransKafkaConnect(TransDbmsVO transDbmsVO) throws Exception {
		String result = "S";
		String resultMsg = "";

		try {
			//커넥트명 중복체크
			String kc_nm = transDbmsVO.getKc_nm();
			if (kc_nm != null && !"".equals(kc_nm)) {
				resultMsg = trans_connect_nmCheck(kc_nm);
			}

			if (!"true".equals(resultMsg)) {
				result = "O";
			}

			if ("S".equals(result) ) {
				transConDAO.insertTransKafkaConnect(transDbmsVO);
				
				transDbmsVO.setAct_type("A");			//활성화
				transDbmsVO.setAct_exe_type("TC004001");//manual
				transDbmsVO.setExe_rslt_cd("TC001501");

				transConDAO.insertTransKafkaConnectLog(transDbmsVO);
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
	 * trans DBMS시스템 명 체크
	 * 
	 * @param transDbmsVO
	 * @return String
	 * @throws Exception
	 */
	@Override
	public String trans_Registry_nmCheck(String regi_nm) throws Exception {
		int resultCnt = 0;
		String resultStr = "true";

		try {
			resultCnt = transConDAO.trans_Registry_nmCheck(regi_nm);
			
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
	 * trans DBMS시스템 명 체크
	 * 
	 * @param transDbmsVO
	 * @return String
	 * @throws Exception
	 */
	@Override
	public String trans_connect_nmCheck(String kc_nm) throws Exception {
		int resultCnt = 0;
		String resultStr = "true";

		try {
			resultCnt = transConDAO.trans_connect_nmCheck(kc_nm);
			
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
	 * trans connect 수정
	 * 
	 * @param transDbmsVO
	 * @return String
	 * @throws Exception
	 */
	@Override
	public String updateTransKafkaConnect(TransDbmsVO transDbmsVO) throws Exception {
		String result = "S";

		try {
			transConDAO.updateTransKafkaConnect(transDbmsVO);

			//kafka connect 이력 등록
			
		} catch (Exception e) {
			result = "F";
			e.printStackTrace();
		}
		
		return result;
	}
	
	/**
	 * trans connect 수정
	 * 
	 * @param transDbmsVO
	 * @return String
	 * @throws Exception
	 */
	@Override
	public String updateTransKafkaConnectFaild(TransDbmsVO transDbmsVO) throws Exception {
		String result = "S";

		try {
			transConDAO.updateTransKafkaConnectFaild(transDbmsVO);
		} catch (Exception e) {
			result = "F";
			e.printStackTrace();
		}
		
		return result;
	}
	
	/**
	 * trans schema registry connect 수정
	 * 
	 * @param transDbmsVO
	 * @return String
	 * @throws Exception
	 */
	@Override
	public String updateTransSchemaConnectFaild(TransRegiVO transRegiVO) throws Exception {
		String result = "S";

		try {
			transConDAO.updateTransSchemaConnectFaild(transRegiVO);
		} catch (Exception e) {
			result = "F";
			e.printStackTrace();
		}
		
		return result;
	}
	
	/**
	 * select box kafka-Connection 연결 테스트
	 * 
	 * @param transDbmsVO
	 * @return String
	 * @throws Exception
	 */
	public Map<String, Object> kafkaConnectionTestUpdate(TransDbmsVO transDbmsVO, List<TransDbmsVO> resultSet, int db_svr_id, String id) throws Exception {
		Map<String, Object> result = new HashMap<String, Object>();
		String resultCode = "";
		String exeStatus = "";
		String dbStatus = "";
		String kafkaIp = "";
		String kafkaPort = "";
		
		if (resultSet != null) {
			exeStatus = resultSet.get(0).getExe_status();
			kafkaIp = resultSet.get(0).getKc_ip();
			kafkaPort = resultSet.get(0).getKc_port();
			
			String cmd = "curl -H 'Accept:application/json' "+kafkaIp+":"+kafkaPort+"/";
			System.out.println("명령어 = "+cmd);				

			DbServerVO schDbServerVO = new DbServerVO();
			schDbServerVO.setDb_svr_id(db_svr_id);
			DbServerVO dbServerVO = (DbServerVO) cmmnServerInfoDAO.selectServerInfo(schDbServerVO);
			
			String strIpAdr = dbServerVO.getIpadr();
			AgentInfoVO vo = new AgentInfoVO();
			vo.setIPADR(strIpAdr);
			AgentInfoVO agentInfo = (AgentInfoVO) cmmnServerInfoDAO.selectAgentInfo(vo);

			String IP = dbServerVO.getIpadr();
			int PORT = agentInfo.getSOCKET_PORT();

			ClientInfoCmmn cic = new ClientInfoCmmn();

			result = cic.kafkaConnectionTest(IP, PORT, cmd);
			
			if (result == null) {
				result.put("RESULT_DATA", "fail");
			} else {					
				resultCode = (String)result.get("RESULT_DATA");
				if ("TC001501".equals(exeStatus)) {
					dbStatus = "success";
				} else {
					dbStatus = "fali";
				}
				
				if (!resultCode.equals(dbStatus)) {
					if ("success".equals(resultCode)) {
						transDbmsVO.setExe_status("TC001501");
					} else {
						transDbmsVO.setExe_status("TC001502");
					}

					transDbmsVO.setFrst_regr_id(id);
					transDbmsVO.setLst_mdfr_id(id);

					updateTransKafkaConnectFaild(transDbmsVO);
				}
			}

			result.put("ip", kafkaIp);
			result.put("port", kafkaPort);
		} else {
			result.put("ip", "");
			result.put("port", "");
		}
		
		return result;
	}
	
	/**
	 * select box schema Registry 연결 테스트
	 * 
	 * @param transDbmsVO
	 * @return String
	 * @throws Exception
	 */
	public Map<String, Object> schemaRegistryTestUpdate(TransRegiVO transRegiVO, List<TransRegiVO> resultSet, int db_svr_id, String id) throws Exception {
		Map<String, Object> result = new HashMap<String, Object>();
		String resultCode = "";
		String exeStatus = "";
		String dbStatus = "";
		String regiIP = "";
		String regiPort = "";
		
		if (resultSet != null) {
			exeStatus = resultSet.get(0).getExe_status();
			regiIP = resultSet.get(0).getRegi_ip();
			regiPort = resultSet.get(0).getRegi_port();

			String cmd = "curl -X GET http://"+regiIP+":"+regiPort+"/subjects";
			System.out.println("명령어 = "+cmd);				

			DbServerVO schDbServerVO = new DbServerVO();
			schDbServerVO.setDb_svr_id(db_svr_id);
			DbServerVO dbServerVO = (DbServerVO) cmmnServerInfoDAO.selectServerInfo(schDbServerVO);
			
			String strIpAdr = dbServerVO.getIpadr();
			AgentInfoVO vo = new AgentInfoVO();
			vo.setIPADR(strIpAdr);
			AgentInfoVO agentInfo = (AgentInfoVO) cmmnServerInfoDAO.selectAgentInfo(vo);

			String IP = dbServerVO.getIpadr();
			int PORT = agentInfo.getSOCKET_PORT();

			ClientInfoCmmn cic = new ClientInfoCmmn();

			result = cic.kafkaConnectionTest(IP, PORT, cmd);
			
			if (result == null) {
				result.put("RESULT_DATA", "fail");
			} else {					
				resultCode = (String)result.get("RESULT_DATA");
				if ("TC001501".equals(exeStatus)) {
					dbStatus = "success";
				} else {
					dbStatus = "fali";
				}
				
				if (!resultCode.equals(dbStatus)) {
					if ("success".equals(resultCode)) {
						transRegiVO.setExe_status("TC001501");
					} else {
						transRegiVO.setExe_status("TC001502");
					}

					transRegiVO.setFrst_regr_id(id);
					transRegiVO.setLst_mdfr_id(id);

					updateTransSchemaConnectFaild(transRegiVO);
				}
			}

			result.put("ip", regiIP);
			result.put("port", regiPort);
		} else {
			result.put("ip", "");
			result.put("port", "");
		}
		
		return result;		
	}
}
