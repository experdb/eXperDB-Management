package com.k4m.dx.tcontrol.scale.service.impl;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Set;
import java.util.TimeZone;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.stereotype.Service;
import org.springframework.util.ResourceUtils;

import com.k4m.dx.tcontrol.admin.accesshistory.service.impl.AccessHistoryDAO;
import com.k4m.dx.tcontrol.admin.dbserverManager.service.DbServerVO;
import com.k4m.dx.tcontrol.cmmn.CmmnUtils;
import com.k4m.dx.tcontrol.cmmn.client.ClientInfoCmmn;
import com.k4m.dx.tcontrol.cmmn.client.ClientProtocolID;
import com.k4m.dx.tcontrol.common.service.AgentInfoVO;
import com.k4m.dx.tcontrol.common.service.HistoryVO;
import com.k4m.dx.tcontrol.common.service.impl.CmmnServerInfoDAO;
import com.k4m.dx.tcontrol.scale.service.InstanceScaleService;
import com.k4m.dx.tcontrol.scale.service.InstanceScaleVO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

/**
* @author 
* @see aws scale 관련 화면 serviceImpl
* 
*      <pre>
* == 개정이력(Modification Information) ==
*
*   수정일                 수정자                   수정내용
*  -------     --------    ---------------------------
*  2020.03.24              최초 생성
*      </pre>
*/
@Service("InstanceScaleServiceImpl")
public class InstanceScaleServiceImpl extends EgovAbstractServiceImpl implements InstanceScaleService {

	@Resource(name = "instanceScaleDAO")
	private InstanceScaleDAO instanceScaleDAO;

	@Resource(name = "accessHistoryDAO")
	private AccessHistoryDAO accessHistoryDAO;
	
	@Resource(name = "cmmnServerInfoDAO")
	private CmmnServerInfoDAO cmmnServerInfoDAO;
	
