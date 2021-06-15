create table t_db2pg_ddl_wrk_inf
(
	db2pg_ddl_wrk_id     numeric not null,
	wrk_id               numeric(18) null,
	db2pg_sys_id         numeric(18) not null,
	db2pg_uchr_lchr_val  varchar(50) null,
	src_tb_ddl_exrt_tf   boolean null,
	ddl_save_pth         varchar(300) null,
	db2pg_exrt_trg_tb_wrk_id numeric null,
	db2pg_exrt_exct_tb_wrk_id numeric null,
	frst_regr_id         varchar(30) null,
	frst_reg_dtm         timestamp not null,
	lst_mdfr_id          varchar(30) null,
	lst_mdf_dtm          timestamp not null
);


create table t_db2pg_exrtexct_srctb_ls
(
	db2pg_exrt_exct_tb_wrk_id numeric not null,
	exrt_exct_tb_nm      text null,
	exrt_exct_scm_nm     text null,
	src_table_total_cnt numeric null,
	frst_regr_id         varchar(30) null,
	frst_reg_dtm         timestamp not null
);


create table t_db2pg_exrttrg_srctb_ls
(
	db2pg_exrt_trg_tb_wrk_id numeric not null,
	exrt_trg_tb_nm       text null,
	exrt_trg_scm_nm      text null,
	src_table_total_cnt numeric null,
	frst_regr_id         varchar(30) null,
	frst_reg_dtm         timestamp not null
);

create table t_db2pg_sys_inf
(
	db2pg_sys_id         numeric(18) not null,
	db2pg_sys_nm         varchar(50) not null,
	dbms_dscd            varchar(8) not null,
	ipadr                varchar(30) not null,
	dtb_nm               varchar(200) not null,
	spr_usr_id           varchar(30) not null,
	portno               numeric(5) not null,
	scm_nm               varchar(50) null,
	pwd                  varchar(100) null,
	crts_nm              varchar(50) null,
	frst_regr_id         varchar(30) null,
	frst_reg_dtm         timestamp not null default clock_timestamp(),
	lst_mdfr_id          varchar(30) null,
	lst_mdf_dtm          timestamp not null default clock_timestamp()
);


create table t_db2pg_trsf_wrk_inf
(
	db2pg_trsf_wrk_id    numeric not null,
	wrk_id               numeric(18) null,
	db2pg_src_sys_id 	 numeric(18) not null,
	db2pg_trg_sys_id     numeric(18) null,
	exrt_dat_cnt         numeric not null,
	db2pg_exrt_trg_tb_wrk_id numeric null,
	db2pg_exrt_exct_tb_wrk_id numeric null,
	exrt_dat_ftch_sz     numeric(18) not null default 0,
	dat_ftch_bff_sz      numeric(18) not null default 0,
	exrt_prl_prcs_ecnt   bigint not null default 0,
	lob_dat_bff_sz       numeric(18) not null default 0,
	usr_qry_use_tf       boolean null,
	db2pg_usr_qry_id     numeric null,
	ins_opt_cd           varchar(8) null,
	tb_rbl_tf            boolean null,
	cnst_cnd_exrt_tf     boolean null,
	frst_regr_id         varchar(30) null,
	frst_reg_dtm         timestamp not null,
	lst_mdfr_id          varchar(30) null,
	lst_mdf_dtm          timestamp not null,
	trans_save_pth       varchar(300) null,
	src_cnd_qry          text null
);


create table t_db2pg_usrqry_ls
(
	db2pg_usr_qry_id     numeric not null,
	usr_qry_exp          text null,
	frst_regr_id         varchar(30) null,
	frst_reg_dtm         timestamp not null,
	lst_mdfr_id          varchar(30) null,
	lst_mdf_dtm          timestamp not null
);

create table t_migexe_g
(
	mig_exe_sn           numeric not null,
	mig_dscd             varchar(8) not null,
	wrk_strt_dtm         varchar(30) null,
	wrk_end_dtm          varchar(30) null,
	exe_rslt_cd          varchar(20) null,
	rslt_msg             varchar(1000) null,
	frst_regr_id         varchar(30) null,
	frst_reg_dtm         timestamp not null default clock_timestamp(),
	lst_mdfr_id          varchar(30) null,
	lst_mdf_dtm          timestamp not null default clock_timestamp(),
	wrk_id               numeric(18) null
);


comment on table t_db2pg_ddl_wrk_inf is 'db2pg_ddl_작업_정보';

 comment on column t_db2pg_ddl_wrk_inf.db2pg_ddl_wrk_id is 'db2pg_ddl_작업_id';
 comment on column t_db2pg_ddl_wrk_inf.wrk_id is '작업_id';
 comment on column t_db2pg_ddl_wrk_inf.db2pg_sys_id is 'db2pg_시스템_id';
 comment on column t_db2pg_ddl_wrk_inf.db2pg_uchr_lchr_val is 'db2pg_대문자_소문자_값';
 comment on column t_db2pg_ddl_wrk_inf.src_tb_ddl_exrt_tf is '소스_테이블_ddl_추출_유무';
 comment on column t_db2pg_ddl_wrk_inf.ddl_save_pth is 'ddl_저장_경로';
 comment on column t_db2pg_ddl_wrk_inf.db2pg_exrt_trg_tb_wrk_id is 'db2pg_추출_대상_테이블_작업_id';
 comment on column t_db2pg_ddl_wrk_inf.db2pg_exrt_exct_tb_wrk_id is 'db2pg_추출_제외_테이블_작업_id';
 comment on column t_db2pg_ddl_wrk_inf.frst_regr_id is '최초_등록자_id';
 comment on column t_db2pg_ddl_wrk_inf.frst_reg_dtm is '최초_등록_일시';
 comment on column t_db2pg_ddl_wrk_inf.lst_mdfr_id is '최종_수정자_id';
 comment on column t_db2pg_ddl_wrk_inf.lst_mdf_dtm is '최종_수정_일시';
 
alter table t_db2pg_exrtexct_srctb_ls add constraint pk_t_db2pg_exrtexct_srctb_ls 
primary key (db2pg_exrt_exct_tb_wrk_id);

comment on table t_db2pg_exrtexct_srctb_ls is 'db2pg_추출제외_소스테이블_내역';

 comment on column t_db2pg_exrtexct_srctb_ls.db2pg_exrt_exct_tb_wrk_id is 'db2pg_추출_제외_테이블_작업_id';
 comment on column t_db2pg_exrtexct_srctb_ls.exrt_exct_tb_nm is '추출_제외_테이블_명';
 comment on column t_db2pg_exrtexct_srctb_ls.exrt_exct_scm_nm is '추출_제외_스키마_명';
 comment on column t_db2pg_exrtexct_srctb_ls.src_table_total_cnt is '추출_제외_전체_테이블수';
 comment on column t_db2pg_exrtexct_srctb_ls.frst_regr_id is '최초_등록자_id';
 comment on column t_db2pg_exrtexct_srctb_ls.frst_reg_dtm is '최초_등록_일시';
 
 
alter table t_db2pg_exrttrg_srctb_ls add constraint pk_t_db2pg_exrttrg_srctb_ls 
primary key (db2pg_exrt_trg_tb_wrk_id);

comment on table t_db2pg_exrttrg_srctb_ls is 'db2pg_추출대상_소스테이블_내역';

 comment on column t_db2pg_exrttrg_srctb_ls.db2pg_exrt_trg_tb_wrk_id is 'db2pg_추출_대상_테이블_작업_id';
 comment on column t_db2pg_exrttrg_srctb_ls.exrt_trg_tb_nm is '추출_대상_테이블_명';
 comment on column t_db2pg_exrttrg_srctb_ls.exrt_trg_scm_nm is '추출_대상_스키마_명';
 comment on column t_db2pg_exrttrg_srctb_ls.src_table_total_cnt is '추출_대상_전체_테이블수';
 comment on column t_db2pg_exrttrg_srctb_ls.frst_regr_id is '최초_등록자_id';
 comment on column t_db2pg_exrttrg_srctb_ls.frst_reg_dtm is '최초_등록_일시';
 
