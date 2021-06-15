package com.k4m.dx.tcontrol.db2pg.setting.web;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.regex.Matcher;

import org.json.simple.JSONObject;
import org.springframework.stereotype.Controller;

@Controller
public class Db2pgConfigController {
	
	/**
	 * DDL config 파일 생성
	 * 
	 * @param configObj
	 * @return JSONObject
	 * @throws Exception
	 */
	public static JSONObject createDDLConfig(JSONObject configObj) throws IOException {
		JSONObject result = new JSONObject();
		String filePath = configObj.get("path").toString()+"/config/"+configObj.get("wrk_nm").toString()+".config";
        String configPath = Db2pgConfigController.class.getResource("").getPath()+"db2pg.config";
		BufferedReader br = new BufferedReader(new FileReader(new File(configPath)));
		BufferedWriter bw = new BufferedWriter(new FileWriter(new File(filePath)));
		try{
	        String fileContent;
			while((fileContent = br.readLine()) != null) {
				fileContent = fileContent.replaceAll("SRC_DDL_EXPORT=FALSE", "SRC_DDL_EXPORT=TRUE");
				fileContent = fileContent.replaceAll("SRC_HOST=", "SRC_HOST="+configObj.get("src_host").toString());
				fileContent = fileContent.replaceAll("SRC_USER=", "SRC_USER="+configObj.get("src_user").toString());
				fileContent = fileContent.replaceAll("SRC_PASSWORD=", "SRC_PASSWORD="+java.util.regex.Matcher.quoteReplacement(configObj.get("src_password").toString()));
				fileContent = fileContent.replaceAll("SRC_DATABASE=", "SRC_DATABASE="+configObj.get("src_database").toString());
				fileContent = fileContent.replaceAll("SRC_SCHEMA=", "SRC_SCHEMA="+configObj.get("src_schema").toString());
				fileContent = fileContent.replaceAll("SRC_DB_TYPE=ORA", "SRC_DB_TYPE="+configObj.get("src_dbms_type").toString());
				fileContent = fileContent.replaceAll("SRC_PORT=1521", "SRC_PORT="+configObj.get("src_port").toString());
				fileContent = fileContent.replaceAll("SRC_DB_CHARSET=UTF8", "SRC_DB_CHARSET="+configObj.get("src_db_charset").toString());
				if(!configObj.get("src_include_tables").toString().equals("")){
					fileContent = fileContent.replaceAll("#SRC_INCLUDE_TABLES=", Matcher.quoteReplacement("SRC_INCLUDE_TABLES="+configObj.get("src_include_tables").toString()));
				}
				if(!configObj.get("src_exclude_tables").toString().equals("")){
					fileContent = fileContent.replaceAll("#SRC_EXCLUDE_TABLES=", Matcher.quoteReplacement("SRC_EXCLUDE_TABLES="+configObj.get("src_exclude_tables").toString()));
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
		String filePath = configObj.get("path").toString()+"/config/"+configObj.get("wrk_nm").toString()+".config";
		String configPath = Db2pgConfigController.class.getResource("").getPath()+"db2pg.config";
		// String filePath = "C:\\Users\\yeeun\\git\\eXperDB-Management\\eXperDB-Management-WebConsole\\src\\main\\java\\com\\k4m\\dx\\tcontrol\\db2pg\\setting\\web\\"+configObj.get("wrk_nm").toString()+".config";
        // String configPath = "C:\\Users\\yeeun\\git\\eXperDB-Management\\eXperDB-Management-WebConsole\\src\\main\\java\\com\\k4m\\dx\\tcontrol\\db2pg\\setting\\web\\db2pg.config";
        BufferedReader br = new BufferedReader(new FileReader(new File(configPath)));
		BufferedWriter bw = new BufferedWriter(new FileWriter(new File(filePath)));
		try{
	        String fileContent;
			while((fileContent = br.readLine()) != null) {
				fileContent = fileContent.replaceAll("DB_WRITER_MODE=FALSE", "DB_WRITER_MODE=TRUE");
				fileContent = fileContent.replaceAll("SRC_INCLUDE_DATA_EXPORT=FALSE", "SRC_INCLUDE_DATA_EXPORT=TRUE");
				fileContent = fileContent.replaceAll("SRC_HOST=", "SRC_HOST="+configObj.get("src_host").toString());
				fileContent = fileContent.replaceAll("SRC_USER=", "SRC_USER="+configObj.get("src_user").toString());
				fileContent = fileContent.replaceAll("SRC_PASSWORD=", "SRC_PASSWORD="+java.util.regex.Matcher.quoteReplacement(configObj.get("src_password").toString()));
				fileContent = fileContent.replaceAll("SRC_DATABASE=", "SRC_DATABASE="+configObj.get("src_database").toString());
				fileContent = fileContent.replaceAll("SRC_SCHEMA=", "SRC_SCHEMA="+configObj.get("src_schema").toString());
				fileContent = fileContent.replaceAll("SRC_DB_TYPE=ORA", "SRC_DB_TYPE="+configObj.get("src_dbms_type").toString());
				fileContent = fileContent.replaceAll("SRC_PORT=1521", "SRC_PORT="+configObj.get("src_port").toString());
				fileContent = fileContent.replaceAll("SRC_DB_CHARSET=UTF8", "SRC_DB_CHARSET="+configObj.get("src_db_charset").toString());
				if(!configObj.get("src_include_tables").toString().equals("")){
					fileContent = fileContent.replaceAll("#SRC_INCLUDE_TABLES=", "SRC_INCLUDE_TABLES="+Matcher.quoteReplacement(configObj.get("src_include_tables").toString()));
				}
				if(!configObj.get("src_exclude_tables").toString().equals("")){
					fileContent = fileContent.replaceAll("#SRC_EXCLUDE_TABLES=", "SRC_EXCLUDE_TABLES="+Matcher.quoteReplacement(configObj.get("src_exclude_tables").toString()));
				}
				fileContent = fileContent.replaceAll("SRC_SELECT_ON_PARALLEL=1", "SRC_SELECT_ON_PARALLEL="+configObj.get("src_select_on_parallel").toString());
				//target pool 생성 에러로 인해 소스 병렬도(SRC_SELECT_ON_PARALLEL)랑 타겟 커넥션 수(TAR_CONN_COUNT) 동일하게 변경
				fileContent = fileContent.replaceAll("TAR_CONN_COUNT=1", "TAR_CONN_COUNT="+configObj.get("src_select_on_parallel").toString());
				
				//blob 데이터 가능하도록 SRC_COPY_SEGMENT_SIZE,SRC_STATEMENT_FETCH_SIZE 통일 
				fileContent = fileContent.replaceAll("SRC_COPY_SEGMENT_SIZE=3000", "SRC_COPY_SEGMENT_SIZE="+configObj.get("src_copy_segment_size").toString());
				fileContent = fileContent.replaceAll("SRC_STATEMENT_FETCH_SIZE=3000", "SRC_STATEMENT_FETCH_SIZE="+configObj.get("src_copy_segment_size").toString());
				
				fileContent = fileContent.replaceAll("SRC_BUFFER_SIZE=10", "SRC_BUFFER_SIZE="+configObj.get("src_buffer_size").toString());
				fileContent = fileContent.replaceAll("SRC_LOB_BUFFER_SIZE=1024", "SRC_LOB_BUFFER_SIZE="+configObj.get("src_lob_buffer_size").toString());
				fileContent = fileContent.replaceAll("#SRC_ROWS_EXPORT=", "SRC_ROWS_EXPORT="+configObj.get("src_rows_export").toString());
				fileContent = fileContent.replaceAll("TAR_HOST=", "TAR_HOST="+configObj.get("tar_host").toString());
				fileContent = fileContent.replaceAll("TAR_USER=", "TAR_USER="+configObj.get("tar_user").toString());
				fileContent = fileContent.replaceAll("TAR_PASSWORD=", "TAR_PASSWORD="+java.util.regex.Matcher.quoteReplacement(configObj.get("tar_password").toString()));
				fileContent = fileContent.replaceAll("TAR_DATABASE=", "TAR_DATABASE="+configObj.get("tar_database").toString());
				fileContent = fileContent.replaceAll("TAR_SCHEMA=", "TAR_SCHEMA="+configObj.get("tar_schema").toString());
				fileContent = fileContent.replaceAll("TAR_PORT=5432", "TAR_PORT="+configObj.get("tar_port").toString());
				fileContent = fileContent.replaceAll("TAR_DB_CHARSET=UTF8", "TAR_DB_CHARSET="+configObj.get("tar_db_charset").toString());
				fileContent = fileContent.replaceAll("TAR_TRUNCATE=FALSE", "TAR_TRUNCATE="+configObj.get("tar_truncate").toString());
				fileContent = fileContent.replaceAll("TAR_CONSTRAINT_REBUILD=TRUE", "TAR_CONSTRAINT_REBUILD="+configObj.get("tar_constraint_rebuild").toString());
				fileContent = fileContent.replaceAll("TAR_CONSTRAINT_DDL=FALSE", "TAR_CONSTRAINT_DDL="+configObj.get("tar_constraint_ddl").toString());
				if(!configObj.get("src_where_condition").toString().equals("")){
					fileContent = fileContent.replaceAll("#SRC_WHERE_CONDITION=", "SRC_WHERE_CONDITION="+configObj.get("src_where_condition").toString());
				}
				fileContent = fileContent.replaceAll("SRC_FILE_OUTPUT_PATH=./", "SRC_FILE_OUTPUT_PATH="+configObj.get("src_file_output_path").toString());
				fileContent = fileContent.replaceAll("SRC_CLASSIFY_STRING=original", "SRC_CLASSIFY_STRING="+configObj.get("src_classify_string").toString());	
				if((boolean) configObj.get("usrqry_tf")){
					fileContent = fileContent.replaceAll("#SRC_FILE_QUERY_DIR_PATH=./queries.xml", "SRC_FILE_QUERY_DIR_PATH="+configObj.get("path").toString()+"/xml/"+configObj.get("wrk_nm").toString()+".xml");					
				}
				
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
	public static JSONObject deleteConfig(String db2pg_wrk_nm,String db2pg_path) {
		JSONObject result = new JSONObject();
		String filePath = db2pg_path+"/config/"+db2pg_wrk_nm+".config";
		// String filePath = "C:\\Users\\yeeun\\git\\eXperDB-Management\\eXperDB-Management-WebConsole\\src\\main\\java\\com\\k4m\\dx\\tcontrol\\db2pg\\setting\\web\\"+db2pg_wrk_nm+".config";

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
	
	/**
	 * query.xml 파일 만들기(보류)
	 * 
	 * @param String
	 * @return JSONObject
	 * @throws Exception
	 */
	public static JSONObject createXml(String [] table, String [] qry, String db2pg_path, String db2pg_wrk_nm) throws IOException {
		JSONObject result = new JSONObject();
		String filePath = db2pg_path+"/xml/"+db2pg_wrk_nm+".xml";
		// String filePath = "C:\\Users\\yeeun\\git\\eXperDB-Management\\eXperDB-Management-WebConsole\\src\\main\\java\\com\\k4m\\dx\\tcontrol\\db2pg\\setting\\web\\"+db2pg_wrk_nm+".xml";

		BufferedWriter bw = new BufferedWriter(new FileWriter(new File(filePath)));
		System.out.println("xml Create!!!!");
		try{
			bw.write("<QUERIES>\n");
			for(int i=0;i<table.length;i++){				
				bw.append("	<QUERY>\n");
				bw.append("		<NAME>"+table[i]+"</NAME>\n");
				bw.append("		<SELECT>\n");
				bw.append("		<![CDATA[ \n");
				bw.append("		"+qry[i]+"\n");
				bw.append("		]]>\n");
				bw.append("		</SELECT>\n");
				bw.append("	</QUERY>\n");
			}
			bw.append("</QUERIES>");			
			bw.close();
			result.put("resultCode", "0000000000");
		}catch (Exception e){
			e.printStackTrace();
			System.out.println("xml Create ERROR");
			result.put("resultCode", "8000000003");
		}
		
		return result;
	}

	/**
	 * xml 파일 삭제
	 * 
	 * @param String
	 * @return JSONObject
	 * @throws Exception
	 */
	public static JSONObject deleteXml(String db2pg_wrk_nm,String db2pg_path) {
		JSONObject result = new JSONObject();
		String filePath = db2pg_path+"/xml/"+db2pg_wrk_nm+".xml";
		// String filePath = "C:\\Users\\yeeun\\git\\eXperDB-Management\\eXperDB-Management-WebConsole\\src\\main\\java\\com\\k4m\\dx\\tcontrol\\db2pg\\setting\\web\\"+db2pg_wrk_nm+".xml";
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
