package com.k4m.dx.tcontrol.db2pg.history.web;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.util.SystemOutLogger;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.util.ResourceUtils;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.k4m.dx.tcontrol.admin.accesshistory.service.AccessHistoryService;
import com.k4m.dx.tcontrol.admin.menuauthority.service.MenuAuthorityService;
import com.k4m.dx.tcontrol.cmmn.CmmnUtils;
import com.k4m.dx.tcontrol.common.service.HistoryVO;
import com.k4m.dx.tcontrol.db2pg.cmmn.DB2PG_LOG;
import com.k4m.dx.tcontrol.db2pg.cmmn.DB2PG_STOP;
import com.k4m.dx.tcontrol.db2pg.history.service.Db2pgHistoryService;
import com.k4m.dx.tcontrol.db2pg.history.service.Db2pgHistoryVO;

@Controller
public class Db2pgHistoryController {
	
	@Autowired
	private Db2pgHistoryService db2pgHistoryService;
	
	@Autowired
	private AccessHistoryService accessHistoryService;

	@Autowired
	private MenuAuthorityService menuAuthorityService;

	/**
	 * DB2PG 수행이력 화면을 보여준다.
	 * 
	 * @param historyVO
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/db2pgHistory.do")
	public ModelAndView db2pgHistory(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		try {			
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0143");
			historyVO.setMnu_id(42);
			accessHistoryService.insertHistory(historyVO);
			
			String gbn = request.getParameter("gbn");

			mv.addObject("gbn",gbn);
			mv.setViewName("db2pg/history/db2pgHistory");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
	
	
	/**
	 * DDL 수행이력 조회
	 * 
	 * @param request
	 * @return resultSet
	 * @throws Exception
	 */
	@RequestMapping(value = "/db2pg/selectDb2pgDDLHistory.do")
	public @ResponseBody List<Db2pgHistoryVO> selectDb2pgDDLHistory(@ModelAttribute("historyVO") HistoryVO historyVO, @ModelAttribute("db2pgHistoryVO") Db2pgHistoryVO db2pgHistoryVO, HttpServletRequest request, HttpServletResponse response) {
		List<Db2pgHistoryVO> resultSet = null;
		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0143_02");
			historyVO.setMnu_id(42);
			accessHistoryService.insertHistory(historyVO);
			
			resultSet = db2pgHistoryService.selectDb2pgDDLHistory(db2pgHistoryVO);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return resultSet;
	}
	
	
	/**
	 * Migration 수행이력 조회
	 * 
	 * @param request
	 * @return resultSet
	 * @throws Exception
	 */
	@RequestMapping(value = "/db2pg/selectDb2pgMigHistory.do")
	public @ResponseBody List<Db2pgHistoryVO> selectDb2pgMigHistory(@ModelAttribute("historyVO") HistoryVO historyVO, @ModelAttribute("db2pgHistoryVO") Db2pgHistoryVO db2pgHistoryVO, HttpServletRequest request, HttpServletResponse response) {
		List<Db2pgHistoryVO> resultSet = null;
		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0143_02");
			historyVO.setMnu_id(42);
			accessHistoryService.insertHistory(historyVO);

			resultSet = db2pgHistoryService.selectDb2pgMigHistory(db2pgHistoryVO);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return resultSet;
	}
	
	
	/**
	 * DB2PG DDL 에러 수행이력 상세보기 화면을 보여준다.
	 * 
	 * @param
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/db2pg/popup/db2pgDdlErrHistoryDetail.do")
	public ModelAndView db2pgDdlErrHistoryDetail(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView("jsonView");
		Db2pgHistoryVO result = null;
		try {
			int mig_exe_sn=Integer.parseInt(request.getParameter("mig_exe_sn"));

			result = (Db2pgHistoryVO) db2pgHistoryService.selectDb2pgDdlHistoryDetail(mig_exe_sn);
			mv.addObject("result",result);
			//mv.setViewName("db2pg/popup/db2pgHistoryDetail");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}	
	
	
	
	/**
	 * DB2PG MIGRATION 에러 수행이력 상세보기 화면을 보여준다.
	 * 
	 * @param
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/db2pg/popup/db2pgMigErrHistoryDetail.do")
	public ModelAndView db2pgMigErrHistoryDetail(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView("jsonView");
		Db2pgHistoryVO result = null;
		try {
			int mig_exe_sn=Integer.parseInt(request.getParameter("mig_exe_sn"));

			result = (Db2pgHistoryVO) db2pgHistoryService.selectDb2pgMigHistoryDetail(mig_exe_sn);
			mv.addObject("result",result);
			//mv.setViewName("db2pg/popup/db2pgHistoryDetail");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}	
	
	
	
	/**
	 * DB2PG 수행 결과 화면을 보여준다.
	 * 
	 * @param
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/db2pg/popup/db2pgResult.do")
	public ModelAndView db2pgResult(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView("jsonView");
		Map<String, Object> db2pgResult = null;
		Db2pgHistoryVO result = null;

		try {
			String trans_save_pth = request.getParameter("trans_save_pth");
			// 보안: db2pg 루트 하위 경로만 허용(경로 조작 방지)
			if (resolveUnderDb2pgRoot(trans_save_pth) != null) {
				db2pgResult  = DB2PG_LOG.db2pgFile(trans_save_pth);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		try {
			int mig_exe_sn=Integer.parseInt(request.getParameter("mig_exe_sn"));
			result = (Db2pgHistoryVO) db2pgHistoryService.selectDb2pgMigHistoryDetail(mig_exe_sn);
		} catch (Exception e) {
			e.printStackTrace();
		}

		mv.addObject("result",result);
		mv.addObject("db2pgResult",db2pgResult);
		mv.addObject("trans_save_pth",request.getParameter("trans_save_pth"));
		
		return mv;
	}
	
	/**
	 * DB2PG 수행 결과 화면을 보여준다.
	 * 
	 * @param
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/db2pg/db2pgProgress.do")
	public ModelAndView db2pgProgress( HttpServletRequest request) {
		ModelAndView mv = new ModelAndView("jsonView");
		List<String> lines = null;
		String[] result = null;
		try {
			String trans_save_pth = request.getParameter("trans_save_pth");			
			// 보안: db2pg 루트 하위 경로만 허용(경로 조작 방지)
			File progressDir = resolveUnderDb2pgRoot(trans_save_pth);
			if (progressDir != null) {
				lines = DB2PG_LOG.readLastLine(new File(progressDir, "result/progress.txt"), 1);
			}
		} catch (Exception e) {
			System.out.println("* cannot found progress.txt");
		}
		if(lines != null && lines.size() > 0 && lines.get(0).contains(",")){
			result = lines.get(0).split(",");
			mv.addObject("totalcnt",result[0]);
			mv.addObject("nowcnt",result[1]);
			mv.addObject("tables",result[2]);
			mv.addObject("rows",result[3]);
			mv.addObject("migtime",result[4]);
		}else{
			mv.addObject("totalcnt","");
			mv.addObject("nowcnt","");
			mv.addObject("tables","");
			mv.addObject("rows","");
			mv.addObject("migtime","");
		}
		mv.addObject("trans_save_pth",request.getParameter("trans_save_pth"));
		
		return mv;
	}
	
	/**
	 * DDL 수행이력 상세보기 화면을 보여준다.
	 * 
	 * @param
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/db2pg/popup/db2pgResultDDL.do")
	public ModelAndView db2pgResultDDL(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView("jsonView");
		Db2pgHistoryVO result = null;
		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0143_01");
			historyVO.setMnu_id(42);
			accessHistoryService.insertHistory(historyVO);
			
			int mig_exe_sn=Integer.parseInt(request.getParameter("mig_exe_sn"));
			String ddl_save_pth = request.getParameter("ddl_save_pth")+"ddl";
			
			result = (Db2pgHistoryVO) db2pgHistoryService.selectDb2pgDdlHistoryDetail(mig_exe_sn);
			mv.addObject("result",result);
			mv.addObject("ddl_save_pth",ddl_save_pth);
			//mv.setViewName("db2pg/popup/db2pgResultDDL");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}	
	
	/**
	 * DDL 수행이력 파일 리스트를 조회한다.
	 * 
	 * @param historyVO
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value = "/db2pg/selectdb2pgResultDDLFile.do")
	public @ResponseBody List<HashMap<String, String>> selectdb2pgResultDDLFile(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request, HttpServletResponse response) {
		List<HashMap<String, String>> result = new ArrayList<HashMap<String, String>>();
		try {
			String ddl_save_pth = request.getParameter("ddl_save_pth");	

			String pattern = "yyyy-MM-dd HH:mm:ss"; 
			SimpleDateFormat simpleDateFormat = new SimpleDateFormat(pattern);
			
			// 보안: db2pg 루트 하위 디렉토리만 허용(경로 조작 방지)
			File dirFile = resolveUnderDb2pgRoot(ddl_save_pth);
			File [] fileList = (dirFile != null) ? dirFile.listFiles() : null;
			
			if(fileList!=null){
				 for(int i=0; i < fileList.length; i++){
					 HashMap<String, String> hp = new HashMap<String, String>();
					 	hp.put("idx", Integer.toString(i+1));
					    hp.put("name", fileList[i].getName());
					    hp.put("path", ddl_save_pth);
					    hp.put("size", Long.toString(fileList[i].length())+" byte");
					    hp.put("date", simpleDateFormat.format(fileList[i].lastModified()));
				        result.add(hp);
				    }
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	/**
	 * 보안: 사용자 입력 경로가 db2pg 루트(db2pg_path) 하위인지 검증한다.
	 * 유효하면 정규화된 File을, 루트 이탈·오류·빈값이면 null을 반환한다(경로 조작 방지).
	 */
	private File resolveUnderDb2pgRoot(String userPath) {
		if (userPath == null || userPath.trim().isEmpty()) {
			return null;
		}
		try {
			Properties props = new Properties();
			try (FileInputStream in = new FileInputStream(
					ResourceUtils.getFile("classpath:egovframework/tcontrolProps/globals.properties"))) {
				props.load(in);
			}
			File root = new File(props.getProperty("db2pg_path")).getCanonicalFile();
			File target = new File(userPath).getCanonicalFile();
			if (target.getPath().equals(root.getPath())
					|| target.getPath().startsWith(root.getPath() + File.separator)) {
				return target;
			}
		} catch (Exception e) {
			// 검증 실패는 거부(null)로 처리
		}
		return null;
	}

