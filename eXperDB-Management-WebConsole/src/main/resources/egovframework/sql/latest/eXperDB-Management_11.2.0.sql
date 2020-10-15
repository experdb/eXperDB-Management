ALTER TABLE T_USRDBSVRAUT_I ADD COLUMN transSetting_aut_yn varchar(1) ;
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0032', 'TC003201', 'DDL', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0032', 'TC003202', 'MIGRATION', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());


update T_SYSDTL_C set sys_cd_nm ='UTF-8' where sys_cd='TC003101';
update T_SYSDTL_C set sys_cd_nm ='EUC-KR' where sys_cd='TC003102';

INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0001', 'DX-T0125_03', '스크립트설정 스케줄조회', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0001', 'DX-T0026_03', 'Online 백업 상세조회 팝업', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0001', 'DX-T0026_04', 'Dump 백업 상세조회 팝업', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());

INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0001', 'DX-T0133_02', '복원이력 긴급/시점 복원이력 조회', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0001', 'DX-T0133_03', '복원이력 Dump 복원이력 조회', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0001', 'DX-T0133_04', '복원이력 로그 조회', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());

ALTER TABLE T_DUMP_RESTORE ADD COLUMN blobs_only_yn bpchar(1) NOT NULL DEFAULT 'N'::bpchar;
ALTER TABLE T_DUMP_RESTORE ADD COLUMN no_unlogged_table_data_yn bpchar(1) NOT NULL DEFAULT 'N'::bpchar;
ALTER TABLE T_DUMP_RESTORE ADD COLUMN use_column_inserts_yn bpchar(1) NOT NULL DEFAULT 'N'::bpchar;
ALTER TABLE T_DUMP_RESTORE ADD COLUMN use_column_commands_yn bpchar(1) NOT NULL DEFAULT 'N'::bpchar;
ALTER TABLE T_DUMP_RESTORE ADD COLUMN oids_yn bpchar(1) NOT NULL DEFAULT 'N'::bpchar;
ALTER TABLE T_DUMP_RESTORE ADD COLUMN identifier_quotes_apply_yn bpchar(1) NOT NULL DEFAULT 'N'::bpchar;

UPDATE T_SYSDTL_C SET SYS_CD_NM = '서버접근설정 화면' WHERE GRP_CD = 'TC0001' AND SYS_CD = 'DX-T0027';
UPDATE T_SYSDTL_C SET SYS_CD_NM = '서버접근설정 삭제' WHERE GRP_CD = 'TC0001' AND SYS_CD = 'DX-T0027_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM = '서버접근설정 적용' WHERE GRP_CD = 'TC0001' AND SYS_CD = 'DX-T0027_02';
UPDATE T_SYSDTL_C SET SYS_CD_NM = '서버접근설정 등록 팝업' WHERE GRP_CD = 'TC0001' AND SYS_CD = 'DX-T0028';
UPDATE T_SYSDTL_C SET SYS_CD_NM = '서버접근설정 등록' WHERE GRP_CD = 'TC0001' AND SYS_CD = 'DX-T0028_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM = '서버접근설정 수정 팝업' WHERE GRP_CD = 'TC0001' AND SYS_CD = 'DX-T0029';
UPDATE T_SYSDTL_C SET SYS_CD_NM = '서버접근설정 수정' WHERE GRP_CD = 'TC0001' AND SYS_CD = 'DX-T0029_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM = '설정변경이력 화면' WHERE GRP_CD = 'TC0001' AND SYS_CD = 'DX-T0030';
UPDATE T_SYSDTL_C SET SYS_CD_NM = '설정변경이력 조회' WHERE GRP_CD = 'TC0001' AND SYS_CD = 'DX-T0030_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM = '설정변경이력 복원' WHERE GRP_CD = 'TC0001' AND SYS_CD = 'DX-T0030_02';




