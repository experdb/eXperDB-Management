-- Schema Registry정보 테이블 생성    
   CREATE TABLE t_trans_regi_inf (
	regi_id numeric(18) NOT NULL,
	regi_nm varchar(200) NOT NULL,
	regi_ip varchar(50) NOT NULL,
	regi_port numeric(5) NOT NULL,
	exe_status varchar(20) NOT NULL DEFAULT 'TC001502'::character varying,
	frst_regr_id varchar(30) NULL,
	frst_reg_dtm timestamp NOT NULL DEFAULT clock_timestamp(),
	lst_mdfr_id varchar(30) NULL,
	lst_mdf_dtm timestamp NOT NULL DEFAULT clock_timestamp(),
	CONSTRAINT pk_t_trans_regi_inf PRIMARY KEY (regi_id)
);

COMMENT ON TABLE experdb_management.t_trans_regi_inf IS 'trans_Schema_Registry_정보';

create sequence q_trans_regi_inf_01;


-- COMMENT 변경
COMMENT ON COLUMN experdb_management.t_trans_regi_inf.regi_id IS 'schema_regi_ID';
COMMENT ON COLUMN experdb_management.t_trans_regi_inf.regi_nm IS 'schema_regi_명';
COMMENT ON COLUMN experdb_management.t_trans_regi_inf.regi_ip IS 'schema_regi_IP';
COMMENT ON COLUMN experdb_management.t_trans_regi_inf.regi_port IS 'schema_regi_포트';
COMMENT ON COLUMN experdb_management.t_trans_regi_inf.frst_regr_id IS '최초_등록자_ID';
COMMENT ON COLUMN experdb_management.t_trans_regi_inf.frst_reg_dtm IS '최초_등록일';
COMMENT ON COLUMN experdb_management.t_trans_regi_inf.lst_mdfr_id IS '최종_수정자_ID';
COMMENT ON COLUMN experdb_management.t_trans_regi_inf.lst_mdf_dtm IS '최종_수정일';

-- Permissions

ALTER TABLE experdb_management.t_trans_regi_inf OWNER TO experdb;
GRANT ALL ON TABLE experdb_management.t_trans_regi_inf TO experdb;


-- 접근 이력 정보 추가 
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0001', 'DX-T0168', 'Schema Registry 등록 화면', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0001', 'DX-T0168_01', 'Schema Registry 등록', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0001', 'DX-T0169', 'Schema Registry 수정 화면', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0001', 'DX-T0169_01', 'Schema Registry 수정', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0001', 'DX-T0170', 'Schema Registry 삭제', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());

-- Database에 하둡 코드 추가
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0022', 'TC002210', 'Hadoop', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());

-- Schema Registry 기동 상태 변경 이력 
CREATE TABLE experdb_management.t_trans_schem_regi_actstate_cng_g (
	regi_act_exe_sn numeric NOT NULL DEFAULT 1,
	regi_id numeric(18) NOT NULL,
	regi_ip varchar(50) NOT NULL,
	regi_port numeric(5) NOT NULL,
	act_type varchar(1) NOT NULL,
	act_exe_type varchar(20) NOT NULL,
	wrk_dtm timestamp NOT NULL DEFAULT clock_timestamp(),
	exe_rslt_cd varchar(20) NOT NULL DEFAULT 'TC001501'::character varying,
	frst_regr_id varchar(30) NULL,
	frst_reg_dtm timestamp NOT NULL DEFAULT clock_timestamp(),
	lst_mdfr_id varchar(30) NULL,
	lst_mdf_dtm timestamp NOT NULL DEFAULT clock_timestamp(),
	CONSTRAINT pk_t_trans_schem_regi_actstate_cng_g PRIMARY KEY (regi_act_exe_sn, regi_id, act_type)
);

create sequence q_t_trans_schem_regi_actstate_cng_g_01;

