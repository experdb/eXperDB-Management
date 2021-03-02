--VIP 메뉴 추가
INSERT INTO t_mnu_i
(mnu_id, mnu_cd, mnu_nm, hgr_mnu_id, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
VALUES(43, 'MN00018', '프록시관리', '', 'experdb', clock_timestamp(), 'experdb', clock_timestamp());

INSERT INTO t_mnu_i
(mnu_id, mnu_cd, mnu_nm, hgr_mnu_id, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
VALUES(44, 'MN0001801', '프록시모니터링', 'MN00018', 'experdb', clock_timestamp(), 'experdb', clock_timestamp());

INSERT INTO t_mnu_i
(mnu_id, mnu_cd, mnu_nm, hgr_mnu_id, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
VALUES(45, 'MN0001802', '프록시설정관리', 'MN00018', 'experdb', clock_timestamp(), 'experdb', clock_timestamp());

INSERT INTO t_mnu_i
(mnu_id, mnu_cd, mnu_nm, hgr_mnu_id, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
VALUES(46, 'MN0001803', '프록시상태이력관리', 'MN00018', 'experdb', clock_timestamp(), 'experdb', clock_timestamp());

INSERT INTO t_mnu_i
(mnu_id, mnu_cd, mnu_nm, hgr_mnu_id, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
VALUES(47, 'MN0001804', '프록시변경이력관리', 'MN00018', 'experdb', clock_timestamp(), 'experdb', clock_timestamp());


-- 기본 사용자 VIP 메뉴 권한 추가 
INSERT INTO t_usrmnuaut_i
(usr_mnu_aut_id, usr_id, mnu_id, read_aut_yn, wrt_aut_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
VALUES(85, 'admin', 43, 'Y', 'Y', 'experdb', clock_timestamp(), 'experdb', clock_timestamp());

INSERT INTO t_usrmnuaut_i
(usr_mnu_aut_id, usr_id, mnu_id, read_aut_yn, wrt_aut_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
VALUES(86, 'admin', 44, 'Y', 'Y', 'experdb', clock_timestamp(), 'experdb', clock_timestamp());

INSERT INTO t_usrmnuaut_i
(usr_mnu_aut_id, usr_id, mnu_id, read_aut_yn, wrt_aut_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
VALUES(87, 'admin', 45, 'Y', 'Y', 'experdb', clock_timestamp(), 'experdb', clock_timestamp());

INSERT INTO t_usrmnuaut_i
(usr_mnu_aut_id, usr_id, mnu_id, read_aut_yn, wrt_aut_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
VALUES(88, 'admin', 46, 'N', 'N', 'experdb', clock_timestamp(), 'experdb', clock_timestamp());

INSERT INTO t_usrmnuaut_i
(usr_mnu_aut_id, usr_id, mnu_id, read_aut_yn, wrt_aut_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
VALUES(89, 'admin', 47, 'N', 'N', 'experdb', clock_timestamp(), 'experdb', clock_timestamp());

INSERT INTO t_usrmnuaut_i
(usr_mnu_aut_id, usr_id, mnu_id, read_aut_yn, wrt_aut_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
VALUES(90, 'experdb', 43, 'Y', 'Y', 'experdb', clock_timestamp(), 'experdb', clock_timestamp());

INSERT INTO t_usrmnuaut_i
(usr_mnu_aut_id, usr_id, mnu_id, read_aut_yn, wrt_aut_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
VALUES(91, 'experdb', 44, 'Y', 'Y', 'experdb', clock_timestamp(), 'experdb', clock_timestamp());

INSERT INTO t_usrmnuaut_i
(usr_mnu_aut_id, usr_id, mnu_id, read_aut_yn, wrt_aut_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
VALUES(92, 'experdb', 45, 'Y', 'Y', 'experdb', clock_timestamp(), 'experdb', clock_timestamp());

INSERT INTO t_usrmnuaut_i
(usr_mnu_aut_id, usr_id, mnu_id, read_aut_yn, wrt_aut_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
VALUES(93, 'experdb', 46, 'N', 'N', 'experdb', clock_timestamp(), 'experdb', clock_timestamp());

INSERT INTO t_usrmnuaut_i
(usr_mnu_aut_id, usr_id, mnu_id, read_aut_yn, wrt_aut_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
VALUES(94, 'experdb', 47, 'N', 'N', 'experdb', clock_timestamp(), 'experdb', clock_timestamp());


--접근이력코드 등록
INSERT INTO t_sysdtl_c
(grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm, sys_cd_nm_en)
VALUES('TC0001', 'DX-T0159', 'Proxy 설정관리', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp(), 'Proxy Settings');

INSERT INTO t_sysdtl_c
(grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm, sys_cd_nm_en)
VALUES('TC0001', 'DX-T0159_01', 'Proxy 설정관리 - 서버 등록', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp(), 'Proxy Settings - Server Register');

INSERT INTO t_sysdtl_c
(grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm, sys_cd_nm_en)
VALUES('TC0001', 'DX-T0159_02', 'Proxy 설정관리 - VIP Instance 관리', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp(), 'Proxy Settings - VIP Instance Management');

INSERT INTO t_sysdtl_c
(grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm, sys_cd_nm_en)
VALUES('TC0001', 'DX-T0159_03', 'Proxy 설정관리 - Proxy Listen 관리', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp(), 'Proxy Settings - Proxy Listen Management');


