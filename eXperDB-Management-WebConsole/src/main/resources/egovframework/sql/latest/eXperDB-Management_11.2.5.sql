ALTER TABLE t_migexe_g DROP CONSTRAINT fk_t_migexe_g_01;

INSERT INTO t_trans_encrypt( trans_id, trans_chk_key, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM)
select USR_ID, 'UP7x6XqHQsGUZoa5ZXphGQ==', 'admin', clock_timestamp(), 'admin', clock_timestamp()
 from T_USR_I
ON CONFLICT (trans_id) DO NOTHING;


UPDATE T_USR_I SET PWD = 'eb142b0cae0baa72a767ebc0823d1be94e14c5bfc52d8e417fc4302fceb6240c';