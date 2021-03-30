package com.experdb.management.proxy.web;

import java.io.FileInputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.experdb.management.proxy.service.ProxyLogVO;
import com.experdb.management.proxy.service.ProxyMonitoringService;
import com.k4m.dx.tcontrol.admin.menuauthority.service.MenuAuthorityService;
import com.k4m.dx.tcontrol.cmmn.CmmnUtils;
import com.k4m.dx.tcontrol.cmmn.client.ClientAdapter;
import com.k4m.dx.tcontrol.cmmn.client.ClientProtocolID;
import com.k4m.dx.tcontrol.cmmn.client.ClientTranCodeType;
import com.k4m.dx.tcontrol.common.service.HistoryVO;

/**
* @author 
* @see proxy 모니터링 관련 화면 Controller
* 
*      <pre>
* == 개정이력(Modification Information) ==
*
*   수정일                 수정자                   수정내용
*  -------     --------    ---------------------------
*  2021.03.02              최초 생성
*      </pre>
*/
@Controller
@RequestMapping("/proxyMonitoring")
public class ProxyMonitoringController {
	
	@Autowired
	private MenuAuthorityService menuAuthorityService;
	
	@Autowired
	private ProxyMonitoringService proxyMonitoringService;
	
	private List<Map<String, Object>> menuAut;
	
