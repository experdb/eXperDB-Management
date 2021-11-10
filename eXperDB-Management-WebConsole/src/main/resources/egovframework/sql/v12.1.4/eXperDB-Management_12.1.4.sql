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

ALTER TABLE T_TRANSCNG_I ADD COLUMN connect_type varchar(20) NOT NULL DEFAULT 'TC004301'::character varying;
COMMENT ON COLUMN experdb_management.T_TRANSCNG_I.connect_type IS '커넥트_타입' ; 

ALTER TABLE T_TRANSCNG_TARGET_I ADD regi_id numeric(18) NULL;
COMMENT ON COLUMN experdb_management.t_transcng_target_i.regi_id IS 'SchemaRegistry_ID';

ALTER TABLE T_TRANSCNG_TARGET_I ADD COLUMN topic_type varchar(20) NOT NULL DEFAULT 'TC004401'::character varying;
COMMENT ON COLUMN experdb_management.T_TRANSCNG_TARGET_I.topic_type IS '토픽_타입'; 

INSERT INTO T_SYSGRP_C(GRP_CD, GRP_CD_NM, GRP_CD_EXP, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0043', '커넥터타입', 'CDC 커넥터 타입', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSGRP_C(GRP_CD, GRP_CD_NM, GRP_CD_EXP, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0044', '토픽타입', 'CDC 토픽 타입', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());

INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0043', 'TC004301', 'Debezium', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0043', 'TC004302', 'Confluent', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0044', 'TC004401', 'Normal', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0044', 'TC004402', 'Avro', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());

ALTER TABLE T_TRANS_TOPIC_I ADD COLUMN regi_id numeric(18) NULL;
COMMENT ON COLUMN experdb_management.T_TRANS_TOPIC_I.regi_id IS 'schema_regi_ID'; 

ALTER TABLE t_trans_exrttrg_mapp ADD COLUMN regi_id numeric(18) NULL;
COMMENT ON COLUMN experdb_management.t_trans_exrttrg_mapp.regi_id IS 'schema_regi_ID'; 
