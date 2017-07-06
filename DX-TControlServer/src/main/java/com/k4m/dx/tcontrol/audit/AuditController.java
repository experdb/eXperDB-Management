package com.k4m.dx.tcontrol.audit;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.k4m.dx.tcontrol.admin.accesshistory.service.AccessHistoryService;
import com.k4m.dx.tcontrol.audit.service.AuditVO;

/**
 * 감사로그 컨트롤러 클래스를 정의한다.
 *
 * @author 박태혁
 * @see
 * 
 *      <pre>
 * == 개정이력(Modification Information) ==
 *
 *   수정일       수정자           수정내용
 *  -------     --------    ---------------------------
 *  2017.07.06   박태혁
 *      </pre>
 */

@Controller
public class AuditController {
	
	@Autowired
	private AccessHistoryService accessHistoryService;
	
	@RequestMapping(value = "/audit/auditManagement.do")
	public ModelAndView rmanList(@ModelAttribute("auditVO") AuditVO auditVO, ModelMap model) {
		ModelAndView mv = new ModelAndView();

		//mv.addObject("db_svr_id",workVO.getDb_svr_id());
		try {
			//mv.addObject("db_svr_nm", backupService.selectDbSvrNm(workVO).getDb_svr_nm());
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		mv.setViewName("audit/auditManagement");
		return mv;
	}
	
}
