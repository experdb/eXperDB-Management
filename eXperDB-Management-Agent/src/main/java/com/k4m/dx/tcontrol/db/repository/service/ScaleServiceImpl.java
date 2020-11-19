package com.k4m.dx.tcontrol.db.repository.service;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.math.BigDecimal;
import java.net.Socket;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.stereotype.Service;

import com.k4m.dx.tcontrol.db.repository.dao.ScaleDAO;
import com.k4m.dx.tcontrol.db.repository.vo.DbServerInfoVO;
import com.k4m.dx.tcontrol.socket.ProtocolID;
import com.k4m.dx.tcontrol.socket.SocketCtl;
import com.k4m.dx.tcontrol.socket.listener.DXTcontrolScaleAwsExecute;
import com.k4m.dx.tcontrol.util.FileUtil;
import com.k4m.dx.tcontrol.util.RunCommandExec;

/**
* @author 박태혁
* @see
* 
*      <pre>
* == 개정이력(Modification Information) ==
*
*   수정일       수정자           수정내용
*  -------     --------    ---------------------------
*  2018.04.23   박태혁 최초 생성
*      </pre>
*/
@Service("ScaleService")
public class ScaleServiceImpl extends SocketCtl implements ScaleService{

	@Resource(name = "ScaleDAO")
	private ScaleDAO scaleDAO;
	
	private Logger errLogger = LoggerFactory.getLogger("errorToFile");
	private Logger socketLogger = LoggerFactory.getLogger("socketLogger");
	private static ApplicationContext context;
	private String loginId = "admin";

	/* scale log insert */
	public void insertScaleLog_G(Map<String, Object> param)  throws Exception{
		if (param != null) {
			if (param.get("saveGbn").toString().equals("insert")) {
				scaleDAO.insertScaleLog_G(param);
			} else {
				if (param.get("return_val") != null) {
					scaleDAO.updateScaleLog_G(param);
				}
			}
		}
	}

	/* scale loding log insert */
	public void insertScaleLoadLog_G(Map<String, Object> param)  throws Exception{
		if (param != null) {
			scaleDAO.insertScaleLoadLog_G(param);
		}
	}

	/* scale loding log insert */
	public void deleteScaleLoadLog_G(Map<String, Object> param)  throws Exception{
		if (param != null) {
			scaleDAO.deleteScaleLoadLog_G(param);
		}
	}

	/* scale Auto 설정 count */
	public int selectScaleITotCnt(Map<String, Object> param) throws Exception {
		return scaleDAO.selectScaleITotCnt(param);
	}

	/* scale load table seq 조회 */
	public long selectQ_T_SCALELOADLOG_G_01_SEQ() throws Exception  {
		return (long) scaleDAO.selectQ_T_SCALELOADLOG_G_01_SEQ();
	}

	/* scale loding log table 시퀀스 초기화 */
	public void deleteScaleLoadSEQ()  throws Exception{
		scaleDAO.deleteScaleLoadSEQ();
	}

	/* monitoring cpu_mem 사용량 조회록  */
	public Map<String, Object> selectMonitorInfo(Map<String, Object> param)  throws Exception{
		return  (Map<String, Object>)scaleDAO.selectMonitorInfo(param);
	}

	/* 에이전트 비정상 연결실패  */
	public Map<String, Object> selectConnectionFailure(Map<String, Object> param)  throws Exception{
		return  (Map<String, Object>)scaleDAO.selectConnectionFailure(param);
	}


	/* lastLoad값 받기  */
	public String lastNodeCntSearch() throws Exception {
		String scaleMainCmd = "";
		String scale_path = "";
		String lastNodeCnt = "0";

		try {
			scale_path = FileUtil.getPropertyValue("context.properties", "agent.scale_path");
			
			//scaleMainCmd = "psql -c \"select conninfo from nodes where type = 'primary' ; \" -t -d repmgr -U repmgr | grep -v conninfo | grep -v row  | sed \"s/host=//\" | awk '{print $1}'";
			scaleMainCmd = "cat " + scale_path + "/setting.json";
			RunCommandExec rMain = new RunCommandExec(scaleMainCmd);
			//명령어 실행
			rMain.run();

			try {
				rMain.join();
			} catch (InterruptedException ie) {
				ie.printStackTrace();
			}

			String strResultMessgeMain = rMain.getMessage();

			if (!"".equals(strResultMessgeMain)) {
				JSONParser parser = new JSONParser();
				Object obj = parser.parse( strResultMessgeMain );
				JSONObject jsonObj = (JSONObject) obj;
				
				String lastNodeCntStr = (String) jsonObj.get("staticLastNode");

				if (!"".equals(lastNodeCntStr)) {
					lastNodeCnt = lastNodeCntStr;
				}
			}
		} catch (Exception ie) {
			ie.printStackTrace();
		}

		return lastNodeCnt;
	}
	
