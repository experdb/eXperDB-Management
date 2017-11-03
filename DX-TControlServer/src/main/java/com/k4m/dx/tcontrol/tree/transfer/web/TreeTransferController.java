package com.k4m.dx.tcontrol.tree.transfer.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.k4m.dx.tcontrol.accesscontrol.service.DbAutVO;
import com.k4m.dx.tcontrol.accesscontrol.service.DbIDbServerVO;
import com.k4m.dx.tcontrol.admin.accesshistory.service.AccessHistoryService;
import com.k4m.dx.tcontrol.admin.dbserverManager.service.DbServerVO;
import com.k4m.dx.tcontrol.admin.menuauthority.service.MenuAuthorityService;
import com.k4m.dx.tcontrol.cmmn.AES256;
import com.k4m.dx.tcontrol.cmmn.AES256_KEY;
import com.k4m.dx.tcontrol.cmmn.CmmnUtils;
import com.k4m.dx.tcontrol.cmmn.client.ClientInfoCmmn;
import com.k4m.dx.tcontrol.cmmn.client.ClientProtocolID;
import com.k4m.dx.tcontrol.common.service.AgentInfoVO;
import com.k4m.dx.tcontrol.common.service.CmmnServerInfoService;
import com.k4m.dx.tcontrol.common.service.HistoryVO;
import com.k4m.dx.tcontrol.functions.transfer.service.ConnectorVO;
import com.k4m.dx.tcontrol.functions.transfer.service.TransferService;
import com.k4m.dx.tcontrol.functions.transfer.service.TransferVO;
import com.k4m.dx.tcontrol.tree.transfer.service.BottlewaterVO;
import com.k4m.dx.tcontrol.tree.transfer.service.TblKafkaConfigVO;
import com.k4m.dx.tcontrol.tree.transfer.service.TransferDetailMappingVO;
import com.k4m.dx.tcontrol.tree.transfer.service.TransferDetailVO;
import com.k4m.dx.tcontrol.tree.transfer.service.TransferMappingVO;
import com.k4m.dx.tcontrol.tree.transfer.service.TransferRelationVO;
import com.k4m.dx.tcontrol.tree.transfer.service.TransferTargetVO;
import com.k4m.dx.tcontrol.tree.transfer.service.TreeTransferService;

/**
 * TransferSetting 컨트롤러 클래스를 정의한다.
 *
 * @author 김주영
 * @see
 * 
 *      <pre>
 * == 개정이력(Modification Information) ==
 *
 *   수정일       수정자           수정내용
 *  -------     --------    ---------------------------
 *  2017.07.24   김주영 최초 생성
 *      </pre>
 */
@Controller
public class TreeTransferController {

	@Autowired
	private AccessHistoryService accessHistoryService;

	@Autowired
	private TreeTransferService treeTransferService;

	@Autowired
	private TransferService transferService;

