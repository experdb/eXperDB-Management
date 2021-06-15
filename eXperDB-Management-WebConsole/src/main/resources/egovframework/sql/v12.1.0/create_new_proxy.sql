-- CRATE TABLE (PROXY AGENT_INFO)
CREATE TABLE experdb_management.t_pry_agt_i (
	agt_sn numeric(18) NOT NULL DEFAULT 1,                     -- 에이전트_일련번호
	ipadr varchar(30) NOT NULL,                                -- IP주소
	domain_nm varchar(200) NULL,                               -- 도메인명
	socket_port numeric(5) NOT NULL DEFAULT 0,                 -- 소켓_포트
	agt_cndt_cd varchar(20) NULL,                              -- 에이전트_상태_코드
	svr_use_yn bpchar(1) NOT NULL DEFAULT 'N'::bpchar,         -- 서버_사용_여부
	strt_dtm timestamp NOT NULL DEFAULT clock_timestamp(),     -- 시작_일시
	istcnf_yn varchar(1) NULL,                                 -- 설치확인_여부
	agt_version varchar(10) NULL,                              -- 에이전트_버전
	frst_regr_id varchar(30) NULL,                             -- 최초_등록자_ID
	frst_reg_dtm timestamp NOT NULL DEFAULT clock_timestamp(), -- 최초_등록_일시
	lst_mdfr_id varchar(30) NULL,                              -- 최종_수정자_ID
	lst_mdf_dtm timestamp NOT NULL DEFAULT clock_timestamp(),  -- 최종_수정_일시
	kal_install_yn bpchar(1) NULL DEFAULT 'N'::bpchar,         -- KEEPALIVED_설치_여부
	CONSTRAINT pk_t_pry_agt_i PRIMARY KEY (agt_sn, ipadr)
);
COMMENT ON TABLE experdb_management.t_pry_agt_i IS 'PROXY AGENT_정보';

-- Column comments
COMMENT ON COLUMN experdb_management.t_pry_agt_i.agt_sn IS '에이전트_일련번호';
COMMENT ON COLUMN experdb_management.t_pry_agt_i.ipadr IS 'IP주소';
COMMENT ON COLUMN experdb_management.t_pry_agt_i.domain_nm IS '도메인명';
COMMENT ON COLUMN experdb_management.t_pry_agt_i.socket_port IS '소켓_포트';
COMMENT ON COLUMN experdb_management.t_pry_agt_i.agt_cndt_cd IS '에이전트_상태_코드';
COMMENT ON COLUMN experdb_management.t_pry_agt_i.svr_use_yn IS '서버_사용_여부';
COMMENT ON COLUMN experdb_management.t_pry_agt_i.strt_dtm IS '시작_일시';
COMMENT ON COLUMN experdb_management.t_pry_agt_i.istcnf_yn IS '설치확인_여부';
COMMENT ON COLUMN experdb_management.t_pry_agt_i.agt_version IS '에이전트_버전';
COMMENT ON COLUMN experdb_management.t_pry_agt_i.frst_regr_id IS '최초_등록자_ID';
COMMENT ON COLUMN experdb_management.t_pry_agt_i.frst_reg_dtm IS '최초_등록_일시';
COMMENT ON COLUMN experdb_management.t_pry_agt_i.lst_mdfr_id IS '최종_수정자_ID';
COMMENT ON COLUMN experdb_management.t_pry_agt_i.lst_mdf_dtm IS '최종_수정_일시';
COMMENT ON COLUMN experdb_management.t_pry_agt_i.kal_install_yn IS 'KEEPALIVED_설치_여부';

-- Permissions
ALTER TABLE experdb_management.t_pry_agt_i OWNER TO experdb;
GRANT ALL ON TABLE experdb_management.t_pry_agt_i TO experdb;

-----------------------------------------------------------------------------------



