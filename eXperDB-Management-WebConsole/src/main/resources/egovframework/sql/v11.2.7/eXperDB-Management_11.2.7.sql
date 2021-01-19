DROP TABLE experdb_management.t_db2pg_usrqry_ls CASCADE;

CREATE TABLE t_db2pg_usrqry_ls
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
	CONSTRAINT fk_t_db2pg_usrqry_ls_01 FOREIGN KEY(db2pg_trsf_wrk_id) REFERENCES experdb_management.t_db2pg_trsf_wrk_inf(db2pg_trsf_wrk_id)
);