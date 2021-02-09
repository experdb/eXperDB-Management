package com.experdb.management.backup.node.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.experdb.management.backup.node.service.ExperdbBackupNodeService;
import com.experdb.management.backup.node.service.TargetMachineVO;
import com.k4m.dx.tcontrol.backup.service.impl.BackupDAO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("ExperdbBackupNodeServiceImpl")
public class ExperdbBackupNodeServiceImpl  extends EgovAbstractServiceImpl implements ExperdbBackupNodeService{

	@Resource(name = "ExperdbBackupNodeDAO")
	private ExperdbBackupNodeDAO experdbBackupNodeDAO;

	
	
	@Override
	public List<TargetMachineVO> getNodeList() throws Exception {
		return experdbBackupNodeDAO.getNodeList();	
	}
}
