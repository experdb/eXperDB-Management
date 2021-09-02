package com.k4m.dx.tcontrol.server;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.net.Socket;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import com.k4m.dx.tcontrol.db.SqlSessionManager;
import com.k4m.dx.tcontrol.db.repository.service.TransServiceImpl;
import com.k4m.dx.tcontrol.db.repository.vo.TransVO;
import com.k4m.dx.tcontrol.socket.ErrCodeMng;
import com.k4m.dx.tcontrol.socket.ProtocolID;
import com.k4m.dx.tcontrol.socket.SocketCtl;
import com.k4m.dx.tcontrol.socket.TranCodeType;
import com.k4m.dx.tcontrol.util.RunCommandExec;

/**
 * Connect 정지
 *
 * @author 변승우
 * @see <pre>
 * == 개정이력(Modification Information) ==
 *
 *   수정일       수정자           수정내용
 *  -------     --------    ---------------------------
 *  2020.04.09   변승우 최초 생성
 * </pre>
 */

public class DxT039 extends SocketCtl{
	
	private Logger errLogger = LoggerFactory.getLogger("errorToFile");
	private Logger socketLogger = LoggerFactory.getLogger("socketLogger");
	
	ApplicationContext context;
	
	public DxT039(Socket socket, BufferedInputStream is, BufferedOutputStream	os) {
		this.client = socket;
		this.is = is;
		this.os = os;
	}

