package com.k4m.dx.tcontrol.encript.securitypolicy.web;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

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
import com.k4m.dx.tcontrol.cmmn.CmmnUtils;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.SystemCode;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.ProfileAclSpec;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.ProfileCipherSpec;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.ProfileProtection;
import com.k4m.dx.tcontrol.common.service.HistoryVO;
import com.k4m.dx.tcontrol.encript.service.call.CommonServiceCall;
import com.k4m.dx.tcontrol.encript.service.call.KeyManageServiceCall;
import com.k4m.dx.tcontrol.encript.service.call.SecurityPolicyServiceCall;

/**
 * PolicyController 컨트롤러 클래스를 정의한다.
 *
 * @author 김주영
 * @see
 * 
 *      <pre>
 * == 개정이력(Modification Information) ==
 *
 *   수정일       수정자           수정내용
 *  -------     --------    ---------------------------
 *  2017.11.20   김주영 최초 생성
 *      </pre>
 */
@Controller
public class SecurityPolicyController {

	@Autowired
	private AccessHistoryService accessHistoryService;

	String restIp = "127.0.0.1";
	int restPort = 8443;
	String strTocken = "FM1jjfvteWrpIldnxwaTfjzGc+MRUo6MWTQ+SPiYbXQ=";
	
	/**
	 * 보안정책관리 화면을 보여준다.
	 * 
	 * @param
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/securityPolicy.do")
	public ModelAndView securityPolicy(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0055");
			accessHistoryService.insertHistory(historyVO);

			mv.setViewName("encript/securityPolicy/securityPolicy");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}

	
	/**
	 * 보안정책관리 리스트를 조회한다.
	 * 
	 * @return resultSet
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectSecurityPolicy.do")
	public @ResponseBody JSONObject selectSecurityPolicy(HttpServletRequest request) {
		SecurityPolicyServiceCall sic = new SecurityPolicyServiceCall();
		JSONObject result = new JSONObject();
		try {
			result = sic.selectProfileList(restIp, restPort, strTocken);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	/**
	 * 보안정책등록 화면을 보여준다.
	 * 
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/securityPolicyInsert.do")
	public ModelAndView securityPolicyInsert(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		SecurityPolicyServiceCall sic = new SecurityPolicyServiceCall();
		JSONArray dataTypeCode = new JSONArray();
		JSONArray denyResultTypeCode = new JSONArray();
		
		try {

//			// 화면접근이력 이력 남기기
//			historyVO.setExe_dtl_cd("DX-T0056");
//			historyVO.setMnu_id(12);
//			accessHistoryService.insertHistory(historyVO);

			/*데이터타입*/
			dataTypeCode = sic.selectParamSysCodeListDatatype(restIp, restPort, strTocken);
			mv.addObject("dataTypeCode",dataTypeCode);
			/*접근거부시처리*/
			denyResultTypeCode = sic.selectParamSysCodeListDenyresult(restIp, restPort, strTocken);
			mv.addObject("denyResultTypeCode",denyResultTypeCode);
			
			mv.setViewName("encript/securityPolicy/securityPolicyInsert");

		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
	
	/**
	 * 보안정책수정 화면을 보여준다.
	 * 
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/securityPolicyModify.do")
	public ModelAndView securityPolicyModify(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		SecurityPolicyServiceCall sic = new SecurityPolicyServiceCall();
		JSONArray dataTypeCode = new JSONArray();
		JSONArray denyResultTypeCode = new JSONArray();
		JSONObject result = new JSONObject();
		JSONArray cryptoKey = new JSONArray();
		try {

//			// 화면접근이력 이력 남기기
//			historyVO.setExe_dtl_cd("DX-T0056");
//			historyVO.setMnu_id(12);
//			accessHistoryService.insertHistory(historyVO);

			/*데이터타입*/
			dataTypeCode = sic.selectParamSysCodeListDatatype(restIp, restPort, strTocken);
			mv.addObject("dataTypeCode",dataTypeCode);
			/*접근거부시처리*/
			denyResultTypeCode = sic.selectParamSysCodeListDenyresult(restIp, restPort, strTocken);
			mv.addObject("denyResultTypeCode",denyResultTypeCode);

			String loginId = "admin";
			String entityId = "00000000-0000-0000-0000-000000000001";
			
