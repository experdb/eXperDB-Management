

ALTER TABLE T_PRY_LSN_I ADD COLUMN BAL_YN bpchar(1)  NULL;
COMMENT ON COLUMN experdb_management.T_PRY_LSN_I.BAL_YN IS '로드발란스_사용여부';
ALTER TABLE T_PRY_LSN_I ADD COLUMN BAL_OPT varchar(10)  NULL;
COMMENT ON COLUMN experdb_management.T_PRY_LSN_I.BAL_OPT IS '로드발란스_옵션';

ALTER TABLE experdb_management.t_pry_lsn_i ALTER COLUMN bal_yn SET DEFAULT 'N'::bpchar;

UPDATE T_PRY_LSN_I SET BAL_YN='N', BAL_OPT='';

INSERT INTO t_sysgrp_c
(grp_cd, grp_cd_nm, grp_cd_exp, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
VALUES('TC0043', '로드발란싱 옵션', 'Proxy 로드발란싱 옵션', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO t_sysdtl_c
(grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm, sys_cd_nm_en)
VALUES('TC0043', 'TC004301', 'RoundRobin', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp(), 'roundrobin');
INSERT INTO t_sysdtl_c
(grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm, sys_cd_nm_en)
VALUES('TC0043', 'TC004302', 'LeastConn', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp(), 'leastconn');

-- trans 모니터링 메뉴 추가
ALTER TABLE t_usrdbsvraut_i ADD COLUMN trans_mtr_aut_yn bpchar(1) NULL;
COMMENT ON COLUMN experdb_management.t_usrdbsvraut_i.trans_mtr_aut_yn IS 'connector_모니터링_여부';