-- CRATE TABLE (PROXY SERVER_INFO)
CREATE TABLE experdb_management.t_pry_svr_i (
	pry_svr_id numeric(18) NOT NULL DEFAULT 1,                 -- PROXY_서버_ID
	ipadr varchar(30) NOT NULL,                                -- IP주소
	agt_sn numeric(18) NULL,                                   -- 에이전트_일련번호
	pry_svr_nm varchar(50) NOT NULL,                           -- PROXY_서버_명
	pry_pth varchar(500) NOT NULL,                             -- PROXY_파일경로
	kal_pth varchar(500) NULL,                             -- KEEPALIVED_파일경로
	use_yn bpchar(1) NOT NULL DEFAULT 'N'::bpchar,             -- 사용_여부
	exe_status varchar(20) NULL DEFAULT 'TC001502',            -- 실행_상태
	kal_exe_status varchar(20) NULL DEFAULT 'TC001502',        -- KEEPALIVED 실행_상태
	master_gbn varchar(1) NULL,                                -- 마스터_구분
	master_svr_id numeric(18) NULL,                            -- 마스터_서버_ID
	db_svr_id numeric(18) NULL,                                -- DB_서버_ID
	day_data_del_term numeric(2) NOT NULL DEFAULT 30,          -- 일별_데이터_삭제_기간
	min_data_del_term numeric(2) NOT NULL DEFAULT 7,           -- 분별_데이터_삭제_기간
	old_master_gbn varchar(1) NULL,                            -- 마스터_구분
	frst_regr_id varchar(30) NULL,                             -- 최초_등록자_ID
	frst_reg_dtm timestamp NOT NULL DEFAULT clock_timestamp(), -- 최초_등록_일시
	lst_mdfr_id varchar(30) NULL,                              -- 최종_수정자_ID
	lst_mdf_dtm timestamp NOT NULL DEFAULT clock_timestamp(),  -- 최종_수정_일시
	CONSTRAINT pk_t_pry_svr_i PRIMARY KEY (pry_svr_id)
);
CREATE UNIQUE INDEX uk_t_pry_svr_i_01 ON experdb_management.t_pry_svr_i USING btree (pry_svr_id, ipadr, pry_svr_nm);
CREATE UNIQUE INDEX uk_t_pry_svr_i_02 ON experdb_management.t_pry_svr_i USING btree (ipadr, pry_svr_nm);
CREATE INDEX uk_t_pry_svr_i_03 ON experdb_management.t_pry_svr_i USING btree (master_svr_id);
COMMENT ON TABLE experdb_management.t_pry_svr_i IS 'PROXY_서버정보';

-- Column comments
COMMENT ON COLUMN experdb_management.t_pry_svr_i.pry_svr_id IS 'PROXY_서버_ID';
COMMENT ON COLUMN experdb_management.t_pry_svr_i.ipadr IS 'IP주소';
COMMENT ON COLUMN experdb_management.t_pry_svr_i.agt_sn IS '에이전트_일련번호';
COMMENT ON COLUMN experdb_management.t_pry_svr_i.pry_svr_nm IS 'PROXY_서버_명';
COMMENT ON COLUMN experdb_management.t_pry_svr_i.pry_pth IS 'PROXY_파일경로';
COMMENT ON COLUMN experdb_management.t_pry_svr_i.kal_pth IS 'KEEPALIVED_파일경로';
COMMENT ON COLUMN experdb_management.t_pry_svr_i.use_yn IS '사용_여부';
COMMENT ON COLUMN experdb_management.t_pry_svr_i.exe_status IS '실행_상태';
COMMENT ON COLUMN experdb_management.t_pry_svr_i.kal_exe_status IS 'KEEPALIVED_실행_상태';
COMMENT ON COLUMN experdb_management.t_pry_svr_i.master_gbn IS '마스터_구분';
COMMENT ON COLUMN experdb_management.t_pry_svr_i.master_svr_id IS '마스터_서버_ID';
COMMENT ON COLUMN experdb_management.t_pry_svr_i.db_svr_id IS 'DB_서버_ID';
COMMENT ON COLUMN experdb_management.t_pry_svr_i.day_data_del_term IS '일별_데이터_삭제_기간';
COMMENT ON COLUMN experdb_management.t_pry_svr_i.min_data_del_term IS '분별_데이터_삭제_기간';
COMMENT ON COLUMN experdb_management.t_pry_svr_i.old_master_gbn IS '구_마스터_구분';
COMMENT ON COLUMN experdb_management.t_pry_svr_i.frst_regr_id IS '최초_등록자_ID';
COMMENT ON COLUMN experdb_management.t_pry_svr_i.frst_reg_dtm IS '최초_등록_일시';
COMMENT ON COLUMN experdb_management.t_pry_svr_i.lst_mdfr_id IS '최종_수정자_ID';
COMMENT ON COLUMN experdb_management.t_pry_svr_i.lst_mdf_dtm IS '최종_수정_일시';

-- Permissions
ALTER TABLE experdb_management.t_pry_svr_i OWNER TO experdb;
GRANT ALL ON TABLE experdb_management.t_pry_svr_i TO experdb;

-----------------------------------------------------------------------------------------

