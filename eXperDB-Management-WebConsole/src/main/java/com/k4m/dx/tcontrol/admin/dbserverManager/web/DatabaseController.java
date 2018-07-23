package com.k4m.dx.tcontrol.admin.dbserverManager.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.k4m.dx.tcontrol.accesscontrol.service.AccessControlHistoryVO;
import com.k4m.dx.tcontrol.accesscontrol.service.AccessControlService;
import com.k4m.dx.tcontrol.accesscontrol.service.AccessControlVO;
import com.k4m.dx.tcontrol.admin.accesshistory.service.AccessHistoryService;
import com.k4m.dx.tcontrol.admin.dbserverManager.service.DbServerManagerService;
import com.k4m.dx.tcontrol.admin.dbserverManager.service.DbServerVO;
import com.k4m.dx.tcontrol.admin.menuauthority.service.MenuAuthorityService;
import com.k4m.dx.tcontrol.backup.service.DbVO;
import com.k4m.dx.tcontrol.cmmn.CmmnUtils;
import com.k4m.dx.tcontrol.common.service.CmmnServerInfoService;
import com.k4m.dx.tcontrol.common.service.HistoryVO;
import com.k4m.dx.tcontrol.login.service.LoginVO;

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
	private AccessHistoryService accessHistoryService;
	
	@Autowired
	private MenuAuthorityService menuAuthorityService;

	@Autowired
	private DbServerManagerService dbServerManagerService;
	
	@Autowired
	private AccessControlService accessControlService;

	@Autowired
	private CmmnServerInfoService cmmnServerInfoService;
	
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
	public ModelAndView database(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		
		//해당메뉴 권한 조회 (공통메소드호출),
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "MN000303");
		
		ModelAndView mv = new ModelAndView();
		try {
			//읽기 권한이 없는경우 에러페이지 호출 [추후 Exception 처리예정]
			if(menuAut.get(0).get("read_aut_yn").equals("N")){
				mv.setViewName("error/autError");
			}else{
				// 화면접근이력 이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0009");
				historyVO.setMnu_id(11);
				accessHistoryService.insertHistory(historyVO);
				
				mv.addObject("read_aut_yn", menuAut.get(0).get("read_aut_yn"));
				mv.addObject("wrt_aut_yn", menuAut.get(0).get("wrt_aut_yn"));
				mv.setViewName("admin/dbServerManager/database");
			}
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
	public List<Map<String, Object>> selectDatabaseSvrList(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request, HttpServletResponse response) {
		
		//해당메뉴 권한 조회 (공통메소드호출),
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "MN000303");
				
		List<Map<String, Object>> resultSet = null;
		try {
			//읽기 권한이 없는경우 에러페이지 호출 [추후 Exception 처리예정]
			if(menuAut.get(0).get("read_aut_yn").equals("N")){
				response.sendRedirect("/autError.do");
				return resultSet;
			}else{
				int db_svr_id = 0;		
				if(request.getParameter("db_svr_id") != null){
					db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));		
				}	
				resultSet = dbServerManagerService.selectSvrList(db_svr_id);		
			}
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
	public List<Map<String, Object>> selectDatabaseRepoDBList(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request, HttpServletResponse response) {
		
		//해당메뉴 권한 조회 (공통메소드호출)
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "MN000303");

		HashMap<String, Object> paramvalue = new HashMap<String, Object>();
		
		List<Map<String, Object>> resultSet = null;
		try {				
			//읽기 권한이 없는경우 에러페이지 호출 [추후 Exception 처리예정]
			if(menuAut.get(0).get("read_aut_yn").equals("N")){
				response.sendRedirect("/autError.do");
				return resultSet;
			}else{
				// 화면접근이력 이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0009_02");
				historyVO.setMnu_id(11);
				accessHistoryService.insertHistory(historyVO);
				
				String db_svr_nm = request.getParameter("db_svr_nm");
				String ipadr = request.getParameter("ipadr");
				String dft_db_nm = request.getParameter("dft_db_nm");
				
				paramvalue.put("db_svr_nm", db_svr_nm);
				paramvalue.put("ipadr", ipadr);
				paramvalue.put("dft_db_nm", dft_db_nm);
				
				resultSet = dbServerManagerService.selectRepoDBList(paramvalue);		
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return resultSet;
	}
	
	
	/**
	 * DB 등록 팝업 화면을 보여준다.
	 * 
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/popup/dbRegForm.do")
	public ModelAndView dbRegForm(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		
		//해당메뉴 권한 조회 (공통메소드호출)
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "MN000303");
		
		ModelAndView mv = new ModelAndView();
		try {				
			//쓰기 권한이 없는경우 에러페이지 호출 [추후 Exception 처리예정]
			if(menuAut.get(0).get("wrt_aut_yn").equals("N")){
				mv.setViewName("error/autError");
			}else{
				// 화면접근이력 이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0010");
				historyVO.setMnu_id(11);
				accessHistoryService.insertHistory(historyVO);
				
				mv.addObject("read_aut_yn", menuAut.get(0).get("read_aut_yn"));
				mv.addObject("wrt_aut_yn", menuAut.get(0).get("wrt_aut_yn"));
				mv.setViewName("popup/dbRegForm");
			}	
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
	
	
	/**
	 * DB등록 팝업창에서 DB서버 리스트를 조회한다.
	 * 
	 * @return resultSet
	 * @throws Exception
	 */
	@SuppressWarnings("unused")
	@RequestMapping(value = "/selectDBList.do")
	@ResponseBody
	public List<DbVO> selectDBList(@ModelAttribute("historyVO") HistoryVO historyVO, @ModelAttribute("dbVO") DbVO dbVO, HttpServletResponse response, HttpServletRequest request) {
		
		//해당메뉴 권한 조회 (공통메소드호출)
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "MN000303");
		
		List<DbVO> resultSet = null;
		try {
			//읽기 권한이 없는경우 에러페이지 호출 [추후 Exception 처리예정]
			if(menuAut.get(0).get("read_aut_yn").equals("N")){
				response.sendRedirect("/autError.do");
				return resultSet;
			}else{
				int db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));
				resultSet = dbServerManagerService.selectDbListTree(db_svr_id);		
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return resultSet;
	}
	
	
	/**
	 * DB등록 팝업창에서 DB를 등록 한다.
	 * 
	 * @param dbServerVO
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/insertDB.do")
	public @ResponseBody boolean insertDB(@ModelAttribute("accessControlHistoryVO") AccessControlHistoryVO accessControlHistoryVO,@ModelAttribute("accessControlVO") AccessControlVO accessControlVO,@ModelAttribute("dbServerVO") DbServerVO dbServerVO, @ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request, HttpServletResponse response) throws ParseException {
		
		//해당메뉴 권한 조회 (공통메소드호출)
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "MN000303");
		List<DbVO> resultSet = null;
		
		try {
			//쓰기 권한이 없는경우 에러페이지 호출 [추후 Exception 처리예정]
			if(menuAut.get(0).get("wrt_aut_yn").equals("N")){
				response.sendRedirect("/autError.do");
				return false;
			}else{
				// 화면접근이력 이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0010_01");
				historyVO.setMnu_id(11);
				accessHistoryService.insertHistory(historyVO);
						
				HttpSession session = request.getSession();
				LoginVO loginVo = (LoginVO) session.getAttribute("session");
				String id = loginVo.getUsr_id();
				
				dbServerVO.setFrst_regr_id(id);
				dbServerVO.setLst_mdfr_id(id);
				
				String strRows = request.getParameter("rows").toString().replaceAll("&quot;", "\"");
	
				JSONArray rows = (JSONArray) new JSONParser().parse(strRows);
		
				
				HashMap<String, Object> paramvalue = new HashMap<String, Object>();
				
				int db_svr_id = dbServerVO.getDb_svr_id();
				resultSet = dbServerManagerService.selectDbListTree(db_svr_id);

				if(resultSet.size() != 0){
					for (int i = 0; i < rows.size(); i++) {					
						int cnt = 0; 
						for(int j=0; j<resultSet.size(); j++){					
							JSONObject jsrow = (JSONObject) rows.get(i);
							String dft_db_nm = jsrow.get("dft_db_nm").toString();
							String useyn = jsrow.get("useyn").toString();
							String db_exp = jsrow.get("db_exp").toString();
							if(dft_db_nm.equals(resultSet.get(j).getDb_nm())){
								cnt ++;
							}	
							paramvalue.put("db_svr_id", dbServerVO.getDb_svr_id());
							paramvalue.put("dft_db_nm", dft_db_nm);
							paramvalue.put("frst_regr_id", dbServerVO.getFrst_regr_id());
							paramvalue.put("lst_mdfr_id", dbServerVO.getLst_mdfr_id());
							paramvalue.put("useyn", useyn);
							paramvalue.put("db_exp", db_exp);
						}	
						if(cnt == 1){
							System.out.println("============== update Data ==============");
							System.out.println("DB 명 : "+ paramvalue.get("dft_db_nm"));
							System.out.println("사용여부 : "+ paramvalue.get("useyn"));
							System.out.println("====================================");
							dbServerManagerService.updateDB(paramvalue);			
						}else{
							System.out.println("============== insert data ==============");
							System.out.println("DB 명 : "+ paramvalue.get("dft_db_nm"));
							System.out.println("사용여부 : "+ paramvalue.get("useyn"));
							System.out.println("====================================");
							dbServerManagerService.insertDB(paramvalue);	
						}							
					}
				}else{
					for (int i = 0; i < rows.size(); i++) {
						JSONObject jsrow = (JSONObject) rows.get(i);
						String dft_db_nm = jsrow.get("dft_db_nm").toString();
						String useyn = jsrow.get("useyn").toString();
						String db_exp = jsrow.get("db_exp").toString();

						paramvalue.put("db_svr_id", dbServerVO.getDb_svr_id());
						paramvalue.put("dft_db_nm", dft_db_nm);
						paramvalue.put("frst_regr_id", dbServerVO.getFrst_regr_id());
						paramvalue.put("lst_mdfr_id", dbServerVO.getLst_mdfr_id());
						paramvalue.put("useyn", useyn);
						paramvalue.put("db_exp", db_exp);

						dbServerManagerService.insertDB(paramvalue);	
					}
				}
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return true;
	}
	
}
