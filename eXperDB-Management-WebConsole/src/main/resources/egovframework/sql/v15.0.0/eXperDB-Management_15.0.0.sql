ALTER TABLE t_bck_wrkcng_i ADD COLUMN db_svr_ipadr_id numeric(18);
ALTER TABLE t_bck_wrkcng_i ADD COLUMN backrest_gbn varchar(20) ;
ALTER TABLE t_bck_wrkcng_i add column remote_ip varchar(20);
ALTER TABLE t_bck_wrkcng_i add column remote_port varchar(20);
ALTER TABLE t_bck_wrkcng_i add column remote_usr varchar(20);
ALTER TABLE t_bck_wrkcng_i add column remote_pw varchar(20);
ALTER TABLE t_wrkexe_g add column db_sz numeric(18);

INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM, SYS_CD_NM_EN ) VALUES('TC0002', 'TC000205', 'Backrest백업', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp(), 'Backrest Backup');
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0003', 'TC000304', 'diff', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM, SYS_CD_NM_EN ) VALUES('TC0001', 'DX-T0180', 'Backrest 백업 등록 팝업', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp(), 'Backrest Backup Registered Popup');
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM, SYS_CD_NM_EN ) VALUES('TC0001', 'DX-T0180_01', 'Backrest 백업 등록', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp(), 'Backrest Backup Registration');
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM, SYS_CD_NM_EN ) VALUES('TC0001', 'DX-T0181', 'Backrest 백업 수정 팝업', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp(), 'Backrest Backup Modify Popup');
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM, SYS_CD_NM_EN ) VALUES('TC0001', 'DX-T0181_01', 'Backrest 백업 수정', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp(), 'Backrest Backup Modification');
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM) VALUES('TC0001', 'DX-T0183', 'Backrest 백업 상세조회 팝업', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM, SYS_CD_NM_EN ) VALUES('TC0001', 'DX-T0182', 'Backrest 백업 조회', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp(), 'Backrest Backup Search');
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM, SYS_CD_NM_EN ) VALUES('TC0001', 'DX-T0184', 'Backrest 백업이력 조회', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp(), 'Backrest Backup History Search');
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM, SYS_CD_NM_EN ) VALUES('TC0001', 'DX-T0185', '복원설정 화면', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp(), 'Restore Setting Page');
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM, SYS_CD_NM_EN ) VALUES('TC0001', 'DX-T0186', '복원설정 등록', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp(), 'Restore Setting Registration');
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM) VALUES('TC0001', 'DX-T0187', '복원이력 완전/시점 복원이력 조회', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());



CREATE TABLE t_BACKREST_OPT_i (
      opt_id NUMERIC PRIMARY key
      ,opt_gbn  numeric(5)
      ,opt_nm varchar(50)
      ,opt_exp varchar(100)
      );
		
COMMENT ON COLUMN t_BACKREST_OPT_i.opt_id IS 'Backrest 옵션ID';
COMMENT ON COLUMN t_BACKREST_OPT_i.opt_gbn IS 'Backrest 구분';   
COMMENT ON COLUMN t_BACKREST_OPT_i.opt_nm IS 'Backrest 옵션';
COMMENT ON COLUMN t_BACKREST_OPT_i.opt_exp IS 'Backrest 옵션설명';   
COMMENT ON COLUMN t_wrkexe_g.db_sz IS 'db 백업 사이즈';		
		
CREATE SEQUENCE Q_BACKREST_OPT_I_01 ;

