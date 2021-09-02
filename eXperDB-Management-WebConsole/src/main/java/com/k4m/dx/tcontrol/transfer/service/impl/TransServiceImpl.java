package com.k4m.dx.tcontrol.transfer.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.json.simple.JSONArray;
import org.json.simple.parser.JSONParser;
import org.springframework.stereotype.Service;

import com.k4m.dx.tcontrol.admin.dbserverManager.service.DbServerVO;
import com.k4m.dx.tcontrol.cmmn.AES256;
import com.k4m.dx.tcontrol.cmmn.AES256_KEY;
import com.k4m.dx.tcontrol.cmmn.client.ClientInfoCmmn;
import com.k4m.dx.tcontrol.common.service.AgentInfoVO;
import com.k4m.dx.tcontrol.common.service.impl.CmmnServerInfoDAO;
import com.k4m.dx.tcontrol.transfer.service.TransDbmsVO;
import com.k4m.dx.tcontrol.transfer.service.TransMappVO;
import com.k4m.dx.tcontrol.transfer.service.TransService;
import com.k4m.dx.tcontrol.transfer.service.TransVO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;



@Service("transServiceImpl")
public class TransServiceImpl extends EgovAbstractServiceImpl implements TransService{

	@Resource(name = "TransDAO")
	private TransDAO transDAO;

	@Resource(name = "cmmnServerInfoDAO")
	private CmmnServerInfoDAO cmmnServerInfoDAO;
	
	/**
	 * 소스시스템 전송설정 조회
	 * 
	 * @param transVO
	 * @return List<Map<String, Object>>
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> selectTransSetting(TransVO transVO) throws Exception {
		return transDAO.selectTransSetting(transVO);
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

				transDbmsVO.setScm_nm(transDbmsVO.getScm_nm().toUpperCase());
				transDbmsVO.setDtb_nm(transDbmsVO.getDtb_nm().toUpperCase());

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
			transDbmsVO.setScm_nm(transDbmsVO.getScm_nm().toUpperCase());
			transDbmsVO.setDtb_nm(transDbmsVO.getDtb_nm().toUpperCase());

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

	/**
	 * 타겟시스템 전송설정 조회
	 * 
	 * @param transVO
	 * @return List<Map<String, Object>>
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> selectTargetTransSetting(TransVO transVO) throws Exception {
		return transDAO.selectTargetTransSetting(transVO);
	}

	/**
	 * source 커넥트 정보 조회
	 * @param trans_id
	 * @return List<Map<String, Object>>
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> selectTransInfo(int trans_id) throws Exception {
		return transDAO.selectTransInfo(trans_id);
	}

	/**
	 * target 커넥트 정보 조회
	 * @param trans_id
	 * @return List<Map<String, Object>>
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> selectTargetTransInfo(int trans_id) throws Exception {
		return transDAO.selectTargetTransInfo(trans_id);
	}

	/**
	 * source 매핑 정보 조회
	 * @param trans_id
	 * @return List<Map<String, Object>>
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> selectMappInfo(int trans_exrt_trg_tb_id) throws Exception {
		return transDAO.selectMappInfo(trans_exrt_trg_tb_id);
	}
	
	/**
	 * source trans 커넥트 시작
	 * 
	 * @param transDbmsVO
	 * @return String
	 * @throws Exception
	 */
	@Override
	public String transStart(TransVO transVO) throws Exception {
		String result = "fail";
		String result_code = "";
	
		List<Map<String, Object>> transInfo = null;
		List<Map<String, Object>> mappInfo = null;
		
		Map<String, Object> connStartResult = new  HashMap<String, Object>();

		try {
			int db_svr_id = transVO.getDb_svr_id();
			int trans_exrt_trg_tb_id = transVO.getTrans_exrt_trg_tb_id();
			int trans_id = transVO.getTrans_id();

			AES256 dec = new AES256(AES256_KEY.ENC_KEY);
			
			//db 서버 조회
			DbServerVO schDbServerVO = new DbServerVO();
			schDbServerVO.setDb_svr_id(db_svr_id);
			DbServerVO dbServerVO = (DbServerVO) cmmnServerInfoDAO.selectServerInfo(schDbServerVO);
			
			//agent 조회
			String strIpAdr = dbServerVO.getIpadr();
			AgentInfoVO vo = new AgentInfoVO();
			vo.setIPADR(strIpAdr);
			AgentInfoVO agentInfo = (AgentInfoVO) cmmnServerInfoDAO.selectAgentInfo(vo);

			String IP = dbServerVO.getIpadr();
			int PORT = agentInfo.getSOCKET_PORT();

			dbServerVO.setSvr_spr_scm_pwd(dec.aesDecode(dbServerVO.getSvr_spr_scm_pwd_old()));
			dbServerVO.setUsr_id(transVO.getFrst_regr_id());

			//전송정보 조회
			transInfo = transDAO.selectTransInfo(trans_id);
			System.out.println("전송정보 : "+transInfo.get(0));

			//매핑정보 조회
			mappInfo = transDAO.selectMappInfo(trans_exrt_trg_tb_id);
			System.out.println("매핑정보 : "+mappInfo.get(0));
			
			ClientInfoCmmn cic = new ClientInfoCmmn();
			connStartResult = cic.connectStart(IP, PORT, dbServerVO, transInfo, mappInfo);
			
			if (connStartResult != null) {
				result_code = connStartResult.get("RESULT_CODE").toString();
				if ("0".equals(result_code)) {
					result = "success";
				} else {
					result = "fail";
				}
			}
		} catch (Exception e) {
			result = "fail";
			e.printStackTrace();
		}
		
		return result;
	}
	