alter table t_db2pg_sys_inf add constraint pk_t_db2pg_sys_inf 
primary key (db2pg_sys_id);

comment on table t_db2pg_sys_inf is 'db2pg_시스템_정보';

 comment on column t_db2pg_sys_inf.db2pg_sys_id is 'db2pg_시스템_id';
 comment on column t_db2pg_sys_inf.db2pg_sys_nm is 'db2pg_시스템_명';
 comment on column t_db2pg_sys_inf.dbms_dscd is 'dbms_구분코드';
 comment on column t_db2pg_sys_inf.ipadr is 'ip주소';
 comment on column t_db2pg_sys_inf.dtb_nm is '데이터베이스_명';
 comment on column t_db2pg_sys_inf.spr_usr_id is '슈퍼_사용자_id';
 comment on column t_db2pg_sys_inf.portno is '포트번호';
 comment on column t_db2pg_sys_inf.scm_nm is '스키마_명';
 comment on column t_db2pg_sys_inf.pwd is '비밀번호';
 comment on column t_db2pg_sys_inf.crts_nm is '캐릭터셋_명';
 comment on column t_db2pg_sys_inf.frst_regr_id is '최초_등록자_id';
 comment on column t_db2pg_sys_inf.frst_reg_dtm is '최초_등록_일시';
 comment on column t_db2pg_sys_inf.lst_mdfr_id is '최종_수정자_id';
 comment on column t_db2pg_sys_inf.lst_mdf_dtm is '최종_수정_일시';
 
alter table t_db2pg_trsf_wrk_inf add constraint pk_t_db2pg_trsf_wrk_inf 
primary key (db2pg_trsf_wrk_id);

comment on table t_db2pg_trsf_wrk_inf is 'db2pg_이행_작업_정보';

 comment on column t_db2pg_trsf_wrk_inf.db2pg_trsf_wrk_id is 'db2pg_이행_작업_id';
 comment on column t_db2pg_trsf_wrk_inf.wrk_id is '작업_id';
 comment on column t_db2pg_trsf_wrk_inf.db2pg_src_sys_id is 'db2pg_소스_시스템_id';
 comment on column t_db2pg_trsf_wrk_inf.db2pg_trg_sys_id is 'db2pg_대상_시스템_id';
 comment on column t_db2pg_trsf_wrk_inf.exrt_dat_cnt is '추출_데이터_건수';
 comment on column t_db2pg_trsf_wrk_inf.db2pg_exrt_trg_tb_wrk_id is 'db2pg_추출_대상_테이블_작업_id';
 comment on column t_db2pg_trsf_wrk_inf.db2pg_exrt_exct_tb_wrk_id is 'db2pg_추출_제외_테이블_작업_id';
 comment on column t_db2pg_trsf_wrk_inf.exrt_dat_ftch_sz is '추출_데이터_패치_사이즈';
 comment on column t_db2pg_trsf_wrk_inf.dat_ftch_bff_sz is '데이터_패치_버퍼_사이즈';
 comment on column t_db2pg_trsf_wrk_inf.exrt_prl_prcs_ecnt is '추출_병렬_처리_개수';
 comment on column t_db2pg_trsf_wrk_inf.lob_dat_bff_sz is 'lob_데이터_버퍼_사이즈';
 comment on column t_db2pg_trsf_wrk_inf.usr_qry_use_tf is '사용자_쿼리_사용_유무';
 comment on column t_db2pg_trsf_wrk_inf.db2pg_usr_qry_id is 'db2pg_사용자_쿼리_id';
 comment on column t_db2pg_trsf_wrk_inf.ins_opt_cd is '입력_옵션_코드';
 comment on column t_db2pg_trsf_wrk_inf.tb_rbl_tf is '테이블_리빌드_유무';
 comment on column t_db2pg_trsf_wrk_inf.cnst_cnd_exrt_tf is '제약_조건_추출_유무';
 comment on column t_db2pg_trsf_wrk_inf.frst_regr_id is '최초_등록자_id';
 comment on column t_db2pg_trsf_wrk_inf.frst_reg_dtm is '최초_등록_일시';
 comment on column t_db2pg_trsf_wrk_inf.lst_mdfr_id is '최종_수정자_id';
 comment on column t_db2pg_trsf_wrk_inf.lst_mdf_dtm is '최종_수정_일시';
 comment on column t_db2pg_trsf_wrk_inf.trans_save_pth is 'trans_저장_경로';
 comment on column t_db2pg_trsf_wrk_inf.src_cnd_qry is '소스_조건_쿼리';
 
alter table t_db2pg_usrqry_ls add constraint pk_t_db2pg_usrqry_ls 
primary key (db2pg_usr_qry_id);

comment on table t_db2pg_usrqry_ls is 'db2pg_사용자쿼리_내역';

 comment on column t_db2pg_usrqry_ls.db2pg_usr_qry_id is 'db2pg_사용자_쿼리_id';
 comment on column t_db2pg_usrqry_ls.usr_qry_exp is '사용자_쿼리_설명';
 comment on column t_db2pg_usrqry_ls.frst_regr_id is '최초_등록자_id';
 comment on column t_db2pg_usrqry_ls.frst_reg_dtm is '최초_등록_일시';
 comment on column t_db2pg_usrqry_ls.lst_mdfr_id is '최종_수정자_id';
 comment on column t_db2pg_usrqry_ls.lst_mdf_dtm is '최종_수정_일시';
 
 
 alter table t_migexe_g add constraint pk_t_migexe_g 
primary key (mig_exe_sn);

comment on table t_migexe_g is '즉시실행로그';

 comment on column t_migexe_g.mig_exe_sn is '이행_실행_일련번호';
 comment on column t_migexe_g.mig_dscd is 'migration_구분코드';
 comment on column t_migexe_g.wrk_strt_dtm is '작업_시작_일시';
 comment on column t_migexe_g.wrk_end_dtm is '작업_종료_일시';
 comment on column t_migexe_g.exe_rslt_cd is '실행_결과_코드';
 comment on column t_migexe_g.rslt_msg is '결과_메시지';
 comment on column t_migexe_g.frst_regr_id is '최초_등록자_id';
 comment on column t_migexe_g.frst_reg_dtm is '최초_등록_일시';
 comment on column t_migexe_g.lst_mdfr_id is '최종_수정자_id';
 comment on column t_migexe_g.lst_mdf_dtm is '최종_수정_일시';
 comment on column t_migexe_g.wrk_id is '작업_id';
 
alter table t_db2pg_ddl_wrk_inf
add constraint  fk_t_db2pg_ddl_wrk_inf_01 foreign key (db2pg_exrt_trg_tb_wrk_id) references t_db2pg_exrttrg_srctb_ls (db2pg_exrt_trg_tb_wrk_id);

alter table t_db2pg_ddl_wrk_inf
add constraint fk_t_db2pg_ddl_wrk_inf_02 foreign key (db2pg_sys_id) references t_db2pg_sys_inf (db2pg_sys_id);

alter table t_db2pg_ddl_wrk_inf
add constraint fk_t_db2pg_ddl_wrk_inf_03 foreign key (db2pg_exrt_exct_tb_wrk_id) references t_db2pg_exrtexct_srctb_ls (db2pg_exrt_exct_tb_wrk_id);

alter table t_db2pg_ddl_wrk_inf
add constraint fk_t_db2pg_ddl_wrk_inf_04 foreign key (wrk_id) references t_wrkcng_i (wrk_id);