	@Autowired
	private CmmnServerInfoService cmmnServerInfoService;

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
	@RequestMapping(value = "/treeTransferSetting.do")
	public ModelAndView transferSetting(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		try {
			CmmnUtils cu = new CmmnUtils();
			menuAut = cu.selectMenuAut(menuAuthorityService, "MN000201");
			if (menuAut.get(0).get("read_aut_yn").equals("N")) {
				mv.setViewName("error/autError");
			} else {
				mv.addObject("read_aut_yn", menuAut.get(0).get("read_aut_yn"));
				mv.addObject("wrt_aut_yn", menuAut.get(0).get("wrt_aut_yn"));

				// 화면접근이력 이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0011");
				historyVO.setMnu_id(32);
				accessHistoryService.insertHistory(historyVO);

				mv.setViewName("transfer/transferSetting");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}

	/**
	 * 전송대상설정 화면을 보여준다.
	 * 
	 * @param
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/transferTarget.do")
	public ModelAndView transferTarget(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0015");
			historyVO.setMnu_id(33);
			accessHistoryService.insertHistory(historyVO);
			mv.addObject("cnr_id", request.getParameter("cnr_id"));
			mv.addObject("cnr_nm", request.getParameter("cnr_nm"));
			mv.setViewName("transfer/transferTarget");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}

	/**
	 * 전송대상 리스트를 조회한다.
	 * 
	 * @param request
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectTransferTarget.do")
	public @ResponseBody JSONObject selectTransferTarget(
			@ModelAttribute("transferTargetVO") TransferTargetVO transferTargetVO, HttpServletRequest request) {
		JSONObject result = new JSONObject();
		ClientInfoCmmn cic = new ClientInfoCmmn();
		try {
			HttpSession session = request.getSession();
			String usr_id = (String) session.getAttribute("usr_id");

			int cnr_id = Integer.parseInt(request.getParameter("cnr_id"));
			ConnectorVO connectInfo = (ConnectorVO) transferService.selectDetailConnectorRegister(cnr_id);

			TransferVO tengInfo = (TransferVO) transferService.selectTengInfo(usr_id);
			String IP = tengInfo.getTeng_ip();
			int PORT = tengInfo.getTeng_port();

			// strName : 공백이면 전체 검색
			String strName = "";
			JSONObject serverObj = new JSONObject();
			String strServerIp = connectInfo.getCnr_ipadr();
			String strServerPort = Integer.toString(connectInfo.getCnr_portno());
			serverObj.put(ClientProtocolID.SERVER_IP, strServerIp);
			serverObj.put(ClientProtocolID.SERVER_PORT, strServerPort);
			result = cic.kafakConnect_select(serverObj, strName, IP, PORT);

			JSONArray data = (JSONArray) result.get("data");
			for (int i = 0; i < data.size(); i++) {
				JSONObject jsonObj = (JSONObject) data.get(i);
				String name = (String) jsonObj.get("name");
				TransferDetailVO mappingInfo = (TransferDetailVO) treeTransferService.selectMappingInfo(name);
				if (mappingInfo != null) {
					jsonObj.put("db_nm", mappingInfo.getDb_nm());
					jsonObj.put("db_svr_nm", mappingInfo.getDb_svr_nm());
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;

	}

	/**
	 * 전송대상등록 팝업 화면을 보여준다.
	 * 
	 * @param
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/popup/transferTargetRegForm.do")
	public ModelAndView transferTargetRegForm(@ModelAttribute("historyVO") HistoryVO historyVO,
			HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		JSONObject result = new JSONObject();
		JSONObject serverObj = new JSONObject();
		ClientInfoCmmn cic = new ClientInfoCmmn();
		try {

			CmmnUtils.saveHistory(request, historyVO);

			HttpSession session = request.getSession();
			String usr_id = (String) session.getAttribute("usr_id");

			String act = request.getParameter("act");
			int cnr_id = Integer.parseInt(request.getParameter("cnr_id"));
			if (act.equals("i")) {
				// 화면접근이력 이력 남기기
				historyVO.setExe_dtl_cd("DX-T0016");
				historyVO.setMnu_id(33);
				accessHistoryService.insertHistory(historyVO);
			}
			if (act.equals("u")) {
				// 화면접근이력 이력 남기기
				historyVO.setExe_dtl_cd("DX-T0017");
				historyVO.setMnu_id(33);
				accessHistoryService.insertHistory(historyVO);

				ConnectorVO connectInfo = (ConnectorVO) transferService.selectDetailConnectorRegister(cnr_id);
				TransferVO tengInfo = (TransferVO) transferService.selectTengInfo(usr_id);
				String IP = tengInfo.getTeng_ip();
				int PORT = tengInfo.getTeng_port();

				String strName = request.getParameter("name");

				String strServerIp = connectInfo.getCnr_ipadr();
				String strServerPort = Integer.toString(connectInfo.getCnr_portno());
				serverObj.put(ClientProtocolID.SERVER_IP, strServerIp);
				serverObj.put(ClientProtocolID.SERVER_PORT, strServerPort);

				result = cic.kafakConnect_select(serverObj, strName, IP, PORT);
				for (int i = 0; i < result.size(); i++) {
					JSONArray data = (JSONArray) result.get("data");
					for (int m = 0; m < data.size(); m++) {
						JSONObject jsonObj = (JSONObject) data.get(m);
						JSONObject hp = (JSONObject) jsonObj.get("hp");
						String rotate_interval_ms = String.valueOf(hp.get("rotate.interval.ms"));
						String hadoop_home = (String) hp.get("hadoop.home");
						String trf_trg_url = (String) hp.get("hdfs.url");
						String topics = (String) hp.get("topics");
						String task_max = String.valueOf(hp.get("tasks.max"));
						String trf_trg_cnn_nm = (String) hp.get("name");
						String hadoop_conf_dir = (String) hp.get("hadoop.conf.dir");
						String flush_size = String.valueOf(hp.get("flush.size"));
						String connector_class = (String) hp.get("connector.class");

						mv.addObject("trf_trg_cnn_nm", trf_trg_cnn_nm);
						mv.addObject("trf_trg_url", trf_trg_url);
						mv.addObject("topics", topics);
						mv.addObject("connector_class", connector_class);
						mv.addObject("task_max", task_max);
						mv.addObject("hadoop_conf_dir", hadoop_conf_dir);
						mv.addObject("hadoop_home", hadoop_home);
						mv.addObject("flush_size", flush_size);
						mv.addObject("rotate_interval_ms", rotate_interval_ms);
					}
				}
			}
			mv.addObject("act", act);
			mv.addObject("cnr_id", cnr_id);
			mv.setViewName("popup/transferTargetRegForm");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}

	/**
	 * 커넥트명 중복 체크한다.
	 * 
	 * @param trf_trg_cnn_nm
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/transferTargetNameCheck.do")
	public @ResponseBody String transferTargetNameCheck(@RequestParam("trf_trg_cnn_nm") String trf_trg_cnn_nm) {
		try {
			int resultSet = treeTransferService.transferTargetNameCheck(trf_trg_cnn_nm);
			if (resultSet > 0) {
				// 중복값이 존재함.
				return "false";
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "true";
	}

	/**
	 * 전송대상을 등록한다.
	 * 
	 * @param transferTargetVO
	 * @param request
	 * @param historyVO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/insertTransferTarget.do")
	public @ResponseBody boolean insertTransferTarget(
			@ModelAttribute("transferTargetVO") TransferTargetVO transferTargetVO, HttpServletRequest request,
			@ModelAttribute("historyVO") HistoryVO historyVO) {
		JSONObject serverObj = new JSONObject();
		JSONObject param = new JSONObject();
		ClientInfoCmmn cic = new ClientInfoCmmn();
		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0016_01");
			historyVO.setMnu_id(33);
			accessHistoryService.insertHistory(historyVO);

			HttpSession session = request.getSession();
			String usr_id = (String) session.getAttribute("usr_id");
			transferTargetVO.setFrst_regr_id(usr_id);
			transferTargetVO.setLst_mdfr_id(usr_id);

			int cnr_id = Integer.parseInt(request.getParameter("cnr_id"));
			ConnectorVO connectInfo = (ConnectorVO) transferService.selectDetailConnectorRegister(cnr_id);
			TransferVO tengInfo = (TransferVO) transferService.selectTengInfo(usr_id);
			String IP = tengInfo.getTeng_ip();
			int PORT = tengInfo.getTeng_port();

			String strServerIp = connectInfo.getCnr_ipadr();
			String strServerPort = Integer.toString(connectInfo.getCnr_portno());
			serverObj.put(ClientProtocolID.SERVER_IP, strServerIp);
			serverObj.put(ClientProtocolID.SERVER_PORT, strServerPort);

			param.put("strName", transferTargetVO.getTrf_trg_cnn_nm());
			param.put("strConnector_class", transferTargetVO.getConnector_class());
			param.put("strTasks_max", Integer.toString(transferTargetVO.getTask_max()));
			param.put("strHdfs_url", transferTargetVO.getTrf_trg_url());
			param.put("strHadoop_conf_dir", transferTargetVO.getHadoop_conf_dir());
			param.put("strHadoop_home", transferTargetVO.getHadoop_home());
			param.put("strFlush_size", Integer.toString(transferTargetVO.getFlush_size()));
			param.put("strRotate_interval_ms", Integer.toString(transferTargetVO.getRotate_interval_ms()));

			Map<String, Object> result = cic.kafakConnect_create(serverObj, param, IP, PORT);
			String strResultCode = (String) result.get("strResultCode");
			if (strResultCode.equals("0")) {
				treeTransferService.insertTransferTarget(transferTargetVO);
				return true;
			} else {
				return false;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}

	/**
	 * 전송대상을 수정한다.
	 * 
	 * @param transferTargetVO
	 * @param request
	 * @param historyVO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/updateTransferTarget.do")
	public @ResponseBody boolean updateTransferTarget(
			@ModelAttribute("transferTargetVO") TransferTargetVO transferTargetVO, HttpServletRequest request,
			@ModelAttribute("historyVO") HistoryVO historyVO) {
		ClientInfoCmmn cic = new ClientInfoCmmn();
		JSONObject serverObj = new JSONObject();
		JSONObject param = new JSONObject();
		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0017_01");
			historyVO.setMnu_id(33);
			accessHistoryService.insertHistory(historyVO);
			int cnr_id = transferTargetVO.getCnr_id();

			HttpSession session = request.getSession();
			String usr_id = (String) session.getAttribute("usr_id");
			transferTargetVO.setFrst_regr_id(usr_id);
			transferTargetVO.setLst_mdfr_id(usr_id);
			transferTargetVO.setCnr_id(cnr_id);

			ConnectorVO connectInfo = (ConnectorVO) transferService.selectDetailConnectorRegister(cnr_id);
			TransferVO tengInfo = (TransferVO) transferService.selectTengInfo(usr_id);
			String IP = tengInfo.getTeng_ip();
			int PORT = tengInfo.getTeng_port();

			String strServerIp = connectInfo.getCnr_ipadr();
			String strServerPort = Integer.toString(connectInfo.getCnr_portno());
			serverObj.put(ClientProtocolID.SERVER_IP, strServerIp);
			serverObj.put(ClientProtocolID.SERVER_PORT, strServerPort);

			String strName = transferTargetVO.getTrf_trg_cnn_nm();

			String strConnector_class = transferTargetVO.getConnector_class();
			String strTasks_max = Integer.toString(transferTargetVO.getTask_max());
			String strHdfs_url = transferTargetVO.getTrf_trg_url();
			String strHadoop_conf_dir = transferTargetVO.getHadoop_conf_dir();
			String strHadoop_home = transferTargetVO.getHadoop_home();
			String strFlush_size = Integer.toString(transferTargetVO.getFlush_size());
			String strRotate_interval_ms = Integer.toString(transferTargetVO.getRotate_interval_ms());
			String strTopics = request.getParameter("strTopics");

			param.put("strName", strName);
			param.put("strConnector_class", strConnector_class);
			param.put("strTasks_max", strTasks_max);
			param.put("strTopics", strTopics);
			param.put("strHdfs_url", strHdfs_url);
			param.put("strHadoop_conf_dir", strHadoop_conf_dir);
			param.put("strHadoop_home", strHadoop_home);
			param.put("strFlush_size", strFlush_size);
			param.put("strRotate_interval_ms", strRotate_interval_ms);

			Map<String, Object> result = cic.kafakConnect_update(serverObj, param, IP, PORT);
			String strResultCode = (String) result.get("strResultCode");
			if (strResultCode.equals("0")) {
				treeTransferService.updateTransferTarget(transferTargetVO);
				return true;
			} else {
				return false;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}

	/**
	 * 전송대상을 삭제한다.
	 * 
	 * @param request
	 * @param historyVO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/deleteTransferTarget.do")
	public @ResponseBody boolean deleteTransferTarget(
			@ModelAttribute("transferTargetVO") TransferTargetVO transferTargetVO, HttpServletRequest request,
			@ModelAttribute("historyVO") HistoryVO historyVO) {
		ClientInfoCmmn cic = new ClientInfoCmmn();
		JSONObject serverObj = new JSONObject();

		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0015_01");
			historyVO.setMnu_id(33);
			accessHistoryService.insertHistory(historyVO);

			int cnr_id = Integer.parseInt(request.getParameter("cnr_id"));

			HttpSession session = request.getSession();
			String usr_id = (String) session.getAttribute("usr_id");
			transferTargetVO.setFrst_regr_id(usr_id);
			transferTargetVO.setLst_mdfr_id(usr_id);
			transferTargetVO.setCnr_id(cnr_id);

			ConnectorVO connectInfo = (ConnectorVO) transferService.selectDetailConnectorRegister(cnr_id);
			TransferVO tengInfo = (TransferVO) transferService.selectTengInfo(usr_id);
			String IP = tengInfo.getTeng_ip();
			int PORT = tengInfo.getTeng_port();

			String strServerIp = connectInfo.getCnr_ipadr();
			String strServerPort = Integer.toString(connectInfo.getCnr_portno());

			serverObj.put(ClientProtocolID.SERVER_IP, strServerIp);
			serverObj.put(ClientProtocolID.SERVER_PORT, strServerPort);

			String[] param = request.getParameter("name").toString().split(",");

			for (int i = 0; i < param.length; i++) {
				Map<String, Object> result = cic.kafakConnect_delete(serverObj, param[i], IP, PORT);
				String strResultCode = (String) result.get("strResultCode");
				if (strResultCode.equals("0")) {
					String trf_trg_mpp_id = treeTransferService.selectTransfermappid(param[i]);
					if (trf_trg_mpp_id != null) {
						/* 전송대상매핑관계,전송매핑테이블내역 삭제 */
						treeTransferService.deleteTransferMapping(Integer.parseInt(trf_trg_mpp_id));
						treeTransferService.deleteTransferRelation(Integer.parseInt(trf_trg_mpp_id));
					}
					/* 전송대상설정정보 삭제 */
					treeTransferService.deleteTransferTarget(param[i]);
				} else {
					return false;
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return true;
	}

