package com.k4m.dx.tcontrol.functions.schedule.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.k4m.dx.tcontrol.functions.schedule.service.ScheduleHistoryService;
import com.k4m.dx.tcontrol.sample.service.PagingVO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("scheduleHistoryService")
public class ScheduleHistoryServiceImpl extends EgovAbstractServiceImpl implements ScheduleHistoryService{

	@Resource(name = "ScheduleHistoryDAO")
	private ScheduleHistoryDAO scheduleHistoryDAO;

	@Override
	public List<Map<String, Object>> selectScheduleHistory(PagingVO pagingVO, Map<String, Object> param)
			throws Exception {
		return scheduleHistoryDAO.selectScheduleHistory(pagingVO,param);
	}

	@Override
	public int selectScheduleHistoryTotCnt(Map<String, Object> param) throws Exception {
		return scheduleHistoryDAO.selectScheduleHistoryTotCnt(param);
	}

	@Override
	public List<Map<String, Object>> selectScheduleHistoryFail() throws Exception {
		return scheduleHistoryDAO.selectScheduleHistoryFail();
	}

	@Override
	public List<Map<String, Object>> selectScheduleNmList(Map<String, Object> param) throws Exception {
		return scheduleHistoryDAO.selectScheduleNmList(param);
	}

	@Override
	public List<Map<String, Object>> selectWrkNmList(Map<String, Object> param) throws Exception {
		return scheduleHistoryDAO.selectWrkNmList(param);
	}
}
