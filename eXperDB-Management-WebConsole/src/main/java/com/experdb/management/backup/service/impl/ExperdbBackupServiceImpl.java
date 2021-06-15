package com.experdb.management.backup.service.impl;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.experdb.management.backup.service.ExperdbBackupService;
import com.experdb.management.backup.service.ServerInfoVO;
import com.k4m.dx.tcontrol.login.service.LoginVO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("ExperdbBackupServiceImpl")
public class ExperdbBackupServiceImpl extends EgovAbstractServiceImpl implements ExperdbBackupService{
	
	@Autowired
	@Resource(name="ExperdbBackupDAO")
	private ExperdbBackupDAO experdbBackupDAO;

   @Override
   public List<ServerInfoVO> getServerInfo(HttpServletRequest request) throws Exception{
       // HttpSession session = request.getSession();
       // LoginVO loginVo = (LoginVO) session.getAttribute("session");
       // String userId = loginVo.getUsr_id();
       
       // ServerInfoVO serverInfoVo = new ServerInfoVO();
       // serverInfoVo.setUserId(userId);
       
      return experdbBackupDAO.getServerInfo();
       
   }

}
