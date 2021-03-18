package com.experdb.proxy.server;

import java.sql.DriverManager;
import java.util.List;

import org.apache.commons.dbcp.PoolingDriver;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import com.experdb.proxy.db.DBCPPoolManager;
import com.experdb.proxy.socket.ProtocolID;
import com.experdb.proxy.socket.TranCodeType;

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
public class SocketExt {
	protected JSONObject ResultJSON(List<Object> poutputArray, String _tran_err_msg){
		JSONObject outputObj = new JSONObject();
		JSONArray outputArray = (JSONArray) poutputArray;
		outputObj.put(ProtocolID.DX_EX_CODE, TranCodeType.RESULT);
		outputObj.put(ProtocolID.ERR_MSG, _tran_err_msg);
		outputObj.put(ProtocolID.RESULT_DATA, outputArray);

		return outputObj;
	}

	/**
	 * Connection Pool 생성
	 * @param serverInfoObj
	 * @param poolName
	 * @throws Exception
	 */
	public static void setupDriverPool(JSONObject serverInfoObj, String poolName) throws Exception{
		
		// pool 네임정보를 가져온다.
		PoolingDriver driver = (PoolingDriver) DriverManager.getDriver("jdbc:apache:commons:dbcp:");
		String[] poolNames = driver.getPoolNames();
		
		
		boolean isPool = false;
		for (int i = 0; i < poolNames.length; i++){
			if(poolNames[i].equals(poolName)){
				isPool = true;
				break;
			}
		}	
		
		if(!isPool)
		{
			DBCPPoolManager dBCPPoolManager = new DBCPPoolManager();
			
			dBCPPoolManager.setupDriver(
					"org.postgresql.Driver",
					"jdbc:postgresql://"+ serverInfoObj.get(ProtocolID.SERVER_IP) +":"+ serverInfoObj.get(ProtocolID.SERVER_PORT) +"/"+ serverInfoObj.get(ProtocolID.DATABASE_NAME),
					(String)serverInfoObj.get(ProtocolID.USER_ID),
					(String)serverInfoObj.get(ProtocolID.USER_PWD),
					poolName,
					10
			);					
		}
	}
}
