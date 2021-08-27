package com.experdb.management.proxy.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.experdb.management.proxy.service.ProxyListenerServerVO;
import com.experdb.management.proxy.service.ProxyRestService;

/**
 * CDC와 연동 컨트롤러 클래스를 정의한다.
 *
 * @author 김민정
 * @see
 * 
 *      <pre>
 * == 개정이력(Modification Information) ==
 *
 *     수정일                 수정자           수정내용
 *  ------------     --------    ---------------------------
 *  2021.08.24         김민정           최초 생성
 *      </pre>
 */
@RestController
public class ProxyRestController {
	@Autowired
	private ProxyRestService proxyRestService;

	/**
	 * ScaleIn 발생 시 HAProxy.cfg 설정 중 db_svr_list 해당 항목 delete 후 agent에 cfg 파일 수정 후 reload 처리  
	 * 
	 * @param JSONObject
	 * @return JSONObject
	 * @throws Exception
	 */
	@RequestMapping(value = "/experdb/rest/proxy/setProxyScaleInTest.do", method = RequestMethod.POST)
	public  @ResponseBody JSONObject setProxyScaleInTest(@RequestBody JSONObject  param) {
		System.out.println("##########################  setProxyScaleInTest  ###########################");
		
		try{
			JSONParser jParser = new JSONParser();
			JSONObject paramObj = (JSONObject)jParser.parse(param.toString());
			
			JSONArray instanceArray = (JSONArray)paramObj.get("instance");
			
			for(int i=0; i<instanceArray.size(); i++){
				JSONObject jObj = (JSONObject) instanceArray.get(i);
				
				System.out.println(jObj.get("ip")+":"+jObj.get("port"));
			}
		}catch(Exception e){
			System.out.println("error :: " + e.toString());
		}
		
		return param;
	}
	
	/**
	 * ScaleIn 발생 시 HAProxy.cfg 설정 중 db_svr_list 해당 항목 delete 후 agent에 cfg 파일 수정 후 reload 처리  
	 * 
	 * @param JSONObject
	 				{"instance": [{"ip": "192.168.50.182","port": "5432"},{"ip": "192.168.50.183","port": "5432"}]}
	 * @return JSONObject
	 * @throws Exception
	 */
	@RequestMapping(value = "/experdb/rest/proxy/setProxyScaleIn.do", method = RequestMethod.POST)
	public  @ResponseBody JSONObject setProxyScaleIn(@RequestBody JSONObject request) {
		System.out.println("##########################  setProxyScaleIn  ###########################");
		JSONObject resultObj = new JSONObject();
		try {			
			
			JSONParser jParser = new JSONParser();
			JSONObject paramObj = (JSONObject)jParser.parse(request.toString());
			
			JSONArray instanceArray = (JSONArray)paramObj.get("instance");
			
			Map<String, Object> param = new HashMap<String, Object>();
			List<String> dbConAddr = new ArrayList<String>();
			
			for(int i=0; i<instanceArray.size(); i++){
				JSONObject jObj = (JSONObject) instanceArray.get(i);
				dbConAddr.add(jObj.get("ip")+":"+jObj.get("port"));
			}
			param.put("db_con_addr", dbConAddr);
			
			//어떤 Proxy 서버와, Agent를 수정해야되는지 List 추출
			List<Map<String, Object>> pryScaleList = proxyRestService.selectScaleInProxyList(param);	
		
			//Delete T_PRY_LSN_SVR_I
			proxyRestService.scaleInProxyLsnSvrList(param);
			
			//Agent로 cfg 수정 후 반영 요청 
			resultObj= proxyRestService.setProxyConfScaleIn(pryScaleList);
			System.out.println(resultObj.toJSONString());
			
		} catch (Exception e) {
		
			e.printStackTrace();
		
		}
		
		return resultObj;
	}
	
	
	/**
	 * ScaleOut 발생 시 HAProxy.cfg 설정 중 db_svr_list 해당 항목 insert 후 agent에 cfg 파일 수정 후 reload 처리  
	 * 
	 * @param JSONObject
	 				{"instance": [{"ip": "192.168.50.182","port": "5432"},{"ip": "192.168.50.183","port": "5432"}]}
	 * @return JSONObject
	 * @throws Exception
	 */
	@RequestMapping(value = "/experdb/rest/proxy/setProxyScaleOut.do", method = RequestMethod.POST)
	public  @ResponseBody JSONObject setProxyScaleOut(@RequestBody JSONObject request) {
		System.out.println("##########################  setProxyScaleOut  ###########################");
		JSONObject resultObj = new JSONObject();
		
		try{
			JSONParser jParser = new JSONParser();
			JSONObject paramObj = (JSONObject)jParser.parse(request.toString());
			
			JSONArray instanceArray = (JSONArray)paramObj.get("instance");
			Map<String, Object> param = new HashMap<String, Object>();
			List<String> dbConIp = new ArrayList<String>();
			ProxyListenerServerVO listnSvr[] = new ProxyListenerServerVO[instanceArray.size()];
			
			for(int i=0; i<instanceArray.size(); i++){
				JSONObject jObj = (JSONObject) instanceArray.get(i);
				listnSvr[i] = new ProxyListenerServerVO();
				listnSvr[i].setDb_con_addr(jObj.get("ip")+":"+jObj.get("port"));
				listnSvr[i].setChk_portno(Integer.parseInt(jObj.get("port").toString()));
				listnSvr[i].setBackup_yn("N");
				listnSvr[i].setLst_mdfr_id("system");
				dbConIp.add(jObj.get("ip").toString());
			}
			param.put("ipadr", dbConIp);
			
			System.out.println("Param :: "+param.toString());
			//어떤 Proxy 서버와, Agent를 수정해야되는지 List 추출
			List<Map<String, Object>> pryScaleList = proxyRestService.selectScaleOutProxyList(param);	
		
			//Insert T_PRY_LSN_SVR_I
			proxyRestService.scaleOutProxyLsnSvrList(listnSvr, pryScaleList);
			
			//Agent로 cfg 수정 후 반영 요청 
			resultObj= proxyRestService.setProxyConfScaleIn(pryScaleList);
			System.out.println(resultObj.toJSONString());
		}catch(Exception e){
			System.out.println("error :: " + e.toString());
		}
		return resultObj;
	}
	
}