	/**
	 * aws 설치 여부 조회
	 * 
	 * @param param
	 * @throws Exception
	 */
	@Override
	public Map<String, Object> scaleInstallChk(InstanceScaleVO instanceScaleVO) throws Exception {

		Map<String, Object> recultChk = null;
		Map<String, Object> result = new JSONObject();
		Map<String, Object> param = new HashMap<String, Object>();
		String scalejsonChk = "";

		try {
			recultChk = (Map<String, Object>) instanceScaleDAO.selectScaleAWSSvrInfo(instanceScaleVO);

			if (recultChk != null) {
				result.put("install_yn", "Y");
			} else {
				//서버 직접 확인
				Map<String, Object> agentList = null;
				String id = instanceScaleVO.getLogin_id();
				
				param.put("search_gbn", "scaleAwsChk");
				param.put("scale_set", "");
				param.put("login_id", id);
				param.put("instance_id", "");           //확인완료
				param.put("db_svr_id", instanceScaleVO.getDb_svr_id());
				param.put("process_id", "");
				param.put("monitering", "");
				param.put("scale_count", "");
				
				agentList = scaleInAgent(param);
				
				if (!agentList.isEmpty()) {
					String resultCode = (String)agentList.get(ClientProtocolID.RESULT_CODE);
					
					if (resultCode != null){
						if (resultCode.equals("0")) {
							scalejsonChk = (String)agentList.get(ClientProtocolID.RESULT_SUB_DATA);
						}
					}

				}
				
				if (!scalejsonChk.isEmpty()) {
					scalejsonChk = scalejsonChk.trim();
					if (scalejsonChk.contains("/usr/bin/aws")) {
						//서버 db 등록
						instanceScaleDAO.insertScaleAwsserver(instanceScaleVO);
						
						result.put("install_yn", "Y");
					} else {
						result.put("install_yn", "N");
					}
				} else {
					result.put("install_yn", "N");
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}

		return result;
	}

	/**
	 * scale Auto 설정 list 조회
	 * 
	 * @param instanceScaleVO
	 * @throws Exception 
	 */
	@Override
	public List<Map<String, Object>> selectScaleCngList(InstanceScaleVO instanceScaleVO) throws Exception {
		return  instanceScaleDAO.selectScaleCngList(instanceScaleVO);
	}

	/**
	 * scale 설정정보 상세정보조회
	 * 
	 * @param instanceScaleVO
	 * @throws Exception 
	 */
	@Override
	public Map<String, Object> selectAutoScaleCngInfo(InstanceScaleVO instanceScaleVO) throws Exception {
		return instanceScaleDAO.selectAutoScaleCngInfo(instanceScaleVO);
	}

	/**
	 * scale 공통 설정정보 상세정보조회
	 * 
	 * @param instanceScaleVO
	 * @throws Exception 
	 */
	@Override
	public Map<String, Object> selectAutoScaleComCngInfo(InstanceScaleVO instanceScaleVO) throws Exception {
		return instanceScaleDAO.selectAutoScaleComCngInfo(instanceScaleVO);
	}

	/**
	 * scale 상태조회
	 * 
	 * @param param
	 * @throws Exception
	 */
	@Override
	public Map<String, Object> scaleSetResult(InstanceScaleVO instanceScaleVO) throws Exception {
		Map<String, Object> param = new HashMap<String, Object>();
		Map<String, Object> result = new JSONObject();
		JSONObject scalejsonObj = new JSONObject();
		String scalejsonChk = "";
		String scalejsonStr = "";

		String id = instanceScaleVO.getLogin_id();
		String resultChk = "";

		try {
			//scale load 상태보기
			param.put("frst_regr_id", id);
			result = (Map<String, Object>)instanceScaleDAO.selectScaleLog(param);

			if (result == null) {
				resultChk = "search";
			} else {
				if (!result.get("wrk_id").toString().equals("1")) {
					resultChk = "search";
				}
			}

			//aws도 확인힐요 -- 값자체를 찾아야할듯함
			if ("search".equals(resultChk)) {
				Map<String, Object> agentList = null;

				param.put("search_gbn", "scaleChk");
				param.put("scale_set", "");
				param.put("login_id", id);
				param.put("instance_id", "");           //확인완료
				param.put("db_svr_id", instanceScaleVO.getDb_svr_id());
				param.put("process_id", "");
				param.put("monitering", "");
				param.put("scale_count", "");

				agentList = scaleInAgent(param);

				if (!agentList.isEmpty()) {
					String resultCode = (String)agentList.get(ClientProtocolID.RESULT_CODE);

					if (resultCode.equals("0")) {
						scalejsonObj = (JSONObject)agentList.get(ClientProtocolID.RESULT_DATA);
						scalejsonChk = (String)agentList.get(ClientProtocolID.RESULT_SUB_DATA);
					}
				}

				if (!scalejsonObj.isEmpty()) {
					scalejsonStr = scalejsonObj.toString();
					
					if ("{\"Instances\":[]}".equals(scalejsonStr)) {
						result = new JSONObject();
					}

					if (scalejsonStr.contains("pending")) {
						result.put("wrk_id", "1");
						result.put("scale_type", "2");
					} else if (scalejsonStr.contains("shutting-down")) {
						result.put("wrk_id", "1");
						result.put("scale_type", "1");
					} else {
						if (!scalejsonChk.isEmpty()) {
							if (!"0".equals(scalejsonChk)) {
								result.put("wrk_id", "1");
								result.put("scale_type", "1");
							} else {
								result.put("wrk_id", "2");
								result.put("scale_type", "");
							}
						} else {
							result.put("wrk_id", "2");
							result.put("scale_type", "");
						}
					}
				} else {
					result = new JSONObject();

					if (!scalejsonChk.isEmpty()) {
						if (!"0".equals(scalejsonChk)) {
							result.put("wrk_id", "1");
							result.put("scale_type", "1");
						} else {
							result.put("wrk_id", "2");
							result.put("scale_type", "");
						}
					} else {
						result.put("wrk_id", "2");
						result.put("scale_type", "");
					}
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}

		return result;
	}
	
	/**
	 * scale Auto setting 등록
	 * 
	 * @param instanceScaleVO
	 * @throws Exception 
	 */
	@Override
	public String updateAutoScaleCommonSetting(InstanceScaleVO instanceScaleVO) throws Exception {
		String result = "S";
		List<Map<String, Object>> dbResult = null;
		Map<String, Object> recultChk = null;
		
		try{
			//데이터 있는지 확인
			recultChk = (Map<String, Object>) instanceScaleDAO.selectScaleAWSSvrInfo(instanceScaleVO);

			if (recultChk == null) {
				result = "O";
			}
		}catch(Exception e){
			e.printStackTrace();
		}

		//저장
		if ("S".equals(result)) {
			try{
				int db_svr_id = instanceScaleVO.getDb_svr_id();
				dbResult = instanceScaleDAO.selectSvrIpadrList(db_svr_id);
				if (!dbResult.isEmpty()) {
					int iDbSvrIpadrId = Integer.parseInt(String.valueOf(dbResult.get(0).get("db_svr_ipadr_id")+""));
					instanceScaleVO.setDb_svr_ipadr_id(iDbSvrIpadrId);
				} else {
					instanceScaleVO.setDb_svr_ipadr_id(1);
				}
				
				String min_clusters_val = instanceScaleVO.getMin_clusters();
				
				if ("".equals(min_clusters_val)) {
					instanceScaleVO.setMin_clusters(null);
				}

				String max_clusters_val = instanceScaleVO.getMax_clusters();
				
				if ("".equals(max_clusters_val)) {
					instanceScaleVO.setMax_clusters(null);
				}
				
				String auto_run_cycle_val = instanceScaleVO.getAuto_run_cycle();
				
				if ("".equals(auto_run_cycle_val)) {
					instanceScaleVO.setExpansion_clusters(null);
				}
				
				instanceScaleDAO.updateAutoScaleCommonSetting(instanceScaleVO);
				
				//설정 전체 수정
				instanceScaleDAO.updateTotalAutoScaleSetting(instanceScaleVO);
			} catch (Exception e) {
				result = "F";
				e.printStackTrace();
			}
		}

		return result;
	}
	
	/**
	 * 공통 INS 조회
	 * 
	 * @param param
	 * @throws Exception
	 */
	@Override
	public Map<String, Object> scaleInstallList(InstanceScaleVO instanceScaleVO) throws Exception {
		return (Map<String, Object>) instanceScaleDAO.selectScaleAWSSvrInfo(instanceScaleVO);
	}

	/**
	 * scale Auto setting 등록
	 * 
	 * @param instanceScaleVO
	 * @throws Exception 
	 */
	@Override
	public String insertAutoScaleSetting(InstanceScaleVO instanceScaleVO) throws Exception {
		String result = "S";
		List<Map<String, Object>> dbResult = null;

		try{
			//중복 체크
			int autoScaleChk = instanceScaleDAO.selectAutoScaleSetChk(instanceScaleVO);
			if (autoScaleChk > 0) {
				result = "O";
			}
		}catch(Exception e){
			e.printStackTrace();
		}

		//저장
		if ("S".equals(result)) {
			try{
				int db_svr_id = instanceScaleVO.getDb_svr_id();
				dbResult = instanceScaleDAO.selectSvrIpadrList(db_svr_id);
				if (!dbResult.isEmpty()) {
					int iDbSvrIpadrId = Integer.parseInt(String.valueOf(dbResult.get(0).get("db_svr_ipadr_id")+""));
					instanceScaleVO.setDb_svr_ipadr_id(iDbSvrIpadrId);
				} else {
					instanceScaleVO.setDb_svr_ipadr_id(1);
				}
				
				String min_clusters_val = instanceScaleVO.getMin_clusters();
				
				if ("".equals(min_clusters_val)) {
					instanceScaleVO.setMin_clusters(null);
				}

				String max_clusters_val = instanceScaleVO.getMax_clusters();
				
				if ("".equals(max_clusters_val)) {
					instanceScaleVO.setMax_clusters(null);
				}
				
				String expansion_clusters_val = instanceScaleVO.getExpansion_clusters();
				
				if ("".equals(expansion_clusters_val)) {
					instanceScaleVO.setExpansion_clusters(null);
				}

				instanceScaleDAO.insertAutoScaleSetting(instanceScaleVO);
			} catch (Exception e) {
				result = "F";
				e.printStackTrace();
			}
		}

		return result;
	}

	/**
	 * scale Auto setting 삭제
	 * 
	 * @param instanceScaleVO
	 * @throws Exception 
	 */
	@Override
	public String deleteAutoScaleSetting(InstanceScaleVO instanceScaleVO) throws Exception {
		String result = "S";
		
		try{
			JSONArray wrk_ids = (JSONArray) new JSONParser().parse(instanceScaleVO.getWrk_id_Rows());

			for(int i=0; i<wrk_ids.size(); i++){
				instanceScaleVO.setWrk_id(wrk_ids.get(i).toString());
				instanceScaleDAO.deleteAutoScaleSetting(instanceScaleVO);
			}
		}catch(Exception e){
			result = "F";
			e.printStackTrace();
		}

		return result;
	}

	/**
	 * scale Auto setting 수정
	 * 
	 * @param instanceScaleVO
	 * @throws Exception 
	 */
	@Override
	public String updateAutoScaleSetting(InstanceScaleVO instanceScaleVO) throws Exception {
		String result = "S";
		List<Map<String, Object>> dbResult = null;

		try{
			//중복 체크
			int autoScaleChk = instanceScaleDAO.selectAutoScaleSetChk(instanceScaleVO);
			if (autoScaleChk > 0) {
				result = "O";
			}
		}catch(Exception e){
			e.printStackTrace();
		}

		//저장
		if ("S".equals(result)) {
			try{
				int db_svr_id = instanceScaleVO.getDb_svr_id();
				dbResult = instanceScaleDAO.selectSvrIpadrList(db_svr_id);
				if (!dbResult.isEmpty()) {
					int iDbSvrIpadrId = Integer.parseInt(String.valueOf(dbResult.get(0).get("db_svr_ipadr_id")+""));
					instanceScaleVO.setDb_svr_ipadr_id(iDbSvrIpadrId);
				} else {
					instanceScaleVO.setDb_svr_ipadr_id(1);
				}
				
				String min_clusters_val = instanceScaleVO.getMin_clusters();
				
				if ("".equals(min_clusters_val)) {
					instanceScaleVO.setMin_clusters(null);
				}

				String max_clusters_val = instanceScaleVO.getMax_clusters();
				
				if ("".equals(max_clusters_val)) {
					instanceScaleVO.setMax_clusters(null);
				}
				
				String expansion_clusters_val = instanceScaleVO.getExpansion_clusters();
				
				if ("".equals(expansion_clusters_val)) {
					instanceScaleVO.setExpansion_clusters(null);
				}

				instanceScaleDAO.updateAutoScaleSetting(instanceScaleVO);
			} catch (Exception e) {
				result = "F";
				e.printStackTrace();
			}
		}

		return result;
	}

	/**
	 * scale log list 조회
	 * 
	 * @param instanceScaleVO
	 * @throws Exception 
	 */
	@Override
	public List<Map<String, Object>> selectScaleHistoryList(InstanceScaleVO instanceScaleVO) throws Exception {
		List<Map<String, Object>> list = null;
		String histGbn = (String)instanceScaleVO.getHist_gbn();

		if ("execute_hist".equals(histGbn)) {
			list = instanceScaleDAO.selectScaleHistoryList(instanceScaleVO);
		} else {
			list = instanceScaleDAO.selectScaleOccurHistoryList(instanceScaleVO);
		}
		
		return list;
	}

	/**
	 * scale 실행이력 상세정보조회
	 * 
	 * @param instanceScaleVO
	 * @throws Exception 
	 */
	@Override
	public Map<String, Object> selectScaleWrkInfo(InstanceScaleVO instanceScaleVO) throws Exception {
		return instanceScaleDAO.selectScaleWrkInfo(instanceScaleVO);
	}

	/**
	 * scale 실패 이력정보
	 * 
	 * @param scale_wrk_sn
	 * @throws Exception 
	 */
	@Override
	public Map<String, Object> selectScaleWrkErrorMsg(InstanceScaleVO instanceScaleVO) throws Exception {
		return instanceScaleDAO.selectScaleWrkErrorMsg(instanceScaleVO);
	}

	/**
	 * scale list search
	 * 
	 * @param instanceScaleVO
	 * @throws Exception 
	 */
	@Override
	public JSONObject instanceListSetting(InstanceScaleVO instanceScaleVO) throws Exception {
		JSONObject result = new JSONObject();
		JSONArray jsonArray = new JSONArray(); // 객체를 담기위해 JSONArray 선언.
		JSONArray InstancesArrly = new JSONArray();

		String scaleId = (String)instanceScaleVO.getScale_id();
		JSONObject scalejsonObj = new JSONObject();
		String stateChk = "";
		String scalejsonChk = "";
		int iLastNodeCnt = 0;
		
		Map<String, Object> param = new HashMap<String, Object>();
		Map<String, Object> agentList = null;

		Properties props = new Properties();
		props.load(new FileInputStream(ResourceUtils.getFile("classpath:egovframework/tcontrolProps/globals.properties")));

		param.put("search_gbn", "main");
		param.put("scale_set", "");
		param.put("login_id", (String)instanceScaleVO.getLogin_id());
		param.put("instance_id", scaleId);                          //확인완료
		param.put("db_svr_id", instanceScaleVO.getDb_svr_id());
		param.put("process_id", "");
		param.put("monitering", "");
		param.put("scale_count", "");

		try {				
			agentList = scaleInAgent(param);
			
			if (!agentList.isEmpty()) {
				String resultCode = (String)agentList.get(ClientProtocolID.RESULT_CODE);

				if (resultCode.equals("0")) {
					scalejsonObj = (JSONObject)agentList.get(ClientProtocolID.RESULT_DATA);
					
					if (agentList.get(ClientProtocolID.RESULT_SUB_DATA) != null) {
						scalejsonChk = (String)agentList.get(ClientProtocolID.RESULT_SUB_DATA);
					}
					
					if (agentList.get(ClientProtocolID.LAST_NODE_CNT) != null) {
						iLastNodeCnt = Integer.parseInt((String)agentList.get(ClientProtocolID.LAST_NODE_CNT));
					}
					
					if (iLastNodeCnt == 0) {
						iLastNodeCnt = 1;
					}
				}
			}

			if (!scalejsonObj.isEmpty()) {
				InstancesArrly = (JSONArray) scalejsonObj.get("Instances");
	
				int iNumCnt = 0;
				int iLastNodeChkCnt = 1;
				
				if (InstancesArrly != null) {
					for (int j = 0; j < InstancesArrly.size(); j++) {
						JSONObject jsonObj = new JSONObject();
						JSONObject instancesObj = (JSONObject)InstancesArrly.get(j);
						
						JSONArray securityGroupsArrly = (JSONArray) instancesObj.get("SecurityGroups");     //보안그룹

						String privateIpAddressVal = "";
						String default_chk ="";

						if (instancesObj.get("PrivateIpAddress") != null) {
							privateIpAddressVal = (String) instancesObj.get("PrivateIpAddress");
						}
						
						String key_name_val = (String) instancesObj.get("TagsName");

						//재확인 필요 일단 넣어놈 - staticLastNode 수를 확인함
						if (scalejsonChk != null && privateIpAddressVal != null) {
							if (!"".equals(scalejsonChk) && !"".equals(privateIpAddressVal)) {

/*								if (Integer.parseInt(privateIpAddressVal.replaceAll("\\.","")) >= Integer.parseInt(scalejsonChk.replaceAll("\\.",""))) {
									default_chk = "N";
								} else {*/
									//추가
									String key_name_val_last = key_name_val.substring(key_name_val.length()-1, key_name_val.length());

									if (key_name_val.indexOf("master") > 0 || "master".contains(key_name_val) || !isInteger(key_name_val_last)) {
										if (iLastNodeCnt >= iLastNodeChkCnt) {
											default_chk = "Y";
											iLastNodeChkCnt = iLastNodeChkCnt + 1;
										} else {
											default_chk = "N";
										}
									} else {
										default_chk = "N";
									}
/*								}*/
							} else {
								default_chk = "N";
							}
						} else {
							default_chk = "N";
						}

						jsonObj.put("default_chk", default_chk); 
						jsonObj.put("public_IPv4", (String) instancesObj.get("PublicDnsName"));             //public dns IPv4
						jsonObj.put("IPv4_public_ip", (String) instancesObj.get("PublicIpAddress"));        //IPv4 IP
						jsonObj.put("private_ip_address", (String) instancesObj.get("PrivateIpAddress"));   //private_IP

						jsonObj.put("instance_id", instancesObj.get("InstanceId"));                         //인스턴트 id - 확인완료
						jsonObj.put("private_dns_name", (String) instancesObj.get("PrivateDnsName"));       //private_dna_name
						jsonObj.put("key_name", (String) instancesObj.get("KeyName"));                      //키이름
						jsonObj.put("instance_type", (String) instancesObj.get("InstanceType"));            //인스턴트 타입
						
						/* start time */
						String LaunchTimeStr = instancesObj.get("LaunchTime").toString();  //시작일자
						
						String dateLocale = "KST";
					    String lang = props.get("lang").toString();
						if (!lang.equals("ko")) {dateLocale = "UTC";}

						SimpleDateFormat old_format = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"); // 받은 데이터 형식
				        old_format.setTimeZone(TimeZone.getTimeZone(dateLocale));
				        SimpleDateFormat new_format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"); // 바꿀 데이터 형식
				        
				        Date old_date = old_format.parse(LaunchTimeStr);
						jsonObj.put("start_time", new_format.format(old_date));
						/* start time end */

						jsonObj.put("monitoring_state", (String) instancesObj.get("MonitoringState"));            //모니터링 상태
						stateChk = instancesObj.get("InstanceStatusName").toString();
						jsonObj.put("instance_status_name", stateChk);     											//인스턴스 상태
						jsonObj.put("availability_zone", (String) instancesObj.get("AvailabilityZone")); 
						jsonObj.put("tagsValue", (String) instancesObj.get("TagsName"));                          //name

						/* securityGroupsArrly start*/ 
						if (securityGroupsArrly != null) {
							String nameVal = "";
							String idVal = "";

							for (int k = 0; k < securityGroupsArrly.size(); k++) {
								JSONObject securityGroupObj = (JSONObject)securityGroupsArrly.get(k);

								if (!nameVal.equals("")) {
									nameVal += ", ";
									idVal += ", ";
								}

								nameVal += securityGroupObj.get("GroupName").toString();
								idVal += securityGroupObj.get("GroupId").toString();
							}

							jsonObj.put("security_group", nameVal);
							jsonObj.put("securityGroupId", idVal);
						}
						/* securityGroupsArrly end */

						if (!stateChk.contains("terminated")) {
							iNumCnt = iNumCnt + 1;
							jsonObj.put("rownum", iNumCnt);                                                //no
							jsonArray.add(jsonObj);
						}
					}
				}
			}

			if (!jsonArray.isEmpty()) {
				result.put("data", jsonArray);
			} else {
				result.put("data", null);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	/**
	 * scale 상세 조회
	 * 
	 * @param instanceScaleVO
	 * @throws Exception 
	 */
	@Override
	public JSONArray instanceInfoListSetting(InstanceScaleVO instanceScaleVO) throws Exception {
		Set key = null;
		Iterator<String> iter = null;
		String scaleId = (String)instanceScaleVO.getScale_id();
		JSONArray result = new JSONArray(); // 객체를 담기위해 JSONArray 선언.
		JSONArray scaleArrly = new JSONArray();
		JSONObject scalejsonObj = new JSONObject();

		Properties props = new Properties();
		props.load(new FileInputStream(ResourceUtils.getFile("classpath:egovframework/tcontrolProps/globals.properties")));		

		Map<String, Object> param = new HashMap<String, Object>();
		Map<String, Object> agentList = null;
		
		param.put("search_gbn", "");
		param.put("scale_set", "");
		param.put("login_id", (String)instanceScaleVO.getLogin_id());
		param.put("instance_id", scaleId);                           //확인완료
		param.put("db_svr_id", instanceScaleVO.getDb_svr_id());
		param.put("process_id", "");
		param.put("monitering", "");
		param.put("scale_count", "");

		try {
			agentList = scaleInAgent(param);
			
			if (!agentList.isEmpty()) {
				String resultCode = (String)agentList.get(ClientProtocolID.RESULT_CODE);
				if (resultCode.equals("0")) {
					scalejsonObj = (JSONObject)agentList.get(ClientProtocolID.RESULT_DATA);
				}
			}
			
			if (!scalejsonObj.isEmpty()) {
				scaleArrly = (JSONArray) scalejsonObj.get("Reservations");

				if (scaleArrly != null) {
					for (int i = 0; i < scaleArrly.size(); i++) {
						String instantsIdChk = "";
						JSONObject jsonObj = new JSONObject();
						JSONObject scaleSubObj = (JSONObject)scaleArrly.get(i);
					
						JSONArray InstancesArrly = (JSONArray) scaleSubObj.get("Instances");
					
						//jsonObj.put("rownum", i + 1);                                                //no
						jsonObj.put("owner", (String) scaleSubObj.get("OwnerId"));                   //소유자
						jsonObj.put("reservation_id", (String) scaleSubObj.get("ReservationId"));    //예약id

						if (InstancesArrly != null) {
							for (int j = 0; j < InstancesArrly.size(); j++) {
								JSONObject instancesObj = (JSONObject)InstancesArrly.get(j);
							
								JSONObject monitoringObj = (JSONObject)instancesObj.get("Monitoring");              		//모니터링
								JSONObject stateObj = (JSONObject)instancesObj.get("State");                        		//상태 
								JSONObject placementObj = (JSONObject)instancesObj.get("Placement");                		//가상서버
								JSONObject stateReasonObj = (JSONObject)instancesObj.get("StateReason");            		//상태사유
								JSONObject cctRevtSpectObj = (JSONObject)instancesObj.get("CapacityReservationSpecification"); //용량예약설정
								JSONObject hibernationOptionsObj = (JSONObject)instancesObj.get("HibernationOptions");		//최대절전
								JSONObject cpuOptionsObj = (JSONObject)instancesObj.get("CpuOptions");
								
								JSONArray productCodesArrly = (JSONArray) instancesObj.get("ProductCodes");         		//제품코드
								JSONArray securityGroupsArrly = (JSONArray) instancesObj.get("SecurityGroups");     		//보안그룹
								JSONArray tagsArrly = (JSONArray) instancesObj.get("Tags");                         		//인스턴스 name
								JSONArray blockDeviceMappingsArrly = (JSONArray) instancesObj.get("BlockDeviceMappings"); 	//Block Device
								JSONArray networkInterfacesArrly = (JSONArray) instancesObj.get("NetworkInterfaces");		//Network Interfaces
							
								jsonObj.put("public_IPv4", (String) instancesObj.get("PublicDnsName"));			    		//public dns IPv4
								instantsIdChk = (String) instancesObj.get("InstanceId");
								jsonObj.put("instance_id", instantsIdChk);                									//인스턴트 id - 확인완료 
								jsonObj.put("IPv4_public_ip", (String) instancesObj.get("PublicIpAddress"));        		//IPv4 IP
								jsonObj.put("instance_type", (String) instancesObj.get("InstanceType"));            		//인스턴트 타입
								jsonObj.put("private_dns_name", (String) instancesObj.get("PrivateDnsName"));       		//private_dna_name
								jsonObj.put("private_ip_address", (String) instancesObj.get("PrivateIpAddress"));   		//private_IP
								jsonObj.put("vpc_id", (String) instancesObj.get("VpcId"));									//vpc_id
								jsonObj.put("subnet_id", (String) instancesObj.get("SubnetId"));							//subnet_id
								jsonObj.put("key_name", (String) instancesObj.get("KeyName"));                      		//키이름
								jsonObj.put("ebs_optimized", instancesObj.get("EbsOptimized").toString());					//ebs_optimized
								jsonObj.put("root_device_type", (String) instancesObj.get("RootDeviceType"));       		//루트디바이스유형
								jsonObj.put("root_device_name", (String) instancesObj.get("RootDeviceName"));      			//루트디바이스명
								jsonObj.put("virtualization_type", (String) instancesObj.get("VirtualizationType"));		//가상화
								jsonObj.put("capacity_reservation_id", (String) instancesObj.get("CapacityReservationId"));	//용량예약
								jsonObj.put("ami_launch_index", instancesObj.get("AmiLaunchIndex").toString());				//AMI 시작 인덱스
								jsonObj.put("image_id", (String)instancesObj.get("ImageId"));                				//이미지ID
								
								if (instancesObj.get("SourceDestCheck") != null) {
									jsonObj.put("source_dest_check", instancesObj.get("SourceDestCheck").toString());	//sourceDestCheck
								} else {
									jsonObj.put("source_dest_check", null);
								}
							
					            /* tagsArrly start */
								if (tagsArrly != null) {
									String serviceValue="";

									for (int k = 0; k < tagsArrly.size(); k++) {
										JSONObject tagsArrlyObj = (JSONObject)tagsArrly.get(k);

										if (tagsArrlyObj.get("Key").toString().equals("Name")) {
											serviceValue = tagsArrlyObj.get("Value").toString();
										}

										if (serviceValue.equals("")) {
											if (tagsArrlyObj.get("Key").toString().equals("Service")) {
												serviceValue = (String) tagsArrlyObj.get("Value");
											}
										}
									}
									jsonObj.put("tagsValue", serviceValue);   										//name
								} else {
									jsonObj.put("tagsValue", null);    												//name
								}
					            /* tagsArrly end */
							
					            /* placementObj start */
								jsonObj.put("tenancy", (String) placementObj.get("Tenancy"));  						//Tenancy
								jsonObj.put("availability_zone", (String) placementObj.get("AvailabilityZone"));   	//가용영역
					            /* placementObj end */

					            /* securityGroupsArrly start */
								if (securityGroupsArrly != null) {
									String nameVal = "";

									for (int k = 0; k < securityGroupsArrly.size(); k++) {
										JSONObject securityGroupObj = (JSONObject)securityGroupsArrly.get(k);

							            if (!nameVal.equals("")) {
							            	nameVal += ",";
							            }
						            	
							            nameVal += securityGroupObj.get("GroupName").toString();
									}
						        
									jsonObj.put("security_group", nameVal);
								}
								/* securityGroupsArrly end */

					            /* stateReasonObj start */
								if (stateReasonObj != null) {
									jsonObj.put("stateReason_message", (String) stateReasonObj.get("Message"));   //상태사유
								}
					            /* stateReasonObj end */
							
					            /* networkInterfacesArrly start */
								if (networkInterfacesArrly != null) {
									String nameVal = "";
								
									for (int k = 0; k < networkInterfacesArrly.size(); k++) {
							            if (!nameVal.equals("")) {
							            	nameVal += ",";
							            }
						            	
							            nameVal += "eth" + k;
									}
						        
									jsonObj.put("network_interfaces", nameVal);
								}
								/* networkInterfacesArrly end */
							
								/* start time */
								String LaunchTimeStr = (String) instancesObj.get("LaunchTime");  //시작일자
								
								String dateLocale = "KST";
							    String lang = props.get("lang").toString();
								if (!lang.equals("ko")) {dateLocale = "UTC";}

								SimpleDateFormat old_format = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"); // 받은 데이터 형식
						        old_format.setTimeZone(TimeZone.getTimeZone(dateLocale));
						        SimpleDateFormat new_format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"); // 바꿀 데이터 형식
						        
						        Date old_date = old_format.parse(LaunchTimeStr);
	
								jsonObj.put("start_time", new_format.format(old_date));
							    /* start time end */
							
								//blockDeviceMappingsArrly
								if (blockDeviceMappingsArrly != null) {
									String blockNameVal = "";

									for (int k = 0; k < blockDeviceMappingsArrly.size(); k++) {
										JSONObject blockDeviceMappingsObj = (JSONObject)blockDeviceMappingsArrly.get(k);

							            if (!blockNameVal.equals("")) {
							            	blockNameVal += "<br/>";
							            }
							            	
							            blockNameVal += blockDeviceMappingsObj.get("DeviceName").toString();
									}

									jsonObj.put("block_device_name", (String) blockNameVal);
								} else {
									jsonObj.put("block_device_name", null);
								}
								//blockDeviceMappingsArrly end
							
								/* monitoringObj start */
								key = monitoringObj.keySet(); 
					            iter = key.iterator(); // Iterator 설정
					            while(iter.hasNext()) {
					            	String keyname = iter.next();

					            	jsonObj.put("monitoring_" + keyname.toLowerCase(), (String) monitoringObj.get(keyname).toString());
					            }
					            /* monitoringObj end */
							
								/* stateObj start */
								key = stateObj.keySet(); 
					            iter = key.iterator(); // Iterator 설정
					            while(iter.hasNext()) {
					            	String keyname = iter.next();					            	
					            	jsonObj.put("instance_status_" + keyname.toLowerCase(), stateObj.get(keyname).toString());
					            }
					            /* stateObj end */
								
								/* cctRevtSpectObj start */
					            if (cctRevtSpectObj != null) {
									jsonObj.put("cct_revt_spect_preference", (String) cctRevtSpectObj.get("CapacityReservationPreference"));
									
									JSONObject cctRevtSpectRetgObj = (JSONObject) cctRevtSpectObj.get("CapacityReservationTarget");
									if (cctRevtSpectRetgObj != null) {
										jsonObj.put("cct_revt_spect_re_id", (String) cctRevtSpectRetgObj.get("CapacityReservationId"));
									}
					            }
					            /* cctRevtSpectObj end */
								
								/* hibernationOptionsObj start */
					            if (hibernationOptionsObj != null) {
									jsonObj.put("hiber_configured", hibernationOptionsObj.get("Configured").toString());
					            }
								/* hibernationOptionsObj end */
								
					            /* productCodesArrly start */
								if (productCodesArrly != null) {
									for (int k = 0; k < productCodesArrly.size(); k++) {
										JSONObject productCodeObj = (JSONObject)productCodesArrly.get(k);

										key = productCodeObj.keySet(); 
							            iter = key.iterator(); // Iterator 설정
							            while(iter.hasNext()) {
							            	String keyname = iter.next();

							            	jsonObj.put(keyname.toLowerCase(), (String) productCodeObj.get(keyname).toString());
							            }
									}
								}
					            /* productCodesArrly end */
								
								/* cpuOptionsObj start */
								if (cpuOptionsObj != null) {
									jsonObj.put("core_count", cpuOptionsObj.get("CoreCount").toString());
									jsonObj.put("threads_perCore", cpuOptionsObj.get("ThreadsPerCore").toString());
								}
								/* cpuOptionsObj end */
							}
						} else {
							jsonObj.put("public_IPv4", null);				//퍼블릭 DNS IPv4
							jsonObj.put("instance_id", null);				//인스턴트 id  확인완료
							jsonObj.put("tagsValue", null);					//name
							jsonObj.put("IPv4_public_ip", null);			//IPv4 IP
							jsonObj.put("instance_type", null);				//인스턴트 타입
							jsonObj.put("private_dns_name", null);			//private_dna_name
							jsonObj.put("availability_zone", null);			//가용영역
							jsonObj.put("private_ip_address", null);		//private_ip_address
							jsonObj.put("vpc_id", null);					//vpc_id
							jsonObj.put("subnet_id", null);					//subnet_id
							jsonObj.put("stateReason_message", null);		//stateReason_message
							jsonObj.put("key_name", null);               	//키이름
							jsonObj.put("security_group", null);         	//보안그룹명
							jsonObj.put("network_interfaces", null);        //network_interfaces
							jsonObj.put("source_dest_check", null);			//source_dest_check
							jsonObj.put("ebs_optimized", null);				//ebs_optimized
							jsonObj.put("root_device_type", null);       	//루트디바이스유형
							jsonObj.put("root_device_name", null);          //루트디바이스이름
							jsonObj.put("start_time", null);              	//시작일자
							jsonObj.put("block_device_name", null);			//블록디바이스이름
							jsonObj.put("virtualization_type", null);		//가상화
							jsonObj.put("capacity_reservation_id", null);	//용량 예약
							jsonObj.put("capacity_reservation_id", null);	//용량 예약
							jsonObj.put("cct_revt_spect_preference", null);	//용량 예약 설정
							jsonObj.put("cct_revt_spect_re_id", null);		//용량 예약 설정
							jsonObj.put("ami_launch_index", null);			//AMI 시작 인덱스
							jsonObj.put("tenancy", null);  					//Tenancy
							jsonObj.put("image_id", null);                	//이미지ID
							jsonObj.put("hiber_configured", null);          //최대절전
							jsonObj.put("core_count", null);		        //core_count
							jsonObj.put("threads_perCore", null);	        //threads_perCore
						}

						if (scaleId != null && !"".equals(scaleId)) {
							if (instantsIdChk.equals(scaleId)) {
								result.add(jsonObj);
							}
						}
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return result;
	}
	
	/**
	 * scale in out
	 * 
	 * @param historyVO, param
	 * @throws Exception
	 */
	@Override
	public Map<String, Object> scaleInOutSet(HistoryVO historyVO, Map<String, Object> param) throws Exception {
		Map<String, Object> result = null;

		Map<String, Object> agentList = null;

		try {
			//구분값 : yyyMMddHHmmss
			SimpleDateFormat formatDate = new SimpleDateFormat ( "yyyMMddHHmmss");
			Date time = new Date();
			String timeId = formatDate.format(time);

			param.put("search_gbn", "");
			param.put("instance_id", "");         //확인완료
			param.put("process_id", timeId);
			param.put("monitering", "monitering");

			agentList = scaleInAgent(param);
			
			if (agentList == null) {
				result.put("RESULT", "FAIL");
			} else {
				result = agentList;
			}
			
		} catch (Exception e) {
			result.put("RESULT", "FAIL");
			e.printStackTrace();
		}

		return result;
	}

	/**
	 * 전송 cmd 값 setting
	 * 
	 * @return String
	 * @throws IOException  
	 * @throws FileNotFoundException 
	 * @throws Exception
	 */
	public String scaleCmdSetting(JSONObject obj) throws FileNotFoundException, IOException {
		Properties props = new Properties();
		props.load(new FileInputStream(ResourceUtils.getFile("classpath:egovframework/tcontrolProps/globals.properties")));	

		String scale_path = "";
		String strCmd = "";
		String strSubCmd = "";

		//구분값 : yyyMMddHHmmss
		SimpleDateFormat formatDate = new SimpleDateFormat ( "yyyMMddHHmmss");
		Date time = new Date();
		String timeId = formatDate.format(time);

		//String scaleServer = (String)props.get("scale_server");

		//명령어 setting
		String scaleSet = obj.get("scale_set").toString();
		String searchGbn = obj.get("search_gbn").toString();
		String instanceId = obj.get("instance_id").toString();   //확인완료
		String moniteringGbn = obj.get("monitering").toString();
		String scale_count = obj.get("scale_count").toString();
		int scale_exe_count = 1;
		
		if (scale_count != null && !"".equals(scale_count)) {
			scale_exe_count = Integer.parseInt(scale_count);
		}

		if (!moniteringGbn.equals("")) {
			scaleSet = moniteringGbn;
		}

		//scale 실행
		if (!scaleSet.isEmpty()) {
			if ("scaleIn".equals(scaleSet)) {
				if (scale_exe_count <= 1) { //one
					if (props.get("scale_in_cmd") != null) {
						scale_path = props.get("scale_in_cmd").toString();
					}

					strCmd = String.format(scale_path + " ", timeId);
				} else { //multi
					if (props.get("scale_in_multi_cmd") != null) {
						scale_path = props.get("scale_in_multi_cmd").toString();
					}

					timeId = scale_exe_count + " -id " + timeId;
					strCmd = String.format(scale_path + " ", timeId) + "      ";
					
				//	strCmd += strCmd + " >> ./out.log"; //log파일 생성
					strCmd += strCmd + " > /dev/null ";  //의미없는 표준출력 넣어서 일단 돌아가게 만듬
				}
			} else if ("scaleOut".equals(scaleSet)) {
/*				if (scale_exe_count <= 1) { //one
					scale_path = props.get("scale_out_cmd").toString();
					strCmd = String.format(scale_path + " ", timeId);
				} else {*/ //multi
					if (props.get("scale_out_multi_cmd") != null) {
						scale_path = props.get("scale_out_multi_cmd").toString();
					}

					timeId = scale_exe_count + " -id " + timeId;
					strCmd = String.format(scale_path + " ", timeId);
/*				}*/
			} else if ("monitering".equals(scaleSet)) {
				if (props.get("scale_chk_prgress") != null) {
					scale_path = props.get("scale_chk_prgress").toString();
				}
				
				if (scale_exe_count <= 1) { //one
					strCmd = String.format(scale_path + " ", timeId);
				} else { //multi
					strCmd = String.format(scale_path + " ", "scale-");
				}
			}
		} else {
			if (searchGbn.equals("scaleChk") && (obj.get("scaleChk_sub") != null && obj.get("scaleChk_sub").toString().equals("Y"))) {
				if (props.get("scale_chk_prgress") != null) {
					strSubCmd = props.get("scale_chk_prgress").toString();
				}

				strCmd = String.format(strSubCmd, "scale-");
				
			} else if (searchGbn.equals("scaleAwsChk")) { //설치여부 체크
				//strCmd = "which aws";
				strCmd = "whereis -b aws";
			} else {
				if (props.get("scale_json_view") != null) {
					strCmd = props.get("scale_json_view").toString();
				}

				if ("main".equals(searchGbn)) {
					//strSubCmd = "--query 'sort_by\"(Reservations[*].Instances[].{LaunchTime:LaunchTime, InstanceId:InstanceId, PublicDnsName:PublicDnsName,PublicIpAddress:PublicIpAddress,PrivateIpAddress:PrivateIpAddress,PrivateDnsName:PrivateDnsName,KeyName:KeyName,InstanceType:InstanceType,MonitoringState:Monitoring.State,InstanceStatusName:State.Name, AvailabilityZone:Placement.AvailabilityZone, SecurityGroups:SecurityGroups[], TagsName:Tags[?Key==\\`Name\\`] | [0].Value}[], &LaunchTime)\"'";
					strSubCmd = "--query \"sort_by(Reservations[*].Instances[].{LaunchTime:LaunchTime, InstanceId:InstanceId, PublicDnsName:PublicDnsName,PublicIpAddress:PublicIpAddress,PrivateIpAddress:PrivateIpAddress,PrivateDnsName:PrivateDnsName,KeyName:KeyName,InstanceType:InstanceType,MonitoringState:Monitoring.State,InstanceStatusName:State.Name, AvailabilityZone:Placement.AvailabilityZone, SecurityGroups:SecurityGroups[], TagsName:Tags[?Key==\\`Name\\`] | [0].Value}[], &LaunchTime)\"";
				} else if (searchGbn.equals("scaleChk") && (obj.get("scaleChk_sub") == null || obj.get("scaleChk_sub").toString().equals(""))) {
					strSubCmd = "--query \"Reservations[*].Instances[].{InstanceId:InstanceId, InstanceStatusName:State.Name, TagsName:Tags[?Key==\\`Name\\`] | [0].Value}[]\"";
				} else if ("instanceCnt".equals(searchGbn)) {
					strSubCmd = "--query \"Reservations[*].Instances[].{InstanceId:InstanceId,PrivateIpAddress:PrivateIpAddress}[]\"";
				}
				
				strCmd = String.format(strCmd, strSubCmd);
				
				if ("instanceCnt".equals(searchGbn)) {
					strCmd = strCmd + " \"Name=instance-state-name,Values=running\"";
				}

				if (instanceId != null && !"".equals(instanceId)) {
					strCmd = strCmd + " \"Name=instance-id,Values=" + instanceId + "*\"";
				}

				if (searchGbn.equals("scaleChk") && (obj.get("scaleChk_sub") == null || obj.get("scaleChk_sub").toString().equals(""))) {
					strCmd = strCmd + " \"Name=instance-state-name,Values=pending,shutting-down\"";
				}
			}
		}

		return strCmd;
	}

	/**
	 * scale 화면 접속 히스토리 등록
	 * 
	 * @param request, historyVO, dtlCd
	 * @throws Exception
	 */
	@Override
	public void scaleSaveHistory(HttpServletRequest request, HistoryVO historyVO, String dtlCd) throws Exception {
		CmmnUtils.saveHistory(request, historyVO);
		historyVO.setExe_dtl_cd(dtlCd);
		accessHistoryDAO.insertHistory(historyVO);
	}

	/**
	 * scale log search
	 * 
	 * @param instanceScaleVO
	 * @throws Exception 
	 */
	@Override
	public Map<String, Object> selectScaleLog(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return (Map<String, Object>) instanceScaleDAO.selectScaleLog(param);
	}

	/**
	 * 현재시간 조회
	 * 
	 * @return String
	 * @throws Exception
	 */
	public static String nowTime(){
		Calendar calendar = Calendar.getInstance();
		java.util.Date date = calendar.getTime();
		String today = (new SimpleDateFormat("yyyyMMddHHmmss").format(date));
		return today;
	}

	/**
	 * scale agent 전송
	 * 
	 * @param instanceScaleVO
	 * @throws Exception 
	 */
	public Map<String, Object> scaleInAgent(Map<String, Object> param) throws Exception {
		Map<String, Object> result = new HashMap<String, Object>();
		List<Map<String, Object>> dbResult = null;
		JSONObject obj = new JSONObject();
		
		int db_svr_id = Integer.parseInt(param.get("db_svr_id").toString());
		String scale_set = param.get("scale_set").toString();
		String scale_count = param.get("scale_count").toString();
		int iScale_count = 0;
		
		if (scale_count != null) {
			if (!"".equals(scale_count)) {
				iScale_count = Integer.parseInt(scale_count);
			}
		}
		
		String login_id_prm = "";
		String instance_id_prm = "";
		String search_gbn_prm = "";
		String process_id_prm ="";

		try {
			if (param.get("login_id") != null) {
				login_id_prm = param.get("login_id").toString();
			}
			
			if (param.get("instance_id") != null) {
				instance_id_prm = param.get("instance_id").toString();
			}
			
			if (param.get("search_gbn") != null) {
				search_gbn_prm = param.get("search_gbn").toString();
			}
			
			if (param.get("process_id") != null) {
				process_id_prm = param.get("process_id").toString();
			}

			obj.put("scale_set", scale_set);
			obj.put("login_id", login_id_prm);
			obj.put("instance_id", instance_id_prm);  //확인완료
			obj.put("search_gbn", search_gbn_prm);
			obj.put("process_id", process_id_prm);
			obj.put("db_svr_id", db_svr_id);
			obj.put("monitering", "");
			obj.put("scaleChk_sub", "");

			//추가 - 수동 scale 실행 cnt
			obj.put("scale_count", iScale_count);

			if (!scale_set.equals("")) {
				dbResult = instanceScaleDAO.selectSvrIpadrList(db_svr_id);
				if (!dbResult.isEmpty()) {
					obj.put("db_svr_ipadr_id", dbResult.get(0).get("db_svr_ipadr_id"));
				} else {
					obj.put("db_svr_ipadr_id", 1);
				}
			} else {
				obj.put("db_svr_ipadr_id", 1);
			}

			/* db 서버 조회 */
			DbServerVO schDbServerVO = new DbServerVO();
			schDbServerVO.setDb_svr_id(db_svr_id);
			DbServerVO dbServerVO = (DbServerVO) cmmnServerInfoDAO.selectServerInfo(schDbServerVO);

			/* agnet 정보조회  */
			String strIpAdr = dbServerVO.getIpadr();
			AgentInfoVO vo = new AgentInfoVO();
			vo.setIPADR(strIpAdr);
			AgentInfoVO agentInfo = (AgentInfoVO) cmmnServerInfoDAO.selectAgentInfo(vo);

			String IP = dbServerVO.getIpadr();
			int PORT = agentInfo.getSOCKET_PORT();

			//cmd 값 셋팅
			String agentCmd = scaleCmdSetting(obj);

System.out.println("agentCmd 명령어 호출 :::::::::" + agentCmd);
			
			String agentSubCmd = "";
			if (param.get("monitering") != null || param.get("search_gbn").toString().equals("scaleChk")) {
				obj.put("monitering", param.get("monitering").toString());
				obj.put("scaleChk_sub", "Y");
				agentSubCmd = scaleCmdSetting(obj);
			}

			ClientInfoCmmn cic = new ClientInfoCmmn();
			result = cic.scale_exec_call(IP, PORT, agentCmd, agentSubCmd, obj);

			System.out.println("결과");
			System.out.println(result.get("RESULT_CODE"));
			System.out.println(result.get("ERR_CODE"));
			System.out.println(result.get("ERR_MSG"));

		} catch (Exception e) {
			result.put("RESULT", "FAIL");
			e.printStackTrace();
		}
		return result;
	}

	/**
	 * scale list setting
	 * 
	 * @param instanceScaleVO
	 * @throws Exception 
	 */
	@Override
	public int dashboardInstanceScale(int db_svr_id) throws Exception {
		Map<String, Object> param = new HashMap<String, Object>();
		
		String resultChk = "instanceCnt";
		Map<String, Object> result = new JSONObject();
		JSONObject scalejsonObj = new JSONObject();
		JSONArray InstancesArrly = new JSONArray();
		int iNumCnt = 0;
		String stateChk = "";

		try {
			//현재 instance 수
			if ("instanceCnt".equals(resultChk)) {
				Map<String, Object> agentList = null;

				param.put("search_gbn", "instanceCnt");
				param.put("scale_set", "");
				param.put("login_id", "");
				param.put("instance_id", "");           //확인완료
				param.put("db_svr_id", db_svr_id);
				param.put("process_id", "");
				param.put("monitering", "");
				param.put("scale_count", "");

				agentList = scaleInAgent(param);

				if (!agentList.isEmpty()) {
					String resultCode = (String)agentList.get(ClientProtocolID.RESULT_CODE);

					if (resultCode.equals("0")) {
						scalejsonObj = (JSONObject)agentList.get(ClientProtocolID.RESULT_DATA);
					}
				}

				if (!scalejsonObj.isEmpty()) {
					InstancesArrly = (JSONArray) scalejsonObj.get("Instances");

					if (InstancesArrly != null) {
						iNumCnt = InstancesArrly.size();
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return iNumCnt;
	}
	
	/**
	 * scale Auto 사용여부 setting 수정
	 * 
	 * @param instanceScaleVO
	 * @throws Exception 
	 */
	@Override
	public String updateAutoScaleUseSetting(InstanceScaleVO instanceScaleVO) throws Exception {
		String result = "fail";

		try{
			instanceScaleDAO.updateAutoScaleUseSetting(instanceScaleVO);
			
			result = "success";
		} catch (Exception e) {
			result = "fail";
			e.printStackTrace();
		}

		return result;
	}
	
	/**
	 * 숫자인지 확인
	 */
	public static boolean isInteger(String s) {
	    try { 
	        Integer.parseInt(s); 
	    } catch(NumberFormatException e) { 
	        return false; 
	    } catch(NullPointerException e) {
	        return false;
	    }
	    return true;
	}
}