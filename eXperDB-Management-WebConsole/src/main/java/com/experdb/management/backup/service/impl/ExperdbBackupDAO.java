package com.experdb.management.backup.service.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.experdb.management.backup.service.ServerInfoVO;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;

@Repository("ExperdbBackupDAO")
public class ExperdbBackupDAO extends EgovAbstractMapper {

    @SuppressWarnings({ "deprecation", "unchecked" })
	public List<ServerInfoVO> getServerInfo(ServerInfoVO serverInfoVo){
        List<ServerInfoVO> result = null;
        result = (List<ServerInfoVO>) list("experdbBackupSql.getServerInfo", serverInfoVo);
        return result;
    }

}
