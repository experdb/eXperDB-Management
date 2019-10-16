package com.k4m.dx.tcontrol.db2pg.setting.web;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;

import org.json.simple.JSONObject;
import org.springframework.stereotype.Controller;

@Controller
public class Db2pgConfigController {

	public static String createDDLConfig(JSONObject configObj) {
		String filePath = configObj.get("save_pth").toString()+"/"+configObj.get("wrk_nm").toString()+".config";
        String configPath = Db2pgSettingController.class.getResource("").getPath()+"db2pg.config";
		try{
	        String fileContent;
	        BufferedReader br = new BufferedReader(new FileReader(new File(configPath)));
			BufferedWriter bw = new BufferedWriter(new FileWriter(new File(filePath)));
	
			while((fileContent = br.readLine()) != null) {
				fileContent = fileContent.replaceAll("SRC_DDL_EXPORT=FALSE", "SRC_DDL_EXPORT=TRUE");
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
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	
}
