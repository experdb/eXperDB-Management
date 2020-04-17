CREATE TABLE experdb_management.t_scale_g (
	scale_wrk_sn numeric NOT NULL DEFAULT 1,                    -- 스케일_실행_일련번호
	wrk_id numeric(18) NOT NULL DEFAULT 1,                      -- 작업_ID
	scale_type varchar(1) NOT NULL ,                            -- 스케일_유형
	db_svr_id numeric(18) NOT NULL DEFAULT 1,                   -- DB_서버_ID
	db_svr_ipadr_id numeric(18) NOT NULL DEFAULT 1,             -- DB_서버_IP주소_ID
	wrk_type varchar(8) NOT NULL,                               -- 작업_유형
	auto_policy varchar(8) NULL,                                -- AUTO_정책
	auto_policy_nm varchar(300) NULL,                           -- AUTO_정책_명
	clusters numeric NULL,                                      -- 클러스터
	instance_id varchar(30) NULL,                               -- 인스턴트_ID
	process_id varchar(30) NOT NULL,                           -- 프로세스_ID
	wrk_strt_dtm timestamp NOT NULL DEFAULT clock_timestamp(), -- 작업_시작_일시
	wrk_end_dtm timestamp NOT NULL DEFAULT clock_timestamp(), -- 작업_종료_일시
	exe_rslt_cd varchar(20) NULL,                               -- 실행_결과_코드
	rslt_msg varchar(1000) NULL,                                -- 결과_메시지
	frst_regr_id varchar(30) NULL,                              -- 최초_등록자_ID
	frst_reg_dtm timestamp NOT NULL DEFAULT clock_timestamp(),  --최초_등록_일시
	lst_mdfr_id varchar(30) NULL,  -- 최종_수정자_ID
	lst_mdf_dtm timestamp NOT NULL DEFAULT clock_timestamp()
);
CREATE UNIQUE INDEX uk_t_scale_g_01 ON experdb_management.t_scale_g USING btree (scale_wrk_sn, wrk_id, scale_type, db_svr_ipadr_id, process_id);
COMMENT ON TABLE experdb_management.t_scale_g IS 'SCALE 실행로그';

COMMENT ON COLUMN experdb_management.t_scale_g.scale_wrk_sn IS 'SCALE_실행일련번호';
COMMENT ON COLUMN experdb_management.t_scale_g.wrk_id IS '작업_ID';
COMMENT ON COLUMN experdb_management.t_scale_g.scale_type IS '스케일_유형:scale_in(1),scale_out(2)';
COMMENT ON COLUMN experdb_management.t_scale_g.db_svr_id IS 'DB_서버_ID';
COMMENT ON COLUMN experdb_management.t_scale_g.db_svr_ipadr_id IS 'DB_서버_IP주소_ID';
COMMENT ON COLUMN experdb_management.t_scale_g.wrk_type IS '작업_유형';
COMMENT ON COLUMN experdb_management.t_scale_g.auto_policy IS 'AUTO_정책';
COMMENT ON COLUMN experdb_management.t_scale_g.auto_policy_nm IS 'AUTO_정책_명';
COMMENT ON COLUMN experdb_management.t_scale_g.clusters IS '클러스터';
COMMENT ON COLUMN experdb_management.t_scale_g.instance_id IS '인스턴트_ID';
COMMENT ON COLUMN experdb_management.t_scale_g.process_id IS '프로세스_ID';
COMMENT ON COLUMN experdb_management.t_scale_g.wrk_strt_dtm IS '작업_시작_일시';
COMMENT ON COLUMN experdb_management.t_scale_g.wrk_end_dtm IS '작업_종료_일시';
COMMENT ON COLUMN experdb_management.t_scale_g.exe_rslt_cd IS '실행_결과_코드';
COMMENT ON COLUMN experdb_management.t_scale_g.rslt_msg IS '결과_메시지';

COMMENT ON COLUMN experdb_management.t_scale_g.frst_regr_id IS '최초_등록자_ID';
COMMENT ON COLUMN experdb_management.t_scale_g.frst_reg_dtm IS '최초_등록_일시';
COMMENT ON COLUMN experdb_management.t_scale_g.lst_mdfr_id IS '최종_수정자_ID';
COMMENT ON COLUMN experdb_management.t_scale_g.lst_mdf_dtm IS '최종_수정_일시';


ALTER TABLE T_USRDBSVRAUT_I ADD COLUMN SCALE_YN VARCHAR(1) NULL;
ALTER TABLE T_USRDBSVRAUT_I ADD COLUMN SCALE_HIST_YN VARCHAR(1) NULL;