	/**
	 * source trans 커넥트 stop
	 * 
	 * @param transDbmsVO
	 * @return String
	 * @throws Exception
	 */
	@Override
	public String transStop(TransVO transVO) throws Exception {
		String result = "fail";
		String result_code = "";

		Map<String, Object> connStartResult = new  HashMap<String, Object>();

		try {
			String kc_ip = transVO.getKc_ip();
			String kc_port = Integer.toString(transVO.getKc_port());
			String connect_nm = transVO.getConnect_nm();
			int db_svr_id = transVO.getDb_svr_id();
			String trans_id = Integer.toString(transVO.getTrans_id());
			String trans_active_gbn = transVO.getTrans_active_gbn();
			String str_login_id = "system";
			
			if (transVO.getFrst_regr_id() != null && !"".equals(transVO.getFrst_regr_id())) {
				str_login_id = transVO.getFrst_regr_id();
			}

			String strCmd =" curl -i -X DELETE -H 'Accept:application/json' "+kc_ip+":"+kc_port+"/connectors/"+connect_nm;
			
			//db 서버 조회
			DbServerVO schDbServerVO = new DbServerVO();
			schDbServerVO.setDb_svr_id(db_svr_id);
			DbServerVO dbServerVO = (DbServerVO) cmmnServerInfoDAO.selectServerInfo(schDbServerVO);
			
			//agent 조회
			String strIpAdr = dbServerVO.getIpadr();
			AgentInfoVO vo = new AgentInfoVO();
			vo.setIPADR(strIpAdr);
			AgentInfoVO agentInfo = (AgentInfoVO) cmmnServerInfoDAO.selectAgentInfo(vo);

			String IP = dbServerVO.getIpadr();
			int PORT = agentInfo.getSOCKET_PORT();

			ClientInfoCmmn cic = new ClientInfoCmmn();
			connStartResult = cic.connectStop(IP, PORT, strCmd, trans_id, trans_active_gbn, str_login_id);
System.out.println("connStartResult=========================" + connStartResult);
			if (connStartResult != null) {
				System.out.println("connStartResult=========123123================" + connStartResult.get("RESULT_CODE").toString());
				result_code = connStartResult.get("RESULT_CODE").toString();
				if ("0".equals(result_code)) {
					result = "success";
				} else if ("-1".equals(result_code)) {
					result = "no_depth";
				} else {
					result = "fail";
				}
			}
		} catch (Exception e) {
			result = "fail";
			e.printStackTrace();
		}
		
		return result;
	}

