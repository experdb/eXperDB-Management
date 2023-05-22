ALTER TABLE t_bck_wrkcng_i ADD COLUMN db_svr_ipadr_id numeric(18);
ALTER TABLE t_bck_wrkcng_i ADD COLUMN backrest_gbn varchar(20) ;

INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0003', 'TC000304', 'diff', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());


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