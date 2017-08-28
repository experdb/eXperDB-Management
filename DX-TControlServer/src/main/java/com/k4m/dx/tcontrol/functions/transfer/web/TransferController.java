package com.k4m.dx.tcontrol.functions.transfer.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.k4m.dx.tcontrol.admin.accesshistory.service.AccessHistoryService;
import com.k4m.dx.tcontrol.admin.menuauthority.service.MenuAuthorityService;
import com.k4m.dx.tcontrol.cmmn.CmmnUtils;
import com.k4m.dx.tcontrol.common.service.HistoryVO;
import com.k4m.dx.tcontrol.functions.transfer.service.ConnectorVO;
import com.k4m.dx.tcontrol.functions.transfer.service.TransferService;
import com.k4m.dx.tcontrol.functions.transfer.service.TransferVO;
import com.k4m.dx.tcontrol.tree.transfer.service.TransferMappingVO;

/**
 * Transfer 컨트롤러 클래스를 정의한다.
 *
 * @author 김주영
 * @see
 * 
 *      <pre>
 * == 개정이력(Modification Information) ==
 *
 *   수정일       수정자           수정내용
 *  -------     --------    ---------------------------
 *  2017.06.08   김주영 최초 생성
 *      </pre>
 */
@Controller
public class TransferController {

	@Autowired
	private TransferService transferService;

	@Autowired
	private AccessHistoryService accessHistoryService;

	@Autowired
	private MenuAuthorityService menuAuthorityService;
	
	private List<Map<String, Object>> menuAut;
	
