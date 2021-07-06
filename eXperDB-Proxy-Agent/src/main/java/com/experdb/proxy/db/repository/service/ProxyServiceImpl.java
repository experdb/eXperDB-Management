package com.experdb.proxy.db.repository.service;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.codehaus.jackson.map.ObjectMapper;
import org.codehaus.jettison.json.JSONArray;
import org.codehaus.jettison.json.JSONException;
import org.codehaus.jettison.json.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.experdb.proxy.db.repository.dao.ProxyDAO;
import com.experdb.proxy.db.repository.dao.SystemDAO;
import com.experdb.proxy.db.repository.vo.AgentInfoVO;
import com.experdb.proxy.db.repository.vo.DbServerInfoVO;
import com.experdb.proxy.db.repository.vo.ProxyGlobalVO;
import com.experdb.proxy.db.repository.vo.ProxyListenerServerListVO;
import com.experdb.proxy.db.repository.vo.ProxyListenerVO;
import com.experdb.proxy.db.repository.vo.ProxyServerVO;
import com.experdb.proxy.db.repository.vo.ProxyStatisticVO;
import com.experdb.proxy.db.repository.vo.ProxyVipConfigVO;
import com.experdb.proxy.socket.ProtocolID;
import com.experdb.proxy.util.CommonUtil;
import com.experdb.proxy.util.FileRunCommandExec;
import com.experdb.proxy.util.FileUtil;
import com.experdb.proxy.util.ProxyRunCommandExec;
import com.experdb.proxy.util.RunCommandExec;

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
@Service("ProxyService")
public class ProxyServiceImpl implements ProxyService{

	@Resource(name = "SystemDAO")
	private SystemDAO systemDAO;

	@Resource(name = "ProxyDAO")
	private ProxyDAO proxyDAO;

	private Logger socketLogger = LoggerFactory.getLogger("socketLogger");
	private Logger errLogger = LoggerFactory.getLogger("errorToFile");
	
	public final static String TEMPLATE_DIR = "./template/";

	/**
	 * proxy cmd 실행
	 * 
	 * @param String cmdGbn
	 * @return String
	 * @throws Exception
	 */
	public String selectProxyServerChk(String cmdGbn) throws Exception {
		Map<String, Object> param = new HashMap<String, Object>();
		JSONObject searchObj = new JSONObject();
		JSONObject jObjResult = null;
		String returnData = "";

		try {
			//1. proxy conf 위치
			param = paramLoadSetting(cmdGbn, "", "", ""); //param setting

			searchObj = proxyObjSetting(param);
			jObjResult = confSetExecute(searchObj);

			if (jObjResult != null) {
				String resultCode = (String)jObjResult.get(ProtocolID.RESULT_CODE);
	
				if (resultCode.equals("0")) {
					returnData = (String)jObjResult.get(ProtocolID.RESULT_SUB_DATA);
				}
			}

			if (returnData != null) {
				returnData = returnData.trim();
			} else {
				returnData = "";
			}
			///////////////////////////////////////////////////////////////
		} catch(Exception e) {
			e.printStackTrace();
		}

		return returnData;
	}

	/**
	 * 설치정보 conf 조회
	 * 
	 * @param String cmdGbn, String req_cmd, String server_ip, String db_chk
	 * @return JSONObject
	 * @throws Exception
	 */
	public JSONObject selectProxyServerList(String cmdGbn, String req_cmd, String server_ip, String db_chk) throws Exception {
		Map<String, Object> param = new HashMap<String, Object>();
		JSONObject searchObj = new JSONObject();
		JSONObject jObjResult = null;
		JSONObject resultJObjResult = null;

		try {
			param = paramLoadSetting(cmdGbn, req_cmd, server_ip, db_chk); //param setting

			searchObj = proxyObjSetting(param);

			if (cmdGbn.equals("dbms_realTime_read")) {
				jObjResult = dbmsReadExecute(searchObj);
			} else if (cmdGbn.equals("lsn_svr_data_del")) {
					jObjResult = lsnSvrDelExecute(searchObj);
			} else {
				jObjResult = confReadExecute(searchObj);	
			}

			if (jObjResult != null) {
				String resultCode = (String)jObjResult.get(ProtocolID.RESULT_CODE);
	
				if (resultCode.equals("0")) {
					resultJObjResult = (JSONObject)jObjResult.get(ProtocolID.RESULT_DATA);
				}
			}

			///////////////////////////////////////////////////////////////
		} catch(Exception e) {
			e.printStackTrace();
		}

		return resultJObjResult;
	}

	/**
	 * proxy 서버 정보 조회
	 * 
	 * @param ProxyServerVO
	 * @return ProxyServerVO
	 * @throws Exception
	 */
	public ProxyServerVO selectPrySvrInfo(ProxyServerVO vo)  throws Exception {
		return (ProxyServerVO) proxyDAO.selectPrySvrInfo(vo);
	}

	/**
	 * proxy 서버 정보 조회
	 * 
	 * @param ProxyServerVO
	 * @return ProxyServerVO
	 * @throws Exception
	 */
	public ProxyServerVO selectPrySvrInslInfo(ProxyServerVO vo)  throws Exception {
		return (ProxyServerVO) proxyDAO.selectPrySvrInslInfo(vo);
	}
	

	/**
	 * proxy 서버 param setting
	 * 
	 * @param String search_gbn, String req_cmd, String server_ip, String db_chk
	 * @return Map<String, Object>
	 * @throws Exception
	 */
	public Map<String, Object> paramLoadSetting(String search_gbn, String req_cmd, String server_ip, String db_chk) throws Exception {
		Map<String, Object> param = new HashMap<String, Object>();

		param.put("search_gbn", search_gbn);
		param.put("req_cmd", req_cmd);
		param.put("server_ip", server_ip);
		param.put("db_chk", db_chk);
		
		return param;
	}

	/**
	 * param JSONObject 변환 setting
	 * 
	 * @param Map<String, Object> param
	 * @return JSONObject
	 * @throws Exception
	 */
	private JSONObject proxyObjSetting(Map<String, Object> param) {
		JSONObject obj = new JSONObject();

		try {
			obj.put(ProtocolID.SEARCH_GBN, param.get("search_gbn").toString());  
			obj.put(ProtocolID.REQ_CMD, param.get("req_cmd").toString());  
			obj.put(ProtocolID.SERVER_IP, param.get("server_ip").toString());  
			obj.put(ProtocolID.DB_CHK, param.get("db_chk").toString());  
		} catch(Exception e) {
			e.printStackTrace();
		}

		return obj;
	}

	/**
	 * proxy cmd 정보 조회
	 * 
	 * @param JSONObject
	 * @return JSONObject
	 * @throws Exception
	 */
	private JSONObject confSetExecute(JSONObject jObj) throws Exception {
		socketLogger.info("ProxyServiceImpl.confSetExecute : ");

		String strSuccessCode = "0";
		String strErrCode = "";
		String strErrMsg = "";

		JSONObject outputObj = new JSONObject();
		JSONObject jsonObj = new JSONObject();
		JSONParser parser = new JSONParser();

		try {
			String searchGbn = jObj.get(ProtocolID.SEARCH_GBN).toString();
			String proxyCmd = proxyCmdSetting(jObj);
			
			RunCommandExec r = null;
			ProxyRunCommandExec pr = null;
			
			String retVal = "";
			String strResultMessge = "";
			String strResultSubMessge = "";

			if (searchGbn.equals("proxy_conf_which") || searchGbn.equals("keep_conf_which")) {
				pr = new ProxyRunCommandExec(proxyCmd, 0);
				pr.start();
				
				try {
					pr.join();
				} catch (InterruptedException ie) {
					ie.printStackTrace();
				}

				retVal = pr.call();
				strResultMessge = pr.getMessage();
			} else {
				r = new RunCommandExec(proxyCmd);
				
				//명령어 실행
				r.run();

				try {
					r.join();
				} catch (InterruptedException ie) {
					ie.printStackTrace();
				}

				retVal = r.call();
				strResultMessge = r.getMessage();
			}

			if (retVal.equals("success")) {
				if (!strResultMessge.isEmpty()) {
					if (searchGbn.equals("proxy_conf_which") || searchGbn.equals("keep_conf_which") || searchGbn.equals("proxy_setting_tot") || searchGbn.equals("keepalived_setting_tot")
						|| searchGbn.equals("proxy_lsn_exe_cnt") || searchGbn.equals("keepalived_vip_exe_cnt")
							) {
						strResultSubMessge  = strResultMessge;
						strResultMessge = "";
					}

					if (!strResultMessge.isEmpty()) {
						Object obj = parser.parse( strResultMessge );
						jsonObj = (JSONObject) obj;
					}
				}
			}

			outputObj.put(ProtocolID.RESULT_CODE, strSuccessCode);
			outputObj.put(ProtocolID.ERR_CODE, strErrCode);
			outputObj.put(ProtocolID.ERR_MSG, strErrMsg);
			outputObj.put(ProtocolID.RESULT_DATA, jsonObj);
			outputObj.put(ProtocolID.RESULT_SUB_DATA, strResultSubMessge);
			
			return outputObj;
		} catch (Exception e) {
			errLogger.error("ProxyServiceImpl.confSetExecute ", e.toString());

			outputObj.put(ProtocolID.RESULT_CODE, "1");
			outputObj.put(ProtocolID.ERR_CODE, strErrCode);
			outputObj.put(ProtocolID.ERR_MSG, "confSetExecute Error [" + e.toString() + "]");
			outputObj.put(ProtocolID.RESULT_DATA, jsonObj);
			outputObj.put(ProtocolID.RESULT_SUB_DATA, "");
		} finally {
			outputObj = null;
		}

		return outputObj;
	}

