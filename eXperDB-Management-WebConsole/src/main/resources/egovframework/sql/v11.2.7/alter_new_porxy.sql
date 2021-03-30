--Proxy 메뉴 추가
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


-- 기본 사용자 Proxy 메뉴 권한 추가 
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
VALUES('TC0001', 'DX-T0159', 'Proxy 설정관리 화면', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp(), 'Proxy Settings');

INSERT INTO t_sysdtl_c
(grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm, sys_cd_nm_en)
VALUES('TC0001', 'DX-T0159_01', 'Proxy 설정관리 - 서버 등록 팝업', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp(), 'Proxy Settings - Server Register');

INSERT INTO t_sysdtl_c
(grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm, sys_cd_nm_en)
VALUES('TC0001', 'DX-T0159_02', 'Proxy 설정관리 - VIP Instance 관리 팝업', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp(), 'Proxy Settings - VIP Instance Management');

INSERT INTO t_sysdtl_c
(grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm, sys_cd_nm_en)
VALUES('TC0001', 'DX-T0159_03', 'Proxy 설정관리 - Proxy Listen 관리 팝업', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp(), 'Proxy Settings - Proxy Listen Management');

INSERT INTO t_sysdtl_c
(grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm, sys_cd_nm_en)
VALUES('TC0001', 'DX-T0159_04', 'Proxy 설정관리 - 서버 정보 등록/수정', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp(), 'Proxy Settings - Proxy Server Info Registration/Modification');

INSERT INTO t_sysdtl_c
(grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm, sys_cd_nm_en)
VALUES('TC0001', 'DX-T0159_05', 'Proxy 설정관리 - VIP Instance 등록', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp(), 'Proxy Settings - Proxy Server Info Modification');

INSERT INTO t_sysdtl_c
(grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm, sys_cd_nm_en)
VALUES('TC0001', 'DX-T0159_06', 'Proxy 설정관리 - 서버 삭제', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp(), 'Proxy Settings - Proxy Server Delete');

INSERT INTO t_sysdtl_c
(grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm, sys_cd_nm_en)
VALUES('TC0001', 'DX-T0159_07', 'Proxy 설정관리 - 서버 정보 조회', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp(), 'Proxy Settings - Proxy Server Info Search');

INSERT INTO t_sysdtl_c
(grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm, sys_cd_nm_en)
VALUES('TC0001', 'DX-T0159_08', 'Proxy 설정관리 - 상세 정보 조회', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp(), 'Proxy Settings - Proxy Detail Info Search');

INSERT INTO t_sysdtl_c
(grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm, sys_cd_nm_en)
VALUES('TC0001', 'DX-T0159_09', 'Proxy 설정관리 - 설정 정보 수정 및 서버 재구동', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp(), 'Proxy Settings - Proxy Server Info Modification');


INSERT INTO t_sysdtl_c
(grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm, sys_cd_nm_en)
VALUES('TC0001', 'DX-T0160', 'Proxy 모니터링', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp(), 'Proxy Monitoring')

INSERT INTO t_sysdtl_c
(grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm, sys_cd_nm_en)
VALUES('TC0001', 'DX-T0160_01', 'Proxy 모니터링 - 리스너 통계 정보 조회', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp(), 'Proxy Listener Statistics')

INSERT INTO t_sysdtl_c
(grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm, sys_cd_nm_en)
VALUES('TC0001', 'DX-T0160_02', 'Proxy 모니터링 - config 파일 조회', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp(), 'Proxy Monitoring Config')

INSERT INTO t_sysdtl_c
(grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm, sys_cd_nm_en)
VALUES('TC0001', 'DX-T0160_03', 'Proxy 모니터링 - Log 파일 조회', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp(), 'Proxy Monitoring Log')



--Proxy 설정 select 코드 등록 
INSERT INTO t_sysgrp_c
(grp_cd, grp_cd_nm, grp_cd_exp, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
VALUES('TC0041', 'Simple Query', 'PROXY Simple Query', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());

INSERT INTO t_sysdtl_c
(grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm, sys_cd_nm_en)
VALUES('TC0041', 'TC004101', 'select haproxy_check();', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp(), 'select haproxy_check();');
INSERT INTO t_sysdtl_c
(grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm, sys_cd_nm_en)
VALUES('TC0041', 'TC004102', 'select 1;', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp(), 'select 1;');




