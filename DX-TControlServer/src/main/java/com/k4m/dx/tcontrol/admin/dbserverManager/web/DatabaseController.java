package com.k4m.dx.tcontrol.admin.dbserverManager.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.k4m.dx.tcontrol.admin.dbserverManager.service.DbServerManagerService;
import com.k4m.dx.tcontrol.admin.menuauthority.service.MenuAuthorityService;
import com.k4m.dx.tcontrol.cmmn.CmmnUtils;
import com.k4m.dx.tcontrol.common.service.HistoryVO;

/**
 * [DB DATABASE] DB 서버 관리 컨트롤러 클래스를 정의한다.
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
public class DatabaseController {

	@Autowired
	private MenuAuthorityService menuAuthorityService;

	@Autowired
	private DbServerManagerService dbServerManagerService;
	
	private List<Map<String, Object>> menuAut;
	
	
	/**
	 * [DB DATABASE] database 화면을 보여준다.
	 * 
	 * @param historyVO
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/database.do")
	public ModelAndView database(HttpServletRequest request) {
		
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "MN000303");
		
		ModelAndView mv = new ModelAndView();
		try {
			mv.addObject("read_aut_yn", menuAut.get(0).get("read_aut_yn"));
			mv.addObject("wrt_aut_yn", menuAut.get(0).get("wrt_aut_yn"));
			mv.setViewName("admin/dbServerManager/database");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
	
	
	/**
	 * [DB DATABASE] Repository DB에 등록되어 있는 DB의 서버명 SelectBox 
	 * 
	 * @return resultSet
	 * @throws Exception
	 */
	@SuppressWarnings("unused")
	@RequestMapping(value = "/selectDatabaseSvrList.do")
	@ResponseBody
	public List<Map<String, Object>> selectDatabaseSvrList(HttpServletRequest request, HttpServletResponse response) {
		
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "MN000303");
				
		List<Map<String, Object>> resultSet = null;
		try {
			//읽기권한이 없는경우
			if(menuAut.get(0).get("read_aut_yn").equals("N")){
				response.sendRedirect("/autError.do");
				return resultSet;
			}	
			int db_svr_id = 0;		
			if(request.getParameter("db_svr_id") != null){
				db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));		
			}	
			resultSet = dbServerManagerService.selectSvrList(db_svr_id);	
		} catch (Exception e) {
			e.printStackTrace();
		}
		return resultSet;
	}
	
	
	/**
	 * [DB DATABASE] Repository DB 리스트를 조회한다.
	 * 
	 * @return resultSet
	 * @throws Exception
	 */
	@SuppressWarnings("unused")
	@RequestMapping(value = "/selectDatabaseRepoDBList.do")
	@ResponseBody
	public List<Map<String, Object>> selectDatabaseRepoDBList(HttpServletRequest request, HttpServletResponse response) {
		
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "MN000303");

		HashMap<String, Object> paramvalue = new HashMap<String, Object>();
		
		String db_svr_nm = request.getParameter("db_svr_nm");
		String ipadr = request.getParameter("ipadr");
		String dft_db_nm = request.getParameter("dft_db_nm");
		
		paramvalue.put("db_svr_nm", db_svr_nm);
		paramvalue.put("ipadr", ipadr);
		paramvalue.put("dft_db_nm", dft_db_nm);

		List<Map<String, Object>> resultSet = null;
		try {		
			
			//읽기권한이 없는경우
			if(menuAut.get(0).get("read_aut_yn").equals("N")){
				response.sendRedirect("/autError.do");
				return resultSet;
			}	
			
			resultSet = dbServerManagerService.selectRepoDBList(paramvalue);		
		} catch (Exception e) {
			e.printStackTrace();
		}
		return resultSet;
	}
}
