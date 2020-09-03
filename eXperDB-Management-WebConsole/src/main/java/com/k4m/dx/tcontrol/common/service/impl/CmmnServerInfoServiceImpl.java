package com.k4m.dx.tcontrol.common.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.k4m.dx.tcontrol.admin.dbserverManager.service.DbServerVO;
import com.k4m.dx.tcontrol.common.service.AgentInfoVO;
import com.k4m.dx.tcontrol.common.service.CmmnServerInfoService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("cmmnServerInfoServiceImpl")
public class CmmnServerInfoServiceImpl extends EgovAbstractServiceImpl implements CmmnServerInfoService {

	@Resource(name = "cmmnServerInfoDAO")
	private CmmnServerInfoDAO cmmnServerInfoDAO;

	/**
	 * 서버정보 리스트
	 */
	public List<DbServerVO> selectDbServerList(String db_svr_nm) throws Exception {
		return cmmnServerInfoDAO.selectDbServerList(db_svr_nm);
	}

	@Override
	public AgentInfoVO selectAgentInfo(AgentInfoVO vo) throws Exception {
		// TODO Auto-generated method stub
		return (AgentInfoVO) cmmnServerInfoDAO.selectAgentInfo(vo);
	}

	@Override
	public DbServerVO selectServerInfo(DbServerVO vo) throws Exception {
		// TODO Auto-generated method stub
		return (DbServerVO) cmmnServerInfoDAO.selectServerInfo(vo);
	}

	@Override
	public List<Map<String, Object>> selectIpadrList(int db_svr_id) throws Exception {
		return cmmnServerInfoDAO.selectIpadrList(db_svr_id);
	}

	@Override
	public void deleteIpadr(DbServerVO dbServerVO) throws Exception {
		cmmnServerInfoDAO.deleteIpadr(dbServerVO);
	}

	@Override
	public List<DbServerVO> selectServerInfoSlave(DbServerVO vo) throws Exception {
		return cmmnServerInfoDAO.selectServerInfoSlave(vo);
	}

	@Override
	public List<DbServerVO> selectAllIpadrList(int db_svr_id) throws Exception {
		return cmmnServerInfoDAO.selectAllIpadrList(db_svr_id);
	}

	@Override
	public List<Map<String, Object>> selectWrkErrorMsg(int exe_sn) throws Exception {
		return cmmnServerInfoDAO.selectWrkErrorMsg(exe_sn);
	}

	@Override
	public List<DbServerVO> selectRepoDBList(DbServerVO dbServerVO) throws Exception {
		return cmmnServerInfoDAO.selectRepoDBList(dbServerVO);
	}

	@Override
	public List<Map<String, Object>> selectHaCnt(int db_svr_id) throws Exception {
		return cmmnServerInfoDAO.selectHaCnt(db_svr_id);
	}

	/**
	 * 서버정보 리스트 레이아웃
	 */
	public List<Map<String, Object>> selectDashboardServerInfoImg(DbServerVO dbServerVO) throws Exception {
		return cmmnServerInfoDAO.selectDashboardServerInfoImg(dbServerVO);
	}

}
