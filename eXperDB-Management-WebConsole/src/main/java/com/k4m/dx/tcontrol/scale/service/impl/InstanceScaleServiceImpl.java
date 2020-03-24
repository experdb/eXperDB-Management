package com.k4m.dx.tcontrol.scale.service.impl;

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Set;
import java.util.TreeMap;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.codehaus.jackson.map.ObjectMapper;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.stereotype.Service;
import org.springframework.util.ResourceUtils;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.k4m.dx.tcontrol.admin.accesshistory.service.impl.AccessHistoryDAO;
import com.k4m.dx.tcontrol.cmmn.CmmnUtils;
import com.k4m.dx.tcontrol.common.service.HistoryVO;
import com.k4m.dx.tcontrol.login.service.LoginVO;
import com.k4m.dx.tcontrol.scale.cmmn.InstanceScaleConnect;
import com.k4m.dx.tcontrol.scale.service.InstanceScaleService;
import com.k4m.dx.tcontrol.scale.service.InstanceScaleVO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import net.sf.json.JSONException;

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

	/**
	 * scale 로그조회
	 * 
	 * @param param
	 * @throws Exception
	 */
	@Override
	public Map<String, Object> scaleSetResult(HttpServletRequest request) throws Exception {
		Map<String, Object> param = new HashMap<String, Object>();
		Map<String, Object> result = new JSONObject();
		
		HttpSession session = request.getSession();
		LoginVO loginVo = (LoginVO) session.getAttribute("session");
		String id = loginVo.getUsr_id();

		try {
			//scale load 상태보기
			param.put("frst_regr_id", id);
			result = (Map<String, Object>)instanceScaleDAO.selectScaleLog(param);
		} catch (SQLException e) {
			e.printStackTrace();
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
		JSONObject obj = new JSONObject();

		try {
			obj.put("scale_gbn", param.get("scale_gbn"));
			obj.put("login_id", param.get("login_id"));
			result  = new ObjectMapper().readValue(InstanceScaleConnect.scaleSetStart(obj).toJSONString(), Map.class);
		} catch (Exception e) {
			result.put("RESULT", "FAIL");
			e.printStackTrace();
		}
		
		return result;
	}

	/**
	 * scale 완료 log 조회
	 * 
	 * @param loginId, timeId
	 * @throws Exception
	 */
	@Override
	public Map<String, Object> scaleThreadLogSetResult(String loginId, String timeId) throws Exception {

		Map<String, Object> param = new HashMap<String, Object>();
		Map<String, Object> result = new JSONObject();

		try {
			//scale load 상태보기
			param.put("frst_regr_id", loginId);
			param.put("instance_id", timeId);
			result = (Map<String, Object>)instanceScaleDAO.selectScaleLog(param);
		} catch (SQLException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return result;
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
	 * scale 보안그룹 상세조회
	 * 
	 * @param instanceScaleVO
	 * @throws FileNotFoundException, IOException, ParseException
	 */
	@Override
	public JSONObject instanceSecurityListSetting(InstanceScaleVO instanceScaleVO) throws FileNotFoundException, IOException, ParseException {
		JSONObject result = new JSONObject();
		JSONArray jsonArray = new JSONArray(); // 객체를 담기위해 JSONArray 선언.
		JSONArray scaleArrly = new JSONArray();
		Set key = null;
		Iterator<String> iter = null;
		String scaleId = (String)instanceScaleVO.getScale_id();

		JSONParser jParser = new JSONParser();
		JSONObject scalejsonObj = new JSONObject();

		Properties props = new Properties();
		props.load(new FileInputStream(ResourceUtils.getFile("classpath:egovframework/tcontrolProps/globals.properties")));		

		String scale_path = props.get("scale_path").toString();
		scale_path = scale_path + "instance_list.json";

		try {
			//나중에는 aws로 변경해야함
			FileReader fileReader = new FileReader(scale_path);
			if (fileReader != null) {
				Object scaleObj = jParser.parse(fileReader);
				scalejsonObj = (JSONObject)scaleObj;
				scaleArrly = (JSONArray) scalejsonObj.get("Reservations");

				if (scaleArrly != null) {
					for (int i = 0; i < scaleArrly.size(); i++) {
						String instantsIdChk = "";
						JSONObject jsonObj = new JSONObject();
						JSONObject scaleSubObj = (JSONObject)scaleArrly.get(i);
						JSONArray InstancesArrly = (JSONArray) scaleSubObj.get("Instances");

						if (InstancesArrly != null) {
							for (int j = 0; j < InstancesArrly.size(); j++) {
								JSONObject instancesObj = (JSONObject)InstancesArrly.get(j);
								
								instantsIdChk = (String) instancesObj.get("InstanceId");

								JSONArray securityGroupsArrly = (JSONArray) instancesObj.get("SecurityGroups");     //보안그룹

								/* securityGroupsArrly start */
								if (securityGroupsArrly != null) {
									for (int k = 0; k < securityGroupsArrly.size(); k++) {
										JSONObject securityGroupObj = (JSONObject)securityGroupsArrly.get(k);

										jsonObj.put("security_group_nm", securityGroupObj.get("GroupName").toString());
										jsonObj.put("security_group_id", securityGroupObj.get("GroupId").toString());

										if (scaleId != null && !"".equals(scaleId)) {
											if (instantsIdChk.equals(scaleId)) {
												jsonArray.add(jsonObj);
											}
										} else {
											jsonArray.add(jsonObj);
										}
									}
								}
								/* securityGroupsArrly end */
							}
						}
					}

					result.put("data", jsonArray);
				}
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
		scalejsonObj = scaleJsonDownSearch("", scaleId);

		try {
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
								jsonObj.put("instance_id", instantsIdChk);                									//인스턴트 id
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
							    String startTime = LaunchTimeStr;
							    String lang = props.get("lang").toString();
							
								if (!lang.equals("ko")) {startTime = startTime + " UTC+9";}
								jsonObj.put("start_time", startTime);
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
							jsonObj.put("instance_id", null);				//인스턴트 id
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
	 * scale list setting
	 * 
	 * @param instanceScaleVO
	 * @throws Exception 
	 */
	@Override
	public JSONObject instanceListSetting(InstanceScaleVO instanceScaleVO) throws Exception {
		JSONObject result = new JSONObject();
		JSONArray jsonArray = new JSONArray(); // 객체를 담기위해 JSONArray 선언.
		JSONArray InstancesArrly = new JSONArray();

		Set key = null;
		Iterator<String> iter = null;
		String scaleId = (String)instanceScaleVO.getScale_id();
		JSONObject scalejsonObj = new JSONObject();
		String stateChk = "";

		Properties props = new Properties();
		props.load(new FileInputStream(ResourceUtils.getFile("classpath:egovframework/tcontrolProps/globals.properties")));		
		scalejsonObj = scaleJsonDownSearch("main", scaleId);

		try {			
			if (!scalejsonObj.isEmpty()) {
				InstancesArrly = (JSONArray) scalejsonObj.get("Instances");
	
				int iNumCnt = 0;
				
				if (InstancesArrly != null) {
					for (int j = 0; j < InstancesArrly.size(); j++) {
						JSONObject jsonObj = new JSONObject();
						JSONObject instancesObj = (JSONObject)InstancesArrly.get(j);
						
						JSONArray securityGroupsArrly = (JSONArray) instancesObj.get("SecurityGroups");     //보안그룹

						jsonObj.put("public_IPv4", (String) instancesObj.get("PublicDnsName"));             //public dns IPv4
						jsonObj.put("IPv4_public_ip", (String) instancesObj.get("PublicIpAddress"));        //IPv4 IP
						jsonObj.put("private_ip_address", (String) instancesObj.get("PrivateIpAddress"));   //private_IP

						jsonObj.put("instance_id", instancesObj.get("InstanceId"));                //인스턴트 id
						jsonObj.put("private_dns_name", (String) instancesObj.get("PrivateDnsName"));       //private_dna_name
						jsonObj.put("key_name", (String) instancesObj.get("KeyName"));                      //키이름
						jsonObj.put("instance_type", (String) instancesObj.get("InstanceType"));            //인스턴트 타입
						
						/* start time */
						String LaunchTimeStr = (String) instancesObj.get("LaunchTime");  //시작일자
						//    LocalDateTime launchDateTime = LocalDateTime.from(Instant.from(DateTimeFormatter.ISO_DATE_TIME.parse(LaunchTimeStr)).atZone(ZoneId.of("Asia/Seoul")));
						//   String startTime = launchDateTime.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
					    String startTime = LaunchTimeStr;

						String lang = props.get("lang").toString();

						if (!lang.equals("ko")) {startTime = startTime + " UTC+9";}
						jsonObj.put("start_time", startTime);
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
	 * scale log insert data setting
	 * 
	 * @param instanceScaleVO
	 * @throws Exception 
	 */
	@Override
	public void insertScaleSetLog(Map<String, Object> param) throws Exception {
		Map<String, Object> logParam = new HashMap<String, Object>();

		try {
			//param값 null이 아닐경우만 log저장
			if (param != null) {
				String scaleGbn = param.get("scale_gbn").toString();
				
				if ("fileDown".equals(scaleGbn)) {  //wrk_id, scale_gbn setting
					logParam.put("wrk_id", 2);
					logParam.put("scale_gbn", 3);
				} else {
					if ("scaleIn".equals(scaleGbn)) {  //scale_gbn setting
						logParam.put("scale_gbn", "1");
					} else {
						logParam.put("scale_gbn", "2");
					}
					
					logParam.put("wrk_id", 1);
				}
	
				logParam.put("wrk_strt_dtm", param.get("RESULT_startTime"));
				logParam.put("wrk_end_dtm", param.get("RESULT_endTime"));
	
				if(param.get("RESULT").equals("SUCCESS")){
					logParam.put("exe_rslt_cd", "TC001701");
				}else{
					logParam.put("exe_rslt_cd", "TC001702");
				}
				
				if (param.get("RESULT_MSG") != null) {
					if (param.get("RESULT_MSG").toString().length() > 1000) {
						logParam.put("rslt_msg", param.get("RESULT_MSG").toString().substring(0, 1000));
					} else {
						logParam.put("rslt_msg", param.get("RESULT_MSG").toString());
					}
				} else {
					logParam.put("rslt_msg", "");
				}
	
				logParam.put("frst_regr_id", param.get("login_id"));
				logParam.put("lst_mdfr_id", param.get("login_id"));
				
				//차후 추가
				logParam.put("instance_id", param.get("instance_id"));
				logParam.put("instance_nm", "");
	
				//history 등록
				instanceScaleDAO.insertScaleLog(logParam);
			}
		} catch(SQLException e) {
			e.printStackTrace();
		}
	}

	/**
	 * scale log insert
	 * 
	 * @param instanceScaleVO
	 * @throws Exception 
	 */
	@Override
	public void scaleThreadLogSave(String timeId, String scaleGbn, String loginId, String logGbn, Map<String, Object> jParam) throws Exception {
		Map<String, Object> logParam = new HashMap<String, Object>();
		
		try {
			if ("insert".equals(logGbn)) {
				
				if ("fileDown".equals(scaleGbn)) {

					if (!jParam.isEmpty()) {
				    	logParam.put("RESULT_CODE", jParam.get("RESULT_CODE"));
				    	logParam.put("RESULT", jParam.get("RESULT"));
				    	
				    	String resultMsg = (String)jParam.get("RESULT_MSG");
				    	if (resultMsg == null || "".equals(resultMsg)) {
				    		resultMsg = "SUCCESS";
				    	}
				    	
				    	logParam.put("RESULT_MSG", resultMsg);
					} else {
				    	logParam.put("RESULT_CODE", 1);
				    	logParam.put("RESULT", "FAIL");
				    	logParam.put("RESULT_MSG", "FAIL");
					}
				} else {
					if (!jParam.isEmpty()) {
				    	String errorChkMsg = (String)jParam.get("errorChk");
				    	if ("error".equals(errorChkMsg)) {
					    	logParam.put("RESULT_CODE", 1);
					    	logParam.put("RESULT", "FAIL");
					    	logParam.put("RESULT_MSG", "FAIL");
				    	} else {
					    	logParam.put("RESULT_CODE", 0);
					    	logParam.put("RESULT", "SUCCESS");
					    	logParam.put("RESULT_MSG", "SUCCESS");
				    	}
					} else {
				    	logParam.put("RESULT_CODE", 0);
				    	logParam.put("RESULT", "SUCCESS");
				    	logParam.put("RESULT_MSG", "SUCCESS");
					}
				}
		    	logParam.put("RESULT_startTime", nowTime());
		    	logParam.put("RESULT_endTime", nowTime());
		    	logParam.put("login_id", loginId);
		    	logParam.put("scale_gbn", scaleGbn);
		    	logParam.put("instance_id", timeId);

				if ("fileDown".equals(scaleGbn)) {
					if (!jParam.isEmpty()) {
				    	insertScaleSetLog(logParam);
					}
				} else {
			    	insertScaleSetLog(logParam);
				}
			} else {
		    	logParam.put("login_id", loginId);
		    	logParam.put("instance_id", timeId);
		    	logParam.put("wrk_id", 2);
		    	
				//log 수정
				instanceScaleDAO.updateScaleLog(logParam);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
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
	 * scale 실시간 조회
	 * 
	 * @param instanceScaleVO
	 * @throws Exception 
	 */
	public JSONObject scaleJsonDownSearch(String searchGbn, String param) throws Exception {//json 다운
		Gson gson = (new GsonBuilder()).excludeFieldsWithoutExposeAnnotation().create();
		Map<String, Object> logParam = new HashMap<String, Object>();
		Process pJson = null;
        StringBuffer successOutput = new StringBuffer(); // 성공 스트링 버퍼
        StringBuffer errorOutput = new StringBuffer(); // 오류 스트링 버퍼
        BufferedReader successBufferReader = null; // 성공 버퍼
        BufferedReader errorBufferReader = null; // 오류 버퍼
        JSONObject jsonObj = new JSONObject(new TreeMap ());
        JSONParser parser = new JSONParser();
        JSONArray mArray = new JSONArray();
        
        String jsonMsg = "";
        String strSubCmd = "";
        
        String msg = null;
		
		Properties props = new Properties();
		props.load(new FileInputStream(ResourceUtils.getFile("classpath:egovframework/tcontrolProps/globals.properties")));	
		String strCmd = props.get("scale_json_view").toString();
		String scaleServer = props.get("scale_seach_server").toString();
		
		if (searchGbn.equals("main")) {
			strSubCmd = "--query 'sort_by\"(Reservations[*].Instances[].{LaunchTime:LaunchTime, InstanceId:InstanceId, PublicDnsName:PublicDnsName,PublicIpAddress:PublicIpAddress,PrivateIpAddress:PrivateIpAddress,PrivateDnsName:PrivateDnsName,KeyName:KeyName,InstanceType:InstanceType,MonitoringState:Monitoring.State,InstanceStatusName:State.Name, AvailabilityZone:Placement.AvailabilityZone, SecurityGroups:SecurityGroups[], TagsName:Tags[?Key==\\`Name\\`] | [0].Value}[], &LaunchTime)\"'";
		}

		strCmd = String.format(strCmd, strSubCmd);
		if (param != null && !"".equals(param)) {
			strCmd = strCmd + " \"Name=instance-id,Values=" + param + "*\"";
		} 
	
		Runtime runtime = Runtime.getRuntime();

		String[] cmdPw = {"/bin/sh","-c",scaleServer + " " + strCmd};

        try {   
			// 명령어 실행
            pJson = runtime.exec(cmdPw); 

            // shell 실행이 정상 동작했을 경우
            successBufferReader = new BufferedReader(new InputStreamReader(pJson.getInputStream()));

            while ((msg = successBufferReader.readLine()) != null) {
                successOutput.append(msg + System.getProperty("line.separator"));
            }
 
            // shell 실행시 에러가 발생했을 경우
            errorBufferReader = new BufferedReader(new InputStreamReader(pJson.getErrorStream()));
            while ((msg = errorBufferReader.readLine()) != null) {
                errorOutput.append(msg + System.getProperty("line.separator"));
            } 
 
            // 프로세스의 수행이 끝날때까지 대기
            pJson.waitFor();

            if (!successOutput.toString().isEmpty()) {
        		if (searchGbn.equals("main")) {
        			jsonMsg = "{ \"Instances\":" + successOutput.toString() + "}";
        		} else {
        			jsonMsg = successOutput.toString();
        		}
    			Object obj = parser.parse( jsonMsg);
    			jsonObj = (JSONObject) obj;
            }

            return jsonObj;

        } catch (IOException e) {
            e.printStackTrace();
        } catch (InterruptedException e) {
            e.printStackTrace();
        } finally {
            try {
            	pJson.destroy();
                if (successBufferReader != null) successBufferReader.close();
                if (errorBufferReader != null) errorBufferReader.close();
            } catch (IOException e1) {
                e1.printStackTrace();
            }
        }
		return jsonObj;
	}
}