	/* 비정상종료 scale in 실행 */
	public String failedScaleExecute(Map<String, Object> param) throws Exception {
		JSONObject jObjResult = null;
		String result = "failed";

		try {
			Map<String, Object> scaleparam = new HashMap<String, Object>();
			Map<String, Object> logParam = new HashMap<String, Object>();
			
			SimpleDateFormat formatDate = new SimpleDateFormat ( "yyyMMddHHmmss");
			Date time = new Date();
			String timeId = formatDate.format(time);
			
	    	String clusterChk = "success";
	    	int expansion_clusters = 1;
	    	
	    	int scaleLastNodeCnt = 0;
	    	String scaleLastNode = lastNodeCntSearch();

	    	if (scaleLastNode != null && !"".equals(scaleLastNode)) {
	    		scaleLastNodeCnt = Integer.parseInt(scaleLastNode);
	    	}
	    	
	    	//현재 인스턴스 갯수
	    	//최종 갯수보다 작거나 같으면 실행 중지
	    	int jObjCnt = scaleInstanceCnt(client, is, os);
			if (jObjCnt <= scaleLastNodeCnt) {
				clusterChk = "scale-in_fail";
			}
			
			//scale 실행
			if ("success".equals(clusterChk)) {
				//process_id 셋팅
				scaleparam.put("process_id", timeId);

				scaleparam.put("auto_policy", "");
				scaleparam.put("auto_policy_set_div", "");
				scaleparam.put("auto_policy_time", "");
				scaleparam.put("auto_level", "");
	
				jObjResult = this.scaleAwsConnect(scaleparam, "scaleIn", expansion_clusters, client, is, os);
				
				result = "success";
			} else {
				//실패시 실행이력 오류 insert만 하고 auto-scale 안함
				if (!"".equals(clusterChk)) {
					logParam = logSetting(scaleparam, timeId, "insert", clusterChk, 0);
					this.insertScaleLog_G(logParam);
				}
				result = "failed";
			}
		} catch (Exception e) {
			errLogger.error("비정상종료 scale in 실행중 오류가 발생하였습니다. {}", e.toString());
			e.printStackTrace();
		}

		return result;
		
	}

