package com.experdb.proxy.socket.listener;

import java.util.HashMap;
import java.util.Map;

import org.codehaus.jettison.json.JSONObject;
import org.quartz.Scheduler;
import org.quartz.SchedulerFactory;
import org.quartz.impl.StdSchedulerFactory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.transaction.annotation.Transactional;

import com.experdb.proxy.db.repository.service.ProxyServiceImpl;
import com.experdb.proxy.db.repository.service.SystemServiceImpl;
import com.experdb.proxy.db.repository.vo.AgentInfoVO;
import com.experdb.proxy.db.repository.vo.ProxyServerVO;
import com.experdb.proxy.socket.SocketCtl;
import com.experdb.proxy.util.FileUtil;
import com.experdb.proxy.util.StrUtil;
 
public class DXTcontrolProxy extends SocketCtl {
	private SchedulerFactory schedulerFactory = null;
	private Scheduler scheduler = null;
	private static ApplicationContext context;

	private Logger socketLogger = LoggerFactory.getLogger("socketLogger");
	private Logger errLogger = LoggerFactory.getLogger("errorToFile");
	
	public static void main(String[] args) {   
		DXTcontrolProxy dXTcontrolProxy = new DXTcontrolProxy();
		dXTcontrolProxy.start();
	}

	public DXTcontrolProxy() {
		try {
			schedulerFactory = new StdSchedulerFactory();
			scheduler = schedulerFactory.getScheduler();
		} catch(Exception e) {
			e.printStackTrace();
		}
	}

