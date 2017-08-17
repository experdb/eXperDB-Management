package com.k4m.dx.tcontrol.admin.dbserverManager.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.k4m.dx.tcontrol.accesscontrol.service.AccessControlService;
import com.k4m.dx.tcontrol.admin.dbserverManager.service.DbServerManagerService;
import com.k4m.dx.tcontrol.admin.dbserverManager.service.DbServerVO;
import com.k4m.dx.tcontrol.admin.menuauthority.service.MenuAuthorityService;
import com.k4m.dx.tcontrol.cmmn.CmmnUtils;
import com.k4m.dx.tcontrol.common.service.CmmnHistoryService;
import com.k4m.dx.tcontrol.common.service.CmmnVO;
import com.k4m.dx.tcontrol.common.service.HistoryVO;
import com.k4m.dx.tcontrol.functions.schedule.ScheduleUtl;

/**
 * DB 트리 컨트롤러 클래스를 정의한다.
 *
 * @author 변승우
 * @see
 * 
 *      <pre>
 * == 개정이력(Modification Information) ==
 *
 *   수정일       수정자           수정내용
 *  -------     --------    ---------------------------
 *  2017.05.31   변승우 최초 생성
 *      </pre>
 */

@Controller
public class TreeController {
	
	@Autowired
	private MenuAuthorityService menuAuthorityService;

	@Autowired
	private DbServerManagerService dbServerManagerService;
	
	@Autowired
	private CmmnHistoryService cmmnHistoryService;
	
	@Autowired
	private AccessControlService accessControlService;

	private List<Map<String, Object>> menuAut;
	
	
	/**
	 * DB Tree 화면을 보여준다.
	 * 
	 * @param historyVO
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/dbTree.do")
	public ModelAndView dbTree(@ModelAttribute("historyVO") HistoryVO historyVO, @ModelAttribute("cmmnVO") CmmnVO cmmnVO, HttpServletRequest request) {
				
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "15");

		ModelAndView mv = new ModelAndView();
		try {
			// DB Server Tree 이력 남기기
			HttpSession session = request.getSession();
			String usr_id = (String) session.getAttribute("usr_id");
			String ip = (String) session.getAttribute("ip");
			historyVO.setUsr_id(usr_id);
			historyVO.setLgi_ipadr(ip);
			cmmnHistoryService.insertHistoryDbTree(historyVO);
			
			mv.addObject("read_aut_yn", menuAut.get(0).get("read_aut_yn"));
			mv.addObject("wrt_aut_yn", menuAut.get(0).get("wrt_aut_yn"));
			mv.setViewName("admin/dbServerManager/dbTree");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
	
	
	
	/**
	 * DB서버 리스트를 조회한다.
	 * 
	 * @return resultSet
	 * @throws Exception
	 */
	@SuppressWarnings("unused")
	@RequestMapping(value = "/selectTreeDbServerList.do")
	@ResponseBody
	public List<DbServerVO> selectDbServerList(@ModelAttribute("dbServerVO") DbServerVO dbServerVO) {
	
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "15");
		
		List<DbServerVO> result = null;
		List<DbServerVO> resultSet = null;
		try {
			
			System.out.println("=======parameter=======");
			System.out.println("서버명 : " + dbServerVO.getDb_svr_id());
			System.out.println("서버명 : " + dbServerVO.getDb_svr_nm());
			System.out.println("아이피 : " + dbServerVO.getIpadr());
			System.out.println("Database : " + dbServerVO.getDft_db_nm());
			System.out.println("=====================");
			
			if(menuAut.get(0).get("read_aut_yn").equals("Y")){
				resultSet = dbServerManagerService.selectDbServerList(dbServerVO);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return resultSet;
	}
}
