package com.k4m.dx.tcontrol.cmmn_web;

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

import com.k4m.dx.tcontrol.admin.accesshistory.service.AccessHistoryService;
import com.k4m.dx.tcontrol.admin.dbserverManager.service.DbServerVO;
import com.k4m.dx.tcontrol.backup.service.BackupService;
import com.k4m.dx.tcontrol.backup.service.WorkVO;
import com.k4m.dx.tcontrol.cmmn.CmmnUtils;
import com.k4m.dx.tcontrol.cmmn.client.ClientInfoCmmn;
import com.k4m.dx.tcontrol.cmmn.client.ClientProtocolID;
import com.k4m.dx.tcontrol.common.service.CmmnServerInfoService;
import com.k4m.dx.tcontrol.common.service.HistoryVO;

/**
 * 공통 컨트롤러 클래스를 정의한다.
 *
 * @author 변승우
 * @see
 * 
 *      <pre>
 * == 개정이력(Modification Information) ==
 *
 *   수정일       수정자           수정내용
 *  -------     --------    ---------------------------
 *  2017.05.24   변승우 최초 생성
 *      </pre>
 */

@Controller
public class CmmnController {
	@Autowired
	private BackupService backupService;
	
	@Autowired
	private AccessHistoryService accessHistoryService;
	
	@Autowired
	private CmmnServerInfoService cmmnServerInfoService;
	
	/**
	 * 메인(홈)을 보여준다.
	 * @return ModelAndView mv
	 */	
	@RequestMapping(value = "/index.do")
	public ModelAndView index(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) throws Exception {
		
		// 메인 이력 남기기
		CmmnUtils.saveHistory(request, historyVO);
		historyVO.setExe_dtl_cd("DX-T0004");
		accessHistoryService.insertHistory(historyVO);
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("view/index");
		return mv;	
	}
	

	/**
	 * DB서버에 대한 DB 리스트를 조회한다.
	 * 
	 * @return resultSet
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectServerDBList.do")
	@ResponseBody
	public Map<String, Object> selectServerDBList (@ModelAttribute("dbServerVO") DbServerVO dbServerVO, HttpServletRequest request) {
		
		Map<String, Object> result =new HashMap<String, Object>();
		try {
			String db_svr_nm = request.getParameter("db_svr_nm");
			System.out.println(db_svr_nm);
			
			List<DbServerVO> resultSet = cmmnServerInfoService.selectDbServerList(db_svr_nm);
			
			JSONObject serverObj = new JSONObject();
			
			serverObj.put(ClientProtocolID.SERVER_NAME, resultSet.get(0).getDb_svr_nm());
			serverObj.put(ClientProtocolID.SERVER_IP, resultSet.get(0).getIpadr());
			serverObj.put(ClientProtocolID.SERVER_PORT, resultSet.get(0).getPortno());
			serverObj.put(ClientProtocolID.DATABASE_NAME, resultSet.get(0).getDft_db_nm());
			serverObj.put(ClientProtocolID.USER_ID, resultSet.get(0).getSvr_spr_usr_id());
			serverObj.put(ClientProtocolID.USER_PWD, resultSet.get(0).getSvr_spr_scm_pwd());
			
			ClientInfoCmmn cic = new ClientInfoCmmn();
			result = cic.db_List(serverObj);
	
			System.out.println(result);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	/**
	 * Tbale 리스트를 조회한다.
	 * 
	 * @return resultSet
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/selectTableList.do")
	@ResponseBody
	public Map<String, Object> selectTableList (@ModelAttribute("workVO") WorkVO workVO, HttpServletRequest request) {
		
		Map<String, Object> result =new HashMap<String, Object>();
		try {
			DbServerVO dbServerVO = backupService.selectDbSvrNm(workVO);
			
			JSONObject serverObj = new JSONObject();
			
			serverObj.put(ClientProtocolID.SERVER_NAME, dbServerVO.getDb_svr_nm());
			serverObj.put(ClientProtocolID.SERVER_IP, dbServerVO.getIpadr());
			serverObj.put(ClientProtocolID.SERVER_PORT, dbServerVO.getPortno());
			serverObj.put(ClientProtocolID.DATABASE_NAME, dbServerVO.getDft_db_nm());
			serverObj.put(ClientProtocolID.USER_ID, dbServerVO.getSvr_spr_usr_id());
			serverObj.put(ClientProtocolID.USER_PWD, dbServerVO.getSvr_spr_scm_pwd());
			
			ClientInfoCmmn cic = new ClientInfoCmmn();
			result = cic.table_List(serverObj, Integer.toString(workVO.getDb_svr_id()));
			
			System.out.println(result);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	

}
