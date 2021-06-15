package com.experdb.proxy.socket.client;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;


/**
* @author 
* @see
* 
*      <pre>
* == 개정이력(Modification Information) ==
*
*   수정일       수정자           수정내용
*  -------     --------    ---------------------------
*  2021.02.24   
*      </pre>
*/

/**
 * agent 기능
 * 
 * 1. proxy 에이전트 setting(PsP001)
 * 2. proxy 에이전트 연결 Test(PsP002)
 * 3. proxy, keepalived conf 파일 가져오기(PsP003)
 * 4. proxy conf 파일 백업 & 신규 생성 (PsP004)
 * 5. proxy service restart(PsP005)
 * 6. proxy service start/stop(PsP006)
 * 7. proxy agent interface 목록 조회(PsP007)
 * 8. proxy log 파일 가져오기(PsP008)
 * 9. proxy conf 파일 searh 후 데이터 입력 요청(PsP009)
 * 10. Keepavlied 설치 여부 확인(PsP010)
 * 11. Config Backup 폴더 삭제 (PsP011)
 * 
 * @author 
 *
 */
public class ClientTester {
	
	public static void main(String[] args) {
		
		ClientTester clientTester = new ClientTester();
		
		String Ip = "192.168.50.110";
		int port = 9002;

		try {
			clientTester.PsP001(Ip, port);
			//clientTester.PsP002(Ip, port);
			//clientTester.PsP003(Ip, port);
			//clientTester.PsP004(Ip, port);
			//clientTester.PsP005(Ip, port);
			//clientTester.PsP006(Ip, port);
			//clientTester.PsP007(Ip, port);
			//clientTester.PsP008(Ip, port);
			//clientTester.PsP009(Ip, port);
			//clientTester.PsP0010(Ip, port);
			//clientTester.PsP0011(Ip, port);
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	private void PsP001(String Ip, int port) {
		try {
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	private void PsP002(String Ip, int port) {
		try {
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	private void PsP003(String Ip, int port) {
		try {
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	private void PsP004(String Ip, int port) {
		try {
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	private void PsP005(String Ip, int port) {
		try {
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	private void PsP006(String Ip, int port) {
		try {
		} catch(Exception e) {
			e.printStackTrace();
		}
	}

	private void PsP007(String Ip, int port) {
		try {
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	private void PsP008(String Ip, int port) {
		try {
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	private void PsP009(String Ip, int port) {
		try {
		} catch(Exception e) {
			e.printStackTrace();
		}
	}

	private void PsP010(String Ip, int port) {
		try {
		} catch(Exception e) {
			e.printStackTrace();
		}
	}

	private void PsP011(String Ip, int port) {
		try {
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
}
