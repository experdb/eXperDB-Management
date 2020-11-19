package com.k4m.dx.tcontrol.functions.schedule.service.impl;

import java.sql.SQLException;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.k4m.dx.tcontrol.backup.service.WorkVO;
import com.k4m.dx.tcontrol.functions.schedule.service.ScheduleDtlVO;
import com.k4m.dx.tcontrol.functions.schedule.service.ScheduleVO;
import com.k4m.dx.tcontrol.functions.schedule.service.WrkExeVO;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;


@Repository("ScheduleDAO")
public class ScheduleDAO extends EgovAbstractMapper{

	@SuppressWarnings({ "deprecation", "unchecked" })
	public List<WorkVO> selectWorkList(WorkVO workVO, String locale_type) {
		List<WorkVO> sl = null;
		if(locale_type.equals("ko")){
			sl = (List<WorkVO>) list("scheduleSql.selectWorkList", workVO);
		}else{
			sl = (List<WorkVO>) list("scheduleSql.selectWorkListEN", workVO);
		}
		
		return sl;
	}

	
	@SuppressWarnings({ "deprecation", "unchecked" })
	public List<Map<String, Object>> selectScheduleWorkList(HashMap paramvalue) {
		List<Map<String, Object>> sl = null;
		if(paramvalue.get("locale_type").equals("ko")){
			sl = (List<Map<String, Object>>) list("scheduleSql.selectScheduleWorkList", paramvalue);
		}else{
			sl = (List<Map<String, Object>>) list("scheduleSql.selectScheduleWorkListEN", paramvalue);	
		}
			
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

	
	@SuppressWarnings({ "deprecation", "unchecked" })
	public List<Map<String, Object>> selectScheduleList(ScheduleVO scheduleVO) {
		List<Map<String, Object>> sl = null;
		sl = (List<Map<String, Object>>) list("scheduleSql.selectScheduleList", scheduleVO);		
		return sl;
	}

	
	@SuppressWarnings({ "deprecation", "unchecked" })
	public List<ScheduleVO> selectInitScheduleList() {
		List<ScheduleVO> sl = null;
		sl = (List<ScheduleVO>) list("scheduleSql.selectInitScheduleList", null);		
		return sl;
	}


	@SuppressWarnings({ "deprecation", "unchecked" })
	public List<Map<String, Object>> selectExeScheduleList(String scd_id) {
		List<Map<String, Object>> sl = null;
		sl = (List<Map<String, Object>>) list("scheduleSql.selectExeScheduleList", scd_id);		
		return sl;
	}


	public void updatePrevJobTime(HashMap<String , Object> hp) {
		update("scheduleSql.updatePrevJobTime",hp);
	}


	public void updateNxtJobTime(HashMap<String, Object> hp) {
		update("scheduleSql.updateNxtJobTime",hp);		
	}


	@SuppressWarnings({ "deprecation", "unchecked" })
	public List<Map<String, Object>> selectDbconn(int scd_id) {
		List<Map<String, Object>> sl = null;
		sl = (List<Map<String, Object>>) list("scheduleSql.selectDbconn", scd_id);		
		return sl;
	}


	@SuppressWarnings({ "unchecked", "deprecation" })
	public List<Map<String, Object>> selectAddOption(int wrk_id) {
		List<Map<String, Object>> sl = null;
		sl = (List<Map<String, Object>>) list("scheduleSql.selectAddOption", wrk_id);		
		return sl;
	}


	@SuppressWarnings({ "deprecation", "unchecked" })
	public List<Map<String, Object>> selectAddObject(int wrk_id) {
		List<Map<String, Object>> sl = null;
		sl = (List<Map<String, Object>>) list("scheduleSql.selectAddObject", wrk_id);		
		return sl;
	}


	public void deleteScheduleList(int scd_id) {
		delete("scheduleSql.deleteDscheduleList",scd_id);
		delete("scheduleSql.deleteMscheduleList",scd_id);
	}


	@SuppressWarnings({ "deprecation", "unchecked" })
	public List<Map<String, Object>> selectModifyScheduleList(int scd_id) {
		List<Map<String, Object>> sl = null;
		sl = (List<Map<String, Object>>) list("scheduleSql.selectModifyScheduleList", scd_id);		
		return sl;
	}


	public void updateSchedule(ScheduleVO scheduleVO) {
		update("scheduleSql.updateSchedule",scheduleVO);	
	}


	public void deleteScheduleDtl(ScheduleDtlVO scheduleDtlVO) {
		delete("scheduleSql.deleteScheduleDtl",scheduleDtlVO);	
	}


	public void updateScheduleStatus(ScheduleVO scheduleVO) {
		update("scheduleSql.updateScheduleStatus",scheduleVO);			
	}


	public int scd_nmCheck(String scd_nm) {
		int resultSet = 0;
		resultSet = (int) getSqlSession().selectOne("scheduleSql.scd_nmCheck", scd_nm);
		return resultSet;
	}


	public List<Map<String, Object>> selectWrkScheduleList(int scd_id, String locale_type) {
		List<Map<String, Object>> sl = null;
		if(locale_type.equals("ko")){
			sl = (List<Map<String, Object>>) list("scheduleSql.selectWrkScheduleList", scd_id);					
		}else {
			sl = (List<Map<String, Object>>) list("scheduleSql.selectWrkScheduleListEN", scd_id);		
		}
		return sl;
	}


	public List<Map<String, Object>> selectWorkDivList(String locale_type) {
		List<Map<String, Object>> sl = null;
		if(locale_type.equals("ko")){
			sl = (List<Map<String, Object>>) list("scheduleSql.selectWorkDivList", null);
		}else{
			sl = (List<Map<String, Object>>) list("scheduleSql.selectWorkDivListEN", null);	
		}
		
		return sl;
	}


	public List<Map<String, Object>> selectScdInfo(int scd_id, String locale_type) {
		List<Map<String, Object>> sl = null;
		
		if(locale_type.equals("ko")){
			sl = (List<Map<String, Object>>) list("scheduleSql.selectScdInfo", scd_id);	
		}else{
			sl = (List<Map<String, Object>>) list("scheduleSql.selectScdInfoEn", scd_id);	
		}
			
		return sl;
	}


	public List<Map<String, Object>> selectWrkInfo(int wrk_id) {
		List<Map<String, Object>> sl = null;
		
		
		sl = (List<Map<String, Object>>) list("scheduleSql.selectWrkInfo", wrk_id);		
		return sl;
	}


	public List<Map<String, Object>> selectRunScheduleList() {
		List<Map<String, Object>> sl = null;
		sl = (List<Map<String, Object>>) list("scheduleSql.selectRunScheduleList", null);		
		return sl;
	}


	public void updateSCD_CNDT(WrkExeVO vo) {
		update("scheduleSql.updateSCD_CNDT",vo);	
	}


	public void insertT_WRKEXE_G(WrkExeVO vo) {
		insert("scheduleSql.insertT_WRKEXE_G",vo);
	}


	public int selectQ_WRKEXE_G_01_SEQ() {
		int wrkExeSEQ  = getSqlSession().selectOne("scheduleSql.selectQ_WRKEXE_G_01_SEQ");
		return wrkExeSEQ;		
	}


	public int selectQ_WRKEXE_G_02_SEQ() {
		int wrkExeSEQ02  = getSqlSession().selectOne("scheduleSql.selectQ_WRKEXE_G_02_SEQ");
		return wrkExeSEQ02;	
	}


	public void updateFixRslt(HashMap<String, Object> paramvalue) {
		update("scheduleSql.updateFixRslt",paramvalue);
	}


	public List<Map<String, Object>> selectFixRsltMsg(int exe_sn) {
		List<Map<String, Object>> sl = null;
		sl = (List<Map<String, Object>>) list("scheduleSql.selectFixRsltMsg", exe_sn);		
		return sl;
	}


	public List<Map<String, Object>> selectDb2pgScheduleWorkList(HashMap<String, Object> paramvalue) {
		List<Map<String, Object>> sl = null;
		sl = (List<Map<String, Object>>) list("scheduleSql.selectDb2pgScheduleWorkList", paramvalue);		
		return sl;
	}


	public void insertMigExe(Map<String, Object> param) {
		insert("db2pgHistorySql.insertMigExe", param);
	}
	
	public void updateMigExe(Map<String, Object> param) {
		update("db2pgHistorySql.updateMigExe", param);
	}


	public String selectOldSavePath(int wrk_id) {
		String oldSavePath = getSqlSession().selectOne("scheduleSql.selectOldSavePath",wrk_id);
		return oldSavePath;
	}


	public void updateSavePth(Map<String, Object> param) {
		update("db2pgSettingSql.updateTransSavePth", param);
	}


	public void updateScheduler(WrkExeVO wrkExeVO) {
		update("scheduleHistorySql.updateScheduler", wrkExeVO);
	}


}
