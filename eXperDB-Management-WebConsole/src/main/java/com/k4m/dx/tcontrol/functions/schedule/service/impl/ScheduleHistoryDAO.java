package com.k4m.dx.tcontrol.functions.schedule.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.k4m.dx.tcontrol.sample.service.PagingVO;
import com.k4m.dx.tcontrol.script.service.ScriptVO;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;

@Repository("ScheduleHistoryDAO")
public class ScheduleHistoryDAO extends EgovAbstractMapper{

	@SuppressWarnings({ "deprecation", "unchecked" })
	public List<Map<String, Object>> selectScheduleHistory(PagingVO pagingVO, Map<String, Object> param) {
		List<Map<String, Object>> result = null;
		HashMap<String, Object> params= new HashMap<String, Object>();
		params.put("lgi_dtm_start", param.get("lgi_dtm_start"));
		params.put("lgi_dtm_end", param.get("lgi_dtm_end"));
		params.put("scd_nm", param.get("scd_nm"));
		params.put("db_svr_nm", param.get("db_svr_nm"));
		params.put("exe_result", param.get("exe_result"));
		params.put("wrk_nm", param.get("wrk_nm"));
		params.put("recordCountPerPage", pagingVO.getRecordCountPerPage());
		params.put("firstIndex", pagingVO.getFirstIndex());
		params.put("order_type", param.get("order_type"));
		params.put("order", param.get("order"));
		params.put("usr_id", param.get("usr_id"));

		result = (List<Map<String, Object>>) list("scheduleHistorySql.selectScheduleHistory",params);

		return result;
	}
	
	public List<Map<String, Object>> selectScheduleHistoryNew(Map<String, Object> param) {
		List<Map<String, Object>> sl = null;
		sl = (List<Map<String, Object>>) list("scheduleHistorySql.selectScheduleHistoryNew", param);		
		return sl;
	}

	
	public int selectScheduleHistoryTotCnt(Map<String, Object> param) {
		int TotCnt= 0;
		TotCnt = (int) getSqlSession().selectOne("scheduleHistorySql.selectScheduleHistoryTotCnt",param);
		return TotCnt;
	}


	public List<Map<String, Object>> selectScheduleHistoryFail(Map<String, Object> param) {
		List<Map<String, Object>> sl = null;
		sl = (List<Map<String, Object>>) list("scheduleHistorySql.selectScheduleHistoryFail", param);		
		return sl;
	}


	public List<Map<String, Object>> selectScheduleNmList(Map<String, Object> param) {
		List<Map<String, Object>> sl = null;
		sl = (List<Map<String, Object>>) list("scheduleHistorySql.selectScheduleNmList", param);		
		return sl;
	}


	public List<Map<String, Object>> selectWrkNmList(Map<String, Object> param) {
		List<Map<String, Object>> sl = null;
		sl = (List<Map<String, Object>>) list("scheduleHistorySql.selectWrkNmList", param);		
		return sl;
	}


	public List<Map<String, Object>> selectScheduleHistoryDetail(int exe_sn, String locale_type) {
		List<Map<String, Object>> sl = null;
		if(locale_type.equals("ko")){			
			sl = (List<Map<String, Object>>) list("scheduleHistorySql.selectScheduleHistoryDetail", exe_sn);		
		}else{
			sl = (List<Map<String, Object>>) list("scheduleHistorySql.selectScheduleHistoryDetailEN", exe_sn);		
		}
		return sl;
	}


	public List<Map<String, Object>> selectScheduleHistoryWorkDetail(int exe_sn, String locale_type) {
		List<Map<String, Object>> sl = null;
		if(locale_type.equals("ko")){			
			sl = (List<Map<String, Object>>) list("scheduleHistorySql.selectScheduleHistoryWorkDetail", exe_sn);		
		}else {
			sl = (List<Map<String, Object>>) list("scheduleHistorySql.selectScheduleHistoryWorkDetailEN", exe_sn);
		}
		return sl;
	}


	public List<Map<String, Object>> selectScheduleDBMSList(Map<String, Object> param) {
		List<Map<String, Object>> sl = null;
		sl = (List<Map<String, Object>>) list("scheduleHistorySql.selectScheduleDBMSList", param);		
		return sl;
	}

}
