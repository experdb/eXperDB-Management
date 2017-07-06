package com.k4m.dx.tcontrol.accesscontrol.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.k4m.dx.tcontrol.accesscontrol.service.AccessControlService;
import com.k4m.dx.tcontrol.accesscontrol.service.AccessControlVO;
import com.k4m.dx.tcontrol.admin.accesshistory.service.AccessHistoryService;
import com.k4m.dx.tcontrol.backup.service.DbVO;
import com.k4m.dx.tcontrol.cmmn.CmmnUtils;
import com.k4m.dx.tcontrol.common.service.HistoryVO;
import com.k4m.dx.tcontrol.functions.transfer.service.ConnectorVO;
import com.k4m.dx.tcontrol.functions.transfer.service.TransferService;

/**
 * 접근제어관리 컨트롤러 클래스를 정의한다.
 *
 * @author 김주영
 * @see
 * 
 *      <pre>
 * == 개정이력(Modification Information) ==
 *
 *   수정일       수정자           수정내용
 *  -------     --------    ---------------------------
 *  2017.06.23   김주영 최초 생성
 *      </pre>
 */

@Controller
public class AccessControlController {
	
	@Autowired
	private AccessHistoryService accessHistoryService;
	
	@Autowired
	private TransferService transferService;
	
	@Autowired
	private AccessControlService accessControlService;
	
	/**
	 * 트리 Connector 리스트를 조회한다.
	 * 
	 * @return resultSet
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectTreeConnectorRegister.do")
	public @ResponseBody List<ConnectorVO> selectTreeConnectorRegister() {
		List<ConnectorVO> resultSet = null;
		Map<String, Object> param = new HashMap<String, Object>();
		try {
			resultSet = transferService.selectConnectorRegister(param);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return resultSet;
	}
	
	
	/**
	 * 서버접근제어 화면을 보여준다.
	 * 
	 * @param 
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/accessControl.do")
	public ModelAndView serverAccessControl(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		try {
			// 접근제어관리 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0027");
			accessHistoryService.insertHistory(historyVO);
			
			//Databae 목록 조회
			int db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));
			List<DbVO> resultSet = accessControlService.selectDatabaseList(db_svr_id);

			String db_svr_nm= request.getParameter("db_svr_nm");
			mv.addObject("db_svr_nm",db_svr_nm);
			mv.addObject("resultSet",resultSet);
			mv.setViewName("accessControl/accessControl");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
	
	
	
	/**
	 * 접근제어 리스트를 조회한다.
	 * 
	 * @return resultSet
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectAccessControl.do")
	public @ResponseBody List<AccessControlVO> selectAccessControl() {
		List<AccessControlVO> resultSet = null;
		try {
//			resultSet = ;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return resultSet;
	}
	
	
	/**
	 * 접근제어 등록/수정 팝업을 보여준다.
	 * 
	 * @param request
	 * @param historyVO
	 * @throws Exception
	 */
	@RequestMapping(value = "/popup/accessControlRegForm.do")
	public ModelAndView connectorReg(HttpServletRequest request,@ModelAttribute("historyVO") HistoryVO historyVO) {
		ModelAndView mv = new ModelAndView();
		try {
			String act = request.getParameter("act");
			CmmnUtils.saveHistory(request, historyVO);
			
			if(act.equals("i")){
				//접근제어 등록 팝업 이력 남기기
				historyVO.setExe_dtl_cd("DX-T0028");
				accessHistoryService.insertHistory(historyVO);
			}
			if(act.equals("u")){
				//접근제어 수정 팝업 이력 남기기
				historyVO.setExe_dtl_cd("DX-T0028_01");
				accessHistoryService.insertHistory(historyVO);
			}
			mv.addObject("act",act);
			mv.setViewName("popup/accessControlRegForm");	
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
	
	
	/**
	 * 접근제어를 등록한다.
	 * 
	 * @param accessControlVO
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/insertAccessControl.do")
	public @ResponseBody void insertAccessControl(@ModelAttribute("accessControlVO") AccessControlVO accessControlVO,HttpServletRequest request,@ModelAttribute("historyVO") HistoryVO historyVO) {
		try {		
			// 접근제어 등록 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0028_02");
			accessHistoryService.insertHistory(historyVO);
			
			//등록
			//accessControlService.insertAccessControl(accessControlVO);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	
	/**
	 * 접근제어를 수정한다.
	 * 
	 * @param accessControlVO
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/updateAccessControl.do")
	public @ResponseBody void updateAccessControl(@ModelAttribute("accessControlVO") AccessControlVO accessControlVO,HttpServletRequest request,@ModelAttribute("historyVO") HistoryVO historyVO) {
		try {		
			// 접근제어 수정 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0028_03");
			accessHistoryService.insertHistory(historyVO);

			//수정
			//accessControlService.updateAccessControl(accessControlVO);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	
}