-- CRATE TABLE (PROXY GLOBAL INFO)
CREATE TABLE experdb_management.t_pry_glb_i (
	pry_glb_id numeric(18) NOT NULL DEFAULT 1,                 -- PROXY_공통_ID
	pry_svr_id numeric(18) NOT NULL DEFAULT 1,                 -- PROXY_서버_ID
	max_con_cnt numeric NULL,                                  -- 최대_연결_개수
	cl_con_max_tm varchar(20) NULL,                            -- 클라이언트_연결_최대_시간
	con_del_tm varchar(20) NULL,                               -- 커넥트_연결_지연_시간
	svr_con_max_tm varchar(20) NULL,                           -- 서버_연결_최대_시간
	chk_tm varchar(20) NULL,                                   -- 체크_시간
	if_nm varchar(20) NULL,                                    -- 인터페이스_명
	obj_ip varchar(20) NULL,                                   -- 대상_IP
	peer_server_ip varchar(20) NULL,                           -- PEER_서버_IP
	frst_regr_id varchar(30) NULL,                             -- 최초_등록자_ID
	frst_reg_dtm timestamp NOT NULL DEFAULT clock_timestamp(), -- 최초_등록_일시
	lst_mdfr_id varchar(30) NULL,                              -- 최종_수정자_ID
	lst_mdf_dtm timestamp NOT NULL DEFAULT clock_timestamp(),  -- 최종_수정_일시
	CONSTRAINT pk_t_pry_glb_i PRIMARY KEY (pry_glb_id, pry_svr_id),
	CONSTRAINT fk_t_pry_glb_i_01 FOREIGN KEY (pry_svr_id) REFERENCES t_pry_svr_i(pry_svr_id)
);
COMMENT ON TABLE experdb_management.t_pry_glb_i IS 'PROXY_공통_설정';


-- Column comments
COMMENT ON COLUMN experdb_management.t_pry_glb_i.pry_glb_id IS 'PROXY_공통_ID';
COMMENT ON COLUMN experdb_management.t_pry_glb_i.pry_svr_id IS 'PROXY_서버_ID';
COMMENT ON COLUMN experdb_management.t_pry_glb_i.max_con_cnt IS '최대_연결_개수';
COMMENT ON COLUMN experdb_management.t_pry_glb_i.cl_con_max_tm IS '클라이언트_연결_최대_시간';
COMMENT ON COLUMN experdb_management.t_pry_glb_i.con_del_tm IS '커넥트_연결_지연_시간';
COMMENT ON COLUMN experdb_management.t_pry_glb_i.svr_con_max_tm IS '서버_연결_최대_시간';
COMMENT ON COLUMN experdb_management.t_pry_glb_i.chk_tm IS '체크_시간';
COMMENT ON COLUMN experdb_management.t_pry_glb_i.if_nm IS '인터페이스_명';
COMMENT ON COLUMN experdb_management.t_pry_glb_i.obj_ip IS '대상_IP';
COMMENT ON COLUMN experdb_management.t_pry_glb_i.peer_server_ip IS 'PEER_서버_IP';
COMMENT ON COLUMN experdb_management.t_pry_glb_i.frst_regr_id IS '최초_등록자_ID';
COMMENT ON COLUMN experdb_management.t_pry_glb_i.frst_reg_dtm IS '최초_등록_일시';
COMMENT ON COLUMN experdb_management.t_pry_glb_i.lst_mdfr_id IS '최종_수정자_ID';
COMMENT ON COLUMN experdb_management.t_pry_glb_i.lst_mdf_dtm IS '최종_수정_일시';

-- Permissions
ALTER TABLE experdb_management.t_pry_glb_i OWNER TO experdb;
GRANT ALL ON TABLE experdb_management.t_pry_glb_i TO experdb;

-----------------------------------------------------------------------------------------

-- CRATE TABLE (PROXY LISNER INFO)
CREATE TABLE experdb_management.t_pry_lsn_i (
	lsn_id numeric(18) NOT NULL DEFAULT 1,                     -- 리스너_ID
	pry_svr_id numeric(18) NOT NULL DEFAULT 1,            	   -- PROXY_서버_ID
	lsn_nm varchar(50) NOT NULL,                               -- 리스너_명
	con_bind_port varchar(30) NOT NULL,                        -- 접속_포트
	lsn_desc varchar(500) NULL,                                -- 리스너_설명
	db_usr_id varchar(30) NOT NULL,                            -- DB_사용자_ID
	db_id numeric(18) NOT NULL,                                -- DB_ID
	db_nm varchar(50) NOT NULL,                                -- DB_명
	con_sim_query varchar(300) NULL,                           -- 전송_쿼리
	field_val varchar(200) NULL,                               -- 필드_값
	field_nm varchar(200) NULL,                                -- 필드_명
	lsn_exe_status varchar(20) NULL,                           -- 리스너_실행_상태
	frst_regr_id varchar(30) NULL,                             -- 최초_등록자_ID
	frst_reg_dtm timestamp NOT NULL DEFAULT clock_timestamp(), -- 최초_등록_일시
	lst_mdfr_id varchar(30) NULL,                              -- 최종_수정자_ID
	lst_mdf_dtm timestamp NOT NULL DEFAULT clock_timestamp(),  -- 최종_수정_일시
	CONSTRAINT pk_t_pry_lsn_i PRIMARY KEY (lsn_id, pry_svr_id),
	CONSTRAINT fk_t_pry_lsn_i_01 FOREIGN KEY (pry_svr_id) REFERENCES t_pry_svr_i(pry_svr_id)	
);
CREATE UNIQUE INDEX uk_t_pry_lsn_i_01 ON experdb_management.t_pry_lsn_i USING btree (pry_svr_id, lsn_nm);
COMMENT ON TABLE experdb_management.t_pry_lsn_i IS 'PROXY_리스너_정보';