	public void execute(String strDxExCode, JSONObject jObj) throws Exception {
		socketLogger.info("DxT039.execute : " + strDxExCode);
		
		byte[] sendBuff = null;
		String strErrCode = "";
		String strErrMsg = "";
		String strSuccessCode = "0";

		context = new ClassPathXmlApplicationContext(new String[] { "context-tcontrol.xml" });
		TransServiceImpl transService = (TransServiceImpl) context.getBean("TransService");
		
		String strCmd = (String) jObj.get(ProtocolID.REQ_CMD);
		int trans_id = Integer.parseInt((String) jObj.get(ProtocolID.TRANS_ID));
		String con_start_gbn = (String) jObj.get(ProtocolID.CON_START_GBN);
		String login_id = "";
		if (jObj.get(ProtocolID.LOGIN_ID) != null) {
			login_id = jObj.get(ProtocolID.LOGIN_ID).toString();
		}
		
		String conectStopGbn = "";
	
		JSONObject outputObj = new JSONObject();
		
		try {
			socketLogger.info("[COMMAND] " + strCmd);
			
			if ("source".equals(con_start_gbn)) {
				TransVO transSearchVO = new TransVO();
				transSearchVO.setTrans_id(trans_id);

				List<TransVO> topicTableList = transService.selectTranIdTopicTotCnt(transSearchVO); // topic count 조회
				socketLogger.info("DxT039.topicTableList : " + topicTableList.get(0));

				if (topicTableList != null) {
					//target 이 연결되어있는 경우
					if (topicTableList.get(0).getTar_trans_id_cnt() > 0) {
						if (topicTableList.get(0).getTar_topic_ing_cnt() > 0) { //target이 활성화 일경우
							// topicTableList.get(0).getTar_trans_id_cnt()
							conectStopGbn = "no_deps";
						} else { //target이 비활성화 일경우
							if (topicTableList.get(0).getTopic_overlap_cnt() > 0) { // 중복 source topic 이 있는 경우
								if (topicTableList.get(0).getTar_topic_overlap_ing_cnt() > 0) { //중복 topic source이 있는 경우 해당 토픽이 실행 중일 경우
									conectStopGbn = "2deps";
								} else { //중복 topic이 있는 경우 해당 토픽이 실행 중이 아닐경우
									conectStopGbn = "4deps";
								}
							} else { // 중복 source topic 이 없는 경우
								conectStopGbn = "4deps";
							}
						}
					} else {
						//target이 연결되어있지 않은 경우
						conectStopGbn = "total";
					}
				} else {
					conectStopGbn = "total";
				}
			} else {
				conectStopGbn = "total";
			}
			socketLogger.info("##### 결과 : conectStopGbn ==" + conectStopGbn);	
			
			//conectStopGbn 이 total 일 경우 전체 삭제
			if ("total".equals(conectStopGbn) || "2deps".equals(conectStopGbn) || "4deps".equals(conectStopGbn) || "no_deps".equals(conectStopGbn)) {
				RunCommandExec r = new RunCommandExec(strCmd);
				
				//명령어 실행
				r.start();
				try {
					r.join();
				} catch (InterruptedException ie) {
					ie.printStackTrace();
				}
				String retVal = r.call();
				String strResultMessge = r.getMessage();

				socketLogger.info("[RESULT] " + retVal);
				socketLogger.info("[MSG] " + strResultMessge);

				socketLogger.info("##### 결과 : " + retVal + " message : " +strResultMessge);	

				if ("total".equals(conectStopGbn) || "2deps".equals(conectStopGbn) || "4deps".equals(conectStopGbn)) {
					if (retVal.equals("success")) {
						TransVO transVO = new TransVO();
						transVO.setTrans_id(trans_id);
						transVO.setExe_status("TC001502");
						transVO.setSrc_topic_use_yn("N");
						transVO.setWrite_use_yn("N");
						transVO.setLogin_id(login_id);
						
						//타겟 전송테이블 삭제
						if ("4deps".equals(conectStopGbn)) {
						//	updateTranExrtTrgList(transVO);
						}

						//topic 테이블 수정
						transService.updateTransTopicTbl(transVO);
							
						if ("total".equals(conectStopGbn) || "4deps".equals(conectStopGbn)) {
							//topic 삭제
							transService.deleteRealTransTopic(transVO);
						}
					}
				}
				
				TransVO transMainVO = new TransVO();
				transMainVO.setTrans_id(trans_id);
				transMainVO.setExe_status("TC001502");
				transMainVO.setLogin_id(login_id);
				
				if ("source".equals(con_start_gbn)) {
					transMainVO.setConnector_type("source");
					
					//1. 같은 토픽을 가진것이 있으면 본인것만 삭제
					transService.updateTransExe(transMainVO);
				}else {
					transMainVO.setConnector_type("target");
					
					transService.updateTransTargetExe(transMainVO);
				}
				
				//login_id
				transMainVO.setAct_type("S");				//비활성화
				transMainVO.setAct_exe_type("TC004001");	//manual
				transMainVO.setExe_rslt_cd("TC001501");

				transService.insertTransActstateCngInfo(transMainVO);

				outputObj.put(ProtocolID.DX_EX_CODE, strDxExCode);
				outputObj.put(ProtocolID.RESULT_CODE, strSuccessCode);
				outputObj.put(ProtocolID.ERR_CODE, strErrCode);
				outputObj.put(ProtocolID.ERR_MSG, strErrMsg);
				outputObj.put(ProtocolID.RESULT_DATA, retVal);
				
				sendBuff = outputObj.toString().getBytes();
				send(4, sendBuff);
			} else {
				outputObj.put(ProtocolID.DX_EX_CODE, strDxExCode);
				outputObj.put(ProtocolID.RESULT_CODE, "-1");
				outputObj.put(ProtocolID.ERR_CODE, strErrCode);
				outputObj.put(ProtocolID.ERR_MSG, "no_deps");
				outputObj.put(ProtocolID.RESULT_DATA, "no_deps");
				
				sendBuff = outputObj.toString().getBytes();
				send(4, sendBuff);
				
			}
		} catch (Exception e) {
			errLogger.error("DxT039 {} ", e.toString());
			
			outputObj.put(ProtocolID.DX_EX_CODE, TranCodeType.DxT039);
			outputObj.put(ProtocolID.RESULT_CODE, "1");
			outputObj.put(ProtocolID.ERR_CODE, TranCodeType.DxT039);
			outputObj.put(ProtocolID.ERR_MSG, "DxT039 Error [" + e.toString() + "]");
			
			sendBuff = outputObj.toString().getBytes();
			send(4, sendBuff);
			
		} finally {
			
			outputObj = null;
			sendBuff = null;
		}	

	}

