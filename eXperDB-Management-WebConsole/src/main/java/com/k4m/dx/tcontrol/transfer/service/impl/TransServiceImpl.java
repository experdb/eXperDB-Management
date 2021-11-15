package com.k4m.dx.tcontrol.transfer.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.stereotype.Service;

import com.k4m.dx.tcontrol.admin.dbserverManager.service.DbServerVO;
import com.k4m.dx.tcontrol.cmmn.AES256;
import com.k4m.dx.tcontrol.cmmn.AES256_KEY;
import com.k4m.dx.tcontrol.cmmn.client.ClientInfoCmmn;
import com.k4m.dx.tcontrol.common.service.AgentInfoVO;
import com.k4m.dx.tcontrol.common.service.impl.CmmnServerInfoDAO;
import com.k4m.dx.tcontrol.login.service.LoginVO;
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

			if (connStartResult != null) {
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
				
				if("TC004401".equals(transInfo.get(0).get("TOPIC_TYPE"))){
					connStartResult = cic.connectStart(IP, PORT, dbServerVO, transInfo, mappInfo);
				} else {
					connStartResult = cic.createConfluentProperties(IP, PORT, dbServerVO, transInfo, mappInfo);
				}
//				connStartResult = cic.connectTargetStart(IP, PORT, dbServerVO, transInfo, mappInfo);
				
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
	public int connect_nm_Check(String connect_nm, String connect_gbn) throws Exception {
		int resultSet = 0;
		
		if ("source".equals(connect_gbn)) {
			resultSet = transDAO.connect_nm_Check(connect_nm);
		} else {
			resultSet = transDAO.connect_target_nm_Check(connect_nm);
		}
		
		return resultSet;
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
	
	/**
	 * trans heatbeat 체크
	 * 
	 * @param transVO
	 * @return Map<String, Object>
	 * @throws Exception
	 */
	@Override
	public Map<String, Object> selectTransComCoIngChk(TransVO transVO) throws Exception {
		return transDAO.selectTransComCoIngChk(transVO);
	}	
	
	/**
	 * 다중 kafka-Connection 시작
	 * 
	 * @param request
	 * @return String
	 * @throws Exception
	 */
	@Override
	public String transTotExecute(HttpServletRequest request, LoginVO loginVo) throws Exception {

		int db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));
		String execute_gbn = request.getParameter("execute_gbn").toString();
		String trans_active_gbn = request.getParameter("trans_active_gbn").toString();

		String trans_exrt_trg_tb_id_Rows = "";
		String kc_ip_Rows = "";
		String kc_port_Rows = "";
		String connect_nm_Rows = "";

		String trans_id_Rows = "";
		JSONArray trans_ids = null;

		JSONArray trans_exrt_trg_tb_ids = null;
		JSONArray kc_ips = null;
		JSONArray kc_ports = null;
		JSONArray connect_nms = null;
		
		String result = "fail";
		
		String result_code = "";
		int sucCnt = 0;
		int sucCnt_no = 0;

		if (request.getParameter("trans_id_List") != null) {
			trans_id_Rows = request.getParameter("trans_id_List").toString().replaceAll("&quot;", "\"");
			trans_ids = (JSONArray) new JSONParser().parse(trans_id_Rows);
		}

		if (request.getParameter("trans_exrt_trg_tb_id_List") != null) {
			trans_exrt_trg_tb_id_Rows = request.getParameter("trans_exrt_trg_tb_id_List").toString().replaceAll("&quot;", "\"");
			trans_exrt_trg_tb_ids = (JSONArray) new JSONParser().parse(trans_exrt_trg_tb_id_Rows);
		}

		if (request.getParameter("kc_ip_List") != null) {
			kc_ip_Rows = request.getParameter("kc_ip_List").toString().replaceAll("&quot;", "\"");
			kc_ips = (JSONArray) new JSONParser().parse(kc_ip_Rows);
		}

		if (request.getParameter("kc_port_List") != null) {
			kc_port_Rows = request.getParameter("kc_port_List").toString().replaceAll("&quot;", "\"");
			kc_ports = (JSONArray) new JSONParser().parse(kc_port_Rows);
		}

		if (request.getParameter("connect_nm_List") != null) {
			connect_nm_Rows = request.getParameter("connect_nm_List").toString().replaceAll("&quot;", "\"");
			connect_nms = (JSONArray) new JSONParser().parse(connect_nm_Rows);
		}

		Map<String, Object> connStartResult = new  HashMap<String, Object>();

		try {
			if (trans_exrt_trg_tb_ids != null && trans_exrt_trg_tb_ids.size() > 0) {
				for(int i=0; i<trans_exrt_trg_tb_ids.size(); i++){
					String resultSs = "fail";
					TransVO transVOPrm = new TransVO();

					if ("active".equals(execute_gbn)) {
						int trans_exrt_trg_tb_id = Integer.parseInt(trans_exrt_trg_tb_ids.get(i).toString());
						int trans_id = Integer.parseInt(trans_ids.get(i).toString());

						transVOPrm.setDb_svr_id(db_svr_id);
						transVOPrm.setTrans_exrt_trg_tb_id(trans_exrt_trg_tb_id);
						transVOPrm.setTrans_id(trans_id);
						transVOPrm.setFrst_regr_id((String)loginVo.getUsr_id());
						transVOPrm.setLst_mdfr_id((String)loginVo.getUsr_id());

						resultSs = transStart(transVOPrm);
					} else if ("target_active".equals(execute_gbn)) {
						int trans_exrt_trg_tb_id = Integer.parseInt(trans_exrt_trg_tb_ids.get(i).toString());
						int trans_id = Integer.parseInt(trans_ids.get(i).toString());

						transVOPrm.setDb_svr_id(db_svr_id);
						transVOPrm.setTrans_exrt_trg_tb_id(trans_exrt_trg_tb_id);
						transVOPrm.setTrans_id(trans_id);
						transVOPrm.setFrst_regr_id((String)loginVo.getUsr_id());
						transVOPrm.setLst_mdfr_id((String)loginVo.getUsr_id());
							
						resultSs = transTargetStart(transVOPrm);
					} else {
						String kc_ip = kc_ips.get(i).toString();
						String kc_port = kc_ports.get(i).toString();
						String connect_nm = connect_nms.get(i).toString();
						String trans_id_str = trans_ids.get(i).toString();

						transVOPrm.setKc_ip(kc_ip);
						transVOPrm.setKc_port(Integer.parseInt(kc_port));
						transVOPrm.setConnect_nm(connect_nm);
						transVOPrm.setTrans_id(Integer.parseInt(trans_id_str));
						transVOPrm.setDb_svr_id(db_svr_id);
						transVOPrm.setTrans_active_gbn(trans_active_gbn);
						transVOPrm.setFrst_regr_id((String)loginVo.getUsr_id());

						resultSs = transStop(transVOPrm);
					}

					if (resultSs != null && "success".equals(resultSs)) {
					//	result_code = connStartResult.get("RESULT_CODE").toString();
					//	if ("0".equals(result_code)) {
							//result = "success";
							sucCnt = sucCnt + 1;
					//	}
					} else if (resultSs != null && "no_depth".equals(resultSs)) {
						sucCnt = sucCnt + 1;
						sucCnt_no = sucCnt_no + 1;
					}
				}	

				if (sucCnt == trans_exrt_trg_tb_ids.size() ) {
					if (sucCnt_no <= 0) {
						result = "success";
					} else {
						result = "no_depth";
					}
					
				} else {
					result = "fail";
				}
			}
		} catch (Exception e) {
			result = "fail";
			e.printStackTrace();	
			return result;
		}
		return result;
	}
	
	/**
	 * 전송대상테이블정보 setting
	 * 
	 * @param mappInfo, trans_active_gbn
	 * @return String
	 * @throws Exception
	 */
	@Override
	public JSONObject selectTransMatchMappInfo(List<Map<String, Object>> mappInfo, String trans_active_gbn, String multi_gbn) throws Exception {

		JSONObject tableResult = new JSONObject();
		String[] tables = null;

		JSONArray tableArray = new JSONArray();

		try {
			if (mappInfo != null) {
				tables = mappInfo.get(0).get("exrt_trg_tb_nm").toString().split(",");
			}

			if(mappInfo.get(0).get("exrt_trg_tb_nm") != null) {
				if (!"".equals(mappInfo.get(0).get("exrt_trg_tb_nm").toString())) {
					for (int i = 0; i < tables.length; i++) {
						JSONObject jsonObj = new JSONObject();
						String[] datas = null;
	
						if ("source".equals(trans_active_gbn)) {
							datas = tables[i].toString().split("\\.");
							
							for(int j = 0; j < 1; j++){
								jsonObj.put("schema_name", datas[0]);
								jsonObj.put("table_name", datas[1]);
								tableArray.add(jsonObj);
							}
						} else {
							if (!"tar_single".equals(multi_gbn)) {
								jsonObj.put("idx", i + 1);
							}

							jsonObj.put("topic_name", tables[i]);
							System.out.println(mappInfo.get(0).toString());
							if(!"".equals(mappInfo.get(0).get("regi_nm").toString()) || mappInfo.get(0).get("regi_nm").toString() != null){
								jsonObj.put("regi_nm", mappInfo.get(0).get("regi_nm"));
							}
							tableArray.add(jsonObj);
						}
					}
					tableResult.put("data", tableArray);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
			
		return tableResult;
	}

	/**
	 * 전송상세 전송설정정보 setting
	 * 
	 * @param mappInfo, trans_active_gbn
	 * @return String
	 * @throws Exception
	 */
	@Override
	public Map<String, Object> selectTransMatchInfo(List<Map<String, Object>> transInfo, String trans_active_gbn) throws Exception {
		Map<String, Object> transInfoMap = new HashMap<String, Object>();

		if (transInfo != null) {
			transInfoMap.put("kc_nm", transInfo.get(0).get("kc_nm"));				//use
			transInfoMap.put("kc_id", transInfo.get(0).get("kc_id"));				//use
			transInfoMap.put("kc_ip", transInfo.get(0).get("kc_ip"));				//use
			transInfoMap.put("kc_port", transInfo.get(0).get("kc_port"));			//use
			transInfoMap.put("connect_nm", transInfo.get(0).get("connect_nm"));		//use
			transInfoMap.put("trans_id", transInfo.get(0).get("trans_id"));			//use
			transInfoMap.put("exe_status", transInfo.get(0).get("exe_status"));		//use

			transInfoMap.put("regi_id", transInfo.get(0).get("regi_id"));			//use
			transInfoMap.put("regi_nm", transInfo.get(0).get("regi_nm"));			//use
			transInfoMap.put("regi_ip", transInfo.get(0).get("regi_ip"));			//use
			transInfoMap.put("regi_port", transInfo.get(0).get("regi_port"));		//use

			if ("source".equals(trans_active_gbn)) {
				transInfoMap.put("db_id", transInfo.get(0).get("db_id"));			//use
				transInfoMap.put("db_nm", transInfo.get(0).get("db_nm"));			//use
				transInfoMap.put("snapshot_mode", transInfo.get(0).get("snapshot_mode"));	//use
				transInfoMap.put("snapshot_nm", transInfo.get(0).get("snapshot_nm"));		//use
				transInfoMap.put("compression_type", transInfo.get(0).get("compression_type"));	//use
				transInfoMap.put("compression_nm", transInfo.get(0).get("compression_nm"));		//use
				transInfoMap.put("meta_data", transInfo.get(0).get("meta_data"));				//use

				transInfoMap.put("trans_com_id", transInfo.get(0).get("trans_com_id"));							//use
				transInfoMap.put("trans_com_cng_nm", transInfo.get(0).get("trans_com_cng_nm"));					//use
				transInfoMap.put("plugin_name", transInfo.get(0).get("plugin_name"));							//use
				transInfoMap.put("heartbeat_interval_ms", transInfo.get(0).get("heartbeat_interval_ms"));		//use
				transInfoMap.put("max_batch_size", transInfo.get(0).get("max_batch_size"));						//use
				transInfoMap.put("max_queue_size", transInfo.get(0).get("max_queue_size"));						//use
				transInfoMap.put("offset_flush_interval_ms", transInfo.get(0).get("offset_flush_interval_ms"));	//use
				transInfoMap.put("offset_flush_timeout_ms", transInfo.get(0).get("offset_flush_timeout_ms"));	//use

				transInfoMap.put("connect_type", transInfo.get(0).get("connect_type"));						//use
			} else {
				transInfoMap.put("trans_sys_nm", transInfo.get(0).get("trans_sys_nm"));			//use
				transInfoMap.put("trans_sys_id", transInfo.get(0).get("trans_sys_id"));			//use
				transInfoMap.put("ipadr", transInfo.get(0).get("ipadr"));						//use
				transInfoMap.put("dtb_nm", transInfo.get(0).get("dtb_nm"));						//use
				transInfoMap.put("spr_usr_id", transInfo.get(0).get("spr_usr_id"));				//use
				transInfoMap.put("portno", transInfo.get(0).get("portno"));						//use
				transInfoMap.put("pwd", transInfo.get(0).get("pwd"));							//use
				transInfoMap.put("scm_nm", transInfo.get(0).get("scm_nm"));						//use
				transInfoMap.put("dbms_dscd_nm", transInfo.get(0).get("dbms_dscd_nm"));			//use

				transInfoMap.put("topic_type", transInfo.get(0).get("topic_type"));				//use
			}
		} else {
			transInfoMap.put("kc_nm", "");				//use
			transInfoMap.put("kc_id", "");				//use
			transInfoMap.put("kc_ip", "");											//use
			transInfoMap.put("kc_port", "");										//use
			transInfoMap.put("connect_nm", "");										//use
			transInfoMap.put("trans_id", "");										//use
			transInfoMap.put("exe_status", "");										//use

			transInfoMap.put("regi_id", "");										//use
			transInfoMap.put("regi_nm", "");										//use
			transInfoMap.put("regi_ip", "");										//use
			transInfoMap.put("regi_port", "");										//use

			if ("source".equals(trans_active_gbn)) {
				transInfoMap.put("db_id", "");										//use
				transInfoMap.put("db_nm", "");										//use
				transInfoMap.put("snapshot_mode", "");								//use
				transInfoMap.put("snapshot_nm", "");								//use
				transInfoMap.put("compression_type", "");							//use
				transInfoMap.put("compression_nm", "");								//use
				transInfoMap.put("meta_data", "");									//use

				transInfoMap.put("trans_com_id", "");								//use
				transInfoMap.put("trans_com_cng_nm", "");							//use
				transInfoMap.put("plugin_name", "");								//use
				transInfoMap.put("heartbeat_interval_ms", "");						//use
				transInfoMap.put("max_batch_size", "");								//use
				transInfoMap.put("max_queue_size", "");								//use
				transInfoMap.put("offset_flush_interval_ms", "");					//use
				transInfoMap.put("offset_flush_timeout_ms", "");					//use

				transInfoMap.put("connect_type", "");								//use
			} else {
				transInfoMap.put("trans_sys_nm", "");								//use
				transInfoMap.put("trans_sys_id", "");								//use
				transInfoMap.put("ipadr", "");										//use
				transInfoMap.put("dtb_nm", "");										//use
				transInfoMap.put("spr_usr_id", "");									//use
				transInfoMap.put("portno", "");										//use
				transInfoMap.put("pwd", "");										//use
				transInfoMap.put("scm_nm", "");										//use
				transInfoMap.put("dbms_dscd_nm", "");								//use
				
				transInfoMap.put("topic_type", "");									//use
			}
		}
		
		System.out.println("kc_nm====" + transInfo.get(0).get("kc_nm"));
		System.out.println("kc_id====" + transInfo.get(0).get("kc_id"));
		System.out.println("kc_ip====" + transInfo.get(0).get("kc_ip"));
		System.out.println("kc_port====" + transInfo.get(0).get("kc_port"));
		System.out.println("connect_nm====" + transInfo.get(0).get("connect_nm"));
		System.out.println("trans_id====" + transInfo.get(0).get("trans_id"));
		System.out.println("exe_status====" + transInfo.get(0).get("exe_status"));
		System.out.println("regi_id====" + transInfo.get(0).get("regi_id"));
		System.out.println("regi_nm====" + transInfo.get(0).get("regi_nm"));
		System.out.println("regi_ip====" + transInfo.get(0).get("regi_ip"));
		System.out.println("regi_port====" + transInfo.get(0).get("regi_port"));
		System.out.println("db_id====" + transInfo.get(0).get("db_id"));
		System.out.println("db_nm====" + transInfo.get(0).get("db_nm"));
		System.out.println("snapshot_mode====" + transInfo.get(0).get("snapshot_mode"));
		System.out.println("snapshot_nm====" + transInfo.get(0).get("snapshot_nm"));
		System.out.println("compression_type====" + transInfo.get(0).get("compression_type"));
		System.out.println("compression_nm====" + transInfo.get(0).get("compression_nm"));
		System.out.println("meta_data====" + transInfo.get(0).get("meta_data"));
		System.out.println("trans_com_id====" + transInfo.get(0).get("trans_com_id"));
		System.out.println("trans_com_cng_nm====" + transInfo.get(0).get("trans_com_cng_nm"));
		System.out.println("plugin_name====" + transInfo.get(0).get("plugin_name"));
		System.out.println("meta_data====" + transInfo.get(0).get("meta_data"));
		System.out.println("heartbeat_interval_ms====" + transInfo.get(0).get("heartbeat_interval_ms"));
		System.out.println("max_batch_size====" + transInfo.get(0).get("max_batch_size"));
		System.out.println("max_queue_size====" + transInfo.get(0).get("max_queue_size"));
		System.out.println("offset_flush_interval_ms====" + transInfo.get(0).get("offset_flush_interval_ms"));
		System.out.println("offset_flush_timeout_ms====" + transInfo.get(0).get("offset_flush_timeout_ms"));
		System.out.println("connect_type====" + transInfo.get(0).get("connect_type"));
		
		System.out.println("transInfoMap====" + transInfoMap);

		return transInfoMap;
	}
}
