-- 테이블 변경(실행이력)
ALTER TABLE experdb_management.t_scale_g DROP COLUMN auto_policy_nm;
ALTER TABLE experdb_management.t_scale_g DROP COLUMN instance_id;
ALTER TABLE experdb_management.t_scale_g add column auto_policy_set_div varchar(1) null;
ALTER TABLE experdb_management.t_scale_g add column auto_policy_time numeric null;
ALTER TABLE experdb_management.t_scale_g add column auto_level varchar(8) null;
COMMENT ON COLUMN experdb_management.t_scale_g.auto_policy_set_div IS 'AUTO_정책_설정_구분';
COMMENT ON COLUMN experdb_management.t_scale_g.auto_policy_time IS 'AUTO_정책_시간';
COMMENT ON COLUMN experdb_management.t_scale_g.auto_level IS 'AUTO_레벨';

DROP INDEX uk_t_scale_g_01;
CREATE UNIQUE INDEX uk_t_scale_g_01 ON experdb_management.t_scale_g USING btree (scale_wrk_sn, wrk_id, db_svr_id, scale_type, process_id);


-- 테이블 변경(발생이력)
ALTER TABLE experdb_management.t_scaleoccur_g DROP COLUMN auto_policy_contents;
ALTER TABLE experdb_management.t_scaleoccur_g add column auto_policy_set_div varchar(1) NOT NULL;
ALTER TABLE experdb_management.t_scaleoccur_g add column auto_policy_time numeric NOT NULL;
ALTER TABLE experdb_management.t_scaleoccur_g add column auto_level varchar(8) NOT NULL;
COMMENT ON COLUMN experdb_management.t_scaleoccur_g.auto_policy_set_div IS 'AUTO_정책_설정_구분';
COMMENT ON COLUMN experdb_management.t_scaleoccur_g.auto_policy_time IS 'AUTO_정책_시간';
COMMENT ON COLUMN experdb_management.t_scaleoccur_g.auto_level IS 'AUTO_레벨';

ALTER TABLE experdb_management.t_scaleoccur_g ALTER COLUMN event_occur_contents TYPE varchar(8);

DROP INDEX uk_t_scaleoccur_g_01;
CREATE UNIQUE INDEX uk_t_scaleoccur_g_01 ON experdb_management.t_scaleoccur_g USING btree (wrk_sn, db_svr_id, scale_type, policy_type, execute_type);



-- 테이블 추가(auto scale 설정)
CREATE TABLE experdb_management.t_scale_i (
	wrk_id numeric(18) NOT NULL DEFAULT 1,                        -- 작업_ID
	db_svr_id numeric(18) NOT NULL DEFAULT 1,                     -- DB_서버_ID
	db_svr_ipadr_id numeric(18) NOT NULL DEFAULT 1,               -- DB_서버_IP주소_ID
	scale_type varchar(1) NOT NULL ,                              -- 스케일_유형
	policy_type varchar(8) NOT NULL,                              -- 정책_유형
	auto_policy_set_div varchar(1) NOT NULL,                      -- AUTO_정책_설정_구분
	auto_policy_time numeric NOT NULL,                            -- AUTO_정책_시간
	auto_level varchar(8) NOT NULL,                               -- AUTO_레벨
	execute_type varchar(8) NOT NULL,                             -- 실행_유형
	expansion_clusters numeric NULL,                              -- 확장_클러스터
	min_clusters numeric NULL,                                    -- 최소_클러스터
	max_clusters numeric NULL,                                    -- 최대_클러스터
	frst_regr_id varchar(30) NULL,                                -- 최초_등록자_ID
	frst_reg_dtm timestamp NOT NULL DEFAULT clock_timestamp(),    -- 최초_등록_일시
	lst_mdfr_id varchar(30) NULL,                                 -- 최종_수정자_ID
	lst_mdf_dtm timestamp NOT NULL DEFAULT clock_timestamp()      -- 최종_수정_일시
);
CREATE UNIQUE INDEX uk_t_scale_i_01 ON experdb_management.t_scale_i USING btree (wrk_id, db_svr_id, scale_type, policy_type, execute_type);
COMMENT ON TABLE experdb_management.t_scale_i IS 'SCALE AUTO 설정';

