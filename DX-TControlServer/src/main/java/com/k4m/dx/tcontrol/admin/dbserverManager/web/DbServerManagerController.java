package com.k4m.dx.tcontrol.admin.dbserverManager.web;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.k4m.dx.tcontrol.admin.dbserverManager.service.DbServerManagerService;
import com.k4m.dx.tcontrol.admin.dbserverManager.service.DbServerVO;
import com.k4m.dx.tcontrol.common.service.CmmnHistoryService;
import com.k4m.dx.tcontrol.common.service.HistoryVO;

/**
 * DB 서버 관리 컨트롤러 클래스를 정의한다.
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
public class DbServerManagerController {

	@Autowired
	private DbServerManagerService dbServerManagerService;
	
	@Autowired
	private CmmnHistoryService cmmnHistoryService;
	
	/**
	 * DB Tree 화면을 보여준다.
	 * 
	 * @param historyVO
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/dbTree.do")
	public ModelAndView dbTree(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		try {
			// DB Server Tree 이력 남기기
			HttpSession session = request.getSession();
			String usr_id = (String) session.getAttribute("usr_id");
			String ip = (String) session.getAttribute("ip");
			historyVO.setUsr_id(usr_id);
			historyVO.setLgi_ipadr(ip);
			cmmnHistoryService.insertHistoryDbTree(historyVO);
			
			mv.setViewName("admin/dbServerManager/dbTree");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}

	/**
	 * DB 서버 화면을 보여준다.
	 * 
	 * @param historyVO
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/dbServer.do")
	public ModelAndView dbServer(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		try {
			// DB Server  이력 남기기
			HttpSession session = request.getSession();
			String usr_id = (String) session.getAttribute("usr_id");
			String ip = (String) session.getAttribute("ip");
			historyVO.setUsr_id(usr_id);
			historyVO.setLgi_ipadr(ip);
			cmmnHistoryService.insertHistoryDbServer(historyVO);
			
			mv.setViewName("admin/dbServerManager/dbServer");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
	
	/**
	 * database 화면을 보여준다.
	 * 
	 * @param historyVO
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/database.do")
	public ModelAndView database(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		try {
			// Database조회 이력 남기기
			HttpSession session = request.getSession();
			String usr_id = (String) session.getAttribute("usr_id");
			String ip = (String) session.getAttribute("ip");
			historyVO.setUsr_id(usr_id);
			historyVO.setLgi_ipadr(ip);
			cmmnHistoryService.insertHistoryDatabase(historyVO);
			
			mv.setViewName("admin/dbServerManager/database");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
	
	/**
	 * DB서버 등록 화면을 보여준다.
	 * 
	 * @param historyVO
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/popup/dbServerRegForm.do")
	public ModelAndView dbServerRegForm(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		try {
			//DB Server 등록팝업 이력 남기기
			HttpSession session = request.getSession();
			String usr_id = (String) session.getAttribute("usr_id");
			String ip = (String) session.getAttribute("ip");
			historyVO.setUsr_id(usr_id);
			historyVO.setLgi_ipadr(ip);
			cmmnHistoryService.insertHistoryDbServerRegPopup(historyVO);
			
			mv.setViewName("popup/dbServerRegForm");
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
	@RequestMapping(value = "/selectDbServerList.do")
	@ResponseBody
	public List<DbServerVO> selectDbServerList(@ModelAttribute("dbServerVO") DbServerVO dbServerVO) {
		List<DbServerVO> resultSet = null;
		try {
			
			System.out.println("=======parameter=======");
			System.out.println("서버명 : " + dbServerVO.getDb_svr_nm());
			System.out.println("아이피 : " + dbServerVO.getIpadr());
			System.out.println("Database : " + dbServerVO.getDft_db_nm());
			System.out.println("=====================");
			
			resultSet = dbServerManagerService.selectDbServerList(dbServerVO);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return resultSet;
	}
	
	
	/**
	 * DB서버 연결 테스트를 한다.
	 * 
	 * @return resultSet
	 * @throws Exception
	 */
	@RequestMapping(value="/dbServerConnTest.do")
	public @ResponseBody List<Map<String, Object>> dbServerConnTest(@ModelAttribute("dbServerVO") DbServerVO dbServerVO) {
		try {
		}catch (Exception e) {
			e.printStackTrace();
		}
		return null;		
	}
	
	
	/**
	 * DB 서버 등록 한다.
	 * 
	 * @param dbServerVO
	 * @param historyVO
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/insertDbServer.do")
	public @ResponseBody String insertDbServer(@ModelAttribute("dbServerVO") DbServerVO dbServerVO, @ModelAttribute("historyVO") HistoryVO historyVO,HttpServletRequest request) throws Exception {
		try {
			
			String id = (String) request.getSession().getAttribute("usr_id");
			System.out.println(id);
			
			dbServerVO.setFrst_regr_id(id);
			dbServerVO.setLst_mdfr_id(id);
			
			System.out.println("=======parameter=======");
			System.out.println("서버명 : " + dbServerVO.getDb_svr_nm());
			System.out.println("Database : " + dbServerVO.getDft_db_nm());
			System.out.println("아이피 : " + dbServerVO.getIpadr());			
			System.out.println("포트 : " + dbServerVO.getPortno());
			System.out.println("유저 : " + dbServerVO.getSvr_spr_usr_id());
			System.out.println("패스워드 : " + dbServerVO.getSvr_spr_scm_pwd());
			System.out.println("=====================");
			
			dbServerManagerService.insertDbServer(dbServerVO);
			
			// DB Server 등록팝업 저장 이력 남기기
			HttpSession session = request.getSession();
			String usr_id = (String) session.getAttribute("usr_id");
			String ip = (String) session.getAttribute("ip");
			historyVO.setUsr_id(usr_id);
			historyVO.setLgi_ipadr(ip);
			cmmnHistoryService.insertHistoryDbServerI(historyVO);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;

	}
	
}
