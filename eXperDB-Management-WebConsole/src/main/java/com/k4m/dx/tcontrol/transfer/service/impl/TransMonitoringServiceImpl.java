package com.k4m.dx.tcontrol.transfer.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.json.simple.JSONObject;
import org.springframework.stereotype.Service;

import com.experdb.management.proxy.cmmn.ProxyClientProtocolID;
import com.experdb.management.proxy.cmmn.ProxyClientTranCodeType;
import com.ibm.db2.jcc.am.j;
import com.k4m.dx.tcontrol.admin.dbserverManager.service.DbServerVO;
import com.k4m.dx.tcontrol.cmmn.AES256;
import com.k4m.dx.tcontrol.cmmn.AES256_KEY;
import com.k4m.dx.tcontrol.cmmn.client.ClientInfoCmmn;
import com.k4m.dx.tcontrol.cmmn.client.ClientProtocolID;
import com.k4m.dx.tcontrol.cmmn.client.ClientTranCodeType;
import com.k4m.dx.tcontrol.common.service.AgentInfoVO;
import com.k4m.dx.tcontrol.common.service.impl.CmmnServerInfoDAO;
import com.k4m.dx.tcontrol.transfer.service.TransMonitoringService;
import com.k4m.dx.tcontrol.transfer.service.TransVO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("TransMonitoringServiceImpl")
public class TransMonitoringServiceImpl  extends EgovAbstractServiceImpl implements TransMonitoringService{

	@Resource(name = "TransMonitoringDAO")
	private TransMonitoringDAO transMonitoringDAO;
	
	@Resource(name = "cmmnServerInfoDAO")
	private CmmnServerInfoDAO cmmnServerInfoDAO;
	
	/**
	 * kafka Process CPU 조회
	 * 
	 * @return List<Map<String, Object>>
	 */
	@Override
	public List<Map<String, Object>> selectProcessCpuList() {
		return transMonitoringDAO.selectProcessCpuList();
	}
	
	/**
	 * kafka Memory 조회
	 * 
	 * @return List<Map<String, Object>>
	 */
	@Override
	public List<Map<String, Object>> selectMemoryList() {
		return transMonitoringDAO.selectMemoryList();
	}
	
	/**
	 * 소스 Connector 목록 조회
	 * 
	 * @return List<Map<String, Object>>
	 */
	@Override
	public List<Map<String, Object>> selectSrcConnectorList() {
		return transMonitoringDAO.selectSrcConnectorList();
	}

	/**
	 * 소스 Connector 연결 테이블 조회
	 * 
	 * @param trans_id
	 * @return Map<String, Object>
	 */
	@Override
	public Map<String, Object> selectSourceConnectorTableList(int trans_id) {
		return transMonitoringDAO.selectSourceConnectorTableList(trans_id);
	}

	/**
	 * 소스 Connect 정보
	 * 
	 * @param trans_id
	 * @return List<Map<String, Object>>
	 */
	@Override
	public List<Map<String, Object>> selectSourceConnectInfo(int trans_id) {
		return transMonitoringDAO.selectSourceConnectInfo(trans_id);
	}

	/**
	 * 소스 Connector snapshot chart
	 * 
	 * @param trans_id
	 * @return List<Map<String, Object>>
	 */
	@Override
	public List<Map<String, Object>> selectSourceSnapshotChart(int trans_id) {
		return transMonitoringDAO.selectSourceSnapshotChart(trans_id);
	}

	/**
	 * 소스 Connector snapshot 정보 테이블
	 * 
	 * @param trans_id
	 * @return List<Map<String, Object>>
	 */
	@Override
	public List<Map<String, Object>> selectSourceSnapshotInfo(int trans_id) {
		return transMonitoringDAO.selectSourceSnapshotInfo(trans_id);
	}
	