	/**
	 * proxy, keepalived conf 정보 조회
	 * 
	 * @param JSONObject
	 * @return JSONObject
	 * @throws Exception
	 */
	private JSONObject confReadExecute(JSONObject jObj) throws Exception {
		socketLogger.info("ProxyServiceImpl.confReadExecute : ");

		String strSuccessCode = "0";
		String strErrCode = "";
		String strErrMsg = "";

		JSONObject outputObj = new JSONObject();
		JSONObject jsonObj = new JSONObject();

		CommonUtil util = new CommonUtil();

		DbServerInfoVO dbServerInfoVO = new DbServerInfoVO();

		int db_svr_id = 0;
		String db_svr_nm = "";
		String stateMaster = "";
		String stateInterface = ""; 		//global_interface명
		String stateMasterInterface = ""; //global_interface명
		String stateGbn = "";
		String strPeerId = "";

		String strMaxConn = ""; 	//최대_연결_개수
		String strTimeClient = ""; 	//클라이언트_연결_최대_시간
		String strTimeConnect = ""; //커넥트_연결_지연_시간
		String strTimeServer = ""; 	//서버_연결_최대_시간
		String strTimeCheck = ""; 	//체크_시간
		String strObjIp = ""; 		//대상 ip
		String strPeerServerIp = ""; //PEER_서버_IP
		
		String strInslIp = "";

		try {
			String searchGbn = jObj.get(ProtocolID.SEARCH_GBN).toString();
			String serverIp = jObj.get(ProtocolID.SERVER_IP).toString();
			String proxyCmd = proxyCmdSetting(jObj);

			//conf 파일 조회
			FileRunCommandExec r = new FileRunCommandExec(proxyCmd);
			//명령어 실행
			r.run();

			try {
				r.join();
			} catch (InterruptedException ie) {
				ie.printStackTrace();
			}
			
			//내부 ip확인
			if (serverIp != null) {
				dbServerInfoVO.setIPADR(serverIp);
				DbServerInfoVO serverInfoIntlList = systemDAO.selectDbsvripadrMstGbnIntlInfo(dbServerInfoVO);

				if (serverInfoIntlList != null) {
					strInslIp = serverInfoIntlList.getINTL_IPADR();
				}
			}

			String retVal = r.call();
			ArrayList<String> strResultMessge = r.getListMessage();

			//db리스트 조회
			List<DbServerInfoVO> serverInfoList = systemDAO.selectDbsvripadrMstGbnInfo(dbServerInfoVO);

			//lisner
			List<ProxyListenerVO> lisnerSvrList = new ArrayList<ProxyListenerVO>();
			List<ProxyListenerServerListVO> lisnerSvrSebuList = new ArrayList<ProxyListenerServerListVO>();
			List<ProxyVipConfigVO> vipConfList = new ArrayList<ProxyVipConfigVO>();

			String strResultSubMessge = "";

			//proxy 파일 setting
			if (retVal.equals("success")) {
				if (strResultMessge != null) {
					String[] strArray = new String[strResultMessge.size()];
					int size=0;
					int keepsize=0;
					int peerServerIpInt = 0;	//PEER_서버_IP
					int peerServerIpChk = 0;
					int iTimeConnectChk = 0;
					int keepCnt = 0;

					int lisnerUserCnt = 0;		//lisnerUser
					int lisnerDbNmCnt = 0;		//lisnerDBNm
					int lisnerBindCnt = 0;		//lisnerBind
					int lisnerSimQueryCnt1 = 0;	//lisnerSimQuery1
					int lisnerSimQueryCnt2 = 0;	//lisnerSimQuery2
					int lisnerFieldNmCnt = 0;	//lisnerFieldNm
					int lisnerFieldValCnt = 0;	//lisnerFieldVal

					int vipAddCnt = 0;
					
					ProxyListenerVO lisnerVo = new ProxyListenerVO();
					ProxyListenerServerListVO lisnerSebuVo = new ProxyListenerServerListVO();
					ProxyVipConfigVO vipConfVo = null;
					ProxyListenerVO lisnerVoView = new ProxyListenerVO();
					String strServerBackList = "";

					for(String temp : strResultMessge){
						strArray[size++] = temp;

						//proxy 설정
						if ("proxy_conf_read".equals(searchGbn)) {
							// server list 조회  -- 내부망일때 체크하는 부분도 추가 2021.07.01
							if(temp.trim().matches(".*server.*")) {
								if (serverInfoList.size() > 0) {
									for(int j=0; j<serverInfoList.size(); j++){
										String db_ipadr = serverInfoList.get(j).getIPADR();
										String intl_db_ipadr = serverInfoList.get(j).getINTL_IPADR();
										
										socketLogger.info("proxy_set.intl_db_ipadrintl_db_ipadr : " + intl_db_ipadr);
										socketLogger.info("proxy_set.db_ipadrdb_ipadrdb_ipadr : " + db_ipadr);
										
										socketLogger.info("proxy_set.temp : " + temp);
										
										socketLogger.info("proxy_set.temp.contains(intl_db_ipadr) : " + temp.contains(intl_db_ipadr));
										
										if ((db_ipadr != null && temp.contains(db_ipadr)) || (intl_db_ipadr != null && temp.contains(intl_db_ipadr))) {
											db_svr_nm = serverInfoList.get(j).getDB_SVR_NM();
											db_svr_id = serverInfoList.get(j).getDB_SVR_ID();
											
											socketLogger.info("proxy_set.temp.db_svr_iddb_svr_iddb_svr_id : " + db_svr_id);
										}
									}
								}

							//global setting
							} else if(temp.trim().matches(".*maxconn.*")) { //maxconn
								if (temp != null) {
									strMaxConn = temp.trim().substring(temp.trim().lastIndexOf(" ") + 1 , temp.trim().length());
								}
							} else if(temp.trim().matches(".*timeout.*")) { //timeout client / connect / server / check
								if (temp != null) {
									if(temp.trim().matches(".*timeout client.*")) { //timeout client
										strTimeClient = temp.trim().replaceAll("timeout client", "");
									} else if(temp.trim().matches(".*timeout connect.*")) { //timeout connect
										strTimeConnect = temp.trim().replaceAll("timeout connect", "");
										iTimeConnectChk = size + 1;
									} else if(temp.trim().matches(".*timeout server.*")) { //timeout server
										strTimeServer = temp.trim().replaceAll("timeout server", "");
									} else if(temp.trim().matches(".*timeout check.*")) { //timeout check
										strTimeCheck = temp.trim().replaceAll("timeout check", "");
									}
								}
							}

							if (iTimeConnectChk == size) {
								strTimeServer = temp.trim().replaceAll("timeout server", "");
							}

							//리스너 setting
							///////////////////////////////////////////////////////////////////////////////////
							if(temp.matches(".*listen.*")) { //리스너 명
								String strtemp = temp.substring(temp.lastIndexOf(" ") + 1 , temp.length());
								if (!"stats".equals(strtemp)) {
									lisnerVo.setLsn_nm(strtemp.trim());
									lisnerVoView.setLsn_nm(lisnerVo.getLsn_nm());
									lisnerBindCnt = size + 2; //리스너 bind
								}
							}
							
							//리스너 bind setting
							if (lisnerBindCnt == size) { //bind
								lisnerVo.setCon_bind_port(temp.substring(temp.lastIndexOf(" ") + 1 , temp.length()));
								lisnerVoView.setCon_bind_port(lisnerVo.getCon_bind_port());
							}
							
							//리스너 user, 리스너 db_nm
							if(temp.matches(".*startup message.*")) {
								lisnerUserCnt = size + 4;  //리스너 user
								lisnerDbNmCnt = size + 6;  //리스너 db_nm
							}

							//리스너 simQuery
							if(temp.matches(".*run simple query.*")) {
								lisnerSimQueryCnt1 = size + 4;  //리스너 simQuery1
								lisnerSimQueryCnt2 = size + 5;  //리스너 simQuery2
							}

							//리스너 field name
							if(temp.matches(".*Row description packet.*")) {
								lisnerFieldNmCnt = size + 4;  //리스너 field name
							}

							//리스너 field value
							if(temp.matches(".*query result.*")) {
								lisnerFieldValCnt = size + 6;  //리스너 field value
							}

							if (lisnerUserCnt == size || lisnerDbNmCnt == size || lisnerSimQueryCnt1 == size || lisnerSimQueryCnt2 == size
								|| lisnerFieldNmCnt == size || lisnerFieldValCnt == size) {
								
								temp = temp.trim().replace(temp.trim().substring(temp.trim().lastIndexOf("#"), temp.trim().length()), "");
								temp = StringUtils.removeEnd(temp, " ");
								temp = temp.substring(temp.lastIndexOf(" ") + 1 , temp.length());
									
								if (!"binary".equals(temp)&& !"send-binary".equals(temp)) {
									temp = util.getHexToString(temp);
								} else {
									temp = "";
								}

								if (lisnerUserCnt == size) { //db user nm
									lisnerVo.setDb_usr_id(temp);
								} else if (lisnerDbNmCnt == size) { //db nm
									lisnerVo.setDb_nm(temp.trim());
								} else if (lisnerSimQueryCnt1 == size) { //SimQuery1
									lisnerVo.setCon_sim_query(temp);
								} else if (lisnerSimQueryCnt2 == size) { //SimQuery2
									if (!temp.equals("")) {
										lisnerVo.setCon_sim_query(lisnerVo.getCon_sim_query() + " " + temp.trim());
									}
								} else if (lisnerFieldNmCnt == size) { //field nm
									lisnerVo.setField_nm(temp);
								} else if (lisnerFieldValCnt == size) { //field nm
									lisnerVo.setField_val(temp);

									lisnerSvrList.add(lisnerVo);
									lisnerVo = new ProxyListenerVO();
								}
							}

							//////////////////////////////////////////////////////////////////////////

							//리스너 서버 setting
							if(temp.trim().indexOf("server") == 0 && temp.trim().matches(".*server.*")) {
								String strBack = temp.trim();
								strServerBackList = strBack.substring(strBack.lastIndexOf(" ") + 1 , strBack.length());
								
								if ("backup".equals(strServerBackList)) { //LISNER SVR BACKUP
									lisnerSebuVo.setBackup_yn("Y");
								} else {
									lisnerSebuVo.setBackup_yn("N");
								}

								temp = temp.replace("backup", "");
								temp = StringUtils.removeEnd(temp, " ");

								//port
								String serverPorttemp = temp.substring(temp.lastIndexOf(" ") + 1 , temp.length());
								if (!"".equals(serverPorttemp)) { 
									boolean isNumericPort =  serverPorttemp.matches("[+-]?\\d*(\\.\\d+)?");
									if (isNumericPort == true) {
										lisnerSebuVo.setChk_portno_val(serverPorttemp);
									} else {
										lisnerSebuVo.setChk_portno_val("0");
									}
								} else {
									lisnerSebuVo.setChk_portno_val("0");
								}

								//ip 체크
								if (!"".equals(temp.trim())) {
									String serverIptemp = temp.trim().substring(temp.trim().indexOf(" check port"), temp.trim().length());

									temp = temp.replace(serverIptemp, "").replace("server ", "").trim();
									temp = StringUtils.removeEnd(temp, " ");
									temp = temp.substring(temp.indexOf(" ") + 1 , temp.length());

									lisnerSebuVo.setDb_con_addr(temp);
								} else {
									lisnerSebuVo.setDb_con_addr(null);
								}

								lisnerSebuVo.setLsn_nm(lisnerVoView.getLsn_nm());
								lisnerSebuVo.setCon_bind_port(lisnerVoView.getCon_bind_port());

								lisnerSvrSebuList.add(lisnerSebuVo);
								lisnerSebuVo = new ProxyListenerServerListVO();
							}
						} else if ("keepalived_conf_read".equals(searchGbn)) {
							if(temp.trim().matches(".*state.*")) {
								 keepCnt++;
							}
						}
					}

					socketLogger.info("======================================================");
					socketLogger.info("1. proxy server");
					socketLogger.info("proxy_set.db_svr_nm : " + db_svr_nm);
					socketLogger.info("proxy_set.db_svr_id : " + db_svr_id);
					socketLogger.info("2. global");
					socketLogger.info("proxy_set.maxConn : " + strMaxConn);
					socketLogger.info("proxy_set.time_client : " + strTimeClient.trim());
					socketLogger.info("proxy_set.time_connect : " + strTimeConnect.trim());
					socketLogger.info("proxy_set.time_server : " + strTimeServer.trim());
					socketLogger.info("proxy_set.time_check : " + strTimeCheck.trim());
					socketLogger.info("3. listner");
					
					if (lisnerSvrList != null) {
						for(int i=0 ; i<lisnerSvrList.size() ; i++){
							socketLogger.info("proxy_set.lisnerSvrList.Db_usr_id_" + i + ": " + lisnerSvrList.get(i).getDb_usr_id());	
							socketLogger.info("proxy_set.lisnerSvrList.Db_nm_" + i + ": " + lisnerSvrList.get(i).getDb_nm());
							socketLogger.info("proxy_set.lisnerSvrList.Con_sim_query_" + i + ": " + lisnerSvrList.get(i).getCon_sim_query());	
							socketLogger.info("proxy_set.lisnerSvrList.Field_nm_" + i + ": " + lisnerSvrList.get(i).getField_nm());	
							socketLogger.info("proxy_set.lisnerSvrList.Field_val_" + i + ": " + lisnerSvrList.get(i).getField_val());	
						}
					} else {
						socketLogger.info("proxy_set.lisnerSvrList.Db_usr_id_");	
						socketLogger.info("proxy_set.lisnerSvrList.Db_nm_");
						socketLogger.info("proxy_set.lisnerSvrList.Con_sim_query_");	
						socketLogger.info("proxy_set.lisnerSvrList.Field_nm_");	
						socketLogger.info("proxy_set.lisnerSvrList.Field_val_");	
					}

					if (lisnerSvrSebuList != null) {
						for(int i=0 ; i<lisnerSvrSebuList.size() ; i++){
							socketLogger.info("proxy_set.lisnerSvrSebuList.Backup_yn_" + i + ": " + lisnerSvrSebuList.get(i).getBackup_yn());
							socketLogger.info("proxy_set.lisnerSvrSebuList.Chk_portno_val_" + i + ": " + lisnerSvrSebuList.get(i).getChk_portno_val());
							socketLogger.info("proxy_set.lisnerSvrSebuList.Db_con_addr_" + i + ": " + lisnerSvrSebuList.get(i).getDb_con_addr());
						}
					} else {
						socketLogger.info("proxy_set.lisnerSvrSebuList.Backup_yn_");
						socketLogger.info("proxy_set.lisnerSvrSebuList.Chk_portno_val_");
						socketLogger.info("proxy_set.lisnerSvrSebuList.Db_con_addr_");
					}
					socketLogger.info("======================================================");	
					
					///////////////////////////////////////////////////////////////////////////////
					if (keepCnt > 0) {
						int firstState = 0;
						strArray = new String[strResultMessge.size()];

						for(String temp : strResultMessge){
							strArray[keepsize++] = temp;

							//vip_상태명
							if(temp.trim().matches(".*state.*")) {
								firstState ++;
								stateMaster = temp.trim();

								vipConfVo = new ProxyVipConfigVO();
								vipConfVo.setState_nm(stateMaster.substring(stateMaster.lastIndexOf(" ") + 1, stateMaster.length())); //state 명
							}

							//첫번째 vip
							if (firstState == 1) {
								//interface 명
								if(temp.trim().matches(".*interface.*")) {
									stateInterface = temp.trim();
									if (stateInterface != null) {
										stateMasterInterface = stateInterface.substring(stateInterface.lastIndexOf(" ") + 1, stateInterface.length());
										if ("interface".equals(stateMasterInterface.trim())) {
											stateMasterInterface = "";
										}
									}
								}
								
								//대상_IP
								if(temp.trim().matches(".*unicast_src_ip.*")) {
									//서버 ip와 내부ip 전부 조회
									if (temp.trim().contains(serverIp)) {
										//대상_IP
										strObjIp = serverIp;
										peerServerIpChk = 1;
									} else if (!strInslIp.equals("")) {
										if (temp.trim().contains(strInslIp)) { //내부일때는 내부ip setting
											//대상_IP
											strObjIp = strInslIp;
											peerServerIpChk = 1;
										}
									}
								}

								//PEER_서버_IP
								if(peerServerIpChk == 1 && temp.trim().matches(".*unicast_peer.*")) {
									 peerServerIpInt = keepsize + 1;
								}

								//peer_서버_ip setting
								if (peerServerIpInt == keepsize && peerServerIpChk > 0) {
									strPeerServerIp = temp.trim();
									strPeerId = temp.trim();
									peerServerIpChk = 0;
								}
							}
							
							//vip - 설정////////////////////////////////////////////////////
							//v_router_ip
							if(temp.trim().matches(".*virtual_router_id.*")) { //v_router_ip
								String strRouter_id = temp.trim();
								strRouter_id = strRouter_id.substring(strRouter_id.lastIndexOf(" ") + 1 , strRouter_id.length());
								if (!"virtual_router_id".equals(strRouter_id) && !"".equals(strRouter_id)) {
									vipConfVo.setV_rot_id(strRouter_id);
								} else {
									vipConfVo.setV_rot_id("");
								}
							}

							//priority
							if(temp.trim().matches(".*priority.*")) { //priority
								String strPriority = temp.trim();
								strPriority = strPriority.substring(strPriority.lastIndexOf(" ") + 1 , strPriority.length());

								boolean isNumericPriority = strPriority.matches("[+-]?\\d*(\\.\\d+)?");
								if (isNumericPriority == true) {
									vipConfVo.setPriority(Integer.parseInt(strPriority));
								} else {
									vipConfVo.setPriority(0);
								}
							}

							//advert_int
							if(temp.trim().matches(".*advert_int.*")) { //advert_int
								String strAdvert_int = temp.trim();
								strAdvert_int = strAdvert_int.substring(strAdvert_int.lastIndexOf(" ") + 1 , strAdvert_int.length());

								boolean isNumericAdvert = strAdvert_int.matches("[+-]?\\d*(\\.\\d+)?");

								if (isNumericAdvert == true) {
									vipConfVo.setChk_tm(Integer.parseInt(strAdvert_int));
								} else {
									vipConfVo.setChk_tm(0);
								}
							}

							//vip 
							if(temp.trim().matches(".*virtual_ipaddress.*")) {
								vipAddCnt = keepsize+1;
							}

							if (vipAddCnt == keepsize) {
								String strVip = temp.trim();

								if (!"".equals(strVip)) {
									vipConfVo.setV_if_nm(strVip.substring(strVip.lastIndexOf(" ") + 1 , strVip.length())); //interface -- vip 마지막
									vipConfVo.setV_ip(strVip.substring(0, strVip.indexOf(" ")).replaceAll("/", "\\/"));
								} else {
									vipConfVo.setV_if_nm(""); //interface -- vip 마지막
									vipConfVo.setV_ip("");
								}

								vipConfList.add(vipConfVo);
								vipConfVo = new ProxyVipConfigVO();
							}
							//////////////////////////////////////////////////////
						}
					}
				}
			}

			socketLogger.info("======================================================");
			socketLogger.info("2. keepalived server");			
			
			if (vipConfList != null) {
				socketLogger.info("keepalived_set.stateMasterInterface: " + stateMasterInterface);	
				socketLogger.info("keepalived_set.strObjIp: " + strObjIp);
				socketLogger.info("keepalived_set.strPeerServerIp: " + strPeerServerIp);

				for(int i=0 ; i<vipConfList.size() ; i++){
					socketLogger.info("keepalived_set.vipConfList.State_nm_" + i + ": " + vipConfList.get(i).getState_nm());	
					socketLogger.info("keepalived_set.vipConfList.V_rot_id_" + i + ": " + vipConfList.get(i).getV_rot_id());	
					socketLogger.info("keepalived_set.vipConfList.Priority_" + i + ": " + vipConfList.get(i).getPriority());
					socketLogger.info("keepalived_set.vipConfList.Chk_tm_" + i + ": " + vipConfList.get(i).getChk_tm());
					socketLogger.info("keepalived_set.vipConfList.Priority_" + i + ": " + vipConfList.get(i).getPriority());
					socketLogger.info("keepalived_set.vipConfList.V_if_nm_" + i + ": " + vipConfList.get(i).getV_if_nm());
					socketLogger.info("keepalived_set.vipConfList.V_ip_" + i + ": " + vipConfList.get(i).getV_ip());
				}
			} else {
				socketLogger.info("keepalived_set.stateMasterInterface");	
				socketLogger.info("keepalived_set.strObjIp: ");
				socketLogger.info("keepalived_set.strPeerServerIp: ");
				
				socketLogger.info("keepalived_set.vipConfList.State_nm_");	
				socketLogger.info("keepalived_set.vipConfList.V_rot_id_");	
				socketLogger.info("keepalived_set.vipConfList.Priority_");
				socketLogger.info("keepalived_set.vipConfList.Chk_tm_");
				socketLogger.info("keepalived_set.vipConfList.V_if_nm_");
				socketLogger.info("keepalived_set.vipConfList.V_ip_");
			}
			socketLogger.info("======================================================");
			
			jsonObj.put("db_svr_nm", db_svr_nm);
			jsonObj.put("db_svr_id", db_svr_id);
			
			ProxyServerVO peerServerInfo = new ProxyServerVO();
			peerServerInfo.setIpadr(strPeerServerIp);
			

			//마스터 확인
			ProxyServerVO proxyServerInfo = proxyDAO.selectPrySvrInslInfo(peerServerInfo); //외부, 내부 조회 로 변경
			String strKeepalived = FileUtil.getPropertyValue("context.properties", "keepalived.install.yn");
			if (strKeepalived != null && "Y".equals(strKeepalived)) {
				if (proxyServerInfo != null) {
					if ("M".equals(proxyServerInfo.getMaster_gbn())) { //peer 마스터 이면 백업
						stateGbn = "S";
					} else if ("S".equals(proxyServerInfo.getMaster_gbn())) { //백업일때 해당 IP의 마스터 ID가 본인과 같으면 마스터 아니면 백업
						if (strObjIp.equals(proxyServerInfo.getMaster_svr_nm())) {
							stateGbn = "M";
						} else {
							stateGbn = "S";
						}
					}
				} else {
					stateGbn = "M";
				}
			} else {
				stateGbn = "M";
			}

			socketLogger.info("keepalived_set.stateGbn.stateGbn" + stateGbn);
			socketLogger.info("keepalived_set.strPeerId.strPeerId" + strPeerId);

			if ("S".equals(stateGbn)) {
				jsonObj.put("peer_id", strPeerId);
				
				jsonObj.put("back_peer_id", ""); //backup master_ip 체크
			} else {
				jsonObj.put("peer_id", "");

				jsonObj.put("back_peer_id", strObjIp); //backup master_ip 체크
			}
			jsonObj.put("master_gbn", stateGbn);

			//global
			jsonObj.put("max_conn", strMaxConn.trim());
			jsonObj.put("time_client", strTimeClient.trim());
			jsonObj.put("time_connect", strTimeConnect.trim());
			jsonObj.put("time_server", strTimeServer.trim());
			jsonObj.put("time_check", strTimeCheck.trim());
			jsonObj.put("if_nm", stateMasterInterface.trim());
			jsonObj.put("obj_ip", strObjIp);
			jsonObj.put("peer_server_ip", strPeerServerIp);

			ObjectMapper mapper = new ObjectMapper();
			String jsonLisnerSvrList="";
			String jsonLisnerSvrSebuList="";
			String jsonVipConfList = "";

			try {
				if (lisnerSvrList.size() > 0) {
					jsonLisnerSvrList = mapper.writeValueAsString(lisnerSvrList); 
				}

				if (lisnerSvrSebuList.size() > 0) {
					jsonLisnerSvrSebuList = mapper.writeValueAsString(lisnerSvrSebuList); 
				}

				if (vipConfList.size() > 0) {
					jsonVipConfList = mapper.writeValueAsString(vipConfList); 
				}

			} catch (IOException e) { 
				e.printStackTrace(); 
			}

			//리스너 list
			jsonObj.put("lisner_list", jsonLisnerSvrList);

			//리스너 server list
			jsonObj.put("lisner_svr_list", jsonLisnerSvrSebuList);

			//vip list
			jsonObj.put("vip_conf_list", jsonVipConfList);

			outputObj.put(ProtocolID.RESULT_CODE, strSuccessCode);
			outputObj.put(ProtocolID.ERR_CODE, strErrCode);
			outputObj.put(ProtocolID.ERR_MSG, strErrMsg);
			outputObj.put(ProtocolID.RESULT_DATA, jsonObj);
			outputObj.put(ProtocolID.RESULT_SUB_DATA, strResultSubMessge);

			return outputObj;

		} catch (Exception e) {
			errLogger.error("ProxyServiceImpl.confReadExecute ", e.toString());

			outputObj.put(ProtocolID.RESULT_CODE, "1");
			outputObj.put(ProtocolID.ERR_CODE, strErrCode);
			outputObj.put(ProtocolID.ERR_MSG, "confReadExecute Error [" + e.toString() + "]");
			outputObj.put(ProtocolID.RESULT_DATA, jsonObj);
			outputObj.put(ProtocolID.RESULT_SUB_DATA, "");
		} finally {
			outputObj = null;
		}

		return outputObj;
	}

