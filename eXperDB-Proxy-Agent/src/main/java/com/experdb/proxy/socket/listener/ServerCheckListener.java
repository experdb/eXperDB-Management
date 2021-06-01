package com.experdb.proxy.socket.listener;

import java.util.HashMap;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.ApplicationContext;

import com.experdb.proxy.db.repository.service.ProxyServiceImpl;
import com.experdb.proxy.db.repository.vo.ProxyServerVO;
import com.experdb.proxy.util.FileUtil;

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

		while (!Thread.interrupted()) {

			ProxyServiceImpl service = (ProxyServiceImpl) context.getBean("ProxyService");
			
			try {
				String strIpadr = FileUtil.getPropertyValue("context.properties", "agent.install.ip");

				String proxySetYn = "";
				String proxySetStatus = "";
				String keepalivedSetStatus = "";

				//선행조건 설정
				//1. proxy 서버 등록 확인
				ProxyServerVO searchProxyServerVO = new ProxyServerVO();
				searchProxyServerVO.setIpadr(strIpadr);
				
				//proxy 서버 등록 여부 확인
				ProxyServerVO proxyServerInfo = service.selectPrySvrInfo(searchProxyServerVO);
				
				//roxy 설치여부 및 keepalived 설치확인
				proxySetStatus = service.selectProxyTotServerChk("proxy_setting_tot", "");
				keepalivedSetStatus = service.selectProxyTotServerChk("keepalived_setting_tot", "");
				
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

				i++;

				try {
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
	
	//실시간 체크
	private String procyExecuteRealCheck(String strIpar, String proxySetStatus, String keepalivedSetStatus, ProxyServerVO proxyServerInfo) throws Exception {
		socketLogger.info("Job procyExecuteRealCheck []");
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
			
			//db 실시간 등록
			returnMsg = service.proxyDbmsStatusChk(chkParam); 	
        } catch(Exception e) {
            e.printStackTrace();
        }  

		return returnMsg;

	}
}