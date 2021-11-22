package com.k4m.dx.tcontrol.db.repository.service;

import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.k4m.dx.tcontrol.db.repository.dao.TransDAO;
import com.k4m.dx.tcontrol.db.repository.vo.TransVO;
import com.k4m.dx.tcontrol.util.RunCommandExec;
import com.k4m.dx.tcontrol.util.TransRunCommandExec;

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

@Service("TransService")
public class TransServiceImpl implements TransService{

	private Logger socketLogger = LoggerFactory.getLogger("socketLogger");
	
	@Resource(name = "TransDAO")
	private TransDAO transDAO;

	/* trans 기본사항 조회  */
	public TransVO selectTransComSettingInfo(TransVO vo)  throws Exception {
		return (TransVO) transDAO.selectTransComSettingInfo(vo);
	}	

	/* table pk 조회  */
	public List<TransVO> selectTablePkInfo(TransVO vo) throws Exception {
		return transDAO.selectTablePkInfo(vo);
	}

	/* 소스테이블 connect 실행 결과 수정  */
	public void updateTransExe(TransVO transVO) throws Exception{
		transDAO.updateTransExe(transVO);
	}

	/* 타겟테이블 connect 실행 결과 수정  */
	public void updateTransTargetExe(TransVO transVO) throws Exception{
		transDAO.updateTransTargetExe(transVO);
	}

	/* 토픽등록  */
	public void insertTransTopic(TransVO transVO)  throws Exception{
		transDAO.insertTransTopic(transVO);
	}

	/* tran id 별 topic 리스트 조회 */
	public List<TransVO> selectTranIdTopicList(TransVO vo) throws Exception {
		return transDAO.selectTranIdTopicList(vo);
	}

	/* topic list 삭제 */
	public void deleteTransTopic(TransVO vo)  throws Exception{
		if (vo != null) {
			transDAO.deleteTransTopic(vo);
		}
	}

	/* topic 상세 카운트 조회 */
	public List<TransVO> selectTranIdTopicTotCnt(TransVO vo) throws Exception {
		return transDAO.selectTranIdTopicTotCnt(vo);
	}

	/* source topic list 수정 */
	public void updateTransSrcTopic(TransVO vo)  throws Exception{
		if (vo != null) {
			transDAO.updateTransSrcTopic(vo);
		}
	}

	/* 소스 전송관리 테이블 조회 */
	public List<TransVO> selectTranExrtTrgList(TransVO vo) throws Exception {
		return transDAO.selectTranExrtTrgList(vo);
	}

	/* 소스 전송관리 테이블  수정 */
	public void updateTranExrtTrgInfo(TransVO vo)  throws Exception{
		if (vo != null) {
			transDAO.updateTranExrtTrgInfo(vo);
		}
	}

	/* source topic list 수정 */
	public void updateTransTopic(TransVO vo)  throws Exception{
		if (vo != null) {
			transDAO.updateTransTopic(vo);
		}
	}

	/* topic 테이블 조회 - KC_ID */
	public List<TransVO> selectTranscngKcList(TransVO transVO) throws Exception {
		return transDAO.selectTranscngKcList(transVO);
	}

