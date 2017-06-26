package com.k4m.dx.tcontrol.functions.transfer.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.k4m.dx.tcontrol.functions.transfer.service.ConnectorVO;
import com.k4m.dx.tcontrol.functions.transfer.service.TransferService;
import com.k4m.dx.tcontrol.functions.transfer.service.TransferVO;

@Service("transferServiceImpl")
public class TransferServiceImpl implements TransferService{
	
	@Resource(name = "transferDAO")
	private TransferDAO transferDAO;

	
	public List<TransferVO> selectTransferSetting(String usr_id) throws Exception {
		return transferDAO.selectTransferSetting(usr_id);
	}
	
	public void insertTransferSetting(TransferVO transferVO) throws Exception {
		transferDAO.insertTransferSetting(transferVO);	
	}
	
	public void updateTransferSetting(TransferVO transferVO) throws Exception {
		transferDAO.updateTransferSetting(transferVO);		
	}
	
	public List<ConnectorVO> selectConnectorRegister(Map<String, Object> param) throws Exception {
		return transferDAO.selectConnectorRegister(param);
	}

	public List<ConnectorVO> selectDetailConnectorRegister(int cnr_id) throws Exception {
		return transferDAO.selectDetailConnectorRegister(cnr_id);
	}

	public void deleteConnectorRegister(int cnr_id) throws Exception {
		transferDAO.deleteConnectorRegister(cnr_id);		
	}

	public void insertConnectorRegister(ConnectorVO connectorVO) throws Exception {
		transferDAO.insertConnectorRegister(connectorVO);
	}

	public void updateConnectorRegister(ConnectorVO connectorVO) throws Exception {
		transferDAO.updateConnectorRegister(connectorVO);
	}









}