	/* auto scale 실행 */
	public List<Map<String, Object>> autoScaleExecute(Map<String, Object> param) throws Exception {
		List<Map<String, Object>> setResult = null;
		JSONObject jObjResult = null;

		//1. 설정에 입력된 값을 select
		try {
			setResult = scaleDAO.selectScaleCngList(param);
			Map<String, Object> scaleparam = new HashMap<String, Object>();
			Map<String, Object> logParam = new HashMap<String, Object>();
			
			SimpleDateFormat formatDate = new SimpleDateFormat ( "yyyMMddHHmmss");
			Date time = new Date();
			String timeId = formatDate.format(time);

			//설정이 있는 경우만 실행
			if (setResult.size() > 0) {
		    	int scaleLastNodeCnt = 0;
		    	String scaleLastNode = lastNodeCntSearch();

		    	if (scaleLastNode != null && !"".equals(scaleLastNode)) {
		    		scaleLastNodeCnt = Integer.parseInt(scaleLastNode);
		    	}

				for (int i = 0; i < setResult.size(); i++) {
					Map<String, Object> scaleChkData = null;

					scaleparam = (Map<String, Object>) setResult.get(i);
					
					String scale_type_cd  = (String) scaleparam.get("scale_type");
							
					int auto_policy_time = ((BigDecimal) scaleparam.get("auto_policy_time")).intValue();

					scaleparam.put("auto_policy_time_pm", auto_policy_time + " minute");
					scaleparam.put("auto_policy_time", auto_policy_time);
					
					BigDecimal expansion_clusters_big = (BigDecimal) scaleparam.get("expansion_clusters");
					int expansion_clusters = 0;
					if (expansion_clusters_big != null) {
						expansion_clusters = expansion_clusters_big.intValue();
					}

					BigDecimal min_clusters_big = (BigDecimal) scaleparam.get("min_clusters");
					int min_clusters = 0;
					if (min_clusters_big != null) {
						min_clusters = min_clusters_big.intValue();
					}
					
					BigDecimal max_clusters_big = (BigDecimal) scaleparam.get("max_clusters");
					int max_clusters = 0;
					if (max_clusters_big != null) {
						max_clusters = max_clusters_big.intValue();
					}
					
					scaleparam.put("expansion_clusters", expansion_clusters);
					scaleparam.put("min_clusters", min_clusters);
					scaleparam.put("max_clusters", max_clusters);

					scaleChkData = scaleDAO.selectAutoScaleDataChk(scaleparam);

					if (scaleChkData != null) {
						int chk_cnt = ((BigDecimal) scaleChkData.get("chk_cnt")).intValue();
						
						BigDecimal exe_num_avg_big = (BigDecimal) scaleChkData.get("exe_num_avg");
						int exe_num_avg = 0;
						if (exe_num_avg_big != null) {
							exe_num_avg = exe_num_avg_big.intValue();
						}

						//체크가 맞을때만 저장
						if (chk_cnt > 0) {
							scaleparam.put("exe_num_avg", exe_num_avg);
							//발생이력 저장 -- scale in 이고 현재 인스턴스 수가 2와 같거나 작은경우는 로그 제외
							int jObjCnt = 0;
							boolean logChk = true;
							if ("1".equals(scale_type_cd)) {
								jObjCnt = scaleInstanceCnt(client, is, os);
								
								if (jObjCnt <= scaleLastNodeCnt) {
									logChk = false;
								}
							}
							
							if (logChk == true) {
								scaleDAO.insertScaleOccurLog_G(scaleparam);  //체크가 맞을때만 저장
							}

							//auto scale일 인경우 
							//scale 실행
							//미리 auto scale이 실행 중일경우에는 실행 안함
							String execute_type = (String)scaleparam.get("execute_type");

							if ("TC003402".equals(execute_type)) { //auto-scale 일때 실행
								//현재 인스턴트 수 call
								jObjCnt = scaleInstanceCnt(client, is, os);
								String clusterChk = "success";
								int clusterChk_cnt = 0; //scale_in 차이cnt

								//scale-in, out 일때 최대, 최소 클러스터 갯수 비교 (scale-in 일때 현재 -1이 min클러스터보다 같거나 작을경우 실행안함), (scale-out 일때 현재 +확장클러스터수 가 max클러스터보다 같거나 클경경우 실행안함)
								if ("1".equals(scale_type_cd)) {
									expansion_clusters = 1;

									//scale-in 일때 현재 instance -1이 min클러스터보다 같거나 작을경우
									if (min_clusters < scaleLastNodeCnt) {
										clusterChk = "";
									} else {
										if (jObjCnt < min_clusters) {
											clusterChk = "scale-in_fail";
										} else if (jObjCnt == min_clusters) {
											clusterChk = "";
										}
									}
								} else {
									//scale-out 일때 현재 +확장클러스터수 가 max클러스터보다 클경경우 실행안
									if ((jObjCnt+expansion_clusters) > max_clusters) {
										if ((jObjCnt+expansion_clusters - max_clusters) > 0 ) {
											clusterChk_cnt = (jObjCnt+expansion_clusters - max_clusters);
										}
										
										clusterChk = "scale-out_fail";
									}
								}
								socketLogger.info("clusterChk: [" + clusterChk + "]");
								
								//오류가 아닌경우 auto_scale 실행
								if ("success".equals(clusterChk)) {
									//auto scale 실행로직 필요  -- 내일해야함
									// multi 또는 single
									
									//process_id 셋팅
									scaleparam.put("process_id", timeId);

									if ("1".equals(scale_type_cd)) {
										jObjResult = this.scaleAwsConnect(scaleparam, "scaleIn", expansion_clusters, client, is, os);
									} else {
										jObjResult = this.scaleAwsConnect(scaleparam, "scaleOut", expansion_clusters, client, is, os);
									}

								} else {
									//실패시 실행이력 오류 insert만 하고 auto-scale 안함
									if (!"".equals(clusterChk)) {
										logParam = logSetting(scaleparam, timeId, "insert", clusterChk, clusterChk_cnt);
										this.insertScaleLog_G(logParam);
									}
								}
							} 
							
							
							
						}

					}
				}
			}
		} catch (Exception e) {
			errLogger.error("auto scale 실행중 오류가 발생하였습니다. {}", e.toString());
			e.printStackTrace();
		}

		return setResult;
	}
	
