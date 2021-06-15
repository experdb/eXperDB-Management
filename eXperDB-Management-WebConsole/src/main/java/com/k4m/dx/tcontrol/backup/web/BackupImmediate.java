package com.k4m.dx.tcontrol.backup.web;

import java.util.List;
import java.util.Map;

import com.k4m.dx.tcontrol.admin.dbserverManager.service.DbServerVO;

public class BackupImmediate {


	
	String rmanBackupMakeCmd(List<Map<String, Object>> resultWork, DbServerVO dbServerVO) {
		String rmanCmd = "pg_rman backup ";

		//DBMS정보 추출
		String dbmsInfo = fn_dbmsInfo(dbServerVO);
		rmanCmd += dbmsInfo;
		
		//데이터베이스 클러스터의 절대경로
		rmanCmd += " --pgdata="+resultWork.get(0).get("data_pth").toString();
		
		//백업 카탈로그의 절대경로
		rmanCmd += " --backup-path="+resultWork.get(0).get("bck_pth").toString();
		
		//백업모드
		if(resultWork.get(0).get("bck_opt_cd").toString().equals("TC000301")){
			rmanCmd += " --backup-mode=full";
		}else if(resultWork.get(0).get("bck_opt_cd").toString().equals("TC000302")){
			rmanCmd += " --backup-mode=incremental";
		}else{
			rmanCmd += " --backup-mode=archive";
		}
		
		rmanCmd += " -A $PGALOG";
		 
		if(resultWork.get(0).get("log_file_bck_yn").toString().equals("Y")){
			rmanCmd += " --with-serverlog";
		}
		
		if(resultWork.get(0).get("cps_yn").toString().equals("Y")){
			rmanCmd += " --compress-data";
		}
				
		//아카이브로그 백업시 FULL백업 보관일수, FULL백업 유지갯수 명령어 호출 X
		
		if(resultWork.get(0).get("bck_opt_cd").toString().equals("TC000303")){
			if(Integer.parseInt(resultWork.get(0).get("acv_file_mtncnt").toString()) != 0){
				rmanCmd += " --keep-arclog-files="+resultWork.get(0).get("acv_file_mtncnt");
			}if(Integer.parseInt(resultWork.get(0).get("acv_file_stgdt").toString()) != 0){
				rmanCmd += " --keep-arclog-days="+resultWork.get(0).get("acv_file_stgdt");
			}if(Integer.parseInt(resultWork.get(0).get("log_file_mtn_ecnt").toString()) != 0){
				rmanCmd += " --keep-srvlog-files="+resultWork.get(0).get("log_file_mtn_ecnt");
			}if(Integer.parseInt(resultWork.get(0).get("log_file_stg_dcnt").toString()) != 0){
				rmanCmd += " --keep-srvlog-days="+resultWork.get(0).get("log_file_stg_dcnt");
			}
		}else{
			if(Integer.parseInt(resultWork.get(0).get("bck_mtn_ecnt").toString()) != 0){
				rmanCmd += " --keep-data-generations="+resultWork.get(0).get("bck_mtn_ecnt");
			}if(Integer.parseInt(resultWork.get(0).get("file_stg_dcnt").toString()) != 0){
				rmanCmd += " --keep-data-days="+resultWork.get(0).get("file_stg_dcnt");
			}if(Integer.parseInt(resultWork.get(0).get("acv_file_mtncnt").toString()) != 0){
				rmanCmd += " --keep-arclog-files="+resultWork.get(0).get("acv_file_mtncnt");
			}if(Integer.parseInt(resultWork.get(0).get("acv_file_stgdt").toString()) != 0){
				rmanCmd += " --keep-arclog-days="+resultWork.get(0).get("acv_file_stgdt");
			}if(Integer.parseInt(resultWork.get(0).get("log_file_mtn_ecnt").toString()) != 0){
				rmanCmd += " --keep-srvlog-files="+resultWork.get(0).get("log_file_mtn_ecnt");
			}if(Integer.parseInt(resultWork.get(0).get("log_file_stg_dcnt").toString()) != 0){
				rmanCmd += " --keep-srvlog-days="+resultWork.get(0).get("log_file_stg_dcnt");
			}
		}

		//rmanCmd += " >> "+resultWork.get(i).get("log_file_pth")+"/"+resultWork.get(i).get("wrk_nm").toString().replaceAll(" ", "")+".log 2>&1";
		return rmanCmd;	
	}
	
	
	
