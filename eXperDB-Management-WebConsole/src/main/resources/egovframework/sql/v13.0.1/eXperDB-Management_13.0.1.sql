--encrypt backup/restore 메뉴 추가
INSERT INTO t_mnu_i
(mnu_id, mnu_cd, mnu_nm, hgr_mnu_id, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
VALUES(nextval('q_mnu_i_01'), 'MN00022', '백업/복원', '', 'experdb', clock_timestamp(), 'experdb', clock_timestamp());

INSERT INTO t_mnu_i
(mnu_id, mnu_cd, mnu_nm, hgr_mnu_id, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
VALUES(nextval('q_mnu_i_01'), 'MN0002201', '관리 데이터 백업', 'MN00022', 'experdb', clock_timestamp(), 'experdb', clock_timestamp());

INSERT INTO t_mnu_i
(mnu_id, mnu_cd, mnu_nm, hgr_mnu_id, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
VALUES(nextval('q_mnu_i_01'), 'MN0002202', '관리 데이터 복원', 'MN00022', 'experdb', clock_timestamp(), 'experdb', clock_timestamp());

INSERT INTO t_usrmnuaut_i
(usr_mnu_aut_id, usr_id, mnu_id, read_aut_yn, wrt_aut_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
select nextval('q_usrmnuaut_i_01'), 'admin',
       (SELECT mnu_id FROM t_mnu_i WHERE mnu_cd = 'MN00022' AND mnu_nm = '백업/복원'),
       'Y', 'Y', 'experdb', clock_timestamp(), 'experdb', clock_timestamp();

--encrypt backup/restore 기본 사용자 권한 설정
INSERT INTO t_usrmnuaut_i
(usr_mnu_aut_id, usr_id, mnu_id, read_aut_yn, wrt_aut_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
select nextval('q_usrmnuaut_i_01'), 'admin',
       (SELECT mnu_id FROM t_mnu_i WHERE mnu_cd = 'MN0002201' AND mnu_nm = '관리 데이터 백업'),
       'Y', 'Y', 'experdb', clock_timestamp(), 'experdb', clock_timestamp();

INSERT INTO t_usrmnuaut_i
(usr_mnu_aut_id, usr_id, mnu_id, read_aut_yn, wrt_aut_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
select nextval('q_usrmnuaut_i_01'), 'admin',
       (SELECT mnu_id FROM t_mnu_i WHERE mnu_cd = 'MN0002202' AND mnu_nm = '관리 데이터 복원'),
       'Y', 'Y', 'experdb', clock_timestamp(), 'experdb', clock_timestamp();
      
--encrypt backup/restore 시스템코드
INSERT INTO t_sysdtl_c
(grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm, sys_cd_nm_en)
VALUES('TC0001', 'DX-T0170', '암호화 백업 화면', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp(), 'Encrypt Backup');

INSERT INTO t_sysdtl_c
(grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm, sys_cd_nm_en)
VALUES('TC0001', 'DX-T0171', '암호화 복원 화면', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp(), 'Encrypt Restore');

INSERT INTO t_sysdtl_c
(grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm, sys_cd_nm_en)
VALUES('TC0001', 'DX-T0170_01', '암호화 백업 실행', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp(), 'Encrypt Backup Run');

INSERT INTO t_sysdtl_c
(grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm, sys_cd_nm_en)
VALUES('TC0001', 'DX-T0171_01', '암호화 복원 실행', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp(), 'Encrypt Restore Run');