-- 테이블 추가(발생이력)
CREATE TABLE experdb_management.t_scaleoccur_g (
	wrk_sn numeric NOT NULL DEFAULT 1,                            -- 작업_일련번호
	db_svr_id numeric(18) NOT NULL DEFAULT 1,                     -- DB_서버_ID
	db_svr_ipadr_id numeric(18) NOT NULL DEFAULT 1,               -- DB_서버_IP주소_ID
	scale_type varchar(1) NOT NULL ,                              -- 스케일_유형
	policy_type varchar(8) NOT NULL,                              -- 정책_유형
	auto_policy_contents varchar(300) NOT NULL,                   -- AUTO_정책_내용
	execute_type varchar(8) NOT NULL,                             -- 실행_유형
	event_occur_contents varchar(1000) NOT NULL,                  -- 이벤트_발생_내용
	event_occur_dtm timestamp NOT NULL DEFAULT clock_timestamp(), -- 이벤트_발생_일시
	frst_regr_id varchar(30) NULL,                                -- 최초_등록자_ID
	frst_reg_dtm timestamp NOT NULL DEFAULT clock_timestamp(),    --최초_등록_일시
	lst_mdfr_id varchar(30) NULL,                                 -- 최종_수정자_ID
	lst_mdf_dtm timestamp NOT NULL DEFAULT clock_timestamp()      -- 최종_수정_일시
);
CREATE UNIQUE INDEX uk_t_scaleoccur_g_01 ON experdb_management.t_scaleoccur_g USING btree (wrk_sn, db_svr_ipadr_id, scale_type, policy_type, execute_type);
COMMENT ON TABLE experdb_management.t_scaleoccur_g IS 'SCALE AUTO 발생로그';

COMMENT ON COLUMN experdb_management.t_scaleoccur_g.wrk_sn IS '작업_일련번호';
COMMENT ON COLUMN experdb_management.t_scaleoccur_g.db_svr_id IS 'DB_서버_ID';
COMMENT ON COLUMN experdb_management.t_scaleoccur_g.db_svr_ipadr_id IS 'DB_서버_IP주소_ID';
COMMENT ON COLUMN experdb_management.t_scaleoccur_g.scale_type IS '스케일_유형:scale_in(1),scale_out(2)';
COMMENT ON COLUMN experdb_management.t_scaleoccur_g.policy_type IS '정책_유형';
COMMENT ON COLUMN experdb_management.t_scaleoccur_g.auto_policy_contents IS 'AUTO_정책_내용';
COMMENT ON COLUMN experdb_management.t_scaleoccur_g.execute_type IS '실행_유형';
COMMENT ON COLUMN experdb_management.t_scaleoccur_g.event_occur_contents IS '이벤트_발생_내용';
COMMENT ON COLUMN experdb_management.t_scaleoccur_g.event_occur_dtm IS '이벤트_발생_일시';
COMMENT ON COLUMN experdb_management.t_scaleoccur_g.frst_regr_id IS '최초_등록자_ID';
COMMENT ON COLUMN experdb_management.t_scaleoccur_g.frst_reg_dtm IS '최초_등록_일시';
COMMENT ON COLUMN experdb_management.t_scaleoccur_g.lst_mdfr_id IS '최종_수정자_ID';
COMMENT ON COLUMN experdb_management.t_scaleoccur_g.lst_mdf_dtm IS '최종_수정_일시';


CREATE SEQUENCE q_t_scale_g_01;
CREATE SEQUENCE q_t_scaleoccur_g_01;


INSERT into T_SYSDTL_C (grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
values ('TC0001', 'DX-T0056', 'eXperDB_scale 화면', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());

INSERT into T_SYSDTL_C (grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
values ('TC0001', 'DX-T0056_01', 'eXperDB_scale 화면 조회', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());

INSERT into T_SYSDTL_C (grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
values ('TC0001', 'DX-T0056_02', 'eXperDB_scale Scale In', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());

INSERT into T_SYSDTL_C (grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
values ('TC0001', 'DX-T0056_03', 'eXperDB_scale Scale Out', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());

INSERT into T_SYSDTL_C (grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
values ('TC0001', 'DX-T0056_04', 'eXperDB_scale 상세 조회', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());

INSERT into T_SYSDTL_C (grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
values ('TC0001', 'DX-T0056_05', 'eXperDB_scale 보안그룹 상세 조회', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());

-- 코드그룹 추가
INSERT INTO T_SYSGRP_C (GRP_CD, GRP_CD_NM, GRP_CD_EXP, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM )
                VALUES ( 'TC0033', '작업유형', 'SCALE 작업유형', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());

INSERT INTO T_SYSGRP_C (GRP_CD, GRP_CD_NM, GRP_CD_EXP, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM )
                VALUES ( 'TC0034', '실행유형', 'SCALE 실행유형', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());

INSERT INTO T_SYSGRP_C (GRP_CD, GRP_CD_NM, GRP_CD_EXP, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM )
                VALUES ( 'TC0035', '정책유형', 'SCALE 정책유형', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());

-- 코드추가
INSERT into T_SYSDTL_C (grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
values ('TC0001', 'DX-T0057', 'eXperDB_scale 이력 화면', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());

INSERT into T_SYSDTL_C (grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
values ('TC0001', 'DX-T0057_01', 'eXperDB_scale 실행이력 조회', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());

INSERT into T_SYSDTL_C (grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
values ('TC0001', 'DX-T0057_02', 'eXperDB_scale auto 발생이력 조회', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());

INSERT into T_SYSDTL_C (grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
values ('TC0033', 'TC003301', 'Auto', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());

INSERT into T_SYSDTL_C (grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
values ('TC0033', 'TC003302', 'Manual', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());

INSERT into T_SYSDTL_C (grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
values ('TC0034', 'TC003401', 'Logging', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());

INSERT into T_SYSDTL_C (grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
values ('TC0034', 'TC003402', 'Auto-scale', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());

INSERT into T_SYSDTL_C (grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
values ('TC0035', 'TC003501', 'CPU', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());

INSERT into T_SYSDTL_C (grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
values ('TC0035', 'TC003502', 'TPS', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());