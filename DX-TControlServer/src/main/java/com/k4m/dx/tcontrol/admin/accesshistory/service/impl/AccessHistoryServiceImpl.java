package com.k4m.dx.tcontrol.admin.accesshistory.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.k4m.dx.tcontrol.admin.accesshistory.service.AccessHistoryService;
import com.k4m.dx.tcontrol.common.service.HistoryVO;
import com.k4m.dx.tcontrol.login.service.UserVO;
import com.k4m.dx.tcontrol.sample.service.PagingVO;

@Service("AccessHistoryServiceImpl")
public class AccessHistoryServiceImpl implements AccessHistoryService{
	
	@Resource(name = "accessHistoryDAO")
	private AccessHistoryDAO accessHistoryDAO;

	public List<UserVO> selectAccessHistory(PagingVO searchVO, Map<String, Object> param) throws Exception {
		return accessHistoryDAO.selectAccessHistory(searchVO,param);
	}
	
	public int selectAccessHistoryTotCnt(Map<String, Object> param)  throws Exception {
		return accessHistoryDAO.selectAccessHistoryTotCnt(param);
	}
	
	public void insertHistory(HistoryVO historyVO) throws Exception {
		accessHistoryDAO.insertHistory(historyVO);	
	}

	public List<UserVO> selectAccessHistoryExcel(Map<String, Object> param) throws Exception {
		return accessHistoryDAO.selectAccessHistoryExcel(param);
	}






}
