package com.experdb.management.proxy.service.impl;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.net.ConnectException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONObject;
import org.springframework.stereotype.Service;
import org.springframework.util.ResourceUtils;

import com.experdb.management.proxy.cmmn.ProxyClientInfoCmmn;
import com.experdb.management.proxy.cmmn.ProxyClientProtocolID;
import com.experdb.management.proxy.cmmn.ProxyClientTranCodeType;
import com.experdb.management.proxy.service.ProxyLogVO;
import com.experdb.management.proxy.service.ProxyMonitoringService;
import com.k4m.dx.tcontrol.admin.accesshistory.service.impl.AccessHistoryDAO;
import com.k4m.dx.tcontrol.cmmn.CmmnUtils;
import com.k4m.dx.tcontrol.common.service.HistoryVO;
import com.k4m.dx.tcontrol.common.service.impl.CmmnServerInfoDAO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

/**
 * @author
 * @see proxy 모니터링 관련 화면 serviceImpl
 * 
 *      <pre>
* == 개정이력(Modification Information) ==
*
*   수정일                 수정자                   수정내용
*  -------     --------    ---------------------------
*  2021.03.05              최초 생성
 *      </pre>
 */
@Service("ProxyMonitoringServiceImpl")
public class ProxyMonitoringServiceImpl extends EgovAbstractServiceImpl implements ProxyMonitoringService {

	@Resource(name = "proxyMonitoringDAO")
	private ProxyMonitoringDAO proxyMonitoringDAO;

	@Resource(name = "accessHistoryDAO")
	private AccessHistoryDAO accessHistoryDAO;

	@Resource(name = "cmmnServerInfoDAO")
	private CmmnServerInfoDAO cmmnServerInfoDAO;

	@Resource(name = "proxySettingDAO")
	private ProxySettingDAO proxySettingDAO;

	/**
	 * Proxy 모니터링 화면 접속 이력 등록
	 * 
	 * @param request, historyVO, dtlCd, mnu_id
	 * @throws Exception
	 */
	@Override
	public void monitoringSaveHistory(HttpServletRequest request, HistoryVO historyVO, String dtlCd, String mnu_id)
			throws Exception {
		CmmnUtils.saveHistory(request, historyVO);
		historyVO.setExe_dtl_cd(dtlCd);

		if (mnu_id != null && !mnu_id.equals("")) {
			historyVO.setMnu_id(Integer.parseInt(mnu_id));
		}
		accessHistoryDAO.insertHistory(historyVO);
	}

	/**
	 * Proxy 서버 목록 조회
	 * 
	 * @param 
	 * @return List<Map<String, Object>>
	 */
	@Override
	public List<Map<String, Object>> selectProxyServerList() {
		return proxyMonitoringDAO.selectProxyServerList();
	}

	/**
	 * Proxy 서버  cluster 조회 by master server id
	 * 
	 * @param pry_svr_id
	 * @return List<Map<String, Object>>
	 */
	@Override
	public List<Map<String, Object>> selectProxyServerByMasterId(int pry_svr_id) {
		return proxyMonitoringDAO.selectProxyServerByMasterId(pry_svr_id);
	}

	/**
	 * Proxy 서버 cluster 별 연결 vip 조회
	 * 
	 * @param pry_svr_id
	 * @return List<Map<String, Object>>
	 */
	@Override
	public List<Map<String, Object>> selectProxyServerVipChk(int pry_svr_id) {
		return proxyMonitoringDAO.selectProxyServerVipChk(pry_svr_id);
	}

	/**
	 * proxy / keepalived 기동 상태 이력 조회
	 * 
	 * @param pry_svr_id
	 * @return List<ProxyLogVO>
	 */
	@Override
	public List<ProxyLogVO> selectProxyLogList(int pry_svr_id) {
		return proxyMonitoringDAO.selectProxyLogList(pry_svr_id);
	}

	/**
	 * Proxy 연결된 db 서버 조회
	 * 
	 * @param pry_svr_id
	 * @return List<Map<String, Object>>
	 */
	@Override
	public List<Map<String, Object>> selectDBServerConProxyList(int pry_svr_id) {
		return proxyMonitoringDAO.selectDBServerConProxyList(pry_svr_id);
	}

