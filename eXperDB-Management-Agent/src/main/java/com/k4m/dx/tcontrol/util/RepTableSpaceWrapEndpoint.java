package com.k4m.dx.tcontrol.util;

import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class RepTableSpaceWrapEndpoint extends Thread {
	

	private String strPGRBAK;
	private String strRESTORE_DIR;
	private Logger errLogger = LoggerFactory.getLogger("errorToFile");
	private Logger socketLogger = LoggerFactory.getLogger("socketLogger");
	
	public RepTableSpaceWrapEndpoint(String strPGRBAK, String strRESTORE_DIR){

		this.strPGRBAK = strPGRBAK;
		this.strRESTORE_DIR = strRESTORE_DIR;
	}
	
	public RepTableSpaceWrapEndpoint(){}

	@Override
	public void run(){
		try {
			
			changeTableSpacePath(strPGRBAK, strRESTORE_DIR);
		} catch (Exception e) {
			errLogger.error("[RepTableSpaceWrapEndpoint run] {} ", e.toString());
		}
	}
	
	
	private void changeTableSpacePath(String strPGRBAK, String strRESTORE_DIR) throws Exception {

		try {

				String strReplaceCmd = "find " + strPGRBAK + " -name \"mkdirs.sh\" -exec perl -pi -e 's/" + replaceSlash(strRESTORE_DIR) + "//g' {} \\;";
				
				
				socketLogger.info("rman replace command >> " + strReplaceCmd);
				
				if (!strRESTORE_DIR.equals("")) {

					ExecRmanReplaceTableSpace execRmanReplaceTableSpace = new ExecRmanReplaceTableSpace(strReplaceCmd);
					
					execRmanReplaceTableSpace.start();
					
					synchronized(execRmanReplaceTableSpace) {
						execRmanReplaceTableSpace.wait();
					}
				}

			
		} catch (Exception e) {
			errLogger.error("[RepTableSpaceWrapEndpoint] {} ", e.toString());

		} finally {	

		}	
	}
	
	
	private String replaceSlash(String strInput) throws Exception {
		String strResult = "";
		
		strResult = strInput.replaceAll("/", "\\\\/");
		return strResult;
	}
	
}
