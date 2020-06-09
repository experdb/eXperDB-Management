ALTER TABLE experdb_management.t_migexe_g ADD COLUMN save_pth varchar(300);
ALTER TABLE experdb_management.t_db2pg_trsf_wrk_inf add column db2pg_uchr_lchr_val varchar(50);
ALTER TABLE experdb_management.t_migexe_g DROP CONSTRAINT fk_t_migexe_g_01;