-- Column comments
COMMENT ON COLUMN experdb_management.t_pry_lsn_i.lsn_id IS '리스너_ID';
COMMENT ON COLUMN experdb_management.t_pry_lsn_i.pry_svr_id IS 'PROXY_서버_ID';
COMMENT ON COLUMN experdb_management.t_pry_lsn_i.lsn_nm IS '리스너_명';
COMMENT ON COLUMN experdb_management.t_pry_lsn_i.con_bind_port IS '접속_포트';
COMMENT ON COLUMN experdb_management.t_pry_lsn_i.lsn_desc IS '리스너_설명';
COMMENT ON COLUMN experdb_management.t_pry_lsn_i.db_usr_id IS 'DB_사용자_ID';
COMMENT ON COLUMN experdb_management.t_pry_lsn_i.db_id IS 'DB_ID';
COMMENT ON COLUMN experdb_management.t_pry_lsn_i.db_nm IS 'DB_명';
COMMENT ON COLUMN experdb_management.t_pry_lsn_i.con_sim_query IS '전송_쿼리';
COMMENT ON COLUMN experdb_management.t_pry_lsn_i.field_val IS '필드_값';
COMMENT ON COLUMN experdb_management.t_pry_lsn_i.field_nm IS '필드_명';
COMMENT ON COLUMN experdb_management.t_pry_lsn_i.lsn_exe_status IS '리스너_실행_상태';
COMMENT ON COLUMN experdb_management.t_pry_lsn_i.frst_regr_id IS '최초_등록자_ID';
COMMENT ON COLUMN experdb_management.t_pry_lsn_i.frst_reg_dtm IS '최초_등록_일시';
COMMENT ON COLUMN experdb_management.t_pry_lsn_i.lst_mdfr_id IS '최종_수정자_ID';
COMMENT ON COLUMN experdb_management.t_pry_lsn_i.lst_mdf_dtm IS '최종_수정_일시';

-- Permissions
ALTER TABLE experdb_management.t_pry_lsn_i OWNER TO experdb;
GRANT ALL ON TABLE experdb_management.t_pry_lsn_i TO experdb;

-----------------------------------------------------------------------------------------


-- CRATE TABLE (PROXY LISNER SERVER INFO)
CREATE TABLE experdb_management.t_pry_lsn_svr_i (
	lsn_svr_id numeric(18) NOT NULL DEFAULT 1,                 -- 리스너_서버_ID
	db_con_addr varchar(30) NOT NULL,                          -- DB_접속_주소
	pry_svr_id numeric(18) NOT NULL DEFAULT 1,                 -- PROXY_서버_ID
	lsn_id numeric(18) NOT NULL DEFAULT 1,                     -- 리스너_ID
	chk_portno numeric(5) NULL,                                -- 체크_포트
	backup_yn bpchar(1) NOT NULL DEFAULT 'N'::bpchar,          -- 백업옵션_여부
	db_conn_ip varchar(30) NULL,                               -- DB_연결_IP
	frst_regr_id varchar(30) NULL,                             -- 최초_등록자_ID
	frst_reg_dtm timestamp NOT NULL DEFAULT clock_timestamp(), -- 최초_등록_일시
	lst_mdfr_id varchar(30) NULL,                              -- 최종_수정자_ID
	lst_mdf_dtm timestamp NOT NULL DEFAULT clock_timestamp(),  -- 최종_수정_일시
	CONSTRAINT pk_t_pry_lsn_svr_i PRIMARY KEY (lsn_svr_id, db_con_addr, pry_svr_id, lsn_id),
	CONSTRAINT fk_t_pry_lsn_svr_i_01 FOREIGN KEY (pry_svr_id, lsn_id) REFERENCES t_pry_lsn_i(pry_svr_id, lsn_id)
);
COMMENT ON TABLE experdb_management.t_pry_lsn_svr_i IS 'PROXY_리스너_서버_정보';