	/**
	 * log값 setting
	 * 
	 * @return String
	 * @throws Exception
	 */
	// logSetting(scaleparam, timeId, "insert", clusterChk, expansion_clusters, clusterChk_cnt);
	public Map<String, Object> logSetting(Map<String, Object> scaleparam, String timeId, String saveGbn, String clusterChk, int clusterChk_cnt){
		Map<String, Object> logParam = new HashMap<String, Object>();
		String strResult = "";

		if ("insert".equals(saveGbn)) {
			logParam.put("scale_type", (String)scaleparam.get("scale_type"));
			logParam.put("db_svr_id",scaleparam.get("db_svr_id"));
			logParam.put("db_svr_ipadr_id", scaleparam.get("db_svr_ipadr_id"));
			logParam.put("wrk_type", "TC003301");
			logParam.put("auto_policy", (String)scaleparam.get("policy_type"));
			logParam.put("auto_policy_set_div", (String)scaleparam.get("auto_policy_set_div"));

			logParam.put("auto_policy_time", scaleparam.get("auto_policy_time"));
			logParam.put("auto_level", (String)scaleparam.get("auto_level"));

			if (!"success".equals(clusterChk)) {
				logParam.put("wrk_id", 2);
			} else {
				logParam.put("wrk_id", 1);
			}

			logParam.put("process_id", timeId);

			if (!"success".equals(clusterChk)) {
				 logParam.put("exe_rslt_cd", "TC001702");
			} else {
				 logParam.put("exe_rslt_cd", "TC001701");
			}
			
			if ("scale-in_fail".equals(clusterChk) || "scale-out_fail".equals(clusterChk)) {
				strResult = "Auto " + clusterChk;
			}
		   

			if (strResult != null) {
				if (strResult.length() > 1000) {
					logParam.put("rslt_msg", strResult.substring(0, 1000));
				} else {
					logParam.put("rslt_msg", strResult);
				}
			} else {
				logParam.put("rslt_msg", "");
			}

			logParam.put("frst_regr_id", loginId);
			logParam.put("lst_mdfr_id", loginId);

		    logParam.put("saveGbn", saveGbn);
		    logParam.put("return_val", "");

		    //CLUSTERS 갯수
			if (!"1".equals((String)scaleparam.get("scale_type"))) {	
				BigDecimal expansion_clusters_big = (BigDecimal) scaleparam.get("expansion_clusters");
				int expansion_clusters = 0;
				if (expansion_clusters_big != null) {
					expansion_clusters = expansion_clusters_big.intValue();
				}

				logParam.put("scale_exe_cnt", expansion_clusters);
			} else {
				logParam.put("scale_exe_cnt", 1);
			}
		} 

		return logParam;
	}
	
    //aws instance 갯수 조회
    public int scaleInstanceCnt(Socket client, BufferedInputStream is, BufferedOutputStream os) {
    	int jObjCnt = 0;
    	JSONObject jObjResult = null;
    	JSONObject jObjSebuResult = null;
    	
		JSONArray scaleArrly = new JSONArray();
		jObjResult = this.scaleAwsConnect(null, "instanceCnt", 0, client, is, os);

		if (jObjResult != null) {
			jObjSebuResult = (JSONObject)jObjResult.get(ProtocolID.RESULT_DATA);
			
			if (jObjSebuResult != null) {
				scaleArrly = (JSONArray) jObjSebuResult.get("Instances");
				if (scaleArrly != null) {
					jObjCnt = scaleArrly.size();
				}
			} else {
				jObjCnt = 0;
			}
		} else {
			jObjCnt = 0;
		}
		
		return jObjCnt;
    }
    
