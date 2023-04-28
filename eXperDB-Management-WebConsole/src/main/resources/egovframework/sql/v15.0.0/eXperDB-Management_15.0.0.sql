ALTER TABLE t_bck_wrkcng_i ADD COLUMN db_svr_ipadr_id numeric(18);
ALTER TABLE t_bck_wrkcng_i ADD COLUMN backrest_gbn varchar(20) ;

INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0003', 'TC000304', 'diff', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());