-- Column comments
COMMENT ON COLUMN experdb_management.t_pry_lsn_svr_i.lsn_svr_id IS '리스너_서버_ID';
COMMENT ON COLUMN experdb_management.t_pry_lsn_svr_i.db_con_addr IS 'DB_접속_주소';
COMMENT ON COLUMN experdb_management.t_pry_lsn_svr_i.pry_svr_id IS 'PROXY_서버_ID';
COMMENT ON COLUMN experdb_management.t_pry_lsn_svr_i.lsn_id IS '리스너_ID';
COMMENT ON COLUMN experdb_management.t_pry_lsn_svr_i.chk_portno IS '체크_포트';
COMMENT ON COLUMN experdb_management.t_pry_lsn_svr_i.backup_yn IS '백업옵션_여부';
COMMENT ON COLUMN experdb_management.t_pry_lsn_svr_i.db_conn_ip IS 'DB_연결_IP';
COMMENT ON COLUMN experdb_management.t_pry_lsn_svr_i.frst_regr_id IS '최초_등록자_ID';
COMMENT ON COLUMN experdb_management.t_pry_lsn_svr_i.frst_reg_dtm IS '최초_등록_일시';
COMMENT ON COLUMN experdb_management.t_pry_lsn_svr_i.lst_mdfr_id IS '최종_수정자_ID';
COMMENT ON COLUMN experdb_management.t_pry_lsn_svr_i.lst_mdf_dtm IS '최종_수정_일시';

-- Permissions
ALTER TABLE experdb_management.t_pry_lsn_svr_i OWNER TO experdb;
GRANT ALL ON TABLE experdb_management.t_pry_lsn_svr_i TO experdb;

-----------------------------------------------------------------------------------------


-- CRATE TABLE (VIP SETTING INFO)
CREATE TABLE experdb_management.t_pry_vipcng_i (
	vip_cng_id numeric(18) NOT NULL DEFAULT 1,                 -- VIP_설정_ID
	state_nm varchar(10) NOT NULL,                             -- 상태_명
	pry_svr_id numeric(18) NOT NULL DEFAULT 1,               -- PROXY_서버_ID
	v_ip varchar(20) NULL,                                     -- 가상_IP
	v_rot_id varchar(20) NULL,                                 -- 가상_라우터_ID
	v_if_nm varchar(20) NULL,                                  -- 가상_인터페이스_명
	priority numeric(18) NULL,                                  -- 우선순위
	chk_tm numeric(18) NULL,                                    -- 체크_시간
	v_ip_exe_status varchar(20) NULL,                          -- 가상_IP_실행_상태
	frst_regr_id varchar(30) NULL,                             -- 최초_등록자_ID
	frst_reg_dtm timestamp NOT NULL DEFAULT clock_timestamp(), -- 최초_등록_일시
	lst_mdfr_id varchar(30) NULL,                              -- 최종_수정자_ID
	lst_mdf_dtm timestamp NOT NULL DEFAULT clock_timestamp(),  -- 최종_수정_일시
	CONSTRAINT pk_t_pry_vipcng_i PRIMARY KEY (vip_cng_id, state_nm, pry_svr_id),
	CONSTRAINT fk_t_pry_vipcng_i_01 FOREIGN KEY (pry_svr_id) REFERENCES t_pry_svr_i(pry_svr_id)
);
COMMENT ON TABLE experdb_management.t_pry_vipcng_i IS 'VIP 설정정보';

-- Column comments
COMMENT ON COLUMN experdb_management.t_pry_vipcng_i.vip_cng_id IS 'VIP_설정_ID';
COMMENT ON COLUMN experdb_management.t_pry_vipcng_i.state_nm IS '상태_명';
COMMENT ON COLUMN experdb_management.t_pry_vipcng_i.pry_svr_id IS 'PROXY_서버_ID';
COMMENT ON COLUMN experdb_management.t_pry_vipcng_i.v_ip IS '가상_IP';
COMMENT ON COLUMN experdb_management.t_pry_vipcng_i.v_rot_id IS '가상_라우터_ID';
COMMENT ON COLUMN experdb_management.t_pry_vipcng_i.v_if_nm IS '가상_인터페이스_명';
COMMENT ON COLUMN experdb_management.t_pry_vipcng_i.priority IS '우선순위';
COMMENT ON COLUMN experdb_management.t_pry_vipcng_i.chk_tm IS '체크_시간';
COMMENT ON COLUMN experdb_management.t_pry_vipcng_i.v_ip_exe_status IS '가상_IP_실행_상태';
COMMENT ON COLUMN experdb_management.t_pry_vipcng_i.frst_regr_id IS '최초_등록자_ID';
COMMENT ON COLUMN experdb_management.t_pry_vipcng_i.frst_reg_dtm IS '최초_등록_일시';
COMMENT ON COLUMN experdb_management.t_pry_vipcng_i.lst_mdfr_id IS '최종_수정자_ID';
COMMENT ON COLUMN experdb_management.t_pry_vipcng_i.lst_mdf_dtm IS '최종_수정_일시';

-- Permissions
ALTER TABLE experdb_management.t_pry_vipcng_i OWNER TO experdb;
GRANT ALL ON TABLE experdb_management.t_pry_vipcng_i TO experdb;

-----------------------------------------------------------------------------------------


