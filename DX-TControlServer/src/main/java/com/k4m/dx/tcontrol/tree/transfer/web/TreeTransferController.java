package com.k4m.dx.tcontrol.tree.transfer.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.k4m.dx.tcontrol.admin.accesshistory.service.AccessHistoryService;
import com.k4m.dx.tcontrol.cmmn.CmmnUtils;
import com.k4m.dx.tcontrol.cmmn.client.ClientInfoCmmn;
import com.k4m.dx.tcontrol.cmmn.client.ClientProtocolID;
import com.k4m.dx.tcontrol.common.service.HistoryVO;
import com.k4m.dx.tcontrol.functions.transfer.service.ConnectorVO;
import com.k4m.dx.tcontrol.functions.transfer.service.TransferService;
import com.k4m.dx.tcontrol.login.service.UserVO;
import com.k4m.dx.tcontrol.tree.transfer.service.TransferDetailVO;
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
			// 전송설정 이력 남기기
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
//		List<TransferTargetVO> result = null;
		JSONObject result = new JSONObject();
		List<ConnectorVO> resultList = null;
		
		try {
			// 전송설정 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
		
			String act = request.getParameter("act");
			int cnr_id = Integer.parseInt(request.getParameter("cnr_id"));
			if(act.equals("i")){
				historyVO.setExe_dtl_cd("DX-T0014_02");
				accessHistoryService.insertHistory(historyVO);
							
			}
			if(act.equals("u")){
				historyVO.setExe_dtl_cd("DX-T0014_03");
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
		JSONObject result = new JSONObject();
		ClientInfoCmmn cic = new ClientInfoCmmn();
		try {		
			// 전송대상 등록 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
//			historyVO.setExe_dtl_cd("DX-T0032_01");
//			accessHistoryService.insertHistory(historyVO);
			
			int cnr_id = Integer.parseInt(request.getParameter("cnr_id"));
			
			HttpSession session = request.getSession();
			String usr_id = (String)session.getAttribute("usr_id");
			transferTargetVO.setFrst_regr_id(usr_id);
			transferTargetVO.setLst_mdfr_id(usr_id);
			
			//전송대상 전체 삭제
			treeTransferService.deleteTransferTarget(cnr_id);
			
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

			String strName="";
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
					
					transferTargetVO.setTrf_trg_cnn_nm(trf_trg_cnn_nm);
					transferTargetVO.setTrf_trg_url(trf_trg_url);
					transferTargetVO.setConnector_class(connector_class);
					transferTargetVO.setTask_max(task_max);
					transferTargetVO.setHadoop_conf_dir(hadoop_conf_dir);
					transferTargetVO.setHadoop_home(hadoop_home);
					transferTargetVO.setFlush_size(flush_size);
					transferTargetVO.setRotate_interval_ms(rotate_interval_ms);
					
					treeTransferService.insertTransferTarget(transferTargetVO);

				}							
			}	
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
		JSONObject result = new JSONObject();
		List<ConnectorVO> resultList = null;
		try {		
			// 전송대상 수정 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
//			historyVO.setExe_dtl_cd("DX-T0032_01");
//			accessHistoryService.insertHistory(historyVO);
			int cnr_id = transferTargetVO.getCnr_id();
			
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
			
			//전송대상 전체 삭제
			treeTransferService.deleteTransferTarget(cnr_id);
			
			strName="";
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
					
					transferTargetVO.setTrf_trg_cnn_nm(trf_trg_cnn_nm);
					transferTargetVO.setTrf_trg_url(trf_trg_url);
					transferTargetVO.setConnector_class(connector_class);
					transferTargetVO.setTask_max(task_max);
					transferTargetVO.setHadoop_conf_dir(hadoop_conf_dir);
					transferTargetVO.setHadoop_home(hadoop_home);
					transferTargetVO.setFlush_size(flush_size);
					transferTargetVO.setRotate_interval_ms(rotate_interval_ms);
					
					treeTransferService.insertTransferTarget(transferTargetVO);
				}							
			}			
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
		JSONObject result = new JSONObject();
		List<ConnectorVO> resultList = null;
		
		try {		
			// 전송대상 삭제 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
//			historyVO.setExe_dtl_cd("DX-T0032_01");
//			accessHistoryService.insertHistory(historyVO);
			
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
			}			
			
			//전송대상 전체 삭제
			treeTransferService.deleteTransferTarget(cnr_id);
			
			String strName="";
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
					
					transferTargetVO.setTrf_trg_cnn_nm(trf_trg_cnn_nm);
					transferTargetVO.setTrf_trg_url(trf_trg_url);
					transferTargetVO.setConnector_class(connector_class);
					transferTargetVO.setTask_max(task_max);
					transferTargetVO.setHadoop_conf_dir(hadoop_conf_dir);
					transferTargetVO.setHadoop_home(hadoop_home);
					transferTargetVO.setFlush_size(flush_size);
					transferTargetVO.setRotate_interval_ms(rotate_interval_ms);
					
					treeTransferService.insertTransferTarget(transferTargetVO);
				}							
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
			// 전송설정 이력 남기기
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
	public ModelAndView transferMappingRegForm(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		try {
			// 전송설정 이력 남기기 수정
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0018");
			accessHistoryService.insertHistory(historyVO);
			
			mv.setViewName("popup/transferMappingRegForm");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}	
}
