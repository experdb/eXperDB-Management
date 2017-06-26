package com.k4m.dx.tcontrol.accesscontrol.service.impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.k4m.dx.tcontrol.accesscontrol.service.AccessControlService;

@Service("AccessControlServiceImpl")
public class AccessControlServiceImpl implements AccessControlService{
	
	@Resource(name = "accessControlDAO")
	private AccessControlDAO accessControlDAO;


}
