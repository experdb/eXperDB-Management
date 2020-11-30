INSERT INTO t_sysdtl_c (grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm) VALUES ('TC0002', 'TC000203', '배치작업', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO t_sysdtl_c (grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm) VALUES ('TC0002', 'TC000204', '데이터이행', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());


UPDATE T_SYSDTL_C SET sys_cd_nm = '노드 관리 화면', SYS_CD_NM_EN = 'Node Management Page' WHERE grp_cd = 'TC0001' AND sys_cd = 'DX-T0056';
UPDATE T_SYSDTL_C SET sys_cd_nm = '노드 관리 화면 조회', SYS_CD_NM_EN = 'Node Management Search' WHERE grp_cd = 'TC0001' AND sys_cd = 'DX-T0056_01';
UPDATE T_SYSDTL_C SET sys_cd_nm = '노드 수동축소 스케일-인' WHERE grp_cd = 'TC0001' AND sys_cd = 'DX-T0056_02';
UPDATE T_SYSDTL_C SET sys_cd_nm = '노드 수동확장 스케일-아웃' WHERE grp_cd = 'TC0001' AND sys_cd = 'DX-T0056_03';
UPDATE T_SYSDTL_C SET sys_cd_nm = '노드 관리 상세 조회', SYS_CD_NM_EN = 'Node Management Detail' WHERE grp_cd = 'TC0001' AND sys_cd = 'DX-T0056_04';
UPDATE T_SYSDTL_C SET sys_cd_nm = '노드 관리 보안그룹 상세 조회', SYS_CD_NM_EN = 'Node Management Security Group Detail' WHERE grp_cd = 'TC0001' AND sys_cd = 'DX-T0056_05';
UPDATE T_SYSDTL_C SET sys_cd_nm = '노드 관리  수동확장 실행 팝업', SYS_CD_NM_EN = 'Node Manual Expansion Run Popup' WHERE grp_cd = 'TC0001' AND sys_cd = 'DX-T0056_06';

UPDATE T_SYSDTL_C SET sys_cd_nm = '노드 변경이력 화면' WHERE grp_cd = 'TC0001' AND sys_cd = 'DX-T0057';
UPDATE T_SYSDTL_C SET sys_cd_nm = '노드 변경이력 노드 확장/축소 실행 이력 조회' WHERE grp_cd = 'TC0001' AND sys_cd = 'DX-T0057_01';
UPDATE T_SYSDTL_C SET sys_cd_nm = '노드 변경이력 노드 자동 확장/축소 발생 이력 조회', SYS_CD_NM_EN = 'Node Auto-Expansion/collapse Scale History Search' WHERE grp_cd = 'TC0001' AND sys_cd = 'DX-T0057_02';

INSERT INTO t_sysdtl_c (grp_cd, sys_cd, sys_cd_nm, SYS_CD_NM_EN, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm) VALUES ('TC0001', 'DX-T0056_07', '노드 관리  수동축소 실행 팝업', 'Node Manual Collapse Run Popup', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());

CREATE TABLE experdb_management.t_trans_encrypt (
	trans_id varchar(100) NOT NULL,
	trans_chk_key varchar(100) NOT NULL,
	FRST_REGR_ID         VARCHAR(30) NULL,
	frst_reg_dtm timestamp NOT NULL DEFAULT clock_timestamp(),
	lst_mdfr_id varchar(30) NULL,
	lst_mdf_dtm timestamp NOT NULL DEFAULT clock_timestamp(),
	CONSTRAINT pk_t_trans_encrypt PRIMARY KEY (trans_id)
);

UPDATE T_USR_I SET PWD = 'eb142b0cae0baa72a767ebc0823d1be94e14c5bfc52d8e417fc4302fceb6240c' WHERE USR_ID = 'experdb';
UPDATE T_USR_I SET PWD = 'eb142b0cae0baa72a767ebc0823d1be94e14c5bfc52d8e417fc4302fceb6240c' WHERE USR_ID = 'admin';


INSERT INTO t_trans_encrypt( trans_id, trans_chk_key, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM)VALUES('experdb', 'UP7x6XqHQsGUZoa5ZXphGQ==', 'admin', clock_timestamp(), 'admin', clock_timestamp());
INSERT INTO t_trans_encrypt( trans_id, trans_chk_key, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM)VALUES('admin', 'UP7x6XqHQsGUZoa5ZXphGQ==', 'admin', clock_timestamp(), 'admin', clock_timestamp());