	/* 전송테이블 정보 수정 */
	public String updateTranExrtTrgList(TransVO transVO) throws Exception {
		socketLogger.info("DxT039.updateTranExrtTrgList : ");
		
		context = new ClassPathXmlApplicationContext(new String[] { "context-tcontrol.xml" });
		TransServiceImpl transService = (TransServiceImpl) context.getBean("TransService");
		
		String result = "success";
		String tb_nm = "";
		try {
			TransVO searchTransVO = new TransVO();
			searchTransVO.setTrans_id(transVO.getTrans_id());

			List<TransVO> tblTableList = transService.selectTranExrtTrgList(searchTransVO); // 전송관리 테이블 조회
			List<TransVO> topicTableList = transService.selectTranIdTopicList(searchTransVO); // topic 테이블 조회

			if (tblTableList.size() > 0 && topicTableList.size() > 0) {
				for(int i=0; i<tblTableList.size(); i++){
					String[] exrt_trg_tb_nm_arr = tblTableList.get(i).getExrt_trg_tb_nm().split(",");
					
					for(int j=0; j<exrt_trg_tb_nm_arr.length; j++){
						for(int h=0; h<topicTableList.size(); h++){
							tb_nm = "";
							if (exrt_trg_tb_nm_arr[j].equals(topicTableList.get(h).getTopic_nm())) {
								tb_nm += "";
							} else {
								tb_nm += exrt_trg_tb_nm_arr[j];
								
								if (j != topicTableList.size() -1) {
									tb_nm += ",";
								}
							}
						}
					}

					socketLogger.info("DxT039.tb_nmtb_nmtb_nmtb_nmtb_nm : " + tb_nm);
					TransVO insTransVO = new TransVO();
					insTransVO.setTrans_exrt_trg_tb_id(tblTableList.get(i).getTrans_exrt_trg_tb_id());
					insTransVO.setExrt_trg_tb_nm(tb_nm);
					
					transService.updateTranExrtTrgInfo(insTransVO);
				}
			}

			result = "success";
		} catch (Exception e) {
			result = "failed";
			
			errLogger.error("topic 수정 중 오류가 발생했습니다. {}", e.toString());
			e.printStackTrace();
		}
		
		return result;
	}
	
	public static String shellCmd(String command) throws Exception {
		//ps -ef| grep bottledwater |grep test25 | awk '{print $2}'
		String strResult = "";
		Runtime runtime = Runtime.getRuntime();
		Process process = runtime.exec(new String[]{"/bin/sh", "-c", command});

		return strResult;
	}

	/**
	* delete slot
	* @param strDxExCode
	* @param jObj
	* @param strSlotName
	* @throws Exception
	*/
	public void deleteSlot(String strDxExCode, JSONObject jObj, String strSlotName) throws Exception {
		byte[] sendBuff = null;
		String strErrCode = "";
		String strErrMsg = "";
		String strSuccessCode = "0";
			
		JSONObject objSERVER_INFO = (JSONObject) jObj.get(ProtocolID.SERVER_INFO);
			
		SqlSessionFactory sqlSessionFactory = null;

		sqlSessionFactory = SqlSessionManager.getInstance();
			
		String poolName = "" + objSERVER_INFO.get(ProtocolID.SERVER_IP) + "_" + objSERVER_INFO.get(ProtocolID.DATABASE_NAME) + "_" + objSERVER_INFO.get(ProtocolID.SERVER_PORT);
			
		Connection connDB = null;
		SqlSession sessDB = null;

		JSONObject outputObj = new JSONObject();
	
		try {
			SocketExt.setupDriverPool(objSERVER_INFO, poolName);

			try {
				//DB 컨넥션을 가져온다.
				connDB = DriverManager.getConnection("jdbc:apache:commons:dbcp:" + poolName);
				sessDB = sqlSessionFactory.openSession(connDB);
			} catch(Exception e) {
				strErrCode += ErrCodeMng.Err001;
				strErrMsg += ErrCodeMng.Err001_Msg + " " + e.toString();
				strSuccessCode = "1";
			}

			HashMap hp = new HashMap();
			hp.put("SLOT_NAME", strSlotName);

			sessDB.selectList("app.selectDelSlot", hp);

			sessDB.close();
			connDB.close();

			hp = null;
		} catch (Exception e) {
			errLogger.error("DxT013 {} ", e.toString());

			outputObj.put(ProtocolID.DX_EX_CODE, TranCodeType.DxT013);
			outputObj.put(ProtocolID.RESULT_CODE, "1");
			outputObj.put(ProtocolID.ERR_CODE, TranCodeType.DxT013);
			outputObj.put(ProtocolID.ERR_MSG, "DxT002 Error [" + e.toString() + "]");

			sendBuff = outputObj.toString().getBytes();
			send(4, sendBuff);	
		} finally {
			if(sessDB !=null) sessDB.close();
			if(connDB !=null) connDB.close();
				
			outputObj = null;
			sendBuff = null;
		}
	}
}