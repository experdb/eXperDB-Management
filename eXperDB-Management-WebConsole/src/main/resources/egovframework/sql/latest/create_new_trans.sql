INSERT INTO T_SYSGRP_C(GRP_CD, GRP_CD_NM, GRP_CD_EXP, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES( 'TC0036', '스냅샷모드', '데이터전송 스냅샷모드', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());

INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0036', 'TC003601', 'INITIAL', 'Y', 'ADMIN', CLOCK_TIMESTAMP(), 'ADMIN', CLOCK_TIMESTAMP());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0036', 'TC003602', 'ALWAYS', 'N', 'ADMIN', CLOCK_TIMESTAMP(), 'ADMIN', CLOCK_TIMESTAMP());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0036', 'TC003603', 'NEVER', 'Y', 'ADMIN', CLOCK_TIMESTAMP(), 'ADMIN', CLOCK_TIMESTAMP());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0036', 'TC003604', 'INITIAL_ONLY', 'N', 'ADMIN', CLOCK_TIMESTAMP(), 'ADMIN', CLOCK_TIMESTAMP());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0036', 'TC003605', 'EXPORTED', 'N', 'ADMIN', CLOCK_TIMESTAMP(), 'ADMIN', CLOCK_TIMESTAMP());



CREATE TABLE T_TRANS_EXRTEXCT_MAPP (
	TRANS_EXRT_EXCT_TB_ID NUMERIC NOT NULL,
	EXRT_EXCT_TB_NM TEXT NULL,
	EXRT_EXCT_SCM_NM TEXT NULL,
	SCHEMA_TOTAL_CNT NUMERIC NULL,
	TABLE_TOTAL_CNT NUMERIC NULL,
	FRST_REGR_ID VARCHAR(30) NULL,
	FRST_REG_DTM TIMESTAMP NOT NULL,
	CONSTRAINT PK_T_TRANS_EXRTEXCT_MAPP PRIMARY KEY (TRANS_EXRT_EXCT_TB_ID)
);


COMMENT ON TABLE T_TRANS_EXRTEXCT_MAPP IS '전송제외테이블';

 COMMENT ON COLUMN T_TRANS_EXRTEXCT_MAPP.TRANS_EXRT_EXCT_TB_ID IS '전송제외아이디';
 COMMENT ON COLUMN T_TRANS_EXRTEXCT_MAPP.EXRT_EXCT_TB_NM IS '전송제외테이블명';
 COMMENT ON COLUMN T_TRANS_EXRTEXCT_MAPP.EXRT_EXCT_SCM_NM IS '전송제외스키마명';
 COMMENT ON COLUMN T_TRANS_EXRTEXCT_MAPP.SCHEMA_TOTAL_CNT IS '전송제외스키마수';
 COMMENT ON COLUMN T_TRANS_EXRTEXCT_MAPP.TABLE_TOTAL_CNT IS '전송제외테이블수';
 COMMENT ON COLUMN T_TRANS_EXRTEXCT_MAPP.FRST_REGR_ID IS '최초_등록자_ID';
 COMMENT ON COLUMN T_TRANS_EXRTEXCT_MAPP.FRST_REG_DTM IS '최초_등록_일시';


CREATE SEQUENCE Q_T_TRANS_EXRTEXCT_MAPP_01;


CREATE TABLE T_TRANS_EXRTTRG_MAPP (
	TRANS_EXRT_TRG_TB_ID NUMERIC NOT NULL,
	EXRT_TRG_TB_NM TEXT NULL,
	EXRT_TRG_SCM_NM TEXT NULL,
	SCHEMA_TOTAL_CNT NUMERIC NULL,
	TABLE_TOTAL_CNT NUMERIC NULL,
	FRST_REGR_ID VARCHAR(30) NULL,
	FRST_REG_DTM TIMESTAMP NOT NULL,
	CONSTRAINT PK_T_TRANS_EXRTTRG_MAPP PRIMARY KEY (TRANS_EXRT_TRG_TB_ID)
);



COMMENT ON TABLE T_TRANS_EXRTTRG_MAPP IS '전송대상테이블';

 COMMENT ON COLUMN T_TRANS_EXRTTRG_MAPP.TRANS_EXRT_TRG_TB_ID IS '전송대상아이디';
 COMMENT ON COLUMN T_TRANS_EXRTTRG_MAPP.EXRT_TRG_TB_NM IS '전송대상테이블명';
 COMMENT ON COLUMN T_TRANS_EXRTTRG_MAPP.EXRT_TRG_SCM_NM IS '전송대상스키마명';
 COMMENT ON COLUMN T_TRANS_EXRTTRG_MAPP.SCHEMA_TOTAL_CNT IS '전송대상스키마수';
 COMMENT ON COLUMN T_TRANS_EXRTTRG_MAPP.TABLE_TOTAL_CNT IS '전송대상테이블수';
 COMMENT ON COLUMN T_TRANS_EXRTTRG_MAPP.FRST_REGR_ID IS '최초_등록자_ID';
 COMMENT ON COLUMN T_TRANS_EXRTTRG_MAPP.FRST_REG_DTM IS '최초_등록_일시';


CREATE SEQUENCE Q_T_TRANS_EXRTTRG_MAPP_01;


