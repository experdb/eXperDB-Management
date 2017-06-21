package com.k4m.dx.tcontrol.admin.accesshistory.web;

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

import com.k4m.dx.tcontrol.admin.accesshistory.service.AccessHistoryService;
import com.k4m.dx.tcontrol.cmmn.CmmnUtils;
import com.k4m.dx.tcontrol.common.service.HistoryVO;
import com.k4m.dx.tcontrol.login.service.UserVO;

/**
 * 접근내역 컨트롤러 클래스를 정의한다.
 *
 * @author 김주영
 * @see
 * 
 *      <pre>
 * == 개정이력(Modification Information) ==
 *
 *   수정일       수정자           수정내용
 *  -------     --------    ---------------------------
 *  2017.06.07   김주영 최초 생성
 *      </pre>
 */
@Controller
public class AccessHistoryController {

	@Autowired
	private AccessHistoryService accessHistoryService;
	
	/**
	 * 접근이력 화면을 보여준다.
	 * 
	 * @param historyVO
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/accessHistory.do")
	public ModelAndView accessHistory(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		try {
			// 화면접근 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0036");
			accessHistoryService.insertHistory(historyVO);
			
			mv.setViewName("admin/accessHistory/accessHistory");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;

	}

	/**
	 * 접근이력을 조회한다.
	 * 
	 * @return resultSet
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectAccessHistory.do")
	@ResponseBody
	public List<UserVO> selectAccessHistory(HttpServletRequest request) {
		List<UserVO> resultSet = null;
		try {
			Map<String, Object> param = new HashMap<String, Object>();

			String lgi_dtm_start = request.getParameter("lgi_dtm_start");
			String lgi_dtm_end = request.getParameter("lgi_dtm_end");
			String usr_nm = request.getParameter("usr_nm");

			param.put("lgi_dtm_start", lgi_dtm_start);
			param.put("lgi_dtm_end", lgi_dtm_end);
			param.put("usr_nm", usr_nm);

			resultSet = accessHistoryService.selectAccessHistory(param);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return resultSet;
	}

	
	/**
	 * 접근이력 엑셀을 저장한다.
	 * 
	 * @param request
	 * @throws Exception
	 */
	@RequestMapping("/accessHistory_data_JxlExportExcel.do")
	public ModelAndView accessHistory_data_JxlExportExcel(HttpServletRequest request) throws Exception {
		List<UserVO> resultSet = null;
		Map<String, Object> param = new HashMap<String, Object>();
		try {
			String lgi_dtm_start = request.getParameter("lgi_dtm_start");
			String lgi_dtm_end = request.getParameter("lgi_dtm_end");
			String usr_nm = request.getParameter("usr_nm");

			param.put("lgi_dtm_start", lgi_dtm_start);
			param.put("lgi_dtm_end", lgi_dtm_end);
			param.put("usr_nm", usr_nm);

			resultSet = accessHistoryService.selectAccessHistory(param);
			
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("category", resultSet);
			
			return new ModelAndView("categoryExcelView", "categoryMap", map);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

}
