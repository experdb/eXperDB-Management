-- SCALE ---------------------------------------------------------------------------------------------
-- scale AWS 서버설정 모니터링 서버 관련 컬럼 추가
-- ALTER TABLE t_scaleawssvr_i ADD COLUMN mon_ip varchar(30) NULL;
-- ALTER TABLE t_scaleawssvr_i ADD COLUMN mon_port numeric(5) NOT NULL DEFAULT 0;
-- ALTER TABLE t_scaleawssvr_i ADD COLUMN mon_database varchar(50) NULL;
-- ALTER TABLE t_scaleawssvr_i ADD COLUMN mon_user varchar(1000) NULL;
-- ALTER TABLE t_scaleawssvr_i ADD COLUMN mon_password varchar(1000) NULL;

-- COMMENT ON COLUMN experdb_management.t_scaleawssvr_i.mon_ip IS '모니터링 repository DB IP';
-- COMMENT ON COLUMN experdb_management.t_scaleawssvr_i.mon_port IS '모니터링 repository DB PORT';
-- COMMENT ON COLUMN experdb_management.t_scaleawssvr_i.mon_database IS '모니터링 repository DB 데이터베이스';
-- COMMENT ON COLUMN experdb_management.t_scaleawssvr_i.mon_user IS '모니터링 repository DB 유저명';
-- COMMENT ON COLUMN experdb_management.t_scaleawssvr_i.mon_password IS '모니터링 repository DB 비밀번호';

-- ALTER TABLE T_PRY_AGT_I ADD COLUMN INTL_IPADR varchar(30) NULL;
-- COMMENT ON COLUMN experdb_management.T_PRY_AGT_I.INTL_IPADR IS '내부_IP주소';


INSERT INTO T_SYSGRP_C(GRP_CD, GRP_CD_NM, GRP_CD_EXP, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0046', 'CDC 기본설정 Plug.in', 'CDC PlugIn 타입', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0046', 'TC004601', 'wal2json', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