	/**
	 * Proxy 리스너 목록 및 상태조회
	 * 
	 * @param pry_svr_id
	 * @return List<Map<String, Object>>
	 */
	@Override
	public List<Map<String, Object>> selectProxyListnerMainList(int pry_svr_id) {
		return proxyMonitoringDAO.selectProxyListnerMainList(pry_svr_id);
	}
	
	/**
	 * Proxy 리스너 상세 정보 조회
	 * 
	 * @param pry_svr_id
	 * @return List<Map<String, Object>>
	 */
	@Override
	public List<Map<String, Object>> selectProxyStatisticsInfo(int pry_svr_id) {
		return proxyMonitoringDAO.selectProxyStatisticsInfo(pry_svr_id);
	}

	/**
	 * Proxy 리스너 통계 정보 조회
	 * 
	 * @param pry_svr_id
	 * @return List<Map<String, Object>>
	 */
	@Override
	public List<Map<String, Object>> selectProxyStatisticsChartInfo(int pry_svr_id) {
		return proxyMonitoringDAO.selectProxyStatisticsChartInfo(pry_svr_id);
	}

	/**
	 * Proxy 리스너 통계 정보 카운트
	 * 
	 * @param pry_svr_id
	 * @return List<Map<String, Object>>
	 */
	@Override
	public List<Map<String, Object>> selectProxyChartCntList(int pry_svr_id) {
		return proxyMonitoringDAO.selectProxyChartCntList(pry_svr_id);
	}

	/**
	 * Proxy, keepalived config 파일 정보 조회
	 * 
	 * @param pry_svr_id, type
	 * @return Map<String, Object>
	 */
	@Override
	public Map<String, Object> selectConfigurationInfo(int pry_svr_id, String type) {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("pry_svr_id", pry_svr_id);
		param.put("type", type);
		
		return null;
	}

	/**
	 * Proxy, keepalived config 파일 가져오기
	 * 
	 * @param pry_svr_id, type, Map<String, Object>
	 * @return Map<String, Object>
	 * @throws Exception 
	 */
	@Override
	public Map<String, Object> getConfiguration(int pry_svr_id, String type, Map<String, Object> param)
			throws Exception {

		Map<String, Object> info = proxyMonitoringDAO.selectConfigurationInfo(pry_svr_id, type);

		String strIpAdr = (String) info.get("ipadr");
		String strPrySvrNm = (String) info.get("pry_svr_nm");
		String strConfigFilePath = (String) info.get("path");
		String strDirectory = strConfigFilePath.substring(0, strConfigFilePath.lastIndexOf("/") + 1);
		String strFileName = strConfigFilePath.substring(strConfigFilePath.lastIndexOf("/") + 1);
		String strPort = String.valueOf(info.get("socket_port"));

		JSONObject jObj = new JSONObject();
		jObj.put(ProxyClientProtocolID.DX_EX_CODE, ProxyClientTranCodeType.PsP003);
		jObj.put(ProxyClientProtocolID.FILE_DIRECTORY, strDirectory);
		jObj.put(ProxyClientProtocolID.FILE_NAME, strFileName);
		jObj.put(ProxyClientProtocolID.SEEK, param.get("seek"));
		jObj.put(ProxyClientProtocolID.DW_LEN, param.get("dwLen"));
		jObj.put(ProxyClientProtocolID.READLINE, param.get("readLine"));

		String IP = strIpAdr;
		int PORT = Integer.parseInt(strPort);
		ProxyClientInfoCmmn pcic = new ProxyClientInfoCmmn();

		Map<String, Object> getConfigResult = new HashMap<String, Object>();
		getConfigResult = pcic.getConfigFile(IP, PORT, jObj);
		getConfigResult.put("pry_svr_nm", strPrySvrNm);

		return getConfigResult;
	}

	/**
	 * proxy / keepavlived 기동-정지 실패 로그 
	 * 
	 * @param pry_act_exe_sn
	 * @return Map<String, Object>
	 */
	@Override
	public Map<String, Object> selectActExeFailLog(int pry_act_exe_sn) {
		return proxyMonitoringDAO.selectActExeFailLog(pry_act_exe_sn);
	}