	/**
	 * target trans 커넥트 시작
	 * 
	 * @param transDbmsVO
	 * @return String
	 * @throws Exception
	 */
	@Override
	public String transTargetStart(TransVO transVO) throws Exception {
		String result = "fail";
		String result_code = "";
	
		List<Map<String, Object>> transInfo = null;
		List<Map<String, Object>> mappInfo = null;
		
		Map<String, Object> connStartResult = new  HashMap<String, Object>();

		try {
			int db_svr_id = transVO.getDb_svr_id();
			int trans_exrt_trg_tb_id = transVO.getTrans_exrt_trg_tb_id();
			int trans_id = transVO.getTrans_id();
			
			AES256 dec = new AES256(AES256_KEY.ENC_KEY);
			
			//db 서버 조회
			DbServerVO schDbServerVO = new DbServerVO();
			schDbServerVO.setDb_svr_id(db_svr_id);
			DbServerVO dbServerVO = (DbServerVO) cmmnServerInfoDAO.selectServerInfo(schDbServerVO);
			
			//agent 조회
			String strIpAdr = dbServerVO.getIpadr();
			AgentInfoVO vo = new AgentInfoVO();
			vo.setIPADR(strIpAdr);
			AgentInfoVO agentInfo = (AgentInfoVO) cmmnServerInfoDAO.selectAgentInfo(vo);

			String IP = dbServerVO.getIpadr();
			int PORT = agentInfo.getSOCKET_PORT();

			dbServerVO.setSvr_spr_scm_pwd(dec.aesDecode(dbServerVO.getSvr_spr_scm_pwd()));
			dbServerVO.setUsr_id(transVO.getFrst_regr_id());
			
			//전송정보 조회
			transInfo = transDAO.selectTargetTransInfo(trans_id);
			System.out.println("전송정보 : "+transInfo.get(0));

			//매핑정보 조회
			mappInfo = transDAO.selectMappInfo(trans_exrt_trg_tb_id);
			System.out.println("매핑정보 : "+mappInfo.get(0));
			
			if (transInfo != null && mappInfo != null) {
				ClientInfoCmmn cic = new ClientInfoCmmn();
				connStartResult = cic.connectTargetStart(IP, PORT, dbServerVO, transInfo, mappInfo);
				
				if (connStartResult != null) {
					result_code = connStartResult.get("RESULT_CODE").toString();
					if ("0".equals(result_code)) {
						result = "success";
					} else {
						result = "fail";
					}
				}
			} else {
				result = "fail";
			}
		} catch (Exception e) {
			result = "fail";
			e.printStackTrace();
		}
		
		return result;
	}
	
	/**
	 * trans source 삭제
	 * 
	 * @param trans_id
	 * @throws Exception 
	 */
	@Override
	public void deleteTransSetting(int trans_id) throws Exception {
		transDAO.deleteTransSetting(trans_id);		
		
		transDAO.deleteTransTopicSetting(trans_id);
	}
	
	/**
	 * 매핑 정보 삭제
	 * 
	 * @param trans_exrt_trg_tb_id
	 * @throws Exception 
	 */
	@Override
	public void deleteTransExrttrgMapp(int trans_exrt_trg_tb_id) throws Exception {
		transDAO.deleteTransExrttrgMapp(trans_exrt_trg_tb_id);
	}
	
	/**
	 * trans 삭제
	 * 
	 * @param transVo
	 * @return String
	 * @throws Exception 
	 */
	@Override
	public String deleteTransTotSetting(TransVO transVo) throws Exception {
		String result = "S";
		
		try{
			JSONArray trans_ids = (JSONArray) new JSONParser().parse(transVo.getTrans_id_Rows());
			JSONArray trans_exrt_trg_tb_ids = (JSONArray) new JSONParser().parse(transVo.getTrans_exrt_trg_tb_id_Rows());

			if (trans_ids != null && trans_ids.size() > 0) {
				for(int i=0; i<trans_exrt_trg_tb_ids.size(); i++){
					int trans_id = Integer.parseInt(trans_ids.get(i).toString());
					String str_trans_exrt_trg_tb_ids = "";
					
					int trans_exrt_trg_tb_id = -1;
					
					if (trans_exrt_trg_tb_ids.get(i) != null) {
						str_trans_exrt_trg_tb_ids = trans_exrt_trg_tb_ids.get(i).toString();
						trans_exrt_trg_tb_id = Integer.parseInt(str_trans_exrt_trg_tb_ids);
					}

					// 데이터전송 삭제
					if ("del".equals(transVo.getTrans_active_gbn())) {
						transVo.setTrans_id(trans_id);
						
						//연결되어있는 타겟전송테이블 정리
						updateTranExrtTrgList(trans_id);

						transDAO.deleteTransSetting(trans_id);
						
						transDAO.deleteTransTopicSetting(trans_id);
					} else {
						transDAO.deleteTransTargetSetting(trans_id);
						
						//target topic 테이블 초기화
						transVo.setTar_trans_id(trans_id);
						transVo.setTrans_id(trans_id);
						
						//기존 topic 연결 초기화
						transDAO.updateTransTarTopicChogihwa(transVo);
					}

					if (trans_exrt_trg_tb_id != -1) {
						// 맵핑 테이블 삭제
						transDAO.deleteTransExrttrgMapp(trans_exrt_trg_tb_id);
					}
					
					//삭제 시 log파일 삭제
					transDAO.deleteTransConnectLog(transVo);
				}
			}
		}catch(Exception e){
			result = "F";
			e.printStackTrace();
		}

		return result;
	}
	
