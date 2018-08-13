package com.k4m.dx.tcontrol.monitoring.schedule.sender;

import org.springframework.web.client.RestTemplate;

import com.k4m.dx.tcontrol.monitoring.schedule.sender.vo.TestVO;
import com.k4m.dx.tcontrol.monitoring.schedule.service.ExperDBRestApi;
import com.k4m.dx.tcontrol.monitoring.schedule.service.RestCommonService;

public class Sender {

	
	public void sendHttpRestSample(String restIp, int restPort, String strService, String strCommand) throws Exception {
		RestCommonService api = new RestCommonService(restIp, restPort);

		///experdb/rest/monitoring/testMonitoring.do
		//String strService = "monitoring";
		//String strCommand = "testMonitoring.do";
		TestVO testVO = new TestVO();
		testVO.setTestMessage("test");

		
		RestTemplate restTemplate = new RestTemplate();
		
		ExperDBRestApi experDBRestApi = new ExperDBRestApi(restIp, restPort);
		
		String url = experDBRestApi.makeRestHttpURL(strService, strCommand);

		TestVO returnTestVO = restTemplate.postForObject(url, testVO, TestVO.class);
		
	
		System.out.println("result : " + returnTestVO.getTestMessage());
	}
}
