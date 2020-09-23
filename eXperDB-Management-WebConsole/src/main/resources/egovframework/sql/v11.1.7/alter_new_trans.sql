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
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_C D_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0001', 'DX-T0149_01', '전송관리 타켓DBMS 등록', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());

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