-- CRATE TABLE (PROXY SETTING HIST)
CREATE TABLE experdb_management.t_prycng_g (
	pry_cng_sn numeric NOT NULL DEFAULT 1,                   -- PROXY_설정_일련번호
	pry_svr_id numeric(18) NOT NULL DEFAULT 1,               -- PROXY_서버_ID
	pry_pth varchar(500) NOT NULL,                           -- PROXY_파일경로
	kal_pth varchar(500) NULL,                               -- KEEPALIVED_파일경로
	exe_rst_cd varchar(20) NULL,                             -- 실행_결과_코드
	frst_regr_id varchar(30) NULL,                             -- 최초_등록자_ID
	frst_reg_dtm timestamp NOT NULL DEFAULT clock_timestamp(), -- 최초_등록_일시
	lst_mdfr_id varchar(30) NULL,                              -- 최종_수정자_ID
	lst_mdf_dtm timestamp NOT NULL DEFAULT clock_timestamp(),  -- 최종_수정_일시
	CONSTRAINT pk_t_prycng_g PRIMARY KEY (pry_cng_sn, pry_svr_id),
	CONSTRAINT fk_t_prycng_g_01 FOREIGN KEY (pry_svr_id) REFERENCES t_pry_svr_i(pry_svr_id)
);
COMMENT ON TABLE experdb_management.t_prycng_g IS 'PROXY설정_이력';

-- Column comments
COMMENT ON COLUMN experdb_management.t_prycng_g.pry_cng_sn IS 'PROXY_설정_일련번호';
COMMENT ON COLUMN experdb_management.t_prycng_g.pry_svr_id IS 'PROXY_서버_ID';
COMMENT ON COLUMN experdb_management.t_prycng_g.pry_pth IS 'PROXY_파일경로';
COMMENT ON COLUMN experdb_management.t_prycng_g.kal_pth IS 'KEEPALIVED_파일경로';
COMMENT ON COLUMN experdb_management.t_prycng_g.exe_rst_cd IS '실행_결과_코드';
COMMENT ON COLUMN experdb_management.t_prycng_g.frst_regr_id IS '최초_등록자_ID';
COMMENT ON COLUMN experdb_management.t_prycng_g.frst_reg_dtm IS '최초_등록_일시';
COMMENT ON COLUMN experdb_management.t_prycng_g.lst_mdfr_id IS '최종_수정자_ID';
COMMENT ON COLUMN experdb_management.t_prycng_g.lst_mdf_dtm IS '최종_수정_일시';

-- Permissions
ALTER TABLE experdb_management.t_prycng_g OWNER TO experdb;
GRANT ALL ON TABLE experdb_management.t_prycng_g TO experdb;

-----------------------------------------------------------------------------------------



-- CRATE TABLE (PROXY act CNG HIST)
CREATE TABLE experdb_management.t_pry_actstate_cng_g (
	pry_act_exe_sn numeric NOT NULL DEFAULT 1,                -- PROXY_실행_상태_일련번호
	pry_svr_id numeric(18) NOT NULL DEFAULT 1,                -- PROXY_서버_ID
	sys_type varchar(20) NOT NULL,                            -- 시스템_유형
	act_type varchar(1) NOT NULL,                             -- 기동_유형
	act_exe_type varchar(20) NOT NULL,      	              -- 기동_실행_유형
	wrk_dtm timestamp NOT NULL DEFAULT clock_timestamp(),     -- 작업_시간
	exe_rslt_cd varchar(20) NOT NULL DEFAULT 'TC001501',      -- 실행_결과_코드
	rslt_msg varchar(300) NULL,                                -- 결과_메세지
	frst_regr_id varchar(30) NULL,                             -- 최초_등록자_ID
	frst_reg_dtm timestamp NOT NULL DEFAULT clock_timestamp(), -- 최초_등록_일시
	lst_mdfr_id varchar(30) NULL,                              -- 최종_수정자_ID
	lst_mdf_dtm timestamp NOT NULL DEFAULT clock_timestamp(),  -- 최종_수정_일시
	CONSTRAINT pk_t_pry_actstate_cng_g PRIMARY KEY (pry_act_exe_sn, pry_svr_id, sys_type, act_type),
	CONSTRAINT fk_t_pry_actstate_cng_g_01 FOREIGN KEY (pry_svr_id) REFERENCES t_pry_svr_i(pry_svr_id)
);
COMMENT ON TABLE experdb_management.t_pry_actstate_cng_g IS 'PROXY_기동상태_변경_이력';

