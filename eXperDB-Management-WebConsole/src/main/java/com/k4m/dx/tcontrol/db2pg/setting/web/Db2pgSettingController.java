package com.k4m.dx.tcontrol.db2pg.setting.web;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.ResourceUtils;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.k4m.dx.tcontrol.admin.accesshistory.service.AccessHistoryService;
import com.k4m.dx.tcontrol.backup.service.BackupService;
import com.k4m.dx.tcontrol.cmmn.AES256;
import com.k4m.dx.tcontrol.cmmn.AES256_KEY;
import com.k4m.dx.tcontrol.cmmn.CmmnUtils;
import com.k4m.dx.tcontrol.cmmn.client.ClientProtocolID;
import com.k4m.dx.tcontrol.common.service.HistoryVO;
import com.k4m.dx.tcontrol.db2pg.cmmn.DB2PG_ImmediateExe;
import com.k4m.dx.tcontrol.db2pg.cmmn.DB2PG_START;
import com.k4m.dx.tcontrol.db2pg.cmmn.DatabaseTableInfo;
import com.k4m.dx.tcontrol.db2pg.dbms.service.Db2pgSysInfVO;
import com.k4m.dx.tcontrol.db2pg.dbms.service.DbmsService;
import com.k4m.dx.tcontrol.db2pg.history.service.Db2pgHistoryService;
import com.k4m.dx.tcontrol.db2pg.setting.service.CodeVO;
import com.k4m.dx.tcontrol.db2pg.setting.service.DDLConfigVO;
import com.k4m.dx.tcontrol.db2pg.setting.service.DataConfigVO;
import com.k4m.dx.tcontrol.db2pg.setting.service.Db2pgSettingService;
import com.k4m.dx.tcontrol.db2pg.setting.service.QueryVO;
import com.k4m.dx.tcontrol.db2pg.setting.service.SrcTableVO;
import com.k4m.dx.tcontrol.login.service.LoginVO;

@Controller
public class Db2pgSettingController {
	
	@Autowired
	private BackupService backupService;
	
	@Autowired
	private Db2pgSettingService db2pgSettingService;
	
	@Autowired
	private DbmsService dbmsService;
	
	@Autowired
	private Db2pgHistoryService db2pgHistoryService;
	
	@Autowired
	private AccessHistoryService accessHistoryService;
	
	
	
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
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0137");
			historyVO.setMnu_id(41);
			accessHistoryService.insertHistory(historyVO);
			
			List<Map<String, Object>> dbmsGrb = dbmsService.dbmsGrb();
			mv.addObject("dbmsGrb", dbmsGrb);
			
			List<CodeVO> codeLetter = db2pgSettingService.selectCode("TC0028");
			mv.addObject("codeLetter", codeLetter);
			List<CodeVO> codeTF = db2pgSettingService.selectCode("TC0029");
			mv.addObject("codeTF", codeTF);
			List<CodeVO> codeInputMode = db2pgSettingService.selectCode("TC0030");
			mv.addObject("codeInputMode", codeInputMode);
			
			mv.setViewName("db2pg/setting/db2pgSetting");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
	
	/**
	 * DDL WORK 리스트를 조회한다.
	 * 
	 * @param request
	 * @return resultSet
	 * @throws Exception
	 */
	@RequestMapping(value = "/db2pg/selectDDLWork.do")
	public @ResponseBody List<DDLConfigVO> selectDDLWork(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request, HttpServletResponse response) {
		List<DDLConfigVO> resultSet = null;
		Map<String, Object> param = new HashMap<String, Object>();
		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0137_01");
			historyVO.setMnu_id(41);
			accessHistoryService.insertHistory(historyVO);

			String wrk_nm = request.getParameter("wrk_nm");
			String dbms_dscd = request.getParameter("dbms_dscd");
			String ipadr = request.getParameter("ipadr");
			String dtb_nm = request.getParameter("dtb_nm");
			String scm_nm = request.getParameter("scm_nm");
			param.put("wrk_nm", wrk_nm);
			param.put("dbms_dscd", dbms_dscd);
			param.put("ipadr", ipadr);
			param.put("dtb_nm", dtb_nm);
			param.put("scm_nm", scm_nm);
			resultSet = db2pgSettingService.selectDDLWork(param);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return resultSet;
	}
	