	/**
	 * proxy / keepalived 상태 변경
	 * 
	 * @param Map<String, Object>
	 * @return JSONObject
	 */
	@Override
	public JSONObject actExeCng(Map<String, Object> param) throws ConnectException, Exception {

		JSONObject jObj = new JSONObject();
		JSONObject resultObj = new JSONObject();

		String statusNm = "";

		boolean executeFlag = false;

		String resultLog = "";
		String errMsg = "";

		String type = (String) param.get("type");
		int pry_svr_id = (int) param.get("pry_svr_id");
		String cur_status = (String) param.get("cur_status");
		String act_exe_type = (String) param.get("act_exe_type");
		Map<String, Object> info = proxyMonitoringDAO.selectConfigurationInfo(pry_svr_id, type);
		String strIpAdr = (String) info.get("ipadr");
		String strPort = String.valueOf(info.get("socket_port"));

		jObj.put("pry_svr_id", pry_svr_id);
		if (type.equals("P") || type.equals("PROXY")) {
			jObj.put("sys_type", "PROXY");
		} else if (type.equals("K") || type.equals("KEEPALIVED")) {
			jObj.put("sys_type", "KEEPALIVED");
		}

		if (cur_status.equals("TC001501")) {
			jObj.put("status", "TC001502");
			jObj.put("act_type", "S");
			statusNm = "정지";
		} else if (cur_status.equals("TC001502")) {
			jObj.put("status", "TC001501");
			jObj.put("act_type", "R");
			statusNm = "재기동";
		}
		jObj.put("act_exe_type", act_exe_type);
		jObj.put("lst_mdfr_id", param.get("lst_mdfr_id"));

		ProxyClientInfoCmmn cic = new ProxyClientInfoCmmn();
		Map<String, Object> executeResult = new HashMap<String, Object>();
		int PORT = Integer.parseInt(strPort);
		try {
			executeResult = cic.proxyServiceExcute(strIpAdr, PORT, jObj);
		} catch (ConnectException e) {
			e.printStackTrace();
		}
		
		info = proxyMonitoringDAO.selectConfigurationInfo(pry_svr_id, type);
		if (executeResult != null) {
			if (!cur_status.equals(executeResult.get("EXECUTE_RESULT")) && info.get("exe_status") != cur_status) {
				executeFlag = true;
			} else {
				executeFlag = false;
			}
		} else if(info.get("exe_status") == cur_status){
			executeFlag = false;
		}
		
		if (!executeFlag) {
			errMsg = (String) jObj.get("sys_type") + " " + statusNm + " 중 오류가 발생하였습니다.";
		} else {
			errMsg = "정상적으로 " + statusNm + "되었습니다.";
		}
		resultObj.put("resultLog", resultLog);
		resultObj.put("result", executeFlag);
		resultObj.put("errMsg", errMsg);
		return resultObj;
	}

