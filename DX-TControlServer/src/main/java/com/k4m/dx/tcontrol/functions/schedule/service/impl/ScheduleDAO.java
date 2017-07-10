package com.k4m.dx.tcontrol.functions.schedule.service.impl;

import java.util.List;

import org.springframework.stereotype.Repository;
import com.k4m.dx.tcontrol.backup.service.WorkVO;
import egovframework.rte.psl.dataaccess.EgovAbstractMapper;


@Repository("ScheduleDAO")
public class ScheduleDAO extends EgovAbstractMapper{

	@SuppressWarnings({ "deprecation", "unchecked" })
	public List<WorkVO> selectWorkList(WorkVO workVO) {
		List<WorkVO> sl = null;
		sl = (List<WorkVO>) list("scheduleSql.selectWorkList", workVO);
		return sl;
	}

}
