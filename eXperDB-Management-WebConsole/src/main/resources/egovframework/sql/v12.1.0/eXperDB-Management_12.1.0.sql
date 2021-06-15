DROP TABLE experdb_management.t_db2pg_usrqry_ls CASCADE;

CREATE TABLE experdb_management.t_db2pg_usrqry_ls
(
	db2pg_usr_qry_id     numeric not null default nextval('q_db2pg_usrqry_ls_01'),
	db2pg_trsf_wrk_id    numeric not null,
	tar_tb_nm            varchar(100) not null,
	usr_qry_exp          text null,
	frst_regr_id         varchar(30) null,
	frst_reg_dtm         timestamp not null,
	lst_mdfr_id          varchar(30) null,
	lst_mdf_dtm          timestamp not null,
	CONSTRAINT pk_t_db2pg_usrqry_ls PRIMARY KEY (db2pg_usr_qry_id),
	CONSTRAINT fk_t_db2pg_usrqry_ls_01 FOREIGN KEY(db2pg_trsf_wrk_id) REFERENCES experdb_management.t_db2pg_trsf_wrk_inf(db2pg_trsf_wrk_id) on delete cascade 
);

COMMENT ON COLUMN experdb_management.t_db2pg_usrqry_ls.db2pg_usr_qry_id IS '사용자쿼리_id';
COMMENT ON COLUMN experdb_management.t_db2pg_usrqry_ls.db2pg_trsf_wrk_id IS 'db2pg_이행작업_id';
COMMENT ON COLUMN experdb_management.t_db2pg_usrqry_ls.tar_tb_nm IS '타켓_테이블_이름';
COMMENT ON COLUMN experdb_management.t_db2pg_usrqry_ls.usr_qry_exp IS '사용자_쿼리';
COMMENT ON COLUMN experdb_management.t_db2pg_usrqry_ls.frst_regr_id IS '최초_등록자_id';
COMMENT ON COLUMN experdb_management.t_db2pg_usrqry_ls.frst_reg_dtm IS '최초_등록_시각';
COMMENT ON COLUMN experdb_management.t_db2pg_usrqry_ls.lst_mdfr_id IS '최근_수정자_id';
COMMENT ON COLUMN experdb_management.t_db2pg_usrqry_ls.lst_mdf_dtm IS '최근_수장_시각';