	/**
	 * DDL 수행이력 결과를 파일로 다운받는다.
	 *
	 * @param request
	 * @param response
	 */
	@RequestMapping(value = "/db2pg/popup/db2pgFileDownload.do")
	public  void fileDownload(HttpServletRequest request, HttpServletResponse response){
		try {
			// 인가: DB2PG 수행이력(MN00017) 읽기 권한 확인
			CmmnUtils cu = new CmmnUtils();
			List<Map<String, Object>> menuAut = cu.selectMenuAut(menuAuthorityService, "MN00017");
			if (menuAut == null || menuAut.isEmpty() || "N".equals(menuAut.get(0).get("read_aut_yn"))) {
				response.sendError(HttpServletResponse.SC_FORBIDDEN);
				return;
			}

			String reqPath = request.getParameter("path");
			String reqName = request.getParameter("name");
			if (reqPath == null || reqPath.trim().isEmpty() || reqName == null || reqName.trim().isEmpty()) {
				response.sendError(HttpServletResponse.SC_BAD_REQUEST);
				return;
			}

			// 보안: 파일명은 basename만 사용하여 경로 구분자·상위경로(../)를 제거한다.
			String safeName = new File(reqName).getName();

			// 보안: 다운로드 루트(db2pg_path) 하위로만 허용한다(canonical 경로 prefix 검증).
			Properties props = new Properties();
			try (FileInputStream in = new FileInputStream(
					ResourceUtils.getFile("classpath:egovframework/tcontrolProps/globals.properties"))) {
				props.load(in);
			}
			File root = new File(props.getProperty("db2pg_path")).getCanonicalFile();
			File target = new File(reqPath, safeName).getCanonicalFile();
			if (!target.getPath().equals(root.getPath())
					&& !target.getPath().startsWith(root.getPath() + File.separator)) {
				response.sendError(HttpServletResponse.SC_FORBIDDEN);
				return;
			}
			if (!target.exists() || !target.isFile()) {
				response.sendError(HttpServletResponse.SC_NOT_FOUND);
				return;
			}

			// 검증된 경로/파일명으로만 다운로드한다.
			DownloadView fileDown = new DownloadView(); //파일다운로드 객체생성
			fileDown.filDown(request, response, target.getParent() + File.separator, target.getName(), safeName); //파일다운로드

		} catch (Exception e) {
			e.printStackTrace();
			try {
				response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			} catch (IOException ignore) {
			}
		}
	}
	
	@RequestMapping(value = "/db2pg/cancel.do")
	public @ResponseBody JSONObject db2pgCancel(HttpServletRequest request){
		JSONObject result = new JSONObject();
		String wrkName = request.getParameter("wrk_nm");
		DB2PG_STOP db2pgStop = new DB2PG_STOP();
		
		result = db2pgStop.db2pgStop(wrkName);
		
		return result;
	}
}
