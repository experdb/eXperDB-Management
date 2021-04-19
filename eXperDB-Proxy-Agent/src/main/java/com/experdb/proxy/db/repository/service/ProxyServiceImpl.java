package com.experdb.proxy.db.repository.service;

import static java.nio.file.StandardCopyOption.REPLACE_EXISTING;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.xml.bind.DatatypeConverter;

import org.apache.commons.codec.DecoderException;
import org.apache.commons.codec.binary.Hex;
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
import com.experdb.proxy.db.repository.vo.ProxyConfChangeHistoryVO;
import com.experdb.proxy.db.repository.vo.ProxyGlobalVO;
import com.experdb.proxy.db.repository.vo.ProxyListenerServerListVO;
import com.experdb.proxy.db.repository.vo.ProxyListenerVO;
import com.experdb.proxy.db.repository.vo.ProxyServerVO;
import com.experdb.proxy.db.repository.vo.ProxyVipConfigVO;
import com.experdb.proxy.socket.ProtocolID;
import com.experdb.proxy.util.CommonUtil;
import com.experdb.proxy.util.FileRunCommandExec;
import com.experdb.proxy.util.FileUtil;
import com.experdb.proxy.util.ProxyRunCommandExec;
import com.experdb.proxy.util.RunCommandExec;

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
	 * 설치정보 관리
	 * @param String cmdGbn
	 * @throws Exception
	 */
	public String selectProxyServerChk(String cmdGbn) throws Exception {
		Map<String, Object> param = new HashMap<String, Object>();
		JSONObject searchObj = new JSONObject();
		JSONObject jObjResult = null;
		String returnData = "";

		try {
			//1. proxy conf 위치
			param = paramLoadSetting(cmdGbn, "", ""); //param setting

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
	 * @param String cmdGbn, String req_cmd, String server_ip
	 * @throws Exception
	 */
	public JSONObject selectProxyServerList(String cmdGbn, String req_cmd, String server_ip) throws Exception {
		Map<String, Object> param = new HashMap<String, Object>();
		JSONObject searchObj = new JSONObject();
		JSONObject jObjResult = null;
		JSONObject resultJObjResult = null;

		try {
			param = paramLoadSetting(cmdGbn, req_cmd, server_ip); //param setting

			searchObj = proxyObjSetting(param);
			jObjResult = confReadExecute(searchObj);

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
	 * @param ProxyServerVO
	 * @throws Exception
	 */
	public ProxyServerVO selectPrySvrInfo(ProxyServerVO vo)  throws Exception {
		return (ProxyServerVO) proxyDAO.selectPrySvrInfo(vo);
	}

	/**
	 * proxy 서버 param setting
	 * @param String search_gbn, String req_cmd, String server_ip
	 * @throws Exception
	 */
	public Map<String, Object> paramLoadSetting(String search_gbn, String req_cmd, String server_ip) throws Exception {
		Map<String, Object> param = new HashMap<String, Object>();

		param.put("search_gbn", search_gbn);
		param.put("req_cmd", req_cmd);
		param.put("server_ip", server_ip);
		
		return param;
	}

	//proxyObjSetting setting
	private JSONObject proxyObjSetting(Map<String, Object> param) {
		JSONObject obj = new JSONObject();

		try {
			obj.put(ProtocolID.SEARCH_GBN, param.get("search_gbn").toString());  
			obj.put(ProtocolID.REQ_CMD, param.get("req_cmd").toString());  
			obj.put(ProtocolID.SERVER_IP, param.get("server_ip").toString());  
		} catch(Exception e) {
			e.printStackTrace();
		}

		return obj;
	}

	/**
	 * conf 정보 조회
	 * @param dbServerInfo
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
					if (searchGbn.equals("proxy_conf_which") || searchGbn.equals("keep_conf_which") || searchGbn.equals("proxy_exe_status") || searchGbn.equals("keepalived_exe_status") || searchGbn.equals("proxy_setting_tot") || searchGbn.equals("keepalived_setting_tot")) {
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
	 * conf 정보 조회
	 * @param dbServerInfo
	 * @throws Exception
	 */
	private JSONObject confReadExecute(JSONObject jObj) throws Exception {
		socketLogger.info("ProxyServiceImpl.confReadExecute : ");

		String strSuccessCode = "0";
		String strErrCode = "";
		String strErrMsg = "";

		JSONObject outputObj = new JSONObject();
		JSONObject jsonObj = new JSONObject();
		JSONParser parser = new JSONParser();
		
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

		try {
			String searchGbn = jObj.get(ProtocolID.SEARCH_GBN).toString();
			String serverIp = jObj.get(ProtocolID.SERVER_IP).toString();

			String proxyCmd = proxyCmdSetting(jObj);

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

			//db리스트 조회
			List<DbServerInfoVO> serverInfoList = systemDAO.selectDbsvripadrMstGbnInfo(dbServerInfoVO);

			//lisner
			List<ProxyListenerVO> lisnerSvrList = new ArrayList<ProxyListenerVO>();
			List<ProxyListenerServerListVO> lisnerSvrSebuList = new ArrayList<ProxyListenerServerListVO>();
			List<ProxyVipConfigVO> vipConfList = new ArrayList<ProxyVipConfigVO>();

			String strResultSubMessge = "";

			if (retVal.equals("success")) {
				if (strResultMessge != null) {
					String[] strArray = new String[strResultMessge.size()];
					int size=0;
					int keepsize=0;
					int peerInt = 0;
					int peerServerIpInt = 0;	//PEER_서버_IP
					int peerchk = 0;
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

						if ("proxy_conf_read".equals(searchGbn)) {
							// server list 조회
							if(temp.trim().matches(".*server.*")) {
								if (serverInfoList.size() > 0) {
									for(int j=0; j<serverInfoList.size(); j++){
										String db_ipadr = serverInfoList.get(j).getIPADR();

										if (db_ipadr != null && temp.contains(db_ipadr)) {
											db_svr_nm = serverInfoList.get(j).getDB_SVR_NM();
											db_svr_id = serverInfoList.get(j).getDB_SVR_ID();
										}
									}
								}

							//global setting
							} else if(temp.trim().matches(".*maxconn.*")) { //maxconn
								if (temp != null) {
									strMaxConn = temp.substring(temp.lastIndexOf(" ") + 1 , temp.length());
								}
							} else if(temp.trim().matches(".*time.*")) { //timeout client / connect / server / check
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
								lisnerVo.setLsn_nm(temp.substring(temp.lastIndexOf(" ") + 1 , temp.length()));
								lisnerVoView.setLsn_nm(lisnerVo.getLsn_nm());
								lisnerBindCnt = size + 2; //리스너 bind
							}

							if(temp.matches(".*startup message.*")) {
								lisnerUserCnt = size + 4;  //리스너 user
								lisnerDbNmCnt = size + 6;  //리스너 db_nm
							}

							if(temp.matches(".*run simple query.*")) {
								lisnerSimQueryCnt1 = size + 4;  //리스너 simQuery1
								lisnerSimQueryCnt2 = size + 5;  //리스너 simQuery
							}

							if(temp.matches(".*Row description packet.*")) {
								lisnerFieldNmCnt = size + 4;  //리스너 field name
							}

							if(temp.matches(".*query result.*")) {
								lisnerFieldValCnt = size + 6;  //리스너 field value
							}

							//리스너 setting
							if (lisnerBindCnt == size) { //bind
								lisnerVo.setCon_bind_port(temp.substring(temp.lastIndexOf(" ") + 1 , temp.length()));
								lisnerVoView.setCon_bind_port(lisnerVo.getCon_bind_port());
							} else if (lisnerUserCnt == size || lisnerDbNmCnt == size || lisnerSimQueryCnt1 == size || lisnerSimQueryCnt2 == size
								|| lisnerFieldNmCnt == size || lisnerFieldValCnt == size) {
								temp = temp.trim().replace(temp.substring(temp.lastIndexOf("#"), temp.length()), "");
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
									lisnerVo.setDb_nm(temp);
								} else if (lisnerSimQueryCnt1 == size) { //SimQuery1
									lisnerVo.setCon_sim_query(temp);
								} else if (lisnerSimQueryCnt2 == size) { //SimQuery2
									if (!temp.equals("")) {
										lisnerVo.setCon_sim_query(lisnerVo.getCon_sim_query() + " " + temp);
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

								String serverPorttemp = temp.substring(temp.lastIndexOf(" ") + 1 , temp.length());

								if (!"".equals(serverPorttemp)) { //port
									if (!"server".equals(serverPorttemp) && !"primary".equals(serverPorttemp) && !"check".equals(serverPorttemp)
										&& !"port".equals(serverPorttemp) && !"backup".equals(serverPorttemp)
										) {
										lisnerSebuVo.setChk_portno_val(serverPorttemp);
									} else {
										lisnerSebuVo.setChk_portno_val("0");
									}
								} else {
									lisnerSebuVo.setChk_portno_val("0");
								}

								if (!"".equals(temp.trim())) {
									//ip 체크
									String serverIptemp = temp.substring(temp.indexOf(" check port"), temp.length());

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

					if (keepCnt > 0) {
						int firstState = 0;
						strArray = new String[strResultMessge.size()];
						for(String temp : strResultMessge){
							strArray[keepsize++] = temp;

							if(temp.trim().matches(".*state.*")) {
								firstState ++;
								stateMaster = temp.trim();

								vipConfVo = new ProxyVipConfigVO();
								vipConfVo.setState_nm(stateMaster.substring(stateMaster.lastIndexOf(" ") + 1, stateMaster.length())); //state 명
							}

							//interface 명
							if(temp.trim().matches(".*interface.*") && firstState == 1) {
								stateInterface = temp.trim();
								if (stateInterface != null) {
									stateMasterInterface = stateInterface.substring(stateInterface.lastIndexOf(" ") + 1, stateInterface.length());
									if ("interface".equals(stateMasterInterface.trim())) {
										stateMasterInterface = "";
									}
								}
							}

							if(temp.trim().matches(".*unicast_src_ip.*") && firstState == 1) {
								if (temp.trim().contains(serverIp)) {
									stateGbn = stateMaster;

									if (stateGbn != null) {
										stateGbn = stateGbn.substring(stateGbn.lastIndexOf(" ") + 1 , stateGbn.length());

										peerInt = keepsize + 2;
										peerchk = 1;
									}

									//대상_IP
									strObjIp = serverIp;
									peerServerIpChk = 1;
								}
							}

							//PEER_서버_IP
							if(peerServerIpChk == 1 && temp.trim().matches(".*unicast_peer.*") && firstState == 1) {
								 peerServerIpInt = keepsize + 1;
							}

							if (peerServerIpInt == keepsize && peerServerIpChk > 0  && firstState == 1) {
								strPeerServerIp = temp.trim();
								peerServerIpChk = 0;
							}

							//backup일때 peer id 확인
							if (peerInt == keepsize && peerchk > 0  && firstState == 1) {
								strPeerId = temp.trim();
								peerchk = 0;
							}


							//vip - 설정////////////////////////////////////////////////////
							if(temp.trim().matches(".*virtual_router_id.*")) { //v_router_ip
								String strRouter_id = temp.trim();
								strRouter_id = strRouter_id.substring(strRouter_id.lastIndexOf(" ") + 1 , strRouter_id.length());

								if (!"virtual_router_id".equals(strRouter_id) && !"".equals(strRouter_id)) {
									vipConfVo.setV_rot_id(strRouter_id.substring(strRouter_id.lastIndexOf(" ") + 1 , strRouter_id.length()));
								} else {
									vipConfVo.setV_rot_id("");
								}
							}

							if(temp.trim().matches(".*priority.*")) { //priority
								String strPriority = temp.trim();
								strPriority = strPriority.substring(strPriority.lastIndexOf(" ") + 1 , strPriority.length());

								if (!"priority".equals(strPriority) && !"".equals(strPriority)) {
									vipConfVo.setPriority(Integer.parseInt(strPriority));
								} else {
									vipConfVo.setPriority(0);
								}
							}

							if(temp.trim().matches(".*advert_int.*")) { //advert_int
								String strAdvert_int = temp.trim();
								strAdvert_int = strAdvert_int.substring(strAdvert_int.lastIndexOf(" ") + 1 , strAdvert_int.length());

								if (!"advert_int".equals(strAdvert_int) && !"".equals(strAdvert_int)) {
									vipConfVo.setChk_tm(Integer.parseInt(strAdvert_int));
								} else {
									vipConfVo.setChk_tm(0);
								}
							}

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

			if (stateGbn != null && !"".equals(stateGbn)) {
				if (stateGbn.contains("MASTER")) {
					stateGbn = "M";
				} else {
					stateGbn = "B";
				}
			}

			jsonObj.put("db_svr_nm", db_svr_nm);
			jsonObj.put("db_svr_id", db_svr_id);
			jsonObj.put("master_gbn", stateGbn);
			
			if ("B".equals(stateGbn)) {
				jsonObj.put("peer_id", strPeerId);
				
				jsonObj.put("back_peer_id", ""); //backup master_ip 체크
			} else {
				jsonObj.put("peer_id", "");

				jsonObj.put("back_peer_id", strObjIp); //backup master_ip 체크
			}

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
			outputObj.put(ProtocolID.ERR_MSG, "confSetExecute Error [" + e.toString() + "]");
			outputObj.put(ProtocolID.RESULT_DATA, jsonObj);
			outputObj.put(ProtocolID.RESULT_SUB_DATA, "");
		} finally {
			outputObj = null;
		}

		return outputObj;
	}

	/**
	 * 설치정보 등록
	 * @param dbServerInfo
	 * @throws Exception
	 */
	@Transactional
	public String proxyConfFisrtIns(ProxyServerVO insPryVo, String insUpNmGbn, Map<String, Object> insertParam, JSONObject jObjListResult) throws Exception  {
		String returnMsg = "";
		int saveChkPrySvrI = 0;
		AgentInfoVO agtVo = new AgentInfoVO();

		long pry_svr_id_sn = 1L;
		long pry_lsn_id_sn = 1L;

		try {
			if (insPryVo.getDb_svr_id() > 0) {
				
				try {
					if ("proxySvrIns".equals(insUpNmGbn)) {
						pry_svr_id_sn = proxyDAO.selectQ_T_PRY_SVR_I_01();
						insPryVo.setPry_svr_id((int)pry_svr_id_sn);
		
						saveChkPrySvrI = proxyDAO.insertPrySvrInfo(insPryVo);
					} else if ("proxySvrUdt".equals(insUpNmGbn)) {
						saveChkPrySvrI = proxyDAO.updatePrySvrInfo(insPryVo);
					}
				} catch (Exception e) {
					errLogger.error("proxySvrIns {} ", e.toString());
					returnMsg = "false";
				}
	
				try {
					//최종 t_pry_agt_i 설정 update
					if (saveChkPrySvrI > 0) {
						agtVo.setSvr_use_yn("Y");
						agtVo.setIpadr(insPryVo.getIpadr());
						agtVo.setLst_mdfr_id("system");
	
						systemDAO.updatePryAgtUseYnLInfo(agtVo);
					}
				} catch (Exception e) {
					errLogger.error("saveChkPrySvrI {} ", e.toString());
					returnMsg = "false";
				}
	
				try {
					//global
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
				} catch (Exception e) {
					errLogger.error("global {} ", e.toString());
					returnMsg = "false";
				}
	
				try {
					//리스너, vip
					if (insertParam != null) {
						String strLisner_list = (String)insertParam.get("lisner_list");
						String strLisner_svr_list = (String)insertParam.get("lisner_svr_list");
						String strVip_conf_list = (String)insertParam.get("vip_conf_list");

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
								for(int i=0 ; i<arrLisner_svr_list.length() ; i++){
									JSONObject tempObj = (JSONObject) arrLisner_svr_list.get(i);
									
									ProxyListenerServerListVO schProxyListnerSebuVO = new ProxyListenerServerListVO();
									
									schProxyListnerSebuVO.setPry_svr_id(insPryVo.getPry_svr_id());
									schProxyListnerSebuVO.setDb_con_addr(tempObj.get("db_con_addr").toString());
									schProxyListnerSebuVO.setLsn_nm(tempObj.get("lsn_nm").toString());
									
									proxyDAO.deletePryLsnSvrList(schProxyListnerSebuVO);
								}
								
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
	
									ProxyListenerVO proxyListenerVO = proxyDAO.selectPryLsnInfo(schProxyListnerVO);

									if (proxyListenerVO != null) {
										proxyDAO.insertPryLsnSvrInfo(schProxyListnerSebuVO);
									}

								}
							}

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
					errLogger.error("global {} ", e.toString());
					returnMsg = "false";
				}
				
				
				try {
					socketLogger.info("insPryVoinsPryVoinsPryVoinsPryVoinsPryVo.confReadExecute : " + insPryVo);
					if (insPryVo != null) {
						String strPry_svr_nm_mst = (String)insertParam.get("lisner_list");
						socketLogger.info("insPryVo.getBack_peer_id : " + insPryVo.getBack_peer_id());
						if (insPryVo.getBack_peer_id() != null && !"".equals(insPryVo.getBack_peer_id())) {
							strPry_svr_nm_mst = insPryVo.getPry_svr_nm();
							socketLogger.info("insPryVo.strPry_svr_nm_mst0 : " +strPry_svr_nm_mst);
							strPry_svr_nm_mst = strPry_svr_nm_mst.substring(0 , strPry_svr_nm_mst.lastIndexOf("_")+1);
							socketLogger.info("insPryVo.strPry_svr_nm_mst1 : " +strPry_svr_nm_mst);
							insPryVo.setPry_svr_nm(strPry_svr_nm_mst);
							
							socketLogger.info("insPryVo.setPry_svr_nm0 : " +insPryVo.getPry_svr_nm());
							socketLogger.info("insPryVo.setPry_svr_nm0 : " +insPryVo.getPry_svr_nm());
							
							proxyDAO.updatePrySvrMstSvrIdList(insPryVo);
						}
					}
					returnMsg = "success";
				} catch (Exception e) {
					errLogger.error("backup master_svr_id setting {} ", e.toString());
					returnMsg = "false";
				}
				
			}
		} catch (Exception e) {
			errLogger.error("DXTcontrolScaleAwsExecute {} ", e.toString());
			returnMsg = "false";
		}

		return returnMsg;
	}

	/**
	 * 전송 cmd 값 setting
	 * 
	 * @return String
	 * @throws IOException  
	 * @throws FileNotFoundException 
	 * @throws JSONException 
	 * @throws Exception
	 */
	private String proxyCmdSetting(JSONObject obj) throws FileNotFoundException, IOException, JSONException {
		String strCmd = "";

		String searchGbn = obj.get(ProtocolID.SEARCH_GBN).toString();
		String reqCmd = obj.get(ProtocolID.REQ_CMD).toString();

		try {
			if (searchGbn.equals("proxy_conf_which")) { //설치여부 체크
				strCmd = "find /etc -name haproxy.cfg";
			} else if (searchGbn.equals("keep_conf_which")) { //설치여부 체크
				strCmd = "find /etc -name keepalived.conf";
			} else if (searchGbn.equals("proxy_conf_read") || searchGbn.equals("keepalived_conf_read")) { //설치여부 체크
				strCmd = "cat " + reqCmd;
			} else if (searchGbn.equals("proxy_exe_status")) { //실행여부 체크
				strCmd = "systemctl status haproxy |grep Active: |cut -d ' ' -f 5";
			} else if (searchGbn.equals("keepalived_exe_status")) { //실행여부 체크
				strCmd = "systemctl status keepalived |grep Active: |cut -d ' ' -f 5";
			} else if (searchGbn.equals("proxy_setting_tot")) { //proxy 설치 여부 및 실행여부 체크
				strCmd = "sh proxy_status.sh";
			} else if (searchGbn.equals("keepalived_setting_tot")) { //keepalived 설치 여부 및 실행여부 체크
				strCmd = "sh keepalived_status.sh";
			}

		} catch(Exception e) {
			e.printStackTrace();
		}

		return strCmd;
	}


	/**
	 * 설치정보 관리
	 * @param String cmdGbn
	 * @throws Exception
	 */
	public String selectProxyTotServerChk(String cmdGbn) throws Exception {
		Map<String, Object> param = new HashMap<String, Object>();
		JSONObject searchObj = new JSONObject();
		JSONObject jObjResult = null;
		String returnData = "";

		try {
			//1. proxy conf 위치
			param = paramLoadSetting(cmdGbn, "", ""); //param setting

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
}