	/**
	 * proxy 서버 저장 / 설치정보 등록
	 * 
	 * @param ProxyServerVO insPryVo, String insUpNmGbn, Map<String, Object> insertParam
	 * @return String
	 * @throws Exception
	 */
	@Transactional
	public String proxyConfFisrtIns(ProxyServerVO insPryVo, String insUpNmGbn, Map<String, Object> insertParam) throws Exception  {
		socketLogger.info("ProxyServiceImpl.confSetExecute----- : ");
		String returnMsg = "false";
		int saveChkPrySvrI = 0;
		AgentInfoVO agtVo = new AgentInfoVO();
		
		Map<String, Object> mstChkParam = new HashMap<String, Object>();
		ProxyServerVO prySvrChk = null;

		long pry_svr_id_sn = 1L;
		long pry_lsn_id_sn = 1L;

		try {
			if (insPryVo.getDb_svr_id() > 0) {
				//서버 등록
				try {
					if ("proxySvrIns".equals(insUpNmGbn)) {
						pry_svr_id_sn = proxyDAO.selectQ_T_PRY_SVR_I_01();
						insPryVo.setPry_svr_id((int)pry_svr_id_sn);
		
						saveChkPrySvrI = proxyDAO.insertPrySvrInfo(insPryVo);
					} else if ("proxySvrUdt".equals(insUpNmGbn)) {
						socketLogger.info("insPryVo.getMaster_svr_id_chk()insPryVo.getMaster_svr_id_chk() : " + insPryVo.getMaster_svr_id_chk());
						if (insPryVo.getMaster_svr_id_chk() != null && "Y".equals(insPryVo.getMaster_svr_id_chk())) {
							mstChkParam.put("selQueryGbn", "backupM");
							mstChkParam.put("db_svr_id", insPryVo.getDb_svr_id());
							
							prySvrChk = proxyDAO.selectPrySvrMasterSetInfo(mstChkParam);
							socketLogger.info("prySvrChk : " + prySvrChk);
							if (prySvrChk != null) {
								socketLogger.info("prySvrChk : " + prySvrChk.getPry_svr_id());
								insPryVo.setMaster_svr_id_chk(Integer.toString(prySvrChk.getPry_svr_id()));
							}
						}
						
						saveChkPrySvrI = proxyDAO.updatePrySvrInfo(insPryVo);
					}
					
					returnMsg = "success";
				} catch (Exception e) {
					errLogger.error("proxySvrIns {} ", e.toString());
					returnMsg = "false";
				}
				socketLogger.info("returnMsg : "+returnMsg);
				//global
				try {
					if (insertParam != null) {
						ProxyGlobalVO proxyGlobalVO = new ProxyGlobalVO();
	
						proxyGlobalVO.setPry_svr_id(insPryVo.getPry_svr_id());
						if (!"".equals(insertParam.get("max_conn").toString())) {
							proxyGlobalVO.setMax_con_cnt_chk(insertParam.get("max_conn").toString());
						} else {
							proxyGlobalVO.setMax_con_cnt_chk(null);
						}
						proxyGlobalVO.setCl_con_max_tm(insertParam.get("time_client").toString());
						proxyGlobalVO.setCon_del_tm(insertParam.get("time_connect").toString());
						proxyGlobalVO.setSvr_con_max_tm(insertParam.get("time_server").toString());
						proxyGlobalVO.setChk_tm(insertParam.get("time_check").toString());
						proxyGlobalVO.setIf_nm(insertParam.get("if_nm").toString());
						proxyGlobalVO.setObj_ip(insertParam.get("obj_ip").toString());
						proxyGlobalVO.setPeer_server_ip(insertParam.get("peer_server_ip").toString());
	
						proxyGlobalVO.setLst_mdfr_id("system");
						proxyGlobalVO.setFrst_regr_id("system");
	
						proxyDAO.insertPryGlbInfo(proxyGlobalVO);
					}
					returnMsg = "success";
				} catch (Exception e) {
					errLogger.error("global {} ", e.toString());
					returnMsg = "false";
				}
				socketLogger.info("returnMsg2 : "+returnMsg);
				try {
					//리스너, vip
					if (insertParam != null) {
						String strLisner_list = "";
						if (insertParam.get("lisner_list") != null) {
							strLisner_list = (String)insertParam.get("lisner_list");
						}
						
						String strLisner_svr_list = "";
						if (insertParam.get("lisner_svr_list") != null) {
							strLisner_svr_list = (String)insertParam.get("lisner_svr_list");
						}
						
						String strVip_conf_list = "";
						if (insertParam.get("vip_conf_list") != null) {
							strVip_conf_list = (String)insertParam.get("vip_conf_list");
						}

						try {
							JSONArray arrLisner_list = new JSONArray(strLisner_list);
							
							if (arrLisner_list.length() > 0 ) {
								for(int i=0 ; i<arrLisner_list.length() ; i++){
									JSONObject tempObj = (JSONObject) arrLisner_list.get(i);
									ProxyListenerVO schProxyListnerVO = new ProxyListenerVO();
	
									schProxyListnerVO.setPry_svr_id(insPryVo.getPry_svr_id());
									schProxyListnerVO.setCon_bind_port(tempObj.get("con_bind_port").toString());
									schProxyListnerVO.setCon_sim_query(tempObj.get("con_sim_query").toString());
									schProxyListnerVO.setDb_usr_id(tempObj.get("db_usr_id").toString());
									schProxyListnerVO.setField_val(tempObj.get("field_val").toString());
									schProxyListnerVO.setField_nm(tempObj.get("field_nm").toString());
	
									schProxyListnerVO.setLst_mdfr_id("system");
									schProxyListnerVO.setFrst_regr_id("system");
	
									schProxyListnerVO.setDb_svr_id(insPryVo.getDb_svr_id());
									schProxyListnerVO.setLsn_nm(tempObj.get("lsn_nm").toString());
	
									ProxyListenerVO proxyListenerVO = proxyDAO.selectPryLsnInfo(schProxyListnerVO);

									if (!"".equals(tempObj.get("db_nm").toString()) && !"".equals(tempObj.get("lsn_nm").toString())
											 && !"".equals(tempObj.get("db_usr_id").toString()) && !"".equals(tempObj.get("con_bind_port").toString())
											 && schProxyListnerVO.getDb_svr_id() > 0
											) {
										if (proxyListenerVO != null) {
											schProxyListnerVO.setLsn_id(proxyListenerVO.getLsn_id());
											schProxyListnerVO.setDb_id(proxyListenerVO.getDb_id());
											schProxyListnerVO.setLsn_desc(proxyListenerVO.getLsn_desc());
											schProxyListnerVO.setDb_nm(proxyListenerVO.getDb_nm());
	
											proxyDAO.updatePryLsnInfo(schProxyListnerVO);
	
										} else {
											pry_lsn_id_sn = proxyDAO.selectQ_T_PRY_LSN_I_01();
											schProxyListnerVO.setDb_id(Integer.parseInt(tempObj.get("db_id").toString()));
											schProxyListnerVO.setDb_nm(tempObj.get("db_nm").toString());
											schProxyListnerVO.setLsn_id((int)pry_lsn_id_sn);
											schProxyListnerVO.setLsn_desc("");
											
											proxyDAO.insertPryLsnInfo(schProxyListnerVO);
										}
									}
	
								}
							}
	
							JSONArray arrLisner_svr_list = new JSONArray(strLisner_svr_list);

							if (arrLisner_svr_list.length() > 0 ) {
								//db_con_addr / pry_svr_id / isn_id 로 조회 하여 값 있으면 update 없으면 insert
/*								for(int i=0 ; i<arrLisner_svr_list.length() ; i++){
									JSONObject tempObj = (JSONObject) arrLisner_svr_list.get(i);
									
									ProxyListenerServerListVO schProxyListnerSebuVO = new ProxyListenerServerListVO();
									
									schProxyListnerSebuVO.setPry_svr_id(insPryVo.getPry_svr_id());
									schProxyListnerSebuVO.setDb_con_addr(tempObj.get("db_con_addr").toString());
									schProxyListnerSebuVO.setLsn_nm(tempObj.get("lsn_nm").toString());
									
									proxyDAO.deletePryLsnSvrList(schProxyListnerSebuVO);
								}
								*/
								for(int i=0 ; i<arrLisner_svr_list.length() ; i++){
									JSONObject tempObj = (JSONObject) arrLisner_svr_list.get(i);
	
									ProxyListenerServerListVO schProxyListnerSebuVO = new ProxyListenerServerListVO();
									ProxyListenerVO schProxyListnerVO = new ProxyListenerVO();
									
									schProxyListnerSebuVO.setPry_svr_id(insPryVo.getPry_svr_id());
									schProxyListnerSebuVO.setDb_con_addr(tempObj.get("db_con_addr").toString());
									schProxyListnerSebuVO.setChk_portno_val(tempObj.get("chk_portno_val").toString());
									schProxyListnerSebuVO.setBackup_yn(tempObj.get("backup_yn").toString());
									schProxyListnerSebuVO.setCon_bind_port(tempObj.get("con_bind_port").toString());
									schProxyListnerSebuVO.setLsn_nm(tempObj.get("lsn_nm").toString());
	
									schProxyListnerSebuVO.setLst_mdfr_id("system");
									schProxyListnerSebuVO.setFrst_regr_id("system");

									schProxyListnerVO.setPry_svr_id(insPryVo.getPry_svr_id());
									schProxyListnerVO.setLsn_nm(tempObj.get("lsn_nm").toString());

									ProxyListenerServerListVO resultListnerServer = proxyDAO.selectPryLsnSvrChkInfo(schProxyListnerSebuVO);
									
									//값이 있으면 UPDATE / 없으면 insert
									if (resultListnerServer != null) {
										schProxyListnerSebuVO.setLsn_svr_id(resultListnerServer.getLsn_svr_id());
										schProxyListnerSebuVO.setLsn_id(resultListnerServer.getLsn_id());
										
										proxyDAO.updatePryLsnSvrInfo(schProxyListnerSebuVO);
									} else {
										proxyDAO.insertPryLsnSvrInfo(schProxyListnerSebuVO);
									}

								}
							}

							//vip 등록
							JSONArray arrVip_conf_list= new JSONArray(strVip_conf_list);

							if (arrVip_conf_list.length() > 0 ) {
								for(int i=0 ; i<arrVip_conf_list.length() ; i++){
									JSONObject tempObj = (JSONObject) arrVip_conf_list.get(i);

									ProxyVipConfigVO schProxyVipConfigVO = new ProxyVipConfigVO();
	
									schProxyVipConfigVO.setPry_svr_id(insPryVo.getPry_svr_id());
									schProxyVipConfigVO.setState_nm(tempObj.get("state_nm").toString());
									schProxyVipConfigVO.setV_ip(tempObj.get("v_ip").toString());
									schProxyVipConfigVO.setV_rot_id(tempObj.get("v_rot_id").toString());
									schProxyVipConfigVO.setV_if_nm(tempObj.get("v_if_nm").toString());
									schProxyVipConfigVO.setPriority(Integer.parseInt(tempObj.get("priority").toString()));
									schProxyVipConfigVO.setChk_tm(Integer.parseInt(tempObj.get("chk_tm").toString()));
	
									schProxyVipConfigVO.setLst_mdfr_id("system");
									schProxyVipConfigVO.setFrst_regr_id("system");
	
									proxyDAO.insertPryVipCngInfo(schProxyVipConfigVO);
								}
							}
						} catch (JSONException e) {
							e.printStackTrace();
						}
					}
					returnMsg = "success";
				} catch (Exception e) {
					errLogger.error("listner.error {} ", e.toString());
					returnMsg = "false";
				}
				socketLogger.info("returnMsg3 : "+returnMsg);
				try {
					if (insPryVo != null) {
						String strPry_svr_nm_mst = (String)insertParam.get("lisner_list");

						if (insPryVo.getBack_peer_id() != null && !"".equals(insPryVo.getBack_peer_id())) {
							strPry_svr_nm_mst = insPryVo.getPry_svr_nm();

							strPry_svr_nm_mst = strPry_svr_nm_mst.substring(0 , strPry_svr_nm_mst.lastIndexOf("_")+1);
							insPryVo.setPry_svr_nm(strPry_svr_nm_mst);

							proxyDAO.updatePrySvrMstSvrIdList(insPryVo);
						}
					}
					returnMsg = "success";
				} catch (Exception e) {
					errLogger.error("backup master_svr_id setting {} ", e.toString());
					returnMsg = "false";
				}
				socketLogger.info("returnMsg4 : "+returnMsg);
			}

			try {
				//최종 t_pry_agt_i 설정 update
				if ("success".equals(returnMsg)) {
					agtVo.setSvr_use_yn("Y");
					agtVo.setKal_install_yn(insPryVo.getKal_install_yn());
					agtVo.setIpadr(insPryVo.getIpadr());
					
					agtVo.setLst_mdfr_id("system");

					systemDAO.updatePryAgtUseYnLInfo(agtVo);
				}

				Map<String, Object> chkParam = new HashMap<String, Object>();
				chkParam.put("pry_svr_id",insPryVo.getPry_svr_id());

				//리스너 및  vip 상태 체크
				returnMsg = proxyStatusChk(chkParam);
			} catch (Exception e) {
				errLogger.error("proxy agent update {} ", e.toString());
				returnMsg = "false";
			}
		} catch (Exception e) {
			errLogger.error("proxyConfFisrtIns error {} ", e.toString());
			returnMsg = "false";
		}

		return returnMsg;
	}

