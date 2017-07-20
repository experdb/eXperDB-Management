package com.k4m.dx.tcontrol.functions.schedule.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.k4m.dx.tcontrol.backup.service.WorkVO;
import com.k4m.dx.tcontrol.functions.schedule.service.ScheduleDtlVO;
import com.k4m.dx.tcontrol.functions.schedule.service.ScheduleVO;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;


@Repository("ScheduleDAO")
public class ScheduleDAO extends EgovAbstractMapper{

	@SuppressWarnings({ "deprecation", "unchecked" })
	public List<WorkVO> selectWorkList(WorkVO workVO) {
		List<WorkVO> sl = null;
		sl = (List<WorkVO>) list("scheduleSql.selectWorkList", workVO);
		return sl;
	}

	
	@SuppressWarnings({ "deprecation", "unchecked" })
	public List<Map<String, Object>> selectScheduleWorkList(HashMap paramvalue) {
		List<Map<String, Object>> sl = null;
		sl = (List<Map<String, Object>>) list("scheduleSql.selectScheduleWorkList", paramvalue);		
		return sl;
	}

	
	public int selectScd_id() {
		int scd_id  = getSqlSession().selectOne("scheduleSql.selectScd_id");
		return scd_id;	
	}
	
	
	public void insertSchedule(ScheduleVO scheduleVO) {
		insert("scheduleSql.insertSchedule",scheduleVO);
	}


	public void insertScheduleDtl(ScheduleDtlVO scheduleDtlVO) {
		insert("scheduleSql.insertScheduleDtl",scheduleDtlVO);	
	}

}
