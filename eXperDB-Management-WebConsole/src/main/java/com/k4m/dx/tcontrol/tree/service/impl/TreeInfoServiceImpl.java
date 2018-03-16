package com.k4m.dx.tcontrol.tree.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.k4m.dx.tcontrol.functions.transfer.service.ConnectorVO;
import com.k4m.dx.tcontrol.tree.service.TreeInfoService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("TreeInfoServiceImpl")
public class TreeInfoServiceImpl extends EgovAbstractServiceImpl implements TreeInfoService {

	@Resource(name = "TreeInfoDAO")
	private TreeInfoDAO treeInfoDAO;

	public List<ConnectorVO> selectConnectorRegister(String usr_id) throws Exception {
		return treeInfoDAO.selectConnectorRegister(usr_id);
	}

	@Override
	public List<Map<String, Object>> selectTreeEncrypt(String usr_id) throws Exception {
		return treeInfoDAO.selectTreeEncrypt(usr_id);
	}



}