	/**
	 * 리스너 실행 및 vip 체크
	 * 
	 * @param Map<String, Object>
	 * @return String
	 * @throws Exception
	 */
	@Transactional
	public String proxyStatusChk(Map<String, Object> chkParam) throws Exception  {
		socketLogger.info("Job proxyStatusChk [" + new Date(System.currentTimeMillis()) + "]");
		
		String returnMsg = "";
		List<Map<String, Object>> proxyLsnPortList = null;
		List<Map<String, Object>> proxyVipList = null;		

		try {
			//리스너 체크
			if (chkParam != null) {
				proxyLsnPortList = proxyDAO.selectPryLsnPortList(chkParam);

				//리스너 설정이 있는 경우만 실행
				if (proxyLsnPortList.size() > 0) {
					Map<String, Object> proxyLsnMapParam = new HashMap<String, Object>();
					for (int i = 0; i < proxyLsnPortList.size(); i++) {
						proxyLsnMapParam = (Map<String, Object>) proxyLsnPortList.get(i);
						String strPort = "";

						if (proxyLsnMapParam.get("con_bind_port") != null) {
							strPort = proxyLsnMapParam.get("con_bind_port").toString();
							strPort = strPort.substring(strPort.lastIndexOf(":") + 1 , strPort.length());

							int portCnt = Integer.parseInt(selectProxyTotServerChk("proxy_lsn_exe_cnt", strPort));
							
							ProxyListenerVO lisnerVo = new ProxyListenerVO();
							lisnerVo.setLsn_id(Integer.parseInt(proxyLsnMapParam.get("lsn_id").toString()));
							lisnerVo.setPry_svr_id(Integer.parseInt(proxyLsnMapParam.get("pry_svr_id").toString()));
							lisnerVo.setLst_mdfr_id("system");
							
							if (portCnt > 0) {
								lisnerVo.setLsn_exe_status("TC001501");
							} else {
								lisnerVo.setLsn_exe_status("TC001502");
							}
							
							proxyDAO.updatePryLsnStatusInfo(lisnerVo);	
						}
					}
				}
				
				//keepalived vip 실행상태 저장
				proxyVipList = proxyDAO.selectPryVipcngVipList(chkParam);

				//vip 설정이 있는 경우만 실행
				if (proxyVipList.size() > 0) {
					Map<String, Object> proxyVipMapParam = new HashMap<String, Object>();
					
					for (int i = 0; i < proxyVipList.size(); i++) {
						proxyVipMapParam = (Map<String, Object>) proxyVipList.get(i);

						String strVip = "";
						if (proxyVipMapParam.get("v_ip") != null) {
							strVip = proxyVipMapParam.get("v_ip").toString();

							int vipCnt = Integer.parseInt(selectProxyTotServerChk("keepalived_vip_exe_cnt", strVip));
							ProxyVipConfigVO vipConfigVo = new ProxyVipConfigVO();
							vipConfigVo.setVip_cng_id(Integer.parseInt(proxyVipMapParam.get("vip_cng_id").toString()));
							vipConfigVo.setPry_svr_id(Integer.parseInt(proxyVipMapParam.get("pry_svr_id").toString()));
							vipConfigVo.setState_nm(proxyVipMapParam.get("state_nm").toString());

							vipConfigVo.setLst_mdfr_id("system");
							
							if (vipCnt > 0) {
								vipConfigVo.setV_ip_exe_status("TC001501");
							} else {
								vipConfigVo.setV_ip_exe_status("TC001502");
							}

							proxyDAO.updatePryVipcngStatusInfo(vipConfigVo);	
						}
					}
				}
			}
			returnMsg = "success";
		} catch (Exception e) {
			errLogger.error("proxyStatusChk {sebu} ", e.toString());
			returnMsg = "false";
		}
		
		return returnMsg;
	}