	/**
	 * 소스 Connector streaming chart 
	 * 
	 * @param trans_id
	 * @return List<Map<String, Object>> 
	 */
	@Override
	public List<Map<String, Object>> selectStreamingChart(int trans_id) {
		return transMonitoringDAO.selectStreamingChart(trans_id);
	}
	
	/**
	 * 소스 Connector streaming 정보 조회
	 * 
	 * @param trans_id
	 * @return List<Map<String, Object>>
	 */
	@Override
	public List<Map<String, Object>> selectStreamingInfo(int trans_id) {
		return transMonitoringDAO.selectStreamingInfo(trans_id);
	}
	
	/**
	 * 소스 Connect 실시간 chart1
	 * 
	 * @param trans_id
	 * @return List<Map<String, Object>>
	 */
	@Override
	public List<Map<String, Object>> selectSourceChart_1(int trans_id) {
		return transMonitoringDAO.selectSourceChart_1(trans_id);
	}

	/**
	 * 소스 Connect 실시간 chart2
	 * 
	 * @param trans_id
	 * @return List<Map<String, Object>>
	 */
	@Override
	public List<Map<String, Object>> selectSourceChart_2(int trans_id) {
		return transMonitoringDAO.selectSourceChart_2(trans_id);
	}
	
	/**
	 * 소스 connect 실시간 정보
	 * 
	 * @param trans_id
	 * @return List<Map<String, Object>>
	 */
	@Override
	public List<Map<String, Object>> selectSourceInfo(int trans_id) {
		return transMonitoringDAO.selectSourceInfo(trans_id);
	}
	
	/**
	 * 소스 Connect error chart
	 * 
	 * @param trans_id
	 * @return List<Map<String, Object>>
	 */
	@Override
	public List<Map<String, Object>> selectSourceErrorChart(int trans_id) {
		return transMonitoringDAO.selectSourceErrorChart(trans_id);
	}

	/**
	 * 소스 Connect error 정보
	 * 
	 * @param trans_id
	 * @return List<Map<String, Object>>
	 */
	@Override
	public List<Map<String, Object>> selectSourceErrorInfo(int trans_id) {
		return transMonitoringDAO.selectSourceErrorInfo(trans_id);
	}

	/**
	 * 타겟 Connector 목록 조회
	 * 
	 * @param trans_id
	 * @return List<Map<String, Object>>
	 */
	@Override
	public List<Map<String, Object>> selectTargetConnectList(int trans_id) {
		return transMonitoringDAO.selectTargetConnectList(trans_id);
	}

	/**
	 * 타겟 DBMS 정보 조회
	 * 
	 * @param trans_id
	 * @return List<Map<String, Object>>
	 */
	@Override
	public List<Map<String, Object>> selectTargetDBMSInfo(int trans_id) {
		return transMonitoringDAO.selectTargetDBMSInfo(trans_id);
	}

	/**
	 * 타겟 전송대상 테이블 목록 조회
	 * 
	 * @param trans_id
	 * @return List<Map<String, Object>>
	 */
	@Override
	public Map<String, Object> selectTargetTopicList(int trans_id) {
		return transMonitoringDAO.selectTargetTopicList(trans_id);
	}

	/**
	 * 타겟 record sink chart
	 * 
	 * @param trans_id
	 * @return List<Map<String, Object>>
	 */
	@Override
	public List<Map<String, Object>> selectTargetSinkRecordChart(int trans_id) {
		return transMonitoringDAO.selectTargetSinkRecordChart(trans_id);
	}
	
	/**
	 * 타겟 complete sink chart
	 * 
	 * @param trans_id
	 * @return List<Map<String, Object>>
	 */
	@Override
	public List<Map<String, Object>> selectTargetSinkCompleteChart(int trans_id) {
		return transMonitoringDAO.selectTargetSinkCompleteChart(trans_id);
	}
	
