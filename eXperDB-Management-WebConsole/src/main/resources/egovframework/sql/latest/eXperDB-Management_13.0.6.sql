-- 컬럼추가 (DB2PG 데이터이관 히스트리 레포트추출을 위한 컬럼 )
ALTER TABLE T_DB2PG_MIG_HISTORY ADD COLUMN save_pth varchar(300) NULL;

-- 컬럼추가 (DB2PG 소스병렬도 컬럼 추가)
ALTER TABLE t_db2pg_trsf_wrk_inf ADD COLUMN src_parallel numeric NOT NULL DEFAULT -1;