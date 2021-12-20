-- SCALE ---------------------------------------------------------------------------------------------
-- scale AWS 서버설정 모니터링 서버 관련 컬럼 추가
ALTER TABLE t_scaleawssvr_i ADD COLUMN mon_ip varchar(30) NULL;
ALTER TABLE t_scaleawssvr_i ADD COLUMN mon_port numeric(5) NOT NULL DEFAULT 0;
ALTER TABLE t_scaleawssvr_i ADD COLUMN mon_database varchar(50) NULL;
ALTER TABLE t_scaleawssvr_i ADD COLUMN mon_user varchar(1000) NULL;
ALTER TABLE t_scaleawssvr_i ADD COLUMN mon_password varchar(1000) NULL;

COMMENT ON COLUMN experdb_management.t_scaleawssvr_i.mon_ip IS '모니터링 repository DB IP';
COMMENT ON COLUMN experdb_management.t_scaleawssvr_i.mon_port IS '모니터링 repository DB PORT';
COMMENT ON COLUMN experdb_management.t_scaleawssvr_i.mon_database IS '모니터링 repository DB 데이터베이스';
COMMENT ON COLUMN experdb_management.t_scaleawssvr_i.mon_user IS '모니터링 repository DB 유저명';
COMMENT ON COLUMN experdb_management.t_scaleawssvr_i.mon_password IS '모니터링 repository DB 비밀번호';