    //scale 실행여부 조회
    public int scaleExecutionSearch(Socket client, BufferedInputStream is, BufferedOutputStream os) {
    	int jObjCnt = 0;
    	JSONObject jObjResult = null;
    	String scalejsonChk = null;

		jObjResult = this.scaleAwsConnect(null,"scaleChk", 0, client, is, os);

		if (jObjResult != null) {
			String resultCode = (String)jObjResult.get(ProtocolID.RESULT_CODE);

			if (resultCode.equals("0")) {
				scalejsonChk = jObjResult.get(ProtocolID.RESULT_SUB_DATA).toString();
				
				if (scalejsonChk != null) {
					jObjCnt = Integer.parseInt(scalejsonChk);
				} else {
					jObjCnt = 1;
				}
			} else {
				jObjCnt = 1;
			}

		} else {
			jObjCnt = 1;
		}
		
		return jObjCnt;
    }
	
    //scale 실행 연결
    public JSONObject scaleAwsConnect(Map<String, Object> scaleparam, String awsGbn, int scaleCnt, Socket client, BufferedInputStream is, BufferedOutputStream os) {
    	JSONObject jObj = null;
      	JSONObject jObjResult = null;
    	Map<String, Object> param = new HashMap<String, Object>();
    	
    	try {
	    	if ("scaleAwsChk".equals(awsGbn) || "instanceCnt".equals(awsGbn) || "scaleChk".equals(awsGbn) || "scaleIngChk".equals(awsGbn)) {
	    		param.put("search_gbn", awsGbn);
	    		param.put("scale_set", "");
	    		param.put("login_id", "");
	    		param.put("db_svr_id", "");
	    		param.put("process_id", "");
	    		param.put("monitering", "");
	    		param.put("scale_count", "");
	    		
				param.put("auto_policy", "");
				param.put("auto_policy_set_div", "");
				param.put("auto_policy_time", "");
				param.put("auto_level", "");
	    	} else if ("scaleIn".equals(awsGbn) || "scaleOut".equals(awsGbn)) {
				param.put("search_gbn", "");
				param.put("scale_set", awsGbn);
				param.put("login_id", loginId);
				param.put("instance_id", "");
				param.put("db_svr_id", "");
				param.put("process_id", (String)scaleparam.get("process_id"));
				param.put("monitering", "monitering");
				param.put("scale_count", scaleCnt);
				
				param.put("auto_policy", (String)scaleparam.get("policy_type"));
				param.put("auto_policy_set_div", (String)scaleparam.get("auto_policy_set_div"));
				param.put("auto_policy_time", scaleparam.get("auto_policy_time"));
				param.put("auto_level", (String)scaleparam.get("auto_level"));
	    	}
	    	
			jObj = this.scaleAwsSetting(param);

	    	DXTcontrolScaleAwsExecute scaleAwsExecute = new DXTcontrolScaleAwsExecute(client, is, os);
	    	jObjResult = scaleAwsExecute.execute(jObj);
	    } catch(Exception e) {
	        e.printStackTrace();
	    }  
    	
    	return jObjResult;
    }
    
    //scale 실행 setting
    public JSONObject scaleAwsSetting(Map<String, Object> param) {
		String scale_set = param.get("scale_set").toString();
		JSONObject obj = new JSONObject();
		int db_svr_id = 1;

		try {
			db_svr_id = this.dbServerInfoSet();
			
			obj.put(ProtocolID.SCALE_COUNT_SET, param.get("scale_count").toString());     //scale 갯수
			obj.put(ProtocolID.SCALE_SET, scale_set);                                     //scale 구분
			obj.put(ProtocolID.SEARCH_GBN, param.get("search_gbn").toString());           //조회구분
			obj.put(ProtocolID.PROCESS_ID, param.get("process_id").toString());           //프로세스 ID
			obj.put(ProtocolID.LOGIN_ID, param.get("login_id").toString());               //로그인 ID
			obj.put(ProtocolID.DB_SVR_ID, db_svr_id);                               //DB_서버_ID
			obj.put(ProtocolID.WRK_TYPE, "TC003301");                                     //작업유형
			obj.put(ProtocolID.MONITERING, param.get("monitering").toString());
			
			obj.put(ProtocolID.DB_SVR_IPADR_ID, this.dbServerIPadrInfoSet());              //DB_서버_IP주소_ID
			obj.put(ProtocolID.AUTO_POLICY, param.get("auto_policy").toString());
			obj.put(ProtocolID.AUTO_POLICY_SET_DIV, param.get("auto_policy_set_div").toString());
			obj.put(ProtocolID.AUTO_POLICY_TIME, param.get("auto_policy_time").toString());
			obj.put(ProtocolID.AUTO_LEVEL, param.get("auto_level").toString());
        } catch(Exception e) {
            e.printStackTrace();
        }
		
		return obj;
    }
    