			/*키이름*/
			cryptoKey = sic.selectCryptoKeySymmetricList(restIp, restPort, strTocken, loginId, entityId);
			mv.addObject("cryptoKey",cryptoKey);
			
			String profileUid = request.getParameter("profileUid");
			result = sic.selectProfileProtectionContents(restIp, restPort, strTocken, loginId, entityId, profileUid);
			
			System.out.println(result);
			
			mv.addObject("result",result);
			mv.setViewName("encript/securityPolicy/securityPolicyModify");

		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
	
	
	/**
	 * 암복호화 정책 등록 팝업을 보여준다.
	 * 
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/popup/securityPolicyRegForm.do")
	public ModelAndView securityPolicyRegForm(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		CommonServiceCall csc= new CommonServiceCall();
		SecurityPolicyServiceCall sic = new SecurityPolicyServiceCall();
		KeyManageServiceCall kmsc= new KeyManageServiceCall();
		JSONArray cipherAlgorithmCode = new JSONArray();
		JSONArray initialVectorTypeCode = new JSONArray();
		JSONArray operationModeCode = new JSONArray();
		JSONObject binUid = new JSONObject();
		try {

//			// 화면접근이력 이력 남기기
//			historyVO.setExe_dtl_cd("DX-T0056");
//			historyVO.setMnu_id(12);
//			accessHistoryService.insertHistory(historyVO);
			String act = request.getParameter("act");
			
			/*암호화 키*/
			binUid = kmsc.selectCryptoKeyList(restIp, restPort, strTocken);
			mv.addObject("binUid",binUid);
			/*암호화알고리즘*/
			cipherAlgorithmCode = csc.selectSysCodeListExper(restIp, restPort, strTocken);
			mv.addObject("cipherAlgorithmCode",cipherAlgorithmCode);
			/*초기벡터*/
			initialVectorTypeCode = sic.selectParamSysCodeListVector(restIp, restPort, strTocken);
			mv.addObject("initialVectorTypeCode",initialVectorTypeCode);
			/*운영모드*/
			operationModeCode = sic.selectParamSysCodeListOperation(restIp, restPort, strTocken);
			mv.addObject("operationModeCode",operationModeCode);
			
			if (act.equals("u")) {
				mv.addObject("rnum",request.getParameter("rnum").equals("undefined") ? "" : request.getParameter("rnum"));
				mv.addObject("specIndex",request.getParameter("specIndex").equals("undefined") ? "" : request.getParameter("specIndex"));
				mv.addObject("length",request.getParameter("length").equals("undefined") ? "" : request.getParameter("length"));
				mv.addObject("cipherAlgorithmCodeValue",request.getParameter("cipherAlgorithmCode").equals("undefined") ? "" : request.getParameter("cipherAlgorithmCode"));
				mv.addObject("binUidValue",request.getParameter("binUid").equals("undefined") ? "" : request.getParameter("binUid"));
				mv.addObject("initialVectorTypeCodeValue",request.getParameter("initialVectorTypeCode").equals("undefined") ? "" : request.getParameter("initialVectorTypeCode"));
				mv.addObject("operationModeCodeValue",request.getParameter("operationModeCode").equals("undefined") ? "" : request.getParameter("operationModeCode"));
			}
			mv.addObject("act", act);
			mv.setViewName("encript/popup/securityPolicyRegForm");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
	