COMMENT ON COLUMN t_usrdbsvraut_i.script_cng_aut_yn IS '배치_설정_권한_여부';
COMMENT ON COLUMN t_usrdbsvraut_i.script_his_aut_yn IS '배치_이력_권한_여부';

UPDATE T_SYSDTL_C SET SYS_CD_NM = '배치설정 화면' WHERE GRP_CD = 'TC0001' AND SYS_CD = 'DX-T0125';
UPDATE T_SYSDTL_C SET SYS_CD_NM = '배치설정 조회' WHERE GRP_CD = 'TC0001' AND SYS_CD = 'DX-T0125_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM = '배치설정 삭제' WHERE GRP_CD = 'TC0001' AND SYS_CD = 'DX-T0125_02';
UPDATE T_SYSDTL_C SET SYS_CD_NM = '배치설정 등록 팝업' WHERE GRP_CD = 'TC0001' AND SYS_CD = 'DX-T0126';
UPDATE T_SYSDTL_C SET SYS_CD_NM = '배치설정 등록' WHERE GRP_CD = 'TC0001' AND SYS_CD = 'DX-T0126_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM = '배치설정 수정 팝업' WHERE GRP_CD = 'TC0001' AND SYS_CD = 'DX-T0127';
UPDATE T_SYSDTL_C SET SYS_CD_NM = '배치설정 수정' WHERE GRP_CD = 'TC0001' AND SYS_CD = 'DX-T0127_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM = '배치이력 화면' WHERE GRP_CD = 'TC0001' AND SYS_CD = 'DX-T0128';
UPDATE T_SYSDTL_C SET SYS_CD_NM = '배치이력 조회' WHERE GRP_CD = 'TC0001' AND SYS_CD = 'DX-T0128_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM = '배치' WHERE GRP_CD = 'TC0019' AND SYS_CD = 'TC001902';
UPDATE T_SYSDTL_C SET SYS_CD_NM = '배치설정 스케줄조회' WHERE GRP_CD = 'TC0001' AND SYS_CD = 'DX-T0125_03';


-- TRAN DMBS 관리 --
---------------------------------------------------------------------------
CREATE TABLE experdb_management.t_trans_sys_inf (
	trans_sys_id numeric(18) NOT NULL, -- trans_시스템_id
	trans_sys_nm varchar(50) NOT NULL, -- trans_시스템_명
	dbms_dscd varchar(8) NOT NULL, -- dbms_구분코드
	ipadr varchar(30) NOT NULL, -- ip주소
	dtb_nm varchar(200) NOT NULL, -- 데이터베이스_명
	spr_usr_id varchar(30) NOT NULL, -- 슈퍼_사용자_id
	portno numeric(5) NOT NULL, -- 포트번호
	scm_nm varchar(50) NULL, -- 스키마_명
	pwd varchar(100) NULL, -- 비밀번호
	frst_regr_id varchar(30) NULL, -- 최초_등록자_id
	frst_reg_dtm timestamp NOT NULL DEFAULT clock_timestamp(), -- 최초_등록_일시
	lst_mdfr_id varchar(30) NULL, -- 최종_수정자_id
	lst_mdf_dtm timestamp NOT NULL DEFAULT clock_timestamp(), -- 최종_수정_일시
	CONSTRAINT pk_t_trans_sys_inf PRIMARY KEY (trans_sys_id)
);
COMMENT ON TABLE experdb_management.t_trans_sys_inf IS 'tran_시스템_정보';

-- Column comments