	/**
	 * 전송 cmd 값 setting
	 * 
	 * @param JSONObject
	 * @return String
	 * @throws IOException  
	 * @throws FileNotFoundException 
	 * @throws JSONException 
	 */
	private String proxyCmdSetting(JSONObject obj) throws FileNotFoundException, IOException, JSONException {
		String strCmd = "";

		String searchGbn = obj.get(ProtocolID.SEARCH_GBN).toString();
		String reqCmd = obj.get(ProtocolID.REQ_CMD).toString();

		try {
			if (searchGbn.equals("proxy_conf_which")) { //설치여부 체크
				strCmd = "find /etc -name haproxy.cfg";
			} else if (searchGbn.equals("keep_conf_which")) { //설치여부 체크
				strCmd = "find /etc/keepalived -name keepalived.conf";
			} else if (searchGbn.equals("proxy_conf_read") || searchGbn.equals("keepalived_conf_read")) { //설치여부 체크
				strCmd = "cat " + reqCmd;
			} else if (searchGbn.equals("proxy_setting_tot")) { //proxy 설치 여부 및 실행여부 체크
				strCmd = "sh proxy_status.sh";
			} else if (searchGbn.equals("keepalived_setting_tot")) { //keepalived 설치 여부 및 실행여부 체크
				strCmd = "sh keepalived_status.sh";
			} else if (searchGbn.equals("proxy_lsn_exe_cnt")) { //proxy 리스너 실행여부 체크
				strCmd = "ss -tulpn|grep " + reqCmd + "|wc -l";
			} else if (searchGbn.equals("keepalived_vip_exe_cnt")) { //vip 실행여부 체크
				strCmd = "ip addr | grep '" + reqCmd + "'|wc -l";
			} else if (searchGbn.equals("dbms_realTime_read")) { //실시간 데이터 체크
				strCmd = "echo \"show stat\"  | sudo -u root socat stdio unix-connect:/var/run/haproxy.sock | awk -F, '$1!=\"# pxname\" && $2!=\"FRONTEND\" && $2!=\"BACKEND\"'  | cut -d \",\" -f 1,2,5-10,18,21-25,31,34-37,56,74";
			}

		} catch(Exception e) {
			e.printStackTrace();
		}

		return strCmd;
	}

