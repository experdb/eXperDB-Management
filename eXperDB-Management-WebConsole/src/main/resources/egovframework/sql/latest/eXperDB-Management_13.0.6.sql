-- 컬럼추가 (DB2PG 데이터이관 히스트리 레포트추출을 위한 컬럼 )
ALTER TABLE T_DB2PG_MIG_HISTORY ADD COLUMN save_pth varchar(300) NULL;

