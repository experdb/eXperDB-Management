package com.k4m.dx.tcontrol.functions.schedule.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.k4m.dx.tcontrol.backup.service.WorkVO;
import com.k4m.dx.tcontrol.functions.schedule.service.ScheduleService;



@Service("ScheduleServiceImpl")
public class ScheduleServiceImpl implements ScheduleService{

	@Resource(name = "ScheduleDAO")
	private ScheduleDAO scheduleDAO;
	
	@Override
	public List<WorkVO> selectWorkList(WorkVO workVO) throws Exception {
		return scheduleDAO.selectWorkList(workVO);
	}

}
