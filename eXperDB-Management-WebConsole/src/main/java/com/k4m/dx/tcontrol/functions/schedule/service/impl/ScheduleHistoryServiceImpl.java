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
	public List<Map<String, Object>> selectScheduleHistoryFail(Map<String, Object> param) throws Exception {
		return scheduleHistoryDAO.selectScheduleHistoryFail(param);
	}

	@Override
	public List<Map<String, Object>> selectScheduleNmList(Map<String, Object> param) throws Exception {
		return scheduleHistoryDAO.selectScheduleNmList(param);
	}

	@Override
	public List<Map<String, Object>> selectWrkNmList(Map<String, Object> param) throws Exception {
		return scheduleHistoryDAO.selectWrkNmList(param);
	}

	@Override
	public List<Map<String, Object>> selectScheduleHistoryDetail(int exe_sn, String locale_type) throws Exception {
		return scheduleHistoryDAO.selectScheduleHistoryDetail(exe_sn, locale_type);
	}

	@Override
	public List<Map<String, Object>> selectScheduleHistoryWorkDetail(int exe_sn, String locale_type) throws Exception {
		return scheduleHistoryDAO.selectScheduleHistoryWorkDetail(exe_sn, locale_type);
	}

	@Override
	public List<Map<String, Object>> selectScheduleDBMSList(Map<String, Object> param) throws Exception {
		return scheduleHistoryDAO.selectScheduleDBMSList(param);
	}
	
	@Override
	public List<Map<String, Object>> selectScheduleHistoryNew(Map<String, Object> param) throws Exception {
		return scheduleHistoryDAO.selectScheduleHistoryNew(param);
	}
}
