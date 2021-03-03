package com.experdb.management.proxy.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.experdb.management.proxy.service.ProxyServerVO;
import com.experdb.management.proxy.service.ProxySettingService;
import com.experdb.management.proxy.service.impl.ProxySettingDAO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;


@Service("ProxySettingServiceImpl")
public class ProxySettingServiceImpl extends EgovAbstractServiceImpl implements ProxySettingService{
	
	@Resource(name = "proxySettingDAO")
	private ProxySettingDAO proxySettingDAO;
	
	@Override
	public List<ProxyServerVO> selectProxyServerList(Map<String, Object> param) throws Exception {
		return proxySettingDAO.selectProxyServerList(param);
	}

}
