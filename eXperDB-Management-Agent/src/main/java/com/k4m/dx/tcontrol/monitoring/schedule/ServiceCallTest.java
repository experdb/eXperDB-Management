package com.k4m.dx.tcontrol.monitoring.schedule;

import java.util.LinkedHashMap;

import org.springframework.web.client.RestTemplate;

import com.k4m.dx.tcontrol.monitoring.schedule.runner.RunShell;
import com.k4m.dx.tcontrol.monitoring.schedule.sender.vo.TestVO;
import com.k4m.dx.tcontrol.monitoring.schedule.service.ExperDBRestApi;
import com.k4m.dx.tcontrol.monitoring.schedule.service.RestCommonService;



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

public class ServiceCallTest {

	public static void main(String[] args) throws Exception {

		String restIp = "222.110.153.204";
		int restPort = 9443;
		
		restIp = "127.0.0.1";

		restPort = 8080;
		
		//restIp = "192.168.56.112";

		

		ServiceCallTest test = new ServiceCallTest();
	
		test.selectTest(restIp, restPort);
		
	}

	private void selectTest(String restIp, int restPort) throws Exception {

		RestCommonService api = new RestCommonService(restIp, restPort);

		///experdb/rest/monitoring/testMonitoring.do
		String strService = "monitoring";
		String strCommand = "testMonitoring.do";
		TestVO testVO = new TestVO();
		testVO.setTestMessage("test");

		
		RestTemplate restTemplate = new RestTemplate();
		
		ExperDBRestApi experDBRestApi = new ExperDBRestApi(restIp, restPort);
		
		String url = experDBRestApi.makeRestHttpURL(strService, strCommand);

		TestVO returnTestVO = restTemplate.postForObject(url, testVO, TestVO.class);
		
	
		System.out.println("result : " + returnTestVO.getTestMessage());

	}
	
	private void runShell() throws Exception {
		RunShell runShell = new RunShell();
		
		LinkedHashMap<String,String> map = new LinkedHashMap<String,String>();
		
		//$0 FILE_NAME $1 SERVER_URL $2 PORT $3 ROLE $4 DATABASE
		//./find_dbname.sh 192.168.56.108 5433 experdb experdb
		String FILE_NAME = "find_dbname.sh";
		String SERVER_URL = "192.168.56.108";
		String PORT = "5433";
		String ROLE = "experdb";
		String DATABASE = "experdb";
		
		map.put("FILE_NAME", FILE_NAME);
		map.put("SERVER_URL", SERVER_URL);
		map.put("PORT", PORT);
		map.put("ROLE", ROLE);
		map.put("DATABASE", DATABASE);
		
		
		runShell.run(map);
	}
	
}
