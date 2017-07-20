package com.k4m.dx.tcontrol.functions.schedule.service.impl;


import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.k4m.dx.tcontrol.backup.service.WorkVO;
import com.k4m.dx.tcontrol.functions.schedule.service.ScheduleDtlVO;
import com.k4m.dx.tcontrol.functions.schedule.service.ScheduleService;
import com.k4m.dx.tcontrol.functions.schedule.service.ScheduleVO;



@Service("ScheduleServiceImpl")
public class ScheduleServiceImpl implements ScheduleService{

	@Resource(name = "ScheduleDAO")
	private ScheduleDAO scheduleDAO;
	
	/**
	 * 전체 work 리스트 조회
	 * @param dbServerVO
	 * @throws Exception
	 */
	@Override
	public List<WorkVO> selectWorkList(WorkVO workVO) throws Exception {
		return scheduleDAO.selectWorkList(workVO);
	}
	
	
	/**
	 * 선택된 work 리스트 조회
	 * @param 
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> selectScheduleWorkList(HashMap paramvalue) throws Exception {
		return scheduleDAO.selectScheduleWorkList(paramvalue);
	}

	
	/**
	 * 스케줄ID 시퀀스 조회
	 * @param 
	 * @throws Exception
	 */
	@Override
	public int selectScd_id() throws Exception {
		return scheduleDAO.selectScd_id();
	}
	
	
	/**
	 * 스케줄 등록
	 * @param 
	 * @throws Exception
	 */
	@Override
	public void insertSchedule(ScheduleVO scheduleVO) throws Exception {
		scheduleDAO.insertSchedule(scheduleVO);
	}

	
	/**
	 * 스케줄 상세정보 등록
	 * @param 
	 * @throws Exception
	 */
	@Override
	public void insertScheduleDtl(ScheduleDtlVO scheduleDtlVO) throws Exception {
		scheduleDAO.insertScheduleDtl(scheduleDtlVO);	
	}


}
