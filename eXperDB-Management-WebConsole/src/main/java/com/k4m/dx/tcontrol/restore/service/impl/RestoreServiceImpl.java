package com.k4m.dx.tcontrol.restore.service.impl;

import java.util.List;

import javax.annotation.Resource;
import org.springframework.stereotype.Service;

import com.k4m.dx.tcontrol.backup.service.WorkLogVO;
import com.k4m.dx.tcontrol.restore.service.RestoreDumpVO;
import com.k4m.dx.tcontrol.restore.service.RestoreRmanVO;
import com.k4m.dx.tcontrol.restore.service.RestoreService;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("RestoreServiceImpl")
public class RestoreServiceImpl extends EgovAbstractServiceImpl implements RestoreService{

	@Resource(name = "restoreDAO")
	private RestoreDAO restoreDAO;

	@Override
	public void insertRmanRestore(RestoreRmanVO restoreRmanVO) throws Exception {
		restoreDAO.insertRmanRestore(restoreRmanVO);
	}

	@Override
	public int restore_nmCheck(String restore_nm) throws Exception {	
		return restoreDAO.restore_nmCheck(restore_nm);
	}

	@Override
	public RestoreRmanVO latestRestoreSN() throws Exception {
		return restoreDAO.latestRestoreSN();
	}

	@Override
	public List<RestoreRmanVO> rmanRestoreHistory(RestoreRmanVO restoreRmanVO) throws Exception {
		return restoreDAO.rmanRestoreHistory(restoreRmanVO);
	}

	@Override
	public List<WorkLogVO> selectBckInfo(WorkLogVO workLogVO) throws Exception {
		return restoreDAO.selectBckInfo(workLogVO);
	}

	@Override
	public void insertDumpRestore(RestoreDumpVO restoreDumpVO) throws Exception {
		restoreDAO.insertDumpRestore(restoreDumpVO);
	}

	@Override
	public RestoreDumpVO latestDumpRestoreSN() throws Exception {
		return restoreDAO.latestDumpRestoreSN();
	}

	@Override
	public List<RestoreDumpVO> dumpRestoreHistory(RestoreDumpVO restoreDumpVO) throws Exception {
		return restoreDAO.dumpRestoreHistory(restoreDumpVO);
	}

	@Override
	public List<WorkLogVO> selectDumpRestoreLogList(WorkLogVO workLogVO) throws Exception {
		return restoreDAO.selectDumpRestoreLogList(workLogVO);
	}

}