	/**
	 * proxy / keepalived log 파일 가져오기
	 * 
	 * @param pry_svr_id,type, param
	 * @return Map<String, Object>
	 */
	@Override
	public Map<String, Object> getLogFile(int pry_svr_id, String type, Map<String, Object> param) throws Exception {
		Properties props = new Properties();
		props.load(
				new FileInputStream(ResourceUtils.getFile("classpath:egovframework/tcontrolProps/globals.properties")));

		Map<String, Object> info = proxyMonitoringDAO.selectConfigurationInfo(pry_svr_id, type);

		String strIpAdr = (String) info.get("ipadr");
		String strPrySvrNm = (String) info.get("pry_svr_nm");
		String status = (String) info.get("exe_status");

		if (type.equals("PROXY")) {
			type = "haproxy";
		}
		String strDirectory = "/var/log/" + type.toLowerCase() + "/";
		String strFileName = type.toLowerCase() + ".log";

		if (param.get("todayYN").equals("N")) {
			strFileName += "-" + param.get("date");
		}

		String strPort = String.valueOf(info.get("socket_port"));
		JSONObject jObj = new JSONObject();
		jObj.put(ProxyClientProtocolID.DX_EX_CODE, ProxyClientTranCodeType.PsP008);
		jObj.put(ProxyClientProtocolID.FILE_DIRECTORY, strDirectory);
		jObj.put(ProxyClientProtocolID.FILE_NAME, strFileName);
		jObj.put(ProxyClientProtocolID.SEEK, param.get("seek"));
		jObj.put(ProxyClientProtocolID.DW_LEN, param.get("dwLen"));
		jObj.put(ProxyClientProtocolID.READLINE, param.get("readLine"));

		String IP = strIpAdr;
		int PORT = Integer.parseInt(strPort);
		ProxyClientInfoCmmn pcic = new ProxyClientInfoCmmn();

		Map<String, Object> getLogResult = new HashMap<String, Object>();
		getLogResult = pcic.getLogFile(IP, PORT, jObj);
		getLogResult.put("pry_svr_nm", strPrySvrNm);
		getLogResult.put("file_name", strFileName);
		getLogResult.put("status", status);

		try {
			if (getLogResult != null) {
				String file_path = "";
				if (props.get("proxy_path") != null) {
					file_path = props.get("proxy_path").toString();
				} else {
					file_path = "/home/experdb/app/eXperDB-Management/eXperDB-Proxy";
				}
				String file_name = "";

				File Folder = new File(file_path);
				if (!Folder.exists()) {
					try {
						Folder.mkdir(); // 폴더 생성
					} catch (Exception e) {
						e.getStackTrace();
					}
				}

				if (type.equals("haproxy")) {
					file_name = "/haproxy.log";
				} else {
					file_name = "/keepalived.log";
				}

				File file = new File(file_path + file_name);

				if (file.exists()) {
					file.delete(); // 파일삭제
				}

				if (!file.exists()) {
					try {
						file.createNewFile(); // 파일 생성
					} catch (IOException e) {
						e.printStackTrace();
					}
				}

				if (getLogResult.get("RESULT_DATA") != null) {
					BufferedWriter fw = new BufferedWriter(new FileWriter(file_path + file_name, true));

					fw.write(getLogResult.get("RESULT_DATA").toString());
					fw.flush();

					// 객체 닫기
					fw.close();
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return getLogResult;
	}

	/**
	 * proxy config파일 변경 이력 조회
	 * 
	 * @param pry_svr_id
	 * @return List<Map<String, Object>>
	 */
	@Override
	public List<Map<String, Object>> selectPryCngList(int pry_svr_id) {
		return proxyMonitoringDAO.selectPryCngList(pry_svr_id);
	}

	/**
	 * proxy 연결 db standby ip list
	 * 
	 * @param db_svr_id
	 * @return List<Map<String, Object>>
	 */
	@Override
	public List<Map<String, Object>> selectDbStandbyList(int db_svr_id) {
		return proxyMonitoringDAO.selectDbStandbyList(db_svr_id);
	}

	/**
	 * proxy agent 상태 확인
	 * 
	 * @param pry_svr_id
	 * @return Map<String, Object>
	 */
	@Override
	public Map<String, Object> getProxyAgentStatus(int pry_svr_id) {
		Map<String, Object> info = proxyMonitoringDAO.selectConfigurationInfo(pry_svr_id, "proxy");

		String strIpAdr = (String) info.get("ipadr");
		String strPort = String.valueOf(info.get("socket_port"));

		JSONObject jObj = new JSONObject();
		jObj.put(ProxyClientProtocolID.DX_EX_CODE, ProxyClientTranCodeType.PsP012);

		String IP = strIpAdr;
		int PORT = Integer.parseInt(strPort);
		ProxyClientInfoCmmn pcic = new ProxyClientInfoCmmn();

		Map<String, Object> getProxyAgentStatus = new HashMap<String, Object>();
		String conn_result = "Y";

		try {
			getProxyAgentStatus = pcic.getProxyAgentStatus(IP, PORT, jObj);
		} catch (ConnectException e) {
			conn_result = "N";
		} catch (Exception e) {
			conn_result = "N";
		}
		getProxyAgentStatus.put("conn_result", conn_result);
		return getProxyAgentStatus;
	}

	/**
	 * dashbord Proxy 조회 by db server id
	 * 
	 * @param db_svr_id
	 * @return List<Map<String, Object>>
	 */
	@Override
	public List<Map<String, Object>> selectProxyServerByDBSvrId(int db_svr_id) {
		return proxyMonitoringDAO.selectProxyServerByDBSvrId(db_svr_id);
	}
}