alter table t_db2pg_trsf_wrk_inf
add constraint fk_t_db2pg_trsf_wrk_inf_01 foreign key (db2pg_exrt_trg_tb_wrk_id) references t_db2pg_exrttrg_srctb_ls (db2pg_exrt_trg_tb_wrk_id);

alter table t_db2pg_trsf_wrk_inf
add constraint fk_t_db2pg_trsf_wrk_inf_02 foreign key (db2pg_exrt_exct_tb_wrk_id) references t_db2pg_exrtexct_srctb_ls (db2pg_exrt_exct_tb_wrk_id);

alter table t_db2pg_trsf_wrk_inf
add constraint fk_t_db2pg_trsf_wrk_inf_03 foreign key (db2pg_usr_qry_id) references t_db2pg_usrqry_ls (db2pg_usr_qry_id);

alter table t_db2pg_trsf_wrk_inf
add constraint fk_t_db2pg_trsf_wrk_inf_04 foreign key (wrk_id) references t_wrkcng_i (wrk_id);

alter table t_db2pg_ddl_wrk_inf add constraint pk_t_db2pg_ddl_wrk_inf 
primary key (db2pg_ddl_wrk_id);
 
ALTER TABLE t_migexe_g ADD COLUMN save_pth varchar(300);
ALTER TABLE t_db2pg_trsf_wrk_inf add column db2pg_uchr_lchr_val varchar(50);

create sequence q_db2pg_ddl_wrk_inf_01;
create sequence q_db2pg_sys_inf_01;
create sequence q_db2pg_trsf_wrk_inf_01;
create sequence q_db2pg_usrqry_ls_01;
create sequence q_db2pg_exrtexct_srctb_ls_01;
create sequence q_db2pg_exrttrg_srctb_ls_01;
create sequence q_t_migexe_g_01;


INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0019', 'TC001903', 'MIGRATION', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());

