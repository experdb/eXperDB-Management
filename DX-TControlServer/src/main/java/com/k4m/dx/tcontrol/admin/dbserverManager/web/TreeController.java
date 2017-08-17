package com.k4m.dx.tcontrol.admin.dbserverManager.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
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

import com.k4m.dx.tcontrol.accesscontrol.service.AccessControlService;
import com.k4m.dx.tcontrol.accesscontrol.service.AccessControlVO;
import com.k4m.dx.tcontrol.accesscontrol.service.DbIDbServerVO;
import com.k4m.dx.tcontrol.admin.dbserverManager.service.DbServerManagerService;
import com.k4m.dx.tcontrol.admin.dbserverManager.service.DbServerVO;
import com.k4m.dx.tcontrol.admin.menuauthority.service.MenuAuthorityService;
import com.k4m.dx.tcontrol.backup.service.DbVO;
import com.k4m.dx.tcontrol.cmmn.AES256;
import com.k4m.dx.tcontrol.cmmn.AES256_KEY;
import com.k4m.dx.tcontrol.cmmn.CmmnUtils;
import com.k4m.dx.tcontrol.cmmn.client.ClientInfoCmmn;
import com.k4m.dx.tcontrol.cmmn.client.ClientProtocolID;
import com.k4m.dx.tcontrol.common.service.CmmnHistoryService;
import com.k4m.dx.tcontrol.common.service.CmmnServerInfoService;
import com.k4m.dx.tcontrol.common.service.CmmnVO;
import com.k4m.dx.tcontrol.common.service.HistoryVO;
import com.k4m.dx.tcontrol.functions.schedule.ScheduleUtl;

/**
 * [DB TREE] 컨트롤러 클래스를 정의한다.
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

	@Autowired
	private CmmnServerInfoService cmmnServerInfoService;
	
	private List<Map<String, Object>> menuAut;
	
	
	/**
	 * [DB TREE] DB Tree 화면을 보여준다.
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
			mv.addObject("read_aut_yn", menuAut.get(0).get("read_aut_yn"));
			mv.addObject("wrt_aut_yn", menuAut.get(0).get("wrt_aut_yn"));
			mv.setViewName("admin/dbServerManager/dbTree");
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
	
	
	
	/**
	 * [DB TREE] DB서버 리스트를 조회한다.
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
			
			//읽기권한이 있을경우
			if(menuAut.get(0).get("read_aut_yn").equals("Y")){
				resultSet = dbServerManagerService.selectDbServerList(dbServerVO);
			}else{
				return resultSet;
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return resultSet;
	}
	
	
	
	/**
	 * [DB TREE] DB서버에 대한 DB 리스트를 조회한다.
	 * 
	 * @return resultSet
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectTreeServerDBList.do")
	@ResponseBody
	public Map<String, Object> selectServerDBList (@ModelAttribute("dbServerVO") DbServerVO dbServerVO, HttpServletRequest request) {
		
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "15");
		
		Map<String, Object> result =new HashMap<String, Object>();
	
		try {
			AES256 aes = new AES256(AES256_KEY.ENC_KEY);
			String db_svr_nm = request.getParameter("db_svr_nm");
			System.out.println(db_svr_nm);
			
			List<DbServerVO> resultSet = cmmnServerInfoService.selectDbServerList(db_svr_nm);
			
			JSONObject serverObj = new JSONObject();
			
			serverObj.put(ClientProtocolID.SERVER_NAME, resultSet.get(0).getDb_svr_nm());
			serverObj.put(ClientProtocolID.SERVER_IP, resultSet.get(0).getIpadr());
			serverObj.put(ClientProtocolID.SERVER_PORT, resultSet.get(0).getPortno());
			serverObj.put(ClientProtocolID.DATABASE_NAME, resultSet.get(0).getDft_db_nm());
			serverObj.put(ClientProtocolID.USER_ID, resultSet.get(0).getSvr_spr_usr_id());
			serverObj.put(ClientProtocolID.USER_PWD, aes.aesDecode(resultSet.get(0).getSvr_spr_scm_pwd()));
			
			
			//읽기권한이 있을경우
			if(menuAut.get(0).get("read_aut_yn").equals("Y")){
				ClientInfoCmmn cic = new ClientInfoCmmn();
				result = cic.db_List(serverObj);
			}else{
				return result;
			}
			//System.out.println(result);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	
	
	/**
	 * [DB TREE] Reposytory DB서버 리스트를 조회한다.
	 * 
	 * @return resultSet
	 * @throws Exception
	 */
	@SuppressWarnings("unused")
	@RequestMapping(value = "/selectTreeDBList.do")
	@ResponseBody
	public List<DbVO> selectTreeDBList(@ModelAttribute("dbVO") DbVO dbVO) {
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "15");
		
		List<DbVO> resultSet = null;
		try {
			//읽기권한이 있을경우
			if(menuAut.get(0).get("read_aut_yn").equals("Y")){
				resultSet = dbServerManagerService.selectDbList();		
			}else{
				return resultSet;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return resultSet;
	}
	
	
	
	/**
	 * [DB TREE] DB를 등록 한다.
	 * 
	 * @param dbServerVO
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/insertTreeDB.do")
	public @ResponseBody boolean insertTreeDB(@ModelAttribute("accessControlVO") AccessControlVO accessControlVO,@ModelAttribute("dbServerVO") DbServerVO dbServerVO, @ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) throws ParseException {
		try {
			CmmnUtils cu = new CmmnUtils();
			menuAut = cu.selectMenuAut(menuAuthorityService, "15");
			
			String id = (String) request.getSession().getAttribute("usr_id");
			
			dbServerVO.setFrst_regr_id(id);
			dbServerVO.setLst_mdfr_id(id);
			
			String strRows = request.getParameter("rows").toString().replaceAll("&quot;", "\"");

			JSONArray rows = (JSONArray) new JSONParser().parse(strRows);
			
			//쓰기권한이 있을경우
			if(menuAut.get(0).get("wrt_aut_yn").equals("Y")){
				dbServerManagerService.deleteDB(dbServerVO);
				accessControlService.deleteDbAccessControl(dbServerVO.getDb_svr_id());
			}else{
				return true;
			}
			
			
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
			
			//쓰기권한이 있을경우
			if(menuAut.get(0).get("wrt_aut_yn").equals("Y")){	
				dbServerManagerService.insertDB(paramvalue);		
			}else{
				return true;
			}
			
			}
			/*접근제어 정보 INSERT*/
			int db_svr_id = dbServerVO.getDb_svr_id();
			List<DbIDbServerVO> resultSet = accessControlService.selectDatabaseList(db_svr_id);
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
				result = cic.dbAccess_selectAll(serverObj);
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
		} catch (Exception e) {
			e.printStackTrace();
		}
		return true;
	}
}