CREATE TABLE T_TRANSCNG_I(
	TRANS_ID           NUMERIC(18) NOT NULL DEFAULT 1,
	KC_IP          VARCHAR(50) NULL,
	KC_PORT           NUMERIC(5) NOT NULL DEFAULT 0,
	CONNECT_NM           VARCHAR(50) NULL,
	SNAPSHOT_MODE         VARCHAR(50) NULL,
	DB_ID         		  NUMERIC(18) NOT NULL DEFAULT 1,
	DB_SVR_ID            NUMERIC(18) NOT NULL DEFAULT 1,	
	TRANS_EXRT_TRG_TB_ID numeric NULL,
	TRANS_EXRT_EXCT_TB_ID numeric NULL,	
	EXE_STATUS VARCHAR(20) NOT NULL DEFAULT 'TC001502',
	FRST_REGR_ID         VARCHAR(30) NULL,
	FRST_REG_DTM         TIMESTAMP NOT NULL DEFAULT CLOCK_TIMESTAMP(),
	LST_MDFR_ID          VARCHAR(30) NULL,
	LST_MDF_DTM          TIMESTAMP NOT NULL DEFAULT CLOCK_TIMESTAMP(),
	CONSTRAINT fk_T_TRANSCNG_I_01 FOREIGN KEY (TRANS_EXRT_TRG_TB_ID) REFERENCES T_TRANS_EXRTTRG_MAPP(TRANS_EXRT_TRG_TB_ID),
	CONSTRAINT fk_T_TRANSCNG_I_02 FOREIGN KEY (TRANS_EXRT_EXCT_TB_ID) REFERENCES T_TRANS_EXRTEXCT_MAPP(TRANS_EXRT_EXCT_TB_ID)
);


ALTER TABLE T_TRANSCNG_I ADD CONSTRAINT PK_T_TRANSCNG_I
PRIMARY KEY (TRANS_ID);


COMMENT ON TABLE T_TRANSCNG_I IS '전송설정테이블';

 COMMENT ON COLUMN T_TRANSCNG_I.TRANS_ID IS '전송_ID';
 COMMENT ON COLUMN T_TRANSCNG_I.KC_IP IS '커넥터_아이피';
 COMMENT ON COLUMN T_TRANSCNG_I.KC_PORT IS '커넥터_포트';
 COMMENT ON COLUMN T_TRANSCNG_I.CONNECT_NM IS '커넥트명';
 COMMENT ON COLUMN T_TRANSCNG_I.SNAPSHOT_MODE IS '스냅샷모드';
 COMMENT ON COLUMN T_TRANSCNG_I.DB_ID IS '디비_아이디';
 COMMENT ON COLUMN T_TRANSCNG_I.DB_SVR_ID IS '디비_서버_아이디';
 COMMENT ON COLUMN T_TRANSCNG_I.TRANS_EXRT_TRG_TB_ID IS '전송 포함_아이디';
 COMMENT ON COLUMN T_TRANSCNG_I.TRANS_EXRT_EXCT_TB_ID IS '전송_제외_아이디';
 COMMENT ON COLUMN T_TRANSCNG_I.FRST_REGR_ID IS '최초_등록자_ID';
 COMMENT ON COLUMN T_TRANSCNG_I.FRST_REG_DTM IS '최초_등록_일시';
 COMMENT ON COLUMN T_TRANSCNG_I.LST_MDFR_ID IS '최종_수정자_ID';
 COMMENT ON COLUMN T_TRANSCNG_I.LST_MDF_DTM IS '최종_수정_일시';

CREATE SEQUENCE Q_T_TRANSCNG_I_01;

INSERT INTO T_SYSGRP_C(GRP_CD, GRP_CD_NM, GRP_CD_EXP, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES( 'TC0037', '압축형태', '데이터전송 압축형태', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());

INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0037', 'TC003701', 'NONE', 'Y', 'ADMIN', CLOCK_TIMESTAMP(), 'ADMIN', CLOCK_TIMESTAMP());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0037', 'TC003702', 'GZIP', 'Y', 'ADMIN', CLOCK_TIMESTAMP(), 'ADMIN', CLOCK_TIMESTAMP());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0037', 'TC003703', 'SNAPPY', 'Y', 'ADMIN', CLOCK_TIMESTAMP(), 'ADMIN', CLOCK_TIMESTAMP());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0037', 'TC003704', 'LZ4', 'Y', 'ADMIN', CLOCK_TIMESTAMP(), 'ADMIN', CLOCK_TIMESTAMP());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0037', 'TC003705', 'ZSTD', 'Y', 'ADMIN', CLOCK_TIMESTAMP(), 'ADMIN', CLOCK_TIMESTAMP());


ALTER TABLE T_TRANSCNG_I ADD COLUMN compression_type varchar(50);
COMMENT ON COLUMN T_TRANSCNG_I.compression_type IS '압축형태';

ALTER TABLE T_TRANSCNG_I ADD COLUMN meta_data varchar(50);
COMMENT ON COLUMN T_TRANSCNG_I.meta_data IS '메타데이터 사용유무';

ALTER TABLE T_USRDBSVRAUT_I ADD COLUMN transSetting_aut_yn varchar(1) ;

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


