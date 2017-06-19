package com.k4m.dx.tcontrol.admin.accesshistory.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.k4m.dx.tcontrol.admin.accesshistory.service.AccessHistoryService;
import com.k4m.dx.tcontrol.login.service.UserVO;

@Service("UserAccessServiceImpl")
public class AccessHistoryServiceImpl implements AccessHistoryService{
	
	@Resource(name = "accessHistoryDAO")
	private AccessHistoryDAO accessHistoryDAO;

	public List<UserVO> selectAccessHistory(Map<String, Object> param) throws Exception {
		return accessHistoryDAO.selectAccessHistory(param);
	}
}
