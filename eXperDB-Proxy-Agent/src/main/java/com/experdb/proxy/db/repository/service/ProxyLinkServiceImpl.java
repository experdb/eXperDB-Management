package com.experdb.proxy.db.repository.service;

import static java.nio.file.StandardCopyOption.REPLACE_EXISTING;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.annotation.Resource;

import org.codehaus.jettison.json.JSONArray;
import org.codehaus.jettison.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.experdb.proxy.db.repository.dao.ProxyDAO;
import com.experdb.proxy.db.repository.dao.SystemDAO;
import com.experdb.proxy.db.repository.vo.ProxyConfChangeHistoryVO;
import com.experdb.proxy.db.repository.vo.ProxyServerVO;
import com.experdb.proxy.util.CommonUtil;
import com.experdb.proxy.util.FileUtil;

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
@Service("ProxyLinkService")
public class ProxyLinkServiceImpl implements ProxyLinkService{

	@Resource(name = "SystemDAO")
	private SystemDAO systemDAO;

	@Resource(name = "ProxyDAO")
	private ProxyDAO proxyDAO;

	private Logger socketLogger = LoggerFactory.getLogger("socketLogger");
	private Logger errLogger = LoggerFactory.getLogger("errorToFile");
	
	public final static String TEMPLATE_DIR = "./template/";

	/**
	 * packet length 구하기
	 * 
	 * @return String
	 * @throws UnsupportedEncodingException  
	 */
	public String getPacketLength(int total, String data) throws Exception{
		CommonUtil util = new CommonUtil();
		
		int dataLen = util.getStringToHex(data).length()/2;
		String result = Integer.toHexString(total+dataLen); 
		return util.lpad(8, "0", result);
	}
	
	//파일을 읽어 String으로 반환
	public String readTemplateFile(String filename)
	{   	
		String content = null;
 	   	File file = new File(getClass().getClassLoader().getResource(TEMPLATE_DIR+filename).getFile()); 
 	   	try {
 	   		InputStreamReader reader= new InputStreamReader(new FileInputStream(file),"UTF8"); 
 	   		char[] chars = new char[(int) file.length()];
 	   		reader.read(chars);
 	   		content = new String(chars);
 	   		reader.close();
 	   	} catch (IOException e) {
 		   e.printStackTrace();
 	   	}
 	   	return content;
	}

