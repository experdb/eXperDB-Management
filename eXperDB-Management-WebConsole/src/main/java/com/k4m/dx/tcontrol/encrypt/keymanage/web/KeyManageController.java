package com.k4m.dx.tcontrol.encrypt.keymanage.web;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.k4m.dx.tcontrol.admin.accesshistory.service.AccessHistoryService;
import com.k4m.dx.tcontrol.admin.menuauthority.service.MenuAuthorityService;
import com.k4m.dx.tcontrol.cmmn.CmmnUtils;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.CryptoKeySymmetric;
import com.k4m.dx.tcontrol.common.service.HistoryVO;
import com.k4m.dx.tcontrol.encrypt.service.call.CommonServiceCall;
import com.k4m.dx.tcontrol.encrypt.service.call.KeyManageServiceCall;
import com.k4m.dx.tcontrol.login.service.LoginVO;
/**
 * keyManageController 컨트롤러 클래스를 정의한다.
 *
 * @author 변승우 대리
 * @see
 * 
 *      <pre>
 * == 개정이력(Modification Information) ==
 *
 *   수정일       수정자           수정내용
 *  -------     --------    ---------------------------
 *  2018.01.09   변승우대리  최초 생성
 *      </pre>
 */
@Controller
public class KeyManageController {
	
	@Autowired
	private AccessHistoryService accessHistoryService;

	private List<Map<String, Object>> menuAut;
	
	@Autowired
	private MenuAuthorityService menuAuthorityService;
	
