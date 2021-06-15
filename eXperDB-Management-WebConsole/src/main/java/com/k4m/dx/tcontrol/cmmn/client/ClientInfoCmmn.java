package com.k4m.dx.tcontrol.cmmn.client;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.config.AutowireCapableBeanFactory;
import org.springframework.context.ConfigurableApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import com.k4m.dx.tcontrol.admin.dbserverManager.service.DbServerVO;
import com.k4m.dx.tcontrol.cmmn.AES256;
import com.k4m.dx.tcontrol.cmmn.AES256_KEY;
import com.k4m.dx.tcontrol.db2pg.cmmn.DB2PG_START;
import com.k4m.dx.tcontrol.functions.schedule.service.ScheduleService;
import com.k4m.dx.tcontrol.functions.schedule.service.WrkExeVO;
import com.k4m.dx.tcontrol.restore.service.RestoreDumpVO;
import com.k4m.dx.tcontrol.restore.service.RestoreRmanVO;

public class ClientInfoCmmn implements Runnable{
	
	private ConfigurableApplicationContext context;
	

	// 1. 서버 연결 테스트 (serverConn)
	public Map<String, Object> DbserverConn(JSONObject serverObj, String IP, int PORT) {

		Map<String, Object> result = new HashMap<String, Object>();

		try {					
			JSONObject objList;

			ClientAdapter CA = new ClientAdapter(IP, PORT);
			CA.open();

			objList = CA.dxT003(ClientTranCodeType.DxT003, serverObj);

			String strResultCode = (String) objList.get(ClientProtocolID.RESULT_CODE);
			String strErrCode = (String) objList.get(ClientProtocolID.ERR_CODE);
			String strErrMsg = (String) objList.get(ClientProtocolID.ERR_MSG);
			String strDxExCode = (String) objList.get(ClientProtocolID.DX_EX_CODE);

			result.put("result_data", objList.get(ClientProtocolID.RESULT_DATA));
			result.put("result_code", strResultCode);

			CA.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	// 2. 데이터베이스 리스트 (dbList)
	public JSONObject db_List(JSONObject serverObj, String IP, int PORT) {

		JSONArray jsonArray = new JSONArray(); // 객체를 담기위해 JSONArray 선언.
		JSONObject result = new JSONObject();

		List<Object> selectDBList = null;

		try {
			JSONObject objList;

			ClientAdapter CA = new ClientAdapter(IP, PORT);
			CA.open();

			objList = CA.dxT001(ClientTranCodeType.DxT001, serverObj);

			String _tran_err_msg = (String) objList.get(ClientProtocolID.ERR_MSG);
			String strDxExCode = (String) objList.get(ClientProtocolID.DX_EX_CODE);

			selectDBList = (ArrayList<Object>) objList.get(ClientProtocolID.RESULT_DATA);

			if (selectDBList != null) {
				for (int i = 0; i < selectDBList.size(); i++) {
					JSONObject jsonObj = new JSONObject();
					Object obj = selectDBList.get(i);
					HashMap hp = (HashMap) obj;
					String datname = (String) hp.get("datname");

					jsonObj.put("dft_db_nm", datname);
					jsonObj.put("db_exp", "");
					jsonObj.put("rownum", i);
					jsonArray.add(jsonObj);
				}
				result.put("data", jsonArray);
			}
			CA.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	// 5. 백업실행
	public void db_backup(List<Map<String, Object>> resultWork, ArrayList<String> CMD, String IP, int PORT, ArrayList<String> BCKNM, int db_svr_ipadr_id) {
		
		String xml[] = {
				"egovframework/spring/context-aspect.xml",
				"egovframework/spring/context-common.xml",
				"egovframework/spring/context-datasource.xml",
				"egovframework/spring/context-mapper.xml",
				"egovframework/spring/context-properties.xml",
				"egovframework/spring/context-transaction.xml"};
		
		context = new ClassPathXmlApplicationContext(xml);
		context.getAutowireCapableBeanFactory().autowireBeanProperties(this,
				AutowireCapableBeanFactory.AUTOWIRE_BY_TYPE, false);
		
		ScheduleService scheduleService = (ScheduleService) context.getBean("scheduleService");		
		
		try {
			JSONObject reqJObj = new JSONObject();
			JSONObject outputObj = new JSONObject();
			
			//작업완료
			int j = 0;
			
			System.out.println(" ");
			System.out.println(" ");
			System.out.println(" ");
						
			for (int i = 0; i < resultWork.size(); i++) {				
								
				if(resultWork.get(i).get("bsn_dscd").equals("TC001901")){

					JSONArray arrCmd = new JSONArray();			
					JSONObject objJob = new JSONObject();
					
					objJob.put(ClientProtocolID.SCD_ID, resultWork.get(i).get("scd_id")); // 스캐쥴ID
					objJob.put(ClientProtocolID.WORK_ID, resultWork.get(i).get("wrk_id")); // 작업ID
					objJob.put(ClientProtocolID.EXD_ORD, resultWork.get(i).get("exe_ord")); // 실행순서
					objJob.put(ClientProtocolID.NXT_EXD_YN, resultWork.get(i).get("nxt_exe_yn")); // 다음실행여부
					objJob.put(ClientProtocolID.DB_ID, resultWork.get(i).get("db_id")); // db아이디
					if (resultWork.get(i).get("bck_bsn_dscd").equals("TC000201")) {
						System.out.println("> > > > > > > > > > > > > RMAN Backup START");
						System.out.println("> CMD = "+CMD.get(i));
						objJob.put(ClientProtocolID.BCK_OPT_CD, resultWork.get(i).get("bck_opt_cd")); // 백업종류
						objJob.put(ClientProtocolID.BCK_FILE_PTH, resultWork.get(i).get("bck_pth")); // 저장경로
						objJob.put(ClientProtocolID.BCK_FILENM, ""); // 저장파일명
					} else {
						System.out.println("> > > > > > > > > > > > > DUMP Backup START");
						System.out.println("> CMD = "+CMD.get(i));
						objJob.put(ClientProtocolID.BCK_OPT_CD, ""); // 백업종류
						objJob.put(ClientProtocolID.BCK_FILE_PTH, resultWork.get(i).get("save_pth")); // 저장경로					
						objJob.put(ClientProtocolID.BCK_FILENM, BCKNM.get(i)); // 저장파일명					
						objJob.put(ClientProtocolID.BCK_MTN_ECNT, resultWork.get(i).get("bck_mtn_ecnt"));//백업유지개수
						objJob.put(ClientProtocolID.FILE_STG_DCNT, resultWork.get(i).get("file_stg_dcnt")); // 파일보관일수
					}
					objJob.put(ClientProtocolID.BCK_BSN_DSCD, resultWork.get(i).get("bck_bsn_dscd")); //백업종류(RMAN or DUMP)
					objJob.put(ClientProtocolID.LOG_YN, "Y"); // 로그저장 유무
					objJob.put(ClientProtocolID.REQ_CMD, CMD.get(i));// 명령어
					objJob.put(ClientProtocolID.DB_SVR_IPADR_ID, db_svr_ipadr_id);// 명령어
					objJob.put(ClientProtocolID.BSN_DSCD, resultWork.get(i).get("bsn_dscd"));
					arrCmd.add(j, objJob);
	
					// 백업명령 실행후,
					// [pg_rman validate -B 백업경로] 명령어 실행해줘여함
					// [pg_rman validate -B 백업경로] 정합성 체크하는 명령어, 안할실 복구불가능
					// rman은 두번 실행되기때문에 두번째 실행시, LOG_YN=N으로 해주면서, 업데이트 및 이력이 남지않도록한다 
					if (resultWork.get(i).get("bck_bsn_dscd").equals("TC000201")) {
						System.out.println("> RMAN Validataion START");
						j++;
						JSONObject objJob2 = new JSONObject();
						objJob2.put(ClientProtocolID.SCD_ID, resultWork.get(i).get("scd_id")); // 스캐쥴ID
						objJob2.put(ClientProtocolID.WORK_ID, resultWork.get(i).get("wrk_id")); // 작업ID
						objJob2.put(ClientProtocolID.EXD_ORD, resultWork.get(i).get("exe_ord")); // 실행순서
						objJob2.put(ClientProtocolID.NXT_EXD_YN, resultWork.get(i).get("nxt_exe_yn")); // 다음실행여부
						objJob2.put(ClientProtocolID.BCK_OPT_CD, resultWork.get(i).get("bck_opt_cd")); // 백업종류
						objJob2.put(ClientProtocolID.DB_ID, resultWork.get(i).get("db_id")); // db아이디
						objJob2.put(ClientProtocolID.BCK_FILE_PTH, resultWork.get(i).get("bck_pth")); // 저장경로
						objJob2.put(ClientProtocolID.BCK_FILENM, ""); // 저장파일명
						objJob2.put(ClientProtocolID.LOG_YN, "N"); // 로그저장 유무
						objJob2.put(ClientProtocolID.REQ_CMD, "pg_rman validate -B " + resultWork.get(i).get("bck_pth"));// 명령어
						System.out.println("> Validate CMD = "+objJob2.get(ClientProtocolID.REQ_CMD));
						objJob2.put(ClientProtocolID.BCK_BSN_DSCD, resultWork.get(i).get("bck_bsn_dscd"));
						objJob2.put(ClientProtocolID.DB_SVR_IPADR_ID, db_svr_ipadr_id);
						objJob2.put(ClientProtocolID.BSN_DSCD, resultWork.get(i).get("bsn_dscd"));
						arrCmd.add(j, objJob2);
					}
					
					JSONObject serverObj = new JSONObject();

					serverObj.put(ClientProtocolID.SERVER_NAME, "");
					serverObj.put(ClientProtocolID.SERVER_IP, "");
					serverObj.put(ClientProtocolID.SERVER_PORT, "");

					reqJObj.put(ClientProtocolID.DX_EX_CODE, ClientTranCodeType.DxT005);
					reqJObj.put(ClientProtocolID.SERVER_INFO, serverObj);
					reqJObj.put(ClientProtocolID.ARR_CMD, arrCmd);

					ClientAdapter CA = new ClientAdapter(IP, PORT);
					CA.open();
					outputObj = CA.dxT005(reqJObj);
					CA.close();
			
					System.out.println(">> > > > > > > > > >> > >  > > Backup END");
					System.out.println(" ");
					System.out.println(" ");
					System.out.println(" ");
				
				}else if(resultWork.get(i).get("bsn_dscd").equals("TC001902")){
					System.out.println("> > > > > > > > > > > > > Script Batch START");
					System.out.println("> CMD = "+CMD.get(i));
					
					JSONArray arrCmd = new JSONArray();
					JSONObject objJob3 = new JSONObject();
					objJob3.put(ClientProtocolID.SCD_ID, resultWork.get(i).get("scd_id")); // 스캐쥴ID
					objJob3.put(ClientProtocolID.WORK_ID, resultWork.get(i).get("wrk_id")); // 작업ID
					objJob3.put(ClientProtocolID.EXD_ORD, resultWork.get(i).get("exe_ord")); // 실행순서
					objJob3.put(ClientProtocolID.NXT_EXD_YN, resultWork.get(i).get("nxt_exe_yn")); // 다음실행여부
					objJob3.put(ClientProtocolID.BCK_OPT_CD, "");
					objJob3.put(ClientProtocolID.DB_ID, 0); // db아이디
					objJob3.put(ClientProtocolID.BCK_FILE_PTH, ""); // 저장경로
					objJob3.put(ClientProtocolID.BCK_FILENM, ""); // 저장파일명
					objJob3.put(ClientProtocolID.LOG_YN, "Y"); // 로그저장 유무
					objJob3.put(ClientProtocolID.REQ_CMD, CMD.get(i));// 명령어
					objJob3.put(ClientProtocolID.BCK_BSN_DSCD, "");
					objJob3.put(ClientProtocolID.DB_SVR_IPADR_ID, db_svr_ipadr_id);
					objJob3.put(ClientProtocolID.BSN_DSCD, resultWork.get(i).get("bsn_dscd"));
					arrCmd.add(0, objJob3);
					
					//j++;
					JSONObject serverObj = new JSONObject();

					serverObj.put(ClientProtocolID.SERVER_NAME, "");
					serverObj.put(ClientProtocolID.SERVER_IP, "");
					serverObj.put(ClientProtocolID.SERVER_PORT, "");

					reqJObj.put(ClientProtocolID.DX_EX_CODE, ClientTranCodeType.DxT005);
					reqJObj.put(ClientProtocolID.SERVER_INFO, serverObj);
					reqJObj.put(ClientProtocolID.ARR_CMD, arrCmd);

					ClientAdapter CA = new ClientAdapter(IP, PORT);
					CA.open();
					outputObj =CA.dxT005(reqJObj);
					CA.close();
					
					System.out.println("> > > > > > > > > > > > > > > > Script Batch END");
					System.out.println(" ");
					System.out.println(" ");
					System.out.println(" ");
					
				}else{
					
					System.out.println("> > > > > > > > > > > > > > > > DB2PG START");
					
					int wrk_id = Integer.parseInt(resultWork.get(i).get("wrk_id").toString());						
					String oldSavePath = scheduleService.selectOldSavePath(wrk_id);
							
					System.out.println("wrk_id= " +  wrk_id);
					System.out.println("DB2PG oldSavePath = "+ oldSavePath);
											
					int intSeq = scheduleService.selectQ_WRKEXE_G_01_SEQ();
					int intGrpSeq = scheduleService.selectQ_WRKEXE_G_02_SEQ();
					WrkExeVO vo = new WrkExeVO();
									
					String db2pg = resultWork.get(i).get("bsn_dscd").toString();
					
					Map<String, Object> result = null;
					//Map<String, Object> param = new HashMap<String, Object>();
					
					JSONObject obj = new JSONObject();
					obj.put("wrk_nm", resultWork.get(i).get("wrk_nm"));		
					obj.put("oldSavePath", oldSavePath);
					obj.put("wrk_id", resultWork.get(i).get("wrk_id"));
					obj.put("lst_mdfr_id", resultWork.get(i).get("lst_mdfr_id"));
									
					vo.setExe_sn(intSeq);
					vo.setScd_id(Integer.parseInt(resultWork.get(i).get("scd_id").toString()));
					vo.setWrk_id(Integer.parseInt(resultWork.get(i).get("wrk_id").toString()));
					vo.setExe_grp_sn(intGrpSeq);
					
					scheduleService.insertT_WRKEXE_G(vo);
					
					result  = DB2PG_START.db2pgStart(obj);
					
					if(result.get("RESULT").equals("SUCCESS")){
						vo.setExe_rslt_cd("TC001701");
					}else{
						vo.setExe_rslt_cd("TC001702");
					}
					
					scheduleService.updateScheduler(vo);
					
					System.out.println(" ");
					System.out.println(" ");
					System.out.println(" ");
										
				}
			}
			
			/*JSONObject serverObj = new JSONObject();

			serverObj.put(ClientProtocolID.SERVER_NAME, "");
			serverObj.put(ClientProtocolID.SERVER_IP, "");
			serverObj.put(ClientProtocolID.SERVER_PORT, "");

			reqJObj.put(ClientProtocolID.DX_EX_CODE, ClientTranCodeType.DxT005);
			reqJObj.put(ClientProtocolID.SERVER_INFO, serverObj);
			reqJObj.put(ClientProtocolID.ARR_CMD, arrCmd);

			ClientAdapter CA = new ClientAdapter(IP, PORT);
			CA.open();
			CA.dxT005(reqJObj);
			CA.close();*/
			System.out.println(">Schedule END ================================================");	
		} catch (Exception e) {
			e.printStackTrace();
		}
	}


	
	// 6. DB접근제어 (dbAccess_create)
	public void dbAccess_create(JSONObject serverObj, JSONObject acObj, String IP, int PORT) {
		try {
			JSONObject objList;
			ClientAdapter CA = new ClientAdapter(IP, PORT);
			CA.open();

			JSONObject jObj = new JSONObject();
			jObj.put(ClientProtocolID.DX_EX_CODE, ClientTranCodeType.DxT006);
			jObj.put(ClientProtocolID.COMMAND_CODE, ClientProtocolID.COMMAND_CODE_C);
			jObj.put(ClientProtocolID.SERVER_INFO, serverObj);
			jObj.put(ClientProtocolID.ACCESS_CONTROL_INFO, acObj);

			objList = CA.dxT006(ClientTranCodeType.DxT006, jObj);

			String strErrMsg = (String) objList.get(ClientProtocolID.ERR_MSG);
			String strErrCode = (String) objList.get(ClientProtocolID.ERR_CODE);
			String strDxExCode = (String) objList.get(ClientProtocolID.DX_EX_CODE);
			String strResultCode = (String) objList.get(ClientProtocolID.RESULT_CODE);

			CA.close();

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	// 6. DB접근제어 R(dbAccessList-#주석처리 안되어있는것 set==0)
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public JSONObject dbAccess_select(JSONObject serverObj, String IP, int PORT) {
		JSONArray jsonArray = new JSONArray(); // 객체를 담기위해 JSONArray 선언.
		JSONObject result = new JSONObject();
		try {
			JSONObject objList;

			JSONObject acObj = new JSONObject();

			ClientAdapter CA = new ClientAdapter(IP, PORT);
			CA.open();

			JSONObject jObj = new JSONObject();
			jObj.put(ClientProtocolID.DX_EX_CODE, ClientTranCodeType.DxT006);
			jObj.put(ClientProtocolID.COMMAND_CODE, ClientProtocolID.COMMAND_CODE_R);
			jObj.put(ClientProtocolID.SERVER_INFO, serverObj);
			jObj.put(ClientProtocolID.ACCESS_CONTROL_INFO, acObj);

			objList = CA.dxT006(ClientTranCodeType.DxT006, jObj);
			String strErrCode = (String) objList.get(ClientProtocolID.ERR_CODE);
			String strErrMsg = (String) objList.get(ClientProtocolID.ERR_MSG);
			String strDxExCode = (String) objList.get(ClientProtocolID.DX_EX_CODE);
			String strResultCode = (String) objList.get(ClientProtocolID.RESULT_CODE);

			List<Object> selectDBList = (ArrayList<Object>) objList.get(ClientProtocolID.RESULT_DATA);

			if (selectDBList != null) {
				for (int i = 0; i < selectDBList.size() - 1; i++) {
					JSONObject jsonObj = new JSONObject();
					Object obj = selectDBList.get(i);
					HashMap hp = (HashMap) obj;

					if (Integer.parseInt((String) hp.get("Set")) != 0) {
						String Seq = (String) hp.get("Seq");
						String Set = (String) hp.get("Set");
						String Type = (String) hp.get("Type");
						String Database = (String) hp.get("Database");
						String User = (String) hp.get("User");
						String Ipadr = (String) hp.get("Ip");
						String Ipmask = (String) hp.get("Ipmask");
						String Method = (String) hp.get("Method");
						String Option = (String) hp.get("Option");

						jsonObj.put("Seq", Seq);
						jsonObj.put("Set", Set);
						jsonObj.put("Type", Type);
						jsonObj.put("Database", Database);
						jsonObj.put("User", User);
						jsonObj.put("Ipadr", Ipadr);
						jsonObj.put("Ipmask", Ipmask);
						jsonObj.put("Method", Method);
						jsonObj.put("Option", Option);

						jsonArray.add(jsonObj);
					}

				}
				result.put("data", jsonArray);
			}
			CA.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	// 6. DB접근제어 R(dbAccessList-전체)
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public JSONObject dbAccess_selectAll(JSONObject serverObj, String IP, int PORT) {

		JSONArray jsonArray = new JSONArray(); // 객체를 담기위해 JSONArray 선언.
		JSONObject result = new JSONObject();

		try {
			JSONObject objList;

			JSONObject acObj = new JSONObject();

			ClientAdapter CA = new ClientAdapter(IP, PORT);
			CA.open();

			JSONObject jObj = new JSONObject();
			jObj.put(ClientProtocolID.DX_EX_CODE, ClientTranCodeType.DxT006);
			jObj.put(ClientProtocolID.COMMAND_CODE, ClientProtocolID.COMMAND_CODE_R);
			jObj.put(ClientProtocolID.SERVER_INFO, serverObj);
			jObj.put(ClientProtocolID.ACCESS_CONTROL_INFO, acObj);

			objList = CA.dxT006(ClientTranCodeType.DxT006, jObj);
			String strErrCode = (String) objList.get(ClientProtocolID.ERR_CODE);
			String strErrMsg = (String) objList.get(ClientProtocolID.ERR_MSG);
			String strDxExCode = (String) objList.get(ClientProtocolID.DX_EX_CODE);
			String strResultCode = (String) objList.get(ClientProtocolID.RESULT_CODE);

			List<Object> selectDBList = (ArrayList<Object>) objList.get(ClientProtocolID.RESULT_DATA);

			for (int i = 0; i < selectDBList.size() - 1; i++) {
				JSONObject jsonObj = new JSONObject();

				Object obj = selectDBList.get(i);
				HashMap hp = (HashMap) obj;
				String Seq = (String) hp.get("Seq");
				String Set = (String) hp.get("Set");
				String Type = (String) hp.get("Type");
				String Database = (String) hp.get("Database");
				String User = (String) hp.get("User");
				String Ipadr = (String) hp.get("Ip");
				String Ipmask = (String) hp.get("Ipmask");
				String Method = (String) hp.get("Method");
				String Option = (String) hp.get("Option");

				jsonObj.put("Seq", Seq);
				jsonObj.put("Set", Set);
				jsonObj.put("Type", Type);
				jsonObj.put("Database", Database);
				jsonObj.put("User", User);
				jsonObj.put("Ipadr", Ipadr);
				jsonObj.put("Ipmask", Ipmask);
				jsonObj.put("Method", Method);
				jsonObj.put("Option", Option);

				jsonArray.add(jsonObj);

			}
			result.put("data", jsonArray);

			CA.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	// 6.DB접근제어 U(dbAccess_update)
	public void dbAccess_update(JSONObject serverObj, JSONObject acObj, String IP, int PORT) {
		try {
			JSONObject objList;

			ClientAdapter CA = new ClientAdapter(IP, PORT);
			CA.open();

			JSONObject jObj = new JSONObject();
			jObj.put(ClientProtocolID.DX_EX_CODE, ClientTranCodeType.DxT006);
			jObj.put(ClientProtocolID.COMMAND_CODE, ClientProtocolID.COMMAND_CODE_U);
			jObj.put(ClientProtocolID.SERVER_INFO, serverObj);
			jObj.put(ClientProtocolID.ACCESS_CONTROL_INFO, acObj);

			objList = CA.dxT006(ClientTranCodeType.DxT006, jObj);

			String strErrMsg = (String) objList.get(ClientProtocolID.ERR_MSG);
			String strErrCode = (String) objList.get(ClientProtocolID.ERR_CODE);
			String strDxExCode = (String) objList.get(ClientProtocolID.DX_EX_CODE);
			String strResultCode = (String) objList.get(ClientProtocolID.RESULT_CODE);

			CA.close();

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	// 6. DB접근제어 D(dbAccess_delete)
	public void dbAccess_delete(JSONObject serverObj, ArrayList arrSeq, String IP, int PORT) {
		try {

			JSONObject objList;

			ClientAdapter CA = new ClientAdapter(IP, PORT);
			CA.open();

			JSONObject jObj = new JSONObject();
			jObj.put(ClientProtocolID.DX_EX_CODE, ClientTranCodeType.DxT006);
			jObj.put(ClientProtocolID.COMMAND_CODE, ClientProtocolID.COMMAND_CODE_D_A);
			jObj.put(ClientProtocolID.SERVER_INFO, serverObj);
			jObj.put(ClientProtocolID.ARR_AC_SEQ, arrSeq);

			objList = CA.dxT006(ClientTranCodeType.DxT006, jObj);

			String strErrMsg = (String) objList.get(ClientProtocolID.ERR_MSG);
			String strErrCode = (String) objList.get(ClientProtocolID.ERR_CODE);
			String strDxExCode = (String) objList.get(ClientProtocolID.DX_EX_CODE);
			String strResultCode = (String) objList.get(ClientProtocolID.RESULT_CODE);
			
			CA.close();

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	// 10. 확장 설치 리스트 조회(Extension_select)
	public List<Object> extension_select(JSONObject serverObj,String IP, int PORT,String strExtname) {
		List<Object> selectDBList = null;
		try {
	
			ClientAdapter CA = new ClientAdapter(IP, PORT);
			CA.open(); 
			
			JSONObject objList;
			
			//strExtname = "pgaudit";
			objList = CA.dxT010(ClientTranCodeType.DxT010, serverObj, strExtname);
			
			String strErrMsg = (String)objList.get(ClientProtocolID.ERR_MSG);
			String strErrCode = (String)objList.get(ClientProtocolID.ERR_CODE);
			String strDxExCode = (String)objList.get(ClientProtocolID.DX_EX_CODE);
			String strResultCode = (String)objList.get(ClientProtocolID.RESULT_CODE);
			
			selectDBList =(ArrayList<Object>) objList.get(ClientProtocolID.RESULT_DATA);
			
			CA.close();
			
			return selectDBList;
		} catch(Exception e) {
			e.printStackTrace();
		}
		return selectDBList;
	}
	
	
	// 11. Role 리스트 (roleList)
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public JSONObject role_List(JSONObject serverObj,String IP, int PORT) {

		JSONArray jsonArray = new JSONArray(); // 객체를 담기위해 JSONArray 선언.
		JSONObject result = new JSONObject();

		try {
			JSONObject objList;

			ClientAdapter CA = new ClientAdapter(IP, PORT);
			CA.open();

			objList = CA.dxT011(ClientTranCodeType.DxT011, serverObj);

			String strErrMsg = (String) objList.get(ClientProtocolID.ERR_MSG);
			String strDxExCode = (String) objList.get(ClientProtocolID.DX_EX_CODE);

			List<Object> selectList = (ArrayList<Object>) objList.get(ClientProtocolID.RESULT_DATA);

			for (int i = 0; i < selectList.size(); i++) {
				JSONObject jsonObj = new JSONObject();
				Object obj = selectList.get(i);

				HashMap hp = (HashMap) obj;

				jsonObj.put("rolname", (String) hp.get("rolname"));
				jsonArray.add(jsonObj);
			}
			CA.close();

			result.put("data", jsonArray);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	// 12. 스키마 및 테이블 리스트 (objectList)
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public JSONObject object_List(JSONObject serverObj, String IP, int PORT) {

		JSONArray jsonArray = new JSONArray(); // 객체를 담기위해 JSONArray 선언.
		JSONObject result = new JSONObject();

		List<Object> selectList = null;

		try {
			JSONObject objList;

			ClientAdapter CA = new ClientAdapter(IP, PORT);
			CA.open();

			objList = CA.dxT012(ClientTranCodeType.DxT012, serverObj);

			selectList = (ArrayList<Object>) objList.get(ClientProtocolID.RESULT_DATA);

			String strErrMsg = (String) objList.get(ClientProtocolID.ERR_MSG);
			String strErrCode = (String) objList.get(ClientProtocolID.ERR_CODE);
			String strDxExCode = (String) objList.get(ClientProtocolID.DX_EX_CODE);
			String strResultCode = (String) objList.get(ClientProtocolID.RESULT_CODE);

			for (int i = 0; i < selectList.size(); i++) {
				JSONObject jsonObj = new JSONObject();
				HashMap hp = (HashMap) selectList.get(i);

				jsonObj.put("schema", (String) hp.get("table_schema"));
				jsonObj.put("name", (String) hp.get("table_name"));
				jsonArray.add(jsonObj);

			}
			result.put("data", jsonArray);

			CA.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	// 12. 테이블리스트 조회(tableList_select)
	public JSONObject tableList_select(JSONObject serverObj, String IP, int PORT) {
		JSONArray jsonArray = new JSONArray(); // 객체를 담기위해 JSONArray 선언.
		JSONObject result = new JSONObject();
		try {
			JSONObject objList;

			ClientAdapter CA = new ClientAdapter(IP, PORT);
			CA.open();

			objList = CA.dxT011(ClientTranCodeType.DxT012, serverObj);

			String strErrMsg = (String) objList.get(ClientProtocolID.ERR_MSG);
			String strErrCode = (String) objList.get(ClientProtocolID.ERR_CODE);
			String strDxExCode = (String) objList.get(ClientProtocolID.DX_EX_CODE);
			String strResultCode = (String) objList.get(ClientProtocolID.RESULT_CODE);

			List<Object> selectDBList = (ArrayList<Object>) objList.get(ClientProtocolID.RESULT_DATA);

			if (selectDBList != null) {
				if (selectDBList.size() > 0) {
					for (int i = 0; i < selectDBList.size(); i++) {
						JSONObject jsonObj = new JSONObject();
						Object obj = selectDBList.get(i);
						HashMap hp = (HashMap) obj;
						String table_schema = (String) hp.get("table_schema");
						String table_name = (String) hp.get("table_name");
						jsonObj.put("table_schema", table_schema);
						jsonObj.put("table_name", table_name);
						jsonArray.add(jsonObj);
					}
				}
				result.put("data", jsonArray);
			}
			CA.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	// bottledWater 실행
	public void bottledwater_start(String IP, int PORT, String strExecTxt, String trf_trg_id) {
		try {
			JSONObject jObj = new JSONObject();
			jObj.put(ClientProtocolID.DX_EX_CODE, ClientTranCodeType.DxT013);
			jObj.put(ClientProtocolID.TRF_TRG_ID, trf_trg_id);
			jObj.put(ClientProtocolID.COMMAND_CODE, ClientProtocolID.RUN);
			jObj.put(ClientProtocolID.EXEC_TXT, strExecTxt);

			JSONObject objList;

			ClientAdapter CA = new ClientAdapter(IP, PORT);
			CA.open();

			objList = CA.dxT013(ClientTranCodeType.DxT013, jObj);

			String strErrMsg = (String) objList.get(ClientProtocolID.ERR_MSG);
			String strErrCode = (String) objList.get(ClientProtocolID.ERR_CODE);
			String strDxExCode = (String) objList.get(ClientProtocolID.DX_EX_CODE);
			String strResultCode = (String) objList.get(ClientProtocolID.RESULT_CODE);

			CA.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	// bottledWater 종료
	public void bottledwater_end(String IP, int PORT, String strExecTxt, String trf_trg_id,JSONObject serverObj) {
		try {
			JSONObject jObj = new JSONObject();
			jObj.put(ClientProtocolID.DX_EX_CODE, ClientTranCodeType.DxT013);
			jObj.put(ClientProtocolID.TRF_TRG_ID, trf_trg_id);
			jObj.put(ClientProtocolID.COMMAND_CODE, ClientProtocolID.STOP);
			jObj.put(ClientProtocolID.EXEC_TXT, strExecTxt);
			jObj.put(ClientProtocolID.SERVER_INFO, serverObj);
			
			JSONObject objList;

			ClientAdapter CA = new ClientAdapter(IP, PORT);
			CA.open();

			objList = CA.dxT013(ClientTranCodeType.DxT013, jObj);

			String strErrMsg = (String) objList.get(ClientProtocolID.ERR_MSG);
			String strErrCode = (String) objList.get(ClientProtocolID.ERR_CODE);
			String strDxExCode = (String) objList.get(ClientProtocolID.DX_EX_CODE);
			String strResultCode = (String) objList.get(ClientProtocolID.RESULT_CODE);

			CA.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	// 14.kafka connect 조회(kafakConnect_select)
	public JSONObject kafakConnect_select(JSONObject serverObj, String strName, String IP, int PORT) {

		JSONArray jsonArray = new JSONArray(); // 객체를 담기위해 JSONArray 선언.
		JSONObject result = new JSONObject();

		try {

			JSONObject connectorInfoObj = new JSONObject();

			connectorInfoObj.put(ClientProtocolID.CONNECTOR_NAME, strName);

			JSONObject jObj = new JSONObject();
			jObj.put(ClientProtocolID.DX_EX_CODE, ClientTranCodeType.DxT014);
			jObj.put(ClientProtocolID.COMMAND_CODE, ClientProtocolID.COMMAND_CODE_R);
			jObj.put(ClientProtocolID.SERVER_INFO, serverObj);
			jObj.put(ClientProtocolID.CONNECTOR_INFO, connectorInfoObj);

			JSONObject objList;

			ClientAdapter CA = new ClientAdapter(IP, PORT);
			CA.open();

			objList = CA.dxT014(ClientTranCodeType.DxT014, jObj);

			String strErrMsg = (String) objList.get(ClientProtocolID.ERR_MSG);
			String strErrCode = (String) objList.get(ClientProtocolID.ERR_CODE);
			String strDxExCode = (String) objList.get(ClientProtocolID.DX_EX_CODE);
			String strResultCode = (String) objList.get(ClientProtocolID.RESULT_CODE);

			List<Object> selectDBList = (ArrayList<Object>) objList.get(ClientProtocolID.RESULT_DATA);

			if (selectDBList != null) {
				if (selectDBList.size() > 0) {
					for (int i = 0; i < selectDBList.size(); i++) {
						JSONObject jsonObj = new JSONObject();

						Object obj = selectDBList.get(i);

						HashMap hp = (HashMap) obj;
						String name = (String) hp.get("name");
						String hdfs_url = (String) hp.get("hdfs.url");
						String tasks_max = (String) hp.get("tasks.max");
						String flush_size = (String) hp.get("flush.size");
						String rotate_interval_ms = (String) hp.get("rotate.interval.ms");

						jsonObj.put("hp", hp);
						jsonObj.put("name", name);
						jsonObj.put("hdfs_url", hdfs_url);
						jsonObj.put("tasks_max", tasks_max);
						jsonObj.put("flush_size", flush_size);
						jsonObj.put("rotate_interval_ms", rotate_interval_ms);

						jsonArray.add(jsonObj);

					}
					result.put("data", jsonArray);
				}
			}
			CA.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	// 14.kafka connect 등록(kafakConnect_create)
	public Map<String, Object> kafakConnect_create(JSONObject serverObj, JSONObject param, String IP, int PORT) {
		Map<String, Object> result = new HashMap<String, Object>();
		try {

			String strName = (String) param.get("strName");
			String strConnector_class = (String) param.get("strConnector_class");
			String strTasks_max = (String) param.get("strTasks_max");
			String strTopics = "";
			String strHdfs_url = (String) param.get("strHdfs_url");
			String strHadoop_conf_dir = (String) param.get("strHadoop_conf_dir");
			String strHadoop_home = (String) param.get("strHadoop_home");
			String strFlush_size = (String) param.get("strFlush_size");
			String strRotate_interval_ms = (String) param.get("strRotate_interval_ms");

			JSONObject connectorInfoObj = new JSONObject();

			connectorInfoObj.put(ClientProtocolID.CONNECTOR_NAME, strName);
			connectorInfoObj.put(ClientProtocolID.CONNECTOR_CLASS, strConnector_class);
			connectorInfoObj.put(ClientProtocolID.TASK_MAX, strTasks_max);
			connectorInfoObj.put(ClientProtocolID.TOPIC, strTopics);
			connectorInfoObj.put(ClientProtocolID.HDFS_URL, strHdfs_url);
			connectorInfoObj.put(ClientProtocolID.HADOOP_CONF_DIR, strHadoop_conf_dir);
			connectorInfoObj.put(ClientProtocolID.HADOOP_HOOM, strHadoop_home);
			connectorInfoObj.put(ClientProtocolID.FLUSH_SIZE, strFlush_size);
			connectorInfoObj.put(ClientProtocolID.ROTATE_INTERVAL_MS, strRotate_interval_ms);

			JSONObject jObj = new JSONObject();
			jObj.put(ClientProtocolID.DX_EX_CODE, ClientTranCodeType.DxT014);
			jObj.put(ClientProtocolID.COMMAND_CODE, ClientProtocolID.COMMAND_CODE_C);
			jObj.put(ClientProtocolID.SERVER_INFO, serverObj);
			jObj.put(ClientProtocolID.CONNECTOR_INFO, connectorInfoObj);

			JSONObject objList;

			ClientAdapter CA = new ClientAdapter(IP, PORT);
			CA.open();

			objList = CA.dxT014(ClientTranCodeType.DxT014, jObj);

			String strErrMsg = (String) objList.get(ClientProtocolID.ERR_MSG);
			String strErrCode = (String) objList.get(ClientProtocolID.ERR_CODE);
			String strDxExCode = (String) objList.get(ClientProtocolID.DX_EX_CODE);
			String strResultCode = (String) objList.get(ClientProtocolID.RESULT_CODE);

			CA.close();

			result.put("strResultCode", strResultCode);
			return result;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	// 14.kafka connect 수정(kafakConnect_update)
	public Map<String, Object> kafakConnect_update(JSONObject serverObj, JSONObject param, String IP, int PORT) {
		Map<String, Object> result = new HashMap<String, Object>();
		try {

			String strName = (String) param.get("strName");

			String strConnector_class = (String) param.get("strConnector_class");
			String strTasks_max = (String) param.get("strTasks_max");
			String strTopics = (String) param.get("strTopics");
			String strHdfs_url = (String) param.get("strHdfs_url");
			String strHadoop_conf_dir = (String) param.get("strHadoop_conf_dir");
			String strHadoop_home = (String) param.get("strHadoop_home");
			String strFlush_size = (String) param.get("strFlush_size");
			String strRotate_interval_ms = (String) param.get("strRotate_interval_ms");

			JSONObject connectorInfoObj = new JSONObject();

			connectorInfoObj.put(ClientProtocolID.CONNECTOR_NAME, strName);
			connectorInfoObj.put(ClientProtocolID.CONNECTOR_CLASS, strConnector_class);
			connectorInfoObj.put(ClientProtocolID.TASK_MAX, strTasks_max);
			connectorInfoObj.put(ClientProtocolID.TOPIC, strTopics);
			connectorInfoObj.put(ClientProtocolID.HDFS_URL, strHdfs_url);
			connectorInfoObj.put(ClientProtocolID.HADOOP_CONF_DIR, strHadoop_conf_dir);
			connectorInfoObj.put(ClientProtocolID.HADOOP_HOOM, strHadoop_home);
			connectorInfoObj.put(ClientProtocolID.FLUSH_SIZE, strFlush_size);
			connectorInfoObj.put(ClientProtocolID.ROTATE_INTERVAL_MS, strRotate_interval_ms);

			JSONObject jObj = new JSONObject();
			jObj.put(ClientProtocolID.DX_EX_CODE, ClientTranCodeType.DxT014);
			jObj.put(ClientProtocolID.COMMAND_CODE, ClientProtocolID.COMMAND_CODE_U);
			jObj.put(ClientProtocolID.SERVER_INFO, serverObj);
			jObj.put(ClientProtocolID.CONNECTOR_INFO, connectorInfoObj);

			JSONObject objList;

			ClientAdapter CA = new ClientAdapter(IP, PORT);
			CA.open();

			objList = CA.dxT014(ClientTranCodeType.DxT014, jObj);

			String strErrMsg = (String) objList.get(ClientProtocolID.ERR_MSG);
			String strErrCode = (String) objList.get(ClientProtocolID.ERR_CODE);
			String strDxExCode = (String) objList.get(ClientProtocolID.DX_EX_CODE);
			String strResultCode = (String) objList.get(ClientProtocolID.RESULT_CODE);

			CA.close();

			result.put("strResultCode", strResultCode);
			return result;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	// 14.kafka connect 삭제(kafakConnect_delete)
	public Map<String, Object> kafakConnect_delete(JSONObject serverObj, String strName, String IP, int PORT) {
		Map<String, Object> result = new HashMap<String, Object>();
		try {
			JSONObject connectorInfoObj = new JSONObject();

			connectorInfoObj.put(ClientProtocolID.CONNECTOR_NAME, strName);

			JSONObject jObj = new JSONObject();
			jObj.put(ClientProtocolID.DX_EX_CODE, ClientTranCodeType.DxT014);
			jObj.put(ClientProtocolID.COMMAND_CODE, ClientProtocolID.COMMAND_CODE_D);
			jObj.put(ClientProtocolID.SERVER_INFO, serverObj);
			jObj.put(ClientProtocolID.CONNECTOR_INFO, connectorInfoObj);

			JSONObject objList;

			ClientAdapter CA = new ClientAdapter(IP,PORT);
			CA.open();

			objList = CA.dxT014(ClientTranCodeType.DxT014, jObj);

			String strErrMsg = (String) objList.get(ClientProtocolID.ERR_MSG);
			String strErrCode = (String) objList.get(ClientProtocolID.ERR_CODE);
			String strDxExCode = (String) objList.get(ClientProtocolID.DX_EX_CODE);
			String strResultCode = (String) objList.get(ClientProtocolID.RESULT_CODE);

			CA.close();

			result.put("strResultCode", strResultCode);
			return result;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	// 16.exist directory check
	public Map<String, Object> directory_exist(JSONObject serverObj, String folderPath, String IP, int PORT) {
		Map<String, Object> result = new HashMap<String, Object>();
		try {
			JSONObject jObj = new JSONObject();
			jObj.put(ClientProtocolID.DX_EX_CODE, ClientTranCodeType.DxT016);
			jObj.put(ClientProtocolID.SERVER_INFO, serverObj);
			jObj.put(ClientProtocolID.FILE_DIRECTORY, folderPath);

			JSONObject objList;

			ClientAdapter CA = new ClientAdapter(IP, PORT);
			CA.open();
			objList = CA.dxT016(jObj);

			String strErrMsg = (String) objList.get(ClientProtocolID.ERR_MSG);
			String strErrCode = (String) objList.get(ClientProtocolID.ERR_CODE);
			String strDxExCode = (String) objList.get(ClientProtocolID.DX_EX_CODE);
			String strResultCode = (String) objList.get(ClientProtocolID.RESULT_CODE);
			Object strResultData =  objList.get(ClientProtocolID.RESULT_DATA);
			
			CA.close();
			
			HashMap obj = (HashMap)objList.get(ClientProtocolID.RESULT_DATA);			
			int checkDir = Integer.parseInt(obj.get(ClientProtocolID.IS_DIRECTORY).toString());
			
			if(checkDir == 1){
				result.put("resultCode", 1);				
			}else{
				result.put("resultCode", 0);
			}
			
			result.put("SERVERIP", serverObj.get(ClientProtocolID.SERVER_IP));
			result.put("result", objList);
				
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	// 17.tbl_mapps insert
	public void tblmapps_insert(String IP, int PORT, JSONObject serverObj,
			ArrayList<HashMap<String, String>> arrTableInfo) {
		try {
			JSONObject jObj = new JSONObject();

			jObj.put(ClientProtocolID.DX_EX_CODE, ClientTranCodeType.DxT017);
			jObj.put(ClientProtocolID.COMMAND_CODE, ClientProtocolID.COMMAND_CODE_C);
			jObj.put(ClientProtocolID.SERVER_INFO, serverObj);
			jObj.put(ClientProtocolID.TABLE_INFO, arrTableInfo);

			JSONObject objList;

			ClientAdapter CA = new ClientAdapter(IP, PORT);
			CA.open();

			objList = CA.dxT017(jObj);

			String strErrMsg = (String) objList.get(ClientProtocolID.ERR_MSG);
			String strErrCode = (String) objList.get(ClientProtocolID.ERR_CODE);
			String strDxExCode = (String) objList.get(ClientProtocolID.DX_EX_CODE);
			String strResultCode = (String) objList.get(ClientProtocolID.RESULT_CODE);

			CA.close();

			// CA.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	// 17.tbl_mapps select
	public int tblmapps_select(String IP, int PORT, JSONObject serverObj,ArrayList<HashMap<String, String>> arrTableInfo) {
		int tblmappsSize =0;
		try {
			JSONObject jObj = new JSONObject();
			
			jObj.put(ClientProtocolID.DX_EX_CODE, ClientTranCodeType.DxT017);
			jObj.put(ClientProtocolID.COMMAND_CODE, ClientProtocolID.COMMAND_CODE_R);
			jObj.put(ClientProtocolID.SERVER_INFO, serverObj);
			
			jObj.put(ClientProtocolID.TABLE_INFO, arrTableInfo);

			JSONObject objList;
			
			ClientAdapter CA = new ClientAdapter(IP, PORT);
			CA.open(); 

			objList = CA.dxT017(jObj);
			
			CA.close();
			
			String strErrMsg = (String)objList.get(ClientProtocolID.ERR_MSG);
			String strErrCode = (String)objList.get(ClientProtocolID.ERR_CODE);
			String strDxExCode = (String)objList.get(ClientProtocolID.DX_EX_CODE);
			String strResultCode = (String)objList.get(ClientProtocolID.RESULT_CODE);

			List<Object> selectDBList =(ArrayList<Object>) objList.get(ClientProtocolID.RESULT_DATA);
			
			tblmappsSize= selectDBList.size();
			return tblmappsSize;
			//CA.close();
		} catch(Exception e) {
			e.printStackTrace();
		}
		return tblmappsSize;
	}
	
	// kafka_con_config insert
	public void kafkaConConfig_insert(String IP, int PORT, JSONObject serverObj, JSONObject tableInfoObj) {
		try {

			JSONObject jObj = new JSONObject();

			jObj.put(ClientProtocolID.DX_EX_CODE, ClientTranCodeType.DxT018);
			jObj.put(ClientProtocolID.COMMAND_CODE, ClientProtocolID.COMMAND_CODE_C);
			jObj.put(ClientProtocolID.SERVER_INFO, serverObj);
			jObj.put(ClientProtocolID.TABLE_INFO, tableInfoObj);

			JSONObject objList;

			ClientAdapter CA = new ClientAdapter(IP, PORT);
			CA.open();

			objList = CA.dxT018(jObj);
			CA.close();

			String strErrMsg = (String) objList.get(ClientProtocolID.ERR_MSG);
			String strErrCode = (String) objList.get(ClientProtocolID.ERR_CODE);
			String strDxExCode = (String) objList.get(ClientProtocolID.DX_EX_CODE);
			String strResultCode = (String) objList.get(ClientProtocolID.RESULT_CODE);

			// CA.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	// kafka_con_config delete
	public void kafkaConConfig_delete(String IP, int PORT, JSONObject serverObj, JSONObject tableInfoObj) {
		try {
			JSONObject jObj = new JSONObject();

			jObj.put(ClientProtocolID.DX_EX_CODE, ClientTranCodeType.DxT018);
			jObj.put(ClientProtocolID.COMMAND_CODE, ClientProtocolID.COMMAND_CODE_D);
			jObj.put(ClientProtocolID.SERVER_INFO, serverObj);
			jObj.put(ClientProtocolID.TABLE_INFO, tableInfoObj);

			JSONObject objList;

			ClientAdapter CA = new ClientAdapter(IP, PORT);
			CA.open();

			objList = CA.dxT018(jObj);

			String strErrMsg = (String) objList.get(ClientProtocolID.ERR_MSG);
			String strErrCode = (String) objList.get(ClientProtocolID.ERR_CODE);
			String strDxExCode = (String) objList.get(ClientProtocolID.DX_EX_CODE);
			String strResultCode = (String) objList.get(ClientProtocolID.RESULT_CODE);

			CA.close();

			// CA.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public Map<String, Object> getHostName(String IP, int PORT) {
		Map<String, Object> result = new HashMap<String, Object>();
		try {
		JSONObject jObj = new JSONObject();
			
		jObj.put(ClientProtocolID.DX_EX_CODE, ClientTranCodeType.DxT019);
		JSONObject objList;
		
		ClientAdapter CA = new ClientAdapter(IP, PORT);
		CA.open(); 

		objList = CA.dxT019(jObj);	
		CA.close();
		
		String strErrMsg = (String)objList.get(ClientProtocolID.ERR_MSG);
		String strErrCode = (String)objList.get(ClientProtocolID.ERR_CODE);
		String strDxExCode = (String)objList.get(ClientProtocolID.DX_EX_CODE);
		String strResultCode = (String)objList.get(ClientProtocolID.RESULT_CODE);

		HashMap resultHp = (HashMap) objList.get(ClientProtocolID.RESULT_DATA);

		String host = resultHp.get("CMD_HOSTNAME").toString();
		result.put("host", host);
		
		
		} catch(Exception e) {
			e.printStackTrace();
		}
		
		return result;
	}

	public Map<String, Object> DbserverConnTest(JSONObject serverObj, String IP, int PORT) {
		
		Map<String, Object> result = new HashMap<String, Object>();
		try {
			
			JSONArray arrServerInfo = new JSONArray();
			arrServerInfo.add(serverObj);
/*			for(int i=0; i<rows.size(); i++){
				JSONObject jsonObject = (JSONObject) rows.get(i);
				JSONObject serverObj = new JSONObject();			
				
				serverObj.put(ClientProtocolID.SERVER_NAME, jsonObject.get("SERVER_IP").toString());
				serverObj.put(ClientProtocolID.SERVER_IP, jsonObject.get("SERVER_IP").toString());
				serverObj.put(ClientProtocolID.SERVER_PORT, jsonObject.get("SERVER_PORT").toString());
				serverObj.put(ClientProtocolID.DATABASE_NAME, jsonObject.get("DATABASE_NAME").toString());
				serverObj.put(ClientProtocolID.USER_ID, jsonObject.get("USER_ID").toString());
				serverObj.put(ClientProtocolID.USER_PWD, jsonObject.get("USER_PWD").toString());
				arrServerInfo.add(serverObj);
			}*/
			
			JSONObject jObj = new JSONObject();
			
			
			jObj.put(ClientProtocolID.DX_EX_CODE, ClientTranCodeType.DxT020);
			jObj.put(ClientProtocolID.ARR_SERVER_INFO, arrServerInfo);

			JSONObject objList;
			
			ClientAdapter CA = new ClientAdapter(IP, PORT);
			CA.open(); 

			objList = CA.dxT020(jObj);
			
			CA.close();
			
			String strErrMsg = (String)objList.get(ClientProtocolID.ERR_MSG);
			String strErrCode = (String)objList.get(ClientProtocolID.ERR_CODE);
			String strDxExCode = (String)objList.get(ClientProtocolID.DX_EX_CODE);
			String strResultCode = (String)objList.get(ClientProtocolID.RESULT_CODE);
			
			JSONArray arrResult = (JSONArray) objList.get(ClientProtocolID.RESULT_DATA);
			
			if(strResultCode.equals("0")) {
				for(int i=0; i<arrResult.size(); i++) {
					
					JSONObject outObj = new JSONObject();
					outObj = (JSONObject) arrResult.get(i);

					String strServerIP = (String) outObj.get(ClientProtocolID.SERVER_IP);
					String strServerPort = (String) outObj.get(ClientProtocolID.SERVER_PORT);
					String strDatabaseName = (String) outObj.get(ClientProtocolID.DATABASE_NAME);
					String strMasterGbn = (String) outObj.get(ClientProtocolID.MASTER_GBN); 
					String strConnectYn = (String) outObj.get(ClientProtocolID.CONNECT_YN); 
					String strDBHostName = (String) outObj.get(ClientProtocolID.CMD_HOSTNAME); 
					
					result.put("result_code", strResultCode);
					result.put("result_data", arrResult);
					/*result.put("ipadr", strServerIP);
					result.put("master_gbn", strMasterGbn);
					result.put("connYn", strConnectYn);*/
				}
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	// DBMS정보
	public JSONObject dbms_inforamtion(String IP, int PORT, JSONObject serverObj) {
		JSONObject resultHp = null;
		try {
			JSONObject jObj = new JSONObject();
			jObj.put(ClientProtocolID.DX_EX_CODE, ClientTranCodeType.DxT021);
			jObj.put(ClientProtocolID.SERVER_INFO, serverObj);
			JSONObject objList;
			ClientAdapter CA = new ClientAdapter(IP, PORT);
			CA.open(); 
			objList = CA.dxT021(jObj);
			CA.close();
			
			String strErrMsg = (String)objList.get(ClientProtocolID.ERR_MSG);
			String strErrCode = (String)objList.get(ClientProtocolID.ERR_CODE);
			String strDxExCode = (String)objList.get(ClientProtocolID.DX_EX_CODE);
			String strResultCode = (String)objList.get(ClientProtocolID.RESULT_CODE);
			
			resultHp = (JSONObject) objList.get(ClientProtocolID.RESULT_DATA);
	
		} catch(Exception e) {
			e.printStackTrace();
		}
		return resultHp;
	}	
	
	
	
	public Map<String, Object> setInit(String IP, int PORT, String bck_pth) {
		Map<String, Object> result = new HashMap<String, Object>();
		try {	
			JSONObject jObj = new JSONObject();
			
			String strPath = bck_pth;
			
			jObj.put(ClientProtocolID.DX_EX_CODE, ClientTranCodeType.DxT022);
			jObj.put(ClientProtocolID.CMD_BACKUP_PATH, strPath);
				
			JSONObject objList;
			
			ClientAdapter CA = new ClientAdapter(IP, PORT);
			CA.open(); 

			objList = CA.dxT022(jObj);
			
			CA.close();
			
			String strErrMsg = (String)objList.get(ClientProtocolID.ERR_MSG);
			String strErrCode = (String)objList.get(ClientProtocolID.ERR_CODE);
			String strDxExCode = (String)objList.get(ClientProtocolID.DX_EX_CODE);
			String strResultCode = (String)objList.get(ClientProtocolID.RESULT_CODE);

			result.put("result", strResultCode);
			
		} catch(Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	
	public HashMap back_path_call(String IP, int PORT) {
		HashMap resultHp = null;
		try {			
			JSONObject jObj = new JSONObject();	
			jObj.put(ClientProtocolID.DX_EX_CODE, ClientTranCodeType.DxT019);

			JSONObject objList;
			
			ClientAdapter CA = new ClientAdapter(IP, PORT);
			CA.open(); 

			objList = CA.dxT019(jObj);
			
			CA.close();
			
			String strErrMsg = (String)objList.get(ClientProtocolID.ERR_MSG);
			String strErrCode = (String)objList.get(ClientProtocolID.ERR_CODE);
			String strDxExCode = (String)objList.get(ClientProtocolID.DX_EX_CODE);
			String strResultCode = (String)objList.get(ClientProtocolID.RESULT_CODE);

			resultHp = (HashMap) objList.get(ClientProtocolID.RESULT_DATA);
						
			Iterator<String> keys = resultHp.keySet().iterator();

	        while( keys.hasNext() ){
	            String key = keys.next();
	            System.out.println( String.format("키 : %s, 값 : %s", key, resultHp.get(key)) );
	        }
				
		} catch(Exception e) {
			e.printStackTrace();
		}
		return resultHp;
	}
	
	public String file_path(String IP, int PORT,String strFile) {
		String checkFile="1";
		try {
			JSONObject jObj = new JSONObject();
			
			jObj.put(ClientProtocolID.DX_EX_CODE, ClientTranCodeType.DxT023);
			jObj.put(ClientProtocolID.FILE_NAME, strFile);

			JSONObject objList;
			
			ClientAdapter CA = new ClientAdapter(IP, PORT);
			CA.open(); 

			objList = CA.dxT016(jObj);
			
			HashMap obj = (HashMap)objList.get(ClientProtocolID.RESULT_DATA);
			
			checkFile = (String)obj.get(ClientProtocolID.IS_FILE);
			
			CA.close();
		} catch(Exception e) {
			e.printStackTrace();
		}
		return checkFile;
	}
	
	
	public List<HashMap<String, String>> rmanShow(String IP, int PORT,String cmd) {
		

		List<HashMap<String, String>> rmanList = null;
		
		try {
			JSONObject serverObj = new JSONObject();
			
			serverObj.put(ClientProtocolID.SERVER_NAME, IP);
			serverObj.put(ClientProtocolID.SERVER_IP, Integer.toString(PORT));
			
			
			JSONObject jObj = new JSONObject();
			jObj.put(ClientProtocolID.DX_EX_CODE, ClientTranCodeType.DxT025);
			jObj.put(ClientProtocolID.SERVER_INFO, serverObj);
			jObj.put(ClientProtocolID.FILE_DIRECTORY, cmd);

			JSONObject objList;
			
			ClientAdapter CA = new ClientAdapter(IP, PORT);
			CA.open(); 
				
			objList = CA.dxT025(jObj);
			
			String strErrMsg = (String)objList.get(ClientProtocolID.ERR_MSG);
			String strErrCode = (String)objList.get(ClientProtocolID.ERR_CODE);
			String strDxExCode = (String)objList.get(ClientProtocolID.DX_EX_CODE);
			String strResultCode = (String)objList.get(ClientProtocolID.RESULT_CODE);
			System.out.println("RESULT_CODE : " +  strResultCode);
			System.out.println("ERR_CODE : " +  strErrCode);
			System.out.println("ERR_MSG : " +  strErrMsg);
			
			rmanList = (List<HashMap<String, String>>) objList.get(ClientProtocolID.RESULT_DATA);
			
		} catch(Exception e) {
			e.printStackTrace();
		}
		return rmanList;
	}
	
	
public List<HashMap<String, String>> dumpShow(String IP, int PORT,String cmd) {
		

		List<HashMap<String, String>> dumpList = null;
		
		try {
			JSONObject serverObj = new JSONObject();
			
			serverObj.put(ClientProtocolID.SERVER_NAME, IP);
			serverObj.put(ClientProtocolID.SERVER_IP, Integer.toString(PORT));
			
			
			JSONObject jObj = new JSONObject();
			jObj.put(ClientProtocolID.DX_EX_CODE, ClientTranCodeType.DxT024);
			jObj.put(ClientProtocolID.SERVER_INFO, serverObj);
			jObj.put(ClientProtocolID.FILE_DIRECTORY, cmd);

			JSONObject objList;
			
			ClientAdapter CA = new ClientAdapter(IP, PORT);
			CA.open(); 
				
			objList = CA.dxT024(jObj);
			
			String strErrMsg = (String)objList.get(ClientProtocolID.ERR_MSG);
			String strErrCode = (String)objList.get(ClientProtocolID.ERR_CODE);
			String strDxExCode = (String)objList.get(ClientProtocolID.DX_EX_CODE);
			String strResultCode = (String)objList.get(ClientProtocolID.RESULT_CODE);
			System.out.println("RESULT_CODE : " +  strResultCode);
			System.out.println("ERR_CODE : " +  strErrCode);
			System.out.println("ERR_MSG : " +  strErrMsg);
			
			dumpList = (List<HashMap<String, String>>) objList.get(ClientProtocolID.RESULT_DATA);
			System.out.println(dumpList);
		} catch(Exception e) {
			e.printStackTrace();
		}
		return dumpList;
	}


	public void extensionCreate(JSONObject serverObj, String IP, int PORT, String strExtname) {
		
		try {			
			
			System.out.println(IP);
			System.out.println(PORT);
			System.out.println(strExtname);
			
			JSONObject jObj = new JSONObject();
			
			ClientAdapter CA = new ClientAdapter(IP, PORT);
			CA.open(); 
			
			JSONObject objList;

			
			jObj.put(ClientProtocolID.DX_EX_CODE, ClientTranCodeType.DxT026);
			jObj.put(ClientProtocolID.SERVER_INFO, serverObj);
			jObj.put(ClientProtocolID.EXTENSION, strExtname);
			
			objList = CA.dxT026(jObj);
			
			String strErrMsg = (String)objList.get(ClientProtocolID.ERR_MSG);
			String strErrCode = (String)objList.get(ClientProtocolID.ERR_CODE);
			String strDxExCode = (String)objList.get(ClientProtocolID.DX_EX_CODE);
			String strResultCode = (String)objList.get(ClientProtocolID.RESULT_CODE);

			CA.close();
		} catch(Exception e) {
			e.printStackTrace();
		}
	}

	
	public HashMap restorePath(String IP, int PORT) {
		HashMap result = new HashMap();
		
		try {		
			JSONObject jObj = new JSONObject();
				
			jObj.put(ClientProtocolID.DX_EX_CODE, ClientTranCodeType.DxT027);
		
			JSONObject objList;
			
			ClientAdapter CA = new ClientAdapter(IP, PORT);
			CA.open(); 

			objList = CA.dxT027(jObj);	
			CA.close();
			
			String strErrMsg = (String)objList.get(ClientProtocolID.ERR_MSG);
			String strErrCode = (String)objList.get(ClientProtocolID.ERR_CODE);
			String strDxExCode = (String)objList.get(ClientProtocolID.DX_EX_CODE);
			String strResultCode = (String)objList.get(ClientProtocolID.RESULT_CODE);
			System.out.println("RESULT_CODE : " +  strResultCode);
			System.out.println("ERR_CODE : " +  strErrCode);
			System.out.println("ERR_MSG : " +  strErrMsg);

		  result = (HashMap) objList.get(ClientProtocolID.RESULT_DATA);
				
			Iterator<String> keys = result.keySet().iterator();

	        while( keys.hasNext() ){
	            String key = keys.next();
	            System.out.println( String.format("키 : %s, 값 : %s", key, result.get(key)) );
	        }
	   	       
		} catch(Exception e) {
			e.printStackTrace();
		}		
		return result;		
	}


	
	public void rmanRestoreStart(JSONObject serverObj, String IP, int PORT, RestoreRmanVO restoreRmanVO) {
	try {	
			JSONObject jObj = new JSONObject();

			jObj.put(ClientProtocolID.DX_EX_CODE, ClientTranCodeType.DxT028);
			
			//RESTORE_SN
			String RESTORE_SN = String.valueOf(restoreRmanVO.getRestore_sn());
			jObj.put(ClientProtocolID.RESTORE_SN, RESTORE_SN);
			//RESTORE_FLAG
			String RESTORE_FLAG = restoreRmanVO.getRestore_flag();
			jObj.put(ClientProtocolID.RESTORE_FLAG, RESTORE_FLAG);
			//TIMELINE
			String TIMELINE = restoreRmanVO.getTimeline_dt()+" "+restoreRmanVO.getTimeline_h()+":"+restoreRmanVO.getTimeline_m()+":"+restoreRmanVO.getTimeline_s();
			System.out.println("TIMELINE ==========="+ TIMELINE);
			jObj.put(ClientProtocolID.TIMELINE, TIMELINE);
			//PGDATA
			String PGDATA = restoreRmanVO.getDtb_pth();
			jObj.put(ClientProtocolID.PGDATA, PGDATA);
			//PGALOG
			String PGALOG = restoreRmanVO.getPgalog_pth();
			jObj.put(ClientProtocolID.PGALOG, PGALOG);
			//SRVLOG
			String SRVLOG = restoreRmanVO.getSvrlog_pth();
			jObj.put(ClientProtocolID.SRVLOG, SRVLOG);
			//PGRBAK
			String PGRBAK = restoreRmanVO.getBck_pth();
			jObj.put(ClientProtocolID.PGRBAK, PGRBAK);			
			//ASIS_FLAG
			String ASIS_FLAG = restoreRmanVO.getAsis_flag();
			jObj.put(ClientProtocolID.ASIS_FLAG, ASIS_FLAG);			
			//RESTORE_DIR
			String RESTORE_DIR = restoreRmanVO.getRestore_dir();
			jObj.put(ClientProtocolID.RESTORE_DIR, RESTORE_DIR);			
			
			System.out.println("=========== RMAN Restore 정보 ============");
			System.out.println("RESTORE_SN = "+RESTORE_SN);
			System.out.println("RESTORE_FLAG = "+RESTORE_FLAG);
			System.out.println("TIMELINE = "+TIMELINE);
			System.out.println("PGDATA = "+PGDATA);
			System.out.println("PGALOG = "+PGALOG);
			System.out.println("SRVLOG = "+SRVLOG);
			System.out.println("PGRBAK = "+PGRBAK);
			System.out.println("ASIS_FLAG = "+ASIS_FLAG);
			System.out.println("RESTORE_DIR = "+"");					
			System.out.println("=====================================");
			
			//SERVER_INFO
			jObj.put(ClientProtocolID.SERVER_INFO, serverObj);

			JSONObject objList;
			
			ClientAdapter CA = new ClientAdapter(IP, PORT);
			CA.open(); 

			objList = CA.dxT028(jObj);
			
			CA.close();
			
			String strErrMsg = (String)objList.get(ClientProtocolID.ERR_MSG);
			String strErrCode = (String)objList.get(ClientProtocolID.ERR_CODE);
			String strDxExCode = (String)objList.get(ClientProtocolID.DX_EX_CODE);
			String strResultCode = (String)objList.get(ClientProtocolID.RESULT_CODE);
			
			System.out.println("RESULT_CODE : " +  strResultCode);
			System.out.println("ERR_CODE : " +  strErrCode);
			System.out.println("ERR_MSG : " +  strErrMsg);
			
		} catch(Exception e) {
			e.printStackTrace();
		}		
	}
	
	
	public void dumpRestoreStart(JSONObject serverObj, String IP, int PORT, RestoreDumpVO restoreDumpVO) {
			try {	
					JSONObject jObj = new JSONObject();
							
					jObj.put(ClientProtocolID.DX_EX_CODE, ClientTranCodeType.DxT030);
					
					System.out.println("RESTORE_SN="+restoreDumpVO.getRestore_sn());
					
					jObj.put(ClientProtocolID.RESTORE_SN, restoreDumpVO.getRestore_sn());
					jObj.put(ClientProtocolID.PGDBAK, restoreDumpVO.getBck_file_pth());					
					jObj.put(ClientProtocolID.DB_NM, restoreDumpVO.getDb_nm());
					
					
					//SERVER_INFO
					jObj.put(ClientProtocolID.SERVER_INFO, serverObj);
		
					JSONObject dumpOptionObj = new JSONObject();
					
					dumpOptionObj.put(ClientProtocolID.FORMAT, restoreDumpVO.getFormat());
					dumpOptionObj.put(ClientProtocolID.FILENAME, restoreDumpVO.getFilename());
					dumpOptionObj.put(ClientProtocolID.JOBS, restoreDumpVO.getJobs());
					dumpOptionObj.put(ClientProtocolID.ROLE, restoreDumpVO.getRole());
					dumpOptionObj.put(ClientProtocolID.PRE_DATA, restoreDumpVO.getPre_data_yn());
					dumpOptionObj.put(ClientProtocolID.DATA, restoreDumpVO.getData_yn());
					dumpOptionObj.put(ClientProtocolID.POST_DATA, restoreDumpVO.getPost_data_yn());
					dumpOptionObj.put(ClientProtocolID.DATA_ONLY, restoreDumpVO.getData_only_yn());
					dumpOptionObj.put(ClientProtocolID.SCHEMA_ONLY, restoreDumpVO.getSchema_only_yn());
					dumpOptionObj.put(ClientProtocolID.NO_OWNER, restoreDumpVO.getNo_owner_yn());
					dumpOptionObj.put(ClientProtocolID.NO_PRIVILEGES, restoreDumpVO.getNo_privileges_yn());
					dumpOptionObj.put(ClientProtocolID.NO_TABLESPACES, restoreDumpVO.getNo_tablespaces_yn());
					dumpOptionObj.put(ClientProtocolID.CREATE, restoreDumpVO.getCreate_yn());
					dumpOptionObj.put(ClientProtocolID.CLEAN, restoreDumpVO.getClean_yn());
					dumpOptionObj.put(ClientProtocolID.SINGLE_TRANSACTION, restoreDumpVO.getSingle_transaction_yn());
					dumpOptionObj.put(ClientProtocolID.DISABLE_TRIGGERS, restoreDumpVO.getDisable_triggers_yn());
					dumpOptionObj.put(ClientProtocolID.NO_DATA_FOR_FAILED_TABLES, restoreDumpVO.getNo_data_for_failed_tables_yn());
					dumpOptionObj.put(ClientProtocolID.VERBOSE, restoreDumpVO.getVerbose_yn());
					dumpOptionObj.put(ClientProtocolID.USE_SET_SESSON_AUTH, restoreDumpVO.getUse_set_sesson_auth_yn());
					dumpOptionObj.put(ClientProtocolID.EXIT_ON_ERROR, restoreDumpVO.getExit_on_error_yn());
					
					//컬럼추가 2020.08.07
					dumpOptionObj.put(ClientProtocolID.BLOBS_ONLY_YN, restoreDumpVO.getBlobs_only_yn());
					dumpOptionObj.put(ClientProtocolID.NO_UNLOGGED_TABLE_DATA_YN, restoreDumpVO.getNo_unlogged_table_data_yn());
					dumpOptionObj.put(ClientProtocolID.USE_COLUMN_INSERTS_YN, restoreDumpVO.getUse_column_inserts_yn());
					dumpOptionObj.put(ClientProtocolID.USE_COLUMN_COMMANDS_YN, restoreDumpVO.getUse_column_commands_yn());
					dumpOptionObj.put(ClientProtocolID.OIDS_YN, restoreDumpVO.getOids_yn());
					dumpOptionObj.put(ClientProtocolID.IDENTIFIER_QUOTES_APPLY_YN, restoreDumpVO.getIdentifier_quotes_apply_yn());
					dumpOptionObj.put(ClientProtocolID.OBJ_CMD, restoreDumpVO.getObj_cmd());

					jObj.put(ClientProtocolID.DUMP_OPTION, dumpOptionObj);
					
					
					JSONObject objList;
					
					ClientAdapter CA = new ClientAdapter(IP, PORT);
					CA.open(); 

					objList = CA.dxT030(jObj);
					
					CA.close();
					
					String strErrMsg = (String)objList.get(ClientProtocolID.ERR_MSG);
					String strErrCode = (String)objList.get(ClientProtocolID.ERR_CODE);
					String strDxExCode = (String)objList.get(ClientProtocolID.DX_EX_CODE);
					String strResultCode = (String)objList.get(ClientProtocolID.RESULT_CODE);
										
					System.out.println("RESULT_CODE : " +  strResultCode);
					System.out.println("ERR_CODE : " +  strErrCode);
					System.out.println("ERR_MSG : " +  strErrMsg);

			} catch(Exception e) {
				e.printStackTrace();
			}		
	}
	
	
	public Map<String, Object> restoreLog(String IP, int PORT, String restore_sn) {
		
		Map<String, Object> result = new HashMap<String, Object>();
		
		try {								
			JSONObject jObj = new JSONObject();
			
			jObj.put(ClientProtocolID.DX_EX_CODE, ClientTranCodeType.DxT029);
			
			//RESTORE_SN
			jObj.put(ClientProtocolID.RESTORE_SN, restore_sn);
			

			JSONObject objList;
			
			ClientAdapter CA = new ClientAdapter(IP, PORT);
			CA.open(); 

			objList = CA.dxT029(jObj);
			
			CA.close();
			
			String strErrMsg = (String)objList.get(ClientProtocolID.ERR_MSG);
			String strErrCode = (String)objList.get(ClientProtocolID.ERR_CODE);
			String strDxExCode = (String)objList.get(ClientProtocolID.DX_EX_CODE);
			String strResultCode = (String)objList.get(ClientProtocolID.RESULT_CODE);
			String strResultData = (String)objList.get(ClientProtocolID.RESULT_DATA);
			
			System.out.println("RESULT_CODE : " +  strResultCode);
			System.out.println("ERR_CODE : " +  strErrCode);
			System.out.println("ERR_MSG : " +  strErrMsg);
			System.out.println("strResultData : " +  strResultData);

			result.put("RESULT_CODE", strResultCode);
			result.put("ERR_CODE", strErrCode);
			result.put("ERR_MSG", strErrMsg);
			result.put("strResultData", strResultData);
				
		} catch(Exception e) {
			e.printStackTrace();
		}	
		return result;		
	}
	
	public Map<String, Object> switchWalFile(JSONObject serverObj, String IP, int PORT) {
		
		Map<String, Object> result = new HashMap<String, Object>();
		
		try {								
			JSONObject jObj = new JSONObject();
			
			ClientAdapter CA = new ClientAdapter(IP, PORT);
			CA.open(); 
			
			JSONObject objList;

			
			jObj.put(ClientProtocolID.DX_EX_CODE, ClientTranCodeType.DxT032);
			jObj.put(ClientProtocolID.SERVER_INFO, serverObj);
			
			objList = CA.dxT032(jObj);
			
			String strErrMsg = (String)objList.get(ClientProtocolID.ERR_MSG);
			String strErrCode = (String)objList.get(ClientProtocolID.ERR_CODE);
			String strDxExCode = (String)objList.get(ClientProtocolID.DX_EX_CODE);
			String strResultCode = (String)objList.get(ClientProtocolID.RESULT_CODE);

			result.put("RESULT_CODE", strResultCode);
			result.put("ERR_CODE", strErrCode);
			result.put("ERR_MSG", strErrMsg);
			
			CA.close();
		} catch(Exception e) {
			e.printStackTrace();
		}	
		return result;		
	}
	
	
	public Map<String, Object> dumpRestoreLog(String IP, int PORT, String restore_sn) {
		
		Map<String, Object> result = new HashMap<String, Object>();
		
		try {								
			JSONObject jObj = new JSONObject();
			
			jObj.put(ClientProtocolID.DX_EX_CODE, ClientTranCodeType.DxT031);
			
			//RESTORE_SN
			jObj.put(ClientProtocolID.RESTORE_SN, restore_sn);
			
			JSONObject objList;
			
			ClientAdapter CA = new ClientAdapter(IP, PORT);
			CA.open(); 

			objList = CA.dxT031(jObj);
			
			CA.close();
			
			String strErrMsg = (String)objList.get(ClientProtocolID.ERR_MSG);
			String strErrCode = (String)objList.get(ClientProtocolID.ERR_CODE);
			String strDxExCode = (String)objList.get(ClientProtocolID.DX_EX_CODE);
			String strResultCode = (String)objList.get(ClientProtocolID.RESULT_CODE);
			String strResultData = (String)objList.get(ClientProtocolID.RESULT_DATA);
		
			System.out.println("RESULT_CODE : " +  strResultCode);
			System.out.println("ERR_CODE : " +  strErrCode);
			System.out.println("ERR_MSG : " +  strErrMsg);
			System.out.println("strResultData : " +  strResultData);
			
			result.put("RESULT_CODE", strResultCode);
			result.put("ERR_CODE", strErrCode);
			result.put("ERR_MSG", strErrMsg);
			result.put("strResultData", strResultData);
				
		} catch(Exception e) {
			e.printStackTrace();
		}	
		return result;		
	}
		
	
	//33. 스키마 리스트
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public JSONObject schemaList(JSONObject serverObj,String IP, int PORT) {

		JSONArray jsonArray = new JSONArray(); // 객체를 담기위해 JSONArray 선언.
		JSONObject result = new JSONObject();

		try {
			JSONObject objList;

			ClientAdapter CA = new ClientAdapter(IP, PORT);
			CA.open();

			objList = CA.dxT033(ClientTranCodeType.DxT033, serverObj);

			String strErrMsg = (String) objList.get(ClientProtocolID.ERR_MSG);
			String strDxExCode = (String) objList.get(ClientProtocolID.DX_EX_CODE);

			List<Object> selectSchemaList = (ArrayList<Object>) objList.get(ClientProtocolID.RESULT_DATA);

			if(selectSchemaList.size() > 0) {
				for(int i=0; i<selectSchemaList.size(); i++) {
					JSONObject jsonObj = new JSONObject();
					Object obj = selectSchemaList.get(i);
					
					HashMap hp = (HashMap) obj;
					String schema = (String) hp.get("name");

					jsonObj.put("schema", (String) hp.get("name"));
					jsonArray.add(jsonObj);
	
				}
			}
			CA.close();
			result.put("data", jsonArray);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	
	//34. 즉시실행
	public Map<String, Object> immediate(String IP, int PORT, String cmd, List<Map<String, Object>> resultWork, String bck_fileNm) {
		
		Map<String, Object> result = new HashMap<String, Object>();
		JSONArray arrCmd = new JSONArray();
		
		String bckCmd = cmd;
		
		try {
			
			JSONObject jObj = new JSONObject();
							
			arrCmd.add(0, bckCmd);

			if(resultWork.get(0).get("bck_opt_cd") != null && resultWork.get(0).get("bck_bsn_dscd").equals("TC000201")){
				String validateCmd = "pg_rman validate -B "+resultWork.get(0).get("bck_pth").toString(); 
				arrCmd.add(1, validateCmd);
			}
			
			if(resultWork.get(0).get("bck_bsn_dscd").equals("TC000201")){
				jObj.put(ClientProtocolID.BCK_OPT_CD, resultWork.get(0).get("bck_opt_cd").toString());
				jObj.put(ClientProtocolID.BCK_FILE_PTH, resultWork.get(0).get("bck_pth").toString());
			}else{
				jObj.put(ClientProtocolID.BCK_FILE_PTH, resultWork.get(0).get("save_pth").toString());
			}
			
			jObj.put(ClientProtocolID.WORK_ID, resultWork.get(0).get("wrk_id").toString()); 
			jObj.put(ClientProtocolID.BCK_BSN_DSCD, resultWork.get(0).get("bck_bsn_dscd").toString());
			jObj.put(ClientProtocolID.DB_SVR_IPADR_ID, resultWork.get(0).get("db_svr_ipadr_id").toString());
			jObj.put(ClientProtocolID.DB_ID, resultWork.get(0).get("db_id").toString());
			jObj.put(ClientProtocolID.BCK_FILENM, bck_fileNm.toString());
			jObj.put(ClientProtocolID.DX_EX_CODE, ClientTranCodeType.DxT034);
			jObj.put(ClientProtocolID.ARR_CMD, arrCmd);
			
			JSONObject objList;
			
			ClientAdapter CA = new ClientAdapter(IP, PORT);
			CA.open(); 

			objList = CA.dxT034(jObj);
		
			CA.close();
			
			String strErrMsg = (String)objList.get(ClientProtocolID.ERR_MSG);
			String strErrCode = (String)objList.get(ClientProtocolID.ERR_CODE);
			String strDxExCode = (String)objList.get(ClientProtocolID.DX_EX_CODE);
			String strResultCode = (String)objList.get(ClientProtocolID.RESULT_CODE);

			System.out.println("RESULT_CODE : " +  strResultCode);
			System.out.println("ERR_CODE : " +  strErrCode);
			System.out.println("ERR_MSG : " +  strErrMsg);


			result.put("RESULT_CODE", strResultCode);
			result.put("ERR_CODE", strErrCode);
			result.put("ERR_MSG", strErrMsg);

			
		}catch (Exception e) {
			e.printStackTrace();
		}	
		return result;
		
	}

	/* 36. scale 실행 */
	public Map<String, Object> scale_exec_call(String IP, int PORT, String cmd, String subCmd, JSONObject param) {
		Map<String, Object> result = new HashMap<String, Object>();
		HashMap resultHp = null;
		JSONArray arrCmd = new JSONArray();

		try {
			arrCmd.add(0, cmd);
			if (!subCmd.equals("")) {
				arrCmd.add(1, subCmd);
			}

			JSONObject objList;
			JSONObject jObj = new JSONObject();	
			jObj.put(ClientProtocolID.DX_EX_CODE, ClientTranCodeType.DxT036);
			jObj.put(ClientProtocolID.SCALE_COUNT_SET, param.get("scale_count").toString());     //scale 갯수
			jObj.put(ClientProtocolID.SCALE_SET, param.get("scale_set").toString());             //scale 구분
			jObj.put(ClientProtocolID.SEARCH_GBN, param.get("search_gbn").toString());           //조회구분
			jObj.put(ClientProtocolID.ARR_CMD, arrCmd);
			jObj.put(ClientProtocolID.PROCESS_ID, param.get("process_id").toString());           //프로세스 ID
			jObj.put(ClientProtocolID.LOGIN_ID, param.get("login_id").toString());               //로그인 ID
			jObj.put(ClientProtocolID.DB_SVR_IPADR_ID, param.get("db_svr_ipadr_id").toString()); //DB_서버_IP주소_ID
			jObj.put(ClientProtocolID.DB_SVR_ID, param.get("db_svr_id").toString());             //DB_서버_ID
			jObj.put(ClientProtocolID.WRK_TYPE, "TC003302");                                     //작업유형
			jObj.put(ClientProtocolID.AUTO_POLICY, "");                                          //AUTO_정책
			jObj.put(ClientProtocolID.AUTO_POLICY_SET_DIV, "");
			jObj.put(ClientProtocolID.AUTO_POLICY_TIME, "");
			jObj.put(ClientProtocolID.AUTO_LEVEL, "");

			ClientAdapter CA = new ClientAdapter(IP, PORT);
			CA.open(); 
			
			objList = CA.dxT036(jObj);
			
			CA.close();

			String strErrMsg = (String)objList.get(ClientProtocolID.ERR_MSG);
			String strErrCode = (String)objList.get(ClientProtocolID.ERR_CODE);
			String strDxExCode = (String)objList.get(ClientProtocolID.DX_EX_CODE);
			String strResultCode = (String)objList.get(ClientProtocolID.RESULT_CODE);

			result.put("RESULT_CODE", strResultCode);
			result.put("ERR_CODE", strErrCode);
			result.put("ERR_MSG", strErrMsg);
			
			if (objList.get(ClientProtocolID.RESULT_DATA) != null) {
				result.put("RESULT_DATA", objList.get(ClientProtocolID.RESULT_DATA));
			} else {
				result.put("RESULT_DATA", null);
			}

			if (objList.get(ClientProtocolID.RESULT_SUB_DATA) != null) {
				result.put("RESULT_SUB_DATA", objList.get(ClientProtocolID.RESULT_SUB_DATA));
			} else {
				result.put("RESULT_SUB_DATA", null);
			}
			
			if (objList.get(ClientProtocolID.SCALE_LAST_NODE_CNT) != null) {
				result.put("LAST_NODE_CNT", objList.get(ClientProtocolID.SCALE_LAST_NODE_CNT));
			} else {
				result.put("LAST_NODE_CNT", null);
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	@Override
	public void run() {
		// TODO Auto-generated method stub
	}

	public Map<String, Object> kafkaConnectionTest(String IP, int PORT, String cmd) {
		
		
		Map<String, Object> result = new HashMap<String, Object>();
		
		try{
				
				JSONObject jObj = new JSONObject();
				
				jObj.put(ClientProtocolID.DX_EX_CODE, ClientTranCodeType.DxT037);
				jObj.put(ClientProtocolID.REQ_CMD, cmd);
				
				JSONObject objList;
				
				ClientAdapter CA = new ClientAdapter(IP, PORT);
				CA.open(); 
	
				objList = CA.dxT037(jObj);
			
				CA.close();
				
				String strErrMsg = (String)objList.get(ClientProtocolID.ERR_MSG);
				String strErrCode = (String)objList.get(ClientProtocolID.ERR_CODE);
				String strDxExCode = (String)objList.get(ClientProtocolID.DX_EX_CODE);
				String strResultCode = (String)objList.get(ClientProtocolID.RESULT_CODE);
				String strResultData = (String)objList.get(ClientProtocolID.RESULT_DATA);
		
				
				System.out.println("RESULT_CODE : " +  strResultCode);
				System.out.println("ERR_CODE : " +  strErrCode);
				System.out.println("ERR_MSG : " +  strErrMsg);
				System.out.println("RESULT_DATA : " +  strResultData);
				
				result.put("RESULT_CODE", strResultCode);
				result.put("ERR_CODE", strErrCode);
				result.put("ERR_MSG", strErrMsg);
				result.put("RESULT_DATA", strResultData);
			} catch(Exception e) {
				e.printStackTrace();
			}
		
		return result;
	}
	
	// 38. trans connect start
	public Map<String, Object> connectStart(String IP, int PORT, DbServerVO dbServerVO, List<Map<String, Object>> transInfo, List<Map<String, Object>> mappInfo) {
		Map<String, Object> result = new HashMap<String, Object>();
		
		try{
			String cmd = "curl -i -X POST -H 'Accept:application/json' -H 'Content-Type:application/json' " +transInfo.get(0).get("kc_ip")+":"+transInfo.get(0).get("kc_port")+"/connectors/ -d '";
			
			JSONObject serverObj = new JSONObject();
			
			serverObj.put(ClientProtocolID.SERVER_NAME, dbServerVO.getIpadr());
			serverObj.put(ClientProtocolID.SERVER_IP, dbServerVO.getIpadr());
			serverObj.put(ClientProtocolID.SERVER_PORT, dbServerVO.getPortno());
			serverObj.put(ClientProtocolID.DATABASE_NAME, transInfo.get(0).get("db_nm"));
			serverObj.put(ClientProtocolID.USER_ID, dbServerVO.getSvr_spr_usr_id());
			serverObj.put(ClientProtocolID.USER_PWD, dbServerVO.getSvr_spr_scm_pwd());

			JSONObject transObj = new JSONObject();
			transObj.put(ClientProtocolID.KC_IP, transInfo.get(0).get("kc_ip"));
			transObj.put(ClientProtocolID.KC_PORT, transInfo.get(0).get("kc_port"));
			transObj.put(ClientProtocolID.SNAPSHOT_MODE, transInfo.get(0).get("snapshot_nm"));
			transObj.put(ClientProtocolID.COMPRESSION_TYPE, transInfo.get(0).get("compression_nm"));
			transObj.put(ClientProtocolID.CONNECT_NM, transInfo.get(0).get("connect_nm"));
			transObj.put(ClientProtocolID.TRANS_ID, transInfo.get(0).get("trans_id").toString());
			transObj.put(ClientProtocolID.DB_NM, transInfo.get(0).get("db_nm"));
			transObj.put(ClientProtocolID.META_DATA, transInfo.get(0).get("meta_data"));
			
			transObj.put(ClientProtocolID.CON_START_GBN, "source");

			transObj.put(ClientProtocolID.TRANS_COM_ID, transInfo.get(0).get("trans_com_id"));

			JSONObject mappObj = new JSONObject();
			mappObj.put(ClientProtocolID.EXRT_TRG_SCM_NM, mappInfo.get(0).get("exrt_trg_scm_nm"));
			mappObj.put(ClientProtocolID.EXRT_TRG_TB_NM, mappInfo.get(0).get("exrt_trg_tb_nm"));			

			JSONObject jObj = new JSONObject();
			
			jObj.put(ClientProtocolID.DX_EX_CODE, ClientTranCodeType.DxT038);
			jObj.put(ClientProtocolID.SERVER_INFO, serverObj);
			jObj.put(ClientProtocolID.CONNECT_INFO, transObj);
			jObj.put(ClientProtocolID.MAPP_INFO, mappObj);
			jObj.put(ClientProtocolID.REQ_CMD, cmd);
			
			JSONObject objList;

			ClientAdapter CA = new ClientAdapter(IP, PORT);
	
			CA.open(); 
			objList = CA.dxT038(jObj);
			CA.close();

			String strErrMsg = (String)objList.get(ClientProtocolID.ERR_MSG);
			String strErrCode = (String)objList.get(ClientProtocolID.ERR_CODE);
			String strDxExCode = (String)objList.get(ClientProtocolID.DX_EX_CODE);
			String strResultCode = (String)objList.get(ClientProtocolID.RESULT_CODE);
			String strResultData = (String)objList.get(ClientProtocolID.RESULT_DATA);

			System.out.println("RESULT_CODE : " +  strResultCode);
			System.out.println("ERR_CODE : " +  strErrCode);
			System.out.println("ERR_MSG : " +  strErrMsg);
			System.out.println("RESULT_DATA : " +  strResultData);

			result.put("RESULT_CODE", strResultCode);
			result.put("ERR_CODE", strErrCode);
			result.put("ERR_MSG", strErrMsg);
			result.put("RESULT_DATA", strErrMsg);
			
		} catch(Exception e) {
			e.printStackTrace();
		}
		
		return result;
	}

	// 38. trans connect start - target
	public Map<String, Object> connectTargetStart(String IP, int PORT, DbServerVO dbServerVO, List<Map<String, Object>> transInfo, List<Map<String, Object>> mappInfo) throws UnsupportedEncodingException {
		Map<String, Object> result = new HashMap<String, Object>();
		AES256 dec = new AES256(AES256_KEY.ENC_KEY);
		
		try{
			String cmd = "curl -X POST -H 'Accept:application/json' -H 'Content-Type:application/json' " +transInfo.get(0).get("kc_ip")+":"+transInfo.get(0).get("kc_port")+"/connectors/ -d '";
System.out.println("=====cmd" + cmd);
			String con_ipadr = (String)transInfo.get(0).get("ipadr");
			String con_portno = transInfo.get(0).get("portno").toString();
			String con_dtb_nm = (String)transInfo.get(0).get("dtb_nm");
			
			String strConUrl = "jdbc:oracle:thin:@" + con_ipadr + ":" + con_portno + ":" + con_dtb_nm.toLowerCase();
			
			String con_pwd = (String)transInfo.get(0).get("pwd");
			
			if (con_pwd != null && !"".equals(con_pwd)) {
				con_pwd = dec.aesDecode(con_pwd);
			}

			JSONObject serverObj = new JSONObject();
			
			serverObj.put(ClientProtocolID.SERVER_NAME, dbServerVO.getIpadr());
			serverObj.put(ClientProtocolID.SERVER_IP, dbServerVO.getIpadr());
			serverObj.put(ClientProtocolID.SERVER_PORT, dbServerVO.getPortno());
			serverObj.put(ClientProtocolID.DATABASE_NAME, transInfo.get(0).get("db_nm"));
			serverObj.put(ClientProtocolID.USER_ID, dbServerVO.getSvr_spr_usr_id());
			serverObj.put(ClientProtocolID.USER_PWD, dbServerVO.getSvr_spr_scm_pwd());

			JSONObject transObj = new JSONObject();
			transObj.put(ClientProtocolID.CONNECT_NM, transInfo.get(0).get("connect_nm"));
			transObj.put(ClientProtocolID.KC_IP, transInfo.get(0).get("kc_ip"));
			transObj.put(ClientProtocolID.KC_PORT, transInfo.get(0).get("kc_port"));
			transObj.put(ClientProtocolID.TRANS_ID, transInfo.get(0).get("trans_id").toString());
			transObj.put(ClientProtocolID.CONNECTION_URL, strConUrl); 							//con_url
			transObj.put(ClientProtocolID.SPR_USR_ID, transInfo.get(0).get("spr_usr_id"));		//spr_usr_id
			transObj.put(ClientProtocolID.CONNECTION_PWD, con_pwd);								//pwd
			
			transObj.put(ClientProtocolID.CON_START_GBN, "target");

			JSONObject mappObj = new JSONObject();
			mappObj.put(ClientProtocolID.EXRT_TRG_TB_NM, mappInfo.get(0).get("exrt_trg_tb_nm"));

			JSONObject jObj = new JSONObject();
			
			jObj.put(ClientProtocolID.DX_EX_CODE, ClientTranCodeType.DxT038);
			jObj.put(ClientProtocolID.SERVER_INFO, serverObj);
			jObj.put(ClientProtocolID.CONNECT_INFO, transObj);
			jObj.put(ClientProtocolID.MAPP_INFO, mappObj);
			jObj.put(ClientProtocolID.REQ_CMD, cmd);
			
			JSONObject objList;

			ClientAdapter CA = new ClientAdapter(IP, PORT);
	
			CA.open(); 
			objList = CA.dxT038(jObj);
			CA.close();

			String strErrMsg = (String)objList.get(ClientProtocolID.ERR_MSG);
			String strErrCode = (String)objList.get(ClientProtocolID.ERR_CODE);
			String strDxExCode = (String)objList.get(ClientProtocolID.DX_EX_CODE);
			String strResultCode = (String)objList.get(ClientProtocolID.RESULT_CODE);
			String strResultData = (String)objList.get(ClientProtocolID.RESULT_DATA);

			System.out.println("RESULT_CODE : " +  strResultCode);
			System.out.println("ERR_CODE : " +  strErrCode);
			System.out.println("ERR_MSG : " +  strErrMsg);
			System.out.println("RESULT_DATA : " +  strResultData);

			result.put("RESULT_CODE", strResultCode);
			result.put("ERR_CODE", strErrCode);
			result.put("ERR_MSG", strErrMsg);
			result.put("RESULT_DATA", strErrMsg);
			
		} catch(Exception e) {
			e.printStackTrace();
		}
		
		return result;
	}

	// 39. trans connect stop
	public Map<String, Object> connectStop(String IP, int PORT, String strCmd, String trans_id, String trans_active_gbn) {
		
		Map<String, Object> result = new HashMap<String, Object>();
		
		try {
			JSONObject jObj = new JSONObject();
			
			jObj.put(ClientProtocolID.DX_EX_CODE, ClientTranCodeType.DxT039);
			jObj.put(ClientProtocolID.REQ_CMD, strCmd);
			jObj.put(ClientProtocolID.TRANS_ID, trans_id);
			jObj.put(ClientProtocolID.CON_START_GBN, trans_active_gbn);

			JSONObject objList;
			
			ClientAdapter CA = new ClientAdapter(IP, PORT);
			CA.open(); 

			objList = CA.dxT039(jObj);
		
			CA.close();
			
			String strErrMsg = (String)objList.get(ClientProtocolID.ERR_MSG);
			String strErrCode = (String)objList.get(ClientProtocolID.ERR_CODE);
			String strDxExCode = (String)objList.get(ClientProtocolID.DX_EX_CODE);
			String strResultCode = (String)objList.get(ClientProtocolID.RESULT_CODE);
			String strResultData = (String)objList.get(ClientProtocolID.RESULT_DATA);

			System.out.println("RESULT_CODE : " +  strResultCode);
			System.out.println("ERR_CODE : " +  strErrCode);
			System.out.println("ERR_MSG : " +  strErrMsg);
			System.out.println("RESULT_DATA : " +  strResultData);
			
			result.put("RESULT_CODE", strResultCode);
			result.put("ERR_CODE", strErrCode);
			result.put("ERR_MSG", strErrMsg);
			result.put("RESULT_DATA", strErrMsg);
				
			//CA.close();
		} catch(Exception e) {
			e.printStackTrace();
		}
		
		return result;
	}

	public JSONObject serverSpace(String IP, int PORT, JSONObject serverObj) {
		JSONObject resultHp = null;
		try {
			JSONObject jObj = new JSONObject();
			jObj.put(ClientProtocolID.DX_EX_CODE, ClientTranCodeType.DxT040);
			jObj.put(ClientProtocolID.SERVER_INFO, serverObj);
			JSONObject objList;
			ClientAdapter CA = new ClientAdapter(IP, PORT);
			CA.open(); 
			objList = CA.dxT040(jObj);
			CA.close();
			
			String strErrMsg = (String)objList.get(ClientProtocolID.ERR_MSG);
			String strErrCode = (String)objList.get(ClientProtocolID.ERR_CODE);
			String strDxExCode = (String)objList.get(ClientProtocolID.DX_EX_CODE);
			String strResultCode = (String)objList.get(ClientProtocolID.RESULT_CODE);
			
			resultHp = (JSONObject) objList.get(ClientProtocolID.RESULT_DATA);
	
		} catch(Exception e) {
			e.printStackTrace();
		}
		return resultHp;
	}
	
	// 41. trans topic list 조호
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public JSONObject trans_topic_List(JSONObject serverObj,String IP, int PORT) {

		JSONArray jsonArray = new JSONArray(); // 객체를 담기위해 JSONArray 선언.
		JSONObject result = new JSONObject();

		try {
			JSONObject objList;

			ClientAdapter CA = new ClientAdapter(IP, PORT);
			CA.open();

			objList = CA.dxT041(ClientTranCodeType.DxT041, serverObj);

			String strErrMsg = (String) objList.get(ClientProtocolID.ERR_MSG);
			String strDxExCode = (String) objList.get(ClientProtocolID.DX_EX_CODE);
			
			String strStrReult_data = (String) objList.get(ClientProtocolID.RESULT_DATA);

			if (strStrReult_data != null && !"".equals(strStrReult_data)) {
				String[] splitStrResultMessge = strStrReult_data.split(",");

				for(int i=0; i<splitStrResultMessge.length; i++){
					JSONObject jsonObj = new JSONObject();
					String topicName = splitStrResultMessge[i];

					jsonObj.put("topic_name", topicName);

					jsonObj.put("rownum_chk", i);
					jsonArray.add(jsonObj);
				}
				result.put("data", jsonArray);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	
	
	public JSONObject  getVolumes(String IP, int PORT) {
		
		JSONArray jsonArray = new JSONArray(); // 객체를 담기위해 JSONArray 선언.
		JSONObject result = new JSONObject();
		
		JSONObject resultHp = null;
		try {
			
			JSONObject jObj = new JSONObject();
			jObj.put(ClientProtocolID.DX_EX_CODE, ClientTranCodeType.DxT042);
			
			JSONObject objList;
			
			ClientAdapter CA = new ClientAdapter(IP, PORT);
			CA.open(); 
			objList = CA.dxT042(jObj);

			CA.close();
			
			String strErrMsg = (String)objList.get(ClientProtocolID.ERR_MSG);
			String strErrCode = (String)objList.get(ClientProtocolID.ERR_CODE);
			String strDxExCode = (String)objList.get(ClientProtocolID.DX_EX_CODE);
			String strResultCode = (String)objList.get(ClientProtocolID.RESULT_CODE);
	
			List<Object> volumes = (ArrayList<Object>) objList.get(ClientProtocolID.RESULT_DATA);
			
			if(volumes.size() > 0) {
				for(int i=0; i<volumes.size(); i++) {
					JSONObject jsonObj = new JSONObject();
					Object obj = volumes.get(i);
					
					HashMap hp = (HashMap) obj;

					jsonObj.put("mountOn", (String) hp.get("mounton"));
					jsonObj.put("filesystem", (String) hp.get("filesystem"));
					jsonObj.put("size", (String) hp.get("size"));
					jsonObj.put("used", (String) hp.get("used"));
					jsonObj.put("avail", (String) hp.get("avail"));
					jsonObj.put("use", (String) hp.get("use"));
					jsonObj.put("type", (String) hp.get("type"));
					jsonArray.add(jsonObj);
				}
			}
			CA.close();
			
			System.out.println(jsonArray);
			result.put("data", jsonArray);
				
			CA.close();
			
		} catch(Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
}
