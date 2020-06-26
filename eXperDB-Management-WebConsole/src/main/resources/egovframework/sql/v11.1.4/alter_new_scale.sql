ALTER TABLE experdb_management.t_scale_i ADD useyn1 bpchar(1) NOT NULL DEFAULT 'Y'::bpchar;
COMMENT ON COLUMN experdb_management.t_scale_i.useyn1 IS '사용여부';



-- 테이블 추가(AWS 서버 내역)
CREATE TABLE experdb_management.t_scaleAwssvr_i (
	db_svr_id numeric(18) NOT NULL DEFAULT 1, -- DB_서버_ID
    db_svr_ipadr_id numeric(18) NOT NULL DEFAULT 1, -- DB_서버_IP주소_ID
	ipadr varchar(30) NULL, -- IP주소
    auto_run_cycle numeric(2) NULL, -- auto 주기
	min_clusters numeric NULL,                                    -- 최소_노드수
	max_clusters numeric NULL,                                    -- 최대_노드수
	frst_regr_id varchar(30) NULL, -- 최초_등록자_ID
	frst_reg_dtm timestamp NOT NULL DEFAULT clock_timestamp(), -- 최초_등록_일시
	lst_mdfr_id varchar(30) NULL, -- 최종_수정자_ID
	lst_mdf_dtm timestamp NOT NULL DEFAULT clock_timestamp() -- 최종_수정_일시
);
CREATE UNIQUE INDEX uk_t_scaleAwssvr_i_01 ON experdb_management.t_scaleAwssvr_i USING btree (db_svr_id, db_svr_ipadr_id);
COMMENT ON TABLE experdb_management.t_scaleAwssvr_i IS 'scale AWS 서버설정';

COMMENT ON COLUMN experdb_management.t_scaleAwssvr_i.db_svr_id IS 'DB_서버_ID';
COMMENT ON COLUMN experdb_management.t_scaleAwssvr_i.db_svr_ipadr_id IS 'DB_서버_IP주소_ID';
COMMENT ON COLUMN experdb_management.t_scaleAwssvr_i.auto_run_cycle IS 'AUTO_실행_주기';
COMMENT ON COLUMN experdb_management.t_scaleAwssvr_i.min_clusters IS '최소_노드수';
COMMENT ON COLUMN experdb_management.t_scaleAwssvr_i.max_clusters IS '최대_노드수';
COMMENT ON COLUMN experdb_management.t_scaleAwssvr_i.frst_regr_id IS '최초_등록자_ID';
COMMENT ON COLUMN experdb_management.t_scaleAwssvr_i.frst_reg_dtm IS '최초_등록_일시';
COMMENT ON COLUMN experdb_management.t_scaleAwssvr_i.lst_mdfr_id IS '최종_수정자_ID';
COMMENT ON COLUMN experdb_management.t_scaleAwssvr_i.lst_mdf_dtm IS '최종_수정_일시';
COMMENT ON COLUMN experdb_management.t_scaleAwssvr_i.ipadr IS 'IP주소';


