--BnR 설정 메뉴 추가
INSERT INTO t_mnu_i
(mnu_id, mnu_cd, mnu_nm, hgr_mnu_id, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
VALUES(nextval('q_mnu_i_01'), 'MN00019', 'BnR 설정', '', 'experdb', clock_timestamp(), 'experdb', clock_timestamp());

INSERT INTO t_mnu_i
(mnu_id, mnu_cd, mnu_nm, hgr_mnu_id, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
VALUES(nextval('q_mnu_i_01'), 'MN0001901', '모니터링', 'MN00019', 'experdb', clock_timestamp(), 'experdb', clock_timestamp());

INSERT INTO t_mnu_i
(mnu_id, mnu_cd, mnu_nm, hgr_mnu_id, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
VALUES(nextval('q_mnu_i_01'), 'MN0001902', '백업이력 관리', 'MN00019', 'experdb', clock_timestamp(), 'experdb', clock_timestamp());

INSERT INTO t_mnu_i
(mnu_id, mnu_cd, mnu_nm, hgr_mnu_id, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
VALUES(nextval('q_mnu_i_01'), 'MN0001903', '복구이력 관리', 'MN00019', 'experdb', clock_timestamp(), 'experdb', clock_timestamp());

--Backup 메뉴 추가
INSERT INTO t_mnu_i
(mnu_id, mnu_cd, mnu_nm, hgr_mnu_id, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
VALUES(nextval('q_mnu_i_01'), 'MN00020', 'Backup', '', 'experdb', clock_timestamp(), 'experdb', clock_timestamp());


INSERT INTO t_mnu_i
(mnu_id, mnu_cd, mnu_nm, hgr_mnu_id, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
VALUES(nextval('q_mnu_i_01'), 'MN0002001', 'Storage 설정', 'MN00020', 'experdb', clock_timestamp(), 'experdb', clock_timestamp());

INSERT INTO t_mnu_i
(mnu_id, mnu_cd, mnu_nm, hgr_mnu_id, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
VALUES(nextval('q_mnu_i_01'), 'MN0002002', '정책설정', 'MN00020', 'experdb', clock_timestamp(), 'experdb', clock_timestamp());



-- admin유저 BnR 설정 메뉴 권한 추가 
INSERT INTO t_usrmnuaut_i
(usr_mnu_aut_id, usr_id, mnu_id, read_aut_yn, wrt_aut_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
select nextval('q_usrmnuaut_i_01'), 'admin',
       (SELECT mnu_id FROM t_mnu_i WHERE mnu_cd = 'MN00019' AND mnu_nm = 'BnR 설정'),
       'Y', 'Y', 'experdb', clock_timestamp(), 'experdb', clock_timestamp();

INSERT INTO t_usrmnuaut_i
(usr_mnu_aut_id, usr_id, mnu_id, read_aut_yn, wrt_aut_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
select nextval('q_usrmnuaut_i_01'), 'admin',
       (SELECT mnu_id FROM t_mnu_i WHERE mnu_cd = 'MN0001901' AND mnu_nm = '모니터링'),
       'Y', 'Y', 'experdb', clock_timestamp(), 'experdb', clock_timestamp();

INSERT INTO t_usrmnuaut_i
(usr_mnu_aut_id, usr_id, mnu_id, read_aut_yn, wrt_aut_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
select nextval('q_usrmnuaut_i_01'), 'admin',
       (SELECT mnu_id FROM t_mnu_i WHERE mnu_cd = 'MN0001902' AND mnu_nm = '백업이력 관리'),
       'Y', 'Y', 'experdb', clock_timestamp(), 'experdb', clock_timestamp();

INSERT INTO t_usrmnuaut_i
(usr_mnu_aut_id, usr_id, mnu_id, read_aut_yn, wrt_aut_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
select nextval('q_usrmnuaut_i_01'), 'admin',
       (SELECT mnu_id FROM t_mnu_i WHERE mnu_cd = 'MN0001903' AND mnu_nm = '복구이력 관리'),
        'Y', 'Y', 'experdb', clock_timestamp(), 'experdb', clock_timestamp();

             
-- admin유저 Backup 메뉴 권한 추가     
INSERT INTO t_usrmnuaut_i
(usr_mnu_aut_id, usr_id, mnu_id, read_aut_yn, wrt_aut_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
select nextval('q_usrmnuaut_i_01'), 'admin',
       (SELECT mnu_id FROM t_mnu_i WHERE mnu_cd = 'MN00020' AND mnu_nm = 'Backup'),
       'Y', 'Y', 'experdb', clock_timestamp(), 'experdb', clock_timestamp();

INSERT INTO t_usrmnuaut_i
(usr_mnu_aut_id, usr_id, mnu_id, read_aut_yn, wrt_aut_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
select nextval('q_usrmnuaut_i_01'), 'admin',
       (SELECT mnu_id FROM t_mnu_i WHERE mnu_cd = 'MN0002001' AND mnu_nm = 'Storage 설정'),
        'Y', 'Y', 'experdb', clock_timestamp(), 'experdb', clock_timestamp();
     
INSERT INTO t_usrmnuaut_i
(usr_mnu_aut_id, usr_id, mnu_id, read_aut_yn, wrt_aut_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
select nextval('q_usrmnuaut_i_01'), 'admin',
       (SELECT mnu_id FROM t_mnu_i WHERE mnu_cd = 'MN0002002' AND mnu_nm = '정책설정'),
        'Y', 'Y', 'experdb', clock_timestamp(), 'experdb', clock_timestamp();      
        
        
        
        
-- experdb유저 BnR 설정 메뉴 권한 추가 
INSERT INTO t_usrmnuaut_i
(usr_mnu_aut_id, usr_id, mnu_id, read_aut_yn, wrt_aut_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
select nextval('q_usrmnuaut_i_01'), 'experdb',
       (SELECT mnu_id FROM t_mnu_i WHERE mnu_cd = 'MN00019' AND mnu_nm = 'BnR 설정'),
       'Y', 'Y', 'experdb', clock_timestamp(), 'experdb', clock_timestamp();

INSERT INTO t_usrmnuaut_i
(usr_mnu_aut_id, usr_id, mnu_id, read_aut_yn, wrt_aut_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
select nextval('q_usrmnuaut_i_01'), 'experdb',
       (SELECT mnu_id FROM t_mnu_i WHERE mnu_cd = 'MN0001901' AND mnu_nm = '모니터링'),
       'Y', 'Y', 'experdb', clock_timestamp(), 'experdb', clock_timestamp();

INSERT INTO t_usrmnuaut_i
(usr_mnu_aut_id, usr_id, mnu_id, read_aut_yn, wrt_aut_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
select nextval('q_usrmnuaut_i_01'), 'experdb',
       (SELECT mnu_id FROM t_mnu_i WHERE mnu_cd = 'MN0001902' AND mnu_nm = '백업이력 관리'),
       'Y', 'Y', 'experdb', clock_timestamp(), 'experdb', clock_timestamp();

INSERT INTO t_usrmnuaut_i
(usr_mnu_aut_id, usr_id, mnu_id, read_aut_yn, wrt_aut_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
select nextval('q_usrmnuaut_i_01'), 'experdb',
       (SELECT mnu_id FROM t_mnu_i WHERE mnu_cd = 'MN0001903' AND mnu_nm = '복구이력 관리'),
        'Y', 'Y', 'experdb', clock_timestamp(), 'experdb', clock_timestamp();

             
-- experdb Backup 메뉴 권한 추가     
INSERT INTO t_usrmnuaut_i
(usr_mnu_aut_id, usr_id, mnu_id, read_aut_yn, wrt_aut_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
select nextval('q_usrmnuaut_i_01'), 'experdb',
       (SELECT mnu_id FROM t_mnu_i WHERE mnu_cd = 'MN00020' AND mnu_nm = 'Backup'),
       'Y', 'Y', 'experdb', clock_timestamp(), 'experdb', clock_timestamp();

INSERT INTO t_usrmnuaut_i
(usr_mnu_aut_id, usr_id, mnu_id, read_aut_yn, wrt_aut_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
select nextval('q_usrmnuaut_i_01'), 'experdb',
       (SELECT mnu_id FROM t_mnu_i WHERE mnu_cd = 'MN0002001' AND mnu_nm = 'Storage 설정'),
        'Y', 'Y', 'experdb', clock_timestamp(), 'experdb', clock_timestamp();
     
INSERT INTO t_usrmnuaut_i
(usr_mnu_aut_id, usr_id, mnu_id, read_aut_yn, wrt_aut_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
select nextval('q_usrmnuaut_i_01'), 'experdb',
       (SELECT mnu_id FROM t_mnu_i WHERE mnu_cd = 'MN0002002' AND mnu_nm = '정책설정'),
        'Y', 'Y', 'experdb', clock_timestamp(), 'experdb', clock_timestamp();      
        
        
        
        
        
        
        
        
        
        
-- Storage설정 화면 접근이력코드 등록
INSERT INTO t_sysdtl_c
(grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm, sys_cd_nm_en)
VALUES('TC0001', 'DX-T0162', 'Storage설정 화면', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp(), 'Storage Settings');

-- Storage 등록 팝업 화면 접근이력코드 등록
INSERT INTO t_sysdtl_c
(grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm, sys_cd_nm_en)
VALUES('TC0001', 'DX-T0162_01', 'Storage설정 - Storage 등록 팝업', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp(), 'Storage Settings - Storage Register');

-- Storage 수정 팝업 화면 접근이력코드 등록
INSERT INTO t_sysdtl_c
(grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm, sys_cd_nm_en)
VALUES('TC0001', 'DX-T0162_02', 'Storage설정 - Storage 수정 팝업', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp(), 'Storage Settings - Storage Modification');


-- 백업 정책설정 화면 접근이력코드 등록
INSERT INTO t_sysdtl_c
(grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm, sys_cd_nm_en)
VALUES('TC0001', 'DX-T0163', '백업 정책설정 화면', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp(), 'Backup Policy Settings');

-- 대상서버 등록 팝업 접근이력코드 등록
INSERT INTO t_sysdtl_c
(grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm, sys_cd_nm_en)
VALUES('TC0001', 'DX-T0163_01', '백업 정책설정 - 대상서버 등록 팝업', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp(), 'Backup Policy Settings - TagetServer Register');

-- 대상서버 수정 팝업 접근이력코드 등록
INSERT INTO t_sysdtl_c
(grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm, sys_cd_nm_en)
VALUES('TC0001', 'DX-T0163_02', '백업 정책설정 - 대상서버 등록/수정 팝업', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp(), 'Backup Policy Settings - TagetServer Modification');

-- 풀백업 정책 등록/수정 팝업 접근이력코드 등록
INSERT INTO t_sysdtl_c
(grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm, sys_cd_nm_en)
VALUES('TC0001', 'DX-T0163_03', '백업 정책설정 - 풀백업 정책 등록/수정 팝업', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp(), 'Backup Policy Settings - FullBackup Register/Modification');

-- 증분백업 등록/수정 팝업 접근이력코드 등록
INSERT INTO t_sysdtl_c
(grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm, sys_cd_nm_en)
VALUES('TC0001', 'DX-T0163_04', '백업 정책설정 - 증분백업 등록/수정 팝업', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp(), 'Backup Policy Settings - Increment Register/Modification');

-- 백업이력 관리 화면 접근이력코드 등록
INSERT INTO t_sysdtl_c
(grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm, sys_cd_nm_en)
VALUES('TC0001', 'DX-T0164', '백업이력 관리 화면', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp(), 'Storage Settings');

-- 복구이력 관리 화면 접근이력코드 등록
INSERT INTO t_sysdtl_c
(grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm, sys_cd_nm_en)
VALUES('TC0001', 'DX-T0165', '복구이력 관리 화면', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp(), 'Storage Settings');

-- 백업 모니터링 화면 접근이력코드 등록
INSERT INTO t_sysdtl_c
(grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm, sys_cd_nm_en)
VALUES('TC0001', 'DX-T0166', '백업 모니터링 화면', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp(), 'Backup Monitoring');

-- 즉시수행 접근이력코드 등록
INSERT INTO t_sysdtl_c
(grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm, sys_cd_nm_en)
VALUES('TC0001', 'DX-T0166_01', '즉시수행 팝업 화면', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp(), 'Backup RunNow');