COMMENT ON COLUMN experdb_management.t_scale_i.wrk_id IS '작업_ID';
COMMENT ON COLUMN experdb_management.t_scale_i.db_svr_id IS 'DB_서버_ID';
COMMENT ON COLUMN experdb_management.t_scale_i.db_svr_ipadr_id IS 'DB_서버_IP주소_ID';
COMMENT ON COLUMN experdb_management.t_scale_i.scale_type IS '스케일_유형:scale_in(1),scale_out(2)';
COMMENT ON COLUMN experdb_management.t_scale_i.policy_type IS '정책_유형';
COMMENT ON COLUMN experdb_management.t_scale_i.auto_policy_set_div IS 'AUTO_정책_설정_구분';
COMMENT ON COLUMN experdb_management.t_scale_i.auto_policy_time IS 'AUTO_정책_시간';
COMMENT ON COLUMN experdb_management.t_scale_i.auto_level IS 'AUTO_레벨';
COMMENT ON COLUMN experdb_management.t_scale_i.execute_type IS '실행_유형';
COMMENT ON COLUMN experdb_management.t_scale_i.expansion_clusters IS '확장_클러스터';
COMMENT ON COLUMN experdb_management.t_scale_i.min_clusters IS '최소_클러스터';
COMMENT ON COLUMN experdb_management.t_scale_i.max_clusters IS '최대_클러스터';
COMMENT ON COLUMN experdb_management.t_scale_i.frst_regr_id IS '최초_등록자_ID';
COMMENT ON COLUMN experdb_management.t_scale_i.frst_reg_dtm IS '최초_등록_일시';
COMMENT ON COLUMN experdb_management.t_scale_i.lst_mdfr_id IS '최종_수정자_ID';
COMMENT ON COLUMN experdb_management.t_scale_i.lst_mdf_dtm IS '최종_수정_일시';



-- 테이블 추가(Auto Scale Loading 이력)
CREATE TABLE experdb_management.t_scaleloadlog_g (
	wrk_sn numeric NOT NULL DEFAULT 1,                   -- 작업_일련번호
	db_svr_id numeric(18) NOT NULL DEFAULT 1,            -- DB_서버_ID
	db_svr_ipadr_id numeric(18) NOT NULL DEFAULT 1,      -- DB_서버_IP주소_ID
	policy_type varchar(8) NOT NULL,                     -- 정책_유형
	exenum numeric NOT NULL,                             -- 실행값
	exedtm timestamp NOT NULL DEFAULT clock_timestamp()  -- 실행일시
);
CREATE UNIQUE INDEX uk_t_scaleloadlog_g_01 ON experdb_management.t_scaleloadlog_g USING btree (wrk_sn, db_svr_id);
COMMENT ON TABLE experdb_management.t_scaleloadlog_g IS 'Auto Scale Loading 테이블';

COMMENT ON COLUMN experdb_management.t_scaleloadlog_g.wrk_sn IS '작업_일련번호';
COMMENT ON COLUMN experdb_management.t_scaleloadlog_g.db_svr_id IS 'DB_서버_ID';
COMMENT ON COLUMN experdb_management.t_scaleloadlog_g.db_svr_ipadr_id IS 'DB_서버_IP주소_ID';
COMMENT ON COLUMN experdb_management.t_scaleloadlog_g.policy_type IS '정책_유형';
COMMENT ON COLUMN experdb_management.t_scaleloadlog_g.exenum IS '실행값';
COMMENT ON COLUMN experdb_management.t_scaleloadlog_g.exedtm IS '실행일시';

-- 시퀀스 추가
CREATE SEQUENCE q_t_scale_i_01;
CREATE SEQUENCE q_t_scaleloadlog_g_01;