	/**
	 * 전송대상상세 화면을 보여준다.
	 * 
	 * @param
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/popup/transferTargetDetailRegForm.do")
	public ModelAndView transferTargetDetail(@ModelAttribute("historyVO") HistoryVO historyVO,
			HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		JSONObject serverObj = new JSONObject();
		JSONObject result = new JSONObject();
		ClientInfoCmmn cic = new ClientInfoCmmn();
		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0018");
			historyVO.setMnu_id(33);
			accessHistoryService.insertHistory(historyVO);

			HttpSession session = request.getSession();
			String usr_id = (String) session.getAttribute("usr_id");

			int cnr_id = Integer.parseInt(request.getParameter("cnr_id"));
			ConnectorVO connectInfo = (ConnectorVO) transferService.selectDetailConnectorRegister(cnr_id);
			TransferVO tengInfo = (TransferVO) transferService.selectTengInfo(usr_id);
			String IP = tengInfo.getTeng_ip();
			int PORT = tengInfo.getTeng_port();

			String strServerIp = connectInfo.getCnr_ipadr();
			String strServerPort = Integer.toString(connectInfo.getCnr_portno());
			serverObj.put(ClientProtocolID.SERVER_IP, strServerIp);
			serverObj.put(ClientProtocolID.SERVER_PORT, strServerPort);
			String strName = request.getParameter("name");
			result = cic.kafakConnect_select(serverObj, strName, IP, PORT);
			for (int i = 0; i < result.size(); i++) {
				JSONArray data = (JSONArray) result.get("data");
				for (int m = 0; m < data.size(); m++) {
					JSONObject jsonObj = (JSONObject) data.get(m);

					JSONObject hp = (JSONObject) jsonObj.get("hp");

					String rotate_interval_ms = String.valueOf(hp.get("rotate.interval.ms"));
					String hadoop_home = (String) hp.get("hadoop.home");
					String trf_trg_url = (String) hp.get("hdfs.url");
					String topics = (String) hp.get("topics");
					String task_max = String.valueOf(hp.get("tasks.max"));
					String trf_trg_cnn_nm = (String) hp.get("name");
					String hadoop_conf_dir = (String) hp.get("hadoop.conf.dir");
					String flush_size = String.valueOf(hp.get("flush.size"));
					String connector_class = (String) hp.get("connector.class");

					mv.addObject("rotate_interval_ms", rotate_interval_ms);
					mv.addObject("hadoop_home", hadoop_home);
					mv.addObject("trf_trg_url", trf_trg_url);
					mv.addObject("topics", topics);
					mv.addObject("task_max", task_max);
					mv.addObject("trf_trg_cnn_nm", trf_trg_cnn_nm);
					mv.addObject("hadoop_conf_dir", hadoop_conf_dir);
					mv.addObject("flush_size", flush_size);
					mv.addObject("connector_class", connector_class);
				}
			}
			mv.addObject("connector_type", connectInfo.getCnr_cnn_tp_cd());
			mv.setViewName("popup/transferTargetDetailRegForm");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}

	/**
	 * 전송 관리 화면을 보여준다.
	 * 
	 * @param
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/transferDetail.do")
	public ModelAndView transferDetail(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0019");
			historyVO.setMnu_id(34);
			accessHistoryService.insertHistory(historyVO);

			mv.addObject("cnr_id", request.getParameter("cnr_id"));
			mv.addObject("cnr_nm", request.getParameter("cnr_nm"));
			mv.setViewName("transfer/transferDetail");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}

	/**
	 * 전송관리 리스트를 조회한다.
	 * 
	 * @return resultSet
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectTransferDetail.do")
	public @ResponseBody List<TransferDetailVO> selectTransferDetail(
			@ModelAttribute("transferDetailVO") TransferDetailVO transferDetailVO, HttpServletRequest request) {
		List<TransferDetailVO> resultSet = null;
		try {
			transferDetailVO.setCnr_id(Integer.parseInt(request.getParameter("cnr_id")));
			resultSet = treeTransferService.selectTransferDetail(transferDetailVO);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return resultSet;

	}

	/**
	 * Database 매핑작업 팝업 화면을 보여준다.
	 * 
	 * @param
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/popup/transferMappingRegForm.do")
	public ModelAndView transferMappingRegForm(@ModelAttribute("dbServerVO") DbServerVO dbServerVO,@ModelAttribute("historyVO") HistoryVO historyVO,
			HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		List<DbServerVO> resultSet = null;
		List<TransferDetailMappingVO> result = null;
		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0020");
			historyVO.setMnu_id(34);
			accessHistoryService.insertHistory(historyVO);

			int trf_trg_id = treeTransferService.selectTrftrgid(request.getParameter("trf_trg_cnn_nm"));

			// 전송매핑테이블내역 조회
			result = treeTransferService.selectTransferMapping(trf_trg_id);
			if (result.size() > 0) {
				mv.addObject("result", result);
			}
			resultSet = treeTransferService.selectDbServerList(dbServerVO);
			mv.addObject("resultSet", resultSet);
			mv.addObject("trf_trg_id", trf_trg_id);
			mv.addObject("cnr_id", request.getParameter("cnr_id"));
			mv.addObject("trf_trg_cnn_nm", request.getParameter("trf_trg_cnn_nm"));
			mv.setViewName("popup/transferMappingRegForm");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}

	/**
	 * DB를 조회한다.
	 * 
	 * @param dbIDbServerVO
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectServerDbLists.do")
	public @ResponseBody List<DbIDbServerVO> selectServerDbLists(
			HttpServletRequest request,@ModelAttribute("dbAutVO") DbAutVO dbAutVO) {
		List<DbIDbServerVO> resultSet = null;
		try {
			dbAutVO.setDb_svr_nm(request.getParameter("db_svr_nm"));
			HttpSession session = request.getSession();
			dbAutVO.setUsr_id((String) session.getAttribute("usr_id"));

			resultSet = treeTransferService.selectServerDbList(dbAutVO);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return resultSet;

	}

	/**
	 * 테이블 리스트를 조회한다.
	 * 
	 * @param dbIDbServerVO
	 * @param request
	 * @return
	 * @return
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectMappingTableList.do")
	public @ResponseBody Map<String, Object> selectMappingTableList(HttpServletRequest request) {
		JSONObject serverObj = new JSONObject();
		ClientInfoCmmn cic = new ClientInfoCmmn();
		Map<String, Object> result = new HashMap<String, Object>();
		try {
			AES256 dec = new AES256(AES256_KEY.ENC_KEY);

			int db_id = Integer.parseInt(request.getParameter("db_id"));
			DbIDbServerVO dbIDbServerVO = (DbIDbServerVO) treeTransferService.selectServerDb(db_id);

			AgentInfoVO vo = new AgentInfoVO();
			vo.setIPADR(dbIDbServerVO.getIpadr());
			AgentInfoVO agentInfo = (AgentInfoVO) cmmnServerInfoService.selectAgentInfo(vo);

			if (agentInfo == null) {
				return result;
			} else if (agentInfo.getAGT_CNDT_CD().equals("TC001102")) {
				return result;
			} else {
				String IP = dbIDbServerVO.getIpadr();
				int PORT = agentInfo.getSOCKET_PORT();

				serverObj.put(ClientProtocolID.SERVER_NAME, dbIDbServerVO.getDb_svr_nm());
				serverObj.put(ClientProtocolID.SERVER_IP, dbIDbServerVO.getIpadr());
				serverObj.put(ClientProtocolID.SERVER_PORT, dbIDbServerVO.getPortno());
				serverObj.put(ClientProtocolID.DATABASE_NAME, dbIDbServerVO.getDb_nm());
				serverObj.put(ClientProtocolID.USER_ID, dbIDbServerVO.getSvr_spr_usr_id());
				serverObj.put(ClientProtocolID.USER_PWD, dec.aesDecode(dbIDbServerVO.getSvr_spr_scm_pwd()));
				
				String strExtname = "bottledwater";
				List<Object> extensionResult = cic.extension_select(serverObj, IP, PORT, strExtname);
				if(extensionResult.size()==0){
					result.put("bottledwater", "bottledwater");
					return result;
				}else{
					result = cic.tableList_select(serverObj, IP, PORT);
				}			
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	/**
	 * 전송매핑작업을 등록한다.
	 * 
	 * @param transferRelationVO
	 * @param transferMappingVO
	 * @param request
	 * @param historyVO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/insertTransferMapping.do")
	public @ResponseBody void insertTransferMapping(
			@ModelAttribute("transferRelationVO") TransferRelationVO transferRelationVO,
			@ModelAttribute("transferMappingVO") TransferMappingVO transferMappingVO, HttpServletRequest request,
			@ModelAttribute("historyVO") HistoryVO historyVO) {
		JSONObject result = new JSONObject();
		JSONObject param = new JSONObject();
		ClientInfoCmmn cic = new ClientInfoCmmn();
		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0020_01");
			historyVO.setMnu_id(34);
			accessHistoryService.insertHistory(historyVO);

			HttpSession session = request.getSession();
			String usr_id = (String) session.getAttribute("usr_id");
			transferRelationVO.setFrst_regr_id(usr_id);
			transferRelationVO.setLst_mdfr_id(usr_id);
			transferMappingVO.setFrst_regr_id(usr_id);
			transferMappingVO.setLst_mdfr_id(usr_id);

			transferRelationVO.setTrf_trg_id(Integer.parseInt(request.getParameter("trf_trg_id")));
			transferRelationVO.setCnr_id(Integer.parseInt(request.getParameter("cnr_id")));
			transferRelationVO.setDb_id(Integer.parseInt(request.getParameter("db_id")));

			/* 전송매핑테이블내역 DELETE */
			treeTransferService.deleteTransferMapping(Integer.parseInt(request.getParameter("trf_trg_mpp_id")));
			/* 전송대상매핑관계 DELETE */
			treeTransferService.deleteTransferRelation(Integer.parseInt(request.getParameter("trf_trg_mpp_id")));
			/* 전송대상매핑관계 INSERT */
			treeTransferService.insertTransferRelation(transferRelationVO);