	/**
	 * 접근제어 정책 등록 팝업을 보여준다.
	 * 
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/popup/accessPolicyRegForm.do")
	public ModelAndView accessPolicyRegForm(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		try {

//			// 화면접근이력 이력 남기기
//			historyVO.setExe_dtl_cd("DX-T0056");
//			historyVO.setMnu_id(12);
//			accessHistoryService.insertHistory(historyVO);
			String act = request.getParameter("act");
			
			if (act.equals("u")) {
				mv.addObject("rnum",request.getParameter("rnum").equals("undefined") ? "" : request.getParameter("rnum"));
				mv.addObject("specName",request.getParameter("specName").equals("undefined") ? "" : request.getParameter("specName"));
				mv.addObject("serverInstanceId",request.getParameter("serverInstanceId").equals("undefined") ? "" : request.getParameter("serverInstanceId"));
				mv.addObject("serverLoginId",request.getParameter("serverLoginId").equals("undefined") ? "" : request.getParameter("serverLoginId"));
				mv.addObject("adminLoginId",request.getParameter("adminLoginId").equals("undefined") ? "" : request.getParameter("adminLoginId"));
				mv.addObject("osLoginId",request.getParameter("osLoginId").equals("undefined") ? "" : request.getParameter("osLoginId"));
				mv.addObject("applicationName",request.getParameter("applicationName").equals("undefined") ? "" : request.getParameter("applicationName"));
				mv.addObject("accessAddress",request.getParameter("accessAddress").equals("undefined") ? "" : request.getParameter("accessAddress"));
				mv.addObject("accessAddressMask",request.getParameter("accessAddressMask").equals("undefined") ? "" : request.getParameter("accessAddressMask"));
				mv.addObject("accessMacAddress",request.getParameter("accessMacAddress").equals("undefined") ? "" : request.getParameter("accessMacAddress"));
				mv.addObject("startDateTime",request.getParameter("startDateTime").equals("undefined") ? "" : request.getParameter("startDateTime"));
				mv.addObject("endDateTime",request.getParameter("endDateTime").equals("undefined") ? "" : request.getParameter("endDateTime"));
				mv.addObject("startTime",request.getParameter("startTime").equals("undefined") ? "" : request.getParameter("startTime"));
				mv.addObject("endTime",request.getParameter("endTime").equals("undefined") ? "" : request.getParameter("endTime"));
				mv.addObject("workDay",request.getParameter("workDay").equals("undefined") ? "" : request.getParameter("workDay"));
				mv.addObject("massiveThreshold",request.getParameter("massiveThreshold").equals("undefined") ? "" : request.getParameter("massiveThreshold"));
				mv.addObject("massiveTimeInterval",request.getParameter("massiveTimeInterval").equals("undefined") ? "" : request.getParameter("massiveTimeInterval"));
				mv.addObject("extraName",request.getParameter("extraName").equals("undefined") ? "" : request.getParameter("extraName"));
				mv.addObject("hostName",request.getParameter("hostName").equals("undefined") ? "" : request.getParameter("hostName"));
				mv.addObject("whitelistYesNo",request.getParameter("whitelistYesNo").equals("undefined") ? "" : request.getParameter("whitelistYesNo"));
			}
			
			mv.addObject("act", act);
			mv.setViewName("encript/popup/accessPolicyRegForm");

		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
	
	
	
	/**
	 * 보호 정책을 등록한다.
	 * 
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/insertSecurityPolicy.do")
	public @ResponseBody void insertSecurityPolicy(HttpServletRequest request) {
		SecurityPolicyServiceCall sic = new SecurityPolicyServiceCall();
		try {		
			ProfileProtection param1 = new ProfileProtection();
			//보호정책 이름
			param1.setProfileName(request.getParameter("profileName")); 
			//보호 정책 설명
			param1.setProfileNote(request.getParameter("profilenote"));
			//데이터타입
			param1.setDataTypeCode(request.getParameter("dataTypeCode"));
			param1.setBase64YesNo("Y");
			//이중 암호화 방지
			param1.setPreventDoubleYesNo(request.getParameter("preventDoubleYesNo")==null ? "" : request.getParameter("preventDoubleYesNo"));
			//Null 암호화
			param1.setNullEncryptYesNo(request.getParameter("nullEncryptYesNo")==null ? "" : request.getParameter("nullEncryptYesNo"));
			//접근거부시처리
			param1.setDenyResultTypeCode(request.getParameter("denyResultTypeCode"));
			//대체문자열
			param1.setMaskingValue("");
			
			long optionBits = 0;
			
			if(request.getParameter("log_on_fail")==null){
				//실패 로그기록 체크가 아니면
				optionBits |= SystemCode.BitMask.POLICY_OPT_NO_AUDIT_LOG_ON_FAIL;
			}
			if(request.getParameter("log_on_success")==null){
				//성공로그기록 체크가 아니면 
				optionBits |= SystemCode.BitMask.POLICY_OPT_NO_AUDIT_LOG_ON_SUCCESS;
			}
			if(request.getParameter("compress_audit_log")!=null){
				//로그압축 체크이면
				optionBits |= SystemCode.BitMask.POLICY_OPT_COMPRESS_AUDIT_LOG;
			}
			param1.setOptionBits(optionBits);
			param1.setDefaultAccessAllowTrueFalse(true);
			
			/*암호화정책*/
			List param2 = new ArrayList();
			ProfileCipherSpec p = new ProfileCipherSpec();
			String strRows = request.getParameter("securityPolicy").toString().replaceAll("&quot;", "\"");
			JSONArray rows = (JSONArray) new JSONParser().parse(strRows);
			for (int i = 0; i < rows.size(); i++) {
				JSONObject jsrow = (JSONObject) rows.get(i);
				p.setSpecIndex(Integer.parseInt(jsrow.get("specIndex").toString()));
				//암호화 알고리즘 코드
				p.setCipherAlgorithmCode(jsrow.get("cipherAlgorithmCode").toString());
				//운영모드코드
				p.setOperationModeCode(jsrow.get("operationModeCode").toString());
				//초기벡터코드
				p.setInitialVectorTypeCode(jsrow.get("initialVectorTypeCode").toString());
				//offset
				p.setOffset(1);	
				if(jsrow.get("length").toString().equals("끝까지")){
					//길이
					p.setLength(null);
				}else{
					//길이
					p.setLength(Integer.parseInt(jsrow.get("length").toString()));
				}			
				p.setBinUid("20171027130442382_de351577-5b53-4265-8bee-a60289de88e2");
				param2.add(p.toJSONString());
			}