COMMENT ON COLUMN experdb_management.t_trans_sys_inf.trans_sys_id IS 'trans_시스템_id';
COMMENT ON COLUMN experdb_management.t_trans_sys_inf.trans_sys_nm IS 'trans_시스템_명';
COMMENT ON COLUMN experdb_management.t_trans_sys_inf.dbms_dscd IS 'dbms_구분코드';
COMMENT ON COLUMN experdb_management.t_trans_sys_inf.ipadr IS 'ip주소';
COMMENT ON COLUMN experdb_management.t_trans_sys_inf.dtb_nm IS '데이터베이스_명';
COMMENT ON COLUMN experdb_management.t_trans_sys_inf.spr_usr_id IS '슈퍼_사용자_id';
COMMENT ON COLUMN experdb_management.t_trans_sys_inf.portno IS '포트번호';
COMMENT ON COLUMN experdb_management.t_trans_sys_inf.scm_nm IS '스키마_명';
COMMENT ON COLUMN experdb_management.t_trans_sys_inf.pwd IS '비밀번호';
COMMENT ON COLUMN experdb_management.t_trans_sys_inf.frst_regr_id IS '최초_등록자_id';
COMMENT ON COLUMN experdb_management.t_trans_sys_inf.frst_reg_dtm IS '최초_등록_일시';
COMMENT ON COLUMN experdb_management.t_trans_sys_inf.lst_mdfr_id IS '최종_수정자_id';
COMMENT ON COLUMN experdb_management.t_trans_sys_inf.lst_mdf_dtm IS '최종_수정_일시';

ALTER TABLE experdb_management.t_trans_sys_inf OWNER TO experdb;
GRANT ALL ON TABLE experdb_management.t_trans_sys_inf TO experdb;
-------------------------------------------------------------------------------------

-- TRAN target 시스템 전송설정 --
-------------------------------------------------------------------------------------
CREATE TABLE experdb_management.t_transcng_target_i (
	trans_id numeric(18) NOT NULL DEFAULT 1, -- 전송_ID
	kc_ip varchar(50) NULL, -- 커넥터_아이피
	kc_port numeric(5) NOT NULL DEFAULT 0, -- 커넥터_포트
	connect_nm varchar(50) NULL, -- 커넥트명
	db_svr_id numeric(18) NOT NULL DEFAULT 1, -- 디비_서버_아이디
	trans_trg_sys_id numeric(18) NOT NULL, -- trans_소스_시스템_id
	snapshot_mode varchar(50) NULL, -- 스냅샷모드
	trans_exrt_trg_tb_id numeric NULL, -- 전송 포함_아이디
	trans_exrt_exct_tb_id numeric NULL, -- 전송_제외_아이디
	exe_status varchar(20) NOT NULL DEFAULT 'TC001502'::character varying,
	frst_regr_id varchar(30) NULL, -- 최초_등록자_ID
	frst_reg_dtm timestamp NOT NULL DEFAULT clock_timestamp(), -- 최초_등록_일시
	lst_mdfr_id varchar(30) NULL, -- 최종_수정자_ID
	lst_mdf_dtm timestamp NOT NULL DEFAULT clock_timestamp(), -- 최종_수정_일시
    kc_id numeric(18) NULL,
	CONSTRAINT pk_t_transcng_target_i PRIMARY KEY (trans_id, trans_trg_sys_id),
	CONSTRAINT fk_t_transcng_target_i_01 FOREIGN KEY (trans_exrt_trg_tb_id) REFERENCES t_trans_exrttrg_mapp(trans_exrt_trg_tb_id),
	CONSTRAINT fk_t_transcng_target_i_02 FOREIGN KEY (trans_exrt_exct_tb_id) REFERENCES t_trans_exrtexct_mapp(trans_exrt_exct_tb_id)
);
COMMENT ON TABLE experdb_management.t_transcng_target_i IS '타겟시스템 전송설정테이블';

-- Column comments

