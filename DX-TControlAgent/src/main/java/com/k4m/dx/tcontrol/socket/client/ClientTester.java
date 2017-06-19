package com.k4m.dx.tcontrol.socket.client;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;


/**
 * agent 기능
 * 
 * 1. Database List 조회(dxT001)
 * 2. table List 조회(dxT002)
 * 3. 서버연결 Test(dxT003)
 * 4. Connector 연결 Test(dxT004)
 * 5. 백업실행(dxT005)
 * 6. DB접근제어 CRUD(dxT006)
 * 7. 감사로그설정(dxT007)
 * 8. 감사로그조회(dxT008)
 * 9. Agent Monitoring(dxT009)
 * 10. Extention 설치 유무 조회(dxT010)
 * 11. role name 조회(dxT011)
 * @author thpark
 *
 */
public class ClientTester {
	
	public static void main(String[] args) {
		
		ClientTester clientTester = new ClientTester();
		
		//String Ip = "222.110.153.162";
		String Ip = "127.0.0.1";
		int port = 9001;
		try {
			
			//clientTester.dxT001(Ip, port);
			//clientTester.dxT002(Ip, port);
			//clientTester.dxT003(Ip, port);
			//clientTester.dxT004(Ip, port);
			//clientTester.dxT005(Ip, port);
			//clientTester.dxT006_C(Ip, port);
			//clientTester.dxT006_R(Ip, port);
			//clientTester.dxT006_U(Ip, port);
			//clientTester.dxT006_D(Ip, port);
			clientTester.dxT011(Ip, port);
			
			
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	private void dxT001(String Ip, int port) {
		try {


			JSONObject serverObj = new JSONObject();
			
			/**
			serverObj.put(ClientProtocolID.SERVER_NAME, "222.110.153.162");
			serverObj.put(ClientProtocolID.SERVER_IP, "222.110.153.162");
			serverObj.put(ClientProtocolID.SERVER_PORT, "6432");
			serverObj.put(ClientProtocolID.DATABASE_NAME, "postgres");
			serverObj.put(ClientProtocolID.USER_ID, "experdba");
			serverObj.put(ClientProtocolID.USER_PWD, "experdba");
			**/
			
			serverObj.put(ClientProtocolID.SERVER_NAME, "222.110.153.162");
			serverObj.put(ClientProtocolID.SERVER_IP, "222.110.153.162");
			serverObj.put(ClientProtocolID.SERVER_PORT, "5432");
			serverObj.put(ClientProtocolID.DATABASE_NAME, "pgmon");
			serverObj.put(ClientProtocolID.USER_ID, "pgmon");
			serverObj.put(ClientProtocolID.USER_PWD, "pgmon");
			
			
			
			JSONObject objList;
			
			ClientAdapter CA = new ClientAdapter(Ip, port);
			CA.open(); 
				
			objList = CA.dxT001(ClientTranCodeType.DxT001, serverObj);
			
			String _tran_err_msg = (String)objList.get(ClientProtocolID.ERR_MSG);
			String strDxExCode = (String)objList.get(ClientProtocolID.DX_EX_CODE);
			
			List<Object> selectDBList =(ArrayList<Object>) objList.get(ClientProtocolID.RESULT_DATA);
			
			System.out.println("strDxExCode : " + " " + strDxExCode);
			
			for(int i=0; i<selectDBList.size(); i++) {
				
				Object obj = selectDBList.get(i);
				
				HashMap hp = (HashMap) obj;
				String datname = (String) hp.get("datname");

				System.out.println(i + " " + datname);

			}
				
				
			CA.close();
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	private void dxT002(String Ip, int port) {
		try {


			JSONObject serverObj = new JSONObject();
			
/*			serverObj.put(ClientProtocolID.SERVER_NAME, "222.110.153.162");
			serverObj.put(ClientProtocolID.SERVER_IP, "222.110.153.162");
			serverObj.put(ClientProtocolID.SERVER_PORT, "5432");
			serverObj.put(ClientProtocolID.DATABASE_NAME, "ibizspt");
			serverObj.put(ClientProtocolID.USER_ID, "pgmon");
			serverObj.put(ClientProtocolID.USER_PWD, "pgmon");*/
			
			serverObj.put(ClientProtocolID.SERVER_NAME, "222.110.153.162");
			serverObj.put(ClientProtocolID.SERVER_IP, "222.110.153.162");
			serverObj.put(ClientProtocolID.SERVER_PORT, "6432");
			serverObj.put(ClientProtocolID.DATABASE_NAME, "postgres");
			serverObj.put(ClientProtocolID.USER_ID, "experdba");
			serverObj.put(ClientProtocolID.USER_PWD, "experdba");
			
			JSONObject objList;
			
			ClientAdapter CA = new ClientAdapter(Ip, port);
			CA.open(); 
			
			String strSchema = "tcontrol";
				
			objList = CA.dxT002(ClientTranCodeType.DxT002, serverObj, strSchema);
			
			String strResultCode = (String)objList.get(ClientProtocolID.RESULT_CODE);
			String strErrCode = (String)objList.get(ClientProtocolID.ERR_CODE);
			String strErrMsg = (String)objList.get(ClientProtocolID.ERR_MSG);
			String strDxExCode = (String)objList.get(ClientProtocolID.DX_EX_CODE);
			
			List<Object> selectDBList =(ArrayList<Object>) objList.get(ClientProtocolID.RESULT_DATA);
			
			System.out.println("strDxExCode : " + " " + strDxExCode);
			System.out.println("strResultCode : " + " " + strResultCode);
			System.out.println("strErrCode : " + " " + strErrCode);
			System.out.println("strErrMsg : " + " " + strErrMsg);
			
			for(int i=0; i<selectDBList.size(); i++) {
				
				Object obj = selectDBList.get(i);

				HashMap hp = (HashMap) obj;
				String table_schema = (String) hp.get("table_schema");
				String table_name = (String) hp.get("table_name");

				System.out.println(i + " " + table_schema + " " + table_name);

			}
				
				
			CA.close();
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	private void dxT003(String Ip, int port) {
		try {
			JSONObject serverObj = new JSONObject();
			
			serverObj.put(ClientProtocolID.SERVER_NAME, "222.110.153.162");
			serverObj.put(ClientProtocolID.SERVER_IP, "222.110.153.162");
			serverObj.put(ClientProtocolID.SERVER_PORT, "6432");
			serverObj.put(ClientProtocolID.DATABASE_NAME, "postgres");
			serverObj.put(ClientProtocolID.USER_ID, "experdba");
			serverObj.put(ClientProtocolID.USER_PWD, "experdba");
			
			JSONObject objList;
			
			ClientAdapter CA = new ClientAdapter(Ip, port);
			CA.open(); 
			
			objList = CA.dxT003(ClientTranCodeType.DxT003, serverObj);
			
			String strResultCode = (String)objList.get(ClientProtocolID.RESULT_CODE);
			String strErrCode = (String)objList.get(ClientProtocolID.ERR_CODE);
			String strErrMsg = (String)objList.get(ClientProtocolID.ERR_MSG);
			String strDxExCode = (String)objList.get(ClientProtocolID.DX_EX_CODE);
			
			System.out.println("strDxExCode : " + " " + strDxExCode);
			System.out.println("strResultCode : " + " " + strResultCode);
			System.out.println("strErrCode : " + " " + strErrCode);
			System.out.println("strErrMsg : " + " " + strErrMsg);
			
			System.out.println("RESULT_DATA : " + " " + objList.get(ClientProtocolID.RESULT_DATA));
			
			CA.close();
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	private void dxT004(String Ip, int port) {
		try {
			JSONArray arrDBInfo = new JSONArray();
			
			ClientAdapter CA = new ClientAdapter(Ip, port);
			CA.open(); 
				//CA.dxT001("dxT001", arrDBInfo);
			CA.close();
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	private void dxT005(String Ip, int port) {
		try {
			
			String[] CMD =
				{
					"pg_dump --file=cats_tmp_acquire.sql --table=ibizspt.cats_tmp_acquire ibizspt",
					"pg_dump --file=cats_tmp_acquire_kb_owner.sql --table=ibizspt.cats_tmp_acquire_kb_owner ibizspt",
					"pg_dump --file=cats_tmp_cardinfo.sql --table=ibizspt.cats_tmp_cardinfo ibizspt",
					"pg_dump --file=cats_tmp_cardinfo.sql --table=ibizspt.cats_tmp_cardinfo ibizsptss",
					"pg_dump --file=pdt_corppdt.sql --table=ibizspt.pdt_corppdt ibizspt"
				};
			
			JSONObject reqJObj = new JSONObject();
			
			JSONArray arrCmd = new JSONArray();
			
			JSONObject objJob_01 = new JSONObject();
			objJob_01.put(ClientProtocolID.SCD_ID, ""); //스캐쥴ID
			objJob_01.put(ClientProtocolID.WORK_ID, ""); //작업ID
			objJob_01.put(ClientProtocolID.EXD_ORD, ""); //실행순서
			objJob_01.put(ClientProtocolID.NXT_EXD_YN, ""); //다음실행여부
			objJob_01.put(ClientProtocolID.REQ_CMD, CMD[0]);
			
			JSONObject objJob_02 = new JSONObject();
			objJob_02.put(ClientProtocolID.SCD_ID, ""); //스캐쥴ID
			objJob_02.put(ClientProtocolID.WORK_ID, ""); //작업ID
			objJob_02.put(ClientProtocolID.EXD_ORD, ""); //실행순서
			objJob_02.put(ClientProtocolID.NXT_EXD_YN, ""); //다음실행여부
			objJob_02.put(ClientProtocolID.REQ_CMD, CMD[0]);
			
			JSONObject objJob_03 = new JSONObject();
			objJob_03.put(ClientProtocolID.SCD_ID, ""); //스캐쥴ID
			objJob_03.put(ClientProtocolID.WORK_ID, ""); //작업ID
			objJob_03.put(ClientProtocolID.EXD_ORD, ""); //실행순서
			objJob_03.put(ClientProtocolID.NXT_EXD_YN, ""); //다음실행여부
			objJob_03.put(ClientProtocolID.REQ_CMD, CMD[0]); //명령어
			
			arrCmd.add(0, objJob_01);
			arrCmd.add(1, objJob_02);
			arrCmd.add(2, objJob_03);

			
			reqJObj.put(ClientProtocolID.DX_EX_CODE, ClientTranCodeType.DxT005);
			reqJObj.put(ClientProtocolID.ARR_CMD, arrCmd);
			
			ClientAdapter CA = new ClientAdapter(Ip, port);
			CA.open(); 
				CA.dxT005(reqJObj);
			CA.close();
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	private void dxT006_C(String Ip, int port) {
		try {
			JSONObject serverObj = new JSONObject();
			
			serverObj.put(ClientProtocolID.SERVER_NAME, "222.110.153.162");
			serverObj.put(ClientProtocolID.SERVER_IP, "222.110.153.162");
			serverObj.put(ClientProtocolID.SERVER_PORT, "6432");
			serverObj.put(ClientProtocolID.DATABASE_NAME, "postgres");
			serverObj.put(ClientProtocolID.USER_ID, "experdba");
			serverObj.put(ClientProtocolID.USER_PWD, "experdba");
			
			JSONObject objList;

			
			JSONObject acObj = new JSONObject();
			acObj.put(ClientProtocolID.AC_SET, "1");
			acObj.put(ClientProtocolID.AC_TYPE, "host");
			acObj.put(ClientProtocolID.AC_DATABASE, "experdba");
			acObj.put(ClientProtocolID.AC_USER, "experdba");
			acObj.put(ClientProtocolID.AC_IP, "222.110.153.254");
			acObj.put(ClientProtocolID.AC_METHOD, "trust");
			acObj.put(ClientProtocolID.AC_OPTION, "");

			
			ClientAdapter CA = new ClientAdapter(Ip, port);
			CA.open(); 

			JSONObject jObj = new JSONObject();
			jObj.put(ClientProtocolID.DX_EX_CODE, ClientTranCodeType.DxT006);
			jObj.put(ClientProtocolID.COMMAND_CODE, ClientProtocolID.COMMAND_CODE_C);
			jObj.put(ClientProtocolID.SERVER_INFO, serverObj);
			jObj.put(ClientProtocolID.ACCESS_CONTROL_INFO, acObj);
			
			objList = CA.dxT006(ClientTranCodeType.DxT006, jObj);
			
			String strErrMsg = (String)objList.get(ClientProtocolID.ERR_MSG);
			String strErrCode = (String)objList.get(ClientProtocolID.ERR_CODE);
			String strDxExCode = (String)objList.get(ClientProtocolID.DX_EX_CODE);
			String strResultCode = (String)objList.get(ClientProtocolID.RESULT_CODE);
			System.out.println("RESULT_CODE : " +  strResultCode);
			System.out.println("ERR_CODE : " +  strErrCode);
			System.out.println("ERR_MSG : " +  strErrMsg);
			
			CA.close();
			
			ClientTester clientTester = new ClientTester();
			clientTester.dxT006_R(Ip, port);
			
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
	

	
	private void dxT006_R(String Ip, int port) {
		try {
			JSONObject serverObj = new JSONObject();
			
			serverObj.put(ClientProtocolID.SERVER_NAME, "222.110.153.162");
			serverObj.put(ClientProtocolID.SERVER_IP, "222.110.153.162");
			serverObj.put(ClientProtocolID.SERVER_PORT, "6432");
			serverObj.put(ClientProtocolID.DATABASE_NAME, "postgres");
			serverObj.put(ClientProtocolID.USER_ID, "experdba");
			serverObj.put(ClientProtocolID.USER_PWD, "experdba");
			
			JSONObject objList;

			
			JSONObject acObj = new JSONObject();
			acObj.put(ClientProtocolID.AC_SET, "1");
			acObj.put(ClientProtocolID.AC_TYPE, "host");
			acObj.put(ClientProtocolID.AC_DATABASE, "experdba");
			acObj.put(ClientProtocolID.AC_USER, "experdba");
			acObj.put(ClientProtocolID.AC_IP, "222.110.153.254");
			acObj.put(ClientProtocolID.AC_METHOD, "trust");
			acObj.put(ClientProtocolID.AC_OPTION, "");

			
			ClientAdapter CA = new ClientAdapter(Ip, port);
			CA.open(); 

			JSONObject jObj = new JSONObject();
			jObj.put(ClientProtocolID.DX_EX_CODE, ClientTranCodeType.DxT006);
			jObj.put(ClientProtocolID.COMMAND_CODE, ClientProtocolID.COMMAND_CODE_R);
			jObj.put(ClientProtocolID.SERVER_INFO, serverObj);
			jObj.put(ClientProtocolID.ACCESS_CONTROL_INFO, acObj);
			
			objList = CA.dxT006(ClientTranCodeType.DxT006, jObj);
			String strErrCode = (String)objList.get(ClientProtocolID.ERR_CODE);
			String strErrMsg = (String)objList.get(ClientProtocolID.ERR_MSG);
			String strDxExCode = (String)objList.get(ClientProtocolID.DX_EX_CODE);
			String strResultCode = (String)objList.get(ClientProtocolID.RESULT_CODE);
			
			System.out.println("RESULT_CODE : " +  strResultCode);
			System.out.println("ERR_CODE : " +  strErrCode);
			System.out.println("ERR_MSG : " +  strErrMsg);
			
			List<Object> selectDBList =(ArrayList<Object>) objList.get(ClientProtocolID.RESULT_DATA);
			
			for(int i=0; i<selectDBList.size()-1; i++) {
				JSONObject mp = (JSONObject) selectDBList.get(i);
				
				System.out.println("seq : " +  mp.get("Seq")
				                + " Set : " +  mp.get("Set")
				                + " Type : " +  mp.get("Type")
								+ " Database : " +  mp.get("Database")
								+ " User : " +  mp.get("User")
								+ " Ip : " +  mp.get("Ip")
								+ " Method : " +  mp.get("Method")
								+ " Option : " +  mp.get("Option"));

			}
			
			CA.close();
			
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	
	private void dxT006_U(String Ip, int port) {
		try {
			JSONObject serverObj = new JSONObject();
			
			serverObj.put(ClientProtocolID.SERVER_NAME, "222.110.153.162");
			serverObj.put(ClientProtocolID.SERVER_IP, "222.110.153.162");
			serverObj.put(ClientProtocolID.SERVER_PORT, "6432");
			serverObj.put(ClientProtocolID.DATABASE_NAME, "postgres");
			serverObj.put(ClientProtocolID.USER_ID, "experdba");
			serverObj.put(ClientProtocolID.USER_PWD, "experdba");
			
			JSONObject objList;

			
			JSONObject acObj = new JSONObject();
			acObj.put(ClientProtocolID.AC_SEQ, "6");
			acObj.put(ClientProtocolID.AC_SET, "0");
			acObj.put(ClientProtocolID.AC_TYPE, "host");
			acObj.put(ClientProtocolID.AC_DATABASE, "experdba");
			acObj.put(ClientProtocolID.AC_USER, "experdba");
			acObj.put(ClientProtocolID.AC_IP, "222.110.153.254");
			acObj.put(ClientProtocolID.AC_METHOD, "trust");
			acObj.put(ClientProtocolID.AC_OPTION, "");

			
			ClientAdapter CA = new ClientAdapter(Ip, port);
			CA.open(); 

			JSONObject jObj = new JSONObject();
			jObj.put(ClientProtocolID.DX_EX_CODE, ClientTranCodeType.DxT006);
			jObj.put(ClientProtocolID.COMMAND_CODE, ClientProtocolID.COMMAND_CODE_U);
			jObj.put(ClientProtocolID.SERVER_INFO, serverObj);
			jObj.put(ClientProtocolID.ACCESS_CONTROL_INFO, acObj);
			
			objList = CA.dxT006(ClientTranCodeType.DxT006, jObj);
			
			String strErrMsg = (String)objList.get(ClientProtocolID.ERR_MSG);
			String strErrCode = (String)objList.get(ClientProtocolID.ERR_CODE);
			String strDxExCode = (String)objList.get(ClientProtocolID.DX_EX_CODE);
			String strResultCode = (String)objList.get(ClientProtocolID.RESULT_CODE);
			System.out.println("RESULT_CODE : " +  strResultCode);
			System.out.println("ERR_CODE : " +  strErrCode);
			System.out.println("ERR_MSG : " +  strErrMsg);
			
			CA.close();
			
			ClientTester clientTester = new ClientTester();
			clientTester.dxT006_R(Ip, port);
			
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	private void dxT006_D(String Ip, int port) {
		try {
			JSONObject serverObj = new JSONObject();
			
			serverObj.put(ClientProtocolID.SERVER_NAME, "222.110.153.162");
			serverObj.put(ClientProtocolID.SERVER_IP, "222.110.153.162");
			serverObj.put(ClientProtocolID.SERVER_PORT, "6432");
			serverObj.put(ClientProtocolID.DATABASE_NAME, "postgres");
			serverObj.put(ClientProtocolID.USER_ID, "experdba");
			serverObj.put(ClientProtocolID.USER_PWD, "experdba");
			
			JSONObject objList;

			HashMap<String, String> hpSeq = new HashMap<String, String>();
			hpSeq.put(ClientProtocolID.AC_SEQ, "5");
			
			HashMap<String, String> hpSeq2 = new HashMap<String, String>();
			hpSeq2.put(ClientProtocolID.AC_SEQ, "6");
			
			ArrayList arrSeq = new ArrayList();
			arrSeq.add(hpSeq);
			arrSeq.add(hpSeq2);
			
	
			ClientAdapter CA = new ClientAdapter(Ip, port);
			CA.open(); 

			JSONObject jObj = new JSONObject();
			jObj.put(ClientProtocolID.DX_EX_CODE, ClientTranCodeType.DxT006);
			jObj.put(ClientProtocolID.COMMAND_CODE, ClientProtocolID.COMMAND_CODE_D);
			jObj.put(ClientProtocolID.SERVER_INFO, serverObj);
			jObj.put(ClientProtocolID.ARR_AC_SEQ, arrSeq);
			
			objList = CA.dxT006(ClientTranCodeType.DxT006, jObj);
			
			String strErrMsg = (String)objList.get(ClientProtocolID.ERR_MSG);
			String strErrCode = (String)objList.get(ClientProtocolID.ERR_CODE);
			String strDxExCode = (String)objList.get(ClientProtocolID.DX_EX_CODE);
			String strResultCode = (String)objList.get(ClientProtocolID.RESULT_CODE);
			System.out.println("RESULT_CODE : " +  strResultCode);
			System.out.println("ERR_CODE : " +  strErrCode);
			System.out.println("ERR_MSG : " +  strErrMsg);
			
			CA.close();
			
			ClientTester clientTester = new ClientTester();
			clientTester.dxT006_R(Ip, port);
			
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	private void dxT007(String Ip, int port) {
		try {
			JSONArray arrDBInfo = new JSONArray();
			
			ClientAdapter CA = new ClientAdapter(Ip, port);
			CA.open(); 
				//CA.dxT001("dxT001", arrDBInfo);
			CA.close();
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	private void dxT008(String Ip, int port) {
		try {
			JSONArray arrDBInfo = new JSONArray();
			
			ClientAdapter CA = new ClientAdapter(Ip, port);
			CA.open(); 
				//CA.dxT001("dxT001", arrDBInfo);
			CA.close();
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	private void dxT009(String Ip, int port) {
		try {
			JSONArray arrDBInfo = new JSONArray();
			
			ClientAdapter CA = new ClientAdapter(Ip, port);
			CA.open(); 
				//CA.dxT001("dxT001", arrDBInfo);
			CA.close();
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	private void dxT011(String Ip, int port) {
		try {


			JSONObject serverObj = new JSONObject();
			
			/**
			serverObj.put(ClientProtocolID.SERVER_NAME, "222.110.153.162");
			serverObj.put(ClientProtocolID.SERVER_IP, "222.110.153.162");
			serverObj.put(ClientProtocolID.SERVER_PORT, "6432");
			serverObj.put(ClientProtocolID.DATABASE_NAME, "postgres");
			serverObj.put(ClientProtocolID.USER_ID, "experdba");
			serverObj.put(ClientProtocolID.USER_PWD, "experdba");
			**/
			
			serverObj.put(ClientProtocolID.SERVER_NAME, "222.110.153.162");
			serverObj.put(ClientProtocolID.SERVER_IP, "222.110.153.162");
			serverObj.put(ClientProtocolID.SERVER_PORT, "5432");
			serverObj.put(ClientProtocolID.DATABASE_NAME, "pgmon");
			serverObj.put(ClientProtocolID.USER_ID, "pgmon");
			serverObj.put(ClientProtocolID.USER_PWD, "pgmon");
			
			
			
			JSONObject objList;
			
			ClientAdapter CA = new ClientAdapter(Ip, port);
			CA.open(); 
				
			objList = CA.dxT011(ClientTranCodeType.DxT011, serverObj);
			
			String _tran_err_msg = (String)objList.get(ClientProtocolID.ERR_MSG);
			String strDxExCode = (String)objList.get(ClientProtocolID.DX_EX_CODE);
			
			List<Object> selectDBList =(ArrayList<Object>) objList.get(ClientProtocolID.RESULT_DATA);
			
			System.out.println("strDxExCode : " + " " + strDxExCode);
			
			for(int i=0; i<selectDBList.size(); i++) {
				
				Object obj = selectDBList.get(i);
				
				HashMap hp = (HashMap) obj;
				String rolname = (String) hp.get("rolname");

				System.out.println(i + " " + rolname);

			}
				
				
			CA.close();
		} catch(Exception e) {
			e.printStackTrace();
		}
	}

}
