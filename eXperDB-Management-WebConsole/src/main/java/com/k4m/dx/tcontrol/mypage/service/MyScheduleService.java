package com.k4m.dx.tcontrol.mypage.service;

import java.util.List;
import java.util.Map;

import com.k4m.dx.tcontrol.functions.schedule.service.ScheduleVO;

public interface MyScheduleService {

	List<Map<String, Object>> selectMyScheduleList(ScheduleVO scheduleVO) throws Exception;

}