-- COMMENT 변경
COMMENT ON COLUMN experdb_management.t_trans_schem_regi_actstate_cng_g.regi_act_exe_sn IS 'schema_regi_실행_상태_일련변호';
COMMENT ON COLUMN experdb_management.t_trans_schem_regi_actstate_cng_g.act_type IS '기동_유형';
COMMENT ON COLUMN experdb_management.t_trans_schem_regi_actstate_cng_g.act_exe_type IS '기동_실행_유형';
COMMENT ON COLUMN experdb_management.t_trans_schem_regi_actstate_cng_g.wrk_dtm IS '작업_시간';
COMMENT ON COLUMN experdb_management.t_trans_schem_regi_actstate_cng_g.exe_rslt_cd IS '실행_결과_코드';
COMMENT ON COLUMN experdb_management.t_trans_schem_regi_actstate_cng_g.regi_id IS 'schema_regi_ID';
COMMENT ON COLUMN experdb_management.t_trans_schem_regi_actstate_cng_g.regi_ip IS 'schema_regi_IP';
COMMENT ON COLUMN experdb_management.t_trans_schem_regi_actstate_cng_g.regi_port IS 'schema_regi_포트';
COMMENT ON COLUMN experdb_management.t_trans_schem_regi_actstate_cng_g.frst_regr_id IS '최초_등록자_ID';
COMMENT ON COLUMN experdb_management.t_trans_schem_regi_actstate_cng_g.frst_reg_dtm IS '최초_등록일';
COMMENT ON COLUMN experdb_management.t_trans_schem_regi_actstate_cng_g.lst_mdfr_id IS '최종_수정자_ID';
COMMENT ON COLUMN experdb_management.t_trans_schem_regi_actstate_cng_g.lst_mdf_dtm IS '최종_수정일';

-- T_TRANSCNG_I 테이블 regi_id, kc_id, connect_type 추가
ALTER TABLE T_TRANSCNG_I ADD COLUMN regi_id numeric(18) NULL;
COMMENT ON COLUMN experdb_management.T_TRANSCNG_I.regi_id IS 'schema_regi_ID'; 

ALTER TABLE T_TRANSCNG_I ADD COLUMN connect_type varchar(20) NOT NULL DEFAULT 'TC004501'::character varying;
COMMENT ON COLUMN experdb_management.T_TRANSCNG_I.connect_type IS '커넥트_타입' ; 

ALTER TABLE T_TRANSCNG_TARGET_I ADD regi_id numeric(18) NULL;
COMMENT ON COLUMN experdb_management.t_transcng_target_i.regi_id IS 'SchemaRegistry_ID';

ALTER TABLE T_TRANSCNG_TARGET_I ADD COLUMN topic_type varchar(20) NOT NULL DEFAULT 'TC004401'::character varying;
COMMENT ON COLUMN experdb_management.T_TRANSCNG_TARGET_I.topic_type IS '토픽_타입'; 

INSERT INTO T_SYSGRP_C(GRP_CD, GRP_CD_NM, GRP_CD_EXP, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0045', '커넥터타입', 'CDC 커넥터 타입', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSGRP_C(GRP_CD, GRP_CD_NM, GRP_CD_EXP, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0044', '토픽타입', 'CDC 토픽 타입', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());

INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0045', 'TC004501', 'Debezium', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0045', 'TC004502', 'Confluent', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0044', 'TC004401', 'Normal', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0044', 'TC004402', 'Avro', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());

ALTER TABLE T_TRANS_TOPIC_I ADD COLUMN regi_id numeric(18) NULL;
COMMENT ON COLUMN experdb_management.T_TRANS_TOPIC_I.regi_id IS 'schema_regi_ID'; 

ALTER TABLE t_trans_exrttrg_mapp ADD COLUMN regi_id numeric(18) NULL;
COMMENT ON COLUMN experdb_management.t_trans_exrttrg_mapp.regi_id IS 'schema_regi_ID'; 


