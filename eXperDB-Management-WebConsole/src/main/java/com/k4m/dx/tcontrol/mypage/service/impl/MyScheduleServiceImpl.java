package com.k4m.dx.tcontrol.mypage.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.k4m.dx.tcontrol.functions.schedule.service.ScheduleVO;
import com.k4m.dx.tcontrol.mypage.service.MyScheduleService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("myScheduleServiceImpl")
public class MyScheduleServiceImpl extends EgovAbstractServiceImpl implements MyScheduleService{
 
	@Resource(name = "myScheduleDAO")
	private MyScheduleDAO myScheduleDAO;

	
	@Override
	public List<Map<String, Object>> selectMyScheduleList(ScheduleVO scheduleVO) throws Exception {
		return myScheduleDAO.selectMyScheduleList(scheduleVO);
	}
}