	/* trans 실시간  */
	public String transRealTimeCheck(TransVO searChTransVO) throws Exception {
		String transConListCmd = "";
		String transConYnCmd = "";
		
		String lastNodeCnt = "0";

		try {
			TransVO transVO = new TransVO();
			List<TransVO> KafkaConList = transDAO.selectTransKafkaConList(transVO); // kafka connect list
			
			//kafka 서버 실시간 확인
			if (KafkaConList.size() > 0) {
				for(int i=0; i<KafkaConList.size(); i++){
					TransVO kafkaTransVO = new TransVO();
					kafkaTransVO = KafkaConList.get(i);
					
					String strKcIp = kafkaTransVO.getKc_ip();
					int strKcPort = kafkaTransVO.getKc_port();
					String strExeStatus = kafkaTransVO.getExe_status();
					String strExeStatusIng = "";
					
					transConYnCmd = "curl -H 'Accept:application/json' "+strKcIp+":"+strKcPort+"/"; //kafka 서버 실시간 확인
					
					RunCommandExec rMain = new RunCommandExec(transConYnCmd);
					
					//명령어 실행
					rMain.run();

					try {
						rMain.join();
					} catch (InterruptedException ie) {
						ie.printStackTrace();
					}
					
					String retVal = rMain.call();
					if (retVal.equals("success")) {
						strExeStatusIng = "TC001501";
					} else {
						strExeStatusIng = "TC001502";
					}
					
					//값이 다른 경우 변경
					if (!strExeStatusIng.equals(strExeStatus)) {
						kafkaTransVO.setExe_status(strExeStatusIng);
						transDAO.updateTranConInfInfo(kafkaTransVO); 
						
						//log 추가
						if ("TC001501".equals(strExeStatusIng)) { //활성화
							kafkaTransVO.setAct_type("A");				//활성화
						} else { //비활성화
							kafkaTransVO.setAct_type("S");				//비활성화
						}

						kafkaTransVO.setAct_exe_type("TC004002");	//auto
						kafkaTransVO.setExe_rslt_cd("TC001501");
						kafkaTransVO.setLogin_id("system");

						transDAO.insertTransKafkaActstateCngInfo(kafkaTransVO);
					}

					if (!strExeStatusIng.equals("TC001502")) { //실행 중일 경우 connect 목록 확인
/*						transConListCmd = "curl -H 'Accept:application/json' "+strKcIp+":"+strKcPort+"/connectors/";
						
						RunCommandExec rListMain = new RunCommandExec(transConListCmd);
						
						//명령어 실행
						rListMain.run();
						
						try {
							rListMain.join();
						} catch (InterruptedException ie) {
							ie.printStackTrace();
						}
						
						String retMainVal = rListMain.call();
						String strResultMessgeMainList = rListMain.getMessage();
						socketLogger.info("#####retMainValretMainVal : " + retMainVal);
						socketLogger.info("#####strResultMessgeMainstrResultMessgeMainstrResultMessgeMainstrResultMessgeMain : " + strResultMessgeMainList);*/
						/*
						if (retMainVal.equals("success")) {
							if (strResultMessgeMainList != null && !"[]".equals(strResultMessgeMainList)) { //값이 있는 경우
								List<TransVO> transCngTotList = transDAO.selectTransCngTotList(transVO); // 소스, 타겟 connect 전체 list

								if (transCngTotList.size() > 0) {
									for(int j=0; j < transCngTotList.size(); j++){
										//connect 존재여부
										if(strResultMessgeMainList.contains(transCngTotList.get(j).getConnect_nm())) { //connect 존재 여부 확인
											//실행 스크립트
											if ("TC001502".equals(transCngTotList.get(j).getExe_status())) {
												connectRealUpdate(transCngTotList.get(j), "TC001501");
											}
										} else {
											//종료 스크립트
											if ("TC001501".equals(transCngTotList.get(j).getExe_status())) {
												connectRealUpdate(transCngTotList.get(j), "TC001502");
											}

										}
									}
								}
							}
						}*/

					}
				}
			}
		} catch (Exception ie) {
			ie.printStackTrace();
		}

		return lastNodeCnt;
	}

