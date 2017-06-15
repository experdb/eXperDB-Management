package com.k4m.dx.tcontrol.admin.accesshistory.service;

import java.util.List;
import java.util.Map;

import com.k4m.dx.tcontrol.login.service.UserVO;

public interface AccessHistoryService {
	/**
	 * 접근 내역
	 * @param param 
	 * @param userVo
	 * @return
	 * @throws Exception
	 */
	List<UserVO> selectAccessHistory(Map<String, Object> param) throws Exception;

}
