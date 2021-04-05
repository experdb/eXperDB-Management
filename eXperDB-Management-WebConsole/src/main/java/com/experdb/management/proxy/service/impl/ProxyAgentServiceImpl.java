package com.experdb.management.proxy.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.experdb.management.proxy.cmmn.ProxyClientInfoCmmn;
import com.experdb.management.proxy.service.ProxyAgentService;
import com.experdb.management.proxy.service.ProxyAgentVO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;


@Service("ProxyAgentServiceImpl")
public class ProxyAgentServiceImpl extends EgovAbstractServiceImpl implements ProxyAgentService{
	
	@Resource(name = "proxyAgentDAO")
	private ProxyAgentDAO proxyAgentDAO;

	/**
	 * Proxy agent count 조회
	 * 
	 * @param param
	 * @return int
	 * @throws Exception
	 */
	@Override
	public int selectAgentCount() throws Exception {
		return 	proxyAgentDAO.selectAgentCount();
	}
	
	/**
	 * proxy agent 리스트 조회
	 * 
	 * @param proxyAgentVO
	 * @return List<ProxyAgentVO>
	 * @throws Exception
	 */
	public List<ProxyAgentVO> selectProxyAgentList(ProxyAgentVO proxyAgentVO) throws Exception {
		return proxyAgentDAO.selectProxyAgentList(proxyAgentVO);
	}
	
	/**
	 * proxy agent 기동 / 정지 실행
	 * 
	 * @param response, request
	 * @return result
	 * @throws
	 */
	public String proxyAgentExcute(ProxyAgentVO proxyAgentVO) throws Exception {
		String result = "fail";
		String result_code = "";
		
		Map<String, Object> agentExecuteResult = new  HashMap<String, Object>();

		try {
			String IP = proxyAgentVO.getIpadr();
			int PORT = proxyAgentVO.getSocket_port();
			String agt_cndt_cd = proxyAgentVO.getAgt_cndt_cd();
	
			ProxyClientInfoCmmn cic = new ProxyClientInfoCmmn();
			agentExecuteResult = cic.proxyAgentExcute(IP, PORT, agt_cndt_cd);

			if (agentExecuteResult != null) {
				result_code = agentExecuteResult.get("RESULT_CODE").toString();
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
}