	/**
	 * Proxy 모니터링 화면
	 * @param historyVO, request
	 * @return ModelAndView
	 */
	@RequestMapping(value = "/monitoring.do")
	public ModelAndView proxyMonitoring(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {

		//권한 조회 (공통메소드호출),
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "MN0001801");
		ModelAndView mv = new ModelAndView();

		String dtlCd = "DX-T0160";
		int mnu_id = 44;
		try {
			//읽기 권한이 없는경우 에러페이지 호출 
			if(menuAut.get(0).get("read_aut_yn").equals("N")){
				mv.setViewName("error/autError");
			} else {
				// 화면접근이력 이력 남기기
				proxyMonitoringService.monitoringSaveHistory(request, historyVO, dtlCd, mnu_id);
				List<Map<String, Object>> proxyServerTotInfo = proxyMonitoringService.selectProxyServerList();
				
				
				int pry_svr_id = Integer.parseInt(String.valueOf(proxyServerTotInfo.get(0).get("pry_svr_id")));
				
				List<Map<String, Object>> proxyServerByMasId = proxyMonitoringService.selectProxyServerByMasterId(pry_svr_id);
				List<Map<String, Object>> dbServerConProxy = proxyMonitoringService.selectDBServerConProxy(pry_svr_id);
				List<ProxyLogVO> proxyLogList = proxyMonitoringService.selectProxyLogList(pry_svr_id);

				mv.addObject("proxyServerTotInfo", proxyServerTotInfo);
				mv.addObject("proxyServerByMasId", proxyServerByMasId);
				mv.addObject("dbServerConProxy", dbServerConProxy);
				mv.addObject("proxyLogList",proxyLogList);
				
				mv.setViewName("proxy/monitoring/proxyMonitoring");
			}	
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return mv;
	}
	
	/**
	 * proxy server id에 따른 데이터 조회
	 * @param request
	 * @return ModelAndView
	 */
	@RequestMapping("/selectInfoByPrySvrId.do")
	public ModelAndView proxyMonitoringInfo(HttpServletRequest request){
		ModelAndView mv = new ModelAndView("jsonView");
		int pry_svr_id = Integer.parseInt(request.getParameter("pry_svr_id"));
		
		try {	
			List<Map<String, Object>> proxyServerByMasId = proxyMonitoringService.selectProxyServerByMasterId(pry_svr_id);
			List<Map<String, Object>> dbServerConProxy = proxyMonitoringService.selectDBServerConProxy(pry_svr_id);
			List<ProxyLogVO> proxyLogList = proxyMonitoringService.selectProxyLogList(pry_svr_id);
			List<Map<String, Object>> proxyChartCntList = proxyMonitoringService.selectProxyChartCntList(pry_svr_id);

			mv.addObject("proxyServerByMasId", proxyServerByMasId);
			mv.addObject("dbServerConProxy", dbServerConProxy);
			mv.addObject("proxyLogList",proxyLogList);
			mv.addObject("proxyChartCntList",proxyChartCntList);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return mv;
	}
	
	/**
	 * 리스너 상세 정보
	 * @param request, pry_svr_id
	 * @return ModelAndView
	 */
	@RequestMapping("/listenerstatistics.do")
	public ModelAndView selectListenerStatisticsInfo(@ModelAttribute("historyVO") HistoryVO historyVO,HttpServletRequest request){
		
		//권한 조회 (공통메소드호출),
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "MN0001801");
		ModelAndView mv = new ModelAndView("jsonView");
		
		System.out.println("***************listenerstatistics ");
		System.out.println("pry_svr_id : " + request.getParameter("pry_svr_id"));
		
		String dtlCd = "DX-T0160_01";
		int mnu_id = 44;
		
		try {
			//읽기 권한이 없는경우 에러페이지 호출 
			if(menuAut.get(0).get("read_aut_yn").equals("N")){
				mv.setViewName("error/autError");
			} else {
				// 화면접근이력 이력 남기기
				proxyMonitoringService.monitoringSaveHistory(request, historyVO, dtlCd, mnu_id);
			}
			String strPrySvrId = request.getParameter("pry_svr_id");
			int pry_svr_id = Integer.parseInt(strPrySvrId); 
			List<Map<String, Object>> proxyStatisticsInfo = proxyMonitoringService.selectProxyStatisticsInfo(pry_svr_id);
			System.out.println(proxyStatisticsInfo.size());
//			System.out.println("pry_svr_nm : " + proxyStatisitcInfo.get(0).get("pry_svr_nm"));
			mv.addObject("proxyStatisticsInfo",proxyStatisticsInfo); 
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
	
	/**
	 * 리스너 통계 정보
	 * @param request, pry_svr_id
	 * @return ModelAndView
	 */
	@RequestMapping("/listenerStatisticsChart.do")
	public ModelAndView selectProxyStatisticsChartInfo(@ModelAttribute("historyVO") HistoryVO historyVO,HttpServletRequest request){
		
		//권한 조회 (공통메소드호출),
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "MN0001801");
		ModelAndView mv = new ModelAndView("jsonView");

		String dtlCd = "DX-T0160_03";
		int mnu_id = 44;
		
		try {
			//읽기 권한이 없는경우 에러페이지 호출 
			if(menuAut.get(0).get("read_aut_yn").equals("N")){
				mv.setViewName("error/autError");
			} else {
				// 화면접근이력 이력 남기기
				proxyMonitoringService.monitoringSaveHistory(request, historyVO, dtlCd, mnu_id);
			}
			String strPrySvrId = request.getParameter("pry_svr_id");
			int pry_svr_id = Integer.parseInt(strPrySvrId); 
			
			List<Map<String, Object>>  proxySettingChartresult = new ArrayList<Map<String, Object>>();
			
			List<Map<String, Object>> proxyStatisticsInfoChart = proxyMonitoringService.selectProxyStatisticsChartInfo(pry_svr_id);

			if (proxyStatisticsInfoChart != null && proxyStatisticsInfoChart.size() > 0) {
				for (int i = 0; i < proxyStatisticsInfoChart.size(); i++) {
					Map<String, Object> chart = new HashMap<String, Object>();

					chart.put("exe_dtm_ss", proxyStatisticsInfoChart.get(i).get("exe_dtm_ss"));
					chart.put("byte_receive", proxyStatisticsInfoChart.get(i).get("byte_receive"));
					chart.put("byte_transmit", proxyStatisticsInfoChart.get(i).get("byte_transmit"));
					chart.put("cumt_sso_con_cnt", proxyStatisticsInfoChart.get(i).get("cumt_sso_con_cnt"));
					chart.put("fail_chk_cnt", proxyStatisticsInfoChart.get(i).get("fail_chk_cnt"));

					proxySettingChartresult.add(chart);
				}
			}

			System.out.println(proxySettingChartresult.size());
			System.out.println(proxyStatisticsInfoChart.size());
//			System.out.println("pry_svr_nm : " + proxyStatisitcInfo.get(0).get("pry_svr_nm"));
			mv.addObject("proxyStatisticsInfoChart",proxyStatisticsInfoChart); 
			mv.addObject("proxySettingChartresult",proxySettingChartresult); 
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
		
	}
	
	/**
	 * proxy / keepalived config 파일 popup
	 * @param request, pry_svr_id
	 * @return ModelAndView
	 */
	@RequestMapping("/configView.do")
	public ModelAndView configView(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request){

		//권한 조회 (공통메소드호출),
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "MN0001801");
		ModelAndView mv = new ModelAndView();
		System.out.println("111111111111111111111111111111111111111");
		System.out.println("pry_svr_id : " + request.getParameter("pry_svr_id"));
		System.out.println("type : " + request.getParameter("type"));
		
		String dtlCd = "DX-T0160_02";
		int mnu_id = 44;
		try {
			//읽기 권한이 없는경우 에러페이지 호출 
			if(menuAut.get(0).get("read_aut_yn").equals("N")){
				mv.setViewName("error/autError");
			} else {
				// 화면접근이력 이력 남기기
				proxyMonitoringService.monitoringSaveHistory(request, historyVO, dtlCd, mnu_id);
				int pry_svr_id = Integer.parseInt(request.getParameter("pry_svr_id"));
				String type = request.getParameter("type");
				
				Map<String, Object> selectConfigBySysType = proxyMonitoringService.selectConfiguration(pry_svr_id, type);
				mv.addObject("selectConfigBySysType",selectConfigBySysType);
				mv.addObject("pry_svr_id", pry_svr_id);
				mv.addObject("type", type);
				mv.setViewName("proxy/popup/proxyConfigViewPop");
			}	
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
	
	/**
	 * config 파일 불러오기
	 * @param historyVO, request
	 * @return
	 */
	@RequestMapping("/configViewAjax.do")
	public ModelAndView configViewAjax(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request){
		HashMap result = new HashMap<>();
		ModelAndView mv = new ModelAndView("jsonView");
		String strBuffer = "";
		System.out.println("2222222222222222222222222222222222222222222222");
		System.out.println("pry_svr_id : " + request.getParameter("pry_svr_id"));
		System.out.println("type : " + request.getParameter("type"));
		try {
			String strPrySvrId = request.getParameter("pry_svr_id");
			String type = request.getParameter("type");
			int pry_svr_id = Integer.parseInt(strPrySvrId);
			
			Map<String, Object> selectConfigBySysType = proxyMonitoringService.selectConfiguration(pry_svr_id, type);
			
			
			String strIpAdr = (String) selectConfigBySysType.get("ipadr");
			String strPrySvrNm = (String) selectConfigBySysType.get("pry_svr_nm");
			String strConfigFilePath = (String) selectConfigBySysType.get("path");
			String strDirectory = strConfigFilePath.substring(0, strConfigFilePath.lastIndexOf("/"));
			String strFileName = strConfigFilePath.substring(strConfigFilePath.lastIndexOf("/")+1);
			String strPort = String.valueOf(selectConfigBySysType.get("socket_port"));
			
			JSONObject serverObj = new JSONObject();
			
			serverObj.put(ClientProtocolID.SERVER_NAME, strPrySvrNm);
			serverObj.put(ClientProtocolID.SERVER_IP, strIpAdr);
//			serverObj.put(ClientProtocolID.SERVER_PORT, dbServerVO.getPortno());
			
			JSONObject jObj = new JSONObject();
			jObj.put(ClientProtocolID.DX_EX_CODE, ClientTranCodeType.DxT015);
			jObj.put(ClientProtocolID.SERVER_INFO, serverObj);
			jObj.put(ClientProtocolID.COMMAND_CODE, ClientProtocolID.COMMAND_CODE_V);
			jObj.put(ClientProtocolID.FILE_DIRECTORY, strDirectory);
			jObj.put(ClientProtocolID.FILE_NAME, strFileName);
//			jObj.put(ClientProtocolID.SEEK, strSeek);
//			jObj.put(ClientProtocolID.DW_LEN, dwLen);
//			jObj.put(ClientProtocolID.READLINE, strReadLine);
			System.out.println("jObj : " + jObj.toJSONString());
			String IP = strIpAdr;
			int PORT = Integer.parseInt(strPort);
			System.out.println("IP : " + IP + ": " + PORT);
			//IP = "127.0.0.1";
//			ClientAdapter CA = new ClientAdapter(IP, PORT);
//			CA.open(); 
//			System.out.println("CA : " + CA.toString());
////			result.put("data", jObj);
//			JSONObject objList = CA.dxT015_V(jObj);
//			CA.close();
//			System.out.println("objList : " + objList.toJSONString());
//			
//			String strErrMsg = (String)objList.get(ClientProtocolID.ERR_MSG);
//			String strErrCode = (String)objList.get(ClientProtocolID.ERR_CODE);
//			String strDxExCode = (String)objList.get(ClientProtocolID.DX_EX_CODE);
//			String strResultCode = (String)objList.get(ClientProtocolID.RESULT_CODE);
//			System.out.println("RESULT_CODE : " +  strResultCode);
//			System.out.println("ERR_CODE : " +  strErrCode);
//			System.out.println("ERR_MSG : " +  strErrMsg);
//			
//			String strEndFlag = (String)objList.get(ClientProtocolID.END_FLAG);
//			strBuffer = (String)objList.get(ClientProtocolID.RESULT_DATA);
//			
//			int intDwlen = (int)objList.get(ClientProtocolID.DW_LEN);
//			
//			Long lngSeek= (Long)objList.get(ClientProtocolID.SEEK);
			System.out.println("fileName : " + strFileName);
			
			///////// 화면용 file 처리
	        FileInputStream fileStream = null; // 파일 스트림
//	        String path = "C:/Users/yj402/git/eXperDB-Management/eXperDB-Management-WebConsole/src/main/java/com/experdb/management/proxy/service/";
	        String path = "/home/experdb/app/eXperDB-Management/eXperDB-Management-WebConsole/webapps/eXperDB-Management-WebConsole/WEB-INF/classes/com/experdb/management/proxy/service/";
//	        String path = "../service/";
	        fileStream = new FileInputStream(path + strFileName );// 파일 스트림 생성
	        
	        //버퍼 선언
	        byte[ ] readBuffer = new byte[fileStream.available()];
	        while (fileStream.read( readBuffer ) != -1){
	        	strBuffer += new String(readBuffer);
	        }
	        String config_title = "";
	        if(type.equals("P")){
	        	config_title = "[ "+ strPrySvrNm + " ]  Proxy Config 파일";
	        } else {
	        	config_title = "[ "+ strPrySvrNm + " ]  Keepavlied Config 파일";
	        }
//			result.put("data", strBuffer);
//			result.put("fSize", strBuffer.length());
			mv.addObject("data", strBuffer);
			mv.addObject("fSize", strBuffer.length());
			mv.addObject("config_title", config_title);
			fileStream.close();
			//hp.put("fChrSize", intLastLength - intFirstLength); 
//			hp.put("seek", lngSeek.toString());
//			hp.put("dwLen", Integer.toString(intDwlen));
//			hp.put("endFlag", strEndFlag);
			
		} catch (Exception e) {
			e.printStackTrace();
		} 
		
		return mv;
	}
	
	/**
	 * proxy / keepavlied log popup view
	 * @param historyVO, request
	 * @return ModelAndView
	 */
	@RequestMapping("/logView.do")
	public ModelAndView logViewBySysTypeAndDate(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request){
		ModelAndView mv = new ModelAndView();
		mv.setViewName("proxy/popup/proxyLogView");
		return mv;
	}
	
	/**
	 * proxy / keepalived log file
	 * @return ModelAndView
	 */
	@RequestMapping("/proxyLogViewAjax.do")
	public ModelAndView logViewAjax(){
		ModelAndView mv = new ModelAndView("jsonView");
		return mv;
	}
	
	/**
	 * proxy / keepalived 상태 변경
	 * @param request
	 * @return ModelAndView
	 */
	@RequestMapping("/actExeCng.do")
	public ModelAndView actExeCng(HttpServletRequest request){
		ModelAndView mv = new ModelAndView("jsonView");
		
		String strPrySvrId = request.getParameter("pry_svr_id");
		String type = request.getParameter("type");
		int pry_svr_id = Integer.parseInt(strPrySvrId);
		String status = request.getParameter("status");
		String act_exe_type = request.getParameter("act_exe_type");
		System.out.println("********************** actExeCng");
		System.out.println(pry_svr_id);
		System.out.println(status);
		System.out.println(type);
		
		int result = proxyMonitoringService.actExeCng(pry_svr_id, type, status, act_exe_type);
		System.out.println("result : " +  result);
		mv.addObject("result", result);
		return mv;
	}
	
	/**
	 * proxy / keepalived 기동-정지 실패 로그
	 * @param request
	 * @return
	 */
	@RequestMapping("/actExeFailLog.do")
	public ModelAndView actExeFailLog(HttpServletRequest request){
		ModelAndView mv = new ModelAndView("jsonView");
		System.out.println("*************************** actExeFailLog ");
		int pry_act_exe_sn = Integer.parseInt(request.getParameter("pry_act_exe_sn"));
		System.out.println(pry_act_exe_sn);
		Map<String, Object> result = proxyMonitoringService.selectActExeFailLog(pry_act_exe_sn);
		System.out.println(result.size());
		System.out.println(result.toString());
		mv.addObject("actExeFailLog", result);
//		mv.setViewName("proxy/popup/exeFailMsg");
		return mv;
	}
}
