package com.k4m.dx.tcontrol.script.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.k4m.dx.tcontrol.script.service.ScriptService;
import com.k4m.dx.tcontrol.script.service.ScriptVO;

@Service("ScriptServiceImpl")
public class ScriptServiceImpl implements ScriptService{

	@Resource(name = "ScriptDAO")
	private ScriptDAO ScriptDAO;

	@Override
	public List<Map<String, Object>> selectScriptList(ScriptVO scriptVO) throws Exception {
		return ScriptDAO.selectScriptList(scriptVO);
	}

	@Override
	public void insertScriptWork(ScriptVO scriptVO) throws Exception {
		ScriptDAO.insertScriptWork(scriptVO);		
	}

	@Override
	public void insertScript(ScriptVO scriptVO) throws Exception {
		ScriptDAO.insertScript(scriptVO);		
	}

	@Override
	public List<Map<String, Object>> selectSciptExeInfo(int wrk_id) throws Exception {
		return ScriptDAO.selectSciptExeInfo(wrk_id);
	}

	@Override
	public void updateScriptWork(ScriptVO scriptVO) throws Exception {
		ScriptDAO.updateScriptWork(scriptVO);	
	}

	@Override
	public void deleteScriptWork(int wrk_id) throws Exception {
		ScriptDAO.deleteScriptWork(wrk_id);	
	}

	@Override
	public List<Map<String, Object>> selectScriptHistoryList(ScriptVO scriptVO) throws Exception {
		return ScriptDAO.selectScriptHistoryList(scriptVO);
	}

	/**
	 * 스크립트 스케줄 리스트 조회
	 * @param 
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> selectScriptScheduleList(ScriptVO scriptVO) throws Exception {
		return ScriptDAO.selectScriptScheduleList(scriptVO);
	}

}
