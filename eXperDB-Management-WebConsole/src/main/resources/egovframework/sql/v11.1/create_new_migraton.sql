
drop table t_db2pg_ddl_wrk_inf;

drop table t_db2pg_sys_inf;

drop table t_db2pg_trsf_wrk_inf;

drop table t_db2pg_usrqry_ls;

drop table t_db2pg_exrtexct_srctb_ls;

drop table t_db2pg_exrttrg_srctb_ls;

drop table t_migexe_g;

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

alter table t_migexe_g
add constraint fk_t_migexe_g_01 foreign key (wrk_id) references t_wrkcng_i (wrk_id);

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

