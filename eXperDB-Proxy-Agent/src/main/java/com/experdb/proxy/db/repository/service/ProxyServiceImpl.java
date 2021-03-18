package com.experdb.proxy.db.repository.service;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
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

import com.experdb.proxy.db.repository.dao.SystemDAO;
import com.experdb.proxy.db.repository.vo.AgentInfoVO;
import com.experdb.proxy.db.repository.vo.DbServerInfoVO;
import com.experdb.proxy.db.repository.vo.ProxyGlobalVO;
import com.experdb.proxy.db.repository.vo.ProxyListenerServerListVO;
import com.experdb.proxy.db.repository.vo.ProxyListenerVO;
import com.experdb.proxy.db.repository.vo.ProxyServerVO;
import com.experdb.proxy.db.repository.vo.ProxyVipConfigVO;
import com.experdb.proxy.socket.ProtocolID;
import com.experdb.proxy.util.FileRunCommandExec;
import com.experdb.proxy.util.RunCommandExec;
import com.sun.org.apache.xerces.internal.impl.xpath.regex.ParseException;

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

	private Logger socketLogger = LoggerFactory.getLogger("socketLogger");
	private Logger errLogger = LoggerFactory.getLogger("errorToFile");

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
			
			socketLogger.info("returnDatareturnDatareturnData.strResultSubMessge : " + returnData);
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
	public ProxyServerVO selectProxyServerInfo(ProxyServerVO vo)  throws Exception {
		return (ProxyServerVO) systemDAO.selectProxyServerInfo(vo);
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

			RunCommandExec r = new RunCommandExec(proxyCmd);
			//명령어 실행
			r.run();

			try {
				r.join();
			} catch (InterruptedException ie) {
				ie.printStackTrace();
			}

			String retVal = r.call();
			String strResultMessge = r.getMessage();
			String strResultSubMessge = "";

			if (retVal.equals("success")) {				
				if (!strResultMessge.isEmpty()) {
					if (searchGbn.equals("proxy_conf_which") || searchGbn.equals("keep_conf_which") || searchGbn.equals("proxy_exe_status") || searchGbn.equals("keepalived_exe_status")) {
					//	strResultSubMessge = strResultMessge.substring(0,strResultMessge.lastIndexOf("/"));
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
			List<DbServerInfoVO> serverInfoList = systemDAO.selectDatabaseMasterConnInfo(dbServerInfoVO);
			
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
					ProxyVipConfigVO vipConfVo = new ProxyVipConfigVO();
					ProxyListenerVO lisnerVoView = new ProxyListenerVO();
					
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
							//	socketLogger.info("stateGbn.strMaxConn1231232 :" + strMaxConn);
					        } else if(temp.trim().matches(".*time.*")) { //timeout client / connect / server / check
					        //	socketLogger.info("stateGbn.temptemptemptemptemptemp : " + temp);
					        	if (temp != null) {
					        		if(temp.trim().matches(".*timeout client.*")) { //timeout client
					        			strTimeClient = temp.substring(temp.lastIndexOf(" ") + 1 , temp.length());
					        		} else if(temp.trim().matches(".*timeout connect.*")) { //timeout connect
					        			strTimeConnect = temp.substring(temp.lastIndexOf(" ") + 1 , temp.length());
					        			iTimeConnectChk = size + 1;
					        			
					        		} else if(temp.trim().matches(".*timeout server.*")) { //timeout server
					        			strTimeServer = temp.substring(temp.lastIndexOf(" ") + 1 , temp.length());
					        		} else if(temp.trim().matches(".*timeout check.*")) { //timeout check
					        			strTimeCheck = temp.substring(temp.lastIndexOf(" ") + 1 , temp.length());
					        		}
					        	}
					        }
					        
					        if (iTimeConnectChk == size) {
						        strTimeServer = temp.substring(temp.lastIndexOf(" ") + 1 , temp.length());
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
					        	temp = temp.replace(temp.substring(temp.lastIndexOf("#"), temp.length()), "");
					        	temp = StringUtils.removeEnd(temp, " ");
					        	temp = getHexToString(temp.substring(temp.lastIndexOf(" ") + 1 , temp.length()));

					        	if (lisnerUserCnt == size) { //db user nm
					        		lisnerVo.setDb_usr_id(temp);
					        	} else if (lisnerDbNmCnt == size) { //db nm
					        		lisnerVo.setDb_nm(temp);
					        	} else if (lisnerSimQueryCnt1 == size) { //SimQuery1
					        		lisnerVo.setCon_sim_query(temp);
					        	} else if (lisnerSimQueryCnt2 == size) { //SimQuery2
					        		lisnerVo.setCon_sim_query(lisnerVo.getCon_sim_query() + " " + temp);
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
					        	String strServerBackList = temp.substring(temp.lastIndexOf(" ") + 1 , temp.length());
					        	if ("backup".equals(strServerBackList)) { //LISNER SVR BACKUP
					        		lisnerSebuVo.setBackup_yn("Y");
					        	} else {
					        		lisnerSebuVo.setBackup_yn("N");
					        	}

					        	temp = temp.replace("backup", "");
					        	temp = StringUtils.removeEnd(temp, " ");
					        	
					        	String serverPorttemp = temp.substring(temp.lastIndexOf(" ") + 1 , temp.length());

					        	if (!"".equals(serverPorttemp)) { //port
					        		lisnerSebuVo.setChk_portno_val(serverPorttemp);
					        	} else {
					        		lisnerSebuVo.setChk_portno_val(null);
					        	}

					        	//ip 체크
					        	 String serverIptemp = temp.substring(temp.indexOf(" check port"), temp.length());
					        	 
					        	temp = temp.replace(serverIptemp, "").replace("server ", "").trim();
					        	temp = StringUtils.removeEnd(temp, " ");
					        	temp = temp.substring(temp.indexOf(" ") + 1 , temp.length());
					        	lisnerSebuVo.setDb_con_addr(temp);
					        	
					        	lisnerSebuVo.setLsn_nm(lisnerVoView.getLsn_nm());
					        	lisnerSebuVo.setCon_bind_port(lisnerVoView.getCon_bind_port());
					 
					        	lisnerSvrSebuList.add(lisnerSebuVo);
					        	lisnerSebuVo = new ProxyListenerServerListVO();
					        }
						} else if ("keepalived_conf_read".equals(searchGbn)) {
							 if(temp.trim().matches(".*state.*")) {
								 keepCnt++;
							 }
							 
							 //vip - 설정////////////////////////////////////////////////////
							 if(temp.trim().matches(".*virtual_ipaddress.*")) {
								 vipAddCnt = size+1;
							 }
							 socketLogger.info("vipAddCnt.trim() :" + vipAddCnt);
							 socketLogger.info("size.trim() :" + size);
							 if (vipAddCnt == size) {
								 String strVip = temp.trim();
								
								 vipConfVo.setV_if_nm(strVip.trim().substring(strVip.lastIndexOf(" ") + 1 , strVip.length())); //interface -- vip 마지막
								 vipConfVo.setV_ip(strVip.substring(0, strVip.indexOf(" ")));
								 socketLogger.info("getV_if_nm.trim() :" + vipConfVo.getV_if_nm());
								 socketLogger.info("getV_ip.trim() :" + vipConfVo.getV_ip());
							 }

							 if(temp.trim().matches(".*virtual_router_id.*")) { //v_router_ip
								 vipConfVo.setV_rot_id(temp.substring(temp.lastIndexOf(" ") + 1 , temp.length()));
							 }

							 if(temp.trim().matches(".*piority.*")) { //piority
								 vipConfVo.setPriority(Integer.parseInt((temp.substring(temp.lastIndexOf(" ") + 1 , temp.length()))));
							 }

							 if(temp.trim().matches(".*advert_int.*")) { //advert_int
								vipConfVo.setChk_tm(Integer.parseInt((temp.substring(temp.lastIndexOf(" ") + 1 , temp.length()))));
							 }

							 if(temp.trim().matches(".*track_process.*")) { //advert_int
								vipConfList.add(vipConfVo);
					        	vipConfVo = new ProxyVipConfigVO();
							 }
							//////////////////////////////////////////////////////
						}
					}

					if (keepCnt > 0) {
						int firstState = 0;
						strArray = new String[strResultMessge.size()];
						for(String temp : strResultMessge){
							strArray[keepsize++] = temp;
							
							 if(temp.trim().matches(".*state.*")) {
								 firstState ++;
								 stateMaster = temp;
								 
								 vipConfVo.setState_nm(stateMaster); //state 명
							 }

							 //interface 명
							 if(temp.trim().matches(".*interface.*") && firstState == 1) {
								 stateInterface = temp;
							 }
					        	
				        	 
							 if(temp.trim().matches(".*unicast_src_ip.*") && firstState == 1) {
								 if (temp.trim().contains(serverIp)) {
									 stateGbn = stateMaster;

									 if (stateGbn != null) {
										 stateGbn = stateGbn.substring(stateGbn.lastIndexOf(" ") + 1 , stateGbn.length());
										 
										 peerInt = keepsize + 2;
										 peerchk = 1;
									 }

									 
									 //인터페이스 명 - global
									 if (stateInterface != null) {
										 stateMasterInterface = stateInterface.substring(stateInterface.lastIndexOf(" ") + 1 , stateInterface.length());
									 }

									 //대상_IP
									 strObjIp = serverIp;
									 socketLogger.info("strObjIpstrObjIpstrObjIpstrObjIp :" + strObjIp);
									 peerServerIpChk = 1;
								 
								 }
							 }
							 
								
							 //PEER_서버_IP
							 if(peerServerIpChk == 1 && temp.trim().matches(".*unicast_peer.*") && firstState == 1) {
								 peerServerIpInt = keepsize + 1;
							 }
					//		 socketLogger.info("peerServerIpChk :" + peerServerIpChk);
						//	 socketLogger.info("peerServerIpInt :" + peerServerIpInt);
							// socketLogger.info("size :" + size);
							 if (peerServerIpInt == keepsize && peerServerIpChk > 0  && firstState == 1) {
								 socketLogger.info("temptemp.999uiui :" + temp.trim());
								 strPeerServerIp = temp.trim();
								 peerServerIpChk = 0;
							 }	

							 //backup일때 peer id 확인
							 if (peerInt == keepsize && peerchk > 0  && firstState == 1) {
								 strPeerId = temp.trim();
								 peerchk = 0;
							 }
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
    		socketLogger.info("strMaxConn.trim() :" + strMaxConn.trim());
    		socketLogger.info("stateMasterInterface.trim() :" + stateMasterInterface.trim());
        	
        	jsonObj.put("db_svr_nm", db_svr_nm);
        	jsonObj.put("db_svr_id", db_svr_id);
        	jsonObj.put("master_gbn", stateGbn);
        	jsonObj.put("peer_id", strPeerId);
        	
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
			socketLogger.info("jsonLisnerSvrListjsonLisnerSvrListjsonLisnerSvrListjsonLisnerSvrList :" + jsonVipConfList);
        	//리스너 list
        	jsonObj.put("lisner_list", jsonLisnerSvrList);
        	
        	//리스너 server list
        	jsonObj.put("lisner_svr_list", jsonLisnerSvrSebuList);
    		socketLogger.info("jsonLisnerSvrListjsonLisnerSvrListjsonLisnerSvrLis4444tjsonLisnerSvrList :" + jsonVipConfList);
        	//vip list
        	jsonObj.put("vip_conf_list_num", jsonVipConfList);

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
	 * proxy 마지막 이름 조회
	 * @param ProxyServerVO
	 * @throws Exception
	 */
	public ProxyServerVO selectMaxAgentInfo(ProxyServerVO vo) throws Exception {
		return (ProxyServerVO) systemDAO.selectMaxAgentInfo(vo);
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
			try {
				if ("proxySvrIns".equals(insUpNmGbn)) {
					pry_svr_id_sn = systemDAO.selectQ_T_PRY_SVR_I_01();
					insPryVo.setPry_svr_id((int)pry_svr_id_sn);
	
					saveChkPrySvrI = systemDAO.insertT_PRY_SVR_I(insPryVo);
				} else if ("proxySvrUdt".equals(insUpNmGbn)) {
					saveChkPrySvrI = systemDAO.updateT_PRY_SVR_I(insPryVo);
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
					
					systemDAO.updateT_PRY_AGT_I_Yn(agtVo);
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
					proxyGlobalVO.setMax_con_cnt(Integer.parseInt(insertParam.get("max_conn").toString()));
					proxyGlobalVO.setMax_con_cnt(1000);
					proxyGlobalVO.setCl_con_max_tm(insertParam.get("time_client").toString());
					proxyGlobalVO.setCon_del_tm(insertParam.get("time_connect").toString());
					proxyGlobalVO.setSvr_con_max_tm(insertParam.get("time_server").toString());
					proxyGlobalVO.setChk_tm(insertParam.get("time_check").toString());
					proxyGlobalVO.setIf_nm(insertParam.get("if_nm").toString());
					proxyGlobalVO.setObj_ip(insertParam.get("obj_ip").toString());
					proxyGlobalVO.setPeer_server_ip(insertParam.get("peer_server_ip").toString());
					
					proxyGlobalVO.setLst_mdf_dtm("system");
					proxyGlobalVO.setFrst_regr_id("system");
					
					systemDAO.insertPryGlbI(proxyGlobalVO);
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
				        		schProxyListnerVO.setDb_nm(tempObj.get("db_nm").toString());
				        		schProxyListnerVO.setDb_usr_id(tempObj.get("db_usr_id").toString());
				        		schProxyListnerVO.setField_val(tempObj.get("field_val").toString());
				        		schProxyListnerVO.setField_nm(tempObj.get("field_nm").toString());
				        			
				        		schProxyListnerVO.setLst_mdfr_id("system");
				        		schProxyListnerVO.setFrst_regr_id("system");
				        			
				        		schProxyListnerVO.setDb_svr_id(insPryVo.getDb_svr_id());
				        		schProxyListnerVO.setLsn_nm(tempObj.get("lsn_nm").toString());

				        		ProxyListenerVO proxyListenerVO = systemDAO.selectProxyLisnerInfo(schProxyListnerVO);
				        			
				        		if (proxyListenerVO != null) {
				        			schProxyListnerVO.setLsn_id(proxyListenerVO.getLsn_id());
				        			schProxyListnerVO.setDb_id(proxyListenerVO.getDb_id());
				        			schProxyListnerVO.setLsn_desc(proxyListenerVO.getLsn_desc());
				        			
				        			socketLogger.info("setLsn_id : " + schProxyListnerVO.getLsn_id());
				        			socketLogger.info("setPry_svr_id : " + schProxyListnerVO.getPry_svr_id());
			        				
				        			systemDAO.updateT_PRY_LSN_I(schProxyListnerVO);
				        		} else {
				        			pry_lsn_id_sn = systemDAO.selectQ_T_PRY_SVR_I_01();

				        			schProxyListnerVO.setDb_id(Integer.parseInt(tempObj.get("db_id").toString()));
				        			schProxyListnerVO.setLsn_id((int)pry_lsn_id_sn);
				        			schProxyListnerVO.setLsn_desc("");
				        				
				        			systemDAO.insertT_PRY_LSN_I(schProxyListnerVO);
				        		}
					    	 } 
					     }
					     
					     JSONArray arrLisner_svr_list = new JSONArray(strLisner_svr_list);
					     socketLogger.info("tempObj.arrLisner_svr_listarrLisner_svr_listarrLisner_svr_listarrLisner_svr_list : " + arrLisner_svr_list.length());
					     if (arrLisner_svr_list.length() > 0 ) {
					    	 for(int i=0 ; i<arrLisner_svr_list.length() ; i++){
					    		JSONObject tempObj = (JSONObject) arrLisner_svr_list.get(i);

					    		ProxyListenerServerListVO schProxyListnerSebuVO = new ProxyListenerServerListVO();

			        			schProxyListnerSebuVO.setPry_svr_id(insPryVo.getPry_svr_id());
			        			schProxyListnerSebuVO.setDb_con_addr(tempObj.get("db_con_addr").toString());
			        			schProxyListnerSebuVO.setChk_portno_val(tempObj.get("chk_portno_val").toString());
			        			schProxyListnerSebuVO.setBackup_yn(tempObj.get("backup_yn").toString());
			        			schProxyListnerSebuVO.setCon_bind_port(tempObj.get("con_bind_port").toString());
			        			schProxyListnerSebuVO.setLsn_nm(tempObj.get("lsn_nm").toString());

			        			schProxyListnerSebuVO.setLst_mdfr_id("system");
			        			schProxyListnerSebuVO.setFrst_regr_id("system");

			        			systemDAO.deleteProxyLisnerSebuInfo(schProxyListnerSebuVO);
			        			systemDAO.insertProxyListnerSebu(schProxyListnerSebuVO);
					    	 } 
					     }
					     
					     socketLogger.info("tempObj.123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123 : " + strVip_conf_list);
					     
					     JSONArray arrVip_conf_list= new JSONArray(strVip_conf_list);
					     socketLogger.info("tempObj.arrVip_conf_listarrVip_conf_listarrVip_conf_listarrVip_conf_list : " + arrVip_conf_list.length());
					     if (arrVip_conf_list.length() > 0 ) {
					    	 for(int i=0 ; i<arrVip_conf_list.length() ; i++){
					    		JSONObject tempObj = (JSONObject) arrVip_conf_list.get(i);
					    		
					    		 socketLogger.info("tempObj.tempObjtempObjtempObjtempObj : " + tempObj.toString());

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

			        			systemDAO.insertPryvVipCngI(schProxyVipConfigVO);
					    	 } 
					     }
					     
					     socketLogger.info("123123123.arrarrarrarrarrarrarrarrarrarrarrarrarr : ");
					 } catch (JSONException e) {
					     e.printStackTrace();
					 } catch (ParseException e) {
						 e.printStackTrace();
					 }
				}
				
				
				

/*
				if (vipConfList != null && vipConfList.size() > 0) {
	        		for(int j=0; j<vipConfList.size(); j++){
	        			ProxyVipConfigVO schProxyVipConfigVO = new ProxyVipConfigVO();
	        			
	        			schProxyVipConfigVO.setPry_svr_id(insPryVo.getPry_svr_id());
	        			schProxyVipConfigVO.setState_nm(vipConfList.get(j).getState_nm());
	        			schProxyVipConfigVO.setV_ip(vipConfList.get(j).getV_ip());
	        			schProxyVipConfigVO.setV_rot_id(vipConfList.get(j).getV_rot_id());
	        			schProxyVipConfigVO.setV_if_nm(vipConfList.get(j).getV_if_nm());
	        			schProxyVipConfigVO.setPriority(vipConfList.get(j).getPriority());
	        			schProxyVipConfigVO.setChk_tm(vipConfList.get(j).getChk_tm());
	        			
	        			schProxyVipConfigVO.setLst_mdf_dtm("system");
	        			schProxyVipConfigVO.setFrst_regr_id("system");

	        			systemDAO.insertPryvVipCngI(schProxyVipConfigVO);
	        		}
				}*/
			} catch (Exception e) {
				errLogger.error("global {} ", e.toString());
				returnMsg = "false";
			}

			returnMsg = "success";
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
			} else if (searchGbn.equals("proxy_exe_status")) { //설치여부 체크
				strCmd = "systemctl status haproxy |grep Active: |cut -d ' ' -f 5";
			} else if (searchGbn.equals("keepalived_exe_status")) { //설치여부 체크
				strCmd = "systemctl status keepalived |grep Active: |cut -d ' ' -f 5";
			}
		} catch(Exception e) {
			e.printStackTrace();
		}

		return strCmd;
	}

	/**
	 * getStringToHex string--> hex 변환
	 * 
	 * @return String
	 * @throws UnsupportedEncodingException  
	 */
    public String getStringToHex(String testStr) throws UnsupportedEncodingException {
        byte[] testBytes = testStr.getBytes("UTF-8");
        return DatatypeConverter.printHexBinary(testBytes);
    }


	/**
	 * getHexToString hex--> string 변환
	 * 
	 * @return String
	 * @throws UnsupportedEncodingException  
	 */
    public String getHexToString(String testHex) throws UnsupportedEncodingException, DecoderException {
        // https://mvnrepository.com/artifact/commons-codec/commons-codec/1.10
        byte[] testBytes = Hex.decodeHex(testHex.toCharArray());
        return new String(testBytes, "UTF-8").replaceAll("\u0000", "");
    }

}