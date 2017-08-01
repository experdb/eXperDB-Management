package com.k4m.dx.tcontrol.tree.transfer.web;

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

import com.k4m.dx.tcontrol.accesscontrol.service.DbIDbServerVO;
import com.k4m.dx.tcontrol.admin.accesshistory.service.AccessHistoryService;
import com.k4m.dx.tcontrol.admin.dbserverManager.service.DbServerManagerService;
import com.k4m.dx.tcontrol.admin.dbserverManager.service.DbServerVO;
import com.k4m.dx.tcontrol.cmmn.AES256;
import com.k4m.dx.tcontrol.cmmn.AES256_KEY;
import com.k4m.dx.tcontrol.cmmn.CmmnUtils;
import com.k4m.dx.tcontrol.cmmn.client.ClientInfoCmmn;
import com.k4m.dx.tcontrol.cmmn.client.ClientProtocolID;
import com.k4m.dx.tcontrol.common.service.HistoryVO;
import com.k4m.dx.tcontrol.functions.transfer.service.ConnectorVO;
import com.k4m.dx.tcontrol.functions.transfer.service.TransferService;
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
	private DbServerManagerService dbServerManagerService;
	
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
			// 전송대상리스트 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0014");
			accessHistoryService.insertHistory(historyVO);
			mv.addObject("cnr_id",request.getParameter("cnr_id"));
			mv.addObject("cnr_nm",request.getParameter("cnr_nm"));
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
	public @ResponseBody JSONObject selectTransferTarget(@ModelAttribute("transferTargetVO") TransferTargetVO transferTargetVO,HttpServletRequest request) {
		JSONObject result = new JSONObject();
		List<ConnectorVO> resultList = null;
		
		try {
			int cnr_id = Integer.parseInt(request.getParameter("cnr_id"));
			resultList = transferService.selectDetailConnectorRegister(cnr_id);
			
			//strName : 공백이면 전체 검색
			String strName = "";
			
			JSONObject serverObj = new JSONObject();
			
			String strServerIp = resultList.get(0).getCnr_ipadr();
			String strServerPort = Integer.toString(resultList.get(0).getCnr_portno());
			
			serverObj.put(ClientProtocolID.SERVER_IP, strServerIp);
			serverObj.put(ClientProtocolID.SERVER_PORT, strServerPort);
			ClientInfoCmmn cic = new ClientInfoCmmn();
			result = cic.kafakConnect_select(serverObj,strName);	
			
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
	public ModelAndView transferTargetRegForm(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		JSONObject result = new JSONObject();
		List<ConnectorVO> resultList = null;
		
		try {
			
			CmmnUtils.saveHistory(request, historyVO);
		
			String act = request.getParameter("act");
			int cnr_id = Integer.parseInt(request.getParameter("cnr_id"));
			if(act.equals("i")){
				// 전송대상등록팝업 이력 남기기
				historyVO.setExe_dtl_cd("DX-T0015");
				accessHistoryService.insertHistory(historyVO);					
			}
			if(act.equals("u")){
				// 전송대상수정팝업 이력 남기기
				historyVO.setExe_dtl_cd("DX-T0015_01");
				accessHistoryService.insertHistory(historyVO);
				
				resultList = transferService.selectDetailConnectorRegister(cnr_id);
				
				String strName = request.getParameter("name");
				JSONObject serverObj = new JSONObject();
				String strServerIp = resultList.get(0).getCnr_ipadr();
				String strServerPort = Integer.toString(resultList.get(0).getCnr_portno());
				
				serverObj.put(ClientProtocolID.SERVER_IP, strServerIp);
				serverObj.put(ClientProtocolID.SERVER_PORT, strServerPort);
				ClientInfoCmmn cic = new ClientInfoCmmn();
				result = cic.kafakConnect_select(serverObj,strName);
				
				for(int i=0; i<result.size(); i++){
					JSONArray data = (JSONArray)result.get("data");
					for(int m=0; m<data.size(); m++){
						JSONObject jsonObj = (JSONObject)data.get(m);
						
						JSONObject hp = (JSONObject) jsonObj.get("hp");
						int rotate_interval_ms = Integer.parseInt((String) hp.get("rotate.interval.ms"));
						String hadoop_home = (String) hp.get("hadoop.home");
						String trf_trg_url = (String) hp.get("hdfs.url");
						String topics = (String) hp.get("topics");
						int task_max = Integer.parseInt((String) hp.get("tasks.max"));
						String trf_trg_cnn_nm = (String) hp.get("name");
						String hadoop_conf_dir = (String) hp.get("hadoop.conf.dir");
						int flush_size = Integer.parseInt((String) hp.get("flush.size"));
						String connector_class = (String) hp.get("connector.class");
						
						mv.addObject("trf_trg_cnn_nm",trf_trg_cnn_nm);
						mv.addObject("trf_trg_url",trf_trg_url);
						mv.addObject("topics",topics);
						mv.addObject("connector_class",connector_class);
						mv.addObject("task_max",task_max);
						mv.addObject("hadoop_conf_dir",hadoop_conf_dir);
						mv.addObject("hadoop_home",hadoop_home);
						mv.addObject("flush_size",flush_size);
						mv.addObject("rotate_interval_ms",rotate_interval_ms);		
					}							
				}	
									
			}
			mv.addObject("act",act);
			mv.addObject("cnr_id",cnr_id);
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
	public @ResponseBody void insertTransferTarget(@ModelAttribute("transferTargetVO") TransferTargetVO transferTargetVO, HttpServletRequest request, @ModelAttribute("historyVO") HistoryVO historyVO) {
		List<ConnectorVO> resultList = null;
		JSONObject serverObj = new JSONObject();
		JSONObject param = new JSONObject();
		ClientInfoCmmn cic = new ClientInfoCmmn();
		try {		
			// 전송대상 등록 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0014_02");
			accessHistoryService.insertHistory(historyVO);
					
			HttpSession session = request.getSession();
			String usr_id = (String)session.getAttribute("usr_id");
			transferTargetVO.setFrst_regr_id(usr_id);
			transferTargetVO.setLst_mdfr_id(usr_id);
			treeTransferService.insertTransferTarget(transferTargetVO);
			
			int cnr_id = Integer.parseInt(request.getParameter("cnr_id"));			
			resultList = transferService.selectDetailConnectorRegister(cnr_id);
			
			String strServerIp = resultList.get(0).getCnr_ipadr();
			String strServerPort = Integer.toString(resultList.get(0).getCnr_portno());
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
		
			cic.kafakConnect_create(serverObj,param);
		} catch (Exception e) {
			e.printStackTrace();
		}
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
	public @ResponseBody void updateTransferTarget(@ModelAttribute("transferTargetVO") TransferTargetVO transferTargetVO, HttpServletRequest request, @ModelAttribute("historyVO") HistoryVO historyVO) {
		ClientInfoCmmn cic = new ClientInfoCmmn();
		JSONObject serverObj = new JSONObject();
		JSONObject param = new JSONObject();
		List<ConnectorVO> resultList = null;
		try {		
			// 전송대상 수정 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0014_03");
			accessHistoryService.insertHistory(historyVO);
			int cnr_id = transferTargetVO.getCnr_id();
			
			HttpSession session = request.getSession();
			String usr_id = (String)session.getAttribute("usr_id");
			transferTargetVO.setFrst_regr_id(usr_id);
			transferTargetVO.setLst_mdfr_id(usr_id);
			transferTargetVO.setCnr_id(cnr_id);
			
			treeTransferService.updateTransferTarget(transferTargetVO);
			
			resultList = transferService.selectDetailConnectorRegister(cnr_id);
			
			String strServerIp = resultList.get(0).getCnr_ipadr();
			String strServerPort = Integer.toString(resultList.get(0).getCnr_portno());
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
			
			cic.kafakConnect_update(serverObj,param);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
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
	public @ResponseBody boolean deleteTransferTarget(@ModelAttribute("transferTargetVO") TransferTargetVO transferTargetVO,HttpServletRequest request, @ModelAttribute("historyVO") HistoryVO historyVO) {
		ClientInfoCmmn cic = new ClientInfoCmmn();
		JSONObject serverObj = new JSONObject();
		List<ConnectorVO> resultList = null;
		
		try {		
			// 전송대상 삭제 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0014_04");
			accessHistoryService.insertHistory(historyVO);
			
			int cnr_id = Integer.parseInt(request.getParameter("cnr_id"));
			
			HttpSession session = request.getSession();
			String usr_id = (String)session.getAttribute("usr_id");
			transferTargetVO.setFrst_regr_id(usr_id);
			transferTargetVO.setLst_mdfr_id(usr_id);
			transferTargetVO.setCnr_id(cnr_id);
			
			resultList = transferService.selectDetailConnectorRegister(cnr_id);
			
			String strServerIp = resultList.get(0).getCnr_ipadr();
			String strServerPort = Integer.toString(resultList.get(0).getCnr_portno());
					
			serverObj.put(ClientProtocolID.SERVER_IP, strServerIp);
			serverObj.put(ClientProtocolID.SERVER_PORT, strServerPort);

			String[] param = request.getParameter("name").toString().split(",");
			for (int i = 0; i < param.length; i++) {
				cic.kafakConnect_delete(serverObj,param[i]);
				treeTransferService.deleteTransferTarget(param[i]);
			}				
		return true;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}
	
	/**
	 * 전송대상상세 화면을 보여준다.
	 * 
	 * @param
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/popup/transferTargetDetailRegForm.do")
	public ModelAndView transferTargetDetail(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		List<ConnectorVO> resultList = null;
		JSONObject serverObj = new JSONObject();
		JSONObject result = new JSONObject();
		ClientInfoCmmn cic = new ClientInfoCmmn();
		try {
			// 전송설정 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0016");
			accessHistoryService.insertHistory(historyVO);
			
			int cnr_id = Integer.parseInt(request.getParameter("cnr_id"));
			resultList = transferService.selectDetailConnectorRegister(cnr_id);

			String strServerIp = resultList.get(0).getCnr_ipadr();
			String strServerPort = Integer.toString(resultList.get(0).getCnr_portno());
			serverObj.put(ClientProtocolID.SERVER_IP, strServerIp);
			serverObj.put(ClientProtocolID.SERVER_PORT, strServerPort);
			String strName = request.getParameter("name");
			result = cic.kafakConnect_select(serverObj,strName);
			for(int i=0; i<result.size(); i++){
				JSONArray data = (JSONArray)result.get("data");
				for(int m=0; m<data.size(); m++){
					JSONObject jsonObj = (JSONObject)data.get(m);
					
					JSONObject hp = (JSONObject) jsonObj.get("hp");
					int rotate_interval_ms = Integer.parseInt((String) hp.get("rotate.interval.ms"));
					String hadoop_home = (String) hp.get("hadoop.home");
					String trf_trg_url = (String) hp.get("hdfs.url");
					String topics = (String) hp.get("topics");
					int task_max = Integer.parseInt((String) hp.get("tasks.max"));
					String trf_trg_cnn_nm = (String) hp.get("name");
					String hadoop_conf_dir = (String) hp.get("hadoop.conf.dir");
					int flush_size = Integer.parseInt((String) hp.get("flush.size"));
					String connector_class = (String) hp.get("connector.class");
					
					mv.addObject("rotate_interval_ms",rotate_interval_ms);
					mv.addObject("hadoop_home",hadoop_home);
					mv.addObject("trf_trg_url",trf_trg_url);
					mv.addObject("topics",topics);
					mv.addObject("task_max",task_max);
					mv.addObject("trf_trg_cnn_nm",trf_trg_cnn_nm);
					mv.addObject("hadoop_conf_dir",hadoop_conf_dir);
					mv.addObject("flush_size",flush_size);
					mv.addObject("connector_class",connector_class);
				}							
			}
			mv.addObject("connector_type",resultList.get(0).getCnr_cnn_tp_cd());
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
			// 전송 관리 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0017");
			accessHistoryService.insertHistory(historyVO);
			
			mv.addObject("cnr_id",request.getParameter("cnr_id"));
			mv.addObject("cnr_nm",request.getParameter("cnr_nm"));
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
	public @ResponseBody List<TransferDetailVO> selectTransferDetail(@ModelAttribute("transferDetailVO") TransferDetailVO transferDetailVO,HttpServletRequest request) {
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
	public ModelAndView transferMappingRegForm(@ModelAttribute("dbServerVO") DbServerVO dbServerVO,@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		List<DbServerVO> resultSet = null;
		List<TransferDetailMappingVO> result = null;
		try {
			// Database 매핑팝업 이력 남기기 수정
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0018");
			accessHistoryService.insertHistory(historyVO);
			
			result= treeTransferService.selectTransferMapping(Integer.parseInt(request.getParameter("trf_trg_id")));
			if(result.size()>0){
				mv.addObject("result",result);
			}
			
			resultSet = dbServerManagerService.selectDbServerList(dbServerVO);
			mv.addObject("resultSet",resultSet);
			mv.addObject("trf_trg_id",request.getParameter("trf_trg_id"));
			mv.addObject("cnr_id",request.getParameter("cnr_id"));
			mv.addObject("trf_trg_cnn_nm",request.getParameter("trf_trg_cnn_nm"));
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
	@RequestMapping(value = "/selectServerDbList.do")
	public @ResponseBody List<DbIDbServerVO> selectServerDbList(@ModelAttribute("dbIDbServerVO") DbIDbServerVO dbIDbServerVO,HttpServletRequest request){
		List<DbIDbServerVO> resultSet = null;
		try{
			String db_svr_nm= request.getParameter("db_svr_nm");
			resultSet = treeTransferService.selectServerDbList(db_svr_nm);
		}catch(Exception e){
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
	public @ResponseBody Map<String, Object> selectMappingTableList(HttpServletRequest request){
		List<DbIDbServerVO> resultSet = null;
		JSONObject serverObj = new JSONObject();
		ClientInfoCmmn cic = new ClientInfoCmmn();
		Map<String, Object> result =new HashMap<String, Object>();
		try{
			AES256 aes = new AES256(AES256_KEY.ENC_KEY);
			int db_id = Integer.parseInt(request.getParameter("db_id"));
			resultSet = treeTransferService.selectServerDb(db_id);
			
			serverObj.put(ClientProtocolID.SERVER_NAME, resultSet.get(0).getDb_svr_nm());
			serverObj.put(ClientProtocolID.SERVER_IP, resultSet.get(0).getIpadr());
			serverObj.put(ClientProtocolID.SERVER_PORT, resultSet.get(0).getPortno());
			serverObj.put(ClientProtocolID.DATABASE_NAME, resultSet.get(0).getDb_nm());
			serverObj.put(ClientProtocolID.USER_ID, resultSet.get(0).getSvr_spr_usr_id());
			serverObj.put(ClientProtocolID.USER_PWD, aes.aesDecode(resultSet.get(0).getSvr_spr_scm_pwd()));
					
			result = cic.tableList_select(serverObj);

		}catch(Exception e){
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
	public @ResponseBody void insertTransferMapping(@ModelAttribute("transferRelationVO") TransferRelationVO transferRelationVO, @ModelAttribute("transferMappingVO") TransferMappingVO transferMappingVO,HttpServletRequest request,@ModelAttribute("historyVO") HistoryVO historyVO) {
		List<ConnectorVO> resultList = null;
		JSONObject result = new JSONObject();
		JSONObject param = new JSONObject();
		try {
			// Database 매핑저장 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0018_01");
			accessHistoryService.insertHistory(historyVO);
			
			HttpSession session = request.getSession();
			String usr_id = (String)session.getAttribute("usr_id");
			transferRelationVO.setFrst_regr_id(usr_id);
			transferRelationVO.setLst_mdfr_id(usr_id);
			transferMappingVO.setFrst_regr_id(usr_id);
			transferMappingVO.setLst_mdfr_id(usr_id);
			
			transferRelationVO.setTrf_trg_id(Integer.parseInt(request.getParameter("trf_trg_id")));
			transferRelationVO.setCnr_id(Integer.parseInt(request.getParameter("cnr_id")));
			transferRelationVO.setDb_id(Integer.parseInt(request.getParameter("db_id")));
			
			/*전송대상매핑관계 DELETE*/
			treeTransferService.deleteTransferRelation(Integer.parseInt(request.getParameter("trf_trg_id")));
			/*전송매핑테이블내역 DELETE*/
			treeTransferService.deleteTransferMapping(Integer.parseInt(request.getParameter("trf_trg_mpp_id")));
			
			/*전송대상매핑관계 INSERT*/
			treeTransferService.insertTransferRelation(transferRelationVO);
			
			JSONParser jParser = new JSONParser();
			JSONArray jArr = (JSONArray)jParser.parse(request.getParameter("rowList").toString().replace("&quot;", "\""));
			
			String trf_trg_cnn_nm = request.getParameter("trf_trg_cnn_nm");
			String topic = "";
			
			for(int i=0; i<jArr.size(); i++){
				JSONObject jObj = (JSONObject)jArr.get(i);
				String table_name=(String) jObj.get("table_name");
				String table_schema=(String) jObj.get("table_schema");
				
				transferMappingVO.setTb_engl_nm(table_name);
				transferMappingVO.setScm_nm(table_schema);
				
				/*전송매핑테이블내역 INSERT*/
				treeTransferService.insertTransferMapping(transferMappingVO); 	
				
				if(i>0){ 
					topic += ","; 
				}
				topic += trf_trg_cnn_nm+"."+table_schema+"."+table_name;			
			}		 
			
			resultList = transferService.selectDetailConnectorRegister(Integer.parseInt(request.getParameter("cnr_id")));
			
			JSONObject serverObj = new JSONObject();
			String strServerIp = resultList.get(0).getCnr_ipadr();
			String strServerPort = Integer.toString(resultList.get(0).getCnr_portno());
			serverObj.put(ClientProtocolID.SERVER_IP, strServerIp);
			serverObj.put(ClientProtocolID.SERVER_PORT, strServerPort);
			ClientInfoCmmn cic = new ClientInfoCmmn();
			result = cic.kafakConnect_select(serverObj,trf_trg_cnn_nm);
			
			for(int i=0; i<result.size(); i++){
				JSONArray data = (JSONArray)result.get("data");
				for(int m=0; m<data.size(); m++){
					JSONObject jsonObj = (JSONObject)data.get(m);
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
			/*kafakConnect_update topic 업데이트*/
			cic.kafakConnect_update(serverObj,param);
			
			
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
