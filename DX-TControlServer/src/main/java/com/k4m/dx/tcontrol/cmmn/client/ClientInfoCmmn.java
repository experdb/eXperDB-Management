package com.k4m.dx.tcontrol.cmmn.client;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

public class ClientInfoCmmn {

	String Ip = "222.110.153.162";
	int port = 9001;

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

			System.out.println("strDxExCode : " + " " + strDxExCode);
			System.out.println("strResultCode : " + " " + strResultCode);
			System.out.println("strErrCode : " + " " + strErrCode);
			System.out.println("strErrMsg : " + " " + strErrMsg);

			System.out.println("RESULT_DATA : " + " " + objList.get(ClientProtocolID.RESULT_DATA));

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

			System.out.println("strDxExCode : " + " " + strDxExCode);
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

	// 3. 테이블 리스트 (tableList)
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public JSONObject table_List(JSONObject serverObj, String strSchema) {

		JSONArray jsonArray = new JSONArray(); // 객체를 담기위해 JSONArray 선언.
		JSONObject result = new JSONObject();

		List<Object> selectList = null;

		try {
			JSONObject objList;

			ClientAdapter CA = new ClientAdapter(Ip, port);
			CA.open();

			objList = CA.dxT002(ClientTranCodeType.DxT002, serverObj, strSchema);

			String strErrMsg = (String) objList.get(ClientProtocolID.ERR_MSG);
			String strDxExCode = (String) objList.get(ClientProtocolID.DX_EX_CODE);

			selectList = (ArrayList<Object>) objList.get(ClientProtocolID.RESULT_DATA);

			System.out.println("strDxExCode : " + " " + strDxExCode);
			System.out.println("resultCode : " + " " + (String) objList.get(ClientProtocolID.RESULT_CODE));

			for (int i = 0; i < selectList.size(); i++) {
				JSONObject jsonObj = new JSONObject();
				Object obj = selectList.get(i);
				HashMap hp = (HashMap) obj;
				String table_schema = (String) hp.get("table_schema");
				String table_name = (String) hp.get("table_name");

				jsonObj.put("schema", table_schema);
				jsonObj.put("name", table_name);
				jsonArray.add(jsonObj);

				System.out.println(i + " " + table_schema + " " + table_name);
			}
			result.put("data", jsonArray);

			CA.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	// 5. 백업실행
	public void db_backup(List<Map<String, Object>> resultWork, ArrayList<String> CMD, String IP, int PORT, ArrayList<String> BCKNM) {
		try {
			JSONObject reqJObj = new JSONObject();
			JSONArray arrCmd = new JSONArray();

			int j = 0;
			for (int i = 0; i < resultWork.size(); i++) {
				JSONObject objJob = new JSONObject();
				objJob.put(ClientProtocolID.SCD_ID, resultWork.get(i).get("scd_id")); // 스캐쥴ID
				objJob.put(ClientProtocolID.WORK_ID, resultWork.get(i).get("wrk_id")); // 작업ID
				objJob.put(ClientProtocolID.EXD_ORD, resultWork.get(i).get("exe_ord")); // 실행순서
				objJob.put(ClientProtocolID.NXT_EXD_YN, resultWork.get(i).get("nxt_exe_yn")); // 다음실행여부
				objJob.put(ClientProtocolID.DB_ID, resultWork.get(i).get("db_id")); // db아이디
				if (resultWork.get(i).get("bck_bsn_dscd").equals("TC000201")) {
					objJob.put(ClientProtocolID.BCK_OPT_CD, resultWork.get(i).get("bck_opt_cd")); // 백업종류
					objJob.put(ClientProtocolID.BCK_FILE_PTH, resultWork.get(i).get("bck_pth")); // 저장경로
					objJob.put(ClientProtocolID.BCK_FILENM, ""); // 저장파일명
				} else {
					objJob.put(ClientProtocolID.BCK_OPT_CD, ""); // 백업종류
					objJob.put(ClientProtocolID.BCK_FILE_PTH, resultWork.get(i).get("save_pth")); // 저장경로					
					objJob.put(ClientProtocolID.BCK_FILENM, BCKNM.get(i)); // 저장파일명
					System.out.println(BCKNM.get(i));
				}
				objJob.put(ClientProtocolID.LOG_YN, "Y"); // 로그저장 유무
				objJob.put(ClientProtocolID.REQ_CMD, CMD.get(i));// 명령어
				arrCmd.add(j, objJob);

				// 백업명령 실행후,
				// [pg_rman validate -B 백업경로] 명령어 실행해줘여함
				// [pg_rman validate -B 백업경로] 정합성 체크하는 명령어, 안할실 복구불가능
				if (resultWork.get(i).get("bck_bsn_dscd").equals("TC000201")) {
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
					arrCmd.add(j, objJob2);
				}

				j++;
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
			CA.dxT005(reqJObj);
			CA.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	// 6. DB접근제어 C(dbAccess_create)
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
			System.out.println("RESULT_CODE : " + strResultCode);
			System.out.println("ERR_CODE : " + strErrCode);
			System.out.println("ERR_MSG : " + strErrMsg);

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
			acObj.put(ClientProtocolID.AC_SET, "1");
			acObj.put(ClientProtocolID.AC_TYPE, "host");
			acObj.put(ClientProtocolID.AC_DATABASE, "experdba");
			acObj.put(ClientProtocolID.AC_USER, "experdba");
			acObj.put(ClientProtocolID.AC_IP, "222.110.153.254");
			acObj.put(ClientProtocolID.AC_METHOD, "trust");
			acObj.put(ClientProtocolID.AC_OPTION, "");

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

			System.out.println("RESULT_CODE : " + strResultCode);
			System.out.println("ERR_CODE : " + strErrCode);
			System.out.println("ERR_MSG : " + strErrMsg);

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
						System.out.println("seq : " + Seq + " Set : " + Set + " Type : " + Type + " Database : "
								+ Database + " User : " + User + " Ip : " + Ipadr + " Ipmask : " + Ipmask + " Method : " + Method + " Option : "
								+ Option);
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
			acObj.put(ClientProtocolID.AC_SET, "1");
			acObj.put(ClientProtocolID.AC_TYPE, "host");
			acObj.put(ClientProtocolID.AC_DATABASE, "experdba");
			acObj.put(ClientProtocolID.AC_USER, "experdba");
			acObj.put(ClientProtocolID.AC_IP, "222.110.153.254");
			acObj.put(ClientProtocolID.AC_METHOD, "trust");
			acObj.put(ClientProtocolID.AC_OPTION, "");

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

			System.out.println("RESULT_CODE : " + strResultCode);
			System.out.println("ERR_CODE : " + strErrCode);
			System.out.println("ERR_MSG : " + strErrMsg);

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

				System.out.println("seq : " + Seq + " Set : " + Set + " Type : " + Type + " Database : "
						+ Database + " User : " + User + " Ip : " + Ipadr + " Ipmask : " + Ipmask + " Method : " + Method + " Option : "
						+ Option);
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
			System.out.println("RESULT_CODE : " + strResultCode);
			System.out.println("ERR_CODE : " + strErrCode);
			System.out.println("ERR_MSG : " + strErrMsg);

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
			jObj.put(ClientProtocolID.COMMAND_CODE, ClientProtocolID.COMMAND_CODE_D);
			jObj.put(ClientProtocolID.SERVER_INFO, serverObj);
			jObj.put(ClientProtocolID.ARR_AC_SEQ, arrSeq);

			objList = CA.dxT006(ClientTranCodeType.DxT006, jObj);

			String strErrMsg = (String) objList.get(ClientProtocolID.ERR_MSG);
			String strErrCode = (String) objList.get(ClientProtocolID.ERR_CODE);
			String strDxExCode = (String) objList.get(ClientProtocolID.DX_EX_CODE);
			String strResultCode = (String) objList.get(ClientProtocolID.RESULT_CODE);
			System.out.println("RESULT_CODE : " + strResultCode);
			System.out.println("ERR_CODE : " + strErrCode);
			System.out.println("ERR_MSG : " + strErrMsg);

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
	public JSONObject role_List(JSONObject serverObj) {

		JSONArray jsonArray = new JSONArray(); // 객체를 담기위해 JSONArray 선언.
		JSONObject result = new JSONObject();

		try {
			JSONObject objList;

			ClientAdapter CA = new ClientAdapter(Ip, port);
			CA.open();

			objList = CA.dxT011(ClientTranCodeType.DxT011, serverObj);

			String strErrMsg = (String) objList.get(ClientProtocolID.ERR_MSG);
			String strDxExCode = (String) objList.get(ClientProtocolID.DX_EX_CODE);

			List<Object> selectList = (ArrayList<Object>) objList.get(ClientProtocolID.RESULT_DATA);

			System.out.println("strDxExCode : " + " " + strDxExCode);
			System.out.println("strErrMsg : " + " " + strErrMsg);

			for (int i = 0; i < selectList.size(); i++) {
				JSONObject jsonObj = new JSONObject();
				Object obj = selectList.get(i);

				HashMap hp = (HashMap) obj;

				jsonObj.put("rolname", (String) hp.get("rolname"));
				jsonArray.add(jsonObj);
				System.out.println(i + " " + (String) hp.get("rolname"));
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

			ClientAdapter CA = new ClientAdapter(Ip, port);
			CA.open();

			objList = CA.dxT012(ClientTranCodeType.DxT012, serverObj);

			selectList = (ArrayList<Object>) objList.get(ClientProtocolID.RESULT_DATA);

			String strErrMsg = (String) objList.get(ClientProtocolID.ERR_MSG);
			String strErrCode = (String) objList.get(ClientProtocolID.ERR_CODE);
			String strDxExCode = (String) objList.get(ClientProtocolID.DX_EX_CODE);
			String strResultCode = (String) objList.get(ClientProtocolID.RESULT_CODE);

			System.out.println("RESULT_CODE : " + strResultCode);
			System.out.println("ERR_CODE : " + strErrCode);
			System.out.println("ERR_MSG : " + strErrMsg);
			System.out.println("strDxExCode : " + " " + strDxExCode);
			System.out.println("resultCode : " + " " + (String) objList.get(ClientProtocolID.RESULT_CODE));

			for (int i = 0; i < selectList.size(); i++) {
				JSONObject jsonObj = new JSONObject();
				HashMap hp = (HashMap) selectList.get(i);

				jsonObj.put("schema", (String) hp.get("table_schema"));
				jsonObj.put("name", (String) hp.get("table_name"));
				jsonArray.add(jsonObj);

				System.out.println(i + " " + hp.get("table_schema") + " " + hp.get("table_name"));
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
			System.out.println("RESULT_CODE : " + strResultCode);
			System.out.println("ERR_CODE : " + strErrCode);
			System.out.println("ERR_MSG : " + strErrMsg);

			List<Object> selectDBList = (ArrayList<Object>) objList.get(ClientProtocolID.RESULT_DATA);

			System.out.println("strDxExCode : " + " " + strDxExCode);

			if (selectDBList != null) {
				if (selectDBList.size() > 0) {
					for (int i = 0; i < selectDBList.size(); i++) {
						JSONObject jsonObj = new JSONObject();
						Object obj = selectDBList.get(i);
						HashMap hp = (HashMap) obj;
						String table_schema = (String) hp.get("table_schema");
						String table_name = (String) hp.get("table_name");
						System.out.println(i + " " + table_schema + " " + table_name);
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
			System.out.println("RESULT_CODE : " + strResultCode);
			System.out.println("ERR_CODE : " + strErrCode);
			System.out.println("ERR_MSG : " + strErrMsg);

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
			System.out.println("RESULT_CODE : " + strResultCode);
			System.out.println("ERR_CODE : " + strErrCode);
			System.out.println("ERR_MSG : " + strErrMsg);

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
			System.out.println("RESULT_CODE : " + strResultCode);
			System.out.println("ERR_CODE : " + strErrCode);
			System.out.println("ERR_MSG : " + strErrMsg);

			List<Object> selectDBList = (ArrayList<Object>) objList.get(ClientProtocolID.RESULT_DATA);

			System.out.println("strDxExCode : " + " " + strDxExCode);

			if (selectDBList != null) {
				if (selectDBList.size() > 0) {
					for (int i = 0; i < selectDBList.size(); i++) {
						JSONObject jsonObj = new JSONObject();

						Object obj = selectDBList.get(i);

						HashMap hp = (HashMap) obj;
						String name = (String) hp.get("name");
						String hdfs_url = (String) hp.get("hdfs.url");

						System.out.println(i + " " + hp);
						System.out.println(i + " name : " + name);
						System.out.println(i + " hdfs_url : " + hdfs_url);

						jsonObj.put("hp", hp);
						jsonObj.put("name", name);
						jsonObj.put("hdfs_url", hdfs_url);

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
			System.out.println("RESULT_CODE : " + strResultCode);
			System.out.println("ERR_CODE : " + strErrCode);
			System.out.println("ERR_MSG : " + strErrMsg);

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
			System.out.println("RESULT_CODE : " + strResultCode);
			System.out.println("ERR_CODE : " + strErrCode);
			System.out.println("ERR_MSG : " + strErrMsg);

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
			System.out.println("RESULT_CODE : " + strResultCode);
			System.out.println("ERR_CODE : " + strErrCode);
			System.out.println("ERR_MSG : " + strErrMsg);

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
			JSONObject connectorInfoObj = new JSONObject();

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
			System.out.println("RESULT_CODE : " + strResultCode);
			System.out.println("ERR_CODE : " + strErrCode);
			System.out.println("ERR_MSG : " + strErrMsg);
			System.out.println("RESULT_DATA : " + strResultData);

			CA.close();

			result.put("result", objList);
			return result;
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
			System.out.println("RESULT_CODE : " + strResultCode);
			System.out.println("ERR_CODE : " + strErrCode);
			System.out.println("ERR_MSG : " + strErrMsg);

			CA.close();

			// CA.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
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
			System.out.println("RESULT_CODE : " + strResultCode);
			System.out.println("ERR_CODE : " + strErrCode);
			System.out.println("ERR_MSG : " + strErrMsg);

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
			System.out.println("RESULT_CODE : " + strResultCode);
			System.out.println("ERR_CODE : " + strErrCode);
			System.out.println("ERR_MSG : " + strErrMsg);

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
		System.out.println("RESULT_CODE : " +  strResultCode);
		System.out.println("ERR_CODE : " +  strErrCode);
		System.out.println("ERR_MSG : " +  strErrMsg);

		String host = (String) objList.get(ClientProtocolID.RESULT_DATA);
		
		System.out.println("host : " + host);
		result.put("host", host);
		} catch(Exception e) {
			e.printStackTrace();
		}
		
		return result;
	}

}