	public void start() {
		String proxyServerChk = "";

		AgentInfoVO agtVo = new AgentInfoVO();

		context = new ClassPathXmlApplicationContext(new String[] {"context-tcontrol.xml"});
		ProxyServiceImpl service = (ProxyServiceImpl) context.getBean("ProxyService");
		SystemServiceImpl systemService = (SystemServiceImpl) context.getBean("SystemService");
		
		try {
			//선행조건  proxy 설치 확인
			proxyServerChk = service.selectProxyServerChk("proxy_conf_which");

			String strIpadr = FileUtil.getPropertyValue("context.properties", "agent.install.ip");
			String strPort = FileUtil.getPropertyValue("context.properties", "socket.server.port");
			String strKeepalived = FileUtil.getPropertyValue("context.properties", "keepalived.install.yn");

			agtVo.setIpadr(strIpadr);
			AgentInfoVO agentInfoVO = systemService.selectPryAgtInfo(agtVo);

			//proxy 설치시 테이블 insert 실행
			//D의 경우 사용자 삭제로 자동등록 실행 안함
			if (proxyServerChk != null && agentInfoVO != null) {
				if (!"".equals(proxyServerChk) && ("".equals(agentInfoVO.getSvr_use_yn()) || !"D".equals(agentInfoVO.getSvr_use_yn()))) {
					//proxy 서버일때 데이터 추가해야함
					confSetProxyExecute(strIpadr, strPort, strKeepalived);
				}
			}

		} catch(Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * proxy 데이터 생성 및 등록
	 * @param dbServerInfo
	 * @throws Exception
	 */
	@Transactional
	public String confSetProxyExecute(String strIpadr, String strPort, String strKeepalived) throws Exception {
		ProxyServerVO searchProxyServerVO = new ProxyServerVO();
		searchProxyServerVO.setIpadr(strIpadr);

		Map<String, Object> param = new HashMap<String, Object>();
		ProxyServerVO vo = new ProxyServerVO();
		String returnMsg = "";

		ProxyServiceImpl pryService = (ProxyServiceImpl) context.getBean("ProxyService");
		SystemServiceImpl systemService = (SystemServiceImpl) context.getBean("SystemService");

		Map<String, Object> insertParam = new HashMap<String, Object>();
		
		try {
			String proxyPathData = "";
			String KeepPathData = "";
			int dbSvrIdData = 0;
			int peerIdData = 0;
			String dbSvrNmData = "";
			String peerIpData = "";
			String back_peerIpData = "";
			String masterGbnData = "";
			String old_masterGbnData = "";
			String upd_masterGbnData = "";
			String proxyExeStaus = "";		//proxy 상태
			String keepExeStaus = "";		//keepalived 상태
			String prySvrUseYn = "N";		//pry_svr_사용여부
			String proxySvrNmData = "";		//pry svr 명

			String insUpNmGbn = "";

			String strMaxConn = "";
			String strTimeClient = "";
			String strTimeConnect = "";
			String strTimeServer = "";
			String strTimeCheck = "";
			String stateMasterInterface = "";
			String strObjIp = "";
			String strPeerServerIp = "";

			String strlisnerList="";
			String strlisnerSvrList="";
			String strVipConfList="";
			String strKeepInstallYn = "";

			JSONObject jObjResult = null;
			JSONObject jObjKeepResult = null;
			socketLogger.info("ProxyServiceImpl.searchProxyServerVO : " + strIpadr);
			//proxy 서버 등록 여부 확인
			ProxyServerVO proxyServerInfo = pryService.selectPrySvrInfo(searchProxyServerVO);
			socketLogger.info("ProxyServiceImpl.proxyServerInfo : " + proxyServerInfo);
			//keepalived 설치 상태
			strKeepInstallYn = strKeepalived;

			//1. proxy conf 위치
			proxyPathData = pryService.selectProxyServerChk("proxy_conf_which"); //param setting

			//2. keepalived conf 위치
			KeepPathData = pryService.selectProxyServerChk("keep_conf_which"); //param setting

			//proxy conf 존재일 경우 만 등록
			if (proxyPathData != null) {
				jObjResult = pryService.selectProxyServerList("proxy_conf_read", proxyPathData, strIpadr,""); //proxy conf setting

				if (jObjResult.length() > 0) {
					dbSvrIdData = ((Integer)jObjResult.get("db_svr_id")).intValue();
					dbSvrNmData = (String)jObjResult.get("db_svr_nm");

					//global
					strMaxConn = (String)jObjResult.get("max_conn");
					strTimeClient = (String)jObjResult.get("time_client");
					strTimeConnect = (String)jObjResult.get("time_connect");
					strTimeServer = (String)jObjResult.get("time_server");
					strTimeCheck = (String)jObjResult.get("time_check");

					//list
					strlisnerList = (String)jObjResult.get("lisner_list");
					strlisnerSvrList = (String)jObjResult.get("lisner_svr_list");

				} else {
					dbSvrIdData = 0;
					dbSvrNmData = "";

					//global
					strMaxConn = "";
					strTimeClient = "";
					strTimeConnect = "";
					strTimeServer = "";
					strTimeCheck = "";

					strlisnerList = "";
					strlisnerSvrList = "";
				}
			}
			/////////////////////////////////////////////////////////////////////

			//4. keepalived conf 열기
			if (strKeepInstallYn != null && "Y".equals(strKeepInstallYn)) {
				jObjKeepResult = pryService.selectProxyServerList("keepalived_conf_read", KeepPathData, strIpadr,""); //param setting

				if (jObjKeepResult.length() > 0) {
					peerIpData = (String)jObjKeepResult.get("peer_id");
					masterGbnData = (String)jObjKeepResult.get("master_gbn");

					stateMasterInterface = (String)jObjKeepResult.get("if_nm");
					strObjIp = (String)jObjKeepResult.get("obj_ip");
					strPeerServerIp = (String)jObjKeepResult.get("peer_server_ip");

					strVipConfList = (String)jObjKeepResult.get("vip_conf_list");

					back_peerIpData = (String)jObjKeepResult.get("back_peer_id");
					
				} else {
					peerIpData = "";
					masterGbnData = "M";

					stateMasterInterface = "";
					strObjIp = "";
					strPeerServerIp = "";

					strVipConfList = "";
					
					back_peerIpData = "";
				}
			} else {
				peerIpData = "";
				masterGbnData = "M"; //무조건 마스터가 됨

				stateMasterInterface = "";
				strObjIp = ""; //
				strPeerServerIp = "";

				strVipConfList = "";
				
				back_peerIpData = "";
			}
			/////////////////////////////////////////////////////////////////////
			socketLogger.info("ProxyServiceImpl.masterGbnDatamasterGbnData : " + masterGbnData);
			//5. proxy 실행상태
			if (proxyPathData != null) {
				proxyExeStaus = pryService.selectProxyServerChk("proxy_setting_tot"); //param setting
				if (proxyExeStaus != null) {
					proxyExeStaus = proxyExeStaus.trim();
					if ("running".equals(proxyExeStaus)) {
						proxyExeStaus = "TC001501";
					} else {
						proxyExeStaus = "TC001502";
					}
				} else {
					proxyExeStaus = "TC001502";
				}
			}
			/////////////////////////////////////////////////////////////////////

			//6. keepalived 실행상태
			if (strKeepInstallYn != null && "Y".equals(strKeepInstallYn)) {
				keepExeStaus = pryService.selectProxyServerChk("keepalived_setting_tot"); //param setting
				if (keepExeStaus != null) {
					keepExeStaus = keepExeStaus.trim();
					if ("running".equals(keepExeStaus)) {
						keepExeStaus = "TC001501";
					} else {
						keepExeStaus = "TC001502";
					}
				} else {
					keepExeStaus = "TC001502";
				}

				//사용여부
				if ("TC001501".equals(keepExeStaus) && "TC001501".equals(keepExeStaus)) {
					prySvrUseYn = "Y";
				} else {
					prySvrUseYn = "N";
				}
			} else {
				keepExeStaus = "";
				prySvrUseYn = "";
			}
			/////////////////////////////////////////////////////////////////////

			////////////////////////////////////PRY_SVR_NM 설정//////////////////////////////
			if (masterGbnData != null) {
				if ("M".equals(masterGbnData)) {
					if (strKeepInstallYn != null && "Y".equals(strKeepInstallYn)) {
						proxySvrNmData = dbSvrNmData + "_proxy_1";
					} else {
						searchProxyServerVO.setDb_svr_id(((Integer)jObjResult.get("db_svr_id")).intValue());
						
						ProxyServerVO proxyServerVOBack = systemService.selectDBMSSvrMaxNmInfo(searchProxyServerVO);
						
						if (proxyServerVOBack == null) {
							proxySvrNmData = dbSvrNmData + "_proxy_1";
						} else {
							String masterSvrNm = "";
							String masterSvrFirst = "";
							int iMasterSvrEnd = 0;
							
							ProxyServerVO masterProxyServerInfo = pryService.selectPrySvrInfo(searchProxyServerVO);

							if (masterProxyServerInfo != null && masterProxyServerInfo.getPry_svr_nm() != null && !"".equals(masterProxyServerInfo.getPry_svr_nm())) {
								proxySvrNmData = masterProxyServerInfo.getPry_svr_nm();
							} else {
								if (proxyServerVOBack.getPry_svr_nm() != null && !"".equals(proxyServerVOBack.getPry_svr_nm())) {
									masterSvrNm = proxyServerVOBack.getPry_svr_nm();

									masterSvrFirst = masterSvrNm.substring(0 , masterSvrNm.lastIndexOf("_")+1);
									iMasterSvrEnd = Integer.parseInt((masterSvrNm.substring(masterSvrNm.lastIndexOf("_") + 1 , masterSvrNm.length()))) + 1;
									proxySvrNmData = masterSvrFirst + Integer.toString(iMasterSvrEnd);
								} else {
									proxySvrNmData = dbSvrNmData + "_proxy_1";
								}
							}
						}	
					}
				} else {
					ProxyServerVO proxyServerVOBack = systemService.selectPrySvrMaxNmInfo(searchProxyServerVO);

					if (proxyServerVOBack == null) {
						proxySvrNmData = dbSvrNmData + "_proxy_2";
					} else {
						String masterSvrNm = "";
						String masterSvrFirst = "";
						int iMasterSvrEnd = 0;
						
						ProxyServerVO masterProxyServerInfo = pryService.selectPrySvrInfo(searchProxyServerVO);

						if (masterProxyServerInfo != null && masterProxyServerInfo.getPry_svr_nm() != null && !"".equals(masterProxyServerInfo.getPry_svr_nm())) {
							proxySvrNmData = masterProxyServerInfo.getPry_svr_nm();
						} else {
							if (proxyServerVOBack.getPry_svr_nm() != null && !"".equals(proxyServerVOBack.getPry_svr_nm())) {
								masterSvrNm = proxyServerVOBack.getPry_svr_nm();

								masterSvrFirst = masterSvrNm.substring(0 , masterSvrNm.lastIndexOf("_")+1);
								iMasterSvrEnd = Integer.parseInt((masterSvrNm.substring(masterSvrNm.lastIndexOf("_") + 1 , masterSvrNm.length()))) + 1;
								proxySvrNmData = masterSvrFirst + Integer.toString(iMasterSvrEnd);
							} else {
								proxySvrNmData = dbSvrNmData + "_proxy_2";
							}
						}
					}
				}
				
				
			}

			//master svr id
			if (peerIpData != null) {
				searchProxyServerVO.setIpadr(peerIpData);

				ProxyServerVO masterProxyServerInfo = pryService.selectPrySvrInslInfo(searchProxyServerVO);
				if (masterProxyServerInfo != null) {
					peerIdData = masterProxyServerInfo.getPry_svr_id();
				}
			}

			//proxy 서버 저장
			vo.setIpadr(strIpadr);
			vo.setPry_pth(proxyPathData);
			
			if (strKeepInstallYn != null && "Y".equals(strKeepInstallYn)) {
				vo.setKal_install_yn("Y");
				vo.setKal_pth(KeepPathData);
				
			} else {
				vo.setKal_install_yn("N");
				vo.setKal_pth(null);
			}

			vo.setDb_svr_id(dbSvrIdData);
			
			vo.setFrst_regr_id("system");
			vo.setLst_mdfr_id("system");

			vo.setExe_status(proxyExeStaus);
			vo.setKal_exe_status(keepExeStaus);
			vo.setUse_yn(prySvrUseYn);
			
			searchProxyServerVO.setDb_svr_id(((Integer)jObjResult.get("db_svr_id")).intValue());
			searchProxyServerVO.setIpadr(strIpadr);
		
			ProxyServerVO proxyOldServerInfo = systemService.selectDBMSSvrEtcMaxNmInfo(searchProxyServerVO);

			//old_master_gbn setting
			if (strKeepInstallYn != null && "Y".equals(strKeepInstallYn)) {
				old_masterGbnData = masterGbnData;
			} else {
				if (proxyOldServerInfo != null) {
					if (proxyOldServerInfo.getPry_svr_nm() != null && !"".equals(proxyOldServerInfo.getPry_svr_nm())) {
						old_masterGbnData = "S";
					} else {
						old_masterGbnData = "M";
					}
				} else {
					old_masterGbnData = "M";
				}
			}
			
			if (proxyOldServerInfo == null) {
				upd_masterGbnData = "M";
			} else {
				upd_masterGbnData = "S";
			}

			//null 이면 insert(t_pry_svr_i)
			if(proxyServerInfo == null) {
				vo.setDay_data_del_term(30);
				vo.setMin_data_del_term(3);
				vo.setPry_svr_nm(proxySvrNmData);
				vo.setMaster_gbn(masterGbnData);
				vo.setOld_master_gbn(old_masterGbnData);

				if (peerIdData != 0) {
					vo.setMaster_svr_id_chk(Integer.toString(peerIdData));
				} else {
					vo.setMaster_svr_id_chk(null);
				}
				
				vo.setBack_peer_id(back_peerIpData);

				insUpNmGbn = "proxySvrIns";
			} else { //null 이 아니면 false
				vo.setPry_svr_id(proxyServerInfo.getPry_svr_id()); //proxy server id
				
				if (vo.getPry_pth() == null) {
					vo.setPry_pth(proxyServerInfo.getPry_pth());
				}
	
				if (vo.getKal_pth() == null) {
					vo.setKal_pth(proxyServerInfo.getKal_pth());
				}

				vo.setAgt_sn(proxyServerInfo.getAgt_sn());
				vo.setDay_data_del_term(StrUtil.nvlIntChg(proxyServerInfo.getDay_data_del_term(),30));
				vo.setMin_data_del_term(StrUtil.nvlIntChg(proxyServerInfo.getMin_data_del_term(),3));
				vo.setPry_svr_nm(proxySvrNmData);

				vo.setMaster_gbn(masterGbnData);
				vo.setOld_master_gbn(old_masterGbnData);
				vo.setUpd_master_gbn(upd_masterGbnData);
				
			//	vo.setMaster_gbn(proxyServerInfo.getMaster_gbn());
				Integer master_svr_id_num = proxyServerInfo.getMaster_svr_id();
				socketLogger.info("strKeepInstallYn : " + master_svr_id_num);
				if (strKeepInstallYn != null && "Y".equals(strKeepInstallYn)) {
					socketLogger.info("master_svr_id_nummaster_svr_id_num : " + master_svr_id_num);
					if (master_svr_id_num != null) {
						if (master_svr_id_num > 0) {
							vo.setMaster_svr_id_chk( Integer.toString(proxyServerInfo.getMaster_svr_id()));
						} else {
							if (peerIdData != 0) {
								vo.setMaster_svr_id_chk("Y");
							} else {
								vo.setMaster_svr_id_chk(null);
							}
						}
					} else {
						if (peerIdData != 0) {
							vo.setMaster_svr_id_chk("Y");
						} else {
							vo.setMaster_svr_id_chk(null);
						}
					}
				} else {
					vo.setMaster_svr_id_chk(null);
				}
				socketLogger.info("peerIdData : " + peerIdData);
				socketLogger.info("vo.getMaster_svr_id_chkgetMaster_svr_id_chkgetMaster_svr_id_chk() : " + vo.getMaster_svr_id_chk());
				vo.setBack_peer_id(null);

				insUpNmGbn = "proxySvrUdt";
			}
			//////////////////////////////////////////////////////////////////

			//global setting
			if (strMaxConn != null) {
				insertParam.put("max_conn", strMaxConn);
				insertParam.put("time_client", strTimeClient);
				insertParam.put("time_connect", strTimeConnect);
				insertParam.put("time_server", strTimeServer);
				insertParam.put("time_check", strTimeCheck);
				insertParam.put("if_nm", stateMasterInterface);
				insertParam.put("obj_ip", strObjIp);
				insertParam.put("peer_server_ip", strPeerServerIp);

				insertParam.put("lisner_list", strlisnerList);
				insertParam.put("lisner_svr_list", strlisnerSvrList);
				insertParam.put("vip_conf_list", strVipConfList);
			} else {
				insertParam.put("max_conn", "");
				insertParam.put("time_client", "");
				insertParam.put("time_connect", "");
				insertParam.put("time_server", "");
				insertParam.put("time_check", "");
				insertParam.put("if_nm", "");
				insertParam.put("obj_ip", "");
				insertParam.put("peer_server_ip", "");
				
				insertParam.put("lisner_list", "");
				insertParam.put("lisner_svr_list", "");
				insertParam.put("vip_conf_list", "");
			}

			if (proxyPathData != null) {
				returnMsg = pryService.proxyConfFisrtIns(vo, insUpNmGbn, insertParam);
			}
		} catch (Exception e) {
			errLogger.error("DXTcontrolProxy {} ", e.toString());
			returnMsg = "false";
		}
		return returnMsg;
	}
}