			JSONParser jParser = new JSONParser();
			JSONArray jArr = (JSONArray) jParser.parse(request.getParameter("rowList").toString().replace("&quot;", "\""));
			String trf_trg_cnn_nm = request.getParameter("trf_trg_cnn_nm");
			String topic = "";
			for (int i = 0; i < jArr.size(); i++) {
				JSONObject jObj = (JSONObject) jArr.get(i);
				String table_name = (String) jObj.get("table_name");
				String table_schema = (String) jObj.get("table_schema");

				transferMappingVO.setTb_engl_nm(table_name);
				transferMappingVO.setScm_nm(table_schema);

				/* 전송매핑테이블내역 INSERT */
				treeTransferService.insertTransferMapping(transferMappingVO);

				if (i != jArr.size() - 1) {
					topic += ",";
				}

				if (table_schema.equals("public")) {
					topic += trf_trg_cnn_nm + "." + table_name;
				} else {
					topic += trf_trg_cnn_nm + "." + table_schema + "." + table_name;
				}

			}

			ConnectorVO connectInfo = (ConnectorVO) transferService.selectDetailConnectorRegister(Integer.parseInt(request.getParameter("cnr_id")));

			TransferVO tengInfo = (TransferVO) transferService.selectTengInfo(usr_id);
			String IP = tengInfo.getTeng_ip();
			int PORT = tengInfo.getTeng_port();