	/**
	 * 리스너 실행여부 / keep 실행여부 체크
	 * 
	 * @param String cmdGbn, String reqCmd
	 * @return String
	 * @throws Exception
	 */
	public String selectProxyTotServerChk(String cmdGbn, String reqCmd) throws Exception {
		Map<String, Object> param = new HashMap<String, Object>();
		JSONObject searchObj = new JSONObject();
		JSONObject jObjResult = null;
		String returnData = "";

		try {
			//1. proxy conf 위치
			param = paramLoadSetting(cmdGbn, reqCmd, "",""); //param setting

			searchObj = proxyObjSetting(param);
			jObjResult = confSetExecute(searchObj);

			if (jObjResult != null) {
				String resultCode = (String)jObjResult.get(ProtocolID.RESULT_CODE);
	
				if (resultCode.equals("0")) {
					returnData = (String)jObjResult.get(ProtocolID.RESULT_SUB_DATA);
				}
			}

			if (returnData != null) {
				returnData = returnData.trim();
			} else {
				returnData = "";
			}
			///////////////////////////////////////////////////////////////
		} catch(Exception e) {
			e.printStackTrace();
		}

		return returnData;
	}

	/**
	 * 마스터 실시간 체크
	 * 
	 * @param Map<String, Object> chkParam, ProxyServerVO proxyServerInfo
	 * @return String
	 * @throws Exception
	 */
	@Transactional
	public String proxyMasterGbnRealCheck(Map<String, Object> chkParam, ProxyServerVO proxyServerInfo) throws Exception  {
		socketLogger.info("Job proxyMasterGbnRealCheck [" + new Date(System.currentTimeMillis()) + "]");
		String returnMsg = "";

		try {
			//param setting
			String ipadrPrm = "";
			String proxySetStatusPrm = "";
			String keepalivedSetStatusPrm = "";
			String strAcptype = "";
			String strAcptypeVal = "";
			String strProxyChgVal = "";
			String strKeepalivedChgVal = "";

			if (chkParam.get("ipadr") != null) ipadrPrm = chkParam.get("ipadr").toString();
			if (chkParam.get("proxySetStatus") != null) proxySetStatusPrm = chkParam.get("proxySetStatus").toString();
			if (chkParam.get("keepalivedSetStatus") != null) keepalivedSetStatusPrm = chkParam.get("keepalivedSetStatus").toString();

			chkParam.put("ipadr", ipadrPrm);
			chkParam.put("lst_mdfr_id", "system");
			chkParam.put("frst_regr_id", "system");

			//proxy check - 기동 이력등록
			if (!"".equals(proxySetStatusPrm) && !"not installed".equals(proxySetStatusPrm)) {
				if ("running".equals(proxySetStatusPrm)) {
					strAcptype = "TC001501";
					strAcptypeVal = "A";
				} else {
					strAcptype = "TC001502";
					strAcptypeVal = "S";
				}

				if (!strAcptype.equals(proxyServerInfo.getExe_status())) {
					chkParam.put("act_type", strAcptypeVal);
					chkParam.put("sys_type", "PROXY");
					
					strProxyChgVal = strAcptype;

					proxyDAO.insertPryActExeCngInfo(chkParam);
				}
			}
			
			//Keepalived check - 기동 이력등록
			if (proxyServerInfo != null) {
				if ("Y".equals(proxyServerInfo.getKal_install_yn())) { //설치여부 확인
					if (!"".equals(keepalivedSetStatusPrm) && !"not installed".equals(keepalivedSetStatusPrm)) {
						if ("running".equals(keepalivedSetStatusPrm)) {
							strAcptype = "TC001501";
							strAcptypeVal = "A";
						} else {
							strAcptype = "TC001502";
							strAcptypeVal = "S";
						}

						if (!strAcptype.equals(proxyServerInfo.getKal_exe_status())) {
							chkParam.put("act_type", strAcptypeVal);
							chkParam.put("sys_type", "KEEPALIVED");
							
							strKeepalivedChgVal = strAcptype;

							proxyDAO.insertPryActExeCngInfo(chkParam);
						}
					}
				}
			}

			//t_pry_svr_i 테이블 status 변경
			if (!"".equals(strProxyChgVal) || !"".equals(strKeepalivedChgVal)) {
				ProxyServerVO prySvr = new ProxyServerVO();
				prySvr.setExe_status(strProxyChgVal);
				prySvr.setKal_exe_status(strKeepalivedChgVal);
				prySvr.setLst_mdfr_id("system");
				prySvr.setIpadr(ipadrPrm);

				proxyDAO.updatePrySvrExeStatusInfo(prySvr);
			}
			
			Map<String, Object> mstChkParam = new HashMap<String, Object>();
			ProxyServerVO prySvrChk = null;

			//마스터 구분 변경
			if (!"".equals(strProxyChgVal)) {
				if ("TC001502".equals(strProxyChgVal)) { //down 된 경우
					if ("M".equals(proxyServerInfo.getMaster_gbn())) { //마스터 일때
						if (!"Y".equals(proxyServerInfo.getKal_install_yn())) { //keep 이 없는 경우
							prySvrChk = new ProxyServerVO();
							
							prySvrChk.setPry_svr_id(proxyServerInfo.getPry_svr_id());
							prySvrChk.setMaster_gbn(proxyServerInfo.getMaster_gbn());
							prySvrChk.setOld_master_svr_id_chk(null);
							prySvrChk.setLst_mdfr_id("system");
		         			prySvrChk.setSel_query_gbn("backup_down");
		         			prySvrChk.setDb_svr_id(proxyServerInfo.getDb_svr_id());

							proxyDAO.updatePrySvrMstGbnInfo(prySvrChk);							
						} else {
							//백업 제일 작은수가 마스터로 변경
							mstChkParam.put("pry_svr_id", proxyServerInfo.getPry_svr_id());
							mstChkParam.put("ipadr", ipadrPrm);
							mstChkParam.put("selQueryGbn", "masterM");
							mstChkParam.put("db_svr_id", proxyServerInfo.getDb_svr_id());
							
							prySvrChk = proxyDAO.selectPrySvrMasterSetInfo(mstChkParam);
							
				         	//backup이 있으면 update 없으면 처리 않함
				         	if (prySvrChk != null) {
				         		//백업중 제일 낮은 Pry_svr_id 존재
				         		if (!"".equals(prySvrChk.getPry_svr_id()) && !"0".equals(prySvrChk.getPry_svr_id())) {
				         			prySvrChk.setMaster_gbn("M");
				         			prySvrChk.setMaster_svr_id_chk(null);
				         			prySvrChk.setLst_mdfr_id("system");
				         			
				         			prySvrChk.setOld_pry_svr_id(proxyServerInfo.getPry_svr_id());
				         			prySvrChk.setOld_master_gbn("S");
				         			prySvrChk.setOld_master_svr_id_chk(Integer.toString(prySvrChk.getPry_svr_id()));

				         			prySvrChk.setSel_query_gbn("master_down");
				         			prySvrChk.setDb_svr_id(proxyServerInfo.getDb_svr_id());
			         	
				         			//백업중 제일 낮은 proxy 마스터로 승격
				         			//기존 마스터는 백업으로 변경
				         			//전체 백업의 마스터_id를 변경
				         			proxyDAO.updatePrySvrMstGbnInfo(prySvrChk);
				         		}
				         	} else {
								//백업일 경우
								prySvrChk = new ProxyServerVO();
								
								prySvrChk.setPry_svr_id(proxyServerInfo.getPry_svr_id());
								prySvrChk.setMaster_gbn(proxyServerInfo.getMaster_gbn());
								
								if (proxyServerInfo.getMaster_svr_id() <= 0) {
									prySvrChk.setOld_master_svr_id_chk(null);
								} else {
									prySvrChk.setOld_master_svr_id_chk(Integer.toString(proxyServerInfo.getMaster_svr_id()));
								}

								prySvrChk.setLst_mdfr_id("system");
			         			prySvrChk.setSel_query_gbn("backup_down");
			         			prySvrChk.setDb_svr_id(proxyServerInfo.getDb_svr_id());

								proxyDAO.updatePrySvrMstGbnInfo(prySvrChk);
			         		}
			         	}
					} else {//백업일 경우
						//keep 설치 여부 상관없이 현재를 그냥 저장함
						prySvrChk = new ProxyServerVO();
						
						prySvrChk.setPry_svr_id(proxyServerInfo.getPry_svr_id());
						prySvrChk.setMaster_gbn(proxyServerInfo.getMaster_gbn());
						prySvrChk.setOld_master_svr_id_chk(Integer.toString(proxyServerInfo.getMaster_svr_id()));
						prySvrChk.setLst_mdfr_id("system");
	         			prySvrChk.setSel_query_gbn("backup_down");
	         			prySvrChk.setDb_svr_id(proxyServerInfo.getDb_svr_id());

						proxyDAO.updatePrySvrMstGbnInfo(prySvrChk);

					}				
				} else { //up
					//마스터 제외하고 전부 등록
					prySvrChk = new ProxyServerVO();

					prySvrChk.setPry_svr_id(proxyServerInfo.getPry_svr_id());
					prySvrChk.setLst_mdfr_id("system");
					prySvrChk.setDb_svr_id(proxyServerInfo.getDb_svr_id());

					//마스터 일 경우 
					if ("M".equals(proxyServerInfo.getMaster_gbn())) { //마스터 일때
						//현재 master_gbn 저장 
						//현재 마스터 svr_id 값 setting 하여 값 저장
						//up 일경우
						//master 일 경우
						//1. keep 없는 경우
						// 본서버 M 그대로 
						// 혹시 연결되어있는 MASTER_SVR_ID 가 있으면 지우고 MASTER로
						//2. KEEP 있는 경우
						// 본서버 M 그대로
						// 연결되어있는 나머지는 MASTER 하위로 S 가 되어야함
						if (!"Y".equals(proxyServerInfo.getKal_install_yn())) {
							prySvrChk.setMaster_gbn(proxyServerInfo.getMaster_gbn());
							prySvrChk.setMaster_svr_id_chk(null);
							prySvrChk.setOld_master_gbn("M");
							prySvrChk.setOld_master_svr_id_chk(null);
							socketLogger.info("g_master_up :: ");
							prySvrChk.setSel_query_gbn("g_master_up");
							
						} else {
							//기존 마스터 가 있는 경우 확인
							//같은 dbms 이고 본서버보다 pry_svr_id 가 낮은 경우는 본인이  s가 되어야함
							//아닌경우는 본서버가 마스터 나머지는 s
							mstChkParam.put("pry_svr_id", proxyServerInfo.getPry_svr_id());
							mstChkParam.put("ipadr", ipadrPrm);
							mstChkParam.put("selQueryGbn", "backupM");
							mstChkParam.put("db_svr_id", proxyServerInfo.getDb_svr_id());

							ProxyServerVO backupChk = proxyDAO.selectPrySvrMasterSetInfo(mstChkParam);
							
							//마스터가 두건이상일때
							//마스터중 가장 앞자리인것이 위로가야함
							//마스터 제외, 현재 서버 의 master_svr_id, 현재 마스터의 svr_id 등 모두 
							prySvrChk.setMaster_gbn("M");
							prySvrChk.setMaster_svr_id_chk(null);

							prySvrChk.setOld_master_gbn("S");
							prySvrChk.setOld_pry_svr_id(proxyServerInfo.getPry_svr_id());
							
							if (backupChk != null && (backupChk.getPry_svr_id() != prySvrChk.getPry_svr_id() ||
								backupChk.getPry_svr_id() < prySvrChk.getPry_svr_id())) {
								//현재서버와 마스터서버아이디로된 것들을 백업으로 변경, pry_svr_id는 조회한 서버로
								//그리고 조회한 서버아이디를 마스터로 나머진 백업으로 한번더 up
								prySvrChk.setPry_svr_id(backupChk.getPry_svr_id());
								socketLogger.info("g_master_up_keep :: ");
								prySvrChk.setSel_query_gbn("g_master_up_keep");
								
							} else {
								//현재꺼를 마스터 그대로
								//기존 마스터나 다른 서버를 본서버 하위로
								//prySvrChk.setPry_svr_id(backupChk.getPry_svr_id());
								socketLogger.info("g_master_up_sel :: ");
								prySvrChk.setSel_query_gbn("g_master_up_sel");
							}
						}
					} else { //백업일때
						// keep 이 없다가 다시 있는 경우
						if (!"Y".equals(proxyServerInfo.getKal_install_yn())) { //keep 이 없는 경우

							//keep 이 없는 경우 master가 됨
							//나머지는 그대로
							prySvrChk.setMaster_gbn("M");
							prySvrChk.setMaster_svr_id_chk(null);
							
							prySvrChk.setSel_query_gbn("g_backup_up_keep");
						} else { //keep 있는 경우
							if ("M".equals(proxyServerInfo.getOld_master_gbn())) { //기본마스터 일때
								//기본마스터 일때 는 제일 1번으로 들어가야함
								//나머지는 현재 pry_svr_id로 master 설정되어야 하며
								//기존 마스터와 기존마스터의 백업들 모두 변경되어야함
								prySvrChk.setMaster_gbn("M"); //M으로 들어감
								prySvrChk.setMaster_svr_id_chk(null);
								
								//기존 마스터와 관련된 백업찾아야함
								//본서버제외
								if (proxyServerInfo.getMaster_svr_id() > 0) {
									prySvrChk.setOld_master_svr_id_chk(Integer.toString(proxyServerInfo.getMaster_svr_id()));
								} else {
									prySvrChk.setOld_master_svr_id_chk("");
								}
								prySvrChk.setOld_master_gbn("S");

								prySvrChk.setSel_query_gbn("g_backup_up");
							} else { //기본 백업일때
								//마스터 한건도 없을때 마스터 up
								//나머지는 현재건의 하위로
								if (proxyServerInfo.getMaster_exe_cnt() <= 0) {
									prySvrChk.setMaster_gbn("M");
									prySvrChk.setMaster_svr_id_chk(null);
								
									prySvrChk.setOld_master_gbn("S");
									prySvrChk.setOld_master_svr_id_chk(Integer.toString(proxyServerInfo.getPry_svr_id()));
									
									prySvrChk.setSel_query_gbn("g_backup_up");
								} else {

									prySvrChk.setMaster_gbn(proxyServerInfo.getMaster_gbn());
									prySvrChk.setMaster_svr_id_chk(Integer.toString(proxyServerInfo.getMaster_svr_id()));
									
									prySvrChk.setSel_query_gbn("g_backup_up_keep");
								}
							}
						}
					}

					proxyDAO.updatePrySvrMstGbnInfo(prySvrChk);
				}
			}

			returnMsg = "success";
		} catch (Exception e) {
			errLogger.error("proxyMasterGbnRealCheck {} ", e.toString());
			returnMsg = "false";
		}
		
		return returnMsg;
	}
	
