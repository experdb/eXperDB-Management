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

import com.k4m.dx.tcontrol.accesscontrol.service.AccessControlService;
import com.k4m.dx.tcontrol.accesscontrol.service.AccessControlVO;
import com.k4m.dx.tcontrol.accesscontrol.service.DbIDbServerVO;
import com.k4m.dx.tcontrol.admin.accesshistory.service.AccessHistoryService;
import com.k4m.dx.tcontrol.admin.dbserverManager.service.DbServerManagerService;
import com.k4m.dx.tcontrol.admin.dbserverManager.service.DbServerVO;
import com.k4m.dx.tcontrol.admin.menuauthority.service.MenuAuthorityService;
import com.k4m.dx.tcontrol.backup.service.DbVO;
import com.k4m.dx.tcontrol.cmmn.CmmnUtils;
import com.k4m.dx.tcontrol.cmmn.client.ClientInfoCmmn;
import com.k4m.dx.tcontrol.cmmn.client.ClientProtocolID;
import com.k4m.dx.tcontrol.common.service.AgentInfoVO;
import com.k4m.dx.tcontrol.common.service.CmmnServerInfoService;
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
				//이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0009");
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
				//이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0009_01");
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
				//이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0010");
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
	public List<DbVO> selectDBList(@ModelAttribute("historyVO") HistoryVO historyVO, @ModelAttribute("dbVO") DbVO dbVO, HttpServletResponse response) {
		
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
				resultSet = dbServerManagerService.selectDbList();		
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
	public @ResponseBody boolean insertDB(@ModelAttribute("accessControlVO") AccessControlVO accessControlVO,@ModelAttribute("dbServerVO") DbServerVO dbServerVO, @ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request, HttpServletResponse response) throws ParseException {
		
		//해당메뉴 권한 조회 (공통메소드호출)
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "MN000303");
		
		try {
			//쓰기 권한이 없는경우 에러페이지 호출 [추후 Exception 처리예정]
			if(menuAut.get(0).get("wrt_aut_yn").equals("N")){
				response.sendRedirect("/autError.do");
				return false;
			}else{
				//이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0010_01");
				accessHistoryService.insertHistory(historyVO);
				
				String id = (String) request.getSession().getAttribute("usr_id");
				
				dbServerVO.setFrst_regr_id(id);
				dbServerVO.setLst_mdfr_id(id);
				
				String strRows = request.getParameter("rows").toString().replaceAll("&quot;", "\"");
	
				JSONArray rows = (JSONArray) new JSONParser().parse(strRows);
			
				dbServerManagerService.deleteDB(dbServerVO);
				accessControlService.deleteDbAccessControl(dbServerVO.getDb_svr_id());
				
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
				
				/*접근제어 정보 INSERT*/
				int db_svr_id = dbServerVO.getDb_svr_id();
				String strIpAdr = dbServerVO.getIpadr();
				
				AgentInfoVO vo = new AgentInfoVO();
				//vo.setDB_SVR_ID(db_svr_id);
				vo.setIPADR(strIpAdr);
				
				AgentInfoVO agentInfo =  (AgentInfoVO) cmmnServerInfoService.selectAgentInfo(vo);
			
				List<DbIDbServerVO> resultSet = accessControlService.selectDatabaseList(db_svr_id);
				
				String IP = resultSet.get(0).getIpadr();
				int PORT = agentInfo.getSOCKET_PORT();
				
				for(int n=0; n<resultSet.size(); n++){
					JSONObject result = new JSONObject();
					
					JSONObject serverObj = new JSONObject();				
					serverObj.put(ClientProtocolID.SERVER_NAME, resultSet.get(0).getDb_svr_nm());
					serverObj.put(ClientProtocolID.SERVER_IP, resultSet.get(0).getIpadr());
					serverObj.put(ClientProtocolID.SERVER_PORT, resultSet.get(0).getPortno());
					serverObj.put(ClientProtocolID.DATABASE_NAME, resultSet.get(0).getDft_db_nm());
					serverObj.put(ClientProtocolID.USER_ID, resultSet.get(0).getSvr_spr_usr_id());
					serverObj.put(ClientProtocolID.USER_PWD, resultSet.get(0).getSvr_spr_scm_pwd());
					
					ClientInfoCmmn cic = new ClientInfoCmmn();
					result = cic.dbAccess_selectAll(serverObj,IP,PORT);
					for(int j=0; j<result.size(); j++){
						 JSONArray data = (JSONArray)result.get("data");
						for(int m=0; m<data.size(); m++){
							JSONObject jsonObj = (JSONObject)data.get(m);
							accessControlVO.setFrst_regr_id(id);
							accessControlVO.setLst_mdfr_id(id);
							accessControlVO.setDb_svr_id(db_svr_id);
							accessControlVO.setDb_id(resultSet.get(n).getDb_id());
							accessControlVO.setPrms_ipadr((String)jsonObj.get("Ipadr"));
							accessControlVO.setPrms_usr_id((String)jsonObj.get("User"));
							accessControlVO.setCtf_mth_nm((String)jsonObj.get("Method"));
							accessControlVO.setCtf_tp_nm((String)jsonObj.get("Type"));
							accessControlVO.setOpt_nm((String)jsonObj.get("Option"));
							accessControlVO.setPrms_seq(Integer.parseInt((String) jsonObj.get("Seq")));
							accessControlVO.setPrms_set((String)jsonObj.get("Set"));
							accessControlService.insertAccessControl(accessControlVO);
						}
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return true;
	}
	
}
