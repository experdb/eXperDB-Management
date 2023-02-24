package com.k4m.dx.tcontrol.socket.listener;

import java.io.FileInputStream;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.ApplicationContext;
import org.springframework.util.ResourceUtils;

import com.experdb.proxy.db.repository.service.ProxyServiceImpl;
import com.experdb.proxy.db.repository.vo.ProxyServerVO;
import com.k4m.dx.tcontrol.db.SqlSessionManager;
import com.k4m.dx.tcontrol.db.repository.service.SystemServiceImpl;
import com.k4m.dx.tcontrol.db.repository.vo.DbServerInfoVO;
import com.k4m.dx.tcontrol.server.SocketExt;
import com.k4m.dx.tcontrol.socket.ProtocolID;
import com.k4m.dx.tcontrol.util.AES256;
import com.k4m.dx.tcontrol.util.AES256_KEY;
import com.k4m.dx.tcontrol.util.FileUtil;

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
*  2022.02.01	강병석		프록시 기능 추가
*      </pre>
*/
public class ServerCheckListener extends Thread {

	// private SystemServiceImpl service;
	ApplicationContext context = null;
	private Logger socketLogger = LoggerFactory.getLogger("socketLogger");
	private Logger errLogger = LoggerFactory.getLogger("errorToFile");

	public ServerCheckListener(ApplicationContext context) throws Exception {
		this.context = context;
	}