-- DB2PG Monitoring Table Create

CREATE TABLE t_db2pg_exework (
	wrk_nm varchar(100) NULL,
	src_dbms_dscd varchar(20) NULL,
	src_ip varchar(100) NULL,
	src_database varchar(50) NULL,
	tar_ip varchar(100) NULL,
	tar_database varchar(50) null,
	total_table_cnt  numeric NULL,
	rs_cnt numeric null default 0
);

COMMENT ON COLUMN experdb_management.t_db2pg_exework.wrk_nm IS '작업명';
COMMENT ON COLUMN experdb_management.t_db2pg_exework.src_dbms_dscd IS '소스DBMS종류';
COMMENT ON COLUMN experdb_management.t_db2pg_exework.src_ip IS '소스아이피';
COMMENT ON COLUMN experdb_management.t_db2pg_exework.src_database IS '소스데이터베이스';
COMMENT ON COLUMN experdb_management.t_db2pg_exework.tar_ip IS '타겟아이피';
COMMENT ON COLUMN experdb_management.t_db2pg_exework.tar_database IS '타겟데이터베이스';
COMMENT ON COLUMN experdb_management.t_db2pg_exework.total_table_cnt IS '총테테이블건수';
COMMENT ON COLUMN experdb_management.t_db2pg_exework.rs_cnt IS '이관된테이블건수';


CREATE TABLE t_db2pg_monitoring (
	table_nm varchar(100) NULL,
	wrk_nm varchar(100) NULL,
	total_cnt numeric NULL,
	mig_cnt numeric NULL,
	start_time varchar(100) NULL DEFAULT NULL::character varying,
	end_time varchar(100) NULL DEFAULT NULL::character varying,
	elapsed_time varchar(20) NULL DEFAULT NULL::character varying,
	status varchar(30) NULL DEFAULT NULL::character varying
);

COMMENT ON COLUMN experdb_management.t_db2pg_monitoring.table_nm IS '이행테이블';
COMMENT ON COLUMN experdb_management.t_db2pg_monitoring.wrk_nm IS '작업명';
COMMENT ON COLUMN experdb_management.t_db2pg_monitoring.total_cnt IS '테이블데이터총건수';
COMMENT ON COLUMN experdb_management.t_db2pg_monitoring.mig_cnt IS '테이블이행건수';
COMMENT ON COLUMN experdb_management.t_db2pg_monitoring.start_time IS '시작시간';
COMMENT ON COLUMN experdb_management.t_db2pg_monitoring.end_time IS '종료시간';
COMMENT ON COLUMN experdb_management.t_db2pg_monitoring.elapsed_time IS '소요시간';
COMMENT ON COLUMN experdb_management.t_db2pg_monitoring.status IS '상태';

INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0001', 'DX-T0166', '백업 모니터링 화면', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());

-- 아이피 컬럼 크기변경
alter table t_agtcndt_i alter column ipadr type varchar(100);
alter table t_db2pg_sys_inf alter column ipadr type varchar(100);
alter table t_dbsvripadr_i alter column ipadr type varchar(100);

-- 타겟 dbms 설정 정보에 하둡용 FILE_PATH 컬럼 추가 
ALTER TABLE experdb_management.t_trans_sys_inf ADD file_path varchar(100) NULL;
COMMENT ON COLUMN experdb_management.t_trans_sys_inf.file_path IS '파일 경로';


ALTER TABLE t_trans_topic_i ADD COLUMN kc_id numeric(18) NULL;
COMMENT ON COLUMN experdb_management.t_trans_topic_i.kc_id IS 'kafka_커넥트_ID';

CREATE INDEX IDX_TRANS_TOPIC_I_01 ON T_TRANS_TOPIC_I(KC_ID);

