package com.k4m.dx.tcontrol.mypage.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.k4m.dx.tcontrol.functions.schedule.service.ScheduleVO;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;

@Repository("myScheduleDAO")
public class MyScheduleDAO extends EgovAbstractMapper{

	@SuppressWarnings({ "deprecation", "unchecked" })
	public List<Map<String, Object>> selectMyScheduleList(ScheduleVO scheduleVO) {
		List<Map<String, Object>> sl = null;
		sl = (List<Map<String, Object>>) list("myScheduleSql.selectMyScheduleList", scheduleVO);		
		return sl;
	}

}