	/**
	 * 암호화 키 리스트 화면을 보여준다.
	 * 
	 * @param
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/keyManage.do")
	public ModelAndView keyManage(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		CommonServiceCall csc= new CommonServiceCall();
		JSONArray result = new JSONArray();
		try {
			CmmnUtils cu = new CmmnUtils();
			menuAut = cu.selectMenuAut(menuAuthorityService, "MN0001102");	
			if(menuAut.get(0).get("read_aut_yn").equals("N")){
				mv.setViewName("error/autError");
			}else{
				mv.addObject("read_aut_yn", menuAut.get(0).get("read_aut_yn"));
				mv.addObject("wrt_aut_yn", menuAut.get(0).get("wrt_aut_yn"));
				
				// 화면접근이력 이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0106");
				historyVO.setMnu_id(26);
				accessHistoryService.insertHistory(historyVO);
				
				HttpSession session = request.getSession();
				LoginVO loginVo = (LoginVO) session.getAttribute("session");
				String restIp = loginVo.getRestIp();
				int restPort = loginVo.getRestPort();
				String strTocken = loginVo.getTockenValue();
				String loginId = loginVo.getUsr_id();
				String entityId = loginVo.getEctityUid();			
				
				try{
					result = csc.selectSysCodeListExper(restIp, restPort, strTocken,loginId,entityId);
				}catch(Exception e){
					JSONObject jsonObj = new JSONObject();
					jsonObj.put("resultCode", "8000000002");
					result.add(jsonObj);
				}
				mv.setViewName("encrypt/keyManage/keyManage");
				mv.addObject("result",result);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}

	
	/**
	 * 암호화 키 등록 팝업을 보여준다.
	 * 
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/popup/keyManageRegForm.do")
	public ModelAndView keyManageRegForm(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		 ModelAndView mv = new ModelAndView("jsonView");
		CommonServiceCall csc= new CommonServiceCall();
		JSONArray result = new JSONArray();
		try {
			HttpSession session = request.getSession();
			LoginVO loginVo = (LoginVO) session.getAttribute("session");
			String restIp = loginVo.getRestIp();
			int restPort = loginVo.getRestPort();
			String strTocken = loginVo.getTockenValue();
			String loginId = loginVo.getUsr_id();
			String entityId = loginVo.getEctityUid();
			
			result = csc.selectSysCodeListExper(restIp, restPort, strTocken,loginId,entityId);
			
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0107");
			historyVO.setMnu_id(26);
			accessHistoryService.insertHistory(historyVO);

			//mv.setViewName("encrypt/popup/keyManageRegForm");
			mv.addObject("result",result);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;

	}
	
	/**
	 * 암호화 키 수정 팝업을 보여준다.
	 * 
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/popup/keyManageRegReForm.do")
	public ModelAndView keyManageRegReForm(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		
		 ModelAndView mv = new ModelAndView("jsonView");
		
		CommonServiceCall csc= new CommonServiceCall();
		JSONArray result = new JSONArray();
		try {
			String resourceName = request.getParameter("resourceName");
			String resourceNote = request.getParameter("resourceNote");
			String keyUid = request.getParameter("keyUid");
			String keyStatusCode = request.getParameter("keyStatusCode");
			String keyStatusName = request.getParameter("keyStatusName");
			String cipherAlgorithmName = request.getParameter("cipherAlgorithmName");
			String cipherAlgorithmCode = request.getParameter("cipherAlgorithmCode");
			String updateDateTime = request.getParameter("updateDateTime");
			
			HttpSession session = request.getSession();
			LoginVO loginVo = (LoginVO) session.getAttribute("session");
			String restIp = loginVo.getRestIp();
			int restPort = loginVo.getRestPort();
			String strTocken = loginVo.getTockenValue();
			String loginId = loginVo.getUsr_id();
			String entityId = loginVo.getEctityUid();	
			
			result = csc.selectSysCodeListExper(restIp, restPort, strTocken,loginId,entityId);
			
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0108");
			historyVO.setMnu_id(26);
			accessHistoryService.insertHistory(historyVO);

			//mv.setViewName("encrypt/popup/keyManageRegReForm");
			mv.addObject("mod_result",result);
			mv.addObject("mod_resourceName",resourceName);
			mv.addObject("mod_resourceNote",resourceNote);
			mv.addObject("mod_keyUid",keyUid);
			mv.addObject("mod_keyStatusCode",keyStatusCode);
			mv.addObject("mod_keyStatusName",keyStatusName);
			mv.addObject("mod_cipherAlgorithmName",cipherAlgorithmName);
			mv.addObject("mod_cipherAlgorithmCode",cipherAlgorithmCode);
			mv.addObject("mod_updateDateTime",updateDateTime);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
	

	/**
	 * 암호화 키를 조회한다.
	 * 
	 * @return resultSet
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectCryptoKeyList.do")
	public @ResponseBody JSONObject selectCryptoKeyList(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request, HttpServletResponse response) {
			
		KeyManageServiceCall kmsc= new KeyManageServiceCall();
		JSONObject result = new JSONObject();
		try {
			
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0106_01");
			historyVO.setMnu_id(26);
			accessHistoryService.insertHistory(historyVO);
						
			HttpSession session = request.getSession();
			LoginVO loginVo = (LoginVO) session.getAttribute("session");
			String restIp = loginVo.getRestIp();
			int restPort = loginVo.getRestPort();
			String strTocken = loginVo.getTockenValue();
			String loginId = loginVo.getUsr_id();
			String entityId = loginVo.getEctityUid();	
			
			try{
				result = kmsc.selectCryptoKeyList(restIp, restPort, strTocken,loginId,entityId);
			}catch(Exception e){
				result.put("resultCode", "8000000002");
			}
		
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	
	/**
	 * 암호화 키를 등록한다.
	 * 
	 * @return resultSet
	 * @throws Exception
	 */
	@RequestMapping(value = "/insertCryptoKeySymmetric.do")
	public @ResponseBody JSONObject insertCryptoKeySymmetric(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		
		String resourceName = request.getParameter("resourceName");
		String cipherAlgorithmCode = request.getParameter("cipherAlgorithmCode");
		String resourceNote = request.getParameter("resourceNote");
		String validEndDateTime = request.getParameter("validEndDateTime") + " 23:59:59.999";

		CryptoKeySymmetric param = new CryptoKeySymmetric();
		param.setResourceName(resourceName);
		param.setCipherAlgorithmCode(cipherAlgorithmCode);
		param.setResourceNote(resourceNote);
		param.setValidEndDateTime(validEndDateTime);
		param.setKeyStatusCode("KS50");
		

		KeyManageServiceCall kmsc= new KeyManageServiceCall();
		JSONObject result = new JSONObject();
		try {
			
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0107_01");
			historyVO.setMnu_id(26);
			accessHistoryService.insertHistory(historyVO);
						
			HttpSession session = request.getSession();
			LoginVO loginVo = (LoginVO) session.getAttribute("session");
			String restIp = loginVo.getRestIp();
			int restPort = loginVo.getRestPort();
			String strTocken = loginVo.getTockenValue();
			String loginId = loginVo.getUsr_id();
			String entityId = loginVo.getEctityUid();	
			try{
				result = kmsc.insertCryptoKeySymmetric(restIp, restPort, strTocken, loginId, entityId, param);
			}catch(Exception e){
			result.put("resultCode", "8000000002");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	
	/**
	 * 암호화 키를 업데이트한다.
	 * 
	 * @return resultSet
	 * @throws Exception
	 */
	@RequestMapping(value = "/updateCryptoKeySymmetric.do")
	public @ResponseBody JSONObject updateCryptoKeySymmetric(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		
		String keyUid = request.getParameter("keyUid");
		String resourceUid = request.getParameter("resourceUid");
		String resourceName = request.getParameter("resourceName");
		String cipherAlgorithmCode = request.getParameter("cipherAlgorithmCode");
		String resourceNote = request.getParameter("resourceNote");
		String validEndDateTime = request.getParameter("validEndDateTime") + " 23:59:59.999";
		String renew = request.getParameter("renew");
		String copyBin = request.getParameter("copyBin");
		
		
		CryptoKeySymmetric param = new CryptoKeySymmetric();
		param.setKeyUid(keyUid);
		param.setResourceUid(resourceUid);
		param.setResourceName(resourceName);
		param.setCipherAlgorithmCode(cipherAlgorithmCode);
		param.setResourceNote(resourceNote);
		param.setValidEndDateTime(validEndDateTime);
		param.setKeyStatusCode("KS50");
		//param.setUpdateUid("00000000-0000-0000-0000-000000000001");
		if(renew.equals("true")){
			param.setRenew(true);
		}else{
			param.setRenew(false);
		}
		
		if(copyBin.equals("true")){
			param.setCopyBin(true);
		}else{
			param.setCopyBin(false);
		}

		KeyManageServiceCall kmsc= new KeyManageServiceCall();
		JSONObject result = new JSONObject();
		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0108_01");
			historyVO.setMnu_id(26);
			accessHistoryService.insertHistory(historyVO);
						
			HttpSession session = request.getSession();
			LoginVO loginVo = (LoginVO) session.getAttribute("session");
			String restIp = loginVo.getRestIp();
			int restPort = loginVo.getRestPort();
			String strTocken = loginVo.getTockenValue();
			String loginId = loginVo.getUsr_id();
			String entityId = loginVo.getEctityUid();
			
			param.setUpdateUid(entityId);
			
			ArrayList param2 = new ArrayList();
			
			String strRows01 = request.getParameter("historyCryptoKeySymmetric").toString().replaceAll("&quot;", "\"");
			JSONArray rows01 = (JSONArray) new JSONParser().parse(strRows01);
			
			for (int i = 0; i < rows01.size(); i++) {
				CryptoKeySymmetric key = new CryptoKeySymmetric();
				JSONObject jsrow = (JSONObject) rows01.get(i);
				key.setBinUid(jsrow.get("binuid").toString());
				key.setBinStatusCode(jsrow.get("binstatuscode").toString());
				key.setValidEndDateTime(jsrow.get("validEndDateTime").toString());				
				param2.add(key.toJSONString());
			}	
			try{
				result = kmsc.updateCryptoKeySymmetric(restIp, restPort, strTocken,loginId,entityId, param, param2);
			}catch(Exception e){
				result.put("resultCode", "8000000002");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	
	/**
	 * 암호화 키 갱신이력을 조회한다.
	 * 
	 * @return resultSet
	 * @throws Exception
	 */
	@RequestMapping(value = "/historyCryptoKeySymmetric.do")
	public @ResponseBody JSONObject historyCryptoKeySymmetric(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		JSONObject result = new JSONObject();
		try {
			
			String keyUid = request.getParameter("keyUid");
			
			CryptoKeySymmetric param = new CryptoKeySymmetric();
			param.setKeyUid(keyUid);
			
			KeyManageServiceCall kmsc= new KeyManageServiceCall();

			HttpSession session = request.getSession();
			LoginVO loginVo = (LoginVO) session.getAttribute("session");
			String restIp = loginVo.getRestIp();
			int restPort = loginVo.getRestPort();
			String strTocken = loginVo.getTockenValue();
			String loginId = loginVo.getUsr_id();
			String entityId = loginVo.getEctityUid();
			try{
				result = kmsc.selectCryptoKeySymmetricList(restIp, restPort, strTocken, loginId, entityId, param);
			}catch(Exception e){
				result.put("resultCode", "8000000002");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	
	/**CryptoKeySymmetric
	 * 암호화 키를 삭제한다.
	 * 
	 * @return resultSet
	 * @throws Exception
	 */
	@RequestMapping(value = "/deleteCryptoKeySymmetric.do")
	public @ResponseBody JSONObject deleteCryptoKeySymmetric(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request, HttpServletResponse response) {
		JSONObject result = new JSONObject();
		try{

			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0106_02");
			historyVO.setMnu_id(26);
			accessHistoryService.insertHistory(historyVO);
						
			String keyUid = request.getParameter("keyUid");
			String resourceName = request.getParameter("resourceName");
			String resourceTypeCode = request.getParameter("resourceTypeCode");
			
			CryptoKeySymmetric param = new CryptoKeySymmetric();
			param.setKeyUid(keyUid);
			param.setResourceName(resourceName);
			param.setResourceTypeCode(resourceTypeCode);			
			
			KeyManageServiceCall kmsc= new KeyManageServiceCall();
			
			HttpSession session = request.getSession();
			LoginVO loginVo = (LoginVO) session.getAttribute("session");
			String restIp = loginVo.getRestIp();
			int restPort = loginVo.getRestPort();
			String strTocken = loginVo.getTockenValue();
			String loginId = loginVo.getUsr_id();
			String entityId = loginVo.getEctityUid();
			
			try{
				result= kmsc.deleteCryptoKeySymmetric(restIp, restPort, strTocken, loginId, entityId, param);
			}catch(Exception e){
			result.put("resultCode", "8000000002");
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		return result;
	}
}

