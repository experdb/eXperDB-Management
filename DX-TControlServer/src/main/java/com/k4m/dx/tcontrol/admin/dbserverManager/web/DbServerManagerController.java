package com.k4m.dx.tcontrol.admin.dbserverManager.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
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

import com.k4m.dx.tcontrol.admin.dbserverManager.service.DbServerManagerService;
import com.k4m.dx.tcontrol.admin.dbserverManager.service.DbServerVO;
import com.k4m.dx.tcontrol.backup.service.DbVO;
import com.k4m.dx.tcontrol.cmmn.client.ClientInfoCmmn;
import com.k4m.dx.tcontrol.cmmn.client.ClientProtocolID;
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
			System.out.println("서버명 : " + dbServerVO.getDb_svr_id());
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
	public @ResponseBody Map<String, Object> dbServerConnTest(@ModelAttribute("dbServerVO") DbServerVO dbServerVO) {
		
		Map<String, Object> result =new HashMap<String, Object>();
	
		try {
				
			System.out.println("=======parameter=======");
			System.out.println("서버명 : " + dbServerVO.getDb_svr_nm());
			System.out.println("Database : " + dbServerVO.getDft_db_nm());
			System.out.println("아이피 : " + dbServerVO.getIpadr());			
			System.out.println("포트 : " + dbServerVO.getPortno());
			System.out.println("유저 : " + dbServerVO.getSvr_spr_usr_id());
			System.out.println("패스워드 : " + dbServerVO.getSvr_spr_scm_pwd());
			System.out.println("=====================");
			
			JSONObject serverObj = new JSONObject();
			
			serverObj.put(ClientProtocolID.SERVER_NAME, dbServerVO.getDb_svr_nm());
			serverObj.put(ClientProtocolID.SERVER_IP, dbServerVO.getIpadr());
			serverObj.put(ClientProtocolID.SERVER_PORT, dbServerVO.getPortno());
			serverObj.put(ClientProtocolID.DATABASE_NAME, dbServerVO.getDft_db_nm());
			serverObj.put(ClientProtocolID.USER_ID, dbServerVO.getSvr_spr_usr_id());
			serverObj.put(ClientProtocolID.USER_PWD, dbServerVO.getSvr_spr_scm_pwd());
			
			ClientInfoCmmn conn  = new ClientInfoCmmn();
			
			result = conn.DbserverConn(serverObj);
			
			System.out.println(result.get("result_data"));
			
		}catch (Exception e) {
			e.printStackTrace();
		}
		return result;		
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
	
	/**
	 * DB서버 수정 화면을 보여준다.
	 * 
	 * @param historyVO
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/popup/dbServerRegReForm.do")
	public ModelAndView dbServerRegReForm() {
		ModelAndView mv = new ModelAndView();
		try {
			mv.setViewName("popup/dbServerRegReForm");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
	
	
	/**
	 * DB서버를 수정한다.
	 * @param cmmnCodeVO
	 * @throws Exception
	 * @return "forward:/cmmnCodeList.do"
	 */
	@RequestMapping(value = "/updateDbServer.do")
	public @ResponseBody boolean updateDbServer(@ModelAttribute("dbServerVO") DbServerVO dbServerVO, HttpServletRequest request){
		try {
			
			String usr_id = (String) request.getSession().getAttribute("usr_id");
			dbServerVO.setLst_mdfr_id(usr_id);

			dbServerManagerService.updateDbServer(dbServerVO);
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
		return true;
	}
	
	
	/**
	 * DB서버를 삭제한다.
	 * @param cmmnCodeVO
	 * @throws Exception
	 * @return "forward:/cmmnCodeList.do"
	 */
/*	@RequestMapping(value = "/deleteCmmnCode.do")
	public @ResponseBody String deleteCmmnCode(@ModelAttribute("cmmnCodeVO") CmmnCodeVO cmmnCodeVO){
		try {
			cmmnCodeService.deleteCmmnCode(cmmnCodeVO);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "forward:/cmmnCodeList.do";
	}*/
	
	
	/**
	 * DB를 등록 한다.
	 * 
	 * @param dbServerVO
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/insertDB.do")
	public @ResponseBody boolean insertDB(@ModelAttribute("dbServerVO") DbServerVO dbServerVO, @ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) throws ParseException {
		try {
			String id = (String) request.getSession().getAttribute("usr_id");
			
			dbServerVO.setFrst_regr_id(id);
			dbServerVO.setLst_mdfr_id(id);
			
			String strRows = request.getParameter("rows").toString().replaceAll("&quot;", "\"");

			System.out.println(strRows);
			JSONArray rows = (JSONArray) new JSONParser().parse(strRows);
		
			dbServerManagerService.deleteDB(dbServerVO);
			
			HashMap<String, Object> paramvalue = new HashMap<String, Object>();
			
			for (int i = 0; i < rows.size(); i++) {
				JSONObject jsrow = (JSONObject) rows.get(i);
				String dft_db_nm = jsrow.get("dft_db_nm").toString();
				
				paramvalue.put("db_svr_id", dbServerVO.getDb_svr_id());
				paramvalue.put("dft_db_nm", dft_db_nm);
				paramvalue.put("frst_regr_id", dbServerVO.getFrst_regr_id());
				paramvalue.put("lst_mdfr_id", dbServerVO.getLst_mdfr_id());
				
				System.out.println("============== parameter ==============");
				System.out.println("DB 서버 ID : "+ paramvalue.get("db_svr_id"));
				System.out.println("DB 명 : "+ paramvalue.get("dft_db_nm"));
				System.out.println("등록자 : "+ paramvalue.get("frst_regr_id"));
				System.out.println("수정자 : "+ paramvalue.get("lst_mdfr_id"));
				System.out.println("====================================");
			
			dbServerManagerService.insertDB(paramvalue);		
			
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return true;
	}
	
	
	/**
	 * DB서버 리스트를 조회한다.
	 * 
	 * @return resultSet
	 * @throws Exception
	 */
	@SuppressWarnings("unused")
	@RequestMapping(value = "/selectDBList.do")
	@ResponseBody
	public List<DbVO> selectDBList(@ModelAttribute("dbVO") DbVO dbVO) {
		List<DbVO> resultSet = null;
		try {
			resultSet = dbServerManagerService.selectDbList();			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return resultSet;
	}
	
	
	/**
	 * Repository DB 리스트를 조회한다.
	 * 
	 * @return resultSet
	 * @throws Exception
	 */
	@SuppressWarnings("unused")
	@RequestMapping(value = "/selectRepoDBList.do")
	@ResponseBody
	public List<Map<String, Object>> selectRepoDBList(HttpServletRequest request) {

		HashMap<String, Object> paramvalue = new HashMap<String, Object>();
		
		String db_svr_nm = request.getParameter("db_svr_nm");
		String ipadr = request.getParameter("ipadr");
		String dft_db_nm = request.getParameter("dft_db_nm");
		
		paramvalue.put("db_svr_nm", db_svr_nm);
		paramvalue.put("ipadr", ipadr);
		paramvalue.put("dft_db_nm", dft_db_nm);

		List<Map<String, Object>> resultSet = null;
		try {			
			resultSet = dbServerManagerService.selectRepoDBList(paramvalue);			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return resultSet;
	}
	
	
	/**
	 * Repository DB에 등록되어 있는 DB의 서버명 SelectBox 
	 * 
	 * @return resultSet
	 * @throws Exception
	 */
	@SuppressWarnings("unused")
	@RequestMapping(value = "/selectSvrList.do")
	@ResponseBody
	public List<Map<String, Object>> selectSvrList() {
		List<Map<String, Object>> resultSet = null;
		try {			
			resultSet = dbServerManagerService.selectSvrList();			
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
	public ModelAndView dbRegForm(HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		try {				
			mv.setViewName("popup/dbRegForm");		
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
}