-- 사용여부 컬럼 추가 및 변경
ALTER TABLE T_USRDBSVRAUT_I RENAME COLUMN SCALE_YN TO SCALE_AUT_YN;
ALTER TABLE T_USRDBSVRAUT_I RENAME COLUMN SCALE_HIST_YN TO SCALE_HIST_AUT_YN;
ALTER TABLE T_USRDBSVRAUT_I ADD COLUMN SCALE_CNG_AUT_YN VARCHAR(1) NULL;
COMMENT ON COLUMN T_USRDBSVRAUT_I.SCALE_AUT_YN IS 'scale_여부';
COMMENT ON COLUMN T_USRDBSVRAUT_I.SCALE_HIST_AUT_YN IS 'scale_이력_권한_여부';
COMMENT ON COLUMN T_USRDBSVRAUT_I.SCALE_CNG_AUT_YN IS 'scale_설정_권한_여부';


-- 메뉴코드 추가 및 변경
UPDATE T_SYSDTL_C SET SYS_CD_NM = 'Node 수동확장 화면' WHERE GRP_CD = 'TC0001' AND SYS_CD = 'DX-T0056';
UPDATE T_SYSDTL_C SET SYS_CD_NM = 'Node 수동확장 화면 조회' WHERE GRP_CD = 'TC0001' AND SYS_CD = 'DX-T0056_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM = 'Node 수동확장 Node 축소' WHERE GRP_CD = 'TC0001' AND SYS_CD = 'DX-T0056_02';
UPDATE T_SYSDTL_C SET SYS_CD_NM = 'Node 수동확장 Node 확대' WHERE GRP_CD = 'TC0001' AND SYS_CD = 'DX-T0056_03';
UPDATE T_SYSDTL_C SET SYS_CD_NM = 'Node 수동확장 상세 조회' WHERE GRP_CD = 'TC0001' AND SYS_CD = 'DX-T0056_04';
UPDATE T_SYSDTL_C SET SYS_CD_NM = 'Node 수동확장 보안그룹 상세 조회' WHERE GRP_CD = 'TC0001' AND SYS_CD = 'DX-T0056_05';

INSERT into T_SYSDTL_C (grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
values ('TC0001', 'DX-T0056_06', 'Node 수동확장  실행 팝업', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());

UPDATE T_SYSDTL_C SET SYS_CD_NM = 'Node 확장이력 화면' WHERE GRP_CD = 'TC0001' AND SYS_CD = 'DX-T0057';
UPDATE T_SYSDTL_C SET SYS_CD_NM = 'Node 확장이력 Node 확장 이력 조회' WHERE GRP_CD = 'TC0001' AND SYS_CD = 'DX-T0057_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM = 'Node 확장이력 Node 자동 확장 이력 조회' WHERE GRP_CD = 'TC0001' AND SYS_CD = 'DX-T0057_02';

INSERT into T_SYSDTL_C (grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
values ('TC0001', 'DX-T0058', 'Node 자동확장설정 화면', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());

INSERT into T_SYSDTL_C (grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
values ('TC0001', 'DX-T0058_01', 'Node 자동확장설정 화면 조회', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());

INSERT into T_SYSDTL_C (grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
values ('TC0001', 'DX-T0058_02', 'Node 자동확장설정 삭제', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());

INSERT into T_SYSDTL_C (grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
values ('TC0001', 'DX-T0059', 'Node 자동확장설정 등록 팝업', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());

INSERT into T_SYSDTL_C (grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
values ('TC0001', 'DX-T0059_01', 'Node 자동확장설정 등록', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());

INSERT into T_SYSDTL_C (grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
values ('TC0001', 'DX-T0060', 'Node 자동확장 수정 팝업', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());

INSERT into T_SYSDTL_C (grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
values ('TC0001', 'DX-T0060_01', 'Node 자동확장 수정', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());

UPDATE T_SYSDTL_C SET SYS_CD_NM = 'Notification' WHERE GRP_CD = 'TC0034' AND SYS_CD = 'TC003401';
