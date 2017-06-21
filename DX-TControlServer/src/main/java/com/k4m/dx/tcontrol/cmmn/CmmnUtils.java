package com.k4m.dx.tcontrol.cmmn;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.web.bind.annotation.ModelAttribute;

import com.k4m.dx.tcontrol.common.service.HistoryVO;

public class CmmnUtils {
	
	public static void saveHistory(HttpServletRequest request,@ModelAttribute("historyVO") HistoryVO historyVO) {
		HttpSession session = request.getSession();
		String usr_id = (String) session.getAttribute("usr_id");
		String ip = (String) session.getAttribute("ip");
		historyVO.setUsr_id(usr_id);
		historyVO.setLgi_ipadr(ip);
	}
}