			/*접근제어 정책*/
			List param3 = new ArrayList();
			ProfileAclSpec r = new ProfileAclSpec();
			
			strRows = request.getParameter("accessPolicy").toString().replaceAll("&quot;", "\"");
			rows = (JSONArray) new JSONParser().parse(strRows);
			for (int i = 0; i < rows.size(); i++) {
				JSONObject jsrow = (JSONObject) rows.get(i);

				r.setSpecIndex(1); //row
				r.setSpecOrder(1); //row
				r.setSpecName(jsrow.get("specName").toString());
				//서버 인스턴스
				r.setServerInstanceId(jsrow.get("serverInstanceId").toString());
				//DB 사용자
				r.setServerLoginId(jsrow.get("serverLoginId").toString());
				//experdb 사용자
				r.setAdminLoginId(jsrow.get("adminLoginId").toString());
				//프로그램 이름
				r.setApplicationName(jsrow.get("applicationName").toString());
				//추가필드
				r.setExtraName(jsrow.get("extraName").toString());
				//호스트 이름
				r.setHostName(jsrow.get("hostName").toString());
				//접근 IP 주소
				r.setAccessAddress(jsrow.get("accessAddress").toString());
				//IP주소 마스크
				r.setAccessAddressMask(jsrow.get("accessAddressMask").toString());
				//접근 MAC 주소
				r.setAccessMacAddress(jsrow.get("accessMacAddress").toString());
				// 기간
				r.setStartDateTime(jsrow.get("startDateTime").toString());
				r.setEndDateTime(jsrow.get("endDateTime").toString());
				//시간
				r.setStartTime(jsrow.get("startTime").toString());
				r.setEndTime(jsrow.get("endTime").toString());
				//OS 사용자
				r.setOsLoginId(jsrow.get("osLoginId").toString());
				//초
				r.setMassiveTimeInterval(Integer.parseInt(jsrow.get("massiveTimeInterval").toString()));
				//대량작업임계건수
				r.setMassiveThreshold(Integer.parseInt(jsrow.get("massiveThreshold").toString()));
				//규칙만족할때 접근허용-Y 접근거부-N
				r.setWhitelistYesNo(jsrow.get("whitelistYesNo").toString());
				
				int workDay = 0;
				String workday = jsrow.get("workDay").toString();
				String data[] = workday.split(",");
		        for(int j=0 ; j<data.length ; j++)
		        {
		            workDay += data[j].equals("월")?SystemCode.Weekday.MONDAY : 0;
		            workDay += data[j].equals("화")?SystemCode.Weekday.TUESDAY : 0;
		            workDay += data[j].equals("수")?SystemCode.Weekday.WEDNESDAY : 0;
		            workDay += data[j].equals("목")?SystemCode.Weekday.THURSDAY : 0;
		            workDay += data[j].equals("금")?SystemCode.Weekday.FRIDAY : 0;
		            workDay += data[j].equals("토")?SystemCode.Weekday.SATURDAY : 0;
		            workDay += data[j].equals("일")?SystemCode.Weekday.SUNDAY : 0;
		        }
				r.setWorkDay(workDay);
				
				param3.add(r.toJSONString());
			}
			
			sic.insertProfileProtection(restIp, restPort, strTocken, param1, param2, param3);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}	
}