	/**
	 * 1. Connection Option 명령어 생성
	 * 2. 기본옵션 명령어 생성
	 * 3. 부가옵션 명령어 생성  
	 * 4. 오브젝트옵션 명령어 생성
	 * @param addObject 
	 * @param i 
	 * @param h 
	 * @param resultDbconn2 
	 * @param result
	 * @return
	 */
	@SuppressWarnings("unused")
	 String dumpBackupMakeCmd(DbServerVO dbServerVO, List<Map<String, Object>> resultWork, List<Map<String, Object>> addOption, List<Map<String, Object>> addObject,  String bck_fileNm) {

		String strCmd = "pg_dump ";
		String strLast = "";
		
		try {		
			//DBMS정보 추출
			String DBMS =  fn_dbmsInfo(dbServerVO);
			strCmd += DBMS;
			
			//기본옵션 명령어 생성	
			String basicCmd = fn_basicOption(resultWork, bck_fileNm);
			strCmd +=basicCmd;
						
			//부가옵션 명령어 생성
			String addCmd = fn_addOption(addOption);	
			strCmd += addCmd;
					
			//오브젝트옵션 명령어 생성
			if(addObject.size() != 0){
				String objCmd = fn_objOption(addObject);	
				strCmd += objCmd;
			}					
			strCmd += " "+resultWork.get(0).get("db_nm")+"  -f "+resultWork.get(0).get("save_pth")+"/"+bck_fileNm;
		} catch (Exception e) {			
			e.printStackTrace();
		}		
		return strCmd;
	}
	
	
	private String fn_basicOption(List<Map<String, Object>> resultWork, String bck_fileNm) {
		String strBasic = "";
        
		if(resultWork.get(0).get("file_fmt_cd_nm") != null && resultWork.get(0).get("file_fmt_cd_nm") != ""){
			//파일포멧에 따른 명령어 생성
			strBasic += " --format="+resultWork.get(0).get("file_fmt_cd_nm").toString().toLowerCase();
			//파일포멧이 tar일경우 압축률 명령어 생성
			if(resultWork.get(0).get("file_fmt_cd_nm") == "tar"){
				strBasic += " --compress="+resultWork.get(0).get("cprt").toString().toLowerCase();
			}
		}
		
		//인코딩 방식 명령어 생성
		if(resultWork.get(0).get("incd") != null && resultWork.get(0).get("incd") != ""){
			strBasic +=" --encoding="+resultWork.get(0).get("incd").toString().toLowerCase();
		}		
		
		//rolename 명령어 생성		
		if(resultWork.get(0).get("incd") != null && !resultWork.get(0).get("usr_role_nm").equals("")){
			strBasic +=" --role="+resultWork.get(0).get("usr_role_nm").toString().toLowerCase();
		}		
		return strBasic;
	}
	
	private String fn_addOption(List<Map<String, Object>> addOption) {	
		String strAdd = "";
		
		for(int j =0; j<addOption.size(); j++){
			// Sections
			if(addOption.get(j).get("grp_cd").toString() != null && addOption.get(j).get("grp_cd").toString().equals("TC0006")){
				strAdd +=" --section="+addOption.get(j).get("opt_cd_nm").toString().toLowerCase();
			}
			// Object형태
			if(addOption.get(j).get("grp_cd").toString() != null && addOption.get(j).get("grp_cd").toString().equals("TC0007")){
				// Object형태(Only data)
				if(addOption.get(j).get("opt_cd").toString().equals("TC000701")){
					strAdd +=" --data-only";
				// Object형태(Only Schema)
				}else if (addOption.get(j).get("opt_cd").toString().equals("TC000702")){
					strAdd +=" --schema-only";
				// Object형태(Blobs)
				}else{
					strAdd +=" --blobs";
				}
			}
			// 저장제외항목
			if(addOption.get(j).get("grp_cd").toString() != null && addOption.get(j).get("grp_cd").toString().equals("TC0008")){
				strAdd +=" --no-"+addOption.get(j).get("opt_cd_nm").toString().toLowerCase();
			}
			// 쿼리
			if(addOption.get(j).get("grp_cd").toString() != null && addOption.get(j).get("grp_cd").toString().equals("TC0009")){
				// 쿼리(Use Column Inserts)
				if(addOption.get(j).get("opt_cd").toString().equals("TC000901")){
					strAdd +=" --column-insert";
				// 쿼리(Use Insert Commands)
				}else if (addOption.get(j).get("opt_cd").toString().equals("TC000902")){
					strAdd +=" --attribute-inserts";
				// 쿼리(Include CREATE DATABASE statement)
				}else if(addOption.get(j).get("opt_cd").toString().equals("TC000903")){
					strAdd +=" --create";
				// 쿼리(Include DROP DATABASE statement)
				}else{
					strAdd +=" --clean";
				}
			}
			// Miscellaneous
			if(addOption.get(j).get("grp_cd").toString() != null && addOption.get(j).get("grp_cd").toString().equals("TC0010")){
				// Miscellaneous(With OID(s))
				if(addOption.get(j).get("opt_cd").toString().equals("TC001001")){
					strAdd +=" --oids";
				// Miscellaneous(Verbose messages)
				}else if (addOption.get(j).get("opt_cd").toString().equals("TC001002")){
					strAdd +=" --verbose";
				// Miscellaneous(Force double quote on identifiers)
				}else if(addOption.get(j).get("opt_cd").toString().equals("TC001003")){
					strAdd +=" --quote-all-identifiers";
				// Miscellaneous(Use SET SESSION AUTHORIZATION)
				}else{
					strAdd +=" --use-set-session-authorization";
				}
			}
		}
		return strAdd;
	}

	private String fn_objOption(List<Map<String, Object>> addObject) {
		String strObj = "";
		for(int n=0; n<addObject.size(); n++){			
			if(addObject.get(n).get("obj_nm").equals(null) || addObject.get(n).get("obj_nm").equals("")){
				strObj+=" -n "+addObject.get(n).get("scm_nm").toString().toLowerCase();						
			}else{
				strObj+=" -t "+addObject.get(n).get("scm_nm").toString().toLowerCase()+"."+addObject.get(n).get("obj_nm").toString().toLowerCase();
			}			
		}
		return strObj;
	}
	
	private String fn_dbmsInfo(DbServerVO dbServerVO) {
		String DBMS = "";
		//1.1 연결할 데이터베이스의 이름 지정
		//DBMS += "--dbname="+resultDbconn.get(h).get("dft_db_nm");
		//1.2 호스트 이름 지정
		//1.3 서버가 연결을 청취하는 TCP포트 설정
		DBMS += " --port="+dbServerVO.getPortno();
		//1.4 연결할 사용자이름
		DBMS += " --username="+dbServerVO.getSvr_spr_usr_id();
		DBMS += " --no-password";	

		return DBMS;
	}
}