	/**
	 * 타겟 sink 정보 조회
	 * 
	 * @param trans_id
	 * @return List<Map<String, Object>>
	 */
	@Override
	public List<Map<String, Object>> selectTargetSinkInfo(int trans_id) {
		return transMonitoringDAO.selectTargetSinkInfo(trans_id);
	}
	
	/**
	 * 타겟 error chart
	 * 
	 * @param trans_id
	 * @return List<Map<String, Object>>
	 */
	@Override
	public List<Map<String, Object>> selectTargetErrorChart(int trans_id) {
		return transMonitoringDAO.selectTargetErrorChart(trans_id);
	}
	
	/**
	 * 타겟 error 정보 조회
	 * 
	 * @param trans_id
	 * @return List<Map<String, Object>>
	 */
	@Override
	public List<Map<String, Object>> selectTargetErrorInfo(int trans_id) {
		return transMonitoringDAO.selectTargetErrorInfo(trans_id);
	}
	
	/**
	 * kafka Connect 전체 에러 조회
	 * 
	 * @return List<Map<String, Object>>
	 */
	@Override
	public List<Map<String, Object>> selectAllErrorList() {
		return transMonitoringDAO.selectAllErrorList();
	}
	
	/**
	 * kafka Connect 정보조회
	 * 
	 * @return List<Map<String, Object>>
	 */
	public Map<String, Object> selectKafkaConnectInfo(int trans_id) {
		return transMonitoringDAO.selectKafkaConnectInfo(trans_id);
	}

