package com.experdb.management.backup.node.service;

import java.util.List;


public interface ExperdbBackupNodeService {
	
	List<TargetMachineVO> getNodeList()  throws Exception;

}