			JSONObject serverObj = new JSONObject();
			String strServerIp = connectInfo.getCnr_ipadr();
			String strServerPort = Integer.toString(connectInfo.getCnr_portno());
			serverObj.put(ClientProtocolID.SERVER_IP, strServerIp);
			serverObj.put(ClientProtocolID.SERVER_PORT, strServerPort);
			result = cic.kafakConnect_select(serverObj, trf_trg_cnn_nm, IP, PORT);
			for (int i = 0; i < result.size(); i++) {
				JSONArray data = (JSONArray) result.get("data");
				for (int m = 0; m < data.size(); m++) {
					JSONObject jsonObj = (JSONObject) data.get(m);
					JSONObject hp = (JSONObject) jsonObj.get("hp");

					param.put("strName", (String) hp.get("name"));
					param.put("strConnector_class", (String) hp.get("connector.class"));
					param.put("strTasks_max", (String) hp.get("tasks.max"));
					param.put("strTopics", topic);
					param.put("strHdfs_url", (String) hp.get("hdfs.url"));
					param.put("strHadoop_conf_dir", (String) hp.get("hadoop.conf.dir"));
					param.put("strHadoop_home", (String) hp.get("hadoop.home"));
					param.put("strFlush_size", (String) hp.get("flush.size"));
					param.put("strRotate_interval_ms", (String) hp.get("rotate.interval.ms"));
				}
			}
			/* kafakConnect_update topic 업데이트 */
			cic.kafakConnect_update(serverObj, param, IP, PORT);

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * bottlewater를 제어한다.
	 * 
	 * @param historyVO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/bottlewaterControl.do")
	public @ResponseBody String bottlewaterControl(@ModelAttribute("historyVO") HistoryVO historyVO,
			@ModelAttribute("transferDetailVO") TransferDetailVO transferDetailVO, HttpServletRequest request) {
		ClientInfoCmmn cic = new ClientInfoCmmn();
		JSONObject result = new JSONObject();
		JSONObject param = new JSONObject();
		try {
			/*
			 * 실행순서 
			 * 1. bottlewater 실행 및 중지 bw_pid가 0이면 -> 실행 
			 * 1-1.tbl_mapps DELETE
			 * 1-2.kafka_con_config DELETE 
			 * 1-3.tbl_mapps INSERT
			 * 1-4.kafka_con_config INSERT 
			 * 1-5.bottledwater_start 
			 * 1-6.bw_pid update(1)
			 * bw_pid가 0이 아니면-> 중지 
			 * 1-1.bottledwater_end 
			 * 1-2.bw_pid update(0)
			 */
			AES256 dec = new AES256(AES256_KEY.ENC_KEY);

			HttpSession session = request.getSession();
			String usr_id = (String) session.getAttribute("usr_id");

			int trf_trg_id = Integer.parseInt(request.getParameter("trf_trg_id"));
			int current_bw_pid = Integer.parseInt(request.getParameter("bw_pid"));

			int db_id = Integer.parseInt(request.getParameter("db_id"));
			DbIDbServerVO dbIDbServerVO = (DbIDbServerVO) treeTransferService.selectServerDb(db_id);
			String strIpAdr = dbIDbServerVO.getIpadr();
			AgentInfoVO vo = new AgentInfoVO();
			vo.setIPADR(strIpAdr);
			AgentInfoVO agentInfo = (AgentInfoVO) cmmnServerInfoService.selectAgentInfo(vo);

			/* agent 미설치일 경우 */
			if (agentInfo == null) {
				return "false";
			}

			JSONObject serverObj = new JSONObject();
			serverObj.put(ClientProtocolID.SERVER_NAME, dbIDbServerVO.getDb_svr_nm());
			serverObj.put(ClientProtocolID.SERVER_IP, dbIDbServerVO.getIpadr());
			serverObj.put(ClientProtocolID.SERVER_PORT, dbIDbServerVO.getPortno());
			serverObj.put(ClientProtocolID.DATABASE_NAME, dbIDbServerVO.getDb_nm());
			serverObj.put(ClientProtocolID.USER_ID, dbIDbServerVO.getSvr_spr_usr_id());
			serverObj.put(ClientProtocolID.USER_PWD, dec.aesDecode(dbIDbServerVO.getSvr_spr_scm_pwd()));

			String IP = dbIDbServerVO.getIpadr();
			int PORT = agentInfo.getSOCKET_PORT();

			if (current_bw_pid == 0) {
				// 화면접근이력 이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0019_01");
				historyVO.setMnu_id(34);
				accessHistoryService.insertHistory(historyVO);

				TransferVO transferInfo = (TransferVO) transferService.selectTransferSetting(usr_id);
				List<BottlewaterVO> dbInfo = treeTransferService.selectBottlewaterinfo(trf_trg_id);

				/* 전송설정등록을 안했을 경우 */
				if (transferInfo == null) {
					return "transfersetting";
				}

				List<TblKafkaConfigVO> tblKafkaConfigInfo = treeTransferService.selectTblKafkaConfigInfo(trf_trg_id);
				String trf_trg_cnn_nm = tblKafkaConfigInfo.get(0).getTrf_trg_cnn_nm();

				/* kafka_con_config DELETE */
				JSONObject tableInfoObj = new JSONObject();
				tableInfoObj.put(ClientProtocolID.DATABASE_NAME, dbIDbServerVO.getDb_nm());
				tableInfoObj.put(ClientProtocolID.CONNECT_NAME, trf_trg_cnn_nm);
				cic.kafkaConConfig_delete(IP, PORT, serverObj, tableInfoObj);

				String topicKafkaConfig = "";
				for (int i = 0; i < tblKafkaConfigInfo.size(); i++) {
					ArrayList<HashMap<String, String>> arrTableInfos = new ArrayList<HashMap<String, String>>();
					HashMap hps = new HashMap();
					hps.put(ClientProtocolID.DATABASE_NAME, dbIDbServerVO.getDb_nm());
					hps.put(ClientProtocolID.TABLE_NAME, tblKafkaConfigInfo.get(i).getTb_engl_nm());
					hps.put(ClientProtocolID.TABLE_SCHEMA, tblKafkaConfigInfo.get(i).getScm_nm());
					arrTableInfos.add(hps);
					int tblmappsSize = cic.tblmapps_select(IP, PORT, serverObj, arrTableInfos);
					String topic = "";
					if (tblKafkaConfigInfo.get(i).getScm_nm().equals("public")) {
						topic += tblKafkaConfigInfo.get(i).getTrf_trg_cnn_nm() + "."
								+ tblKafkaConfigInfo.get(i).getTb_engl_nm();
						topicKafkaConfig += topic;
					} else {
						topic += tblKafkaConfigInfo.get(i).getTrf_trg_cnn_nm() + "."
								+ tblKafkaConfigInfo.get(i).getScm_nm() + "."
								+ tblKafkaConfigInfo.get(i).getTb_engl_nm();
						topicKafkaConfig += topic;
					}
					if (i != tblKafkaConfigInfo.size() - 1) {
						topicKafkaConfig += ",";
					}
					if (tblmappsSize == 0) {
						/* tbl_mapps INSERT */
						ArrayList<HashMap<String, String>> arrTableInfo = new ArrayList<HashMap<String, String>>();
						HashMap hp = new HashMap();
						hp.put(ClientProtocolID.DATABASE_NAME, dbIDbServerVO.getDb_nm());
						hp.put(ClientProtocolID.TABLE_NAME, tblKafkaConfigInfo.get(i).getTb_engl_nm());
						hp.put(ClientProtocolID.TABLE_SCHEMA, tblKafkaConfigInfo.get(i).getScm_nm());
						hp.put(ClientProtocolID.TOPIC_NAME, topic);
						hp.put(ClientProtocolID.REMARK, "1");
						arrTableInfo.add(hp);
						cic.tblmapps_insert(IP, PORT, serverObj, arrTableInfo);
					}
				}

				JSONObject kafkaServerObj = new JSONObject();
				String strServerIp = tblKafkaConfigInfo.get(0).getCnr_ipadr();
				String strServerPort = Integer.toString(tblKafkaConfigInfo.get(0).getCnr_portno());
				kafkaServerObj.put(ClientProtocolID.SERVER_IP, strServerIp);
				kafkaServerObj.put(ClientProtocolID.SERVER_PORT, strServerPort);
				result = cic.kafakConnect_select(kafkaServerObj, trf_trg_cnn_nm, IP, PORT);
				for (int i = 0; i < result.size(); i++) {
					JSONArray data = (JSONArray) result.get("data");
					for (int m = 0; m < data.size(); m++) {
						JSONObject jsonObj = (JSONObject) data.get(m);
						JSONObject hp = (JSONObject) jsonObj.get("hp");

						param.put("strName", (String) hp.get("name"));
						param.put("strConnector_class", (String) hp.get("connector.class"));
						param.put("strTasks_max", (String) hp.get("tasks.max"));
						param.put("strTopics", topicKafkaConfig);
						param.put("strHdfs_url", (String) hp.get("hdfs.url"));
						param.put("strHadoop_conf_dir", (String) hp.get("hadoop.conf.dir"));
						param.put("strHadoop_home", (String) hp.get("hadoop.home"));
						param.put("strFlush_size", (String) hp.get("flush.size"));
						param.put("strRotate_interval_ms", (String) hp.get("rotate.interval.ms"));
					}
				}

				/* kafka_con_config INSERT */
				tableInfoObj = new JSONObject();
				tableInfoObj.put(ClientProtocolID.DATABASE_NAME, dbIDbServerVO.getDb_nm());
				tableInfoObj.put(ClientProtocolID.CONNECT_NAME, trf_trg_cnn_nm);
				tableInfoObj.put(ClientProtocolID.CONTENTS, param.toJSONString());
				tableInfoObj.put(ClientProtocolID.REMARK, "1");

				cic.kafkaConConfig_insert(IP, PORT, serverObj, tableInfoObj);

				String dbinfoTxt = " --postgres=postgres://" + dbInfo.get(0).getSvr_spr_usr_id() + ":"
						+ dec.aesDecode(dbInfo.get(0).getSvr_spr_scm_pwd()) + "@" + dbInfo.get(0).getIpadr() + ":"
						+ dbInfo.get(0).getPortno() + "/" + dbInfo.get(0).getDb_nm();

				/* bottlewater실행 명령어 */
				String strExecTxt = "nohup " + transferInfo.getBw_home() + dbinfoTxt + " --slot="
						+ dbInfo.get(0).getTrf_trg_cnn_nm() + " --broker=" + transferInfo.getKafka_broker_ip() + ":"
						+ transferInfo.getKafka_broker_port() + " --schema-registry="
						+ transferInfo.getSchema_registry_ip() + ":" + transferInfo.getSchema_registry_port()
						+ " --topic-prefix=" + dbInfo.get(0).getTrf_trg_cnn_nm()
						+ " --skip-snapshot --allow-unkeyed --on-error=log &";
				System.out.println("명령어 : " + strExecTxt);

				String string_trf_trg_id = request.getParameter("trf_trg_id");
				cic.bottledwater_start(IP, PORT, strExecTxt, string_trf_trg_id);

				/* bwpid 업데이트 실행 -> 1 중지 -> 0 */
				int bw_pid = 1;
				transferDetailVO.setBw_pid(bw_pid);
				transferDetailVO.setLst_mdfr_id(usr_id);
				transferDetailVO.setTrf_trg_id(trf_trg_id);
				treeTransferService.updateBottleWaterBwpid(transferDetailVO);

				return "start";
			} else {
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0019_02");
				historyVO.setMnu_id(34);
				accessHistoryService.insertHistory(historyVO);

				List<TblKafkaConfigVO> tblKafkaConfigInfo = treeTransferService.selectTblKafkaConfigInfo(trf_trg_id);
				String strExecTxt = tblKafkaConfigInfo.get(0).getTrf_trg_cnn_nm();
				/* string_trf_trg_id 할필요 없음! */
				String string_trf_trg_id = "0";
				cic.bottledwater_end(IP, PORT, strExecTxt, string_trf_trg_id, serverObj);

				/* bwpid 업데이트 실행 -> 1 중지 -> 0 */
				int bw_pid = 0;
				transferDetailVO.setBw_pid(bw_pid);
				transferDetailVO.setLst_mdfr_id(usr_id);
				transferDetailVO.setTrf_trg_id(trf_trg_id);
				treeTransferService.updateBottleWaterBwpid(transferDetailVO);

				return "stop";
			}

		} catch (Exception e) {
			return "false";
		}
	}
}
