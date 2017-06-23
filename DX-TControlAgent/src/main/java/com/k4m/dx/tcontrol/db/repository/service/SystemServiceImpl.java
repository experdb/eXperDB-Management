package com.k4m.dx.tcontrol.db.repository.service;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.k4m.dx.tcontrol.db.repository.dao.SystemDAO;
import com.k4m.dx.tcontrol.db.repository.vo.DbServerInfoVO;



@Service("SystemServiceImpl")
public class SystemServiceImpl implements SystemService{

	@Resource(name = "SystemDAO")
	private SystemDAO systemDAO;
	
	public List<DbServerInfoVO> selectDbServerInfoList() throws Exception {
		return systemDAO.selectDbServerInfoList();
	}
	
	public DbServerInfoVO selectDbServerInfo()  throws Exception {
		return (DbServerInfoVO) systemDAO.selectDbServerInfo();
	}



}