COMMENT ON COLUMN experdb_management.t_transcng_target_i.trans_id IS '전송_ID';
COMMENT ON COLUMN experdb_management.t_transcng_target_i.kc_ip IS '커넥터_아이피';
COMMENT ON COLUMN experdb_management.t_transcng_target_i.kc_port IS '커넥터_포트';
COMMENT ON COLUMN experdb_management.t_transcng_target_i.connect_nm IS '커넥트명';
COMMENT ON COLUMN experdb_management.t_transcng_target_i.db_svr_id IS '디비_서버_아이디';
COMMENT ON COLUMN experdb_management.t_transcng_target_i.trans_trg_sys_id IS 'trans_소스_시스템_id';
COMMENT ON COLUMN experdb_management.t_transcng_target_i.snapshot_mode IS '스냅샷모드';
COMMENT ON COLUMN experdb_management.t_transcng_target_i.trans_exrt_trg_tb_id IS '전송 포함_아이디';
COMMENT ON COLUMN experdb_management.t_transcng_target_i.trans_exrt_exct_tb_id IS '전송_제외_아이디';
COMMENT ON COLUMN experdb_management.t_transcng_target_i.frst_regr_id IS '최초_등록자_ID';
COMMENT ON COLUMN experdb_management.t_transcng_target_i.frst_reg_dtm IS '최초_등록_일시';
COMMENT ON COLUMN experdb_management.t_transcng_target_i.lst_mdfr_id IS '최종_수정자_ID';
COMMENT ON COLUMN experdb_management.t_transcng_target_i.lst_mdf_dtm IS '최종_수정_일시';

-- Permissions

ALTER TABLE experdb_management.t_transcng_target_i OWNER TO experdb;
GRANT ALL ON TABLE experdb_management.t_transcng_target_i TO experdb;
-------------------------------------------------------------------------------------

create sequence q_trans_sys_inf_01;
create sequence q_transcng_target_i_01;

INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0001', 'DX-T0147', '전송관리 타켓DBMS 설정 화면', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0001', 'DX-T0147_01', '전송관리 타켓DBMS 설정 조회', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0001', 'DX-T0147_02', '전송관리 타켓DBMS 삭제', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());

INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0001', 'DX-T0148', '전송관리 화면', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0001', 'DX-T0148_01', '전송관리 조회', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0001', 'DX-T0148_02', '전송관리 삭제', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());

INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0001', 'DX-T0149', '전송관리 타켓DBMS 등록 화면', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0001', 'DX-T0149_01', '전송관리 타켓DBMS 등록', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());

INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0001', 'DX-T0150', '전송관리 타켓DBMS 수정 화면', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0001', 'DX-T0150_01', '전송관리 타켓DBMS 수정', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());

INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0001', 'DX-T0151', '전송관리 등록 화면', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0001', 'DX-T0151_01', '전송관리 등록', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0001', 'DX-T0151_02', '전송관리 삭제', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());

INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0001', 'DX-T0152', '전송관리 수정 화면', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0001', 'DX-T0152_01', '전송관리 수정', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());

INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0001', 'DX-T0153', 'kafka conecnt 설정 화면', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0001', 'DX-T0153_01', 'kafka conecnt 설정 조회', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());

INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0001', 'DX-T0154', 'kafka conecnt 등록 화면', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0001', 'DX-T0154_01', 'kafka conecnt 등록', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());

INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0001', 'DX-T0155', 'kafka conecnt 수정 화면', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0001', 'DX-T0155_01', 'kafka conecnt 수정', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());

INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0001', 'DX-T0156', '전송관리 기본 설정 등록 화면', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0001', 'DX-T0156_01', '전송관리 기본 설정 등록', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());


CREATE TABLE experdb_management.t_trans_con_inf (
	kc_id numeric(18) NOT NULL, -- kafka_connect_id
	kc_nm varchar(200) NOT NULL, -- kafka_connect_명
	kc_ip varchar(50) NOT NULL, -- kafka_connect_ip
	kc_port numeric(5) NOT NULL, -- kafka_connect_port
	exe_status varchar(20) NOT NULL DEFAULT 'TC001502'::character varying,
	frst_regr_id varchar(30) NULL, -- 최초_등록자_id
	frst_reg_dtm timestamp NOT NULL DEFAULT clock_timestamp(), -- 최초_등록_일시
	lst_mdfr_id varchar(30) NULL, -- 최종_수정자_id
	lst_mdf_dtm timestamp NOT NULL DEFAULT clock_timestamp(), -- 최종_수정_일시
	CONSTRAINT pk_t_trans_con_inf PRIMARY KEY (kc_id)
);
COMMENT ON TABLE experdb_management.t_trans_con_inf IS 'tran_시스템_정보';

