INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0032', 'TC003201', 'DDL', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0032', 'TC003202', 'MIGRATION', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());


update T_SYSDTL_C set sys_cd_nm ='UTF-8' where sys_cd='TC003101';
update T_SYSDTL_C set sys_cd_nm ='EUC-KR' where sys_cd='TC003102';