	/**
	 * db 실시간 등록
	 * 
	 * @param Map<String, Object>
	 * @return String
	 * @throws Exception
	 */
	@Transactional
	public String proxyDbmsStatusChk(Map<String, Object> chkParam) throws Exception  {
		socketLogger.info("Job proxyDbmsStatusChk [" + new Date(System.currentTimeMillis()) + "]");
		String returnMsg = "";
		JSONObject jObjResult = null;

		try {
			//param setting
			String ipadrPrm = "";
			String proxySetStatusPrm = "";
			String realInsGbnPrm = "";

			if (chkParam.get("ipadr") != null) ipadrPrm = chkParam.get("ipadr").toString();
			if (chkParam.get("proxySetStatus") != null) proxySetStatusPrm = chkParam.get("proxySetStatus").toString();
			if (chkParam.get("real_ins_gbn") != null) realInsGbnPrm = chkParam.get("real_ins_gbn").toString();
			
			//proxy check - DB 연결 실시간 체크
			if (!"".equals(proxySetStatusPrm) && !"not installed".equals(proxySetStatusPrm)) {
				jObjResult = selectProxyServerList("dbms_realTime_read", "", ipadrPrm, realInsGbnPrm); //dbms 체크

				if (jObjResult.length() > 0) {
					returnMsg = "success";
				}
			}
		} catch (Exception e) {
			errLogger.error("proxyDbmsStatusChk error {} ", e.toString());
			returnMsg = "false";
		}
		
		return returnMsg;
	}

