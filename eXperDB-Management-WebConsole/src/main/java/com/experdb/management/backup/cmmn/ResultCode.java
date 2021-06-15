package com.experdb.management.backup.cmmn;

import java.util.regex.Pattern;

import org.json.simple.JSONObject;

public class ResultCode {

	
	
	public static JSONObject cifsResultCode(String output) {
		JSONObject result = new JSONObject();
		
		String text = output.trim().replace("\n", "");

		  if (text.matches(".*NT_STATUS_LOGON_FAILURE.*") && text.matches(".*1.*")) {
				result.put("RESULT_CODE", 1);
				result.put("RESULT_DATA", " Invalid username/password; logon denied");
				System.out.println(" Invalid username/password; logon denied");
			} else if (text.matches(".*NT_STATUS_BAD_NETWORK_NAME.*") && text.matches(".*1.*")) {
				result.put("RESULT_CODE", 1);
				result.put("RESULT_DATA", "NT_STATUS_BAD_NETWORK_NAME" );
				System.out.println("NT_STATUS_BAD_NETWORK_NAME");
			}else if (text.matches(".*1.*")) {
				result.put("RESULT_CODE", 1);
				result.put("RESULT_DATA", "NT_STATUS_UNSUCCESSFUL");
				System.out.println("NT_STATUS_UNSUCCESSFUL");
			}else{
				result.put("RESULT_CODE", 0);
				result.put("RESULT_DATA", output.trim());
				System.out.println("Result command : " + output.trim());
			}
		 
		return result;
		
	}
	
	
	
	public static JSONObject nfsResultCode(String output, String command) {
		JSONObject result = new JSONObject();
		
		 if (output.trim().matches(".*32.*")) {
				result.put("RESULT_CODE", 1);
				System.out.println("Failed command : " + command);
			}else if (output.trim().matches(".*0.*") && command.matches(".*umount.*")) {
				result.put("RESULT_CODE", 0);
				result.put("RESULT_DATA", "NFS UNMOUNT SUCCESS");
				System.out.println("Result command : NFS UNMOUNT SUCCESS");
			}else if (output.trim().matches(".*0.*") && command.matches(".*mount.*"))  {
				result.put("RESULT_CODE", 0);
				result.put("RESULT_DATA", "NFS MOUNT SUCCESS");
				System.out.println("Result command : NFS MOUNT SUCCESS");
			}else{
				result.put("RESULT_CODE", 0);
				result.put("RESULT_DATA", output.trim());
				System.out.println("Result command : " + output.trim());
			}
		 
		return result;	
	}

	
	public static JSONObject nodeResultCode(String output) {
		JSONObject result = new JSONObject();
		
		// Invalid 형태이면
		if (output.trim().matches(".*Invalid.*")) {
			result.put("RESULT_CODE", 1);
			result.put("RESULT_DATA", output.trim());
			System.out.println("Invalid command : " + output.trim());
			// invalid 형태이면
		} else if (output.trim().matches(".*invalid.*")) {
			result.put("RESULT_CODE", 1);
			result.put("RESULT_DATA", output.trim());
			System.out.println("invalid command : " + output.trim());
			// Failed 형태이면
		} else if (output.trim().matches(".*Failed.*")) {
			result.put("RESULT_CODE", 1);
			result.put("RESULT_DATA", output.trim());
			System.out.println("Failed command : " + output.trim());
		}else{
			result.put("RESULT_CODE", 0);
			result.put("RESULT_DATA", output.trim());
			System.out.println("Result command : " + output.trim());
		}
		
		return result;
	}
	

	public static JSONObject jobResultCode(String output) {
		JSONObject result = new JSONObject();
		
		if (output.trim().matches(".*formatisnot.*")) {
			result.put("RESULT_CODE", 1);
			result.put("RESULT_DATA", output.trim());
			System.out.println("invalid command : The file format is not correct.");
		}else if (output.trim().matches(".*notexis.*")) {
			result.put("RESULT_CODE", 1);
			result.put("RESULT_DATA", output.trim());
			System.out.println("invalid command : File does not exist." );
		}else if (output.trim().matches(".*unreachable.*")) {
			result.put("RESULT_CODE", 1);
			result.put("RESULT_DATA", output.trim());
			System.out.println("invalid command : Verify that the node is valid and can be reached, and then try again");
		}else{
			result.put("RESULT_CODE", 0);
			result.put("RESULT_DATA", output.trim());
			System.out.println("Result command : " + output.trim());
		}
		
		return result;
	}
	
}
