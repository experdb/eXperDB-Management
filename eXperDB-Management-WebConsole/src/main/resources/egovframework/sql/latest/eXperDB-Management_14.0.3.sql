-- 컬럼추가 초기 패스워드 설정
ALTER TABLE T_TRANS_ENCRYPT ADD COLUMN PW_CHANGE varchar(20) DEFAULT 'false';