	/**
	 * db 실시간 체크 / 실시간 데이터 저장
	 * 
	 * @param JSONObject
	 * @return JSONObject
	 * @throws Exception
	 */
	private JSONObject dbmsReadExecute(JSONObject jObj) throws Exception {
		socketLogger.info("ProxyServiceImpl.dbmsReadExecute : ");

		String strSuccessCode = "0";
		String strErrCode = "";
		String strErrMsg = "";

		JSONObject outputObj = new JSONObject();
		JSONObject jsonObj = new JSONObject();

		CommonUtil util = new CommonUtil();

		try {
			String serverIp = jObj.get(ProtocolID.SERVER_IP).toString();
			String db_chk = jObj.get(ProtocolID.DB_CHK).toString();

			String proxyCmd = proxyCmdSetting(jObj);

			//conf 파일 조회
			FileRunCommandExec r = new FileRunCommandExec(proxyCmd);
			//명령어 실행
			r.run();

			try {
				r.join();
			} catch (InterruptedException ie) {
				ie.printStackTrace();
			}

			String retVal = r.call();
			ArrayList<String> strResultMessge = r.getListMessage();

			String strResultSubMessge = "";
			String jsonVipConfList = "";

			if (retVal.equals("success")) {
				if (strResultMessge != null) {
					String strLastTime = "";
					
					for(String temp : strResultMessge){
						ProxyStatisticVO proxyStatisticVO = new ProxyStatisticVO();
						String[] dbmsArray = temp.split(",");
						
						proxyStatisticVO.setExe_rslt_cd("TC001501");
						proxyStatisticVO.setLst_mdfr_id("system");
						proxyStatisticVO.setFrst_regr_id("system");

						proxyStatisticVO.setIpadr(serverIp);

						for(int i=0;i<dbmsArray.length;i++) {
							if (!dbmsArray[i].isEmpty() && dbmsArray[i].length() > 0) {
								if (i == 2) { 					//Sessions-cur
									proxyStatisticVO.setCur_session(Integer.parseInt(dbmsArray[i]));
								} else if (i == 3) {			//Sessions-max
									proxyStatisticVO.setMax_session(Integer.parseInt(dbmsArray[i]));
								} else if (i == 4) {			//Sessions-Limit
									proxyStatisticVO.setSession_limit(Integer.parseInt(dbmsArray[i]));
								} else if (i == 5) {			//Sessions-Total
									proxyStatisticVO.setCumt_sso_con_cnt(Integer.parseInt(dbmsArray[i]));
								} else if (i == 14) {			//Sessions-LbTot
									proxyStatisticVO.setCumt_sso_con_cnt(Integer.parseInt(dbmsArray[i]));
								} else if (i == 19) {			//Sessions-LbTot
									if ("".equals(dbmsArray[i]) || "-1".equals(dbmsArray[i])) {
										strLastTime = "";
									} else {
										strLastTime = util.getLongTimeToString(Long.parseLong(dbmsArray[i]));
									}
									proxyStatisticVO.setLst_con_rec_aft_tm(strLastTime);
								} else if (i == 6) {			//Bytes-In
									proxyStatisticVO.setByte_receive(Integer.parseInt(dbmsArray[i]));
								} else if (i == 7) {			//Bytes-Out
									proxyStatisticVO.setByte_transmit(Integer.parseInt(dbmsArray[i]));
								} else if (i == 8) {			//Server-status
									proxyStatisticVO.setSvr_status(dbmsArray[i]);
								} else if (i == 18) {			//Server-check_status
									proxyStatisticVO.setLst_status_chk_desc(dbmsArray[i]);
								} else if (i == 9) {			//Server-Bck
									proxyStatisticVO.setBakup_ser_cnt(Integer.parseInt(dbmsArray[i]));
								} else if (i == 10) {			//Server-Chk(chkfail)
									proxyStatisticVO.setFail_chk_cnt(Integer.parseInt(dbmsArray[i]));
								} else if (i == 11) {			//Server-Dwn
									proxyStatisticVO.setSvr_status_chg_cnt(Integer.parseInt(dbmsArray[i]));
								} else if (i == 13) {			//Server-Dwntme
									
									if ("".equals(dbmsArray[i]) || "-1".equals(dbmsArray[i])) {
										strLastTime = "";
									} else {
										strLastTime = util.getLongTimeToString(Long.parseLong(dbmsArray[i]));
									}
									proxyStatisticVO.setSvr_stop_tm(strLastTime);
								} else if (i == 0) {			//리스너 명
									proxyStatisticVO.setPxname(dbmsArray[i]);
								} else if (i == 20) {			//dbms 명
									proxyStatisticVO.setDb_con_addr_chk(dbmsArray[i]);
									proxyStatisticVO.setDb_con_addr(dbmsArray[i].substring(0, dbmsArray[i].lastIndexOf(":")));
									proxyStatisticVO.setChk_portno(Integer.parseInt(dbmsArray[i].substring(dbmsArray[i].lastIndexOf(":") + 1, dbmsArray[i].length())));
								}
							}
						}

						Map<String, Object> pryIdList = proxyDAO.selectPryLsnSvrIdInfo(proxyStatisticVO);

						if (pryIdList != null) {
							if (pryIdList.get("pry_svr_id") != null) {
								proxyStatisticVO.setPry_svr_id(Integer.parseInt(pryIdList.get("pry_svr_id").toString()));
							}

							if (pryIdList.get("lsn_id") != null) {
								proxyStatisticVO.setLsn_id(Integer.parseInt(pryIdList.get("lsn_id").toString()));
							}

							if (pryIdList.get("lsn_svr_id") != null) {
								proxyStatisticVO.setLsn_svr_id(Integer.parseInt(pryIdList.get("lsn_svr_id").toString()));
							}
						}
						
						//insert 
						if ("dbchk".equals(db_chk)) { //db 실시간 체크
							proxyDAO.updatePryLsnSvrDbRealChkInfo(proxyStatisticVO);
							strResultSubMessge = "true";
						} else if ("lsn_real_ins".equals(db_chk)) { //리스너 실시간 데이터 저장
							proxyStatisticVO.setLog_type("TC003901");
							
							proxyDAO.insertPrySvrStatusInfo(proxyStatisticVO);
							strResultSubMessge = "true";
						} else if ("lsn_mon_real_ins".equals(db_chk)) { //리스너 매일 00시 실시간 데이터 저장
							proxyStatisticVO.setLog_type("TC003902");
							
							proxyDAO.insertPrySvrStatusInfo(proxyStatisticVO);
							strResultSubMessge = "true";
						}
					}
				}
			}

			//db conf list
			jsonObj.put("db_conf_list", jsonVipConfList);

			outputObj.put(ProtocolID.RESULT_CODE, strSuccessCode);
			outputObj.put(ProtocolID.ERR_CODE, strErrCode);
			outputObj.put(ProtocolID.ERR_MSG, strErrMsg);
			outputObj.put(ProtocolID.RESULT_DATA, jsonObj);
			outputObj.put(ProtocolID.RESULT_SUB_DATA, strResultSubMessge);

			return outputObj;

		} catch (Exception e) {
			errLogger.error("ProxyServiceImpl.dbmsReadExecute ", e.toString());

			outputObj.put(ProtocolID.RESULT_CODE, "1");
			outputObj.put(ProtocolID.ERR_CODE, strErrCode);
			outputObj.put(ProtocolID.ERR_MSG, "dbmsReadExecute Error [" + e.toString() + "]");
			outputObj.put(ProtocolID.RESULT_DATA, jsonObj);
			outputObj.put(ProtocolID.RESULT_SUB_DATA, "");
		} finally {
			outputObj = null;
		}

		return outputObj;
	}
	
	/**
	 * DBMS 연결 실시간 체크
	 * @param dbServerInfo
	 * @throws Exception
	 */
	@Transactional
	public String proxyLsnScrStatusDel(Map<String, Object> chkParam) throws Exception  {
		socketLogger.info("Job proxyLsnScrStatusDel [" + new Date(System.currentTimeMillis()) + "]");
		String returnMsg = "";
		JSONObject jObjResult = null;

		try {
			//param setting
			String ipadrPrm = "";
			String proxySetStatusPrm = "";
			String realInsGbnPrm = "";

			if (chkParam.get("ipadr") != null) ipadrPrm = chkParam.get("ipadr").toString();
			if (chkParam.get("proxySetStatus") != null) proxySetStatusPrm = chkParam.get("proxySetStatus").toString();
			if (chkParam.get("real_ins_gbn") != null) realInsGbnPrm = chkParam.get("real_ins_gbn").toString();
			
			//proxy check - DB 연결 실시간 체크
			if (!"".equals(proxySetStatusPrm) && !"not installed".equals(proxySetStatusPrm)) {
				jObjResult = selectProxyServerList("lsn_svr_data_del", "", ipadrPrm, realInsGbnPrm); //dbms 체크

				if (jObjResult.length() > 0) {
					returnMsg = "success";
				}
			}
		} catch (Exception e) {
			errLogger.error("proxyLsnScrStatusDel error {} ", e.toString());
			returnMsg = "false";
		}
		
		return returnMsg;
	}
	

	/**
	 * proxy 리스너 통계정보 삭제
	 * 
	 * @param JSONObject
	 * @return JSONObject
	 * @throws Exception
	 */
	private JSONObject lsnSvrDelExecute(JSONObject jObj) throws Exception {
		socketLogger.info("ProxyServiceImpl.lsnSvrDelExecute : ");

		String strSuccessCode = "0";
		String strErrCode = "";
		String strErrMsg = "";

		JSONObject outputObj = new JSONObject();
		JSONObject jsonObj = new JSONObject();

		try {
			String serverIp = jObj.get(ProtocolID.SERVER_IP).toString();
			String dayDataDelVal = "";
			String minDataDelVal = "";
			String strResultSubMessge = "";

			ProxyServerVO proxyServerVO = new ProxyServerVO();
			proxyServerVO.setIpadr(serverIp);

			//proxy 서버 등록 여부 확인
			ProxyServerVO proxyServerInfo = proxyDAO.selectPrySvrInfo(proxyServerVO);
			
			if (proxyServerInfo != null) {
				proxyServerVO.setPry_svr_id(proxyServerInfo.getPry_svr_id());
				
				if (proxyServerInfo.getDay_data_del_term() > 0) {
					dayDataDelVal = proxyServerInfo.getDay_data_del_term()  + " day";
				}
				
				if (proxyServerInfo.getDay_data_del_term() > 0) {
					minDataDelVal = proxyServerInfo.getMin_data_del_term()  + " day";
				}

				if ((dayDataDelVal != null && !"".equals(dayDataDelVal)) && (minDataDelVal != null && !"".equals(minDataDelVal))) {
					proxyServerVO.setDay_data_del_val(dayDataDelVal);
					proxyServerVO.setMin_data_del_val(minDataDelVal);

					proxyDAO.lsnSvrDelExecuteList(proxyServerVO);
					
					strResultSubMessge = "success";
				}
			}

			outputObj.put(ProtocolID.RESULT_CODE, strSuccessCode);
			outputObj.put(ProtocolID.ERR_CODE, strErrCode);
			outputObj.put(ProtocolID.ERR_MSG, strErrMsg);
			outputObj.put(ProtocolID.RESULT_DATA, jsonObj);
			outputObj.put(ProtocolID.RESULT_SUB_DATA, strResultSubMessge);

			return outputObj;

		} catch (Exception e) {
			errLogger.error("ProxyServiceImpl.lsnSvrDelExecute ", e.toString());

			outputObj.put(ProtocolID.RESULT_CODE, "1");
			outputObj.put(ProtocolID.ERR_CODE, strErrCode);
			outputObj.put(ProtocolID.ERR_MSG, "lsnSvrDelExecute Error [" + e.toString() + "]");
			outputObj.put(ProtocolID.RESULT_DATA, jsonObj);
			outputObj.put(ProtocolID.RESULT_SUB_DATA, "");
		} finally {
			outputObj = null;
		}

		return outputObj;
	}
}