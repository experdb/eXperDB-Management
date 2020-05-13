package com.k4m.dx.tcontrol.transfer.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.k4m.dx.tcontrol.transfer.service.TransMappVO;
import com.k4m.dx.tcontrol.transfer.service.TransService;
import com.k4m.dx.tcontrol.transfer.service.TransVO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;



@Service("transServiceImpl")
public class TransServiceImpl extends EgovAbstractServiceImpl implements TransService{

	
	@Resource(name = "TransDAO")
	private TransDAO transDAO;
	
	@Override
	public List<TransVO> selectSnapshotModeList() throws Exception {
		return transDAO.selectSnapshotModeList();
	}

	@Override
	public void insertConnectInfo(TransVO transVO) throws Exception {
		transDAO.insertConnectInfo(transVO);		
	}

	@Override
	public List<Map<String, Object>> selectTransSetting(TransVO transVO) throws Exception {
		return transDAO.selectTransSetting(transVO);
	}

	@Override
	public int connect_nm_Check(String connect_nm) throws Exception {
		return transDAO.connect_nm_Check(connect_nm);
	}

	@Override
	public int selectTransExrttrgMappSeq() throws Exception {
		return transDAO.selectTransExrttrgMappSeq();
	}

	@Override
	public void insertTransExrttrgMapp(TransMappVO transMappVO) throws Exception {
		transDAO.insertTransExrttrgMapp(transMappVO);
	}

	@Override
	public List<Map<String, Object>> selectTransInfo(int trans_id) throws Exception {
		return transDAO.selectTransInfo(trans_id);
	}

	@Override
	public List<Map<String, Object>> selectMappInfo(int trans_exrt_trg_tb_id) throws Exception {
		return transDAO.selectMappInfo(trans_exrt_trg_tb_id);
	}

	@Override
	public void updateTransExrttrgMapp(TransMappVO transMappVO) throws Exception {
		transDAO.updateTransExrttrgMapp(transMappVO);
		
	}

	@Override
	public void deleteTransExrttrgMapp(int trans_exrt_trg_tb_id) throws Exception {
		transDAO.deleteTransExrttrgMapp(trans_exrt_trg_tb_id);
		
	}

	@Override
	public void deleteTransSetting(int trans_id) throws Exception {
		transDAO.deleteTransSetting(trans_id);		
	}

}