-- Column comments
COMMENT ON COLUMN experdb_management.t_pry_actstate_cng_g.pry_act_exe_sn IS 'PROXY_실행_상태_일련번호';
COMMENT ON COLUMN experdb_management.t_pry_actstate_cng_g.pry_svr_id IS 'PROXY_서버_ID';
COMMENT ON COLUMN experdb_management.t_pry_actstate_cng_g.sys_type IS '시스템_유형';
COMMENT ON COLUMN experdb_management.t_pry_actstate_cng_g.act_type IS '기동_유형';
COMMENT ON COLUMN experdb_management.t_pry_actstate_cng_g.act_exe_type IS '기동_실행_유형';
COMMENT ON COLUMN experdb_management.t_pry_actstate_cng_g.wrk_dtm IS '작업_시간';
COMMENT ON COLUMN experdb_management.t_pry_actstate_cng_g.exe_rslt_cd IS '결과_메세지';
COMMENT ON COLUMN experdb_management.t_pry_actstate_cng_g.rslt_msg IS '실행_결과_코드';
COMMENT ON COLUMN experdb_management.t_pry_actstate_cng_g.frst_regr_id IS '최초_등록자_ID';
COMMENT ON COLUMN experdb_management.t_pry_actstate_cng_g.frst_reg_dtm IS '최초_등록_일시';
COMMENT ON COLUMN experdb_management.t_pry_actstate_cng_g.lst_mdfr_id IS '최종_수정자_ID';
COMMENT ON COLUMN experdb_management.t_pry_actstate_cng_g.lst_mdf_dtm IS '최종_수정_일시';

-- Permissions
ALTER TABLE experdb_management.t_pry_actstate_cng_g OWNER TO experdb;
GRANT ALL ON TABLE experdb_management.t_pry_actstate_cng_g TO experdb;

-----------------------------------------------------------------------------------------


-- CRATE TABLE (PROXY SERVER STATUS HIST)
CREATE TABLE experdb_management.t_pry_svr_status_g (
	pry_exe_status_sn numeric NOT NULL DEFAULT 1,             -- PROXY_실행_상태_일련번호
	log_type varchar(10) NOT NULL,                            -- 로그_유형
	pry_svr_id numeric(18) NOT NULL DEFAULT 1,                -- PROXY_서버_ID
	exe_dtm timestamp NOT NULL DEFAULT clock_timestamp(),     -- 실행_일시
	cur_session numeric NULL,                                 -- 현재_세션
	max_session numeric NULL,                                 -- 최대_세션
	session_limit numeric NULL,                               -- 세션_제한수
	cumt_sso_con_cnt numeric NULL,                            -- 누적_세션_연결_건수
	svr_pro_req_sel_cnt numeric NULL,                         -- 서버_처리_요청_선택_건수
	lst_con_rec_aft_tm varchar(100) NULL,                     -- 마지막_연결_수신_이후_시간
	byte_receive numeric NULL,                                -- 바이트_수신수
	byte_transmit numeric NULL,                               -- 바이트_송신수
	svr_status varchar(100) NULL,                             -- 서버_상태
	lst_status_chk_desc varchar(200) NULL,                    -- 마지막_상태_체크_내용
	bakup_ser_cnt numeric NULL,                               -- 백업_서버_수
	fail_chk_cnt numeric NULL,                                -- 실패_검사_수
	svr_status_chg_cnt numeric NULL,                          -- 서버_상태_전환_건수
	svr_stop_tm varchar(20) NULL,                             -- 서버_중단_시간
	exe_rslt_cd varchar(20) NOT NULL DEFAULT 'TC001501',      -- 실행_결과_코드
	lsn_id numeric(18) NOT NULL,                              -- 리스너_ID
	lsn_svr_id numeric(18) NOT NULL,                 			-- 리스너_서버_ID
	db_con_addr varchar(30) NOT NULL,                         -- DB_접속_주소
	frst_regr_id varchar(30) NULL,                             -- 최초_등록자_ID
	frst_reg_dtm timestamp NOT NULL DEFAULT clock_timestamp(), -- 최초_등록_일시
	lst_mdfr_id varchar(30) NULL,                              -- 최종_수정자_ID
	lst_mdf_dtm timestamp NOT NULL DEFAULT clock_timestamp(),  -- 최종_수정_일시
	CONSTRAINT pk_t_pry_svr_status_g PRIMARY KEY (pry_exe_status_sn, log_type, pry_svr_id),
	CONSTRAINT fk_t_pry_svr_status_g_01 FOREIGN KEY (pry_svr_id) REFERENCES t_pry_svr_i(pry_svr_id)
);
CREATE UNIQUE INDEX uk_t_pry_svr_status_g_01 ON experdb_management.t_pry_svr_status_g USING btree (pry_exe_status_sn,pry_svr_id, lsn_id);
COMMENT ON TABLE experdb_management.t_pry_svr_status_g IS 'PROXY_서버_실시간_상태_로그';