	/**
	 * trans 소스 전송관리 등록
	 * 
	 * @param connect_nm
	 * @return int
	 * @throws Exception 
	 */
	public String updateTranExrtTrgList(int trans_id) throws Exception {
		String result = "success";
		String tb_nm = "";
		try {
			TransVO searchTransVO = new TransVO();
			searchTransVO.setTrans_id(trans_id);
			
			List<TransVO> tblTableList = transDAO.selectTranExrtTrgList(searchTransVO); // 전송관리 테이블 조회
			List<TransVO> topicTableList = transDAO.selectTranIdTopicList(searchTransVO); // topic 테이블 조회

			if (tblTableList.size() > 0 && topicTableList.size() > 0) {
				for(int i=0; i<tblTableList.size(); i++){
					String[] exrt_trg_tb_nm_arr = tblTableList.get(i).getExrt_trg_tb_nm().split(",");
					
					for(int j=0; j<exrt_trg_tb_nm_arr.length; j++){
						for(int h=0; h<topicTableList.size(); h++){
							tb_nm = "";
							if (exrt_trg_tb_nm_arr[j].equals(topicTableList.get(h).getTopic_nm())) {
								tb_nm += "";
							} else {
								tb_nm += exrt_trg_tb_nm_arr[j];
								
								if (j != topicTableList.size() -1) {
									tb_nm += ",";
								}
							}
						}
					}

					TransVO insTransVO = new TransVO();
					insTransVO.setTrans_exrt_trg_tb_id(tblTableList.get(i).getTrans_exrt_trg_tb_id());
					insTransVO.setExrt_trg_tb_nm(tb_nm);
					
					transDAO.updateTranExrtTrgInfo(insTransVO);
				}
			}

			result = "success";
		} catch (Exception e) {
			result = "failed";
			e.printStackTrace();
		}
		
		return result;
	}
	
	/**
	 * trans connect 명 중복체크
	 * 
	 * @param connect_nm
	 * @return int
	 * @throws Exception 
	 */
	@Override
	public int connect_nm_Check(String connect_nm) throws Exception {
		return transDAO.connect_nm_Check(connect_nm);
	}
	
	/**
	 * trans target connect 명 중복체크
	 * 
	 * @param connect_nm
	 * @return int
	 * @throws Exception 
	 */
	@Override
	public int connect_target_nm_Check(String connect_nm) throws Exception {
		return transDAO.connect_target_nm_Check(connect_nm);
	}
	
	/**
	 * 포함대상 스키마,테이블 시퀀스 조회
	 * @param 
	 * @return int
	 * @throws Exception
	 */
	@Override
	public int selectTransExrttrgMappSeq() throws Exception {
		return transDAO.selectTransExrttrgMappSeq();
	}

	/**
	 * 포함대상 스키마,테이블 등록
	 * @param transMappVO
	 * @return 
	 * @throws Exception
	 */
	@Override
	public void insertTransExrttrgMapp(TransMappVO transMappVO) throws Exception {
		transDAO.insertTransExrttrgMapp(transMappVO);
	}

	/**
	 * 전송설정 등록
	 * @param TransVO
	 * @throws Exception
	 */
	@Override
	public void insertConnectInfo(TransVO transVO) throws Exception {
		transDAO.insertConnectInfo(transVO);		
	}

	/**
	 * 타겟시스템 전송설정 등록
	 * @param TransVO
	 * @throws Exception
	 */
	@Override
	public void insertTargetConnectInfo(TransVO transVO) throws Exception {
		transDAO.insertTargetConnectInfo(transVO);		
	}

	/**
	 * 포함대상 스키마,테이블 수정
	 * @param transMappVO
	 * @return 
	 * @throws Exception
	 */
	@Override
	public void updateTransExrttrgMapp(TransMappVO transMappVO) throws Exception {
		transDAO.updateTransExrttrgMapp(transMappVO);
	}
	