-- CDC 화면 ID 변경
UPDATE T_SYSDTL_C SET SYS_CD_NM = '커넥터 서버 설정 화면', SYS_CD_NM_EN = 'Connector Server Settings Page' WHERE GRP_CD = 'TC0001' AND SYS_CD = 'DX-T0153';
UPDATE T_SYSDTL_C SET SYS_CD_NM = 'Kafka 정보 조회', SYS_CD_NM_EN = 'Kafka Server Information Search' WHERE GRP_CD = 'TC0001' AND SYS_CD = 'DX-T0153_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM = 'Kafka Connect 등록 화면', SYS_CD_NM_EN = 'Kafka Connect Regist Page' WHERE GRP_CD = 'TC0001' AND SYS_CD = 'DX-T0154';
UPDATE T_SYSDTL_C SET SYS_CD_NM = 'Kafka Connect 등록', SYS_CD_NM_EN = 'Kafka Connect Registration' WHERE GRP_CD = 'TC0001' AND SYS_CD = 'DX-T0154_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM = 'Kafka Connect 수정 화면', SYS_CD_NM_EN = 'Kafka Connect Modify Page' WHERE GRP_CD = 'TC0001' AND SYS_CD = 'DX-T0155';
UPDATE T_SYSDTL_C SET SYS_CD_NM = 'Kafka Connect 수정', SYS_CD_NM_EN = 'Kafka Connect Modification' WHERE GRP_CD = 'TC0001' AND SYS_CD = 'DX-T0155_01';

INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM, SYS_CD_NM_EN  ) VALUES('TC0001', 'DX-T0153_02', 'Schema Registry 정보 조회', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp(), 'Schema Registry Information Search');

UPDATE T_SYSDTL_C SET SYS_CD_NM = 'Schema Registry 등록 화면', SYS_CD_NM_EN = 'Schema Registry Regist Page' WHERE GRP_CD = 'TC0001' AND SYS_CD = 'DX-T0168';
UPDATE T_SYSDTL_C SET SYS_CD_NM = 'Schema Registry 등록', SYS_CD_NM_EN = 'Schema Registry Registration' WHERE GRP_CD = 'TC0001' AND SYS_CD = 'DX-T0168_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM = 'Schema Registry 수정 화면', SYS_CD_NM_EN = 'Schema Registry Modify Page' WHERE GRP_CD = 'TC0001' AND SYS_CD = 'DX-T0169';
UPDATE T_SYSDTL_C SET SYS_CD_NM = 'Schema Registry 수정', SYS_CD_NM_EN = 'Schema Registry Modification' WHERE GRP_CD = 'TC0001' AND SYS_CD = 'DX-T0169_01';

DELETE FROM T_SYSDTL_C WHERE GRP_CD = 'TC0001' AND SYS_CD = 'DX-T0170'

INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM, SYS_CD_NM_EN  ) VALUES('TC0001', 'DX-T0153_04', 'Schema Registry 삭제', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp(), 'Schema Registry Delete');
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM, SYS_CD_NM_EN  ) VALUES('TC0001', 'DX-T0153_03', 'Kafka 정보 삭제', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp(), 'Kafka Information Delete');

