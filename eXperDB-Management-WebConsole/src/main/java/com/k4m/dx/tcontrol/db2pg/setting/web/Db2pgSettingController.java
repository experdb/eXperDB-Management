package com.k4m.dx.tcontrol.db2pg.setting.web;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.k4m.dx.tcontrol.cmmn.CmmnUtils;
import com.k4m.dx.tcontrol.common.service.HistoryVO;
import com.k4m.dx.tcontrol.db2pg.setting.service.CodeVO;
import com.k4m.dx.tcontrol.db2pg.setting.service.DDLConfigVO;
import com.k4m.dx.tcontrol.db2pg.setting.service.DataConfigVO;
import com.k4m.dx.tcontrol.db2pg.setting.service.Db2pgSettingService;
import com.k4m.dx.tcontrol.db2pg.setting.service.SrcTableVO;
import com.k4m.dx.tcontrol.login.service.LoginVO;

@Controller
public class Db2pgSettingController {
	
	@Autowired
	private Db2pgSettingService db2pgSettingService;
	
	/**
	 * DB2PG 설정 화면을 보여준다.
	 * 
	 * @param historyVO
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/db2pgSetting.do")
	public ModelAndView db2pgSetting(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		try {				
			mv.setViewName("db2pg/setting/db2pgSetting");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}

	
	/**
	 * DDL 추출 등록 화면을 보여준다.
	 * 
	 * @param historyVO
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/db2pg/popup/ddlRegForm.do")
	public ModelAndView ddlRegForm(HttpServletRequest request, @ModelAttribute("historyVO") HistoryVO historyVO) {
		ModelAndView mv = new ModelAndView();
		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
//			historyVO.setExe_dtl_cd("DX-T0022");
//			accessHistoryService.insertHistory(historyVO);
			
			List<CodeVO> codeLetter = db2pgSettingService.selectCode("TC0028");
			mv.addObject("codeLetter", codeLetter);
			List<CodeVO> codeTF = db2pgSettingService.selectCode("TC0029"); 
			mv.addObject("codeTF", codeTF);
			
		} catch (Exception e2) {
			// TODO Auto-generated catch block
			e2.printStackTrace();
		}
		mv.setViewName("db2pg/popup/ddlRegForm");
		return mv;
	}

	
	/**
	 * DDL 추출 WORK 등록한다.
	 * 
	 * @param userVo
	 * @param request
	 * @return
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/db2pg/insertDDLWork.do")
	@ResponseBody 
	 public String insertDDLWork(@ModelAttribute("ddlConfigVO") DDLConfigVO ddlConfigVO,HttpServletRequest request, HttpServletResponse response, @ModelAttribute("historyVO") HistoryVO historyVO) {
		String result = "S";
		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
//			historyVO.setExe_dtl_cd("DX-T0034_01");
//			historyVO.setMnu_id(12);
//			accessHistoryService.insertHistory(historyVO);
			

			HttpSession session = request.getSession();
			LoginVO loginVo = (LoginVO) session.getAttribute("session");
			String id = loginVo.getUsr_id();

			
			SrcTableVO srctableVO = new SrcTableVO();
			srctableVO.setFrst_regr_id(id);
			int exrt_trg_tb_wrk_id =0;
			int exrt_exct_tb_wrk_id=0;
			
			//1.T_DB2PG_추출대상소스테이블내역 insert
			if(!request.getParameter("src_include_tables").equals("")){
				exrt_trg_tb_wrk_id =0;
		    	String [] src_include_tables = request.getParameter("src_include_tables").split(",");
		    	for(int i = 0; i < src_include_tables.length; i++) {
		    		System.out.println("추출대상테이블 : "+src_include_tables[i]);
		    		
//		    		srctableVO.setDb2pg_exrt_trg_tb_wrk_id(exrt_trg_tb_wrk_id);
//		    		srctableVO.setExrt_exct_tb_nm(src_include_tables[i]);
//					db2pgSettingService.insertDDLWork(srctableVO);
		    	}
			}
			
			//2.T_DB2PG_추출제외소스테이블내역 insert
			if(!request.getParameter("src_exclude_tables").equals("")){
				exrt_exct_tb_wrk_id=0;
		    	String [] src_exclude_tables = request.getParameter("src_exclude_tables").split(",");
		    	for(int i = 0; i < src_exclude_tables.length; i++) {
		    		System.out.println("추출제외테이블 : "+src_exclude_tables[i]);
		    		
//		    		srctableVO.setDb2pg_exrt_exct_tb_wrk_id(exrt_exct_tb_wrk_id);
//		    		srctableVO.setExrt_exct_tb_nm(src_exclude_tables[i]);
//					db2pgSettingService.insertDDLWork(ddlConfigVO);
		    	}
			}
			
			//3.T_DB2PG_DDL_작업_정보 insert
			ddlConfigVO.setFrst_regr_id(id);
			ddlConfigVO.setLst_mdfr_id(id);
			ddlConfigVO.setDb2pg_exrt_trg_tb_wrk_id(exrt_trg_tb_wrk_id);
			ddlConfigVO.setDb2pg_exrt_exct_tb_wrk_id(exrt_exct_tb_wrk_id);
//			db2pgSettingService.insertDDLWork(ddlConfigVO);
			
			System.out.println("**********************");
			System.out.println(id);
			System.out.println(ddlConfigVO.getDb2pg_ddl_wrk_id());
			System.out.println(ddlConfigVO.getDb2pg_ddl_wrk_nm());
			System.out.println(ddlConfigVO.getDb2pg_ddl_wrk_exp());
			System.out.println(ddlConfigVO.getDb2pg_sys_id());
			System.out.println(ddlConfigVO.getDb2pg_uchr_lchr_val());
			System.out.println(ddlConfigVO.getSrc_tb_ddl_exrt_tf());
			System.out.println(ddlConfigVO.getDdl_save_pth());
			System.out.println(ddlConfigVO.getDb2pg_exrt_trg_tb_wrk_id());
			System.out.println(ddlConfigVO.getDb2pg_exrt_exct_tb_wrk_id());
			System.out.println("**********************");

		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	
	/**
	 * DDL 추출 수정 화면을 보여준다.
	 * 
	 * @param historyVO
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/db2pg/popup/ddlRegReForm.do")
	public ModelAndView ddlRegReForm(HttpServletRequest request, @ModelAttribute("historyVO") HistoryVO historyVO) {
		ModelAndView mv = new ModelAndView();
		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
//			historyVO.setExe_dtl_cd("DX-T0022");
//			accessHistoryService.insertHistory(historyVO);
			
			List<CodeVO> codeLetter = db2pgSettingService.selectCode("TC0028");
			mv.addObject("codeLetter", codeLetter);
			List<CodeVO> codeTF = db2pgSettingService.selectCode("TC0029"); 
			mv.addObject("codeTF", codeTF);
			
		} catch (Exception e2) {
			// TODO Auto-generated catch block
			e2.printStackTrace();
		}
		mv.setViewName("db2pg/popup/ddlRegReForm");
		return mv;
	}
	

	/**
	 * DDL 추출 WORK 수정한다.
	 * 
	 * @param userVo
	 * @param request
	 * @return
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/db2pg/updateDDLWork.do")
	@ResponseBody 
	 public String updateDDLWork(@ModelAttribute("ddlConfigVO") DDLConfigVO ddlConfigVO,HttpServletRequest request, HttpServletResponse response, @ModelAttribute("historyVO") HistoryVO historyVO) {
		String result = "S";
		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
//			historyVO.setExe_dtl_cd("DX-T0034_01");
//			historyVO.setMnu_id(12);
//			accessHistoryService.insertHistory(historyVO);
			

//			db2pgSettingService.updateDDLWork(ddlConfigVO);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	
	/**
	 * DATA 이행 등록 화면을 보여준다.
	 * 
	 * @param historyVO
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/db2pg/popup/dataRegForm.do")
	public ModelAndView dataRegForm(HttpServletRequest request, @ModelAttribute("historyVO") HistoryVO historyVO) {
		ModelAndView mv = new ModelAndView();
		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
//			historyVO.setExe_dtl_cd("DX-T0022");
//			accessHistoryService.insertHistory(historyVO);
			
			List<CodeVO> codeInputMode = db2pgSettingService.selectCode("TC0030");
			mv.addObject("codeInputMode", codeInputMode);
			List<CodeVO> codeTF = db2pgSettingService.selectCode("TC0029"); 
			mv.addObject("codeTF", codeTF);
			
			
		} catch (Exception e2) {
			// TODO Auto-generated catch block
			e2.printStackTrace();
		}
		mv.setViewName("db2pg/popup/dataRegForm");
		return mv;
	}
	
	
	/**
	 * Data 이행 WORK 등록한다.
	 * 
	 * @param userVo
	 * @param request
	 * @return
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/db2pg/insertDataWork.do")
	@ResponseBody 
	 public String insertDataWork(@ModelAttribute("dataConfigVO") DataConfigVO dataConfigVO,HttpServletRequest request, HttpServletResponse response, @ModelAttribute("historyVO") HistoryVO historyVO) {
		String result = "S";
		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
//			historyVO.setExe_dtl_cd("DX-T0034_01");
//			historyVO.setMnu_id(12);
//			accessHistoryService.insertHistory(historyVO);
			
			HttpSession session = request.getSession();
			LoginVO loginVo = (LoginVO) session.getAttribute("session");
			String id = loginVo.getUsr_id();
			dataConfigVO.setFrst_regr_id(id);
			dataConfigVO.setLst_mdfr_id(id);
			
			System.out.println("**********************");
			System.out.println(dataConfigVO.getDb2pg_trsf_wrk_nm());
			System.out.print(dataConfigVO.getDb2pg_trsf_wrk_exp());
			System.out.print(dataConfigVO.getDb2pg_source_system_id());
			System.out.print(dataConfigVO.getDb2pg_trg_sys_id());
			System.out.print(dataConfigVO.getExrt_dat_cnt());
			System.out.print(dataConfigVO.getDb2pg_exrt_trg_tb_wrk_id());
			System.out.print(dataConfigVO.getDb2pg_exrt_exct_tb_wrk_id());
			System.out.print(dataConfigVO.getExrt_dat_ftch_sz());
			System.out.print(dataConfigVO.getDat_ftch_bff_sz());
			System.out.print(dataConfigVO.getExrt_prl_prcs_ecnt());
			System.out.print(dataConfigVO.getLob_dat_bff_sz());
			System.out.print(dataConfigVO.getDb2pg_usr_qry_id());
			System.out.print(dataConfigVO.getIns_opt_cd());
			System.out.print(dataConfigVO.getTb_rbl_tf());
			System.out.print(dataConfigVO.getCnst_cnd_exrt_tf());


			
			//1. repo 등록 -> 2. config 파일 만들기
			
			//소스시스템이 PG이면 SRC_STATEMENT_FETCH_SIZE(기존) -> SRC_COPY_SEGMENT_SIZE 옵션 사용
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	
	/**
	 * DATA 이행 수정 화면을 보여준다.
	 * 
	 * @param historyVO
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/db2pg/popup/dataRegReForm.do")
	public ModelAndView dataRegReForm(HttpServletRequest request, @ModelAttribute("historyVO") HistoryVO historyVO) {
		ModelAndView mv = new ModelAndView();
		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
//			historyVO.setExe_dtl_cd("DX-T0022");
//			accessHistoryService.insertHistory(historyVO);
			
			List<CodeVO> codeInputMode = db2pgSettingService.selectCode("TC0030");
			mv.addObject("codeInputMode", codeInputMode);
			List<CodeVO> codeTF = db2pgSettingService.selectCode("TC0029"); 
			mv.addObject("codeTF", codeTF);
			
			
		} catch (Exception e2) {
			// TODO Auto-generated catch block
			e2.printStackTrace();
		}
		mv.setViewName("db2pg/popup/dataRegReForm");
		return mv;
	}
	
	

	
	
	/**
	 * DBMS시스템 등록 팝업 화면을 보여준다.
	 * 
	 * @param historyVO
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/db2pg/popup/dbmsInfo.do")
	public ModelAndView sourceInfo(HttpServletRequest request, @ModelAttribute("historyVO") HistoryVO historyVO) {
		ModelAndView mv = new ModelAndView();
		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
//			historyVO.setExe_dtl_cd("DX-T0022");
//			accessHistoryService.insertHistory(historyVO);
		} catch (Exception e2) {
			// TODO Auto-generated catch block
			e2.printStackTrace();
		}
				
		mv.setViewName("db2pg/popup/dbmsInfo");
		return mv;
	}
	
		
	/**
	 * 테이블리스트 등록 팝업 화면을 보여준다.
	 * 
	 * @param historyVO
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/db2pg/popup/tableInfo.do")
	public ModelAndView tableInfo(HttpServletRequest request, @ModelAttribute("historyVO") HistoryVO historyVO) {
		ModelAndView mv = new ModelAndView();
		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
//			historyVO.setExe_dtl_cd("DX-T0022");
//			accessHistoryService.insertHistory(historyVO);
		} catch (Exception e2) {
			// TODO Auto-generated catch block
			e2.printStackTrace();
		}
				
		mv.setViewName("db2pg/popup/tableInfo");
		return mv;
	}
	
	
	/**
	 * 경로가 유효한지 체크한다.
	 * 
	 * @param src_file_output_path
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/db2pgPathCheck.do")
	public @ResponseBody String db2pgPathCheck(@RequestParam("ddl_save_pth") String ddl_save_pth) {
		try {
			System.out.println("경로 : "+ddl_save_pth);
			int resultSet = 0;
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