	/**
	 * 전송설정 화면을 보여준다.
	 * 
	 * @param
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/transferSetting.do")
	public ModelAndView transferSetting(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		try {
			CmmnUtils cu = new CmmnUtils();
			menuAut = cu.selectMenuAut(menuAuthorityService, "MN000201");
			if(menuAut.get(0).get("read_aut_yn").equals("N")){
				mv.setViewName("error/autError");
			}else{
				mv.addObject("read_aut_yn", menuAut.get(0).get("read_aut_yn"));
				mv.addObject("wrt_aut_yn", menuAut.get(0).get("wrt_aut_yn"));
				
				// 전송설정 이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0011");
				accessHistoryService.insertHistory(historyVO);
				
				mv.setViewName("functions/transfer/transferSetting");
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}

	/**
	 * 전송설정 조회한다.
	 * 
	 * @param request
	 * @return resultSet
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectTransferSetting.do")
	public @ResponseBody TransferVO selectTransferSetting(HttpServletRequest request,HttpServletResponse response) {
		HttpSession session = request.getSession();
		 TransferVO resultSet = null;
		try {
			CmmnUtils cu = new CmmnUtils();
			menuAut = cu.selectMenuAut(menuAuthorityService, "MN000201");
			
			//읽기권한이 있을경우
			if(menuAut.get(0).get("read_aut_yn").equals("N")){
				response.sendRedirect("/autError.do");
				return resultSet;
			}
			String usr_id = (String) session.getAttribute("usr_id");
			resultSet = (TransferVO)transferService.selectTransferSetting(usr_id);	
		} catch (Exception e) {
			e.printStackTrace();
		}
		return resultSet;
	}
	
	/**
	 * 전송설정 등록한다.
	 * 
	 * @param transferVO
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/insertTransferSetting.do")
	public @ResponseBody void insertTransferSetting(@ModelAttribute("transferVO") TransferVO transferVO,@ModelAttribute("historyVO") HistoryVO historyVO,HttpServletRequest request,HttpServletResponse response) {
		try {
			CmmnUtils cu = new CmmnUtils();
			menuAut = cu.selectMenuAut(menuAuthorityService, "MN000201");
			
			//쓰기권한이 있을경우
			if(menuAut.get(0).get("wrt_aut_yn").equals("N")){
				response.sendRedirect("/autError.do");
			}
			HttpSession session = request.getSession();
			String usr_id = (String) session.getAttribute("usr_id");
			transferVO.setFrst_regr_id(usr_id);
			transferVO.setLst_mdfr_id(usr_id);
				
			transferService.insertTransferSetting(transferVO);
				
			// 전송설정 저장 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0011_01");
			accessHistoryService.insertHistory(historyVO);
					
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * 전송설정 수정한다.
	 * 
	 * @param transferVO
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/updateTransferSetting.do")
	public @ResponseBody boolean updateTransferSetting(@ModelAttribute("transferVO") TransferVO transferVO,@ModelAttribute("historyVO") HistoryVO historyVO,HttpServletRequest request,HttpServletResponse response) {
		try {
			CmmnUtils cu = new CmmnUtils();
			menuAut = cu.selectMenuAut(menuAuthorityService, "MN000201");
			//쓰기권한이 있을경우
			if(menuAut.get(0).get("wrt_aut_yn").equals("N")){
				response.sendRedirect("/autError.do");
				return false;
			}
			HttpSession session = request.getSession();
			String usr_id = (String) session.getAttribute("usr_id");
			transferVO.setLst_mdfr_id(usr_id);
				
			transferService.updateTransferSetting(transferVO);
							
			// 전송설정 저장 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0011_01");
			accessHistoryService.insertHistory(historyVO);
			
			return true;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return true;
	}
	
	/**
	 * Connector 등록 화면을 보여준다.
	 * 
	 * @param historyVO
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/connectorRegister.do")
	public ModelAndView connectorRegister(@ModelAttribute("historyVO") HistoryVO historyVO,
			HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		try {
			CmmnUtils cu = new CmmnUtils();
			menuAut = cu.selectMenuAut(menuAuthorityService, "MN000202");
			if(menuAut.get(0).get("read_aut_yn").equals("N")){
				mv.setViewName("error/autError");
			}else{
				mv.addObject("read_aut_yn", menuAut.get(0).get("read_aut_yn"));
				mv.addObject("wrt_aut_yn", menuAut.get(0).get("wrt_aut_yn"));
				
				// Connector조회 이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0012");
				accessHistoryService.insertHistory(historyVO);

				mv.setViewName("functions/transfer/connectorRegister");
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}

	/**
	 * Connector 리스트를 조회한다.
	 * 
	 * @param request
	 * @return resultSet
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectConnectorRegister.do")
	public @ResponseBody List<ConnectorVO> selectConnectorRegister(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request,HttpServletResponse response) {
		List<ConnectorVO> resultSet = null;
		try {
			CmmnUtils cu = new CmmnUtils();
			menuAut = cu.selectMenuAut(menuAuthorityService, "MN000202");
			
			//읽기권한이 있을경우
			if(menuAut.get(0).get("read_aut_yn").equals("N")){
				response.sendRedirect("/autError.do");
				return resultSet;
			}
			
			// Connector 조회 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0012_01");
			accessHistoryService.insertHistory(historyVO);					
			
			Map<String, Object> param = new HashMap<String, Object>();

			String cnr_nm = request.getParameter("cnr_nm");
			String cnr_ipadr = request.getParameter("cnr_ipadr");

			param.put("cnr_nm", cnr_nm);
			param.put("cnr_ipadr", cnr_ipadr);

			resultSet = transferService.selectConnectorRegister(param);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return resultSet;
	}

	/**
	 * Connector 등록 팝업을 보여준다.
	 * 
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/popup/connectorRegForm.do")
	public ModelAndView connectorReg(HttpServletRequest request,@ModelAttribute("historyVO") HistoryVO historyVO) {
		ModelAndView mv = new ModelAndView();
		List<ConnectorVO> result = null;
		try {
			CmmnUtils cu = new CmmnUtils();
			menuAut = cu.selectMenuAut(menuAuthorityService, "MN000202");
			if(menuAut.get(0).get("read_aut_yn").equals("Y")){
				mv.setViewName("error/autError");
			}
			
			String act = request.getParameter("act");
			
			if (act.equals("i")) {
				// Connector 등록 팝업 이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0013");
				accessHistoryService.insertHistory(historyVO);
			}
			
			if (act.equals("u")) {
				// Connector수정 이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0012_03");
				accessHistoryService.insertHistory(historyVO);
				
				int cnr_id = Integer.parseInt(request.getParameter("cnr_id"));
				result = transferService.selectDetailConnectorRegister(cnr_id);
				mv.addObject("cnr_id", result.get(0).getCnr_id());
				mv.addObject("cnr_nm", result.get(0).getCnr_nm());
				mv.addObject("cnr_ipadr", result.get(0).getCnr_ipadr());
				mv.addObject("cnr_portno", result.get(0).getCnr_portno());
				mv.addObject("cnr_cnn_tp_cd", result.get(0).getCnr_cnn_tp_cd());
			}

			mv.addObject("act", act);
			mv.setViewName("popup/connectorRegForm");
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}


	/**
	 * Connector를 등록한다.
	 * 
	 * @param connectorVO
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/insertConnectorRegister.do")
	public @ResponseBody void insertConnectorRegister(@ModelAttribute("connectorVO") ConnectorVO connectorVO,
			@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		try {
			HttpSession session = request.getSession();
			String usr_id = (String) session.getAttribute("usr_id");
			connectorVO.setFrst_regr_id(usr_id);
			connectorVO.setLst_mdfr_id(usr_id);
			transferService.insertConnectorRegister(connectorVO);

			// Connector등록 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0013_01");
			accessHistoryService.insertHistory(historyVO);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * Connector를 수정한다.
	 * 
	 * @param connectorVO
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/updateConnectorRegister.do")
	public @ResponseBody void updateConnectorRegister(@ModelAttribute("connectorVO") ConnectorVO connectorVO, HttpServletRequest request) {
		try {
			HttpSession session = request.getSession();
			String usr_id = (String) session.getAttribute("usr_id");
			connectorVO.setLst_mdfr_id(usr_id);
			transferService.updateConnectorRegister(connectorVO);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * Connector를 삭제한다.
	 * 
	 * @param historyVO
	 * @param request
	 * @return true
	 * @throws Exception
	 */
	@RequestMapping(value = "/deleteConnectorRegister.do")
	public @ResponseBody boolean deleteConnectorRegister(@ModelAttribute("historyVO") HistoryVO historyVO,
			HttpServletRequest request) {
		try {
			String[] param = request.getParameter("cnr_id").toString().split(",");
			for (int i = 0; i < param.length; i++) {
				/*1. 커넥터정보 삭제*/
				transferService.deleteConnectorRegister(Integer.parseInt(param[i]));
				/*2. 전송대상설정정보 삭제*/
				transferService.deleteTransferInfo(Integer.parseInt(param[i]));
				/*3. trf_trg_mpp_id조회 후, 전송대상매핑관계 삭제 */
				List<TransferMappingVO> result = transferService.selectTrftrgmppid(Integer.parseInt(param[i]));
				transferService.deleteTransferRelation(Integer.parseInt(param[i]));
				/*4. 전송매핑테이블 삭제*/
				if(result!=null){
					for(int j=0; j<result.size(); j++){
						transferService.deleteTransferMapping(result.get(j).getTrf_trg_mpp_id());
					}
				}		
			}

			// Connector삭제 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0012_04");
			accessHistoryService.insertHistory(historyVO);

			return true;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}
}
