package com.k4m.dx.tcontrol.functions.schedule.service.impl;


import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.k4m.dx.tcontrol.backup.service.WorkVO;
import com.k4m.dx.tcontrol.functions.schedule.service.ScheduleDtlVO;
import com.k4m.dx.tcontrol.functions.schedule.service.ScheduleService;
import com.k4m.dx.tcontrol.functions.schedule.service.ScheduleVO;
import com.k4m.dx.tcontrol.functions.schedule.service.WrkExeVO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;



@Service("scheduleService")
public class ScheduleServiceImpl extends EgovAbstractServiceImpl  implements ScheduleService{

	@Resource(name = "ScheduleDAO")
	private ScheduleDAO scheduleDAO;
	
	/**
	 * 전체 work 리스트 조회
	 * @param dbServerVO
	 * @throws Exception
	 */
	@Override
	public List<WorkVO> selectWorkList(WorkVO workVO, String locale_type) throws Exception {
		return scheduleDAO.selectWorkList(workVO, locale_type);
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


	/**
	 * 스케줄 리스트 조회
	 * @param 
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> selectScheduleList(ScheduleVO scheduleVO) throws Exception {
		return scheduleDAO.selectScheduleList(scheduleVO);
	}


	/**
	 * 서버 시작시 시행할 스케줄 리스트
	 * @param 
	 * @throws Exception
	 */
	public List<ScheduleVO> selectInitScheduleList() {
		return scheduleDAO.selectInitScheduleList();
	}


	/**
	 * 실행할 스케줄 리스트 정보 조회
	 * @param 
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> selectExeScheduleList(String scd_id) throws Exception {
		return scheduleDAO.selectExeScheduleList(scd_id);
	}

	
	/**
	 * JOB 수행전 다음 JOB 실행시간 업데이트
	 * @param 
	 * @throws Exception
	 */
	public void updateNxtJobTime(HashMap<String, Object> hp) {
		scheduleDAO.updateNxtJobTime(hp);	
	}
	
	
	/**
	 *  JOB 수행후 이전 JOB 실행시간 업데이트
	 * @param 
	 * @throws Exception
	 */
	@Override
	public void updatePrevJobTime(HashMap<String , Object> hp) throws Exception {
		scheduleDAO.updatePrevJobTime(hp);		
	}

	
	/**
	 * DB서버 접속정보 조회
	 * @param 
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> selectDbconn(int scd_id) throws Exception {
		return scheduleDAO.selectDbconn(scd_id);
	}


	/**
	 * 부가옵션 조회
	 * @param 
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> selectAddOption(int wrk_id) throws Exception {
		return scheduleDAO.selectAddOption(wrk_id);
	}

	
	/**
	 * 오브젝트옵션 조회
	 * @param 
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> selectAddObject(int wrk_id) throws Exception {
		return scheduleDAO.selectAddObject(wrk_id);
	}


	/**
	 * 스케줄 리스트 삭제
	 * @param 
	 * @throws Exception
	 */
	@Override
	public void deleteScheduleList(int scd_id) throws Exception {
		scheduleDAO.deleteScheduleList(scd_id);	
	}


	/**
	 * 스케줄리스트 수정 정보 조회
	 * @param 
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> selectModifyScheduleList(int scd_id) {
		return scheduleDAO.selectModifyScheduleList(scd_id);
	}

	
	/**
	 * 스케줄마스터 수정
	 * @param 
	 * @throws Exception
	 */
	@Override
	public void updateSchedule(ScheduleVO scheduleVO) throws Exception {
		scheduleDAO.updateSchedule(scheduleVO);	
	}

	
	/**
	 * 스케줄 디테일 삭제
	 * @param 
	 * @throws Exception
	 */
	@Override
	public void deleteScheduleDtl(ScheduleDtlVO scheduleDtlVO) throws Exception {
		scheduleDAO.deleteScheduleDtl(scheduleDtlVO);		
	}


	@Override
	public void updateScheduleStatus(ScheduleVO scheduleVO) throws Exception {
		scheduleDAO.updateScheduleStatus(scheduleVO);		
	}


	@Override
	public int scd_nmCheck(String scd_nm) throws Exception {
		return scheduleDAO.scd_nmCheck( scd_nm);
	}


	@Override
	public List<Map<String, Object>> selectWrkScheduleList(int scd_id, String locale_type) throws Exception {
		return scheduleDAO.selectWrkScheduleList(scd_id, locale_type);
	}


	@Override
	public List<Map<String, Object>> selectWorkDivList(String locale_type) throws Exception {
		return scheduleDAO.selectWorkDivList(locale_type);
	}


	@Override
	public List<Map<String, Object>> selectScdInfo(int scd_id, String locale_type) throws Exception {
		return scheduleDAO.selectScdInfo(scd_id, locale_type);
	}


	@Override
	public List<Map<String, Object>> selectWrkInfo(int wrk_id) throws Exception {
		return scheduleDAO.selectWrkInfo(wrk_id);
	}


	@Override
	public List<Map<String, Object>> selectRunScheduleList() throws Exception {
		return scheduleDAO.selectRunScheduleList();
	}


	@Override
	public void updateSCD_CNDT(WrkExeVO vo) throws Exception {
		scheduleDAO.updateSCD_CNDT(vo);
	}


	@Override
	public void insertT_WRKEXE_G(WrkExeVO vo) throws Exception {
		scheduleDAO.insertT_WRKEXE_G(vo);
	}


	@Override
	public int selectQ_WRKEXE_G_01_SEQ() throws Exception {
		return (int) scheduleDAO.selectQ_WRKEXE_G_01_SEQ();
	}


	@Override
	public int selectQ_WRKEXE_G_02_SEQ() throws Exception {
		return (int) scheduleDAO.selectQ_WRKEXE_G_02_SEQ();
	}


	@Override
	public void updateFixRslt(HashMap<String, Object> paramvalue) throws Exception {
		scheduleDAO.updateFixRslt(paramvalue);	
	}


	@Override
	public List<Map<String, Object>> selectFixRsltMsg(int exe_sn) throws Exception {
		return scheduleDAO.selectFixRsltMsg(exe_sn);
	}


	@Override
	public List<Map<String, Object>> selectDb2pgScheduleWorkList(HashMap<String, Object> paramvalue) throws Exception {
		return scheduleDAO.selectDb2pgScheduleWorkList(paramvalue);
	}


	@Override
	public void insertMigExe(Map<String, Object> param) throws Exception {
		scheduleDAO.insertMigExe(param);	
	}
	
	@Override
	public void updateMigExe(Map<String, Object> param) throws Exception {
		scheduleDAO.updateMigExe(param);
	}


	@Override
	public String selectOldSavePath(int wrk_id) throws Exception {
		return scheduleDAO.selectOldSavePath(wrk_id);
	}


	@Override
	public void updateSavePth(Map<String, Object> param) throws Exception {
		scheduleDAO.updateSavePth(param);
	}


	@Override
	public void updateScheduler(WrkExeVO wrkExeVO) throws Exception {
		scheduleDAO.updateScheduler(wrkExeVO);
	}
	

}
