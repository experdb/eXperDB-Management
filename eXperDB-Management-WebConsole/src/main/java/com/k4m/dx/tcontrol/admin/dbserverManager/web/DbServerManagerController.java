package com.k4m.dx.tcontrol.admin.dbserverManager.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.TransactionDefinition;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.DefaultTransactionDefinition;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.k4m.dx.tcontrol.accesscontrol.service.AccessControlHistoryVO;
import com.k4m.dx.tcontrol.accesscontrol.service.AccessControlService;
import com.k4m.dx.tcontrol.accesscontrol.service.AccessControlVO;
import com.k4m.dx.tcontrol.admin.accesshistory.service.AccessHistoryService;
import com.k4m.dx.tcontrol.admin.dbserverManager.service.DbServerManagerService;
import com.k4m.dx.tcontrol.admin.dbserverManager.service.DbServerVO;
import com.k4m.dx.tcontrol.admin.dbserverManager.service.IpadrVO;
import com.k4m.dx.tcontrol.admin.menuauthority.service.MenuAuthorityService;
import com.k4m.dx.tcontrol.cmmn.AES256;
import com.k4m.dx.tcontrol.cmmn.AES256_KEY;
import com.k4m.dx.tcontrol.cmmn.CmmnUtils;
import com.k4m.dx.tcontrol.cmmn.client.ClientInfoCmmn;
import com.k4m.dx.tcontrol.cmmn.client.ClientProtocolID;
import com.k4m.dx.tcontrol.common.service.AgentInfoVO;
import com.k4m.dx.tcontrol.common.service.CmmnServerInfoService;
import com.k4m.dx.tcontrol.common.service.HistoryVO;
import com.k4m.dx.tcontrol.login.service.LoginVO;

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
	 * Mybatis Transaction 
	 */
	@Autowired
	private PlatformTransactionManager txManager;
	
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
		
		ModelAndView mv = new ModelAndView("jsonView");
		
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
				// 화면접근이력 이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0006");
				historyVO.setMnu_id(9);
				accessHistoryService.insertHistory(historyVO);
				
				mv.addObject("read_aut_yn", menuAut.get(0).get("read_aut_yn"));
				mv.addObject("wrt_aut_yn", menuAut.get(0).get("wrt_aut_yn"));
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
			AES256 aes = new AES256(AES256_KEY.ENC_KEY);
			
			System.out.println("=======parameter=======");
			System.out.println("서버명 : " + dbServerVO.getDb_svr_id());
			System.out.println("서버명 : " + dbServerVO.getDb_svr_nm());
			System.out.println("아이피 : " + dbServerVO.getIpadr());
			System.out.println("Database : " + dbServerVO.getDft_db_nm());
			System.out.println("=====================");
			
			resultSet = dbServerManagerService.selectDbServerList(dbServerVO);
			
			String svr_spr_scm_pwd = resultSet.get(0).getSvr_spr_scm_pwd();
			resultSet.get(0).setSvr_spr_scm_pwd(aes.aesDecode(svr_spr_scm_pwd));
			
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
	public @ResponseBody List<Map<String, Object>> dbServerConnTest(@ModelAttribute("historyVO") HistoryVO historyVO, @ModelAttribute("dbServerVO") DbServerVO dbServerVO, HttpServletRequest request) {
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		Map<String, Object> result =new HashMap<String, Object>();
		JSONObject serverObj = new JSONObject();
		AgentInfoVO vo = new AgentInfoVO();
		vo.setIPADR(dbServerVO.getIpadr());
		
		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0006_02");
			historyVO.setMnu_id(9);
			accessHistoryService.insertHistory(historyVO);
			
			String strRows = request.getParameter("datasArr").toString().replaceAll("&quot;", "\"");
			JSONArray rows = (JSONArray) new JSONParser().parse(strRows);
						
			for (int i = 0; i < rows.size(); i++) {
				JSONObject jsonObject = (JSONObject) rows.get(i);		
				
				AgentInfoVO agentInfo =  (AgentInfoVO) cmmnServerInfoService.selectAgentInfo(vo);
				String IP = jsonObject.get("SERVER_IP").toString();
				int PORT = agentInfo.getSOCKET_PORT();
				
				serverObj.put(ClientProtocolID.SERVER_NAME, jsonObject.get("SERVER_IP").toString());
				serverObj.put(ClientProtocolID.SERVER_IP, jsonObject.get("SERVER_IP").toString());
				serverObj.put(ClientProtocolID.SERVER_PORT, jsonObject.get("SERVER_PORT").toString());
				serverObj.put(ClientProtocolID.DATABASE_NAME, jsonObject.get("DATABASE_NAME").toString());
				serverObj.put(ClientProtocolID.USER_ID, jsonObject.get("USER_ID").toString());
				serverObj.put(ClientProtocolID.USER_PWD, jsonObject.get("USER_PWD").toString());
				
				
				
				System.out.println("DATABASE_NAME"+jsonObject.get("DATABASE_NAME").toString());
				System.out.println("USER_ID"+jsonObject.get("USER_ID").toString());
				System.out.println("USER_PWD"+ jsonObject.get("USER_PWD").toString());
				
				ClientInfoCmmn conn  = new ClientInfoCmmn();
				result = conn.DbserverConnTest(serverObj, IP, PORT);
				list.add(result);
			}
			
		}catch (Exception e) {
			e.printStackTrace();
		}
		return list;		
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
	public @ResponseBody void insertDbServer(@ModelAttribute("accessControlHistoryVO") AccessControlHistoryVO accessControlHistoryVO,@ModelAttribute("accessControlVO") AccessControlVO accessControlVO, @ModelAttribute("dbServerVO") DbServerVO dbServerVO, @ModelAttribute("ipadrVO") IpadrVO ipadrVO, @ModelAttribute("historyVO") HistoryVO historyVO,HttpServletRequest request) throws Exception {
		AES256 aes = new AES256(AES256_KEY.ENC_KEY);
		
		// Transaction 
		DefaultTransactionDefinition def  = new DefaultTransactionDefinition();
		def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
		TransactionStatus status = txManager.getTransaction(def);
				
		CmmnUtils.saveHistory(request, historyVO);
		historyVO.setExe_dtl_cd("DX-T0006_01");
		historyVO.setMnu_id(9);
		accessHistoryService.insertHistory(historyVO);
		
		String insertResult = "S";
		
		HttpSession session = request.getSession();
		LoginVO loginVo = (LoginVO) session.getAttribute("session");
		String id = loginVo.getUsr_id();

		dbServerVO.setFrst_regr_id(id);
		dbServerVO.setLst_mdfr_id(id);
		
		// T_DBSVR_I 데이터 등록
		try {			
			//비밀번호 암호화
			//String pw = SHA256.SHA256(dbServerVO.getSvr_spr_scm_pwd());
			String pw = aes.aesEncode(dbServerVO.getSvr_spr_scm_pwd());
			dbServerVO.setSvr_spr_scm_pwd(pw);
			
			System.out.println("=======parameter=======");
			System.out.println("서버명 : " + dbServerVO.getDb_svr_nm());
			System.out.println("Database : " + dbServerVO.getDft_db_nm());
			System.out.println("유저 : " + dbServerVO.getSvr_spr_usr_id());
			System.out.println("패스워드 : " + dbServerVO.getSvr_spr_scm_pwd());
			System.out.println("=====================");
			
			dbServerManagerService.insertDbServer(dbServerVO);
			
		} catch (Exception e) {
			e.printStackTrace();
			insertResult = "F";
		}
		
		
		// T_DBSVR_I 시퀀스 조회
		try {							
			int db_svr_id = dbServerManagerService.selectDbsvrid();
			ipadrVO.setDb_svr_id(db_svr_id);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		// ip등록
		if(insertResult.equals("S")){
			try {
				String strRows = request.getParameter("ipadrArr").toString().replaceAll("&quot;", "\"");
				JSONArray rows = (JSONArray) new JSONParser().parse(strRows);

				for (int i = 0; i < rows.size(); i++) {
					JSONObject jsrow = (JSONObject) rows.get(i);
					ipadrVO.setDb_svr_id(ipadrVO.getDb_svr_id());
					ipadrVO.setIPadr(jsrow.get("ipadr").toString());
					ipadrVO.setPortno(Integer.parseInt(jsrow.get("portno").toString()));
					ipadrVO.setMaster_gbn(jsrow.get("master_gbn").toString());
					ipadrVO.setSvr_host_nm(jsrow.get("svr_host_nm").toString());
					ipadrVO.setFrst_regr_id(id);
					ipadrVO.setLst_mdfr_id(id);
					dbServerManagerService.insertIpadr(ipadrVO);			
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		txManager.commit(status);
		
		
		/*접근제어 정보 INSERT*/
		int db_svr_id = dbServerVO.getDb_svr_id();
		AES256 dec = new AES256(AES256_KEY.ENC_KEY);
		
		/*서버접근제어 전체 삭제*/
		accessControlService.deleteDbAccessControl(db_svr_id);
		
		DbServerVO schDbServerVO = new DbServerVO();
		schDbServerVO.setDb_svr_id(db_svr_id);
		dbServerVO = (DbServerVO)  cmmnServerInfoService.selectServerInfo(schDbServerVO);
		String strIpAdr = dbServerVO.getIpadr();
		AgentInfoVO vo = new AgentInfoVO();
		vo.setIPADR(strIpAdr);
		AgentInfoVO agentInfo =  (AgentInfoVO) cmmnServerInfoService.selectAgentInfo(vo);

		String IP = dbServerVO.getIpadr();
		int PORT = agentInfo.getSOCKET_PORT();
		
		JSONObject result = new JSONObject();
		JSONObject serverObj = new JSONObject();				
		serverObj.put(ClientProtocolID.SERVER_NAME, dbServerVO.getDb_svr_nm());
		serverObj.put(ClientProtocolID.SERVER_IP, dbServerVO.getIpadr());
		serverObj.put(ClientProtocolID.SERVER_PORT, dbServerVO.getPortno());
		serverObj.put(ClientProtocolID.DATABASE_NAME, dbServerVO.getDft_db_nm());
		serverObj.put(ClientProtocolID.USER_ID, dbServerVO.getSvr_spr_usr_id());
		serverObj.put(ClientProtocolID.USER_PWD, dec.aesDecode(dbServerVO.getSvr_spr_scm_pwd()));
			
		ClientInfoCmmn cic = new ClientInfoCmmn();
		
		String strExtName = "adminpack";
		List<Object> results = cic.extension_select(serverObj,IP,PORT,strExtName);
		if(results != null || result.size() != 0) {
			int current_his_grp= accessControlService.selectCurrenthisrp();
			accessControlHistoryVO.setHis_grp_id(current_his_grp);
			
			result = cic.dbAccess_selectAll(serverObj,IP,PORT);
			for(int j=0; j<result.size(); j++){
				 JSONArray data = (JSONArray)result.get("data");
				for(int m=0; m<data.size(); m++){
						JSONObject jsonObj = (JSONObject)data.get(m);
						int svr_acs_cntr_id= accessControlService.selectCurrentCntrid();
						
						accessControlVO.setSvr_acs_cntr_id(svr_acs_cntr_id);
						accessControlVO.setFrst_regr_id(id);
						accessControlVO.setLst_mdfr_id(id);
						accessControlVO.setDb_svr_id(db_svr_id);
						accessControlVO.setDtb((String) jsonObj.get("Database"));
						accessControlVO.setPrms_ipadr((String)jsonObj.get("Ipadr"));
						accessControlVO.setPrms_ipmaskadr((String) jsonObj.get("Ipmask"));
						accessControlVO.setPrms_usr_id((String)jsonObj.get("User"));
						accessControlVO.setCtf_mth_nm((String)jsonObj.get("Method"));
						accessControlVO.setCtf_tp_nm((String)jsonObj.get("Type"));
						accessControlVO.setOpt_nm((String)jsonObj.get("Option"));
						accessControlVO.setPrms_seq(Integer.parseInt((String) jsonObj.get("Seq")));
						accessControlVO.setPrms_set((String)jsonObj.get("Set"));
						accessControlService.insertAccessControl(accessControlVO);
						
						accessControlHistoryVO.setLst_mdfr_id(id);
						accessControlHistoryVO.setDb_svr_id(db_svr_id);
						accessControlHistoryVO.setSvr_acs_cntr_id(svr_acs_cntr_id);
						accessControlHistoryVO.setDtb((String) jsonObj.get("Database"));
						accessControlHistoryVO.setPrms_ipadr((String)jsonObj.get("Ipadr"));
						accessControlHistoryVO.setPrms_ipmaskadr((String) jsonObj.get("Ipmask"));
						accessControlHistoryVO.setPrms_usr_id((String)jsonObj.get("User"));
						accessControlHistoryVO.setPrms_seq(Integer.parseInt((String) jsonObj.get("Seq")));
						accessControlHistoryVO.setPrms_set((String)jsonObj.get("Set"));
						accessControlHistoryVO.setCtf_mth_nm((String)jsonObj.get("Method"));
						accessControlHistoryVO.setCtf_tp_nm((String) jsonObj.get("Type"));
						accessControlHistoryVO.setOpt_nm((String)jsonObj.get("Option"));
						accessControlService.insertAccessControlHistory(accessControlHistoryVO);
					}
				}	
			}
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
		
		ModelAndView mv = new ModelAndView("jsonView");
		
		//해당메뉴 권한 조회 (공통메소드호출),
		CmmnUtils cu = new CmmnUtils();
		if(request.getParameter("flag").equals("tree")){
			menuAut = cu.selectMenuAut(menuAuthorityService, "MN000301");
		}else{
			menuAut = cu.selectMenuAut(menuAuthorityService, "MN000302");
		}	
		try {
			int db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));
			
			//읽기 권한이 없는경우 error페이지 호출 , [추후 Exception 처리예정]
			if(menuAut.get(0).get("wrt_aut_yn").equals("N")){
				mv.setViewName("error/autError");
			}else{
				// 화면접근이력 이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0007");
				historyVO.setMnu_id(9);
				accessHistoryService.insertHistory(historyVO);
				
				mv.addObject("read_aut_yn", menuAut.get(0).get("read_aut_yn"));
				mv.addObject("wrt_aut_yn", menuAut.get(0).get("wrt_aut_yn"));
				mv.addObject("db_svr_id", db_svr_id);
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
	public @ResponseBody void updateDbServer(@ModelAttribute("historyVO") HistoryVO historyVO, @ModelAttribute("ipadrVO") IpadrVO ipadrVO, @ModelAttribute("dbServerVO") DbServerVO dbServerVO, HttpServletRequest request){
						
		String updateResult = "S";
		String deleteResult = "S";
		
		// Transaction 
		DefaultTransactionDefinition def  = new DefaultTransactionDefinition();
		def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
		TransactionStatus status = txManager.getTransaction(def);
					
		HttpSession session = request.getSession();
		LoginVO loginVo = (LoginVO) session.getAttribute("session");
		String id = loginVo.getUsr_id();

		dbServerVO.setFrst_regr_id(id);
		dbServerVO.setLst_mdfr_id(id);
		
		// T_DBSVR_I 데이터 업데이트
		try {			
			AES256 aes = new AES256(AES256_KEY.ENC_KEY);
			
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0007_01");
			historyVO.setMnu_id(9);
			accessHistoryService.insertHistory(historyVO);
			
			//비밀번호 암호화
			//String pw = SHA256.SHA256(dbServerVO.getSvr_spr_scm_pwd());
			String pw = aes.aesEncode(dbServerVO.getSvr_spr_scm_pwd());
			dbServerVO.setSvr_spr_scm_pwd(pw);
			
			dbServerManagerService.updateDbServer(dbServerVO);
		} catch (Exception e) {
			e.printStackTrace();
			updateResult = "F";
		}
				
		//IP정보 삭제
		/*if(updateResult.equals("S")){
			try {			
				System.out.println(dbServerVO.getDb_svr_id());
				cmmnServerInfoService.deleteIpadr(dbServerVO);
				System.out.println("IP정보 삭제 완료");
			} catch (Exception e) {
				e.printStackTrace();
				deleteResult = "F";
			}
		}*/

		try {
			
			String db_svr_id = request.getParameter("db_svr_id");
			
			int ipadrCnt = dbServerManagerService.selectIpadrCnt();

			String strRows = request.getParameter("ipmaps").toString().replaceAll("&quot;", "\"");
			JSONArray rows = (JSONArray) new JSONParser().parse(strRows);

			List<String> ids = new ArrayList<String>(); 
			HashMap<String , Object> paramvalue = new HashMap<String, Object>();
			
			if(ipadrCnt >= rows.size()){
				for(int i=0; i<rows.size(); i++){
					ids.add(rows.get(i).toString()); 
				}
				paramvalue.put("db_svr_ipadr_id", ids);
				paramvalue.put("db_svr_id", db_svr_id);
				
				System.out.println(paramvalue.get("db_svr_ipadr_id"));
				
				dbServerManagerService.deleteIpadr(paramvalue);
				System.out.println("IP정보 삭제 완료");
			}
			
		} catch (Exception e1) {
			e1.printStackTrace();
		}			
		
		//아이피  등록
		if(deleteResult.equals("S")){
			try {
				String strRows = request.getParameter("ipadrArr").toString().replaceAll("&quot;", "\"");
				JSONArray rows = (JSONArray) new JSONParser().parse(strRows);

				for (int i = 0; i < rows.size(); i++) {	
					JSONObject jsrow = (JSONObject) rows.get(i);
					ipadrVO.setDb_svr_id(ipadrVO.getDb_svr_id());
					ipadrVO.setIPadr(jsrow.get("ipadr").toString());
					ipadrVO.setPortno(Integer.parseInt(jsrow.get("portno").toString()));
					ipadrVO.setMaster_gbn(jsrow.get("master_gbn").toString());
					ipadrVO.setSvr_host_nm(jsrow.get("svr_host_nm").toString());
					ipadrVO.setFrst_regr_id(id);
					ipadrVO.setLst_mdfr_id(id);					
					ipadrVO.setDb_svr_ipadr_id(Integer.parseInt(jsrow.get("db_svr_ipadr_id").toString()));

					if(Integer.parseInt(jsrow.get("db_svr_ipadr_id").toString()) < 0){
						dbServerManagerService.insertIpadr(ipadrVO);		
						System.out.println("IP정보 등록 완료");
					}else{
						dbServerManagerService.updateIpadr(ipadrVO);
						System.out.println("IP정보 업데이트 완료");
					}
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		txManager.commit(status);
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
	
	
	/**
	 * 디렉토리 존재유무 체크
	 * @param WorkVO
	 * @return resultSet
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/isDirCheck.do")
	@ResponseBody
	public Map<String, Object> isDirCheck (HttpServletRequest request) {
	
		Map<String, Object> result =new HashMap<String, Object>();
		
		String db_svr_nm = request.getParameter("db_svr_nm");
		String ipadr = request.getParameter("ipadr");
		String portno = request.getParameter("portno");
		String svr_spr_scm_pwd = request.getParameter("svr_spr_scm_pwd");
		String directory_path = request.getParameter("path");
		String flag = request.getParameter("flag");
		
		try {
			AES256 aes = new AES256(AES256_KEY.ENC_KEY);
			JSONObject serverObj = new JSONObject();

			AgentInfoVO vo = new AgentInfoVO();
			vo.setIPADR(ipadr);
			
			AgentInfoVO agentInfo =  (AgentInfoVO) cmmnServerInfoService.selectAgentInfo(vo);
			
			String IP = ipadr;
			int PORT = agentInfo.getSOCKET_PORT();
			
			serverObj.put(ClientProtocolID.SERVER_NAME, db_svr_nm);
			serverObj.put(ClientProtocolID.SERVER_IP, ipadr);
			serverObj.put(ClientProtocolID.SERVER_PORT, portno);
			//serverObj.put(ClientProtocolID.USER_PWD, dbServerVO.getSvr_spr_scm_pwd());
			if(flag=="m"){
				serverObj.put(ClientProtocolID.USER_PWD, aes.aesDecode(svr_spr_scm_pwd));
			}else{
				serverObj.put(ClientProtocolID.USER_PWD, (svr_spr_scm_pwd));
			}


			ClientInfoCmmn cic = new ClientInfoCmmn();
			result = cic.directory_exist(serverObj,directory_path, IP, PORT);
			
			//System.out.println(result);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	
	/**
	 * 중복 서버명을 체크한다.
	 * 
	 * @param db_svr_nm
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/db_svr_nmCheck.do")
	public @ResponseBody String db_svr_nmCheck(@RequestParam("db_svr_nm") String db_svr_nm) {
		try {
			int resultSet = dbServerManagerService.db_svr_nmCheck(db_svr_nm);
			if (resultSet > 0) {
				// 중복값이 존재함.
				return "false";
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "true";
	}
	
	
	/**
	 * Agent IP SelectBox 
	 * 
	 * @return resultSet
	 * @throws Exception
	 */
	@SuppressWarnings("unused")
	@RequestMapping(value = "/selectIpList.do")
	@ResponseBody
	public List<Map<String, Object>> selectIpList(@ModelAttribute("agentInfoVO") AgentInfoVO agentInfoVO) {
	
		List<Map<String, Object>> resultSet = null;
	
		try {			
			resultSet = dbServerManagerService.selectIpList(agentInfoVO);	
		} catch (Exception e) {
			e.printStackTrace();
		}
		return resultSet;
	}
	
	
	/**
	 * 호스트명 가져오기
	 * 
	 * @return resultSet
	 * @throws Exception
	 */
	@SuppressWarnings("unused")
	@RequestMapping(value = "/getHostNm.do")
	@ResponseBody
	public Map<String, Object> getHostNm(HttpServletRequest request) {
	
		Map<String, Object> result = null;
		try {		
			String ipadr = request.getParameter("ipadr");
			System.out.println(ipadr);
			AgentInfoVO vo = new AgentInfoVO();
			vo.setIPADR(ipadr);
			
			AgentInfoVO agentInfo =  (AgentInfoVO) cmmnServerInfoService.selectAgentInfo(vo);
			
			String IP = ipadr;
			int PORT = agentInfo.getSOCKET_PORT();
			System.out.println("아이피:" + IP);
			System.out.println("포트:" + PORT);
			ClientInfoCmmn cic = new ClientInfoCmmn();
			result = cic.getHostName(IP, PORT);
			result.put("agentPort", PORT);
			System.out.println(result);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
		
	}
	
	
	
	/**
	 * 경로호출
	 * 
	 * @return resultSet
	 * @throws Exception
	 */
	@RequestMapping(value="/pathCall.do")
	public @ResponseBody Map<String, Object> pathCall(@ModelAttribute("historyVO") HistoryVO historyVO, @ModelAttribute("dbServerVO") DbServerVO dbServerVO, HttpServletRequest request) {
		
		Map<String, Object> result =new HashMap<String, Object>();
		JSONObject serverObj = new JSONObject();
		AgentInfoVO vo = new AgentInfoVO();
		vo.setIPADR(dbServerVO.getIpadr());
		
		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0006_02");
			historyVO.setMnu_id(9);
			accessHistoryService.insertHistory(historyVO);
			
			AgentInfoVO agentInfo =  (AgentInfoVO) cmmnServerInfoService.selectAgentInfo(vo);
			String IP = dbServerVO.getIpadr();
			int PORT = agentInfo.getSOCKET_PORT();
					
			String strRows = request.getParameter("datasArr").toString().replaceAll("&quot;", "\"");
			JSONArray rows = (JSONArray) new JSONParser().parse(strRows);
						
			for(int i=0; i<rows.size(); i++){
				JSONObject jsonObject = (JSONObject) rows.get(i);		
				serverObj.put(ClientProtocolID.SERVER_NAME, jsonObject.get("SERVER_IP").toString());
				serverObj.put(ClientProtocolID.SERVER_IP, jsonObject.get("SERVER_IP").toString());
				serverObj.put(ClientProtocolID.SERVER_PORT, jsonObject.get("SERVER_PORT").toString());
				serverObj.put(ClientProtocolID.DATABASE_NAME, jsonObject.get("DATABASE_NAME").toString());
				serverObj.put(ClientProtocolID.USER_ID, jsonObject.get("USER_ID").toString());
				serverObj.put(ClientProtocolID.USER_PWD, jsonObject.get("USER_PWD").toString());
			}
			
			ClientInfoCmmn conn  = new ClientInfoCmmn();
			result = conn.dbms_inforamtion(IP, PORT,serverObj);
		
		}catch (Exception e) {
			e.printStackTrace();
		}
		return result;		
	}
	
}
