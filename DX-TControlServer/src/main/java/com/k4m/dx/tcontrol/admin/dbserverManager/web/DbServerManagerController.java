package com.k4m.dx.tcontrol.admin.dbserverManager.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
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
import com.k4m.dx.tcontrol.cmmn.AES256;
import com.k4m.dx.tcontrol.cmmn.AES256_KEY;
import com.k4m.dx.tcontrol.cmmn.CmmnUtils;
import com.k4m.dx.tcontrol.cmmn.client.ClientInfoCmmn;
import com.k4m.dx.tcontrol.cmmn.client.ClientProtocolID;
import com.k4m.dx.tcontrol.common.service.AgentInfoVO;
import com.k4m.dx.tcontrol.common.service.CmmnServerInfoService;
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
	 * DB서버 등록 팝업 화면을 보여준다.
	 * 
	 * @param historyVO
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/popup/dbServerRegForm.do")
	public ModelAndView dbServerRegForm(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		
		ModelAndView mv = new ModelAndView();
		
		//해당메뉴 권한 조회 (공통메소드호출),
		CmmnUtils cu = new CmmnUtils();
		if(request.getParameter("flag").equals("tree")){
			menuAut = cu.selectMenuAut(menuAuthorityService, "MN000301");
		}else{
			menuAut = cu.selectMenuAut(menuAuthorityService, "MN000302");
		}		
		try {
			//읽기 권한이 없는경우 error페이지 호출 , [추후 Exception 처리예정]
			if(menuAut.get(0).get("wrt_aut_yn").equals("N")){
				mv.setViewName("error/autError");
			}else{
				//이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0007");
				accessHistoryService.insertHistory(historyVO);
				
				mv.addObject("read_aut_yn", menuAut.get(0).get("read_aut_yn"));
				mv.addObject("wrt_aut_yn", menuAut.get(0).get("wrt_aut_yn"));
				mv.setViewName("popup/dbServerRegForm");
			}
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
	
		List<DbServerVO> result = null;
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
	public @ResponseBody Map<String, Object> dbServerConnTest(@ModelAttribute("historyVO") HistoryVO historyVO, @ModelAttribute("dbServerVO") DbServerVO dbServerVO, HttpServletRequest request) {
		
		Map<String, Object> result =new HashMap<String, Object>();
	
		try {
			//이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0007_02");
			accessHistoryService.insertHistory(historyVO);
			
			AES256 aes = new AES256(AES256_KEY.ENC_KEY);
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
			if(request.getParameter("check").equals("i")){
				serverObj.put(ClientProtocolID.USER_PWD, dbServerVO.getSvr_spr_scm_pwd());
			}else{
				//암호 복호화
				serverObj.put(ClientProtocolID.USER_PWD, aes.aesDecode(dbServerVO.getSvr_spr_scm_pwd()));
			}
			
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
		AES256 aes = new AES256(AES256_KEY.ENC_KEY);
		try {
			//이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0007_01");
			accessHistoryService.insertHistory(historyVO);
			
			String id = (String) request.getSession().getAttribute("usr_id");
			System.out.println(id);
			
			dbServerVO.setFrst_regr_id(id);
			dbServerVO.setLst_mdfr_id(id);
			
			
			//비밀번호 암호화
			//String pw = SHA256.SHA256(dbServerVO.getSvr_spr_scm_pwd());
			String pw = aes.aesEncode(dbServerVO.getSvr_spr_scm_pwd());
			dbServerVO.setSvr_spr_scm_pwd(pw);
			
			System.out.println("=======parameter=======");
			System.out.println("서버명 : " + dbServerVO.getDb_svr_nm());
			System.out.println("Database : " + dbServerVO.getDft_db_nm());
			System.out.println("아이피 : " + dbServerVO.getIpadr());			
			System.out.println("포트 : " + dbServerVO.getPortno());
			System.out.println("유저 : " + dbServerVO.getSvr_spr_usr_id());
			System.out.println("패스워드 : " + dbServerVO.getSvr_spr_scm_pwd());
			System.out.println("서버저장경로 : " + dbServerVO.getIstpath());
			System.out.println("=====================");
			
			dbServerManagerService.insertDbServer(dbServerVO);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	/**
	 * DB서버 수정 팝업 화면을 보여준다.
	 * 
	 * @param historyVO
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/popup/dbServerRegReForm.do")
	public ModelAndView dbServerRegReForm(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		
		ModelAndView mv = new ModelAndView();
		
		//해당메뉴 권한 조회 (공통메소드호출),
		CmmnUtils cu = new CmmnUtils();
		if(request.getParameter("flag").equals("tree")){
			menuAut = cu.selectMenuAut(menuAuthorityService, "MN000301");
		}else{
			menuAut = cu.selectMenuAut(menuAuthorityService, "MN000302");
		}	
		try {
			//읽기 권한이 없는경우 error페이지 호출 , [추후 Exception 처리예정]
			if(menuAut.get(0).get("wrt_aut_yn").equals("N")){
				mv.setViewName("error/autError");
			}else{
				//이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0008");
				accessHistoryService.insertHistory(historyVO);
				
				mv.addObject("read_aut_yn", menuAut.get(0).get("read_aut_yn"));
				mv.addObject("wrt_aut_yn", menuAut.get(0).get("wrt_aut_yn"));
				mv.setViewName("popup/dbServerRegReForm");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
	
	
	/**
	 * DB서버 수정 팝업창에서 DB서버를 수정한다.
	 * @param cmmnCodeVO
	 * @throws Exception
	 * @return "forward:/cmmnCodeList.do"
	 */
	@RequestMapping(value = "/updateDbServer.do")
	public @ResponseBody boolean updateDbServer(@ModelAttribute("historyVO") HistoryVO historyVO, @ModelAttribute("dbServerVO") DbServerVO dbServerVO, HttpServletRequest request){
		try {
			//이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0008_01");
			accessHistoryService.insertHistory(historyVO);
			
			AES256 aes = new AES256(AES256_KEY.ENC_KEY);
			String usr_id = (String) request.getSession().getAttribute("usr_id");
			dbServerVO.setLst_mdfr_id(usr_id);

			//비밀번호 암호화
			String pw = aes.aesEncode(dbServerVO.getSvr_spr_scm_pwd());
			dbServerVO.setSvr_spr_scm_pwd(pw);
			
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
	 * Repository DB에 등록되어 있는 DB의 서버명 SelectBox 
	 * 
	 * @return resultSet
	 * @throws Exception
	 */
	@SuppressWarnings("unused")
	@RequestMapping(value = "/selectSvrList.do")
	@ResponseBody
	public List<Map<String, Object>> selectSvrList(HttpServletRequest request) {
	
		List<Map<String, Object>> resultSet = null;
		try {		
			int db_svr_id = 0;
			
			if(request.getParameter("db_svr_id") != null){
				db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));		
				System.out.println(db_svr_id);
			}

			
			resultSet = dbServerManagerService.selectSvrList(db_svr_id);	
		} catch (Exception e) {
			e.printStackTrace();
		}
		return resultSet;
	}
	
	
	
	/**
	 * 중복 아이디를 체크한다.
	 * 
	 * @param usr_id
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/dbServerIpCheck.do")
	public @ResponseBody String dbServerIpCheck(@RequestParam("ipadr") String ipadr) {
		try {
			int resultSet = dbServerManagerService.dbServerIpCheck(ipadr);
			if (resultSet > 0) {
				// 중복값이 존재함.
				return "false";
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "true";
	}
}
