package com.experdb.management.backup.service.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.experdb.management.backup.service.ServerInfoVO;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;

@Repository("ExperdbBackupDAO")
public class ExperdbBackupDAO extends EgovAbstractMapper {

	public List<ServerInfoVO> getServerInfo(){
        return selectList("experdbBackupSql.getServerInfo");
        
    }

}
