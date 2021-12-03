--BnR 복원 메뉴 추가
INSERT INTO t_mnu_i
(mnu_id, mnu_cd, mnu_nm, hgr_mnu_id, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
VALUES(nextval('q_mnu_i_01'), 'MN00021', 'Recovery', '', 'experdb', clock_timestamp(), 'experdb', clock_timestamp());

INSERT INTO t_mnu_i
(mnu_id, mnu_cd, mnu_nm, hgr_mnu_id, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
VALUES(nextval('q_mnu_i_01'), 'MN0002101', '완전복구', 'MN00021', 'experdb', clock_timestamp(), 'experdb', clock_timestamp());

INSERT INTO t_mnu_i
(mnu_id, mnu_cd, mnu_nm, hgr_mnu_id, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
VALUES(nextval('q_mnu_i_01'), 'MN0002102', '시점복구', 'MN00021', 'experdb', clock_timestamp(), 'experdb', clock_timestamp());


INSERT INTO t_usrmnuaut_i
(usr_mnu_aut_id, usr_id, mnu_id, read_aut_yn, wrt_aut_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
select nextval('q_usrmnuaut_i_01'), 'admin',
       (SELECT mnu_id FROM t_mnu_i WHERE mnu_cd = 'MN00021' AND mnu_nm = 'Recovery'),
       'Y', 'Y', 'experdb', clock_timestamp(), 'experdb', clock_timestamp();

INSERT INTO t_usrmnuaut_i
(usr_mnu_aut_id, usr_id, mnu_id, read_aut_yn, wrt_aut_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
select nextval('q_usrmnuaut_i_01'), 'admin',
       (SELECT mnu_id FROM t_mnu_i WHERE mnu_cd = 'MN0002101' AND mnu_nm = '완전복구'),
       'Y', 'Y', 'experdb', clock_timestamp(), 'experdb', clock_timestamp();

INSERT INTO t_usrmnuaut_i
(usr_mnu_aut_id, usr_id, mnu_id, read_aut_yn, wrt_aut_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
select nextval('q_usrmnuaut_i_01'), 'admin',
       (SELECT mnu_id FROM t_mnu_i WHERE mnu_cd = 'MN0002102' AND mnu_nm = '시점복구'),
       'Y', 'Y', 'experdb', clock_timestamp(), 'experdb', clock_timestamp();
      



INSERT INTO t_sysdtl_c
(grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm, sys_cd_nm_en)
VALUES('TC0001', 'DX-T0178', '완전복구', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp(), 'Encrypt Backup');

INSERT INTO t_sysdtl_c
(grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm, sys_cd_nm_en)
VALUES('TC0001', 'DX-T0179', '시점복구', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp(), 'Encrypt Backup');




--encrypt backup/restore 메뉴 추가
--mnu_id 59
INSERT INTO t_mnu_i
(mnu_id, mnu_cd, mnu_nm, hgr_mnu_id, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
VALUES(nextval('q_mnu_i_01'), 'MN00022', '백업/복원', '', 'experdb', clock_timestamp(), 'experdb', clock_timestamp());
--mnu_id 60
INSERT INTO t_mnu_i
(mnu_id, mnu_cd, mnu_nm, hgr_mnu_id, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
VALUES(nextval('q_mnu_i_01'), 'MN0002201', '관리 데이터 백업', 'MN00022', 'experdb', clock_timestamp(), 'experdb', clock_timestamp());
--mnu_id 61
INSERT INTO t_mnu_i
(mnu_id, mnu_cd, mnu_nm, hgr_mnu_id, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
VALUES(nextval('q_mnu_i_01'), 'MN0002202', '관리 데이터 복원', 'MN00022', 'experdb', clock_timestamp(), 'experdb', clock_timestamp());

--encrypt backup/restore 기본 사용자 권한 설정
INSERT INTO t_usrmnuaut_i
(usr_mnu_aut_id, usr_id, mnu_id, read_aut_yn, wrt_aut_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
select nextval('q_usrmnuaut_i_01'), 'admin',
       (SELECT mnu_id FROM t_mnu_i WHERE mnu_cd = 'MN00022' AND mnu_nm = '백업/복원'),
       'Y', 'Y', 'experdb', clock_timestamp(), 'experdb', clock_timestamp();

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
VALUES('TC0001', 'DX-T0173', '암호화 백업 화면', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp(), 'Encrypt Backup');

INSERT INTO t_sysdtl_c
(grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm, sys_cd_nm_en)
VALUES('TC0001', 'DX-T0174', '암호화 복원 화면', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp(), 'Encrypt Restore');

INSERT INTO t_sysdtl_c
(grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm, sys_cd_nm_en)
VALUES('TC0001', 'DX-T0173_01', '암호화 백업 실행', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp(), 'Encrypt Backup Run');

INSERT INTO t_sysdtl_c
(grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm, sys_cd_nm_en)
VALUES('TC0001', 'DX-T0174_01', '암호화 복원 실행', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp(), 'Encrypt Restore Run');


-- migration history
CREATE TABLE t_db2pg_mig_history (
	exe_date varchar(50) NULL,
	wrk_nm varchar(100) NULL,
	mig_nm varchar(100) NULL,
	total_table_cnt numeric NULL DEFAULT 0,
	mig_table_cnt numeric NULL DEFAULT 0,
	start_time varchar(100) NULL,
	end_time varchar(100) NULL,
	elapsed_time varchar(100) NULL
);

-- migration history detail
CREATE TABLE t_db2pg_mig_history_detail (
	table_nm varchar(100) NULL,
	mig_nm varchar(100) NULL,
	total_cnt numeric NULL,
	mig_cnt numeric NULL,
	start_time varchar(100) NULL DEFAULT NULL::character varying,
	end_time varchar(100) NULL DEFAULT NULL::character varying,
	elapsed_time varchar(20) NULL DEFAULT NULL::character varying,
	status varchar(30) NULL DEFAULT NULL::character varying
);


INSERT INTO t_mnu_i
(mnu_id, mnu_cd, mnu_nm, hgr_mnu_id, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
VALUES(nextval('q_mnu_i_01'), 'MN00023', 'Migration 모니터링', '', 'experdb', clock_timestamp(), 'experdb', clock_timestamp());


INSERT INTO t_mnu_i
(mnu_id, mnu_cd, mnu_nm, hgr_mnu_id, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
VALUES(nextval('q_mnu_i_01'), 'MN00024', 'Migraion 수행이력', '', 'experdb', clock_timestamp(), 'experdb', clock_timestamp());


INSERT INTO t_usrmnuaut_i
(usr_mnu_aut_id, usr_id, mnu_id, read_aut_yn, wrt_aut_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
select nextval('q_usrmnuaut_i_01'), 'admin',
       (SELECT mnu_id FROM t_mnu_i WHERE mnu_cd = 'MN00023' AND mnu_nm = 'Migration 모니터링'),
       'Y', 'Y', 'experdb', clock_timestamp(), 'experdb', clock_timestamp();

       
INSERT INTO t_usrmnuaut_i
(usr_mnu_aut_id, usr_id, mnu_id, read_aut_yn, wrt_aut_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
select nextval('q_usrmnuaut_i_01'), 'admin',
       (SELECT mnu_id FROM t_mnu_i WHERE mnu_cd = 'MN00024' AND mnu_nm = 'Migraion 수행이력'),
       'Y', 'Y', 'experdb', clock_timestamp(), 'experdb', clock_timestamp();

       
INSERT INTO t_sysdtl_c
(grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm, sys_cd_nm_en)
VALUES('TC0001', 'DX-T0176', 'Migration 모니터링', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp(), 'Encrypt Backup');

INSERT INTO t_sysdtl_c
(grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm, sys_cd_nm_en)
VALUES('TC0001', 'DX-T0177', 'Migration 수행이력', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp(), 'Encrypt Restore');