	/**
	 * 전송설정 정보 수정
	 * @param transVO
	 * @return vo
	 * @throws Exception
	 */
	@Override
	public void updateConnectInfo(TransVO transVO) throws Exception {
		transDAO.updateConnectInfo(transVO);	
	}
	
	/**
	 * target 전송설정 정보 수정
	 * @param transVO
	 * @return vo
	 * @throws Exception
	 */
	@Override
	public void updateTargetConnectInfo(TransVO transVO) throws Exception {
		transDAO.updateTargetConnectInfo(transVO);	
	}

	/**
	 * 스냅샷모드 목록 조회
	 * @param TransVO
	 * @return List<TransVO>
	 * @throws Exception
	 */
	@Override
	public List<TransVO> selectSnapshotModeList() throws Exception {
		return transDAO.selectSnapshotModeList();
	}

	/**
	 * 압축형식
	 * @param TransVO
	 * @return List<TransVO>
	 * @throws Exception
	 */
	@Override
	public List<TransVO> selectCompressionTypeList() throws Exception {
		return transDAO.selectCompressionTypeList();
	}

	/**
	 * source auto 커넥트 정보 조회
	 * @param trans_id
	 * @return List<Map<String, Object>>
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> selectTransInfoAuto(int db_svr_id) throws Exception {
		return transDAO.selectTransInfoAuto(db_svr_id);
	}

	/**
	 * target auto 커넥트 정보 조회
	 * @param trans_id
	 * @return List<Map<String, Object>>
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> selectTargetTransInfoAuto(int db_svr_id) throws Exception {
		return transDAO.selectTargetTransInfoAuto(db_svr_id);
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
		return transDAO.selectTransKafkaConList(transDbmsVO);
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
				transDAO.insertTransKafkaConnect(transDbmsVO);
				
				transDbmsVO.setAct_type("A");			//활성화
				transDbmsVO.setAct_exe_type("TC004001");//manual
				transDbmsVO.setExe_rslt_cd("TC001501");

				transDAO.insertTransKafkaConnectLog(transDbmsVO);
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
	public String trans_connect_nmCheck(String kc_nm) throws Exception {
		int resultCnt = 0;
		String resultStr = "true";

		try {
			resultCnt = transDAO.trans_connect_nmCheck(kc_nm);
			
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
					
					transDAO.deleteTransKafkaConnect(transDbmsPrmVO);

					transDAO.deleteTransKafkaConnectLog(transDbmsPrmVO);
				}
			}
		}catch(Exception e){
			e.printStackTrace();
		}
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
			transDAO.updateTransKafkaConnect(transDbmsVO);

			//kafka connect 이력 등록
			
		} catch (Exception e) {
			result = "F";
			e.printStackTrace();
		}
		
		return result;
	}
	
	/**
	 * 기본설정 등록 조회
	 * @param transVO, request, historyVO
	 * @return Map<String, Object>
	 */
	@Override
	public Map<String, Object> selectTransComSettingCngInfo(TransVO transVO) throws Exception {
		return transDAO.selectTransComSettingCngInfo(transVO);
	}
	
	/**
	 * 기본설정 등록
	 * 
	 * @param transVO
	 * @throws Exception 
	 */
	@Override
	public String updateTransCommonSetting(TransVO transVO) throws Exception {
		String result = "S";

		try{
/*			//데이터 있는지 확인
			recultChk = (Map<String, Object>) transDAO.selectTransComSettingCngInfo(transVO);

			if (recultChk == null) {
				result = "O";
			}
			*/
			
			String trans_gbn = transVO.getTrans_com_cng_gbn();
			
			if ("ins".equals(trans_gbn)) {
				transDAO.insertTransCommonSetting(transVO);
			} else {
				transDAO.updateTransCommonSetting(transVO);
			}
			
			result = "S";
		}catch(Exception e){
			result = "F";
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

					resultChk = (Map<String, Object>) transDAO.selectTransKafkaConIngChk(transDbmsPrmVO);
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
			transDAO.updateTransKafkaConnectFaild(transDbmsVO);
		} catch (Exception e) {
			result = "F";
			e.printStackTrace();
		}
		
		return result;
	}

