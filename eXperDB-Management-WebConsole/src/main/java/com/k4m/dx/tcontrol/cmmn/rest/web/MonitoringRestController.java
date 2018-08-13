package com.k4m.dx.tcontrol.cmmn.rest.web;

import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.k4m.dx.tcontrol.cmmn.rest.RequestResult;
import com.k4m.dx.tcontrol.cmmn.rest.service.TestVO;


/**
 * 스케줄이력 컨트롤러 클래스를 정의한다.
 *
 * @author 변승우
 * @see
 * 
 *      <pre>
 * == 개정이력(Modification Information) ==
 *
 *   수정일       수정자           수정내용
 *  -------     --------    ---------------------------
 *  2017.07.03   변승우 최초 생성
 *      </pre>
 */
@RestController
public class MonitoringRestController {
	

	/**
	 * 스케줄이력 화면을 보여준다.
	 * 
	 * @param
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/experdb/rest/monitoring/testMonitoring.do", method = RequestMethod.POST)
	public  @ResponseBody TestVO selectScheduleHistoryView(@RequestBody TestVO testVO) {
		
		TestVO result = new TestVO();
		result.setTestMessage("ok");
		try {			
			System.out.println("########################## OK ###########################" + testVO.getTestMessage());
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return result;

	}
	
	
}
