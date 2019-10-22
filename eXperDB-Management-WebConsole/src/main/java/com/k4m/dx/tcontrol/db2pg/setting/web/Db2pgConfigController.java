package com.k4m.dx.tcontrol.db2pg.setting.web;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;

import org.json.simple.JSONObject;
import org.springframework.stereotype.Controller;

@Controller
public class Db2pgConfigController {
	
	static String path="C:/test";
	
	/**
	 * DDL config 파일 생성
	 * 
	 * @param configObj
	 * @return JSONObject
	 * @throws Exception
	 */
	public static JSONObject createDDLConfig(JSONObject configObj) throws IOException {
		JSONObject result = new JSONObject();
		String filePath = path+"/"+configObj.get("wrk_nm").toString()+".config";
        String configPath = Db2pgConfigController.class.getResource("").getPath()+"db2pg.config";
        BufferedReader br = new BufferedReader(new FileReader(new File(configPath)));
		BufferedWriter bw = new BufferedWriter(new FileWriter(new File(filePath)));
		try{
	        String fileContent;
			while((fileContent = br.readLine()) != null) {
				fileContent = fileContent.replaceAll("SRC_DDL_EXPORT=FALSE", "SRC_DDL_EXPORT=TRUE");
				fileContent = fileContent.replaceAll("SRC_HOST=", "SRC_HOST="+configObj.get("src_host").toString());
				fileContent = fileContent.replaceAll("SRC_USER=", "SRC_USER="+configObj.get("src_user").toString());
				fileContent = fileContent.replaceAll("SRC_PASSWORD=", "SRC_PASSWORD="+configObj.get("src_password").toString());
				fileContent = fileContent.replaceAll("SRC_DATABASE=", "SRC_DATABASE="+configObj.get("src_database").toString());
				fileContent = fileContent.replaceAll("SRC_SCHEMA=", "SRC_SCHEMA="+configObj.get("src_schema").toString());
				fileContent = fileContent.replaceAll("SRC_DBMS_TYPE=ORA", "SRC_DBMS_TYPE="+configObj.get("src_dbms_type").toString());
				fileContent = fileContent.replaceAll("SRC_PORT=1521", "SRC_PORT="+configObj.get("src_port").toString());
				fileContent = fileContent.replaceAll("SRC_DB_CHARSET=UTF8", "SRC_DB_CHARSET="+configObj.get("src_db_charset").toString());
				if(!configObj.get("src_include_tables").toString().equals("")){
					fileContent = fileContent.replaceAll("#SRC_INCLUDE_TABLES=", "SRC_INCLUDE_TABLES="+configObj.get("src_include_tables").toString());
				}
				if(!configObj.get("src_exclude_tables").toString().equals("")){
					fileContent = fileContent.replaceAll("#SRC_EXCLUDE_TABLES=", "SRC_EXCLUDE_TABLES="+configObj.get("src_exclude_tables").toString());
				}
				fileContent = fileContent.replaceAll("SRC_CLASSIFY_STRING=original", "SRC_CLASSIFY_STRING="+configObj.get("src_classify_string").toString());	
				fileContent = fileContent.replaceAll("SRC_TABLE_DDL=TRUE", "SRC_TABLE_DDL="+configObj.get("src_table_ddl").toString());		
				fileContent = fileContent.replaceAll("SRC_FILE_OUTPUT_PATH=./", "SRC_FILE_OUTPUT_PATH="+configObj.get("src_file_output_path").toString());
				bw.write(fileContent + "\r\n");
				bw.flush();
			}
			
			bw.close();
			br.close();
			
			result.put("resultCode", "0000000000");
		} catch (Exception e) {
			e.printStackTrace();
			result.put("resultCode", "8000000003");
		}
		return result;
	}
	
	/**
	 * Data config 파일 생성
	 * 
	 * @param configObj
	 * @return JSONObject
	 * @throws Exception
	 */
	public static JSONObject createDataConfig(JSONObject configObj) throws IOException {
		JSONObject result = new JSONObject();
		String filePath = path+"/"+configObj.get("wrk_nm").toString()+".config";
        String configPath = Db2pgConfigController.class.getResource("").getPath()+"db2pg.config";
        BufferedReader br = new BufferedReader(new FileReader(new File(configPath)));
		BufferedWriter bw = new BufferedWriter(new FileWriter(new File(filePath)));
		try{
	        String fileContent;
			while((fileContent = br.readLine()) != null) {
				fileContent = fileContent.replaceAll("DB_WRITER_MODE=FALSE", "DB_WRITER_MODE=TRUE");
				fileContent = fileContent.replaceAll("SRC_HOST=", "SRC_HOST="+configObj.get("src_host").toString());
				fileContent = fileContent.replaceAll("SRC_USER=", "SRC_USER="+configObj.get("src_user").toString());
				fileContent = fileContent.replaceAll("SRC_PASSWORD=", "SRC_PASSWORD="+configObj.get("src_password").toString());
				fileContent = fileContent.replaceAll("SRC_DATABASE=", "SRC_DATABASE="+configObj.get("src_database").toString());
				fileContent = fileContent.replaceAll("SRC_SCHEMA=", "SRC_SCHEMA="+configObj.get("src_schema").toString());
				fileContent = fileContent.replaceAll("SRC_DBMS_TYPE=ORA", "SRC_DBMS_TYPE="+configObj.get("src_dbms_type").toString());
				fileContent = fileContent.replaceAll("SRC_PORT=1521", "SRC_PORT="+configObj.get("src_port").toString());
				fileContent = fileContent.replaceAll("SRC_DB_CHARSET=UTF8", "SRC_DB_CHARSET="+configObj.get("src_db_charset").toString());
				bw.write(fileContent + "\r\n");
				bw.flush();
			}
			
			bw.close();
			br.close();
			
			result.put("resultCode", "0000000000");
		}catch (Exception e) {
			e.printStackTrace();
			result.put("resultCode", "8000000003");
		}
		return result;
	}

	/**
	 * config 파일 삭제
	 * 
	 * @param String
	 * @return JSONObject
	 * @throws Exception
	 */
	public static JSONObject deleteDDLConfig(String db2pg_ddl_wrk_nm) {
		JSONObject result = new JSONObject();
		String filePath = path+"/"+db2pg_ddl_wrk_nm+".config";
		try{
			File file = new File(filePath);
			if(file.exists()){
				file.delete();
	    	}
			result.put("resultCode", "0000000000");
		}catch (Exception e) {
			e.printStackTrace();
			result.put("resultCode", "8000000003");
		}
		return result;
	}
	
}