	/**
	 * 기본설정 리스트 조회
	 * 
	 * @param transVO
	 * @return List<Map<String, Object>>
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> selectTransComConPopList(TransVO transVO) throws Exception {
		return transDAO.selectTransComConPopList(transVO);
	}

	/**
	 * 기본설정 삭제
	 * 
	 * @param transVO
	 * @throws Exception
	 */
	@Override
	public void deleteTransComConSet(TransVO transVO) throws Exception {
		try{
			JSONArray trans_com_ids = (JSONArray) new JSONParser().parse(transVO.getTrans_com_id_Rows());

			if (trans_com_ids != null && trans_com_ids.size() > 0) {
				for(int i=0; i<trans_com_ids.size(); i++){
					TransVO transPrmVO = new TransVO();	
					transPrmVO.setTrans_com_id(trans_com_ids.get(i).toString());
					
					transDAO.deleteTransComConSet(transPrmVO);
				}
			}
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	
	/**
	 * target 전송설정 total 등록
	 * 
	 * @param transMappVO, transVO
	 * @throws Exception
	 */
	@Override
	public String insertTargetConnectInfoTot(TransMappVO transMappVO, TransVO transVO) throws Exception{
		String result = "success";
		int tar_trans_id  =0;
		try{
			//전송대상 테이블 등록
			transDAO.insertTransExrttrgMapp(transMappVO);
			
			//target trans_id
			tar_trans_id = transDAO.selectTargetConnectSeq();
			transVO.setTrans_id(tar_trans_id);

			if (transMappVO != null) {
				String[] exrt_trg_tb_nm_array = null; //테이블 목록 배열
				String exrt_trg_tb_nm = transMappVO.getExrt_trg_tb_nm();
				exrt_trg_tb_nm_array = exrt_trg_tb_nm.split(",");
				
				if (exrt_trg_tb_nm_array != null) {
					transVO.setTar_trans_exrt_trg_tb_id(transVO.getTrans_exrt_trg_tb_id());
					transVO.setTar_trans_id(transVO.getTrans_id());
					
					for(int i=0;i < exrt_trg_tb_nm_array.length;i++) {
						//테이블별
						String topic_nm = exrt_trg_tb_nm_array[i];
						transVO.setTopic_nm(topic_nm);

						//TRANS target topic update
						transDAO.updateTransTarTopic(transVO);
					}						
				}
			}
			
			transDAO.insertTargetConnectInfo(transVO);

			result = "success";
		} catch (Exception e) {
			result = "fail";
			e.printStackTrace();
		}

		return result;
	}
	
	/**
	 * target 전송설정 total 수정
	 * 
	 * @param transMappVO, transVO
	 * @throws Exception
	 */
	@Override
	public String updateTargetConnectInfoTot(TransMappVO transMappVO, TransVO transVO) throws Exception{
		String result = "success";
		try{
			//전송대상 테이블 수정
			transDAO.updateTransExrttrgMapp(transMappVO);

			if (transMappVO != null) {
				String[] exrt_trg_tb_nm_array = null; //테이블 목록 배열
				String exrt_trg_tb_nm = transMappVO.getExrt_trg_tb_nm();
				exrt_trg_tb_nm_array = exrt_trg_tb_nm.split(",");
				
				if (exrt_trg_tb_nm_array != null) {
					transVO.setTar_trans_exrt_trg_tb_id(transVO.getTrans_exrt_trg_tb_id());
					transVO.setTar_trans_id(transVO.getTrans_id());
					
					//기존 topic 연결 초기화
					transDAO.updateTransTarTopicChogihwa(transVO);
					
					for(int i=0;i < exrt_trg_tb_nm_array.length;i++) {
						//테이블별
						String topic_nm = exrt_trg_tb_nm_array[i];
						transVO.setTopic_nm(topic_nm);
						
						//TRANS target topic update
						transDAO.updateTransTarTopic(transVO);
					}						
				}
			}
			
			transDAO.updateTargetConnectInfo(transVO);

			result = "success";
		} catch (Exception e) {
			result = "fail";
			e.printStackTrace();
		}

		return result;
	}

	
	/**
	 * trans topic 리스트 조회
	 * 
	 * @param transVO
	 * @return List<TransVO>
	 * @throws Exception
	 */
	@Override
	public List<TransVO> selectTransTopicList(TransVO transVO) throws Exception {
		System.out.println("===asdasdasd==");
		return transDAO.selectTransTopicList(transVO);
	}
}