	/**
	 * MIGRATION WORK 리스트를 조회한다.
	 * 
	 * @param request
	 * @return resultSet
	 * @throws Exception
	 */
	@RequestMapping(value = "/db2pg/selectDataWork.do")
	public @ResponseBody List<DataConfigVO> selectDataWork(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request, HttpServletResponse response) {
		List<DataConfigVO> resultSet = null;
		Map<String, Object> param = new HashMap<String, Object>();
		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0140_01");
			historyVO.setMnu_id(41);
			accessHistoryService.insertHistory(historyVO);

			String wrk_nm = request.getParameter("wrk_nm");
			String data_dbms_dscd = request.getParameter("data_dbms_dscd");
			String dbms_dscd = request.getParameter("dbms_dscd");
			String ipadr = request.getParameter("ipadr");
			String dtb_nm = request.getParameter("dtb_nm");
			String scm_nm = request.getParameter("scm_nm");
			param.put("wrk_nm", wrk_nm);
			param.put("data_dbms_dscd", data_dbms_dscd);
			param.put("dbms_dscd", dbms_dscd);
			param.put("ipadr", ipadr);
			param.put("dtb_nm", dtb_nm);
			param.put("scm_nm", scm_nm);
			resultSet = db2pgSettingService.selectDataWork(param);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return resultSet;
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
			historyVO.setExe_dtl_cd("DX-T0138");
			historyVO.setMnu_id(41);
			accessHistoryService.insertHistory(historyVO);
			
			List<CodeVO> codeLetter = db2pgSettingService.selectCode("TC0028");
			mv.addObject("codeLetter", codeLetter);
			List<CodeVO> codeTF = db2pgSettingService.selectCode("TC0029");
			mv.addObject("codeTF", codeTF);
		} catch (Exception e2) {
			e2.printStackTrace();
		}
		mv.setViewName("db2pg/popup/ddlRegForm");
		return mv;
	}
	
	/**
	 * DDL 추출 WORK 등록한다.
	 * 
	 * @param ddlConfigVO
	 * @param request
	 * @return
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/db2pg/insertDDLWork.do")
	 public @ResponseBody JSONObject insertDDLWork(@ModelAttribute("ddlConfigVO") DDLConfigVO ddlConfigVO, HttpServletRequest request, HttpServletResponse response, @ModelAttribute("historyVO") HistoryVO historyVO) {
		JSONObject result = new JSONObject();
		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0138_01");
			historyVO.setMnu_id(41);
			accessHistoryService.insertHistory(historyVO);
			
			AES256 aes = new AES256(AES256_KEY.ENC_KEY);
			HttpSession session = request.getSession();
			LoginVO loginVo = (LoginVO) session.getAttribute("session");
			String id = loginVo.getUsr_id();
			
			SrcTableVO srctableVO = new SrcTableVO();
			srctableVO.setFrst_regr_id(id);
			int exrt_trg_tb_wrk_id =0;
			int exrt_exct_tb_wrk_id=0;			
			int wrk_id = 0;
			String src_include_tables=request.getParameter("src_include_tables");
			String src_exclude_tables=request.getParameter("src_exclude_tables");
			int src_table_total_cnt = Integer.parseInt(request.getParameter("src_table_total_cnt"));
			
			//1. WORK 등록
			String time = nowTime();
			Properties props = new Properties();
			props.load(new FileInputStream(ResourceUtils.getFile("classpath:egovframework/tcontrolProps/globals.properties")));			
			String db2pg_path = props.get("db2pg_path").toString();	
			String ddl_path = db2pg_path+"/ddl/"+time+"_"+ddlConfigVO.getDb2pg_ddl_wrk_nm();
			
			//시퀀스 조회
			wrk_id=db2pgSettingService.selectWorkSeq();
			ddlConfigVO.setWrk_id(wrk_id);
			ddlConfigVO.setFrst_regr_id(id);
			ddlConfigVO.setLst_mdfr_id(id);
			ddlConfigVO.setDb2pg_ddl_wrk_exp(toString(ddlConfigVO.getDb2pg_ddl_wrk_exp()));
			//작업 정보등록
			db2pgSettingService.insertDb2pgWork(ddlConfigVO);
			
			//2.T_DB2PG_추출대상소스테이블내역 insert
			if(!src_include_tables.equals("")){
				exrt_trg_tb_wrk_id=db2pgSettingService.selectExrttrgSrctblsSeq();
		    	srctableVO.setDb2pg_exrt_trg_tb_wrk_id(exrt_trg_tb_wrk_id);
		    	srctableVO.setExrt_trg_tb_nm(src_include_tables);
		    	srctableVO.setSrc_table_total_cnt(src_table_total_cnt);
				db2pgSettingService.insertExrttrgSrcTb(srctableVO);
			}
			
			//3.T_DB2PG_추출제외소스테이블내역 insert
			if(!src_exclude_tables.equals("")){
				exrt_exct_tb_wrk_id=db2pgSettingService.selectExrtexctSrctblsSeq();
		    	srctableVO.setDb2pg_exrt_exct_tb_wrk_id(exrt_exct_tb_wrk_id);
		    	srctableVO.setExrt_exct_tb_nm(src_exclude_tables);
		    	srctableVO.setSrc_table_total_cnt(src_table_total_cnt);
				db2pgSettingService.insertExrtexctSrcTb(srctableVO);
			}
			
			//4.T_DB2PG_DDL_작업_정보 insert
			ddlConfigVO.setDdl_save_pth(ddl_path);
			ddlConfigVO.setWrk_id(wrk_id);
			ddlConfigVO.setDb2pg_exrt_trg_tb_wrk_id(exrt_trg_tb_wrk_id);
			ddlConfigVO.setDb2pg_exrt_exct_tb_wrk_id(exrt_exct_tb_wrk_id);
			db2pgSettingService.insertDDLWork(ddlConfigVO);
			
			//5.config 생성
			Db2pgSysInfVO sourceDBMS = (Db2pgSysInfVO) db2pgSettingService.selectDBMS(ddlConfigVO.getDb2pg_sys_id());
			JSONObject configObj = new JSONObject();
			configObj.put("path", db2pg_path);
			configObj.put("src_host", sourceDBMS.getIpadr());
			configObj.put("src_user", sourceDBMS.getSpr_usr_id());
			configObj.put("src_password", aes.aesDecode(sourceDBMS.getPwd()));
			configObj.put("src_database", sourceDBMS.getDtb_nm());
			configObj.put("src_schema", sourceDBMS.getScm_nm());
			configObj.put("src_dbms_type", sourceDBMS.getDbms_dscd());
			configObj.put("src_port", sourceDBMS.getPortno());
			configObj.put("src_db_charset", sourceDBMS.getCrts_nm());
			configObj.put("wrk_nm", ddlConfigVO.getDb2pg_ddl_wrk_nm());
			configObj.put("src_classify_string", ddlConfigVO.getDb2pg_uchr_lchr_val());
			configObj.put("src_table_ddl", ddlConfigVO.getSrc_tb_ddl_exrt_tf());
			configObj.put("src_file_output_path", ddl_path);
			configObj.put("src_include_tables", src_include_tables);
			configObj.put("src_exclude_tables", src_exclude_tables);
			
			result = Db2pgConfigController.createDDLConfig(configObj);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("resultCode", "8000000003");
		}
		return result;
	}
	
	/**
	 * DDL 추출 WORK를 복제 등록한다.
	 * 
	 * @param ddlConfigVO
	 * @param request
	 * @return
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/db2pg/insertCopyDDLWork.do")
	 public @ResponseBody JSONObject insertCopyDDLWork(@ModelAttribute("ddlConfigVO") DDLConfigVO ddlConfigVO, HttpServletRequest request, HttpServletResponse response, @ModelAttribute("historyVO") HistoryVO historyVO) {
		JSONObject result = new JSONObject();
		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0137_03");
			historyVO.setMnu_id(41);
			accessHistoryService.insertHistory(historyVO);
			
			AES256 aes = new AES256(AES256_KEY.ENC_KEY);
			HttpSession session = request.getSession();
			LoginVO loginVo = (LoginVO) session.getAttribute("session");
			String id = loginVo.getUsr_id();
			
			//1. WORK 등록
			String time = nowTime();
			Properties props = new Properties();
			props.load(new FileInputStream(ResourceUtils.getFile("classpath:egovframework/tcontrolProps/globals.properties")));			
			String db2pg_path = props.get("db2pg_path").toString();	
			String ddl_path = db2pg_path+"/ddl/"+time+"_"+ddlConfigVO.getDb2pg_ddl_wrk_nm();
			
			//시퀀스 조회
			int wrk_id=db2pgSettingService.selectWorkSeq();
			ddlConfigVO.setWrk_id(wrk_id);
			ddlConfigVO.setFrst_regr_id(id);
			ddlConfigVO.setLst_mdfr_id(id);
			ddlConfigVO.setDb2pg_ddl_wrk_exp(toString(ddlConfigVO.getDb2pg_ddl_wrk_exp()));
			//작업 정보등록
			db2pgSettingService.insertDb2pgWork(ddlConfigVO);
	
			//4.T_DB2PG_DDL_작업_정보 insert
			DDLConfigVO sourceDDLWork = (DDLConfigVO) db2pgSettingService.selectDetailDDLWork(Integer.parseInt(request.getParameter("db2pg_ddl_wrk_id")));
			DDLConfigVO targetDDLWork = new DDLConfigVO();
			targetDDLWork.setDdl_save_pth(ddl_path);
			targetDDLWork.setWrk_id(wrk_id);
			targetDDLWork.setDb2pg_sys_id(sourceDDLWork.getDb2pg_sys_id());
			targetDDLWork.setDb2pg_uchr_lchr_val(sourceDDLWork.getDb2pg_uchr_lchr_val());
			targetDDLWork.setSrc_tb_ddl_exrt_tf(sourceDDLWork.getSrc_tb_ddl_exrt_tf());
			targetDDLWork.setDb2pg_exrt_trg_tb_wrk_id(sourceDDLWork.getDb2pg_exrt_trg_tb_wrk_id());
			targetDDLWork.setDb2pg_exrt_exct_tb_wrk_id(sourceDDLWork.getDb2pg_exrt_exct_tb_wrk_id());
			targetDDLWork.setFrst_regr_id(id);
			targetDDLWork.setLst_mdfr_id(id);
			db2pgSettingService.insertDDLWork(targetDDLWork);
		
			//5.config 생성
			Db2pgSysInfVO sourceDBMS = (Db2pgSysInfVO) db2pgSettingService.selectDBMS(sourceDDLWork.getDb2pg_sys_id());
			JSONObject configObj = new JSONObject();
			configObj.put("path", db2pg_path);
			configObj.put("src_host", sourceDBMS.getIpadr());
			configObj.put("src_user", sourceDBMS.getSpr_usr_id());
			configObj.put("src_password", aes.aesDecode(sourceDBMS.getPwd()));
			configObj.put("src_database", sourceDBMS.getDtb_nm());
			configObj.put("src_schema", sourceDBMS.getScm_nm());
			configObj.put("src_dbms_type", sourceDBMS.getDbms_dscd());
			configObj.put("src_port", sourceDBMS.getPortno());
			configObj.put("src_db_charset", sourceDBMS.getCrts_nm());
			configObj.put("wrk_nm", ddlConfigVO.getDb2pg_ddl_wrk_nm());
			configObj.put("src_classify_string", sourceDDLWork.getDb2pg_uchr_lchr_val());
			configObj.put("src_table_ddl", sourceDDLWork.getSrc_tb_ddl_exrt_tf());
			configObj.put("src_file_output_path", ddl_path);
			configObj.put("src_include_tables", sourceDDLWork.getExrt_trg_tb_nm()==null?"":sourceDDLWork.getExrt_trg_tb_nm());
			configObj.put("src_exclude_tables", sourceDDLWork.getExrt_exct_tb_nm()==null?"":sourceDDLWork.getExrt_exct_tb_nm());
			
			result = Db2pgConfigController.createDDLConfig(configObj);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("resultCode", "8000000003");
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
		ModelAndView mv = new ModelAndView("jsonView");
		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0139");
			historyVO.setMnu_id(41);
			accessHistoryService.insertHistory(historyVO);
			
			int db2pg_ddl_wrk_id = Integer.parseInt(request.getParameter("db2pg_ddl_wrk_id"));
			DDLConfigVO result = (DDLConfigVO) db2pgSettingService.selectDetailDDLWork(db2pg_ddl_wrk_id);
			mv.addObject("db2pg_ddl_wrk_id", result.getDb2pg_ddl_wrk_id());
			mv.addObject("wrk_id", result.getWrk_id());
			mv.addObject("db2pg_ddl_wrk_nm", result.getDb2pg_ddl_wrk_nm());
			mv.addObject("db2pg_ddl_wrk_exp", result.getDb2pg_ddl_wrk_exp());
			mv.addObject("db2pg_uchr_lchr_val", result.getDb2pg_uchr_lchr_val()); 
			String src_tb_ddl_exrt_tf = String.valueOf(result.getSrc_tb_ddl_exrt_tf()).toUpperCase();
			mv.addObject("src_tb_ddl_exrt_tf",  src_tb_ddl_exrt_tf);
			mv.addObject("ddl_save_pth", result.getDdl_save_pth());
			mv.addObject("db2pg_sys_id", result.getDb2pg_sys_id());
			mv.addObject("db2pg_sys_nm", result.getDb2pg_sys_nm());
			mv.addObject("exrt_trg_tb_nm", result.getExrt_trg_tb_nm());
			mv.addObject("exrt_exct_tb_nm", result.getExrt_exct_tb_nm());
			mv.addObject("exrt_trg_tb_cnt", result.getExrt_trg_tb_cnt());
			mv.addObject("exrt_exct_tb_cnt", result.getExrt_exct_tb_cnt());
			mv.addObject("exrt_trg_tb_total_cnt", result.getExrt_trg_tb_total_cnt());
			mv.addObject("exrt_exct_tb_total_cnt", result.getExrt_exct_tb_total_cnt());
			
			List<CodeVO> codeLetter = db2pgSettingService.selectCode("TC0028");
			mv.addObject("codeLetter", codeLetter);
			List<CodeVO> codeTF = db2pgSettingService.selectCode("TC0029"); 
			mv.addObject("codeTF", codeTF);
		} catch (Exception e2) {
			e2.printStackTrace();
		}
		return mv;
	}

	/**
	 * DDL 추출 WORK 수정한다.
	 * 
	 * @param ddlConfigVO
	 * @param request
	 * @return
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/db2pg/updateDDLWork.do")
	 public @ResponseBody JSONObject updateDDLWork(@ModelAttribute("ddlConfigVO") DDLConfigVO ddlConfigVO, HttpServletRequest request, HttpServletResponse response, @ModelAttribute("historyVO") HistoryVO historyVO) {
		JSONObject result = new JSONObject();
		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0139_01");
			historyVO.setMnu_id(41);
			accessHistoryService.insertHistory(historyVO);
		
			AES256 aes = new AES256(AES256_KEY.ENC_KEY);
			HttpSession session = request.getSession();
			LoginVO loginVo = (LoginVO) session.getAttribute("session");
			String id = loginVo.getUsr_id();
			
			SrcTableVO srctableVO = new SrcTableVO();
			srctableVO.setFrst_regr_id(id);
			int exrt_trg_tb_wrk_id =0;
			int exrt_exct_tb_wrk_id=0;
			String src_include_tables=request.getParameter("src_include_tables");
			String src_exclude_tables=request.getParameter("src_exclude_tables");
			int src_table_total_cnt = Integer.parseInt(request.getParameter("src_table_total_cnt"));
			
			//1. WORK 등록
			String time = nowTime();
			Properties props = new Properties();
			props.load(new FileInputStream(ResourceUtils.getFile("classpath:egovframework/tcontrolProps/globals.properties")));			
			String db2pg_path = props.get("db2pg_path").toString();	
			String ddl_path = db2pg_path+"/ddl/"+time+"_"+ddlConfigVO.getDb2pg_ddl_wrk_nm();
			
			//2.T_DB2PG_추출대상소스테이블내역 insert
			if(!src_include_tables.equals("")){
				exrt_trg_tb_wrk_id=db2pgSettingService.selectExrttrgSrctblsSeq();
		    	srctableVO.setDb2pg_exrt_trg_tb_wrk_id(exrt_trg_tb_wrk_id);
		    	srctableVO.setExrt_trg_tb_nm(src_include_tables);
		    	srctableVO.setSrc_table_total_cnt(src_table_total_cnt);
				db2pgSettingService.insertExrttrgSrcTb(srctableVO);
			}
			
			//3.T_DB2PG_추출제외소스테이블내역 insert
			if(!src_exclude_tables.equals("")){
				exrt_exct_tb_wrk_id=db2pgSettingService.selectExrtexctSrctblsSeq();
		    	srctableVO.setDb2pg_exrt_exct_tb_wrk_id(exrt_exct_tb_wrk_id);
		    	srctableVO.setExrt_exct_tb_nm(src_exclude_tables);
		    	srctableVO.setSrc_table_total_cnt(src_table_total_cnt);
				db2pgSettingService.insertExrtexctSrcTb(srctableVO);
			}
			
			//4.T_DB2PG_DDL_작업_정보 insert
			ddlConfigVO.setLst_mdfr_id(id);
			ddlConfigVO.setDb2pg_exrt_trg_tb_wrk_id(exrt_trg_tb_wrk_id);
			ddlConfigVO.setDb2pg_exrt_exct_tb_wrk_id(exrt_exct_tb_wrk_id);
			ddlConfigVO.setDdl_save_pth(ddl_path);
			ddlConfigVO.setDb2pg_ddl_wrk_exp(toString(ddlConfigVO.getDb2pg_ddl_wrk_exp()));
			db2pgSettingService.updateDDLWork(ddlConfigVO);
			
			//5.config 생성
			Db2pgSysInfVO sourceDBMS = (Db2pgSysInfVO) db2pgSettingService.selectDBMS(ddlConfigVO.getDb2pg_sys_id());
			JSONObject configObj = new JSONObject();
			configObj.put("path", db2pg_path);
			configObj.put("src_host", sourceDBMS.getIpadr());
			configObj.put("src_user", sourceDBMS.getSpr_usr_id());
			configObj.put("src_password", aes.aesDecode(sourceDBMS.getPwd()));
			configObj.put("src_database", sourceDBMS.getDtb_nm());
			configObj.put("src_schema", sourceDBMS.getScm_nm());
			configObj.put("src_dbms_type", sourceDBMS.getDbms_dscd());
			configObj.put("src_port", sourceDBMS.getPortno());
			configObj.put("src_db_charset", sourceDBMS.getCrts_nm());
			configObj.put("wrk_nm", ddlConfigVO.getDb2pg_ddl_wrk_nm());
			configObj.put("src_classify_string", ddlConfigVO.getDb2pg_uchr_lchr_val());
			configObj.put("src_table_ddl", ddlConfigVO.getSrc_tb_ddl_exrt_tf());
			configObj.put("src_file_output_path", ddl_path);
			configObj.put("src_include_tables", src_include_tables);
			configObj.put("src_exclude_tables", src_exclude_tables);
			
			result = Db2pgConfigController.createDDLConfig(configObj);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("resultCode", "8000000003");
		}
		return result;
	}
	
	/**
	 * DDL WORK를 삭제한다.
	 * 
	 * @param historyVO
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/db2pg/deleteDDLWork.do")
	public @ResponseBody JSONObject deleteDDLWork(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletResponse response, HttpServletRequest request) throws SQLException {
		JSONObject result = new JSONObject();
		int i=0;
		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0137_02");
			historyVO.setMnu_id(41);
			accessHistoryService.insertHistory(historyVO);
			
			//DB 삭제
			String[] db2pg_ddl_wrk_id = request.getParameter("db2pg_ddl_wrk_id").toString().split(",");
			for (i = 0; i < db2pg_ddl_wrk_id.length; i++) {
				db2pgSettingService.deleteDDLWork(Integer.parseInt(db2pg_ddl_wrk_id[i]));
			}
			//work 삭제
			String[] wrk_id = request.getParameter("wrk_id").toString().split(",");
			for (i = 0; i < wrk_id.length; i++) {
				backupService.deleteWork(Integer.parseInt(wrk_id[i]));
			}
			//config 파일 삭제
			Properties props = new Properties();
			props.load(new FileInputStream(ResourceUtils.getFile("classpath:egovframework/tcontrolProps/globals.properties")));			
			String db2pg_path = props.get("db2pg_path").toString();	
			String[] db2pg_ddl_wrk_nm = request.getParameter("db2pg_ddl_wrk_nm").toString().split(",");
			for (i = 0; i < db2pg_ddl_wrk_nm.length; i++) {
				result = Db2pgConfigController.deleteConfig(db2pg_ddl_wrk_nm[i],db2pg_path);
			}
		} catch (Exception e) {
			e.printStackTrace();
			result.put("resultCode", "8000000003");
		}
		return result;
	}
	
	/**
	 * MIGRATION 등록 화면을 보여준다.
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
			historyVO.setExe_dtl_cd("DX-T0141");
			historyVO.setMnu_id(41);
			accessHistoryService.insertHistory(historyVO);
			
			List<CodeVO> codeInputMode = db2pgSettingService.selectCode("TC0030");
			mv.addObject("codeInputMode", codeInputMode);
			List<CodeVO> codeTF = db2pgSettingService.selectCode("TC0029"); 
			mv.addObject("codeTF", codeTF);
			List<CodeVO> codeLetter = db2pgSettingService.selectCode("TC0028");
			mv.addObject("codeLetter", codeLetter);
		} catch (Exception e2) {
			e2.printStackTrace();
		}
		mv.setViewName("db2pg/popup/dataRegForm");
		return mv;
	}
	
	/**
	 * MIGRATION WORK 등록한다.
	 * 
	 * @param dataConfigVO
	 * @param request
	 * @return
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/db2pg/insertDataWork.do")
	 public @ResponseBody JSONObject insertDataWork(@ModelAttribute("dataConfigVO") DataConfigVO dataConfigVO, HttpServletRequest request, HttpServletResponse response, @ModelAttribute("historyVO") HistoryVO historyVO) {
		JSONObject result = new JSONObject();
		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0141_01");
			historyVO.setMnu_id(41);
			accessHistoryService.insertHistory(historyVO);
			
			AES256 aes = new AES256(AES256_KEY.ENC_KEY);
			HttpSession session = request.getSession();
			LoginVO loginVo = (LoginVO) session.getAttribute("session");
			String id = loginVo.getUsr_id();
			
			JSONObject configObj = new JSONObject();
			
			SrcTableVO srctableVO = new SrcTableVO();
			srctableVO.setFrst_regr_id(id);
			int exrt_trg_tb_wrk_id =0;
			int exrt_exct_tb_wrk_id=0;
			int wrk_id = 0;
			String src_include_tables=request.getParameter("src_include_tables");
			String src_exclude_tables=request.getParameter("src_exclude_tables");
			int src_table_total_cnt = Integer.parseInt(request.getParameter("src_table_total_cnt"));
			String [] usrqry_content = request.getParameterValues("db2pg_usrqry_content");
			String [] usrqry_table = request.getParameterValues("db2pg_usrqry_table");
			
			//1. WORK 등록
			String time = nowTime();
			Properties props = new Properties();
			props.load(new FileInputStream(ResourceUtils.getFile("classpath:egovframework/tcontrolProps/globals.properties")));			
			String db2pg_path = props.get("db2pg_path").toString();	
			String trans_path = db2pg_path+"/trans/"+time+"_"+dataConfigVO.getDb2pg_trsf_wrk_nm();
			
			//시퀀스 조회
			wrk_id=db2pgSettingService.selectWorkSeq();

			dataConfigVO.setWrk_id(wrk_id);
			dataConfigVO.setFrst_regr_id(id);
			dataConfigVO.setLst_mdfr_id(id);
			dataConfigVO.setDb2pg_trsf_wrk_exp(toString(dataConfigVO.getDb2pg_trsf_wrk_exp()));
			//작업 정보등록
			db2pgSettingService.insertDb2pgWorkData(dataConfigVO);
			
			//1.T_DB2PG_추출대상소스테이블내역 insert
			if(!src_include_tables.equals("")){
				exrt_trg_tb_wrk_id=db2pgSettingService.selectExrttrgSrctblsSeq();
		    	srctableVO.setDb2pg_exrt_trg_tb_wrk_id(exrt_trg_tb_wrk_id);
		    	srctableVO.setExrt_trg_tb_nm(src_include_tables);
		    	srctableVO.setSrc_table_total_cnt(src_table_total_cnt);
				db2pgSettingService.insertExrttrgSrcTb(srctableVO);
			}
			
			//2.T_DB2PG_추출제외소스테이블내역 insert
			if(!src_exclude_tables.equals("")){
				exrt_exct_tb_wrk_id=db2pgSettingService.selectExrtexctSrctblsSeq();
		    	srctableVO.setDb2pg_exrt_exct_tb_wrk_id(exrt_exct_tb_wrk_id);
		    	srctableVO.setExrt_exct_tb_nm(src_exclude_tables);
		    	srctableVO.setSrc_table_total_cnt(src_table_total_cnt);
				db2pgSettingService.insertExrtexctSrcTb(srctableVO);
			}
			
			
			int usr_qry_id=0;
			//4.T_DB2PG_Data_작업_정보 insert
			dataConfigVO.setTrans_save_pth(trans_path);
			dataConfigVO.setDb2pg_exrt_trg_tb_wrk_id(exrt_trg_tb_wrk_id);
			dataConfigVO.setDb2pg_exrt_exct_tb_wrk_id(exrt_exct_tb_wrk_id);
			dataConfigVO.setDb2pg_usr_qry_id(usr_qry_id);
			
			//src_cnd_qry where문절에 where, ; 문자 제거
			if(!dataConfigVO.getSrc_cnd_qry().equals("")){
				dataConfigVO.setSrc_cnd_qry(toString(dataConfigVO.getSrc_cnd_qry()));
				if(dataConfigVO.getSrc_cnd_qry().contains("WHERE")){
					dataConfigVO.setSrc_cnd_qry(dataConfigVO.getSrc_cnd_qry().replaceAll("WHERE", ""));
				}else if(dataConfigVO.getSrc_cnd_qry().contains("where")){
					dataConfigVO.setSrc_cnd_qry(dataConfigVO.getSrc_cnd_qry().replaceAll("where", ""));
				}else if(dataConfigVO.getSrc_cnd_qry().contains(";")){
					dataConfigVO.setSrc_cnd_qry(dataConfigVO.getSrc_cnd_qry().replaceAll(";", ""));
				}
			}
			int dataWorkId = db2pgSettingService.insertDataWork(dataConfigVO);
			
			
			//3.사용자쿼리를 사용할 경우 insert
			if(usrqry_table.length == 1 && usrqry_table[0].equals("")){
				configObj.put("usrqry_tf", false);
			}else{
				configObj.put("usrqry_tf", true);
				QueryVO queryVO = new QueryVO();
				queryVO.setDb2pg_trsf_wrk_id(dataWorkId);
				queryVO.setFrst_regr_id(id);
				queryVO.setLst_mdfr_id(id);
				for(int i=0;i<usrqry_table.length;i++){
					usrqry_content[i]=toString(usrqry_content[i]);
					usrqry_table[i]=toString(usrqry_table[i]);
					queryVO.setTar_tb_name(usrqry_table[i].toString());
					queryVO.setUsr_qry_exp(usrqry_content[i].toString());
					db2pgSettingService.insertUsrQry(queryVO);
				}
				result = Db2pgConfigController.createXml(usrqry_table, usrqry_content, db2pg_path, dataConfigVO.getDb2pg_trsf_wrk_nm());
			}
			
			
			//5. config 파일 만들기
			Db2pgSysInfVO sourceDBMS = (Db2pgSysInfVO) db2pgSettingService.selectDBMS(dataConfigVO.getDb2pg_src_sys_id());
			Db2pgSysInfVO targetDBMS = (Db2pgSysInfVO) db2pgSettingService.selectDBMS(dataConfigVO.getDb2pg_trg_sys_id());
			
			configObj.put("path", db2pg_path);
			configObj.put("wrk_nm", dataConfigVO.getDb2pg_trsf_wrk_nm());
			configObj.put("src_host", sourceDBMS.getIpadr());
			configObj.put("src_user", sourceDBMS.getSpr_usr_id());
			configObj.put("src_password", aes.aesDecode(sourceDBMS.getPwd()));
			configObj.put("src_database", sourceDBMS.getDtb_nm());
			configObj.put("src_schema", sourceDBMS.getScm_nm());
			configObj.put("src_dbms_type", sourceDBMS.getDbms_dscd());
			configObj.put("src_port", sourceDBMS.getPortno());
			configObj.put("src_db_charset", sourceDBMS.getCrts_nm());
			configObj.put("src_include_tables", src_include_tables);
			configObj.put("src_exclude_tables", src_exclude_tables);
			configObj.put("src_select_on_parallel", dataConfigVO.getExrt_prl_prcs_ecnt());
			configObj.put("src_copy_segment_size", dataConfigVO.getExrt_dat_ftch_sz());
			configObj.put("src_buffer_size", dataConfigVO.getDat_ftch_bff_sz());
			configObj.put("src_lob_buffer_size", dataConfigVO.getLob_dat_bff_sz());
			configObj.put("src_rows_export", dataConfigVO.getExrt_dat_cnt());
			configObj.put("tar_host", targetDBMS.getIpadr());
			configObj.put("tar_user", targetDBMS.getSpr_usr_id());
			configObj.put("tar_password", aes.aesDecode(targetDBMS.getPwd()));
			configObj.put("tar_database", targetDBMS.getDtb_nm());
			configObj.put("tar_schema", targetDBMS.getScm_nm());
			configObj.put("tar_port", targetDBMS.getPortno());
			configObj.put("tar_db_charset", targetDBMS.getCrts_nm());
			if(dataConfigVO.getIns_opt_cd().equals("TRUNCATE")){
				configObj.put("tar_truncate", "true");
			}else{
				configObj.put("tar_truncate", "false");
			}
			configObj.put("tar_constraint_rebuild", dataConfigVO.getTb_rbl_tf());
			configObj.put("tar_constraint_ddl", dataConfigVO.getCnst_cnd_exrt_tf());
			configObj.put("src_where_condition", dataConfigVO.getSrc_cnd_qry());
			configObj.put("src_file_output_path", trans_path);
			configObj.put("src_classify_string", dataConfigVO.getDb2pg_uchr_lchr_val());
			
			result = Db2pgConfigController.createDataConfig(configObj);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("resultCode", "8000000003");
		}
		return result;
	}
	
	
	public static String toString(String str){
		if(str == null)
		return null;
		
		String returnStr = str;
		returnStr = returnStr.replaceAll("<br>", "\n");
		returnStr = returnStr.replaceAll("&gt;", ">");
		returnStr = returnStr.replaceAll("&lt;", "<");
		returnStr = returnStr.replaceAll("&quot;", "\"");
		returnStr = returnStr.replaceAll("&nbsp;", " ");
		returnStr = returnStr.replaceAll("&amp;", "&");
//		returnStr = returnStr.replaceAll("\"", "&#34;");
		returnStr = returnStr.replaceAll("&#34;", "\"");
		returnStr = returnStr.replaceAll("&apos;", "'");	
		
		return returnStr;
	}
	
	
	/**
	 * MIGRATION WORK 복제 등록한다.
	 * 
	 * @param dataConfigVO
	 * @param request
	 * @return
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("null")
	@RequestMapping(value = "/db2pg/insertCopyDataWork.do")
	 public @ResponseBody JSONObject insertCopyDataWork(@ModelAttribute("dataConfigVO") DataConfigVO dataConfigVO, HttpServletRequest request, HttpServletResponse response, @ModelAttribute("historyVO") HistoryVO historyVO) {
		JSONObject result = new JSONObject();
		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0140_03");
			historyVO.setMnu_id(41);
			accessHistoryService.insertHistory(historyVO);
			
			AES256 aes = new AES256(AES256_KEY.ENC_KEY);
			HttpSession session = request.getSession();
			LoginVO loginVo = (LoginVO) session.getAttribute("session");
			String id = loginVo.getUsr_id();

			JSONObject configObj = new JSONObject();
			
			int sourceDataWorkId = Integer.parseInt(request.getParameter("db2pg_trsf_wrk_id"));
			
			//1. WORK 등록
			String time = nowTime();
			Properties props = new Properties();
			props.load(new FileInputStream(ResourceUtils.getFile("classpath:egovframework/tcontrolProps/globals.properties")));			
			String db2pg_path = props.get("db2pg_path").toString();	
			String trans_path = db2pg_path+"/trans/"+time+"_"+dataConfigVO.getDb2pg_trsf_wrk_nm();
			
			//시퀀스 조회
			int wrk_id=db2pgSettingService.selectWorkSeq();

			dataConfigVO.setWrk_id(wrk_id);
			dataConfigVO.setFrst_regr_id(id);
			dataConfigVO.setLst_mdfr_id(id);
			dataConfigVO.setDb2pg_trsf_wrk_exp(toString(dataConfigVO.getDb2pg_trsf_wrk_exp()));
			//작업 정보등록
			db2pgSettingService.insertDb2pgWorkData(dataConfigVO);
			
			//4.T_DB2PG_Data_작업_정보 insert
			DataConfigVO sourceDataWork = (DataConfigVO) db2pgSettingService.selectDetailDataWork(sourceDataWorkId);
			DataConfigVO targetDataWork = new DataConfigVO();
			targetDataWork.setWrk_id(wrk_id);
			targetDataWork.setDb2pg_src_sys_id(sourceDataWork.getDb2pg_src_sys_id());
			targetDataWork.setDb2pg_trg_sys_id(sourceDataWork.getDb2pg_trg_sys_id());
			targetDataWork.setExrt_dat_cnt(sourceDataWork.getExrt_dat_cnt());
			targetDataWork.setDb2pg_exrt_trg_tb_wrk_id(sourceDataWork.getDb2pg_exrt_trg_tb_wrk_id());
			targetDataWork.setDb2pg_exrt_exct_tb_wrk_id(sourceDataWork.getDb2pg_exrt_exct_tb_wrk_id());
			targetDataWork.setExrt_dat_ftch_sz(sourceDataWork.getExrt_dat_ftch_sz());
			targetDataWork.setDat_ftch_bff_sz(sourceDataWork.getDat_ftch_bff_sz());
			targetDataWork.setExrt_prl_prcs_ecnt(sourceDataWork.getExrt_prl_prcs_ecnt());
			targetDataWork.setLob_dat_bff_sz(sourceDataWork.getLob_dat_bff_sz());
			targetDataWork.setUsr_qry_use_tf(sourceDataWork.getUsr_qry_use_tf());
			targetDataWork.setDb2pg_usr_qry_id(sourceDataWork.getDb2pg_usr_qry_id());
			targetDataWork.setIns_opt_cd(sourceDataWork.getIns_opt_cd());
			targetDataWork.setTb_rbl_tf(sourceDataWork.getTb_rbl_tf());
			targetDataWork.setCnst_cnd_exrt_tf(sourceDataWork.getCnst_cnd_exrt_tf());
			targetDataWork.setFrst_regr_id(id);
			targetDataWork.setLst_mdfr_id(id);
			targetDataWork.setTrans_save_pth(trans_path);
			targetDataWork.setSrc_cnd_qry(sourceDataWork.getSrc_cnd_qry());
			targetDataWork.setDb2pg_uchr_lchr_val(sourceDataWork.getDb2pg_uchr_lchr_val());
			
			int targetDataWorkId = db2pgSettingService.insertDataWork(targetDataWork);

			List<QueryVO> usrqry_result = db2pgSettingService.selectDetailUsrQry(sourceDataWorkId);
		
			int usrqryCount = usrqry_result.size();
			if(usrqryCount>0){
				configObj.put("usrqry_tf", true);
				QueryVO queryVO = new QueryVO();
				String [] usrqry_content = new String [usrqryCount];
				String [] usrqry_table = new String [usrqryCount];
				queryVO.setDb2pg_trsf_wrk_id(targetDataWorkId);
				queryVO.setFrst_regr_id(id);
				queryVO.setLst_mdfr_id(id);
				for(int i=0;i<usrqryCount;i++){
					
					usrqry_content[i] = usrqry_result.get(i).getUsr_qry_exp().toString();
					usrqry_table[i] = usrqry_result.get(i).getTar_tb_name().toString();
					queryVO.setTar_tb_name(usrqry_table[i]);
					queryVO.setUsr_qry_exp(usrqry_content[i]);
					db2pgSettingService.insertUsrQry(queryVO);
				}
				result = Db2pgConfigController.createXml(usrqry_table, usrqry_content, db2pg_path, dataConfigVO.getDb2pg_trsf_wrk_nm());
			}else{
				configObj.put("usrqry_tf", false);
			}		
			
			
			//3. config 파일 만들기
			Db2pgSysInfVO sourceDBMS = (Db2pgSysInfVO) db2pgSettingService.selectDBMS(sourceDataWork.getDb2pg_src_sys_id());
			Db2pgSysInfVO targetDBMS = (Db2pgSysInfVO) db2pgSettingService.selectDBMS(sourceDataWork.getDb2pg_trg_sys_id());
			configObj.put("path", db2pg_path);
			configObj.put("wrk_nm", dataConfigVO.getDb2pg_trsf_wrk_nm());
			configObj.put("src_host", sourceDBMS.getIpadr());
			configObj.put("src_user", sourceDBMS.getSpr_usr_id());
			configObj.put("src_password", aes.aesDecode(sourceDBMS.getPwd()));
			configObj.put("src_database", sourceDBMS.getDtb_nm());
			configObj.put("src_schema", sourceDBMS.getScm_nm());
			configObj.put("src_dbms_type", sourceDBMS.getDbms_dscd());
			configObj.put("src_port", sourceDBMS.getPortno());
			configObj.put("src_db_charset", sourceDBMS.getCrts_nm());
			configObj.put("src_include_tables", sourceDataWork.getExrt_trg_tb_nm()==null?"":sourceDataWork.getExrt_trg_tb_nm());
			configObj.put("src_exclude_tables", sourceDataWork.getExrt_exct_tb_nm()==null?"":sourceDataWork.getExrt_exct_tb_nm());
			configObj.put("src_select_on_parallel", sourceDataWork.getExrt_prl_prcs_ecnt());
			configObj.put("src_copy_segment_size", sourceDataWork.getExrt_dat_ftch_sz());
			configObj.put("src_buffer_size", sourceDataWork.getDat_ftch_bff_sz());
			configObj.put("src_lob_buffer_size", sourceDataWork.getLob_dat_bff_sz());
			configObj.put("src_rows_export", sourceDataWork.getExrt_dat_cnt());
			configObj.put("tar_host", targetDBMS.getIpadr());
			configObj.put("tar_user", targetDBMS.getSpr_usr_id());
			configObj.put("tar_password", aes.aesDecode(targetDBMS.getPwd()));
			configObj.put("tar_database", targetDBMS.getDtb_nm());
			configObj.put("tar_schema", targetDBMS.getScm_nm());
			configObj.put("tar_port", targetDBMS.getPortno());
			configObj.put("tar_db_charset", targetDBMS.getCrts_nm());
			configObj.put("tar_truncate", sourceDataWork.getIns_opt_cd());
			configObj.put("tar_constraint_rebuild", dataConfigVO.getTb_rbl_tf());
			configObj.put("tar_constraint_ddl", dataConfigVO.getCnst_cnd_exrt_tf());
			configObj.put("src_where_condition", sourceDataWork.getSrc_cnd_qry());
			configObj.put("src_file_output_path", trans_path);
			configObj.put("src_classify_string", sourceDataWork.getDb2pg_uchr_lchr_val());
			
			result = Db2pgConfigController.createDataConfig(configObj);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("resultCode", "8000000003");
		}
		return result;
	}
	
	/**
	 * MIGRATION 수정 화면을 보여준다.
	 * 
	 * @param historyVO
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/db2pg/popup/dataRegReForm.do")
	public ModelAndView dataRegReForm(HttpServletRequest request, @ModelAttribute("historyVO") HistoryVO historyVO) {
		ModelAndView mv = new ModelAndView("jsonView");
		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0142");
			historyVO.setMnu_id(41);
			accessHistoryService.insertHistory(historyVO);
			
			int db2pg_trsf_wrk_id = Integer.parseInt(request.getParameter("db2pg_trsf_wrk_id"));
			DataConfigVO result = (DataConfigVO) db2pgSettingService.selectDetailDataWork(db2pg_trsf_wrk_id);
			
			mv.addObject("db2pg_trsf_wrk_id", result.getDb2pg_trsf_wrk_id());
			mv.addObject("db2pg_trsf_wrk_nm",result.getDb2pg_trsf_wrk_nm());
			mv.addObject("db2pg_trsf_wrk_exp", result.getDb2pg_trsf_wrk_exp());
			mv.addObject("db2pg_source_system_nm",result.getSource_dbms_nm());
			mv.addObject("db2pg_trg_sys_nm",result.getTarget_dbms_nm());
			mv.addObject("db2pg_sys_id", result.getDb2pg_src_sys_id());
			mv.addObject("db2pg_trg_sys_id", result.getDb2pg_trg_sys_id());
			mv.addObject("exrt_trg_tb_cnt",result.getExrt_trg_tb_cnt());
			mv.addObject("exrt_exct_tb_cnt",result.getExrt_exct_tb_cnt());
			mv.addObject("exrt_trg_tb_nm",result.getExrt_trg_tb_nm());
			mv.addObject("exrt_exct_tb_nm",result.getExrt_exct_tb_nm());

			mv.addObject("exrt_dat_cnt",result.getExrt_dat_cnt());
			mv.addObject("exrt_dat_ftch_sz",result.getExrt_dat_ftch_sz());
			mv.addObject("dat_ftch_bff_sz",result.getDat_ftch_bff_sz());
			mv.addObject("exrt_prl_prcs_ecnt",result.getExrt_prl_prcs_ecnt());
			mv.addObject("lob_dat_bff_sz",result.getLob_dat_bff_sz());
			mv.addObject("usr_qry_use_tf",result.getUsr_qry_use_tf());
			mv.addObject("db2pg_usr_qry_id",result.getDb2pg_usr_qry_id());
			mv.addObject("ins_opt_cd",result.getIns_opt_cd());
			mv.addObject("tb_rbl_tf",String.valueOf(result.getTb_rbl_tf()).toUpperCase());
			mv.addObject("cnst_cnd_exrt_tf",String.valueOf(result.getCnst_cnd_exrt_tf()).toUpperCase());
			mv.addObject("trans_save_pth",result.getTrans_save_pth());
			mv.addObject("src_cnd_qry",result.getSrc_cnd_qry());
			mv.addObject("wrk_id",result.getWrk_id());
			mv.addObject("exrt_trg_tb_total_cnt", result.getExrt_trg_tb_total_cnt());
			mv.addObject("exrt_exct_tb_total_cnt", result.getExrt_exct_tb_total_cnt());
			mv.addObject("db2pg_uchr_lchr_val",result.getDb2pg_uchr_lchr_val());

			List<QueryVO> usrqry_result = db2pgSettingService.selectDetailUsrQry(result.getDb2pg_trsf_wrk_id());
			mv.addObject("usr_qry", usrqry_result);
			
			List<CodeVO> codeInputMode = db2pgSettingService.selectCode("TC0030");
			mv.addObject("codeInputMode", codeInputMode);
			List<CodeVO> codeTF = db2pgSettingService.selectCode("TC0029"); 
			mv.addObject("codeTF", codeTF);
			List<CodeVO> codeLetter = db2pgSettingService.selectCode("TC0028");
			mv.addObject("codeLetter", codeLetter);
		} catch (Exception e2) {
			e2.printStackTrace();
		}
		return mv;
	}
	
	/**
	 * MIGRATION WORK 수정한다.
	 * 
	 * @param dataConfigVO
	 * @param request
	 * @return
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/db2pg/updateDataWork.do")
	public @ResponseBody JSONObject updateDataWork(@ModelAttribute("dataConfigVO") DataConfigVO dataConfigVO, HttpServletRequest request, HttpServletResponse response, @ModelAttribute("historyVO") HistoryVO historyVO) {
		JSONObject result = new JSONObject();
		try{
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0142_01");
			historyVO.setMnu_id(41);
			accessHistoryService.insertHistory(historyVO);
			
			AES256 aes = new AES256(AES256_KEY.ENC_KEY);
			HttpSession session = request.getSession();
			LoginVO loginVo = (LoginVO) session.getAttribute("session");
			String id = loginVo.getUsr_id();
			
			JSONObject configObj = new JSONObject();
			SrcTableVO srctableVO = new SrcTableVO();
			srctableVO.setFrst_regr_id(id);
			int exrt_trg_tb_wrk_id =0;
			int exrt_exct_tb_wrk_id=0;
			int wrk_id = 0;
			String src_include_tables=request.getParameter("src_include_tables");
			String src_exclude_tables=request.getParameter("src_exclude_tables");
			int src_table_total_cnt = Integer.parseInt(request.getParameter("src_table_total_cnt"));
			String [] usrqry_content = request.getParameterValues("db2pg_usrqry_content");
			String [] usrqry_table = request.getParameterValues("db2pg_usrqry_table");
			
			//1. WORK 등록
			String time = nowTime();
			Properties props = new Properties();
			props.load(new FileInputStream(ResourceUtils.getFile("classpath:egovframework/tcontrolProps/globals.properties")));			
			String db2pg_path = props.get("db2pg_path").toString();	
			String trans_path = db2pg_path+"/trans/"+time+"_"+dataConfigVO.getDb2pg_trsf_wrk_nm();

			//1.T_DB2PG_추출대상소스테이블내역 insert
			if(!src_include_tables.equals("")){
				exrt_trg_tb_wrk_id=db2pgSettingService.selectExrttrgSrctblsSeq();
		    	srctableVO.setDb2pg_exrt_trg_tb_wrk_id(exrt_trg_tb_wrk_id);
		    	srctableVO.setExrt_trg_tb_nm(src_include_tables);
		    	srctableVO.setSrc_table_total_cnt(src_table_total_cnt);
				db2pgSettingService.insertExrttrgSrcTb(srctableVO);
			}
			
			//2.T_DB2PG_추출제외소스테이블내역 insert
			if(!src_exclude_tables.equals("")){
				exrt_exct_tb_wrk_id=db2pgSettingService.selectExrtexctSrctblsSeq();
		    	srctableVO.setDb2pg_exrt_exct_tb_wrk_id(exrt_exct_tb_wrk_id);
		    	srctableVO.setExrt_exct_tb_nm(src_exclude_tables);
		    	srctableVO.setSrc_table_total_cnt(src_table_total_cnt);
				db2pgSettingService.insertExrtexctSrcTb(srctableVO);
			}

			//src_cnd_qry where문절에 where, ; 문자 제거
			if(!dataConfigVO.getSrc_cnd_qry().equals("")){
				dataConfigVO.setSrc_cnd_qry(toString(dataConfigVO.getSrc_cnd_qry()));
				if(dataConfigVO.getSrc_cnd_qry().contains("WHERE")){
					dataConfigVO.setSrc_cnd_qry(dataConfigVO.getSrc_cnd_qry().replaceAll("WHERE", ""));
				}else if(dataConfigVO.getSrc_cnd_qry().contains("where")){
					dataConfigVO.setSrc_cnd_qry(dataConfigVO.getSrc_cnd_qry().replaceAll("where", ""));
				}else if(dataConfigVO.getSrc_cnd_qry().contains(";")){
					dataConfigVO.setSrc_cnd_qry(dataConfigVO.getSrc_cnd_qry().replaceAll(";", ""));
				}
			}
			
			int usr_qry_id=0;
			//4.T_DB2PG_Data_작업_정보 insert
			dataConfigVO.setLst_mdfr_id(id);
			dataConfigVO.setTrans_save_pth(trans_path);
			dataConfigVO.setDb2pg_exrt_trg_tb_wrk_id(exrt_trg_tb_wrk_id);
			dataConfigVO.setDb2pg_exrt_exct_tb_wrk_id(exrt_exct_tb_wrk_id);
			dataConfigVO.setDb2pg_usr_qry_id(usr_qry_id);
			dataConfigVO.setDb2pg_trsf_wrk_exp(toString(dataConfigVO.getDb2pg_trsf_wrk_exp()));
			
			db2pgSettingService.updateDataWork(dataConfigVO);
			
			db2pgSettingService.deleteUsrQry(dataConfigVO.getDb2pg_trsf_wrk_id());
			// User Query 입력
			if(usrqry_table.length == 1 && usrqry_table[0].equals("")){
				configObj.put("usrqry_tf", false);
			}else{
				configObj.put("usrqry_tf", true);
				QueryVO queryVO = new QueryVO();
				queryVO.setDb2pg_trsf_wrk_id(dataConfigVO.getDb2pg_trsf_wrk_id());
				queryVO.setLst_mdfr_id(id);
				for(int i=0;i<usrqry_table.length;i++){
					usrqry_content[i]=toString(usrqry_content[i]);
					usrqry_table[i]=toString(usrqry_table[i]);
					queryVO.setTar_tb_name(usrqry_table[i].toString());
					queryVO.setUsr_qry_exp(usrqry_content[i].toString());
					db2pgSettingService.insertUsrQry(queryVO);
				}
				result = Db2pgConfigController.createXml(usrqry_table, usrqry_content, db2pg_path, dataConfigVO.getDb2pg_trsf_wrk_nm());
			}

			//5. config 파일 만들기
			Db2pgSysInfVO sourceDBMS = (Db2pgSysInfVO) db2pgSettingService.selectDBMS(dataConfigVO.getDb2pg_src_sys_id());
			Db2pgSysInfVO targetDBMS = (Db2pgSysInfVO) db2pgSettingService.selectDBMS(dataConfigVO.getDb2pg_trg_sys_id());
			
			configObj.put("path", db2pg_path);
			configObj.put("wrk_nm", dataConfigVO.getDb2pg_trsf_wrk_nm());
			configObj.put("src_host", sourceDBMS.getIpadr());
			configObj.put("src_user", sourceDBMS.getSpr_usr_id());
			configObj.put("src_password", aes.aesDecode(sourceDBMS.getPwd()));
			configObj.put("src_database", sourceDBMS.getDtb_nm());
			configObj.put("src_schema", sourceDBMS.getScm_nm());
			configObj.put("src_dbms_type", sourceDBMS.getDbms_dscd());
			configObj.put("src_port", sourceDBMS.getPortno());
			configObj.put("src_db_charset", sourceDBMS.getCrts_nm());
			configObj.put("src_include_tables", src_include_tables);
			configObj.put("src_exclude_tables", src_exclude_tables);
			configObj.put("src_select_on_parallel", dataConfigVO.getExrt_prl_prcs_ecnt());
			configObj.put("src_copy_segment_size", dataConfigVO.getExrt_dat_ftch_sz());
			configObj.put("src_buffer_size", dataConfigVO.getDat_ftch_bff_sz());
			configObj.put("src_lob_buffer_size", dataConfigVO.getLob_dat_bff_sz());
			configObj.put("src_rows_export", dataConfigVO.getExrt_dat_cnt());
			configObj.put("tar_host", targetDBMS.getIpadr());
			configObj.put("tar_user", targetDBMS.getSpr_usr_id());
			configObj.put("tar_password", aes.aesDecode(targetDBMS.getPwd()));
			configObj.put("tar_database", targetDBMS.getDtb_nm());
			configObj.put("tar_schema", targetDBMS.getScm_nm());
			configObj.put("tar_port", targetDBMS.getPortno());
			configObj.put("tar_db_charset", targetDBMS.getCrts_nm());
			if(dataConfigVO.getIns_opt_cd().equals("TRUNCATE")){
				configObj.put("tar_truncate", "true");
			}else{
				configObj.put("tar_truncate", "false");
			}
			configObj.put("tar_constraint_rebuild", dataConfigVO.getTb_rbl_tf());
			configObj.put("tar_constraint_ddl", dataConfigVO.getCnst_cnd_exrt_tf());
			configObj.put("src_where_condition", dataConfigVO.getSrc_cnd_qry());
			configObj.put("src_file_output_path", trans_path);
			configObj.put("src_classify_string", dataConfigVO.getDb2pg_uchr_lchr_val());

			result = Db2pgConfigController.createDataConfig(configObj);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("resultCode", "8000000003");
		}
		return result;
	}
	
	/**
	 * MIGRATION WORK를 삭제한다.
	 * 
	 * @param historyVO
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/db2pg/deleteDataWork.do")
	public @ResponseBody JSONObject deleteDataWork(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletResponse response, HttpServletRequest request) {
		JSONObject result = new JSONObject();
		int i=0;
		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0140_02");
			historyVO.setMnu_id(41);
			accessHistoryService.insertHistory(historyVO);
			
			//DB 삭제
			String[] db2pg_trsf_wrk_id = request.getParameter("db2pg_trsf_wrk_id").toString().split(",");
			for (i = 0; i < db2pg_trsf_wrk_id.length; i++) {
				db2pgSettingService.deleteDataWork(Integer.parseInt(db2pg_trsf_wrk_id[i]));
			}
			//work 삭제
			String[] wrk_id = request.getParameter("wrk_id").toString().split(",");
			for (i = 0; i < wrk_id.length; i++) {
				backupService.deleteWork(Integer.parseInt(wrk_id[i]));
			}
			//config 파일 삭제
			Properties props = new Properties();
			props.load(new FileInputStream(ResourceUtils.getFile("classpath:egovframework/tcontrolProps/globals.properties")));			
			String db2pg_path = props.get("db2pg_path").toString();	
			String[] db2pg_trsf_wrk_nm = request.getParameter("db2pg_trsf_wrk_nm").toString().split(",");
			for (i = 0; i < db2pg_trsf_wrk_nm.length; i++) {
				result = Db2pgConfigController.deleteConfig(db2pg_trsf_wrk_nm[i],db2pg_path);
				result = Db2pgConfigController.deleteXml(db2pg_trsf_wrk_nm[i], db2pg_path);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
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
	public ModelAndView dbmsInfo(HttpServletRequest request, @ModelAttribute("historyVO") HistoryVO historyVO) {
		ModelAndView mv = new ModelAndView();
		List<Map<String, Object>> dbmsGrb;
		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0144");
			historyVO.setMnu_id(41);
			accessHistoryService.insertHistory(historyVO);
			dbmsGrb = dbmsService.dbmsListDbmsGrb();		
			mv.addObject("result", dbmsGrb);
		} catch (Exception e2) {
			e2.printStackTrace();
		}
		mv.setViewName("db2pg/popup/dbmsInfo");
		return mv;
	}

	/**
	 * DBMS시스템 등록 팝업 화면을 보여준다.(Oracle,MySQL,MsSQL)
	 * 
	 * @param historyVO
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/db2pg/popup/dbmsDDLInfo.do")
	public ModelAndView dbmsDDLInfo(HttpServletRequest request, @ModelAttribute("historyVO") HistoryVO historyVO) {
		ModelAndView mv = new ModelAndView();
		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0144");
			historyVO.setMnu_id(41);
			accessHistoryService.insertHistory(historyVO);
		} catch (Exception e2) {
			e2.printStackTrace();
		}
		mv.setViewName("db2pg/popup/dbmsDDLInfo");
		return mv;
	}
	
	/**
	 * DB2PG DBMS 시스템을 조회한다.(Oracle,MySQL,MsSQL)
	 * 
	 * @param db2pgSysInfVO
	 * @param request
	 * @return resultSet
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectDDLDb2pgDBMS.do")
	@ResponseBody
	public List<Db2pgSysInfVO> selectDDLDb2pgDBMS(@ModelAttribute("historyVO") HistoryVO historyVO, @ModelAttribute("db2pgSysInfVO") Db2pgSysInfVO db2pgSysInfVO, HttpServletResponse response, HttpServletRequest request) {
		List<Db2pgSysInfVO> result = null;
		try {
			result = dbmsService.selectDDLDb2pgDBMS(db2pgSysInfVO);
		}catch(Exception e){
			e.printStackTrace();
		}
		return result;
	}
	
	/**
	 * DBMS시스템 등록 팝업 화면을 보여준다.(PostgreSQL)
	 * 
	 * @param historyVO
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/db2pg/popup/dbmsPgInfo.do")
	public ModelAndView dbmsPgInfo(HttpServletRequest request, @ModelAttribute("historyVO") HistoryVO historyVO) {
		ModelAndView mv = new ModelAndView();
		List<Map<String, Object>> dbmsGrb;
		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0145");
			historyVO.setMnu_id(41);
			accessHistoryService.insertHistory(historyVO);
			
			dbmsGrb = dbmsService.dbmsListDbmsGrb();		
			mv.addObject("result", dbmsGrb);
		} catch (Exception e2) {
			e2.printStackTrace();
		}
		mv.setViewName("db2pg/popup/dbmsPgInfo");
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
	public ModelAndView tableInfo(HttpServletRequest request, @ModelAttribute("historyVO") HistoryVO historyVO, @ModelAttribute("db2pgSysInfVO") Db2pgSysInfVO db2pgSysInfVO) {
		ModelAndView mv = new ModelAndView("jsonView");
		List<Db2pgSysInfVO> resultSet = null;
		JSONArray jsonArray = new JSONArray();
		//테이블구분 (추출테이블 = include , 제외테이블 = exclude)
		String tableGbn = request.getParameter("tableGbn");
		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0146");
			historyVO.setMnu_id(41);
			accessHistoryService.insertHistory(historyVO);

			String[] tables = null;
			//테이블 구분에 따른 테이블 리스트저장
			if(tableGbn.equals("include")){
				System.out.println("추출테이블 리스트");
				tables = request.getParameter("src_include_table_nm").toString().split(",");
			}else{
				System.out.println("제외테이블 리스트");
				tables = request.getParameter("src_exclude_table_nm").toString().split(",");
			}
			for (int i = 0; i < tables.length; i++) {
				jsonArray.add(tables[i]);
			}

			db2pgSysInfVO.setDb2pg_sys_id(Integer.parseInt(request.getParameter("db2pg_sys_id")));
			resultSet = dbmsService.selectDb2pgDBMS(db2pgSysInfVO);
		} catch (Exception e2) {
			e2.printStackTrace();
		}
		mv.addObject("tableGbn", tableGbn);
		mv.addObject("tableList", jsonArray);
		mv.addObject("dbmsInfo", resultSet);
		return mv;
	}

	
	/**
	 * 경로가 유효한지 체크한다.(사용안함)
	 * 
	 * @param ddl_save_pth
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/db2pgPathCheck.do")
	public @ResponseBody boolean db2pgPathCheck(@RequestParam("ddl_save_pth") String ddl_save_pth) {
		boolean blnReturn = false;
		try {
			File file = new File(ddl_save_pth);
			if (file.isDirectory()) {
				blnReturn = true;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return blnReturn;
	}
	
	/**
	 * 각 DBMS 테이블 리스트 조회
	 * 
	 * @return result
	 * @throws Exception
	 */
	@RequestMapping(value="/selectTableList.do")
	public @ResponseBody JSONObject selectTableList(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		
		JSONObject result = new JSONObject();
		
		try {
		AES256 aes = new AES256(AES256_KEY.ENC_KEY);
			
		JSONObject serverObj = new JSONObject();
		String ipadr = request.getParameter("ipadr");
		String portno = request.getParameter("portno");
		String db_nm = request.getParameter("dtb_nm");
		String svr_spr_usr_id = request.getParameter("spr_usr_id");
		String svr_spr_scm_pwd = request.getParameter("pwd");
		String dbms_cd = request.getParameter("dbms_dscd");
		String table_nm = request.getParameter("table_nm");
		String scm_nm = request.getParameter("scm_nm");
		String object_type = request.getParameter("object_type");

		serverObj.put(ClientProtocolID.SERVER_NAME, ipadr);
		serverObj.put(ClientProtocolID.SERVER_IP, ipadr);
		serverObj.put(ClientProtocolID.SERVER_PORT, portno);
		serverObj.put(ClientProtocolID.DATABASE_NAME, db_nm);
		serverObj.put(ClientProtocolID.USER_ID, svr_spr_usr_id);
		serverObj.put(ClientProtocolID.USER_PWD, aes.aesDecode(svr_spr_scm_pwd));
		serverObj.put(ClientProtocolID.DB_TYPE, dbms_cd);
		serverObj.put(ClientProtocolID.TABLE_NM, table_nm);
		serverObj.put(ClientProtocolID.SCHEMA, scm_nm);
		serverObj.put(ClientProtocolID.OBJECT_TYPE, object_type);
		
		result =  DatabaseTableInfo.getTblList(serverObj);
	}catch (Exception e) {
		e.printStackTrace();
	}
		return result;
	}
	
	
	/**
	 * DB2PG 즉시실행
	 * 
	 * @return result
	 * @throws Exception
	 */
	@RequestMapping(value="/db2pg/immediateStart.do")
	public @ResponseBody Map<String, Object> db2pgImmediateStart(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) throws SQLException {
		Map<String, Object> result = null;
		Map<String, Object> param = new HashMap<String, Object>();
		
		HttpSession session = request.getSession();
		LoginVO loginVo = (LoginVO) session.getAttribute("session");
		String id = loginVo.getUsr_id();
		
		try {
		String wrk_nm = request.getParameter("wrk_nm");	
		String wrk_id = request.getParameter("wrk_id");	
		
		System.out.println(wrk_id);
			
		JSONObject obj = new JSONObject();
		obj.put("wrk_nm", wrk_nm);		
		
		//즉시실행
		result  = DB2PG_START.db2pgStart(obj);
		
		param.put("wrk_id", wrk_id);
		param.put("wrk_strt_dtm", result.get("RESULT_startTime"));
		param.put("wrk_end_dtm", result.get("RESULT_endTime"));
		
		if(result.get("RESULT").equals("SUCCESS")){
			param.put("exe_rslt_cd", "TC001701");
		}else{
			param.put("exe_rslt_cd", "TC001702");
		}
		param.put("rslt_msg", result.get("RESULT_MSG"));
		param.put("frst_regr_id", id);
		param.put("lst_mdfr_id", id);

	}catch (Exception e) {
		 result.put("RESULT", "FAIL");
		e.printStackTrace();
	}
		return result;
	}
	
	
	/**
	 * 현재시간 조회
	 * 
	 * @return String
	 * @throws Exception
	 */
	public String nowTime(){
		Calendar calendar = Calendar.getInstance();				
        java.util.Date date = calendar.getTime();
        String today = (new SimpleDateFormat("yyyyMMddHHmmss").format(date));
		return today;
	}
	
	/**
	 * Db2pg config 정보
	 * @param 
	 * @return resultSet
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/selectDb2pgConfigInfo.do")
	public @ResponseBody String selectDb2pgConfigInfo(HttpServletRequest request) {
		String result = null;
		try {
			String config_nm =request.getParameter("config_nm");
			
			Properties props = new Properties();
			props.load(new FileInputStream(ResourceUtils.getFile("classpath:egovframework/tcontrolProps/globals.properties")));			
			String db2pg_path = props.get("db2pg_path").toString();	
			String filePath = db2pg_path+"/config/"+config_nm+".config";
		    FileInputStream fileStream = null; // 파일 스트림
		    try{
		    	fileStream = new FileInputStream( filePath );// 파일 스트림 생성
		    }catch (Exception e){
				System.out.println("파일 입출력 에러 : " + e);
				return result;
			}
		    //버퍼 선언
		    byte[ ] readBuffer = new byte[fileStream.available()];
		    while (fileStream.read( readBuffer ) != -1){}
		    fileStream.close(); //스트림 닫기	
		    result=new String(readBuffer);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}	
	
	
	/**
	 * DB2PG 즉시실행
	 * 
	 * @return result
	 * @throws ParseException 
	 * @throws Exception
	 */
	@RequestMapping(value="/db2pg/ImmediateExe.do")
	public @ResponseBody Map<String, Object> ImmediateExe(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) throws SQLException, ParseException {
		
		String resultCode = "8000000003";
		String save_pth = null;
		
		Map<String, Object> result = null;
		List<DB2PG_ImmediateExe> ddlList = new ArrayList<DB2PG_ImmediateExe>();

		
		HttpSession session = request.getSession();
		LoginVO loginVo = (LoginVO) session.getAttribute("session");
		String id = loginVo.getUsr_id();
		

		String strRows = request.getParameter("datas").toString().replaceAll("&quot;", "\"");
		JSONArray rows = (JSONArray) new JSONParser().parse(strRows);
					
		// ExecuterServer 쓰레드 갯수설정
		ExecutorService executorService = Executors.newFixedThreadPool(rows.size());
		

		try {		
			
			Properties props = new Properties();
			props.load(new FileInputStream(ResourceUtils.getFile("classpath:egovframework/tcontrolProps/globals.properties")));			
			String db2pg_path = props.get("db2pg_path").toString();
			
			for(int i=0; i<rows.size(); i++){
				JSONObject obj = (JSONObject) rows.get(i);		
				
				String gbn = obj.get("gbn").toString();
				String wrk_id = obj.get("wrk_id").toString();
				String wrk_nm =obj.get("wrk_nm").toString();
				String mig_dscd =obj.get("mig_dscd").toString();
		
				// 즉시실행시, Config파일 읽어서 수정 파일저장 경로
				String time = nowTime();
			
				JSONObject DDLOutputPathChange = new JSONObject();
				String filePath = db2pg_path+"/config/"+wrk_nm+".config";

				File inputFile = new File(filePath);
				File outputFile = new File(filePath+"temp");
				FileInputStream fileInputStream = null;
				FileOutputStream fileOutputStream = null;
				
				fileInputStream = new  FileInputStream(inputFile);
				fileOutputStream = new FileOutputStream(outputFile);
								
				BufferedReader br = new BufferedReader(new InputStreamReader(fileInputStream));
				BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(fileOutputStream));
				
				
				// 즉시실행 DDL 
				if(mig_dscd.equals("TC003201")){
					String old_ddl_save_pth = obj.get("ddl_save_pth").toString();			
					save_pth = db2pg_path+"/ddl/"+time+"_"+wrk_nm;
					
					System.out.println("old_path="+old_ddl_save_pth);
					System.out.println("new="+save_pth);
					
					try{
				        String fileContent;
						while((fileContent = br.readLine()) != null) {
							fileContent = fileContent.replaceAll("SRC_FILE_OUTPUT_PATH="+old_ddl_save_pth, "SRC_FILE_OUTPUT_PATH="+save_pth);							
							bw.write(fileContent + "\r\n");
							bw.flush();
						}
						bw.close();
						br.close();

						resultCode = "0000000000";
					} catch (Exception e) {
						resultCode = "8000000003";
						e.printStackTrace();
					}	
					
					
					if(resultCode.equals("0000000000")){
						
						Map<String, Object> param = new HashMap<String, Object>();
						
						param.put("wrk_id", wrk_id);
						param.put("save_pth", save_pth);
						
						//기존 저장경로 변경
						db2pgSettingService.updateDDLSavePth(param);
						
						inputFile.delete();
						outputFile.renameTo(new File(filePath));
					}
					
					
				// 즉시실행 Migration 		
				}else{
					String old_tans_save_pth = obj.get("trans_save_pth").toString();					
					save_pth = db2pg_path+"/trans/"+time+"_"+wrk_nm;
					
					System.out.println("old_path="+old_tans_save_pth);
					System.out.println("new="+save_pth);
					
					try{
				        String fileContent;
						while((fileContent = br.readLine()) != null) {
							fileContent = fileContent.replaceAll("SRC_FILE_OUTPUT_PATH="+old_tans_save_pth, "SRC_FILE_OUTPUT_PATH="+save_pth);
							bw.write(fileContent + "\r\n");
							bw.flush();
						}
						bw.close();
						br.close();
						
						resultCode = "0000000000";
					} catch (Exception e) {
						resultCode = "8000000003";
						e.printStackTrace();
					}	
					
					if(resultCode.equals("0000000000")){
						Map<String, Object> param = new HashMap<String, Object>();
						
						param.put("wrk_id", wrk_id);
						param.put("save_pth", save_pth);
						
						//기존 저장경로 변경
						db2pgSettingService.updateTransSavePth(param);
						
						inputFile.delete();
						outputFile.renameTo(new File(filePath));
					}
					
				}

		
				// 정상적으로 Config가 변경되었을 시,
				if(resultCode.equals("0000000000")){
					
					DB2PG_ImmediateExe ddl = DB2PG_ImmediateExe.getInstance(wrk_id,wrk_nm, mig_dscd, id, gbn, save_pth);
					ddlList.add(ddl);
					
					executorService.execute(ddl);	
				}

			}
				
	}catch (Exception e) {
		e.printStackTrace();
		executorService.shutdown();
	}finally{
		executorService.shutdown();
	}
		return result;
	}
}