UPDATE T_SYSDTL_C SET SYS_CD_NM = '데이터전송 타켓DBMS 설정 화면', SYS_CD_NM_EN = 'DataTransfer TargetDBMS Settings Page' WHERE GRP_CD = 'TC0001' AND SYS_CD = 'DX-T0147';
UPDATE T_SYSDTL_C SET SYS_CD_NM = '데이터전송 타켓DBMS 설정 화면', SYS_CD_NM_EN = 'DataTransfer TargetDBMS Settings Search' WHERE GRP_CD = 'TC0001' AND SYS_CD = 'DX-T0147_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM = '데이터전송 타켓DBMS 삭제', SYS_CD_NM_EN = 'DataTransfer TargetDBMS Delete' WHERE GRP_CD = 'TC0001' AND SYS_CD = 'DX-T0147_02';
UPDATE T_SYSDTL_C SET SYS_CD_NM = '데이터전송 타켓DBMS 수정 화면', SYS_CD_NM_EN = 'DataTransfer TargetDBMS Modify Page' WHERE GRP_CD = 'TC0001' AND SYS_CD = 'DX-T0150';
UPDATE T_SYSDTL_C SET SYS_CD_NM = '데이터전송 타켓DBMS 수정', SYS_CD_NM_EN = 'DataTransfer TargetDBMS Modification' WHERE GRP_CD = 'TC0001' AND SYS_CD = 'DX-T0150_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM = '데이터전송 타켓DBMS 등록 화면', SYS_CD_NM_EN = 'DataTransfer TargetDBMS Regist Page' WHERE GRP_CD = 'TC0001' AND SYS_CD = 'DX-T0149';
UPDATE T_SYSDTL_C SET SYS_CD_NM = '데이터전송 타켓DBMS 등록', SYS_CD_NM_EN = 'DataTransfer TargetDBMS Registration' WHERE GRP_CD = 'TC0001' AND SYS_CD = 'DX-T0149_01';

UPDATE T_SYSDTL_C SET SYS_CD_NM = '데이터전송 전송관리 화면', SYS_CD_NM_EN = 'DataTransfer TransManagement Page' WHERE GRP_CD = 'TC0001' AND SYS_CD = 'DX-T0148';
UPDATE T_SYSDTL_C SET SYS_CD_NM = '데이터전송 전송관리 소스시스템 조회', SYS_CD_NM_EN = 'DataTransfer TransManagement SourceSystem Search' WHERE GRP_CD = 'TC0001' AND SYS_CD = 'DX-T0148_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM = '데이터전송 전송관리 타겟시스템 조회', SYS_CD_NM_EN = 'DataTransfer TransManagement TargetSystem Search' WHERE GRP_CD = 'TC0001' AND SYS_CD = 'DX-T0148_02';

INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM, SYS_CD_NM_EN  ) VALUES('TC0001', 'DX-T0148_03', '데이터전송 전송관리 삭제', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp(), 'DataTransfer TransManagement Delete');
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM, SYS_CD_NM_EN  ) VALUES('TC0001', 'DX-T0148_04', '데이터전송 전송관리 상세보기 팝업', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp(), 'DataTransfer TransManagement Detail Popup');

UPDATE T_SYSDTL_C SET SYS_CD_NM = '데이터전송 전송관리 등록 화면', SYS_CD_NM_EN = 'DataTransfer TransManagement Regist Page' WHERE GRP_CD = 'TC0001' AND SYS_CD = 'DX-T0151';
UPDATE T_SYSDTL_C SET SYS_CD_NM = '데이터전송 소스시스템 전송관리 등록', SYS_CD_NM_EN = 'DataTransfer TransManagement SourceSystem Registration' WHERE GRP_CD = 'TC0001' AND SYS_CD = 'DX-T0151_01';
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM, SYS_CD_NM_EN  ) VALUES('TC0001', 'DX-T0151_03', '데이터전송 전송관리 타겟시스템 등록', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp(), 'DataTransfer TransManagement TargetSystem Registration');

UPDATE T_SYSDTL_C SET SYS_CD_NM = '데이터전송 전송관리 소스시스템 수정 화면', SYS_CD_NM_EN = 'DataTransfer TransManagement SourceSystem Modify Page' WHERE GRP_CD = 'TC0001' AND SYS_CD = 'DX-T0152';
UPDATE T_SYSDTL_C SET SYS_CD_NM = '데이터전송 전송관리 소스시스템 수정', SYS_CD_NM_EN = 'DataTransfer TransManagement SourceSystem Modification' WHERE GRP_CD = 'TC0001' AND SYS_CD = 'DX-T0152_01';
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM, SYS_CD_NM_EN  ) VALUES('TC0001', 'DX-T0152_02', '데이터전송 전송관리 타겟시스템 수정', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp(), 'DataTransfer TransManagement TargetSystem Modification');

INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM, SYS_CD_NM_EN  ) VALUES('TC0001', 'DX-T0175', '데이터전송 전송관리 타겟시스템 수정 화면', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp(), 'DataTransfer TransManagement TargetSystem Modify Page');
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM, SYS_CD_NM_EN  ) VALUES('TC0001', 'DX-T0175_01', '데이터전송 전송관리 타겟시스템 수정', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp(), 'DataTransfer TransManagement TargetSystem Modification');

UPDATE T_SYSDTL_C SET SYS_CD_NM = '데이터전송 전송관리 기본설정 설정 화면', SYS_CD_NM_EN = 'DataTransfer TransManagement DefaultSettings Page' WHERE GRP_CD = 'TC0001' AND SYS_CD = 'DX-T0157';
UPDATE T_SYSDTL_C SET sys_cd_nm = '데이터전송 전송관리 기본설정 설정 조회', SYS_CD_NM_EN = 'DataTransfer TransManagement DefualtSettings Search' WHERE GRP_CD = 'TC0001' AND SYS_CD = 'DX-T0157_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM = '데이터전송 전송관리 기본설정 삭제', SYS_CD_NM_EN = 'DataTransfer TransManagement DefaultSetting Delete' WHERE GRP_CD = 'TC0001' AND SYS_CD = 'DX-T0157_02';

UPDATE T_SYSDTL_C SET SYS_CD_NM = '데이터전송 전송관리 기본설정 등록 화면', SYS_CD_NM_EN = 'DataTransfer TransManagement DefaultSettings Regist Page' WHERE GRP_CD = 'TC0001' AND SYS_CD = 'DX-T0156';
UPDATE T_SYSDTL_C SET SYS_CD_NM = '데이터전송 전송관리 기본설정 등록', SYS_CD_NM_EN = 'DataTransfer TransManagement DefaultSetting Registration' WHERE GRP_CD = 'TC0001' AND SYS_CD = 'DX-T0156_01';

UPDATE T_SYSDTL_C SET SYS_CD_NM = '데이터전송 전송관리 기본설정 수정 화면', SYS_CD_NM_EN = 'DataTransfer TransManagement DefaultSettings Modify Page' WHERE GRP_CD = 'TC0001' AND SYS_CD = 'DX-T0158';
UPDATE T_SYSDTL_C SET SYS_CD_NM = '데이터전송 전송관리 기본설정 수정', SYS_CD_NM_EN = 'DataTransfer TransManagement DefaultSetting Modification' WHERE GRP_CD = 'TC0001' AND SYS_CD = 'DX-T0158_01';

INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM, SYS_CD_NM_EN  ) VALUES('TC0001', 'DX-T0148_05', '데이터전송 전송관리 kafka 상세보기 팝업', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp(), 'DataTransfer TransManagement Kafka Detail Popup');
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM, SYS_CD_NM_EN  ) VALUES('TC0001', 'DX-T0148_06', '데이터전송 전송관리 DBMS 상세보기 팝업', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp(), 'DataTransfer TransManagement DBMS Detail Popup');

INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM, SYS_CD_NM_EN  ) VALUES('TC0001', 'DX-T0171', '데이터전송 모니터링 화면', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp(), 'DataTransfer TransManagement Monitoring Page');
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM, SYS_CD_NM_EN  ) VALUES('TC0001', 'DX-T0172', '데이터전송 모니터링 로그 화면', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp(), 'DataTransfer TransManagement Log Page');
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM, SYS_CD_NM_EN  ) VALUES('TC0001', 'DX-T0172_01', '데이터전송 모니터링 로그 조회', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp(), 'DataTransfer TransManagement Log Search');
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM, SYS_CD_NM_EN  ) VALUES('TC0001', 'DX-T0171_02', '데이터전송 모니터링 Kafka 재시작', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp(), 'DataTransfer TransManagement Kafka restart');

