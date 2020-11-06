package com.k4m.dx.tcontrol.admin.accesshistory.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.k4m.dx.tcontrol.admin.accesshistory.service.AccessHistoryService;
import com.k4m.dx.tcontrol.common.service.HistoryVO;
import com.k4m.dx.tcontrol.login.service.UserVO;
import com.k4m.dx.tcontrol.sample.service.PagingVO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("AccessHistoryServiceImpl")
public class AccessHistoryServiceImpl extends EgovAbstractServiceImpl implements AccessHistoryService {

	@Resource(name = "accessHistoryDAO")
	private AccessHistoryDAO accessHistoryDAO;

	public void insertHistory(HistoryVO historyVO) throws Exception {
		accessHistoryDAO.insertHistory(historyVO);
	}

	public List<HistoryVO> selectAccessScreenName() throws Exception {
		return accessHistoryDAO.selectAccessScreenName();
	}
	
	public List<HistoryVO> selectAccessScreenName(String locale_type) throws Exception {
		return accessHistoryDAO.selectAccessScreenName(locale_type);
	}

	public List<Map<String, Object>> selectAccessHistory(PagingVO searchVO, Map<String, Object> param) throws Exception {
		return accessHistoryDAO.selectAccessHistory(searchVO, param);
	}

	@Override
	public List<Map<String, Object>> selectAccessHistoryNew(Map<String, Object> param) throws Exception {
		return accessHistoryDAO.selectAccessHistoryNew(param);
	}

	public int selectAccessHistoryTotCnt(Map<String, Object> param) throws Exception {
		return accessHistoryDAO.selectAccessHistoryTotCnt(param);
	}

	public List<UserVO> selectAccessHistoryExcel(Map<String, Object> param) throws Exception {
		return accessHistoryDAO.selectAccessHistoryExcel(param);
	}

}
