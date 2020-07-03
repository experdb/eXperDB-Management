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