    //db서버 확인
    public int dbServerInfoSet() {
		int db_svr_id = 4;

		context = new ClassPathXmlApplicationContext(new String[] {"context-tcontrol.xml"});
		SystemServiceImpl service = (SystemServiceImpl) context.getBean("SystemService");

    	DbServerInfoVO searchDbServerInfoVO = new DbServerInfoVO();
    	DbServerInfoVO dbServerInfo = null;
   
		try {
			String strIpadr = FileUtil.getPropertyValue("context.properties", "agent.install.ip");

			//서버정보 조회
			searchDbServerInfoVO.setIPADR(strIpadr);
			dbServerInfo = service.selectDatabaseConnInfo(searchDbServerInfoVO);

			if (dbServerInfo != null) {
				db_svr_id = dbServerInfo.getDB_SVR_ID();
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		
		return db_svr_id;
    }
    
    //db서버IP 확인
    public int dbServerIPadrInfoSet() {
		int db_svr_ipadr_id = 8;
		Map<String, Object> scaleChkData = null;
		Map<String, Object> scaleparam = new HashMap<String, Object>();

		try {
			String strIpadr = FileUtil.getPropertyValue("context.properties", "agent.install.ip");
			scaleparam.put("IPADR", strIpadr);
			
			//서버정보 조회
			scaleChkData = scaleDAO.selectDbServerIpadrInfo(scaleparam);	
			
			if (scaleChkData != null) {
				db_svr_ipadr_id = Integer.parseInt(scaleChkData.get("db_svr_ipadr_id").toString());
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		
		return db_svr_ipadr_id;
    }
   
	public void insertScaleServer()  throws Exception{
		Map<String, Object> scaleChkData = null;
		Map<String, Object> scaleparam = new HashMap<String, Object>();

		try {
			String strIpadr = FileUtil.getPropertyValue("context.properties", "agent.install.ip");
			
			scaleparam.put("IPADR", strIpadr);
			
			//서버정보 조회
			scaleChkData = scaleDAO.selectDbServerIpadrInfo(scaleparam);
socketLogger.info("insertScaleServer.scaleChkData : " + scaleChkData);
			if (scaleChkData != null) {
				scaleparam.put("db_svr_id", scaleChkData.get("db_svr_id"));
				scaleparam.put("db_svr_ipadr_id", scaleChkData.get("db_svr_ipadr_id"));
				scaleparam.put("ipdar_set", strIpadr);
				scaleparam.put("login_id", loginId);
	
				socketLogger.info("insertScaleServer.db_svr_id : " + scaleChkData.get("db_svr_id"));
				socketLogger.info("insertScaleServer.db_svr_ipadr_id : " + scaleChkData.get("db_svr_ipadr_id"));
				socketLogger.info("insertScaleServer.strIpadr : " + strIpadr);
				scaleDAO.insertScaleServer(scaleparam);
			} else {
				socketLogger.info("insertScaleServer.db_svr_id1 : ");
				socketLogger.info("insertScaleServer.db_svr_ipadr_id2 : ");
				socketLogger.info("insertScaleServer.strIpadr3 : ");
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
	

	/* scale 기본사항 조회  */
	public Map<String, Object> selectAutoScaleComCngInfo(Map<String, Object> param)  throws Exception{
		return  (Map<String, Object>)scaleDAO.selectAutoScaleComCngInfo(param);
	}
}