INSERT INTO T_SYSGRP_C(GRP_CD, GRP_CD_NM, GRP_CD_EXP, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0022', 'DBMS구분', '', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSGRP_C(GRP_CD, GRP_CD_NM, GRP_CD_EXP, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0023', '케릭터셋(ORACLE)', '', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSGRP_C(GRP_CD, GRP_CD_NM, GRP_CD_EXP, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0024', '케릭터셋(TIBERO)', '', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSGRP_C(GRP_CD, GRP_CD_NM, GRP_CD_EXP, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0025', '케릭터셋(DB2)', '', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSGRP_C(GRP_CD, GRP_CD_NM, GRP_CD_EXP, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0026', '케릭터셋(SyBaseASE)', '', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSGRP_C(GRP_CD, GRP_CD_NM, GRP_CD_EXP, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0027', '케릭터셋(MySQL)', '', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSGRP_C(GRP_CD, GRP_CD_NM, GRP_CD_EXP, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0028', '대소문자구분', '', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSGRP_C(GRP_CD, GRP_CD_NM, GRP_CD_EXP, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0029', '옵션여부', '', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSGRP_C(GRP_CD, GRP_CD_NM, GRP_CD_EXP, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0030', '입력모드', '', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSGRP_C(GRP_CD, GRP_CD_NM, GRP_CD_EXP, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0031', '케릭터셋(CUBRID)', '', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSGRP_C(GRP_CD, GRP_CD_NM, GRP_CD_EXP, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0032', '이행구분', '', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());


INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0001', 'DX-T0134', '소스/타겟 DBMS 관리 화면', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0001', 'DX-T0134_01', '소스/타겟 DBMS 조회', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0001', 'DX-T0134_02', '소스/타겟 DBMS 삭제', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0001', 'DX-T0135', '소스/타겟 DBMS 등록 팝업', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0001', 'DX-T0135_01', '소스/타겟 DBMS 등록', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0001', 'DX-T0136', '소스/타겟 DBMS 수정 팝업', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0001', 'DX-T0136_01', '소스/타겟 DBMS 수정', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0001', 'DX-T0137', '설정정보관리 화면', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0001', 'DX-T0137_01', 'DDL 설정정보 조회', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0001', 'DX-T0137_02', 'DDL 설정정보 삭제', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0001', 'DX-T0137_03', 'DDL 설정정보 복제', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0001', 'DX-T0137_04', 'DDL 설정정보 즉시실행', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0001', 'DX-T0138', 'DDL 설정정보 등록 팝업', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0001', 'DX-T0138_01', 'DDL 설정정보 등록', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0001', 'DX-T0139', 'DDL 설정정보 수정 팝업', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0001', 'DX-T0139_01', 'DDL 설정정보 수정', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0001', 'DX-T0140_01', 'MIGRATION 설정정보 조회', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0001', 'DX-T0140_02', 'MIGRATION 설정정보 삭제', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0001', 'DX-T0140_03', 'MIGRATION 설정정보 복제', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0001', 'DX-T0140_04', 'MIGRATION 설정정보 즉시실행', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0001', 'DX-T0141', 'MIGRATION 설정정보 등록 팝업', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0001', 'DX-T0141_01', 'MIGRATION 설정정보 등록', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0001', 'DX-T0142', 'MIGRATION 설정정보 수정 팝업', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0001', 'DX-T0142_01', 'MIGRATION 설정정보 수정', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0001', 'DX-T0143', '수행이력 화면', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0001', 'DX-T0143_01', 'DDL 수행이력 조회', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0001', 'DX-T0143_02', 'Migration 수행이력 조회', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0001', 'DX-T0144', '소스 DBMS 시스템정보 팝업', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0001', 'DX-T0145', '타겟 DBMS 시스템정보 팝업', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0001', 'DX-T0146', '테이블정보 팝업', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());


INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0022', 'TC002201', 'Oracle', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0022', 'TC002202', 'MS-SQL', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0022', 'TC002203', 'MySQL', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0022', 'TC002204', 'PostgreSQL', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0022', 'TC002205', 'DB2', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0022', 'TC002206', 'SyBaseASE', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0022', 'TC002207', 'CUBRID', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0022', 'TC002208', 'Tibero', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0023', 'TC002301', 'AMERICAN_AMERICA.KO16MSWIN949', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0023', 'TC002302', 'AMERICAN_AMERICA.KO16KSC5601', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0023', 'TC002303', 'AMERICAN_AMERICA.UTF8', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0023', 'TC002304', 'AMERICAN_AMERICA.AL32UTF', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0024', 'TC002401', 'KO16MSWIN949', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0024', 'TC002402', 'EUCKR', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0024', 'TC002403', 'UTF8', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0025', 'TC002501', '1363', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0025', 'TC002502', 'UTF-8(1208)', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0026', 'TC002601', 'utf8', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0026', 'TC002602', 'iso_1', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0026', 'TC002603', 'eucksc', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0026', 'TC002604', 'ascii_8', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0026', 'TC002605', 'cp949', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0027', 'TC002701', 'euckr', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0027', 'TC002702', 'utf-8', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0028', 'TC002801', 'Original', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0028', 'TC002802', 'toUpper', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0028', 'TC002803', 'toLower', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0029', 'TC002901', 'TRUE', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0029', 'TC002902', 'FALSE', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0030', 'TC003001', 'TRUNCATE', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0030', 'TC003002', 'APPEND', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0031', 'TC003101', 'DDL', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0031', 'TC003102', 'MIGRATION', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());

INSERT INTO T_MNU_I(MNU_ID, MNU_CD, MNU_NM, HGR_MNU_ID, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM)VALUES(nextval('q_mnu_i_01'), 'MN00015', 	'소스/타겟 DBMS 관리', 		'','experdb', clock_timestamp(), 'experdb', clock_timestamp());
INSERT INTO T_MNU_I(MNU_ID, MNU_CD, MNU_NM, HGR_MNU_ID, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM)VALUES(nextval('q_mnu_i_01'), 'MN00016', 	'설정정보관리', 		'','experdb', clock_timestamp(), 'experdb', clock_timestamp());
INSERT INTO T_MNU_I(MNU_ID, MNU_CD, MNU_NM, HGR_MNU_ID, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM)VALUES(nextval('q_mnu_i_01'), 'MN00017', 	'수행이력', 		'','experdb', clock_timestamp(), 'experdb', clock_timestamp());

INSERT INTO T_USRMNUAUT_I(USR_MNU_AUT_ID, USR_ID, MNU_ID, READ_AUT_YN, WRT_AUT_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM)VALUES(nextval('q_usrmnuaut_i_01'), 'experdb', 40, 'Y', 'Y', 'experdb', clock_timestamp(), 'experdb', clock_timestamp());
INSERT INTO T_USRMNUAUT_I(USR_MNU_AUT_ID, USR_ID, MNU_ID, READ_AUT_YN, WRT_AUT_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM)VALUES(nextval('q_usrmnuaut_i_01'), 'experdb', 41, 'Y', 'Y', 'experdb', clock_timestamp(), 'experdb', clock_timestamp());
INSERT INTO T_USRMNUAUT_I(USR_MNU_AUT_ID, USR_ID, MNU_ID, READ_AUT_YN, WRT_AUT_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM)VALUES(nextval('q_usrmnuaut_i_01'), 'experdb', 42, 'Y', 'Y', 'experdb', clock_timestamp(), 'experdb', clock_timestamp());

INSERT INTO T_USRMNUAUT_I(USR_MNU_AUT_ID, USR_ID, MNU_ID, READ_AUT_YN, WRT_AUT_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM)VALUES(nextval('q_usrmnuaut_i_01'), 'admin', 40, 'Y', 'Y', 'experdb', clock_timestamp(), 'experdb', clock_timestamp());
INSERT INTO T_USRMNUAUT_I(USR_MNU_AUT_ID, USR_ID, MNU_ID, READ_AUT_YN, WRT_AUT_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM)VALUES(nextval('q_usrmnuaut_i_01'), 'admin', 41, 'Y', 'Y', 'experdb', clock_timestamp(), 'experdb', clock_timestamp());
INSERT INTO T_USRMNUAUT_I(USR_MNU_AUT_ID, USR_ID, MNU_ID, READ_AUT_YN, WRT_AUT_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM)VALUES(nextval('q_usrmnuaut_i_01'), 'admin', 42, 'Y', 'Y', 'experdb', clock_timestamp(), 'experdb', clock_timestamp());


INSERT INTO T_SYSGRP_C(GRP_CD, GRP_CD_NM, GRP_CD_EXP, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0038', '케릭터셋(MSSQL)', '', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());

INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0038', 'TC003801', 'Korean_Wansung_CI_AS', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0038', 'TC003802', 'UCS-1', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0038', 'TC003803', 'UTF-8', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0038', 'TC003804', 'UTF-16', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());

ALTER TABLE t_migexe_g  ALTER COLUMN rslt_msg TYPE text;


create table experdb_management.t_scale_g (
	scale_wrk_sn numeric NOT NULL DEFAULT 1,                    -- 스케일_실행_일련번호
	wrk_id numeric(18) NOT NULL DEFAULT 1,                      -- 작업_ID
	scale_type varchar(1) NOT NULL,                             -- 스케일_유형
	db_svr_id numeric(18) NOT NULL DEFAULT 1,                   -- DB_서버_ID
	db_svr_ipadr_id numeric(18) NOT NULL DEFAULT 1,             -- DB_서버_IP주소_ID
	wrk_type varchar(8) NOT NULL,                               -- 작업_유형
	auto_policy varchar(8) NULL,                                -- AUTO_정책
	auto_policy_set_div varchar(1) NULL,                        -- AUTO_정책_설정_구분
	auto_policy_time numeric NULL,                              -- AUTO_정책_시간
	auto_level varchar(8) NULL,                                 -- AUTO_레벨
	clusters numeric NULL,                                      -- 클러스터
	process_id varchar(30) NOT NULL,                            -- 프로세스_ID
	wrk_strt_dtm timestamp NOT NULL DEFAULT clock_timestamp(),  -- 작업_시작_일시
	wrk_end_dtm timestamp NOT NULL DEFAULT clock_timestamp(),   -- 작업_종료_일시
	exe_rslt_cd varchar(20) NULL,                               -- 실행_결과_코드
	rslt_msg varchar(1000) NULL,                                -- 결과_메시지
	frst_regr_id varchar(30) NULL,                              -- 최초_등록자_ID
	frst_reg_dtm timestamp NOT NULL DEFAULT clock_timestamp(),  -- 최초_등록_일시
	lst_mdfr_id varchar(30) NULL,  								-- 최종_수정자_ID
	lst_mdf_dtm timestamp NOT NULL DEFAULT clock_timestamp() -- 최종_수정_일시
);
CREATE UNIQUE INDEX uk_t_scale_g_01 ON experdb_management.t_scale_g USING btree (scale_wrk_sn, wrk_id, db_svr_id, scale_type, process_id);
COMMENT ON TABLE experdb_management.t_scale_g IS 'SCALE 실행로그';

COMMENT ON COLUMN experdb_management.t_scale_g.scale_wrk_sn IS 'SCALE_실행일련번호';
COMMENT ON COLUMN experdb_management.t_scale_g.wrk_id IS '작업_ID';
COMMENT ON COLUMN experdb_management.t_scale_g.scale_type IS '스케일_유형:scale_in(1),scale_out(2)';
COMMENT ON COLUMN experdb_management.t_scale_g.db_svr_id IS 'DB_서버_ID';
COMMENT ON COLUMN experdb_management.t_scale_g.db_svr_ipadr_id IS 'DB_서버_IP주소_ID';
COMMENT ON COLUMN experdb_management.t_scale_g.wrk_type IS '작업_유형';
COMMENT ON COLUMN experdb_management.t_scale_g.auto_policy IS 'AUTO_정책';
COMMENT ON COLUMN experdb_management.t_scale_g.auto_policy_set_div IS 'AUTO_정책_설정_구분';
COMMENT ON COLUMN experdb_management.t_scale_g.auto_policy_time IS 'AUTO_정책_시간';
COMMENT ON COLUMN experdb_management.t_scale_g.auto_level IS 'AUTO_레벨';
COMMENT ON COLUMN experdb_management.t_scale_g.clusters IS '클러스터';
COMMENT ON COLUMN experdb_management.t_scale_g.process_id IS '프로세스_ID';
COMMENT ON COLUMN experdb_management.t_scale_g.wrk_strt_dtm IS '작업_시작_일시';
COMMENT ON COLUMN experdb_management.t_scale_g.wrk_end_dtm IS '작업_종료_일시';
COMMENT ON COLUMN experdb_management.t_scale_g.exe_rslt_cd IS '실행_결과_코드';
COMMENT ON COLUMN experdb_management.t_scale_g.rslt_msg IS '결과_메시지';
COMMENT ON COLUMN experdb_management.t_scale_g.frst_regr_id IS '최초_등록자_ID';
COMMENT ON COLUMN experdb_management.t_scale_g.frst_reg_dtm IS '최초_등록_일시';
COMMENT ON COLUMN experdb_management.t_scale_g.lst_mdfr_id IS '최종_수정자_ID';
COMMENT ON COLUMN experdb_management.t_scale_g.lst_mdf_dtm IS '최종_수정_일시';



-- 테이블 추가(발생이력)
CREATE TABLE experdb_management.t_scaleoccur_g (
	wrk_sn numeric NOT NULL DEFAULT 1,                            -- 작업_일련번호
	db_svr_id numeric(18) NOT NULL DEFAULT 1,                     -- DB_서버_ID
	db_svr_ipadr_id numeric(18) NOT NULL DEFAULT 1,               -- DB_서버_IP주소_ID
	scale_type varchar(1) NOT NULL,                               -- 스케일_유형
	policy_type varchar(8) NOT NULL,                              -- 정책_유형
	auto_policy_set_div varchar(1) NOT NULL,                      -- AUTO_정책_설정_구분
	auto_policy_time numeric NOT NULL,                            -- AUTO_정책_시간
	auto_level varchar(8) NOT NULL,                               -- AUTO_레벨
	execute_type varchar(8) NOT NULL,                             -- 실행_유형
	event_occur_contents varchar(8) NOT NULL,                     -- 이벤트_발생_내용
	event_occur_dtm timestamp NOT NULL DEFAULT clock_timestamp(), -- 이벤트_발생_일시
	frst_regr_id varchar(30) NULL,                                -- 최초_등록자_ID
	frst_reg_dtm timestamp NOT NULL DEFAULT clock_timestamp(),    -- 최초_등록_일시
	lst_mdfr_id varchar(30) NULL,                                 -- 최종_수정자_ID
	lst_mdf_dtm timestamp NOT NULL DEFAULT clock_timestamp()      -- 최종_수정_일시
);
CREATE UNIQUE INDEX uk_t_scaleoccur_g_01 ON experdb_management.t_scaleoccur_g USING btree (wrk_sn, db_svr_id, scale_type, policy_type, execute_type);
COMMENT ON TABLE experdb_management.t_scaleoccur_g IS 'SCALE AUTO 발생로그';

COMMENT ON COLUMN experdb_management.t_scaleoccur_g.wrk_sn IS '작업_일련번호';
COMMENT ON COLUMN experdb_management.t_scaleoccur_g.db_svr_id IS 'DB_서버_ID';
COMMENT ON COLUMN experdb_management.t_scaleoccur_g.db_svr_ipadr_id IS 'DB_서버_IP주소_ID';
COMMENT ON COLUMN experdb_management.t_scaleoccur_g.scale_type IS '스케일_유형:scale_in(1),scale_out(2)';
COMMENT ON COLUMN experdb_management.t_scaleoccur_g.policy_type IS '정책_유형';
COMMENT ON COLUMN experdb_management.t_scaleoccur_g.auto_policy_set_div IS 'AUTO_정책_설정_구분';
COMMENT ON COLUMN experdb_management.t_scaleoccur_g.auto_policy_time IS 'AUTO_정책_시간';
COMMENT ON COLUMN experdb_management.t_scaleoccur_g.auto_level IS 'AUTO_레벨';
COMMENT ON COLUMN experdb_management.t_scaleoccur_g.execute_type IS '실행_유형';
COMMENT ON COLUMN experdb_management.t_scaleoccur_g.event_occur_contents IS '이벤트_발생_내용';
COMMENT ON COLUMN experdb_management.t_scaleoccur_g.event_occur_dtm IS '이벤트_발생_일시';
COMMENT ON COLUMN experdb_management.t_scaleoccur_g.frst_regr_id IS '최초_등록자_ID';
COMMENT ON COLUMN experdb_management.t_scaleoccur_g.frst_reg_dtm IS '최초_등록_일시';
COMMENT ON COLUMN experdb_management.t_scaleoccur_g.lst_mdfr_id IS '최종_수정자_ID';
COMMENT ON COLUMN experdb_management.t_scaleoccur_g.lst_mdf_dtm IS '최종_수정_일시';



-- 테이블 추가(auto scale 설정)
CREATE TABLE experdb_management.t_scale_i (
	wrk_id numeric(18) NOT NULL DEFAULT 1,                        -- 작업_ID
	db_svr_id numeric(18) NOT NULL DEFAULT 1,                     -- DB_서버_ID
	db_svr_ipadr_id numeric(18) NOT NULL DEFAULT 1,               -- DB_서버_IP주소_ID
	scale_type varchar(1) NOT NULL ,                              -- 스케일_유형
	policy_type varchar(8) NOT NULL,                              -- 정책_유형
	auto_policy_set_div varchar(1) NOT NULL,                      -- AUTO_정책_설정_구분
	auto_policy_time numeric NOT NULL,                            -- AUTO_정책_시간
	auto_level varchar(8) NOT NULL,                               -- AUTO_레벨
	execute_type varchar(8) NOT NULL,                             -- 실행_유형
	expansion_clusters numeric NULL,                              -- 확장_클러스터
	min_clusters numeric NULL,                                    -- 최소_클러스터
	max_clusters numeric NULL,                                    -- 최대_클러스터
	frst_regr_id varchar(30) NULL,                                -- 최초_등록자_ID
	frst_reg_dtm timestamp NOT NULL DEFAULT clock_timestamp(),    -- 최초_등록_일시
	lst_mdfr_id varchar(30) NULL,                                 -- 최종_수정자_ID
	lst_mdf_dtm timestamp NOT NULL DEFAULT clock_timestamp()      -- 최종_수정_일시
);
CREATE UNIQUE INDEX uk_t_scale_i_01 ON experdb_management.t_scale_i USING btree (wrk_id, db_svr_id, scale_type, policy_type, execute_type);
COMMENT ON TABLE experdb_management.t_scale_i IS 'SCALE AUTO 설정';

COMMENT ON COLUMN experdb_management.t_scale_i.wrk_id IS '작업_ID';
COMMENT ON COLUMN experdb_management.t_scale_i.db_svr_id IS 'DB_서버_ID';
COMMENT ON COLUMN experdb_management.t_scale_i.db_svr_ipadr_id IS 'DB_서버_IP주소_ID';
COMMENT ON COLUMN experdb_management.t_scale_i.scale_type IS '스케일_유형:scale_in(1),scale_out(2)';
COMMENT ON COLUMN experdb_management.t_scale_i.policy_type IS '정책_유형';
COMMENT ON COLUMN experdb_management.t_scale_i.auto_policy_set_div IS 'AUTO_정책_설정_구분';
COMMENT ON COLUMN experdb_management.t_scale_i.auto_policy_time IS 'AUTO_정책_시간';
COMMENT ON COLUMN experdb_management.t_scale_i.auto_level IS 'AUTO_레벨';
COMMENT ON COLUMN experdb_management.t_scale_i.execute_type IS '실행_유형';
COMMENT ON COLUMN experdb_management.t_scale_i.expansion_clusters IS '확장_클러스터';
COMMENT ON COLUMN experdb_management.t_scale_i.min_clusters IS '최소_클러스터';
COMMENT ON COLUMN experdb_management.t_scale_i.max_clusters IS '최대_클러스터';
COMMENT ON COLUMN experdb_management.t_scale_i.frst_regr_id IS '최초_등록자_ID';
COMMENT ON COLUMN experdb_management.t_scale_i.frst_reg_dtm IS '최초_등록_일시';
COMMENT ON COLUMN experdb_management.t_scale_i.lst_mdfr_id IS '최종_수정자_ID';
COMMENT ON COLUMN experdb_management.t_scale_i.lst_mdf_dtm IS '최종_수정_일시';



-- 테이블 추가(Auto Scale Loading 이력)
CREATE TABLE experdb_management.t_scaleloadlog_g (
	wrk_sn numeric NOT NULL DEFAULT 1,                   -- 작업_일련번호
	db_svr_id numeric(18) NOT NULL DEFAULT 1,            -- DB_서버_ID
	db_svr_ipadr_id numeric(18) NOT NULL DEFAULT 1,      -- DB_서버_IP주소_ID
	policy_type varchar(8) NOT NULL,                     -- 정책_유형
	exenum numeric NOT NULL,                             -- 실행값
	exedtm timestamp NOT NULL DEFAULT clock_timestamp()  -- 실행일시
);
CREATE UNIQUE INDEX uk_t_scaleloadlog_g_01 ON experdb_management.t_scaleloadlog_g USING btree (wrk_sn, db_svr_id);
COMMENT ON TABLE experdb_management.t_scaleloadlog_g IS 'Auto Scale Loading 테이블';

COMMENT ON COLUMN experdb_management.t_scaleloadlog_g.wrk_sn IS '작업_일련번호';
COMMENT ON COLUMN experdb_management.t_scaleloadlog_g.db_svr_id IS 'DB_서버_ID';
COMMENT ON COLUMN experdb_management.t_scaleloadlog_g.db_svr_ipadr_id IS 'DB_서버_IP주소_ID';
COMMENT ON COLUMN experdb_management.t_scaleloadlog_g.policy_type IS '정책_유형';
COMMENT ON COLUMN experdb_management.t_scaleloadlog_g.exenum IS '실행값';
COMMENT ON COLUMN experdb_management.t_scaleloadlog_g.exedtm IS '실행일시';



-- 시퀀스 추가
CREATE SEQUENCE q_t_scale_g_01;
CREATE SEQUENCE q_t_scaleoccur_g_01;
CREATE SEQUENCE q_t_scale_i_01;
CREATE SEQUENCE q_t_scaleloadlog_g_01;


-- 사용여부 컬럼 추가
ALTER TABLE T_USRDBSVRAUT_I ADD COLUMN SCALE_AUT_YN VARCHAR(1) NULL;
ALTER TABLE T_USRDBSVRAUT_I ADD COLUMN SCALE_HIST_AUT_YN VARCHAR(1) NULL;
ALTER TABLE T_USRDBSVRAUT_I ADD COLUMN SCALE_CNG_AUT_YN VARCHAR(1) NULL;
COMMENT ON COLUMN T_USRDBSVRAUT_I.SCALE_AUT_YN IS 'scale_여부';
COMMENT ON COLUMN T_USRDBSVRAUT_I.SCALE_HIST_AUT_YN IS 'scale_이력_권한_여부';
COMMENT ON COLUMN T_USRDBSVRAUT_I.SCALE_CNG_AUT_YN IS 'scale_설정_권한_여부';


-- 코드그룹 추가
INSERT INTO T_SYSGRP_C (GRP_CD, GRP_CD_NM, GRP_CD_EXP, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM )
                VALUES ( 'TC0033', '작업유형', 'SCALE 작업유형', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());

INSERT INTO T_SYSGRP_C (GRP_CD, GRP_CD_NM, GRP_CD_EXP, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM )
                VALUES ( 'TC0034', '실행유형', 'SCALE 실행유형', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());

INSERT INTO T_SYSGRP_C (GRP_CD, GRP_CD_NM, GRP_CD_EXP, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM )
                VALUES ( 'TC0035', '정책유형', 'SCALE 정책유형', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());


-- 메뉴코드 추가
INSERT into T_SYSDTL_C (grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
values ('TC0001', 'DX-T0056', 'Node 수동확장 화면', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());

INSERT into T_SYSDTL_C (grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
values ('TC0001', 'DX-T0056_01', 'Node 수동확장 화면 조회', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());

INSERT into T_SYSDTL_C (grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
values ('TC0001', 'DX-T0056_02', 'Node 수동확장 Node 축소', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());

INSERT into T_SYSDTL_C (grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
values ('TC0001', 'DX-T0056_03', 'Node 수동확장 Node 확대', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());

INSERT into T_SYSDTL_C (grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
values ('TC0001', 'DX-T0056_04', 'Node 수동확장 상세 조회', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());

INSERT into T_SYSDTL_C (grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
values ('TC0001', 'DX-T0056_05', 'Node 수동확장 보안그룹 상세 조회', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());

INSERT into T_SYSDTL_C (grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
values ('TC0001', 'DX-T0056_06', 'Node 수동확장  실행 팝업', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());

INSERT into T_SYSDTL_C (grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
values ('TC0001', 'DX-T0057', 'Node 확장이력 화면', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());

INSERT into T_SYSDTL_C (grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
values ('TC0001', 'DX-T0057_01', 'Node 확장이력 Node 확장 이력 조회', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());

INSERT into T_SYSDTL_C (grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
values ('TC0001', 'DX-T0057_02', 'Node 확장이력 Node 자동 확장 이력 조회', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());

INSERT into T_SYSDTL_C (grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
values ('TC0001', 'DX-T0058', 'Node 자동확장설정 화면', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());

INSERT into T_SYSDTL_C (grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
values ('TC0001', 'DX-T0058_01', 'Node 자동확장설정 화면 조회', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());

INSERT into T_SYSDTL_C (grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
values ('TC0001', 'DX-T0058_02', 'Node 자동확장설정 삭제', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());

INSERT into T_SYSDTL_C (grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
values ('TC0001', 'DX-T0059', 'Node 자동확장설정 등록 팝업', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());

INSERT into T_SYSDTL_C (grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
values ('TC0001', 'DX-T0059_01', 'Node 자동확장설정 등록', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());

INSERT into T_SYSDTL_C (grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
values ('TC0001', 'DX-T0060', 'Node 자동확장 수정 팝업', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());

INSERT into T_SYSDTL_C (grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
values ('TC0001', 'DX-T0060_01', 'Node 자동확장 수정', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());



-- 코드추가
INSERT into T_SYSDTL_C (grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
values ('TC0033', 'TC003301', 'Auto', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());

INSERT into T_SYSDTL_C (grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
values ('TC0033', 'TC003302', 'Manual', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());

INSERT into T_SYSDTL_C (grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
values ('TC0034', 'TC003401', 'Notification', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());

INSERT into T_SYSDTL_C (grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
values ('TC0034', 'TC003402', 'Auto-scale', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());

INSERT into T_SYSDTL_C (grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
values ('TC0035', 'TC003501', 'CPU', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());

INSERT into T_SYSDTL_C (grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
values ('TC0035', 'TC003502', 'TPS', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
ALTER TABLE experdb_management.t_scale_i ADD useyn1 bpchar(1) NOT NULL DEFAULT 'Y'::bpchar;
COMMENT ON COLUMN experdb_management.t_scale_i.useyn1 IS '사용여부';



-- 테이블 추가(AWS 서버 내역)
CREATE TABLE experdb_management.t_scaleAwssvr_i (
	db_svr_id numeric(18) NOT NULL DEFAULT 1, -- DB_서버_ID
    db_svr_ipadr_id numeric(18) NOT NULL DEFAULT 1, -- DB_서버_IP주소_ID
	ipadr varchar(30) NULL, -- IP주소
    auto_run_cycle numeric(2) NULL, -- auto 주기
	min_clusters numeric NULL,                                    -- 최소_노드수
	max_clusters numeric NULL,                                    -- 최대_노드수
	frst_regr_id varchar(30) NULL, -- 최초_등록자_ID
	frst_reg_dtm timestamp NOT NULL DEFAULT clock_timestamp(), -- 최초_등록_일시
	lst_mdfr_id varchar(30) NULL, -- 최종_수정자_ID
	lst_mdf_dtm timestamp NOT NULL DEFAULT clock_timestamp() -- 최종_수정_일시
);
CREATE UNIQUE INDEX uk_t_scaleAwssvr_i_01 ON experdb_management.t_scaleAwssvr_i USING btree (db_svr_id, db_svr_ipadr_id);
COMMENT ON TABLE experdb_management.t_scaleAwssvr_i IS 'scale AWS 서버설정';

COMMENT ON COLUMN experdb_management.t_scaleAwssvr_i.db_svr_id IS 'DB_서버_ID';
COMMENT ON COLUMN experdb_management.t_scaleAwssvr_i.db_svr_ipadr_id IS 'DB_서버_IP주소_ID';
COMMENT ON COLUMN experdb_management.t_scaleAwssvr_i.auto_run_cycle IS 'AUTO_실행_주기';
COMMENT ON COLUMN experdb_management.t_scaleAwssvr_i.min_clusters IS '최소_노드수';
COMMENT ON COLUMN experdb_management.t_scaleAwssvr_i.max_clusters IS '최대_노드수';
COMMENT ON COLUMN experdb_management.t_scaleAwssvr_i.frst_regr_id IS '최초_등록자_ID';
COMMENT ON COLUMN experdb_management.t_scaleAwssvr_i.frst_reg_dtm IS '최초_등록_일시';
COMMENT ON COLUMN experdb_management.t_scaleAwssvr_i.lst_mdfr_id IS '최종_수정자_ID';
COMMENT ON COLUMN experdb_management.t_scaleAwssvr_i.lst_mdf_dtm IS '최종_수정_일시';
COMMENT ON COLUMN experdb_management.t_scaleAwssvr_i.ipadr IS 'IP주소';

COMMENT ON COLUMN experdb_management.t_scale_g.clusters IS '노드';

COMMENT ON COLUMN experdb_management.t_scale_i.expansion_clusters IS '노드_단위';
COMMENT ON COLUMN experdb_management.t_scale_i.min_clusters IS '최소_노드수';
COMMENT ON COLUMN experdb_management.t_scale_i.max_clusters IS '최대_노드수';

UPDATE T_SYSDTL_C SET sys_cd_nm = '노드 수동확장 화면' WHERE grp_cd = 'TC0001' AND sys_cd = 'DX-T0056';
UPDATE T_SYSDTL_C SET sys_cd_nm = '노드 수동확장 화면 조회' WHERE grp_cd = 'TC0001' AND sys_cd = 'DX-T0056_01';
UPDATE T_SYSDTL_C SET sys_cd_nm = '노드 수동확장 스케일-인' WHERE grp_cd = 'TC0001' AND sys_cd = 'DX-T0056_02';
UPDATE T_SYSDTL_C SET sys_cd_nm = '노드 수동확장 스케일-아웃' WHERE grp_cd = 'TC0001' AND sys_cd = 'DX-T0056_03';
UPDATE T_SYSDTL_C SET sys_cd_nm = '노드 수동확장 상세 조회' WHERE grp_cd = 'TC0001' AND sys_cd = 'DX-T0056_04';
UPDATE T_SYSDTL_C SET sys_cd_nm = '노드 수동확장 보안그룹 상세 조회' WHERE grp_cd = 'TC0001' AND sys_cd = 'DX-T0056_05';
UPDATE T_SYSDTL_C SET sys_cd_nm = '노드 수동확장  실행 팝업' WHERE grp_cd = 'TC0001' AND sys_cd = 'DX-T0056_06';
UPDATE T_SYSDTL_C SET sys_cd_nm = '노드 확장이력 화면' WHERE grp_cd = 'TC0001' AND sys_cd = 'DX-T0057';
UPDATE T_SYSDTL_C SET sys_cd_nm = '노드 확장이력 노드 확장 실행 이력 조회' WHERE grp_cd = 'TC0001' AND sys_cd = 'DX-T0057_01';
UPDATE T_SYSDTL_C SET sys_cd_nm = '노드 확장이력 노드 자동 확장 발생 이력 조회' WHERE grp_cd = 'TC0001' AND sys_cd = 'DX-T0057_02';
UPDATE T_SYSDTL_C SET sys_cd_nm = '노드 자동확장설정 화면' WHERE grp_cd = 'TC0001' AND sys_cd = 'DX-T0058';
UPDATE T_SYSDTL_C SET sys_cd_nm = '노드 자동확장설정 화면 조회' WHERE grp_cd = 'TC0001' AND sys_cd = 'DX-T0058_01';
UPDATE T_SYSDTL_C SET sys_cd_nm = '노드 자동확장설정 삭제' WHERE grp_cd = 'TC0001' AND sys_cd = 'DX-T0058_02';
UPDATE T_SYSDTL_C SET sys_cd_nm = '노드 자동확장설정 등록 팝업' WHERE grp_cd = 'TC0001' AND sys_cd = 'DX-T0059';
UPDATE T_SYSDTL_C SET sys_cd_nm = '노드 자동확장설정 등록' WHERE grp_cd = 'TC0001' AND sys_cd = 'DX-T0059_01';
UPDATE T_SYSDTL_C SET sys_cd_nm = '노드 자동확장 수정 팝업' WHERE grp_cd = 'TC0001' AND sys_cd = 'DX-T0060';
UPDATE T_SYSDTL_C SET sys_cd_nm = '노드 자동확장 수정' WHERE grp_cd = 'TC0001' AND sys_cd = 'DX-T0060_01';

INSERT into T_SYSDTL_C (grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
values ('TC0001', 'DX-T0061', '노드 자동확장 기본 설정 등록 팝업', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());

INSERT into T_SYSDTL_C (grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
values ('TC0001', 'DX-T0061_01', '노드 자동확장 기본 설정 등록', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());

DELETE FROM T_SYSDTL_C WHERE grp_cd = 'TC0035' AND sys_cd = 'TC003502';



INSERT INTO T_SYSGRP_C(GRP_CD, GRP_CD_NM, GRP_CD_EXP, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES( 'TC0036', '스냅샷모드', '데이터전송 스냅샷모드', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());

INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0036', 'TC003601', 'INITIAL', 'Y', 'ADMIN', CLOCK_TIMESTAMP(), 'ADMIN', CLOCK_TIMESTAMP());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0036', 'TC003602', 'ALWAYS', 'N', 'ADMIN', CLOCK_TIMESTAMP(), 'ADMIN', CLOCK_TIMESTAMP());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0036', 'TC003603', 'NEVER', 'Y', 'ADMIN', CLOCK_TIMESTAMP(), 'ADMIN', CLOCK_TIMESTAMP());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0036', 'TC003604', 'INITIAL_ONLY', 'N', 'ADMIN', CLOCK_TIMESTAMP(), 'ADMIN', CLOCK_TIMESTAMP());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0036', 'TC003605', 'EXPORTED', 'N', 'ADMIN', CLOCK_TIMESTAMP(), 'ADMIN', CLOCK_TIMESTAMP());



CREATE TABLE T_TRANS_EXRTEXCT_MAPP (
	TRANS_EXRT_EXCT_TB_ID NUMERIC NOT NULL,
	EXRT_EXCT_TB_NM TEXT NULL,
	EXRT_EXCT_SCM_NM TEXT NULL,
	SCHEMA_TOTAL_CNT NUMERIC NULL,
	TABLE_TOTAL_CNT NUMERIC NULL,
	FRST_REGR_ID VARCHAR(30) NULL,
	FRST_REG_DTM TIMESTAMP NOT NULL,
	CONSTRAINT PK_T_TRANS_EXRTEXCT_MAPP PRIMARY KEY (TRANS_EXRT_EXCT_TB_ID)
);


COMMENT ON TABLE T_TRANS_EXRTEXCT_MAPP IS '전송제외테이블';

 COMMENT ON COLUMN T_TRANS_EXRTEXCT_MAPP.TRANS_EXRT_EXCT_TB_ID IS '전송제외아이디';
 COMMENT ON COLUMN T_TRANS_EXRTEXCT_MAPP.EXRT_EXCT_TB_NM IS '전송제외테이블명';
 COMMENT ON COLUMN T_TRANS_EXRTEXCT_MAPP.EXRT_EXCT_SCM_NM IS '전송제외스키마명';
 COMMENT ON COLUMN T_TRANS_EXRTEXCT_MAPP.SCHEMA_TOTAL_CNT IS '전송제외스키마수';
 COMMENT ON COLUMN T_TRANS_EXRTEXCT_MAPP.TABLE_TOTAL_CNT IS '전송제외테이블수';
 COMMENT ON COLUMN T_TRANS_EXRTEXCT_MAPP.FRST_REGR_ID IS '최초_등록자_ID';
 COMMENT ON COLUMN T_TRANS_EXRTEXCT_MAPP.FRST_REG_DTM IS '최초_등록_일시';


CREATE SEQUENCE Q_T_TRANS_EXRTEXCT_MAPP_01;


CREATE TABLE T_TRANS_EXRTTRG_MAPP (
	TRANS_EXRT_TRG_TB_ID NUMERIC NOT NULL,
	EXRT_TRG_TB_NM TEXT NULL,
	EXRT_TRG_SCM_NM TEXT NULL,
	SCHEMA_TOTAL_CNT NUMERIC NULL,
	TABLE_TOTAL_CNT NUMERIC NULL,
	FRST_REGR_ID VARCHAR(30) NULL,
	FRST_REG_DTM TIMESTAMP NOT NULL,
	CONSTRAINT PK_T_TRANS_EXRTTRG_MAPP PRIMARY KEY (TRANS_EXRT_TRG_TB_ID)
);



COMMENT ON TABLE T_TRANS_EXRTTRG_MAPP IS '전송대상테이블';

 COMMENT ON COLUMN T_TRANS_EXRTTRG_MAPP.TRANS_EXRT_TRG_TB_ID IS '전송대상아이디';
 COMMENT ON COLUMN T_TRANS_EXRTTRG_MAPP.EXRT_TRG_TB_NM IS '전송대상테이블명';
 COMMENT ON COLUMN T_TRANS_EXRTTRG_MAPP.EXRT_TRG_SCM_NM IS '전송대상스키마명';
 COMMENT ON COLUMN T_TRANS_EXRTTRG_MAPP.SCHEMA_TOTAL_CNT IS '전송대상스키마수';
 COMMENT ON COLUMN T_TRANS_EXRTTRG_MAPP.TABLE_TOTAL_CNT IS '전송대상테이블수';
 COMMENT ON COLUMN T_TRANS_EXRTTRG_MAPP.FRST_REGR_ID IS '최초_등록자_ID';
 COMMENT ON COLUMN T_TRANS_EXRTTRG_MAPP.FRST_REG_DTM IS '최초_등록_일시';


CREATE SEQUENCE Q_T_TRANS_EXRTTRG_MAPP_01;


CREATE TABLE T_TRANSCNG_I(
	TRANS_ID           NUMERIC(18) NOT NULL DEFAULT 1,
	KC_IP          VARCHAR(50) NULL,
	KC_PORT           NUMERIC(5) NOT NULL DEFAULT 0,
	CONNECT_NM           VARCHAR(50) NULL,
	SNAPSHOT_MODE         VARCHAR(50) NULL,
	DB_ID         		  NUMERIC(18) NOT NULL DEFAULT 1,
	DB_SVR_ID            NUMERIC(18) NOT NULL DEFAULT 1,	
	TRANS_EXRT_TRG_TB_ID numeric NULL,
	TRANS_EXRT_EXCT_TB_ID numeric NULL,	
	EXE_STATUS VARCHAR(20) NOT NULL DEFAULT 'TC001502',
	FRST_REGR_ID         VARCHAR(30) NULL,
	FRST_REG_DTM         TIMESTAMP NOT NULL DEFAULT CLOCK_TIMESTAMP(),
	LST_MDFR_ID          VARCHAR(30) NULL,
	LST_MDF_DTM          TIMESTAMP NOT NULL DEFAULT CLOCK_TIMESTAMP(),
	CONSTRAINT fk_T_TRANSCNG_I_01 FOREIGN KEY (TRANS_EXRT_TRG_TB_ID) REFERENCES T_TRANS_EXRTTRG_MAPP(TRANS_EXRT_TRG_TB_ID),
	CONSTRAINT fk_T_TRANSCNG_I_02 FOREIGN KEY (TRANS_EXRT_EXCT_TB_ID) REFERENCES T_TRANS_EXRTEXCT_MAPP(TRANS_EXRT_EXCT_TB_ID)
);


ALTER TABLE T_TRANSCNG_I ADD CONSTRAINT PK_T_TRANSCNG_I
PRIMARY KEY (TRANS_ID);


COMMENT ON TABLE T_TRANSCNG_I IS '전송설정테이블';

 COMMENT ON COLUMN T_TRANSCNG_I.TRANS_ID IS '전송_ID';
 COMMENT ON COLUMN T_TRANSCNG_I.KC_IP IS '커넥터_아이피';
 COMMENT ON COLUMN T_TRANSCNG_I.KC_PORT IS '커넥터_포트';
 COMMENT ON COLUMN T_TRANSCNG_I.CONNECT_NM IS '커넥트명';
 COMMENT ON COLUMN T_TRANSCNG_I.SNAPSHOT_MODE IS '스냅샷모드';
 COMMENT ON COLUMN T_TRANSCNG_I.DB_ID IS '디비_아이디';
 COMMENT ON COLUMN T_TRANSCNG_I.DB_SVR_ID IS '디비_서버_아이디';
 COMMENT ON COLUMN T_TRANSCNG_I.TRANS_EXRT_TRG_TB_ID IS '전송 포함_아이디';
 COMMENT ON COLUMN T_TRANSCNG_I.TRANS_EXRT_EXCT_TB_ID IS '전송_제외_아이디';
 COMMENT ON COLUMN T_TRANSCNG_I.FRST_REGR_ID IS '최초_등록자_ID';
 COMMENT ON COLUMN T_TRANSCNG_I.FRST_REG_DTM IS '최초_등록_일시';
 COMMENT ON COLUMN T_TRANSCNG_I.LST_MDFR_ID IS '최종_수정자_ID';
 COMMENT ON COLUMN T_TRANSCNG_I.LST_MDF_DTM IS '최종_수정_일시';

CREATE SEQUENCE Q_T_TRANSCNG_I_01;

INSERT INTO T_SYSGRP_C(GRP_CD, GRP_CD_NM, GRP_CD_EXP, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES( 'TC0037', '압축형태', '데이터전송 압축형태', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());

INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0037', 'TC003701', 'NONE', 'Y', 'ADMIN', CLOCK_TIMESTAMP(), 'ADMIN', CLOCK_TIMESTAMP());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0037', 'TC003702', 'GZIP', 'Y', 'ADMIN', CLOCK_TIMESTAMP(), 'ADMIN', CLOCK_TIMESTAMP());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0037', 'TC003703', 'SNAPPY', 'Y', 'ADMIN', CLOCK_TIMESTAMP(), 'ADMIN', CLOCK_TIMESTAMP());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0037', 'TC003704', 'LZ4', 'Y', 'ADMIN', CLOCK_TIMESTAMP(), 'ADMIN', CLOCK_TIMESTAMP());
INSERT INTO T_SYSDTL_C(GRP_CD, SYS_CD, SYS_CD_NM, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM ) VALUES('TC0037', 'TC003705', 'ZSTD', 'Y', 'ADMIN', CLOCK_TIMESTAMP(), 'ADMIN', CLOCK_TIMESTAMP());


ALTER TABLE T_TRANSCNG_I ADD COLUMN compression_type varchar(50);
COMMENT ON COLUMN T_TRANSCNG_I.compression_type IS '압축형태';

ALTER TABLE T_TRANSCNG_I ADD COLUMN meta_data varchar(50);
COMMENT ON COLUMN T_TRANSCNG_I.meta_data IS '메타데이터 사용유무';

