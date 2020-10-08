ALTER TABLE experdb_management.t_scale_i ADD useyn bpchar(1) NOT NULL DEFAULT 'Y'::bpchar;
COMMENT ON COLUMN experdb_management.t_scale_i.useyn IS '사용여부';



-- 테이블 추가(AWS 서버 내역)
CREATE TABLE experdb_management.t_scaleAwssvr_i (
	db_svr_id numeric(18) NOT NULL DEFAULT 1, -- DB_서버_ID
    db_svr_ipadr_id numeric(18) NOT NULL DEFAULT 1, -- DB_서버_IP주소_ID
	ipadr varchar(30) NULL, -- IP주소
    auto_run_cycle numeric(2) NULL, -- auto 주기
	min_clusters numeric NULL,                                    -- 최소_노드수
	max_clusters numeric NULL,                                    -- 최대_노드수
	frst_regr_id varchar(30) NULL, -- 최초_등록자_ID
	frst_reg_dtm timestamp NOT NULL DEFAULT clock_timestamp(), -- 최초_등록_일시
	lst_mdfr_id varchar(30) NULL, -- 최종_수정자_ID
	lst_mdf_dtm timestamp NOT NULL DEFAULT clock_timestamp() -- 최종_수정_일시
);
CREATE UNIQUE INDEX uk_t_scaleAwssvr_i_01 ON experdb_management.t_scaleAwssvr_i USING btree (db_svr_id, db_svr_ipadr_id);
COMMENT ON TABLE experdb_management.t_scaleAwssvr_i IS 'scale AWS 서버설정';

COMMENT ON COLUMN experdb_management.t_scaleAwssvr_i.db_svr_id IS 'DB_서버_ID';
COMMENT ON COLUMN experdb_management.t_scaleAwssvr_i.db_svr_ipadr_id IS 'DB_서버_IP주소_ID';
COMMENT ON COLUMN experdb_management.t_scaleAwssvr_i.auto_run_cycle IS 'AUTO_실행_주기';
COMMENT ON COLUMN experdb_management.t_scaleAwssvr_i.min_clusters IS '최소_노드수';
COMMENT ON COLUMN experdb_management.t_scaleAwssvr_i.max_clusters IS '최대_노드수';
COMMENT ON COLUMN experdb_management.t_scaleAwssvr_i.frst_regr_id IS '최초_등록자_ID';
COMMENT ON COLUMN experdb_management.t_scaleAwssvr_i.frst_reg_dtm IS '최초_등록_일시';
COMMENT ON COLUMN experdb_management.t_scaleAwssvr_i.lst_mdfr_id IS '최종_수정자_ID';
COMMENT ON COLUMN experdb_management.t_scaleAwssvr_i.lst_mdf_dtm IS '최종_수정_일시';
COMMENT ON COLUMN experdb_management.t_scaleAwssvr_i.ipadr IS 'IP주소';

COMMENT ON COLUMN experdb_management.t_scale_g.clusters IS '노드';

COMMENT ON COLUMN experdb_management.t_scale_i.expansion_clusters IS '노드_단위';
COMMENT ON COLUMN experdb_management.t_scale_i.min_clusters IS '최소_노드수';
COMMENT ON COLUMN experdb_management.t_scale_i.max_clusters IS '최대_노드수';

UPDATE T_SYSDTL_C SET sys_cd_nm = '노드 수동확장 화면' WHERE grp_cd = 'TC0001' AND sys_cd = 'DX-T0056';
UPDATE T_SYSDTL_C SET sys_cd_nm = '노드 수동확장 화면 조회' WHERE grp_cd = 'TC0001' AND sys_cd = 'DX-T0056_01';
UPDATE T_SYSDTL_C SET sys_cd_nm = '노드 수동확장 스케일-인' WHERE grp_cd = 'TC0001' AND sys_cd = 'DX-T0056_02';
UPDATE T_SYSDTL_C SET sys_cd_nm = '노드 수동확장 스케일-아웃' WHERE grp_cd = 'TC0001' AND sys_cd = 'DX-T0056_03';
UPDATE T_SYSDTL_C SET sys_cd_nm = '노드 수동확장 상세 조회' WHERE grp_cd = 'TC0001' AND sys_cd = 'DX-T0056_04';
UPDATE T_SYSDTL_C SET sys_cd_nm = '노드 수동확장 보안그룹 상세 조회' WHERE grp_cd = 'TC0001' AND sys_cd = 'DX-T0056_05';
UPDATE T_SYSDTL_C SET sys_cd_nm = '노드 수동확장  실행 팝업' WHERE grp_cd = 'TC0001' AND sys_cd = 'DX-T0056_06';
UPDATE T_SYSDTL_C SET sys_cd_nm = '노드 확장이력 화면' WHERE grp_cd = 'TC0001' AND sys_cd = 'DX-T0057';
UPDATE T_SYSDTL_C SET sys_cd_nm = '노드 확장이력 노드 확장 실행 이력 조회' WHERE grp_cd = 'TC0001' AND sys_cd = 'DX-T0057_01';
UPDATE T_SYSDTL_C SET sys_cd_nm = '노드 확장이력 노드 자동 확장 발생 이력 조회' WHERE grp_cd = 'TC0001' AND sys_cd = 'DX-T0057_02';
UPDATE T_SYSDTL_C SET sys_cd_nm = '노드 자동확장설정 화면' WHERE grp_cd = 'TC0001' AND sys_cd = 'DX-T0058';
UPDATE T_SYSDTL_C SET sys_cd_nm = '노드 자동확장설정 화면 조회' WHERE grp_cd = 'TC0001' AND sys_cd = 'DX-T0058_01';
UPDATE T_SYSDTL_C SET sys_cd_nm = '노드 자동확장설정 삭제' WHERE grp_cd = 'TC0001' AND sys_cd = 'DX-T0058_02';
UPDATE T_SYSDTL_C SET sys_cd_nm = '노드 자동확장설정 등록 팝업' WHERE grp_cd = 'TC0001' AND sys_cd = 'DX-T0059';
UPDATE T_SYSDTL_C SET sys_cd_nm = '노드 자동확장설정 등록' WHERE grp_cd = 'TC0001' AND sys_cd = 'DX-T0059_01';
UPDATE T_SYSDTL_C SET sys_cd_nm = '노드 자동확장 수정 팝업' WHERE grp_cd = 'TC0001' AND sys_cd = 'DX-T0060';
UPDATE T_SYSDTL_C SET sys_cd_nm = '노드 자동확장 수정' WHERE grp_cd = 'TC0001' AND sys_cd = 'DX-T0060_01';

INSERT into T_SYSDTL_C (grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
values ('TC0001', 'DX-T0061', '노드 자동확장 기본 설정 등록 팝업', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());

INSERT into T_SYSDTL_C (grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
values ('TC0001', 'DX-T0061_01', '노드 자동확장 기본 설정 등록', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());

DELETE FROM T_SYSDTL_C WHERE grp_cd = 'TC0035' AND sys_cd = 'TC003502';

ALTER TABLE experdb_management.t_scaleAwssvr_i ADD useyn bpchar(1) NOT NULL DEFAULT 'Y'::bpchar;
COMMENT ON COLUMN experdb_management.t_scaleAwssvr_i.useyn IS '사용여부';