	/**
	 * trans log 파일 가져오기
	 * 
	 * @param transVO, param
	 * @return Map<String, Object>
	 */
	@Override
	public Map<String, Object> getLogFile(TransVO transVO, Map<String, Object> param) {
		Map<String, Object> logResult = new HashMap<String, Object>();

		try {
			int db_svr_id = transVO.getDb_svr_id();
			int trans_id = transVO.getTrans_id();
			System.out.println("trans_id : " + trans_id);
			AES256 dec = new AES256(AES256_KEY.ENC_KEY);
			
			// kafka 정보 조회
			Map<String, Object> kafkaInfo = transMonitoringDAO.selectKafkaConnectInfo(trans_id);
			
			//db 서버 조회
			DbServerVO schDbServerVO = new DbServerVO();
			schDbServerVO.setDb_svr_id(db_svr_id);
			DbServerVO dbServerVO = (DbServerVO) cmmnServerInfoDAO.selectServerInfo(schDbServerVO);
			
			//agent 조회
			String strIpAdr = dbServerVO.getIpadr();
			AgentInfoVO vo = new AgentInfoVO();
			vo.setIPADR(strIpAdr);
			AgentInfoVO agentInfo = (AgentInfoVO) cmmnServerInfoDAO.selectAgentInfo(vo);

			String IP = String.valueOf(kafkaInfo.get("kc_ip"));
//			int PORT = Integer.parseInt(String.valueOf(kafkaInfo.get("kc_port")));
			int PORT = agentInfo.getSOCKET_PORT();
			dbServerVO.setSvr_spr_scm_pwd(dec.aesDecode(dbServerVO.getSvr_spr_scm_pwd_old()));
			dbServerVO.setUsr_id(transVO.getFrst_regr_id());
			
			JSONObject jObj = new JSONObject();
			jObj.put(ClientProtocolID.DX_EX_CODE, ClientTranCodeType.DxT043);
			jObj.put(ClientProtocolID.SEEK, param.get("seek"));
			jObj.put(ClientProtocolID.DW_LEN, param.get("dwLen"));
			jObj.put(ClientProtocolID.READLINE, param.get("readLine"));
			jObj.put(ClientProtocolID.SYS_TYPE, param.get("type"));
			ClientInfoCmmn cic = new ClientInfoCmmn();

			logResult = cic.getLogFile(IP, PORT, dbServerVO, jObj);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return logResult;
	}

	/**
	 * trans kafka connect 재시작
	 * 
	 * @param transVO, param
	 * @return JSONObject
	 */
	@Override
	public Map<String, Object> transKafkaConnectRestart(TransVO transVO, Map<String, Object> param) {
		JSONObject jObj = new JSONObject();
		Map<String, Object> resultObj = new HashMap<String, Object>();
		
		try {
			int db_svr_id = transVO.getDb_svr_id();
			int trans_id = transVO.getTrans_id();
			AES256 dec = new AES256(AES256_KEY.ENC_KEY);
			Map<String, Object> kafkaInfo = transMonitoringDAO.selectKafkaConnectInfo(trans_id);

			//db 서버 조회
			DbServerVO schDbServerVO = new DbServerVO();
			schDbServerVO.setDb_svr_id(db_svr_id);
			DbServerVO dbServerVO = (DbServerVO) cmmnServerInfoDAO.selectServerInfo(schDbServerVO);
			
			//agent 조회
			String strIpAdr = dbServerVO.getIpadr();
			AgentInfoVO vo = new AgentInfoVO();
			vo.setIPADR(strIpAdr);
			AgentInfoVO agentInfo = (AgentInfoVO) cmmnServerInfoDAO.selectAgentInfo(vo);

//			String IP = dbServerVO.getIpadr();
			String IP = String.valueOf(kafkaInfo.get("kc_ip"));
			int PORT = agentInfo.getSOCKET_PORT();
			
			dbServerVO.setSvr_spr_scm_pwd(dec.aesDecode(dbServerVO.getSvr_spr_scm_pwd_old()));
			dbServerVO.setUsr_id(transVO.getFrst_regr_id());
			System.out.println(dbServerVO.toString());
			jObj.put(ClientProtocolID.DX_EX_CODE, ClientTranCodeType.DxT044);
			jObj.put(ClientProtocolID.USER_ID, param.get("lst_mdfr_id"));
			jObj.put(ClientProtocolID.KC_IP, IP);
			jObj.put(ClientProtocolID.KC_PORT,kafkaInfo.get("kc_port"));
			jObj.put("kc_id", kafkaInfo.get("kc_id"));
			System.out.println(jObj.toJSONString());
			ClientInfoCmmn cic = new ClientInfoCmmn();
			resultObj = cic.kafkaConnectRestart(IP, PORT, dbServerVO, jObj);
			System.out.println("resultObj : " + resultObj.toString());
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return resultObj;
	}

	/**
	 * trans kafka 기동 정지 이력 조회
	 * 
	 * @param trans_id
	 * @return List<Map<String, Object>>
	 */
	@Override
	public List<Map<String, Object>> selectKafkaActCngList(int trans_id) {
		Map<String, Object> kafkaInfo = transMonitoringDAO.selectKafkaConnectInfo(trans_id);
		String strKcId = String.valueOf(kafkaInfo.get("kc_id"));
		int kc_id = Integer.parseInt(strKcId);
		return transMonitoringDAO.selectKafkaActCngList(kc_id);
	}
	
	/**
	 * 소스 Connector 연결 테이블 조회
	 * 
	 * @param trans_id
	 * @return Map<String, Object>
	 */
	@Override
	public List<Map<String, Object>> selectSourceConnectorTableListNew(int trans_id) {
		return transMonitoringDAO.selectSourceConnectorTableListNew(trans_id);
	}

	/**
	 * 타겟 전송대상 테이블 목록 조회
	 * 
	 * @param trans_id
	 * @return List<Map<String, Object>>
	 */
	@Override
	public List<Map<String, Object>> selectTargetTopicListNew(int trans_id) {
		return transMonitoringDAO.selectTargetTopicListNew(trans_id);
	}

	/**
	 * source DBMS 정보 조회
	 * 
	 * @return Map<String, Object>
	 */
	public Map<String, Object> selectSourceDbmsInfo(int trans_id){
		return transMonitoringDAO.selectSourceDbmsInfo(trans_id);
	}
}