-- Column comments

COMMENT ON COLUMN experdb_management.t_trans_con_inf.kc_id IS 'kafka_connect_id';
COMMENT ON COLUMN experdb_management.t_trans_con_inf.kc_nm IS 'kafka_connect_명';
COMMENT ON COLUMN experdb_management.t_trans_con_inf.kc_ip IS 'kafka_connect_ip';
COMMENT ON COLUMN experdb_management.t_trans_con_inf.kc_port IS 'kafka_connect_port';
COMMENT ON COLUMN experdb_management.t_trans_con_inf.exe_status IS '실행상태';
COMMENT ON COLUMN experdb_management.t_trans_con_inf.frst_regr_id IS '최초_등록자_id';
COMMENT ON COLUMN experdb_management.t_trans_con_inf.frst_reg_dtm IS '최초_등록_일시';
COMMENT ON COLUMN experdb_management.t_trans_con_inf.lst_mdfr_id IS '최종_수정자_id';
COMMENT ON COLUMN experdb_management.t_trans_con_inf.lst_mdf_dtm IS '최종_수정_일시';

-- Permissions

ALTER TABLE experdb_management.t_trans_con_inf OWNER TO experdb;
GRANT ALL ON TABLE experdb_management.t_trans_con_inf TO experdb;

create sequence q_trans_con_inf_01;


ALTER TABLE experdb_management.T_USRDBSVRAUT_I ADD trans_dbms_cng_aut_yn bpchar(1) NULL;
COMMENT ON COLUMN experdb_management.T_USRDBSVRAUT_I.trans_dbms_cng_aut_yn IS '타겟DBMS_설정_권한_여부';

ALTER TABLE experdb_management.T_USRDBSVRAUT_I ADD trans_con_cng_aut_yn bpchar(1) NULL;
COMMENT ON COLUMN experdb_management.T_USRDBSVRAUT_I.trans_con_cng_aut_yn IS 'connecter_설정_권한_여부';


CREATE TABLE experdb_management.t_transcomcng_i (
	trans_com_id numeric(18) NOT NULL, -- trans_공통_아이디
	plugin_name varchar(100) NULL,
	heartbeat_interval_ms varchar(10) NULL,
	heartbeat_action_query varchar NULL,
	max_batch_size varchar(10) NULL,
	max_queue_size varchar(10) NULL,
	offset_flush_interval_ms varchar(10) NULL,
	offset_flush_timeout_ms varchar(10) NULL,
	auto_create varchar(10) NULL,
	transforms_yn varchar(1) DEFAULT 'N',
	frst_regr_id varchar(30) NULL, -- 최초_등록자_id
	frst_reg_dtm timestamp NOT NULL DEFAULT clock_timestamp(), -- 최초_등록_일시
	lst_mdfr_id varchar(30) NULL, -- 최종_수정자_id
	lst_mdf_dtm timestamp NOT NULL DEFAULT clock_timestamp(), -- 최종_수정_일시
	CONSTRAINT pk_t_transcomcng_i PRIMARY KEY (trans_com_id)
);
COMMENT ON TABLE experdb_management.t_transcomcng_i IS 'tran_공통_설정_정보';

ALTER TABLE experdb_management.t_transcomcng_i OWNER TO experdb;
GRANT ALL ON TABLE experdb_management.t_transcomcng_i TO experdb;