	/**
	 * createNewConfFile DB 설정 정보를 conf 파일로 생성
	 * 
	 * @return String
	 * @throws UnsupportedEncodingException  
	 */
	@Override
	public JSONObject createNewConfFile(JSONObject jobj) throws Exception {
		//socketLogger.info("PsP004.createNewConfFile : "+jobj.toString());
		JSONObject result = new JSONObject();
		CommonUtil util = new CommonUtil();
		
		result.put("errcd", 0);
		
		try{
			//haproxy.cfg 생성
			String proxyCfg = ""; 
			
			String globalConf = readTemplateFile("global.cfg");
			
			JSONObject global = jobj.getJSONObject("global_info");
			
			int prySvrId = global.getInt("pry_svr_id");
			String lst_mdfr_id = jobj.getString("lst_mdfr_id");
			
			globalConf = globalConf.replace("{max_con_cnt}", global.getString("max_con_cnt"));
			globalConf = globalConf.replace("{cl_con_max_tm}", global.getString("cl_con_max_tm"));
			globalConf = globalConf.replace("{con_del_tm}", global.getString("con_del_tm"));
			globalConf = globalConf.replace("{svr_con_max_tm}", global.getString("svr_con_max_tm"));
			globalConf = globalConf.replace("{chk_tm}", global.getString("chk_tm"));
			
			proxyCfg += globalConf;
			
			String readOnlyConf = readTemplateFile("readOnly.cfg");
			String readWriteConf = readTemplateFile("readWrite.cfg"); 
			
			JSONArray listener = jobj.getJSONArray("listener_list");
			int listenerSize = listener.length();
			for(int i=0 ; i<listenerSize ; i++){
				JSONObject proxyListener = listener.getJSONObject(i);
				String lsn_nm = proxyListener.getString("lsn_nm");
				String bind = proxyListener.getString("con_bind_port");
				String db_nm = proxyListener.getString("db_nm");
				
				switch(lsn_nm){
					case "pgReadWrite" :
						readWriteConf = readWriteConf.replace("{lsn_nm}", lsn_nm);
						readWriteConf = readWriteConf.replace("{con_bind_port}", bind);
						readWriteConf = readWriteConf.replace("{db_nm_hex}", util.getStringToHex(db_nm)+"00");
						readWriteConf = readWriteConf.replace("{db_nm}", db_nm);
						readWriteConf = readWriteConf.replace("{packet_len}", getPacketLength(31,db_nm)); //8자, 패딩 0으로 넣기 
						proxyCfg +="\n"+readWriteConf;
						break;
					case "pgReadOnly" :
						readOnlyConf = readOnlyConf.replace("{lsn_nm}", lsn_nm);
						readOnlyConf = readOnlyConf.replace("{con_bind_port}", bind);
						readOnlyConf = readOnlyConf.replace("{db_nm_hex}", util.getStringToHex(db_nm)+"00");
						readOnlyConf = readOnlyConf.replace("{db_nm}", db_nm);
						readOnlyConf = readOnlyConf.replace("{packet_len}",  getPacketLength(31,db_nm));
						proxyCfg +="\n"+readOnlyConf;
						break;	
				}
				
				JSONArray listenerSvrList = proxyListener.getJSONArray("server_list");
				int listenerSvrListSize = listenerSvrList.length();
				String serverList = "";
				for(int j =0; j<listenerSvrListSize; j++){
					JSONObject listenSvr = listenerSvrList.getJSONObject(j);
					serverList += "    server db"+j+" "+listenSvr.getString("db_con_addr")+" check port "+listenSvr.getString("chk_portno");
					if("Y".equals(listenSvr.getString("backup_yn"))) serverList +=" BACKUP\n";
					else serverList +="\n";
				}
				
				proxyCfg +=serverList;
				
			}
			socketLogger.info("new haproxy.cfg : "+proxyCfg);
		
			//keepalived.conf 생성
			String keepalivedCfg = "#add\n";
			keepalivedCfg += "global_defs {\n";
			keepalivedCfg += "        router_id LVS_DEVEL\n";
			keepalivedCfg += "}\n";
			keepalivedCfg += "\n";
			keepalivedCfg += "\n";
			keepalivedCfg += "vrrp_track_process chk_haproxy {\n";
			keepalivedCfg += "        process \"haproxy\"\n";
			keepalivedCfg += "        weight 2\n";
			keepalivedCfg += "}\n";
			
			
			JSONArray vipConfArry = jobj.getJSONArray("vipconfig_list");
			int vipConfSize = vipConfArry.length();
			for(int i=0 ; i<vipConfSize ; i++){
				JSONObject vipConfObj = vipConfArry.getJSONObject(i);
				String vipConf = readTemplateFile("vip_instance.conf");
				vipConf = vipConf.replace("{v_index}", String.valueOf(i+1));  
				vipConf = vipConf.replace("{state_nm}", vipConfObj.getString("state_nm"));
				vipConf = vipConf.replace("{if_nm}", global.getString("if_nm"));
				vipConf = vipConf.replace("{v_rot_id}", vipConfObj.getString("v_rot_id"));
				vipConf = vipConf.replace("{priority}", vipConfObj.getString("priority")); 
				vipConf = vipConf.replace("{chk_tm}", vipConfObj.getString("chk_tm"));
				vipConf = vipConf.replace("{obj_ip}", global.getString("obj_ip"));
				vipConf = vipConf.replace("{peer_server_ip}", global.getString("peer_server_ip"));
				vipConf = vipConf.replace("{v_ip}", vipConfObj.getString("v_ip"));
				vipConf = vipConf.replace("{v_if_nm}", vipConfObj.getString("v_if_nm"));
				keepalivedCfg +="\n"+vipConf;
			}
			
			socketLogger.info("new keepalived.conf : "+keepalivedCfg);
		
			//파일 backup
			String backupPath = FileUtil.getPropertyValue("context.properties", "proxy.conf_backup_path");
			
		  	ProxyServerVO vo = new ProxyServerVO();
			vo.setPry_svr_id(prySvrId);
			ProxyServerVO proxySvr = (ProxyServerVO) proxyDAO.selectPrySvrInfo(vo);
			File initHaproxy = new File(proxySvr.getPry_pth());
			File initKeepa = new File(proxySvr.getKal_pth());
			
			//최초 적용 파일 있지만, 백업폴더 없을 경우 백업함
			File backupFolder = new File(backupPath);
			if(!backupFolder.exists() && initHaproxy.exists() && initKeepa.exists()){
				new File(backupPath+"/init/").mkdirs();
				
				Path copyHaproxy = Paths.get(backupFolder+"/init/"+initHaproxy.getName());
				Path copyKeepa = Paths.get(backupFolder+"/init/"+initKeepa.getName());
				Files.copy(initHaproxy.toPath(), copyHaproxy, REPLACE_EXISTING);
				Files.copy(initKeepa.toPath(), copyKeepa, REPLACE_EXISTING);
				socketLogger.info("createNewConfFile : copy files ");
				ProxyConfChangeHistoryVO confChgHistVo = new ProxyConfChangeHistoryVO();
				confChgHistVo.setPry_svr_id(prySvrId);
				confChgHistVo.setFrst_regr_id(lst_mdfr_id);
				confChgHistVo.setPry_pth(copyHaproxy.toString());
				confChgHistVo.setKal_pth(copyKeepa.toString());
				
				//insert T_PRYCHG_G
				proxyDAO.insertPrycngInfo(confChgHistVo);
				
				socketLogger.info("createNewConfFile : Insert init conf file info ");
			}
			DateFormat dateFormat = new SimpleDateFormat("yyyyMMddHHmmssSSS");
		  	String dateTime = dateFormat.format(new Date());
			
			//신규 파일 생성 
		  	new File(backupPath+"/"+dateTime+"/").mkdirs();
			File newHaproxy = new File(backupPath+"/"+dateTime+"/"+initHaproxy.getName());
			File newKeepa = new File(backupPath+"/"+dateTime+"/"+initKeepa.getName());
			
			byte[] proxyBytes = proxyCfg.getBytes();
			byte[] keepBytes = keepalivedCfg.getBytes();
			
			FileOutputStream os_h = new FileOutputStream(newHaproxy);
			os_h.write(proxyBytes);
			os_h.close();
			 
			FileOutputStream os_k = new FileOutputStream(newKeepa);
			os_k.write(keepBytes);
			os_k.close();
			
			Files.copy(newHaproxy.toPath(), initHaproxy.toPath(), REPLACE_EXISTING);
			Files.copy(newKeepa.toPath(), initKeepa.toPath(), REPLACE_EXISTING);//덮어쓰기
			
			ProxyConfChangeHistoryVO newConfChgHistVo = new ProxyConfChangeHistoryVO();
			newConfChgHistVo.setPry_svr_id(prySvrId);
			newConfChgHistVo.setFrst_regr_id(lst_mdfr_id);
			newConfChgHistVo.setPry_pth(newHaproxy.getPath());
			newConfChgHistVo.setKal_pth(newKeepa.getPath());
			
			//insert T_PRYCHG_G
			proxyDAO.insertPrycngInfo(newConfChgHistVo);
			socketLogger.info("createNewConfFile : Insert chg conf file info ");
			
		}catch(Exception e){
			result.put("errorCd", -1);
			result.put("error", e.toString());
			errLogger.error("createNewConfFile {} ", e.toString());
			throw e;
		}
		
		return result;
	}
}