--Proxy 메뉴 추가
INSERT INTO t_mnu_i
(mnu_id, mnu_cd, mnu_nm, hgr_mnu_id, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
VALUES(nextval('q_mnu_i_01'), 'MN00018', '프록시관리', '', 'experdb', clock_timestamp(), 'experdb', clock_timestamp());
-- 50

INSERT INTO t_mnu_i
(mnu_id, mnu_cd, mnu_nm, hgr_mnu_id, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
VALUES(nextval('q_mnu_i_01'), 'MN0001801', '프록시모니터링', 'MN00018', 'experdb', clock_timestamp(), 'experdb', clock_timestamp());
-- 51

INSERT INTO t_mnu_i
(mnu_id, mnu_cd, mnu_nm, hgr_mnu_id, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
VALUES(nextval('q_mnu_i_01'), 'MN0001802', '프록시설정관리', 'MN00018', 'experdb', clock_timestamp(), 'experdb', clock_timestamp());
-- 52

INSERT INTO t_mnu_i
(mnu_id, mnu_cd, mnu_nm, hgr_mnu_id, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
VALUES(nextval('q_mnu_i_01'), 'MN0001803', '프록시상태이력관리', 'MN00018', 'experdb', clock_timestamp(), 'experdb', clock_timestamp());
-- 53

INSERT INTO t_mnu_i
(mnu_id, mnu_cd, mnu_nm, hgr_mnu_id, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
VALUES(nextval('q_mnu_i_01'), 'MN0001804', '프록시변경이력관리', 'MN00018', 'experdb', clock_timestamp(), 'experdb', clock_timestamp());
-- 54

INSERT INTO t_mnu_i
(mnu_id, mnu_cd, mnu_nm, hgr_mnu_id, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
VALUES(nextval('q_mnu_i_01'), 'MN0001805', '프록시관리에이전트', 'MN00018', 'experdb', clock_timestamp(), 'experdb', clock_timestamp());
-- 55



-- 기본 사용자 Proxy 메뉴 권한 추가 
INSERT INTO t_usrmnuaut_i
(usr_mnu_aut_id, usr_id, mnu_id, read_aut_yn, wrt_aut_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
select nextval('q_usrmnuaut_i_01'), 'admin',
       (SELECT mnu_id FROM t_mnu_i WHERE mnu_cd = 'MN00018' AND mnu_nm = '프록시관리'),
       'Y', 'Y', 'experdb', clock_timestamp(), 'experdb', clock_timestamp();

INSERT INTO t_usrmnuaut_i
(usr_mnu_aut_id, usr_id, mnu_id, read_aut_yn, wrt_aut_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
select nextval('q_usrmnuaut_i_01'), 'admin',
       (SELECT mnu_id FROM t_mnu_i WHERE mnu_cd = 'MN0001801' AND mnu_nm = '프록시모니터링'),
       'Y', 'Y', 'experdb', clock_timestamp(), 'experdb', clock_timestamp();

INSERT INTO t_usrmnuaut_i
(usr_mnu_aut_id, usr_id, mnu_id, read_aut_yn, wrt_aut_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
select nextval('q_usrmnuaut_i_01'), 'admin',
       (SELECT mnu_id FROM t_mnu_i WHERE mnu_cd = 'MN0001802' AND mnu_nm = '프록시설정관리'),
       'Y', 'Y', 'experdb', clock_timestamp(), 'experdb', clock_timestamp();

INSERT INTO t_usrmnuaut_i
(usr_mnu_aut_id, usr_id, mnu_id, read_aut_yn, wrt_aut_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
select nextval('q_usrmnuaut_i_01'), 'admin',
       (SELECT mnu_id FROM t_mnu_i WHERE mnu_cd = 'MN0001803' AND mnu_nm = '프록시상태이력관리'),
        'Y', 'Y', 'experdb', clock_timestamp(), 'experdb', clock_timestamp();

INSERT INTO t_usrmnuaut_i
(usr_mnu_aut_id, usr_id, mnu_id, read_aut_yn, wrt_aut_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
select nextval('q_usrmnuaut_i_01'), 'admin',
       (SELECT mnu_id FROM t_mnu_i WHERE mnu_cd = 'MN0001804' AND mnu_nm = '프록시변경이력관리'),
        'Y', 'Y', 'experdb', clock_timestamp(), 'experdb', clock_timestamp();

INSERT INTO t_usrmnuaut_i
(usr_mnu_aut_id, usr_id, mnu_id, read_aut_yn, wrt_aut_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
select nextval('q_usrmnuaut_i_01'), 'admin',
       (SELECT mnu_id FROM t_mnu_i WHERE mnu_cd = 'MN0001805' AND mnu_nm = '프록시관리에이전트'),
        'Y', 'Y', 'experdb', clock_timestamp(), 'experdb', clock_timestamp();
     
INSERT INTO t_usrmnuaut_i
(usr_mnu_aut_id, usr_id, mnu_id, read_aut_yn, wrt_aut_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
select nextval('q_usrmnuaut_i_01'), 'experdb',
       (SELECT mnu_id FROM t_mnu_i WHERE mnu_cd = 'MN00018' AND mnu_nm = '프록시관리'),
       'Y', 'Y', 'experdb', clock_timestamp(), 'experdb', clock_timestamp();

 
INSERT INTO t_usrmnuaut_i
(usr_mnu_aut_id, usr_id, mnu_id, read_aut_yn, wrt_aut_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
select nextval('q_usrmnuaut_i_01'), 'experdb',
       (SELECT mnu_id FROM t_mnu_i WHERE mnu_cd = 'MN0001801' AND mnu_nm = '프록시모니터링'),
       'Y', 'Y', 'experdb', clock_timestamp(), 'experdb', clock_timestamp();

       
INSERT INTO t_usrmnuaut_i
(usr_mnu_aut_id, usr_id, mnu_id, read_aut_yn, wrt_aut_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
select nextval('q_usrmnuaut_i_01'), 'experdb',
       (SELECT mnu_id FROM t_mnu_i WHERE mnu_cd = 'MN0001802' AND mnu_nm = '프록시설정관리'),
       'Y', 'Y', 'experdb', clock_timestamp(), 'experdb', clock_timestamp();

INSERT INTO t_usrmnuaut_i
(usr_mnu_aut_id, usr_id, mnu_id, read_aut_yn, wrt_aut_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
select nextval('q_usrmnuaut_i_01'), 'experdb',
       (SELECT mnu_id FROM t_mnu_i WHERE mnu_cd = 'MN0001803' AND mnu_nm = '프록시상태이력관리'),
        'Y', 'Y', 'experdb', clock_timestamp(), 'experdb', clock_timestamp();

INSERT INTO t_usrmnuaut_i
(usr_mnu_aut_id, usr_id, mnu_id, read_aut_yn, wrt_aut_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
select nextval('q_usrmnuaut_i_01'), 'experdb',
       (SELECT mnu_id FROM t_mnu_i WHERE mnu_cd = 'MN0001804' AND mnu_nm = '프록시변경이력관리'),
        'Y', 'Y', 'experdb', clock_timestamp(), 'experdb', clock_timestamp();

INSERT INTO t_usrmnuaut_i
(usr_mnu_aut_id, usr_id, mnu_id, read_aut_yn, wrt_aut_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
select nextval('q_usrmnuaut_i_01'), 'experdb',
       (SELECT mnu_id FROM t_mnu_i WHERE mnu_cd = 'MN0001805' AND mnu_nm = '프록시관리에이전트'),
        'Y', 'Y', 'experdb', clock_timestamp(), 'experdb', clock_timestamp();
   
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
VALUES('TC0001', 'DX-T0160', 'Proxy 모니터링', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp(), 'Proxy Monitoring');

INSERT INTO t_sysdtl_c
(grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm, sys_cd_nm_en)
VALUES('TC0001', 'DX-T0160_01', 'Proxy 모니터링 - 리스너 통계 정보 조회', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp(), 'Proxy Listener Statistics');

INSERT INTO t_sysdtl_c
(grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm, sys_cd_nm_en)
VALUES('TC0001', 'DX-T0160_02', 'Proxy 모니터링 - config 파일 조회', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp(), 'Proxy Monitoring Config');

INSERT INTO t_sysdtl_c
(grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm, sys_cd_nm_en)
VALUES('TC0001', 'DX-T0160_03', 'Proxy 모니터링 - Log 파일 조회', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp(), 'Proxy Monitoring Log');

INSERT INTO t_sysdtl_c
(grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm, sys_cd_nm_en)
VALUES('TC0001', 'DX-T0161', 'Proxy 관리 에이전트 화면', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp(), 'Proxy Management Agent');

INSERT INTO t_sysdtl_c
(grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm, sys_cd_nm_en)
VALUES('TC0001', 'DX-T0161_01', 'Proxy 관리 에이전트  화면 조회', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp(), 'Proxy Management Agent');

INSERT INTO t_sysdtl_c
(grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm, sys_cd_nm_en)
VALUES('TC0001', 'DX-T0167', 'Proxy 이력 관리 화면', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp(), 'Proxy History Management');

INSERT INTO t_sysdtl_c
(grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm, sys_cd_nm_en)
VALUES('TC0001', 'DX-T0167_01', 'Proxy 이력 관리 화면 - Conf 파일 확인 팝업', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp(), 'Proxy History Management - Conf Popup');

INSERT INTO t_sysdtl_c
(grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm, sys_cd_nm_en)
VALUES('TC0001', 'DX-T0167_02', 'Proxy 이력 관리 화면 - 설정 변경 이력 조회', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp(), 'Proxy Settings History - Conf Popup');

INSERT INTO t_sysdtl_c
(grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm, sys_cd_nm_en)
VALUES('TC0001', 'DX-T0167_03', 'Proxy 이력 관리 화면 - 상태 변경 이력 조회', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp(), 'Proxy Settings History - Conf Popup');


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

--Proxy listener명 코드 등록

INSERT INTO t_sysgrp_c
(grp_cd, grp_cd_nm, grp_cd_exp, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
VALUES('TC0042', 'Listener Name', 'PROXY Listener Name', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());

INSERT INTO t_sysdtl_c
(grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm, sys_cd_nm_en)
VALUES('TC0042', 'TC004201', 'pgReadWrite', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp(), 'pgReadWrite');
INSERT INTO t_sysdtl_c
(grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm, sys_cd_nm_en)
VALUES('TC0042', 'TC004202', 'pgReadOnly', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp(), 'pgReadOnly');



