package com.k4m.dx.tcontrol.transfer.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.k4m.dx.tcontrol.transfer.service.TransMappVO;
import com.k4m.dx.tcontrol.transfer.service.TransVO;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;

@Repository("TransDAO")
public class TransDAO extends EgovAbstractMapper{

	public List<TransVO> selectSnapshotModeList() {
		List<TransVO> sl = null;
		sl = (List<TransVO>) list("transSQL.selectSnapshotModeList",null);
		return sl;
	}

	public void insertConnectInfo(TransVO transVO) {
		insert("transSQL.insertConnectInfo",transVO);
	}

	public List<Map<String, Object>> selectTransSetting(TransVO transVO) {
		List<Map<String, Object>>  sl = null;
		sl = (List<Map<String, Object>>) list("transSQL.selectTransSetting",transVO);
		return sl;
	}

	public int connect_nm_Check(String connect_nm) {
		int resultSet = 0;
		resultSet = (int) getSqlSession().selectOne("transSQL.connect_nm_Check", connect_nm);
		return resultSet;
	}

	public int selectTransExrttrgMappSeq() {
		return (int) getSqlSession().selectOne("transSQL.selectTransExrttrgMappSeq");
	}

	public void insertTransExrttrgMapp(TransMappVO transMappVO) {
		insert("transSQL.insertTransExrttrgMapp",transMappVO);
	}

	public List<Map<String, Object>> selectTransInfo(int trans_id) {
		List<Map<String, Object>>  sl = null;
		sl = (List<Map<String, Object>>) list("transSQL.selectTransInfo",trans_id);
		return sl;
	}

	public List<Map<String, Object>> selectMappInfo(int trans_exrt_trg_tb_id) {
		List<Map<String, Object>>  sl = null;
		sl = (List<Map<String, Object>>) list("transSQL.selectMappInfo",trans_exrt_trg_tb_id);
		return sl;
	}

	public void updateTransExrttrgMapp(TransMappVO transMappVO) {
		update("transSQL.updateTransExrttrgMapp",transMappVO);	
	}

	public void deleteTransExrttrgMapp(int trans_exrt_trg_tb_id) {
		delete("transSQL.deleteTransExrttrgMapp",trans_exrt_trg_tb_id);	
	}

	public void deleteTransSetting(int trans_id) {
		delete("transSQL.deleteTransSetting",trans_id);	
	}

}