	@Override
	public void run() {
		int i = 0;
		
		//에이전트 설정 파일
		Properties prop = new Properties();
		try {
			prop.load(new FileInputStream(ResourceUtils.getFile("/experdb/app/eXperDB-Management/eXperDB-Management-Agent/classes/context.properties")));
		} catch (IOException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		


		while (!Thread.interrupted()) {
			SystemServiceImpl service = (SystemServiceImpl) context.getBean("SystemService");
			ProxyServiceImpl pry_service = (ProxyServiceImpl) context.getBean("ProxyService");
			
			try {
				String strIpadr = FileUtil.getPropertyValue("context.properties", "agent.install.ip");
				
				//매니지먼트 기능
				//프록시 서버 분리시 매니지먼트 기능 미사용
				if("N".equals(prop.getProperty("proxy.global.serveryn"))){
					//에이전트 서버 IP
								
					DbServerInfoVO vo = new DbServerInfoVO();
					vo.setIPADR(strIpadr);
					
					//IP가 동일한 DB 조회
					DbServerInfoVO dbServerInfoVO = service.selectDatabaseConnInfo(vo);
	
					String IPADR = dbServerInfoVO.getIPADR();
					int PORTNO = dbServerInfoVO.getPORTNO();
					String DB_SVR_NM = dbServerInfoVO.getDB_SVR_NM();
					String DFT_DB_NM = dbServerInfoVO.getDFT_DB_NM();
					String SVR_SPR_USR_ID = dbServerInfoVO.getSVR_SPR_USR_ID();
					String SVR_SPR_SCM_PWD = dbServerInfoVO.getSVR_SPR_SCM_PWD();
					
					AES256 aes = new AES256(AES256_KEY.ENC_KEY);
					
					//조회 DB 내용을 담는 JObject 
					JSONObject serverObj = new JSONObject();
	
					serverObj.put(ProtocolID.SERVER_NAME, DB_SVR_NM);
					serverObj.put(ProtocolID.SERVER_IP, IPADR);
					serverObj.put(ProtocolID.SERVER_PORT, PORTNO);
					serverObj.put(ProtocolID.DATABASE_NAME, DFT_DB_NM);
					serverObj.put(ProtocolID.USER_ID, SVR_SPR_USR_ID);
					serverObj.put(ProtocolID.USER_PWD, aes.aesDecode(SVR_SPR_SCM_PWD));
	
					String strMasterGbn = "";
					String strIsMasterGbn = "";
	
					// socketLogger.info("@@@@@@ before : " + strMasterGbn + " @@@@ after : " + strMasterGbn);
	
					//DB 마스터/슬레이브 판별, 상태 변경
					try {
						strMasterGbn = selectConnectInfo(serverObj);
	
						DbServerInfoVO masterGbnVo = new DbServerInfoVO();
						masterGbnVo.setIPADR(strIpadr);
						
						//대상 DB가 마스터인지 판별
						DbServerInfoVO resultMasterGbnVO = service.selectISMasterGbm(masterGbnVo);
						strIsMasterGbn = resultMasterGbnVO.getMASTER_GBN();
	
						dbServerInfoVO.setMASTER_GBN(strMasterGbn);
						dbServerInfoVO.setDB_CNDT("Y");
	
						if (resultMasterGbnVO.getDB_CNDT().equals("N")) {
							service.updateDB_CNDT(dbServerInfoVO);
						}
	
						//socketLogger.info("@@@@@@ before : " + strMasterGbn + " @@@@ after : " + strMasterGbn);
						
						//DB 판별, 상태 변경
						if (!strIsMasterGbn.equals(strMasterGbn)) {
							if (strMasterGbn.equals("M")) {
								service.updateDBSlaveAll(dbServerInfoVO);
							}
	
							service.updateDB_CNDT(dbServerInfoVO);
						}
						
	
					} catch (Exception e) {
						errLogger.error("Master/Slave Check Error {}", e.toString());
						// socketLogger.info("@@@@@@ err : " + e.toString());
						strMasterGbn = "S";
						dbServerInfoVO.setMASTER_GBN(strMasterGbn);
						dbServerInfoVO.setDB_CNDT("N");
						
						service.updateDB_CNDT(dbServerInfoVO);
					}

					serverObj = null;
					aes = null;
				}
				

				
				//에이전트 프록시 기능
				//프록시 미사용시 기능 미실행
				if("Y".equals(prop.getProperty("agent.proxy_yn"))) {
					//프록시 관련 기능
					String proxySetYn = "";
					String proxySetStatus = "";
					String keepalivedSetStatus = "";
					
					//선행조건 설정
					//1. proxy 서버 등록 확인
					ProxyServerVO searchProxyServerVO = new ProxyServerVO();
					searchProxyServerVO.setIpadr(strIpadr);
					
					//proxy 서버 등록 여부 확인
					ProxyServerVO proxyServerInfo = pry_service.selectPrySvrInfo(searchProxyServerVO);
					
					//roxy 설치여부 및 keepalived 설치확인
					proxySetStatus = pry_service.selectProxyTotServerChk("proxy_setting_tot", "");
					keepalivedSetStatus = pry_service.selectProxyTotServerChk("keepalived_setting_tot", "");
					
					//서버 등록 시만  logic 실행
					if (proxyServerInfo != null) {
						proxySetYn = "true";
					}
					
					
					//proxy 설치되어 있는 경우 실행
					if (!"".equals(proxySetStatus) && !"not installed".equals(proxySetStatus)) {
						if ("true".equals(proxySetYn)) {
							procyExecuteRealCheck(strIpadr, proxySetStatus, keepalivedSetStatus, proxyServerInfo);
						}
					}
					
				}

				try {
					//실시간 상태 체크 주기
					Thread.sleep(7000);
				} catch (InterruptedException ex) {
					this.interrupt();
					continue;
				}

			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				service = null;
			}
		}

	}
	
	//프록시 실시간 체크
	private String procyExecuteRealCheck(String strIpar, String proxySetStatus, String keepalivedSetStatus, ProxyServerVO proxyServerInfo) throws Exception {
		//socketLogger.info("Job procyExecuteRealCheck []");
		String returnMsg = "";

		ProxyServiceImpl service = (ProxyServiceImpl) context.getBean("ProxyService");

    	try {
			Map<String, Object> chkParam = new HashMap<String, Object>();
			chkParam.put("ipadr", strIpar);
			chkParam.put("proxySetStatus",proxySetStatus);
			chkParam.put("keepalivedSetStatus",keepalivedSetStatus);
			chkParam.put("real_ins_gbn", "dbchk");

			//마스터 실시간 체크
			returnMsg = service.proxyMasterGbnRealCheck(chkParam, proxyServerInfo); 	

			//리스너 및  vip 상태 체크
			returnMsg = service.proxyStatusChk(chkParam);
			socketLogger.info("Job procyExecuteRealCheck [OK]");
			
			//db 실시간 등록
			//returnMsg = service.proxyDbmsStatusChk(chkParam); 	
        } catch(Exception e) {
        	socketLogger.info("Job procyExecuteRealCheck [BAD]");
            e.printStackTrace();
        }  

		return returnMsg;

	}

	private String selectConnectInfo(JSONObject serverInfoObj) throws Exception {
		SqlSessionFactory sqlSessionFactory = null;
		sqlSessionFactory = SqlSessionManager.getInstance();
		String poolName = "" + serverInfoObj.get(ProtocolID.SERVER_IP) + "_" + serverInfoObj.get(ProtocolID.DATABASE_NAME) + "_" + serverInfoObj.get(ProtocolID.SERVER_PORT);

		Connection connDB = null;
		SqlSession sessDB = null;
		String strMasterGbn = "";

		try {
			SocketExt.setupDriverPool(serverInfoObj, poolName);

			// DB 컨넥션을 가져온다.
			connDB = DriverManager.getConnection("jdbc:apache:commons:dbcp:" + poolName);

			sessDB = sqlSessionFactory.openSession(connDB);
			HashMap hp = (HashMap) sessDB.selectOne("app.selectMasterGbm");
			strMasterGbn = (String) hp.get("master_gbn");
			
			sessDB.close();
			connDB.close();
		} catch (Exception e) {
			throw e;
		} finally {
			if(sessDB !=null) sessDB.close();
			if(connDB !=null) connDB.close();
		}
		return strMasterGbn;
	}
}