INSERT INTO experdb_management.t_transcomcng_i
            (
              trans_com_id, 
              plugin_name, 
              heartbeat_interval_ms, 
              heartbeat_action_query, 
              max_batch_size, 
              max_queue_size, 
              offset_flush_interval_ms, 
              offset_flush_timeout_ms, 
              auto_create, 
              transforms_yn,
              frst_regr_id, 
              frst_reg_dtm, 
              lst_mdfr_id, 
              lst_mdf_dtm)
      VALUES( 1, 
              'wal2json', 
              '10000', 
              'insert into dmsadb.dmsadb.dmsa_link_mntn_log (select 1,1); delete from dmsadb.dmsadb.dmsa_link_mntn_log;', 
              '16384', 
              '65536', 
              '1000',
              '10000', 
              'true',
              'N', 
              'system', 
              clock_timestamp(), 
              'system', 
              clock_timestamp());

ALTER TABLE experdb_management.T_TRANSCNG_I ADD kc_id numeric(18) NULL;
COMMENT ON COLUMN experdb_management.T_TRANSCNG_I.kc_id IS 'kafka connect id';

ALTER TABLE t_scale_g ADD CONSTRAINT pk_t_scale_g PRIMARY KEY(scale_wrk_sn, wrk_id, db_svr_id, scale_type, process_id);
ALTER TABLE t_scale_i ADD CONSTRAINT pk_t_scale_i PRIMARY KEY(wrk_id, db_svr_id, scale_type, policy_type, execute_type);
ALTER TABLE t_scaleawssvr_i ADD CONSTRAINT pk_t_scaleawssvr_i PRIMARY KEY(db_svr_id, db_svr_ipadr_id);
ALTER TABLE t_scaleloadlog_g ADD CONSTRAINT pk_t_scaleloadlog_g PRIMARY KEY(wrk_sn, db_svr_id);
ALTER TABLE t_scaleoccur_g ADD CONSTRAINT pk_t_scaleoccur_g PRIMARY KEY(wrk_sn, db_svr_id, scale_type, policy_type, execute_type);



alter table t_usr_i add column sessionkey varchar(50) not null default 'none';
alter table t_usr_i add column sessionlimit timestamp;


COMMENT ON COLUMN t_usr_i.sessionkey IS 'session_key';
COMMENT ON COLUMN t_usr_i.sessionlimit IS 'session_일자';

----scale-------------------------------------------------------------------------------------------------
ALTER TABLE experdb_management.t_scaleAwssvr_i ADD useyn bpchar(1) NOT NULL DEFAULT 'Y'::bpchar;
COMMENT ON COLUMN experdb_management.t_scaleAwssvr_i.useyn IS '사용여부';

ALTER TABLE experdb_management.t_scale_i ADD useyn bpchar(1) NOT NULL DEFAULT 'Y'::bpchar;
COMMENT ON COLUMN experdb_management.t_scale_i.useyn IS '사용여부';
-----------------------------------------------------------------------------------------------------------

----trans-------------------------------------------------------------------------------------------------
ALTER TABLE experdb_management.t_transcomcng_i ADD trans_com_cng_nm varchar(50) NULL;
COMMENT ON COLUMN experdb_management.t_transcomcng_i.trans_com_cng_nm IS '기본설정 명';

INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0001', 'DX-T0157', '전송관리 기본사항 설정 화면', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0001', 'DX-T0157_01', '전송관리 기본사항 설정 조회', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0001', 'DX-T0157_02', '전송관리 기본사항 삭제', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());

INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0001', 'DX-T0158', '전송관리 기본사항 수정 화면', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0001', 'DX-T0158_01', '전송관리 기본사항 수정', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());

update t_transcomcng_i
  set trans_com_cng_nm = 'default'
 where trans_com_id = 1
;
 
CREATE SEQUENCE q_t_transcomcng_i_01 START 2;

ALTER TABLE experdb_management.T_TRANSCNG_I ADD trans_com_id numeric(18) NULL;
COMMENT ON COLUMN experdb_management.T_TRANSCNG_I.trans_com_id IS '기본설정 id';
-----------------------------------------------------------------------------------------------------------