-- Column comments
COMMENT ON COLUMN experdb_management.t_pry_svr_status_g.pry_exe_status_sn IS 'PROXY_실행_상태_일련번호';
COMMENT ON COLUMN experdb_management.t_pry_svr_status_g.log_type IS '로그_유형';
COMMENT ON COLUMN experdb_management.t_pry_svr_status_g.pry_svr_id IS 'PROXY_서버_ID';
COMMENT ON COLUMN experdb_management.t_pry_svr_status_g.exe_dtm IS '실행_일시';
COMMENT ON COLUMN experdb_management.t_pry_svr_status_g.cur_session IS '현재_세션';
COMMENT ON COLUMN experdb_management.t_pry_svr_status_g.max_session IS '최대_세션';
COMMENT ON COLUMN experdb_management.t_pry_svr_status_g.session_limit IS '세션_제한수';
COMMENT ON COLUMN experdb_management.t_pry_svr_status_g.cumt_sso_con_cnt IS '누적_세션_연결_건수';
COMMENT ON COLUMN experdb_management.t_pry_svr_status_g.svr_pro_req_sel_cnt IS '서버_처리_요청_선택_건수';
COMMENT ON COLUMN experdb_management.t_pry_svr_status_g.lst_con_rec_aft_tm IS '마지막_연결_수신_이후_시간';
COMMENT ON COLUMN experdb_management.t_pry_svr_status_g.byte_receive IS '바이트_수신수';
COMMENT ON COLUMN experdb_management.t_pry_svr_status_g.byte_transmit IS '바이트_송신수';
COMMENT ON COLUMN experdb_management.t_pry_svr_status_g.svr_status IS '서버_상태';
COMMENT ON COLUMN experdb_management.t_pry_svr_status_g.lst_status_chk_desc IS '마지막_상태_체크_내용';
COMMENT ON COLUMN experdb_management.t_pry_svr_status_g.bakup_ser_cnt IS '백업_서버_수';
COMMENT ON COLUMN experdb_management.t_pry_svr_status_g.fail_chk_cnt IS '실패_검사_수';
COMMENT ON COLUMN experdb_management.t_pry_svr_status_g.svr_status_chg_cnt IS '서버_상태_전환_건수';
COMMENT ON COLUMN experdb_management.t_pry_svr_status_g.svr_stop_tm IS '서버_중단_시간';
COMMENT ON COLUMN experdb_management.t_pry_svr_status_g.exe_rslt_cd IS '실행_결과_코드';
COMMENT ON COLUMN experdb_management.t_pry_svr_status_g.lsn_id IS '리스너_ID';
COMMENT ON COLUMN experdb_management.t_pry_svr_status_g.lsn_svr_id IS '리스너_서버_ID';
COMMENT ON COLUMN experdb_management.t_pry_svr_status_g.db_con_addr IS 'DB_접속_주소';
COMMENT ON COLUMN experdb_management.t_pry_svr_status_g.frst_regr_id IS '최초_등록자_ID';
COMMENT ON COLUMN experdb_management.t_pry_svr_status_g.frst_reg_dtm IS '최초_등록_일시';
COMMENT ON COLUMN experdb_management.t_pry_svr_status_g.lst_mdfr_id IS '최종_수정자_ID';
COMMENT ON COLUMN experdb_management.t_pry_svr_status_g.lst_mdf_dtm IS '최종_수정_일시';

-- Permissions
ALTER TABLE experdb_management.t_pry_svr_status_g OWNER TO experdb;
GRANT ALL ON TABLE experdb_management.t_pry_svr_status_g TO experdb;

-----------------------------------------------------------------------------------------


-- SEQUNCE
CREATE SEQUENCE experdb_management.q_t_pry_agt_i_01;
CREATE SEQUENCE experdb_management.q_t_pry_svr_i_01;
CREATE SEQUENCE experdb_management.q_t_pry_glb_i_01;
CREATE SEQUENCE experdb_management.q_t_pry_lsn_i_01;
CREATE SEQUENCE experdb_management.q_t_pry_lsn_svr_i_01;
CREATE SEQUENCE experdb_management.q_t_pry_vipcng_i_01;
CREATE SEQUENCE experdb_management.q_t_prycng_g_01;
CREATE SEQUENCE experdb_management.q_t_pry_actstate_cng_g_01;
CREATE SEQUENCE experdb_management.q_t_pry_svr_status_g_01;

------------------------------------

INSERT INTO T_SYSGRP_C (GRP_CD, GRP_CD_NM, GRP_CD_EXP, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM )
                VALUES ( 'TC0039', '로그유형', 'PROXY 로그유형', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());

                

INSERT into T_SYSDTL_C (grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
values ('TC0039', 'TC003901', '분별', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());

INSERT into T_SYSDTL_C (grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
values ('TC0039', 'TC003902', '일별', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());



INSERT INTO T_SYSGRP_C (GRP_CD, GRP_CD_NM, GRP_CD_EXP, USE_YN, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM )
                VALUES ( 'TC0040', '로그유형', 'PROXY 기동실행상태', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());

                

INSERT into T_SYSDTL_C (grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
values ('TC0040', 'TC004001', 'MANUAL', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());

INSERT into T_SYSDTL_C (grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm)
values ('TC0040', 'TC004002', 'SYSTEM', 'Y', 'ADMIN', clock_timestamp(), 'ADMIN', clock_timestamp());
