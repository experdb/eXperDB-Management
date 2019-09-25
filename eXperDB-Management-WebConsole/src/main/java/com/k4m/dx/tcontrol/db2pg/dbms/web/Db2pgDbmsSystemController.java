package com.k4m.dx.tcontrol.db2pg.dbms.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.k4m.dx.tcontrol.admin.dbserverManager.service.DbServerManagerService;
import com.k4m.dx.tcontrol.admin.dbserverManager.service.DbServerVO;
import com.k4m.dx.tcontrol.cmmn.AES256;
import com.k4m.dx.tcontrol.cmmn.AES256_KEY;
import com.k4m.dx.tcontrol.cmmn.CmmnUtils;
import com.k4m.dx.tcontrol.common.service.HistoryVO;
import com.k4m.dx.tcontrol.db2pg.dbms.service.DbmsService;

@Controller
public class Db2pgDbmsSystemController {
	
	@Autowired
	private DbmsService dbmsService;
	
	@Autowired
	private DbServerManagerService dbServerManagerService;
	
	private List<Map<String, Object>> dbmsGrb;
	
	/**
	 * DBMS시스템 설정 화면을 보여준다.
	 * 
	 * @param historyVO
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/db2pgDBMS.do")
	public ModelAndView db2pgDBMS(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		
		ModelAndView mv = new ModelAndView();

		try {				
			mv.setViewName("db2pg/dbms/dbmsList");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
	
	/**
	 * DBMS 등록 팝업 화면을 보여준다.
	 * 
	 * @param historyVO
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/db2pg/popup/dbmsRegForm.do")
	public ModelAndView dbmsRegForm(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		try {				
			mv.setViewName("db2pg/popup/dbmsRegForm");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
	
	
	/**
	 * 기 등록된 PostgreSQL DBMS List 팝업 화면을 보여준다.
	 * 
	 * @param historyVO
	 * @param requestr
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/db2pg/popup/pgDbmsRegForm.do")
	public ModelAndView pgDbmsRegForm(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		try {				
			mv.setViewName("db2pg/popup/pgDbmsRegForm");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
	
	
	/**
	 * 기 등록된 PostgreSQL DBMS List  조회
	 * 
	 * @return resultSet
	 * @throws Exception
	 */
	@SuppressWarnings("unused")
	@RequestMapping(value = "/selectPgDbmsList.do")
	@ResponseBody
	public List<DbServerVO> selectPgDbmsList(@ModelAttribute("historyVO") HistoryVO historyVO, @ModelAttribute("dbServerVO") DbServerVO dbServerVO, HttpServletResponse response, HttpServletRequest request) {
	
		List<DbServerVO> resultSet = null;
		Map<String, Object> result = new HashMap<String, Object>();
		
		try {		
			AES256 dec = new AES256(AES256_KEY.ENC_KEY);
			
			resultSet = dbServerManagerService.selectPgDbmsList();

			for (int i = 0; i < resultSet.size(); i++) {			
				resultSet.get(i).setSvr_spr_scm_pwd(dec.aesDecode(resultSet.get(i).getSvr_spr_scm_pwd()));
			}
	
		} catch (Exception e) {
			e.printStackTrace();
		}
		return resultSet;
	}
	
}
