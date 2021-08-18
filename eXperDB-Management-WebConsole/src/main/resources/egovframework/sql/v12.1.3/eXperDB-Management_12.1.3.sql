

ALTER TABLE T_PRY_LSN_I ADD COLUMN BAL_YN bpchar(1)  NULL;
COMMENT ON COLUMN experdb_management.T_PRY_LSN_I.BAL_YN IS '로드발란스_사용여부';
ALTER TABLE T_PRY_LSN_I ADD COLUMN BAL_OPT varchar(10)  NULL;
COMMENT ON COLUMN experdb_management.T_PRY_LSN_I.BAL_OPT IS '로드발란스_옵션';

ALTER TABLE experdb_management.t_pry_lsn_i ALTER COLUMN bal_yn SET DEFAULT 'N'::bpchar;

UPDATE T_PRY_LSN_I SET BAL_YN='N', BAL_OPT='';

INSERT INTO t_sysgrp_c
(grp_cd, grp_cd_nm, grp_cd_exp, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
VALUES('TC0043', '로드발란싱 옵션', 'Proxy 로드발란싱 옵션', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO t_sysdtl_c
(grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm, sys_cd_nm_en)
VALUES('TC0043', 'TC004301', 'RoundRobin', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp(), 'roundrobin');
INSERT INTO t_sysdtl_c
(grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm, sys_cd_nm_en)
VALUES('TC0043', 'TC004302', 'LeastConn', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp(), 'leastconn');

-- trans 모니터링 메뉴 추가
ALTER TABLE t_usrdbsvraut_i ADD COLUMN trans_mtr_aut_yn bpchar(1) NULL;
COMMENT ON COLUMN experdb_management.t_usrdbsvraut_i.trans_mtr_aut_yn IS 'connector_모니터링_여부';

COMMENT ON TABLE experdb_management.T_TRANSCNG_I IS '소스시스템 전송설정테이블';
COMMENT ON COLUMN experdb_management.t_transcng_target_i.trans_trg_sys_id IS 'trans_타겟_DBMS_id';

CREATE INDEX IDX_TRANSCNG_I_01 ON T_TRANSCNG_I(DB_SVR_ID, CONNECT_NM);
CREATE INDEX IDX_TRANSCNG_I_02 ON T_TRANSCNG_I(DB_SVR_ID, EXE_STATUS);

CREATE INDEX IDX_TRANSCNG_TARGET_I_01 ON T_TRANSCNG_TARGET_I(DB_SVR_ID, CONNECT_NM);
CREATE INDEX IDX_TRANSCNG_TARGET_I_02 ON T_TRANSCNG_TARGET_I(EXE_STATUS);
CREATE INDEX IDX_TRANSCNG_TARGET_I_03 ON T_TRANSCNG_TARGET_I(KC_ID);

CREATE INDEX IDX_TRANS_SYS_INF_01 ON T_TRANS_SYS_INF(TRANS_SYS_NM);

-- defalut 추가
ALTER TABLE experdb_management.T_TRANSCNG_I ALTER COLUMN TRANS_COM_ID SET DEFAULT 0;
-- not null 추가
ALTER TABLE experdb_management.T_TRANSCNG_I ALTER COLUMN TRANS_COM_ID SET NOT NULL;
--FK 추가
ALTER TABLE experdb_management.T_TRANSCNG_I ADD CONSTRAINT fk_t_transcng_i_03 FOREIGN KEY(TRANS_COM_ID) REFERENCES t_transcomcng_i(TRANS_COM_ID);


-- defalut 추가
ALTER TABLE experdb_management.T_TRANSCNG_TARGET_I ALTER COLUMN TRANS_TRG_SYS_ID SET DEFAULT 0;
--FK 추가
ALTER TABLE experdb_management.T_TRANSCNG_TARGET_I ADD CONSTRAINT fk_t_transcng_target_i_03 FOREIGN KEY(TRANS_TRG_SYS_ID) REFERENCES t_trans_sys_inf(TRANS_SYS_ID);

-- trans 토픽 테이블 추가
CREATE TABLE experdb_management.t_trans_topic_i (
	topic_id numeric NOT NULL, -- 토픽_아이디
	topic_nm text not NULL, -- 토픽명
	src_trans_exrt_trg_tb_id numeric NOT NULL, -- 소스_전송_대상_아이디
  	tar_trans_exrt_trg_tb_id numeric NULL, -- 소스_전송_대상_아이디
	src_trans_id numeric NOT NULL, -- 소스_전송_아이디
  	tar_trans_id numeric NULL, -- 타겟_전송_아이디
	table_total_cnt numeric NULL, -- 전송대상테이블수
 	src_topic_use_yn varchar(1) NOT NULL DEFAULT 'N', -- 소스_토픽_사용여부
    write_use_yn varchar(1) NOT NULL DEFAULT 'Y', -- 등록 사용여부
	frst_regr_id varchar(30) NULL, -- 최초_등록자_ID
	frst_reg_dtm timestamp NOT NULL, -- 최초_등록_일시
	lst_mdfr_id varchar(30) NULL,
	lst_mdf_dtm timestamp NOT NULL DEFAULT clock_timestamp(),
	CONSTRAINT pk_t_trans_topic_i PRIMARY KEY (topic_id, topic_nm, src_trans_id)
);
COMMENT ON TABLE experdb_management.t_trans_topic_i IS '전송토픽테이블';

-- Column comments
COMMENT ON COLUMN experdb_management.t_trans_topic_i.topic_id IS '토픽_아이디';
COMMENT ON COLUMN experdb_management.t_trans_topic_i.topic_nm IS '토픽_명';
COMMENT ON COLUMN experdb_management.t_trans_topic_i.src_trans_exrt_trg_tb_id IS '소스_전송_대상_아이디';
COMMENT ON COLUMN experdb_management.t_trans_topic_i.tar_trans_exrt_trg_tb_id IS '타겟_전송_대상_아이디';
COMMENT ON COLUMN experdb_management.t_trans_topic_i.src_trans_id IS '소스_전송_아이디';
COMMENT ON COLUMN experdb_management.t_trans_topic_i.tar_trans_id IS '타겟_전송_아이디';
COMMENT ON COLUMN experdb_management.t_trans_topic_i.table_total_cnt IS '전송대상테이블수';
COMMENT ON COLUMN experdb_management.t_trans_topic_i.src_topic_use_yn IS '소스_토픽_사용여부';
COMMENT ON COLUMN experdb_management.t_trans_topic_i .write_use_yn IS '등록_사용_여부';
COMMENT ON COLUMN experdb_management.t_trans_topic_i.frst_regr_id IS '최초_등록자_ID';
COMMENT ON COLUMN experdb_management.t_trans_topic_i.frst_reg_dtm IS '최초_등록_일시';
COMMENT ON COLUMN experdb_management.t_trans_topic_i.lst_mdfr_id IS '최종_수정자_ID';
COMMENT ON COLUMN experdb_management.t_trans_topic_i.lst_mdf_dtm IS '최종_수정_일시';

CREATE SEQUENCE Q_T_TRANS_TOPIC_I_01;