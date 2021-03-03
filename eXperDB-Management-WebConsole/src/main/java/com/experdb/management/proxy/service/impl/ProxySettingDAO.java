package com.experdb.management.proxy.service.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.experdb.management.proxy.service.ProxyServerVO;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;


@Repository("proxySettingDAO")
public class ProxySettingDAO extends EgovAbstractMapper{
	
	/**
	 * Proxy Server 조회
	 * 
	 * @param param
	 * @return List
	 * @throws SQLException
	 */
	@SuppressWarnings({ "unchecked", "deprecation" })
	public List<ProxyServerVO> selectProxyServerList(Map<String, Object> param)throws SQLException {
		List<ProxyServerVO> result = null;
		//result = (List<ProxyServerVO>) list("proxyServerSettingSql.selectProxyServerList", param);
		return result;
	}
	
}