INSERT INTO T_BACKREST_OPT_I (OPT_ID, OPT_GBN, OPT_NM, OPT_EXP) VALUES(1, 0, 'buffer-size', '파일 작업을 위한 버퍼 크기');
INSERT INTO T_BACKREST_OPT_I (OPT_ID, OPT_GBN, OPT_NM, OPT_EXP) VALUES(2, 1, 'delta', '체크섬을 이용한 백업 또는 복원');
INSERT INTO T_BACKREST_OPT_I (OPT_ID, OPT_GBN, OPT_NM, OPT_EXP) VALUES(3, 2, 'delta', '체크섬을 이용한 백업 또는 복원');
INSERT INTO T_BACKREST_OPT_I (OPT_ID, OPT_GBN, OPT_NM, OPT_EXP) VALUES(4, 0, 'archive-async', 'WAL 세그먼트 비동기 송수신 활성화 여부');
INSERT INTO T_BACKREST_OPT_I (OPT_ID, OPT_GBN, OPT_NM, OPT_EXP) VALUES(5, 0, 'archive-get-queue-max', 'archive-async 활설화 시, archive-get 큐의 최대 사이즈 지정');
INSERT INTO T_BACKREST_OPT_I (OPT_ID, OPT_GBN, OPT_NM, OPT_EXP) VALUES(6, 0, 'archive-push-queue-max', 'PostgreSQL Archive Queue의 최대 사이즈');
INSERT INTO T_BACKREST_OPT_I (OPT_ID, OPT_GBN, OPT_NM, OPT_EXP) VALUES(7, 0, 'archie-timeout', 'WAL 세그먼트가 pgbackrest 아카이브 저장소로 이동할 때까지의 최대 대기 시간을 초로 설정');
INSERT INTO T_BACKREST_OPT_I (OPT_ID, OPT_GBN, OPT_NM, OPT_EXP) VALUES(8, 1, 'archve-check', '백업이 완료되기 전에 아카이브 WAL 세그먼트를 체크');
INSERT INTO T_BACKREST_OPT_I (OPT_ID, OPT_GBN, OPT_NM, OPT_EXP) VALUES(9, 1, 'archive-copy', '백업 일관성을 유지하기 위한 WAL 세그먼트 복사');
INSERT INTO T_BACKREST_OPT_I (OPT_ID, OPT_GBN, OPT_NM, OPT_EXP) VALUES(10, 1, 'start-fast', '신속하게 백업을 실행하기 위해 체크포인트를 강제 실행');
INSERT INTO T_BACKREST_OPT_I (OPT_ID, OPT_GBN, OPT_NM, OPT_EXP) VALUES(11, 0, 'repo-retention-archive', '유지할 연속 WAL의 백업 수');
INSERT INTO T_BACKREST_OPT_I (OPT_ID, OPT_GBN, OPT_NM, OPT_EXP) VALUES(12, 0, 'repo-retention-archive-type', 'WAL 보존을 위한 백업 유형');
INSERT INTO T_BACKREST_OPT_I (OPT_ID, OPT_GBN, OPT_NM, OPT_EXP) VALUES(13, 0, 'repo-retention-diff', '보존할 차등백업 수');
INSERT INTO T_BACKREST_OPT_I (OPT_ID, OPT_GBN, OPT_NM, OPT_EXP) VALUES(14, 2, 'db-include', '특정 데이터베이스 복원');
INSERT INTO T_BACKREST_OPT_I (OPT_ID, OPT_GBN, OPT_NM, OPT_EXP) VALUES(15, 2, 'db-exclude', '특정 데이터베이스를 제외한 나머지 복원');

ALTER TABLE t_usrdbsvraut_i ADD COLUMN backrest_aut_yn varchar(1) ;
ALTER TABLE t_usrdbsvraut_i ADD COLUMN backrest_restore_aut_yn varchar(1) ;
COMMENT ON COLUMN t_usrdbsvraut_i.backrest_aut_yn IS 'backrest_여부';
COMMENT ON COLUMN t_usrdbsvraut_i.backrest_restore_aut_yn IS '복원_설정_권한_여부';		

ALTER TABLE t_rman_restore ADD COLUMN restore_size varchar(10) ;
ALTER TABLE t_rman_restore ADD COLUMN elapsed_time varchar(100) ;
COMMENT ON COLUMN t_rman_restore.restore_size IS '복원_파일_크기';
COMMENT ON COLUMN t_rman_restore.elapsed_time IS '복원_소요시간';