	/* trans 실시간  update */
	public void connectRealUpdate(TransVO updateTransVO, String exeStatus) throws Exception {
		
		int trans_id = updateTransVO.getTrans_id();

		//구분
		String con_start_gbn = updateTransVO.getCon_gbn();
		String trans_com_id = updateTransVO.getTrans_com_id();
		String connect_nm = updateTransVO.getConnect_nm();

		try {
			TransVO transVO = new TransVO();
			transVO.setTrans_id(trans_id);
			transVO.setLogin_id("system");
			
			String topicNm = "";
			String exrt_trg_tb_nm = "";
			String soucreTransformYN = "N";
			String conectStopGbn = "";
			String[] exrt_trg_tb_nm_array = null; //테이블 목록 배열

			TransVO commonInfo = null;
			
			List<TransVO> transExrttrgTableList = transDAO.selectTransExrttrgMappList(transVO); // 전송가능 테이블 조회

			if (exeStatus.equals("TC001501")) { //실행중
				if ("SOURCE".equals(con_start_gbn)) {
					transVO.setExe_status("TC001501");
					
					if (transExrttrgTableList.size() > 0) {
						for(int i=0; i<transExrttrgTableList.size(); i++){ //전송가능 테이블 수만큼 실행
							if (transExrttrgTableList.get(i).getExrt_trg_tb_nm() != null) {
								exrt_trg_tb_nm = transExrttrgTableList.get(i).getExrt_trg_tb_nm();
								exrt_trg_tb_nm_array = exrt_trg_tb_nm.split(",");
								
								//기존 토픽리스트 조회 후 데이터 가 있는 경우
								List<TransVO> topicTableList = transDAO.selectTranIdTopicList(transVO); // topic 테이블 조회
	
								if (exrt_trg_tb_nm_array != null) {
									String tb_nm = exrt_trg_tb_nm_array[0];
									int overLabCnt = 0;
	
									transVO.setTrans_com_id(trans_com_id);
									commonInfo = transDAO.selectTransComSettingInfo(transVO); //기본사항 조회
	
									String transforms_yn = commonInfo.getTransforms_yn();
									if (transforms_yn != null && "Y".equals(transforms_yn)) {
										soucreTransformYN = "Y";
									}
									
									if ("Y".equals(soucreTransformYN)) { //table 이름만 topic명
										topicNm = tb_nm.trim().substring(tb_nm.trim().lastIndexOf(".") + 1 , tb_nm.trim().length());
									} else {
										topicNm = connect_nm + "." + tb_nm;
									}
									transVO.setTopic_nm(topicNm);
	
									if (topicTableList.size() > 0) {
										for(int j=0;j < topicTableList.size();j++) {
											if (topicTableList.get(j).getTopic_nm().equals(topicNm)) {
												overLabCnt = overLabCnt + 1;
											}
										}
										
										if (overLabCnt > 0) {
											transVO.setSrc_topic_use_yn("Y");
											transVO.setWrite_use_yn("Y");
											
											//topic 추가 로 kafka 생성
											String insResult = insertKafkaRealTopic(transVO);
											
											if ("success".equals(insResult)) {
												transVO.setKc_id(topicTableList.get(0).getKc_id());

												//topic 테이블 수정
												transDAO.updateTransTopic(transVO);
											}
											
										} else {	
											//topic 추가 로 kafka 생성
											String insResult = insertKafkaRealTopic(transVO);
											
											if ("success".equals(insResult)) {
												transVO.setKc_id(topicTableList.get(0).getKc_id());
												
												//topic 테이블 등록
												transDAO.insertTransTopic(transVO);
											}
										}
									} else {
										List<TransVO> kcIpList = transDAO.selectTranscngKcList(transVO); // topic 테이블 조회
										
										transVO.setKc_ip(kcIpList.get(0).getKc_ip());
										transVO.setKc_id(kcIpList.get(0).getKc_id());
										
										String insResult = insertKafkaRealTopic(transVO);
										
										if ("success".equals(insResult)) {
											//topic 테이블 등록
											transDAO.insertTransTopic(transVO);
										}
									}
								}
							}
						}
					}
					
					//이전  topic 삭제
					transVO.setWrite_use_yn("N");
					transVO.setConnector_type("source");
					
					transDAO.deleteTransTopic(transVO);
		
					//전송관리 테이블 수정
					transDAO.updateTransExe(transVO);
					
					
				} else { //타겟
					transVO.setConnector_type("target");
					
					transDAO.updateTransTargetExe(transVO);
				}

				//log 추가
				transVO.setAct_type("A");				//활성화
				transVO.setAct_exe_type("TC004002");	//auto
				transVO.setExe_rslt_cd("TC001501");

				transDAO.insertTransActstateCngInfo(transVO);
			} else {
				if ("SOURCE".equals(con_start_gbn)) { //소스시스템
					List<TransVO> kcIpList = transDAO.selectTranscngKcList(transVO); // topic 테이블 조회

					if (kcIpList.size() > 0) {
						transVO.setKc_id(kcIpList.get(0).getKc_id());
					}
					
					List<TransVO> topicTableList = transDAO.selectTranIdTopicTotCnt(transVO); // topic count 조회

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
				
				if ("total".equals(conectStopGbn) || "2deps".equals(conectStopGbn) || "4deps".equals(conectStopGbn) || "no_deps".equals(conectStopGbn)) {
					if ("total".equals(conectStopGbn) || "2deps".equals(conectStopGbn) || "4deps".equals(conectStopGbn)) {
						transVO.setExe_status("TC001502");
						transVO.setSrc_topic_use_yn("N");
						transVO.setWrite_use_yn("N");

						//topic 테이블 수정
						updateTransTopicTbl(transVO);

						if ("total".equals(conectStopGbn) || "4deps".equals(conectStopGbn)) {
							//topic 삭제
							deleteRealTransTopic(transVO);
						}
					}

					TransVO transMainVO = new TransVO();
					transMainVO.setTrans_id(trans_id);
					transMainVO.setExe_status("TC001502");
					
					if ("SOURCE".equals(con_start_gbn)) { //소스시스템
						//1. 같은 토픽을 가진것이 있으면 본인것만 삭제
						transDAO.updateTransExe(transMainVO);
					}else {
						transDAO.updateTransTargetExe(transMainVO);
					}
				}
				

				//log 추가
				transVO.setAct_type("S");				//비활성화
				transVO.setAct_exe_type("TC004002");	//auto
				transVO.setExe_rslt_cd("TC001501");

				transDAO.insertTransActstateCngInfo(transVO);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/* topic 테이블 수정 */
	public String updateTransTopicTbl(TransVO transVO) throws Exception {
		socketLogger.info("TransServiceImpl.updateTransTopicTbl : ");

		String result = "success";

		try {
			TransVO searchTransVO = new TransVO();
			searchTransVO.setTrans_id(transVO.getTrans_id());
			searchTransVO.setSrc_topic_use_yn(transVO.getSrc_topic_use_yn());
			searchTransVO.setWrite_use_yn(transVO.getWrite_use_yn());

			transDAO.updateTransSrcTopic(searchTransVO);

			result = "success";
		} catch (Exception e) {
			result = "failed";

			e.printStackTrace();
		}
		
		return result;
	}

	/* topic 삭제 */
	public String deleteRealTransTopic(TransVO transVO) throws Exception {
		socketLogger.info("TransServiceImpl.deleteRealTransTopic : ");

		String result = "success";
		socketLogger.info("TransServiceImpl.deleteRealTransTopic.888888888888888888888888234234234234888kc_ip : " + transVO.getTrans_id());
		try {
			int iTrans_id = transVO.getTrans_id();
			
			TransVO searchTransVO = new TransVO();
			searchTransVO.setTrans_id(iTrans_id);
			socketLogger.info("searchTransVOsearchTransVOsearchTransVO : " + searchTransVO.getTrans_id());
			List<TransVO> topicTableList = transDAO.selectTranIdTopicList(searchTransVO); // topic 테이블 조회
			
			if (topicTableList.size() > 0) {
				for(int i=0; i<topicTableList.size(); i++){
					String kc_ip = topicTableList.get(i).getKc_ip();
					String topic_nm = topicTableList.get(i).getTopic_nm();
					String resultTopic = "N";

					//topic 존재 여부 확인
					//////////////////////////////////////////////////////////////////////////////////////////////////////
					String stCmdSearch ="bin/kafka-topics.sh --list --zookeeper " + kc_ip + ":2181 --topic " + topic_nm;
					
socketLogger.info("TransServiceImpl.deleteRealTransTopic.888888888888888888888888888kc_ip : " + kc_ip);
socketLogger.info("TransServiceImpl.deleteRealTransTopic.888888888888888888888888888stCmdSearch : " + stCmdSearch);

					TransRunCommandExec searchR = new TransRunCommandExec(stCmdSearch);
/*					TransRunMultiCommandExec searchR = new TransRunMultiCommandExec(stCmdSearch, kc_ip, "");*/

					//명령어 실행
					searchR.run();
					
					try {
						searchR.join();
					} catch (InterruptedException ie) {
						ie.printStackTrace();
					}
					
					String retSearchVal = searchR.call();
					String strResultSearchMessge = searchR.getMessage();
					
					if (retSearchVal.equals("success")) {	
						if (!strResultSearchMessge.isEmpty()) {
							resultTopic = "Y";
						} else {
							resultTopic = "N";
						}
					} else {
						resultTopic = "N";
					}
					
					//////////////////////////////////////////////////////////////////////////////////////////////////////
					
					if ("Y".equals(resultTopic)) {
						String strCmd = "bin/kafka-topics.sh --delete --zookeeper " + kc_ip + ":2181 --topic " + topic_nm;
						
socketLogger.info("TransServiceImpl.deleteRealTransTopic.topicTableList7777777777777777777777777777777kc_ip : " + kc_ip);
socketLogger.info("TransServiceImpl.deleteRealTransTopic.topicTableList7777777777777777777777777777777strCmd : " + strCmd);
			
						TransRunCommandExec r = new TransRunCommandExec(strCmd);
/*						TransRunMultiCommandExec r = new TransRunMultiCommandExec(strCmd, kc_ip, "");*/

						//명령어 실행
						r.run();

						try {
							r.join();
						} catch (InterruptedException ie) {
							ie.printStackTrace();
						}
						
						String retVal = r.call();

						if (retVal.equals("success")) {	
							result = "success";
						} else {
							result = "failed";
						}
					}
				}
				
				return result;
			}

			result = "success";
		} catch (Exception e) {
			result = "failed";
			e.printStackTrace();
		}
		
		return result;
	}

	/* kafka 등록 시 topic 삭제 */
	public String deleteTransKakfkaTopic(TransVO transVO) throws Exception {
		String result = "success";

		try {
			TransVO searchTransVO = new TransVO();
			searchTransVO.setTrans_id(transVO.getTrans_id());
			searchTransVO.setWrite_use_yn_val(transVO.getWrite_use_yn());

			List<TransVO> topicTableList = transDAO.selectTranIdTopicList(searchTransVO); // topic 테이블 조회
			
			if (topicTableList.size() > 0) {
				for(int i=0; i<topicTableList.size(); i++){
					String kc_ip = topicTableList.get(i).getKc_ip();
					String topic_nm = topicTableList.get(i).getTopic_nm();
					String resultTopic = "N";

					//topic 존재 여부 확인
					//////////////////////////////////////////////////////////////////////////////////////////////////////
					String stCmdSearch ="bin/kafka-topics.sh --list --zookeeper " + kc_ip + ":2181 --topic " + topic_nm;
					
socketLogger.info("TransServiceImpl.deleteTransKakfkaTopic.topicTableList1111111111111111kc_ip : " + kc_ip);
socketLogger.info("TransServiceImpl.deleteTransKakfkaTopic.topicTableList1111111111111111stCmdSearch : " + stCmdSearch);
					TransRunCommandExec searchR = new TransRunCommandExec(stCmdSearch);
					/*TransRunMultiCommandExec searchR = new TransRunMultiCommandExec(stCmdSearch, kc_ip, "");*/

					//명령어 실행
					searchR.run();
					
					try {
						searchR.join();
					} catch (InterruptedException ie) {
						ie.printStackTrace();
					}
					
					String retSearchVal = searchR.call();
					String strResultSearchMessge = searchR.getMessage();
					
					if (retSearchVal.equals("success")) {	
						if (!strResultSearchMessge.isEmpty()) { //값이 있으면 Y
							resultTopic = "Y";
						} else {
							resultTopic = "N"; // 없으면 N
						}
					} else {
						resultTopic = "N";
					}
					
					//////////////////////////////////////////////////////////////////////////////////////////////////////
					
					//topic이 있는 경우 삭제
					if ("Y".equals(resultTopic)) {
						String strCmd = "bin/kafka-topics.sh --delete --zookeeper " + kc_ip + ":2181 --topic " + topic_nm;

socketLogger.info("TransServiceImpl.deleteTransKakfkaTopic.topicTableList22222222222222222222kc_ip : " + kc_ip);
socketLogger.info("TransServiceImpl.deleteTransKakfkaTopic.topicTableList22222222222222222222strCmd : " + strCmd);
						
						TransRunCommandExec r = new TransRunCommandExec(strCmd);
/*						TransRunMultiCommandExec r = new TransRunMultiCommandExec(strCmd, kc_ip, "");*/

						//명령어 실행
						r.run();

						try {
							r.join();
						} catch (InterruptedException ie) {
							ie.printStackTrace();
						}
						
						String retVal = r.call();

						if (retVal.equals("success")) {	
							result = "success";
						} else {
							result = "failed";
						}
					}
				}
				
				return result;
			}

			result = "success";
		} catch (Exception e) {
			result = "failed";
			e.printStackTrace();
		}
		
		return result;
	}

	/* kafka connect 동록 시 topic 실시간 등록 */
	public String insertKafkaRealTopic(TransVO transVO) throws Exception {
		String result = "success";

		try {
			TransVO searchTransVO = new TransVO();
			searchTransVO.setTrans_id(transVO.getTrans_id());

			String kc_ip = transVO.getKc_ip();
			String topic_nm = transVO.getTopic_nm();			

			//topic 존재 여부 확인
			//////////////////////////////////////////////////////////////////////////////////////////////////////
			String stCmdSearch ="bin/kafka-topics.sh --list --zookeeper " + kc_ip + ":2181 --topic " + topic_nm;

socketLogger.info("TransServiceImpl.deleteTransKakfkaTopic.topicTableList333333333333333333333333kc_ip : " + kc_ip);
socketLogger.info("TransServiceImpl.deleteTransKakfkaTopic.topicTableList333333333333333333333333stCmdSearch : " + stCmdSearch);
						
			TransRunCommandExec searchR = new TransRunCommandExec(stCmdSearch);
			/*TransRunMultiCommandExec searchR = new TransRunMultiCommandExec(stCmdSearch, kc_ip, "");*/

			//명령어 실행
			searchR.run();

			try {
				searchR.join();
			} catch (InterruptedException ie) {
				ie.printStackTrace();
			}

			String retSearchVal = searchR.call();
			String strResultSearchMessge = searchR.getMessage();
			String resultTopic = "N";
socketLogger.info("TransServiceImpl.deleteTransKakfkaTopic.4444444444444444444444444444444444444444444444444444444444444retSearchValretSearchVal : " + retSearchVal);
socketLogger.info("TransServiceImpl.deleteTransKakfkaTopic.4444444444444444444444444444444444444444444444444444444444444strResultSearchMessgestrResultSearchMessge : " + strResultSearchMessge);
socketLogger.info("TransServiceImpl.deleteTransKakfkaTopic.4444444444444444444444444444444444444444444444444444444444444retSearchValretSearchVal : " + retSearchVal);
			if (retSearchVal.equals("success")) {
				if (!strResultSearchMessge.isEmpty()) {
					resultTopic = "Y";
				} else {
					resultTopic = "N";
				}

				//////////////////////////////////////////////////////////////////////////////////////////////////////
				socketLogger.info("##### resultTopicresultTopic : " + resultTopic);
				//topic 이 없는 경우만 생성
				if ("N".equals(resultTopic)) {
					String strInsCmd = "bin/kafka-topics.sh --create --zookeeper " + kc_ip + ":2181 --replication-factor 1 --partitions 1 --topic " + topic_nm;
					
					socketLogger.info("##### strInsCmdstrInsCmdstrInsCmd : " + strInsCmd);

socketLogger.info("TransServiceImpl.deleteTransKakfkaTopic.4444444444444444444444444444444444444444444444444444444444444kc_ip : " + kc_ip);
socketLogger.info("TransServiceImpl.deleteTransKakfkaTopic.4444444444444444444444444444444444444444444444444444444444444strInsCmd : " + strInsCmd);

/*					TransRunMultiCommandExec r = new TransRunMultiCommandExec(strInsCmd, kc_ip, "");*/
					TransRunCommandExec r = new TransRunCommandExec(strInsCmd);

					//명령어 실행
					r.run();

					try {
						r.join();
					} catch (InterruptedException ie) {
						ie.printStackTrace();
					}
						
					String retVal = r.call();

					if (retVal.equals("success")) {	
						result = "success";
					} else {
						result = "failed";
					}
						
					return result;
				}
			} else {
				result = "failed";
				return result;
			}

			result = "success";
		} catch (Exception e) {
			result = "failed";
			e.printStackTrace();
		}
		
		return result;
	}
	

	/* kafka connect 동록 시 topic 실시간 등록 */
	public void insertTransActstateCngInfo(TransVO transVO) throws Exception {
		transDAO.insertTransActstateCngInfo(transVO);
	}
	
	/* kafka connect 재시작시 이력 등록 */
	public void insertTransKafkaActstateCngInfo(TransVO transVO) throws Exception {
		transDAO.insertTransKafkaActstateCngInfo(transVO);
	}

	/* topic 중복체크 */
	public int selectTranTopicIdInsChk(TransVO transVO) throws Exception {
		return transDAO.selectTranTopicIdInsChk(transVO);
	}

}