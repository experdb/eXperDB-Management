
--Proxy 수정 사항
--Loadbalance Option
ALTER TABLE T_PRY_LSN_I ADD COLUMN BAL_YN bpchar(1)  NULL DEFAULT 'N'::bpchar;
COMMENT ON COLUMN experdb_management.T_PRY_LSN_I.BAL_YN IS '로드발란스_사용여부';
ALTER TABLE T_PRY_LSN_I ADD COLUMN BAL_OPT varchar(10)  NULL;
COMMENT ON COLUMN experdb_management.T_PRY_LSN_I.BAL_OPT IS '로드발란스_옵션';

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
INSERT into T_SYSDTL_C 
(grp_cd, sys_cd, sys_cd_nm, use_yn, frst_regr_id, frst_reg_dtm, lst_mdfr_id, lst_mdf_dtm, sys_cd_nm_en)
values ('TC0040', 'TC004003', 'Auto Scale', 'Y', 'system', clock_timestamp(), 'system', clock_timestamp(), 'Auto Scale');

--AWS 환경 Option
ALTER TABLE experdb_management.t_pry_agt_i ADD aws_yn bpchar(1) NOT NULL DEFAULT 'N';
COMMENT ON COLUMN experdb_management.t_pry_agt_i.aws_yn IS 'AWS_환경_여부';
ALTER TABLE experdb_management.t_pry_vipcng_i ADD aws_if_id varchar(30) NULL;
COMMENT ON COLUMN experdb_management.t_pry_vipcng_i.aws_if_id IS 'AWS_네트워크_인터페이스_ID';
ALTER TABLE experdb_management.t_pry_vipcng_i ADD peer_aws_if_id varchar(30) NULL;
COMMENT ON COLUMN experdb_management.t_pry_vipcng_i.peer_aws_if_id IS 'AWS_Peer_네트워크_인터페이스_ID';

UPDATE T_PRY_AGT_I SET AWS_YN='N';


-- CDC ---------------------------------------------------------------------------------------------
-- trans 모니터링 테이블 메뉴 추가
ALTER TABLE t_usrdbsvraut_i ADD COLUMN trans_mtr_aut_yn bpchar(1) NULL;
COMMENT ON COLUMN experdb_management.t_usrdbsvraut_i.trans_mtr_aut_yn IS 'connector_모니터링_여부';


-- T_TRANSCNG_I 테이블 시작-------------------
COMMENT ON TABLE experdb_management.T_TRANSCNG_I IS '전송설정_소스시스템_정보';

-- 인덱스 추가
CREATE INDEX IDX_TRANSCNG_I_01 ON T_TRANSCNG_I(DB_SVR_ID, CONNECT_NM);
CREATE INDEX IDX_TRANSCNG_I_02 ON T_TRANSCNG_I(DB_SVR_ID, EXE_STATUS);

-- defalut 추가
ALTER TABLE experdb_management.T_TRANSCNG_I ALTER COLUMN TRANS_COM_ID SET DEFAULT 0;

-- not null 추가
ALTER TABLE experdb_management.T_TRANSCNG_I ALTER COLUMN TRANS_COM_ID SET NOT NULL;

--FK 추가
ALTER TABLE experdb_management.T_TRANSCNG_I ADD CONSTRAINT fk_t_transcng_i_03 FOREIGN KEY(TRANS_COM_ID) REFERENCES t_transcomcng_i(TRANS_COM_ID);

-- comment 변경
COMMENT ON COLUMN experdb_management.T_TRANSCNG_I.kc_ip IS 'kafka커넥트_IP';
COMMENT ON COLUMN experdb_management.T_TRANSCNG_I.kc_port IS 'kafka커넥트_포트';
COMMENT ON COLUMN experdb_management.T_TRANSCNG_I.connect_nm IS '커넥트_명';
COMMENT ON COLUMN experdb_management.T_TRANSCNG_I.snapshot_mode IS '스냅샷_모드';
COMMENT ON COLUMN experdb_management.T_TRANSCNG_I.db_id IS '디비_ID';
COMMENT ON COLUMN experdb_management.T_TRANSCNG_I.trans_com_id IS '전송_기본설정_ID';
COMMENT ON COLUMN experdb_management.T_TRANSCNG_I.trans_exrt_trg_tb_id IS '전송_대상_테이블_ID';
COMMENT ON COLUMN experdb_management.T_TRANSCNG_I.trans_exrt_exct_tb_id IS '전송_제외_테이블_ID';
COMMENT ON COLUMN experdb_management.t_transcng_i.db_svr_id IS 'DB_서버_ID';
COMMENT ON COLUMN experdb_management.t_transcng_i.exe_status IS '실행_상태';
COMMENT ON COLUMN experdb_management.t_transcng_i.compression_type IS '압축_형태';
COMMENT ON COLUMN experdb_management.t_transcng_i.meta_data IS '메타_데이터';
COMMENT ON COLUMN experdb_management.t_transcng_i.kc_id IS 'kafka_커넥트_ID';

-- T_TRANSCNG_I 테이블 종료 ---------------


-- T_TRANSCNG_TARGET_I 테이블 시작-------------------
COMMENT ON TABLE experdb_management.t_transcng_target_i IS '전송설정_타겟시스템_정보';

-- 인덱스 추가
CREATE INDEX IDX_TRANSCNG_TARGET_I_01 ON T_TRANSCNG_TARGET_I(DB_SVR_ID, CONNECT_NM);
CREATE INDEX IDX_TRANSCNG_TARGET_I_02 ON T_TRANSCNG_TARGET_I(EXE_STATUS);
CREATE INDEX IDX_TRANSCNG_TARGET_I_03 ON T_TRANSCNG_TARGET_I(KC_ID);

-- 컬럼명 변경
ALTER TABLE experdb_management.T_TRANSCNG_TARGET_I RENAME COLUMN TRANS_TRG_SYS_ID TO TRANS_SYS_ID;
-- defalut 추가
ALTER TABLE experdb_management.T_TRANSCNG_TARGET_I ALTER COLUMN TRANS_SYS_ID SET DEFAULT 0;
--FK 추가
ALTER TABLE experdb_management.T_TRANSCNG_TARGET_I ADD CONSTRAINT fk_t_transcng_target_i_03 FOREIGN KEY(TRANS_SYS_ID) REFERENCES t_trans_sys_inf(TRANS_SYS_ID);

--COMMENT 추가
COMMENT ON COLUMN experdb_management.t_transcng_target_i.trans_id IS '전송_ID';
COMMENT ON COLUMN experdb_management.t_transcng_target_i.kc_ip IS 'kafka커넥트_IP';
COMMENT ON COLUMN experdb_management.t_transcng_target_i.kc_port IS 'kafka커넥트_PORT';
COMMENT ON COLUMN experdb_management.t_transcng_target_i.connect_nm IS '커넥트_명';
COMMENT ON COLUMN experdb_management.t_transcng_target_i.db_svr_id IS '디비_서버_ID';
COMMENT ON COLUMN experdb_management.t_transcng_target_i.trans_sys_id IS '전송_시스템_ID';
COMMENT ON COLUMN experdb_management.t_transcng_target_i.snapshot_mode IS '스냅샷_모드';
COMMENT ON COLUMN experdb_management.t_transcng_target_i.trans_exrt_trg_tb_id IS '전송_대상_테이블_ID';
COMMENT ON COLUMN experdb_management.t_transcng_target_i.trans_exrt_exct_tb_id IS '전송_제외_테이블_ID';
COMMENT ON COLUMN experdb_management.t_transcng_target_i.frst_regr_id IS '최초_등록자_ID';
COMMENT ON COLUMN experdb_management.t_transcng_target_i.frst_reg_dtm IS '최초_등록_일시';
COMMENT ON COLUMN experdb_management.t_transcng_target_i.lst_mdfr_id IS '최종_수정자_ID';
COMMENT ON COLUMN experdb_management.t_transcng_target_i.lst_mdf_dtm IS '최종_수정_일시';
COMMENT ON COLUMN experdb_management.t_transcng_target_i.exe_status IS '실행_상태';
COMMENT ON COLUMN experdb_management.t_transcng_target_i.kc_id IS 'kafka커넥트_ID';

-- T_TRANSCNG_TARGET_I 테이블 종료 ---------------


-- T_TRANS_SYS_INF 테이블 시작-------------------
COMMENT ON TABLE experdb_management.t_trans_sys_inf IS 'TRANS_시스템_정보';

-- 인덱스 추가
CREATE INDEX IDX_TRANS_SYS_INF_01 ON T_TRANS_SYS_INF(TRANS_SYS_NM);

-- 실행_상태
ALTER TABLE experdb_management.t_trans_sys_inf ADD COLUMN exe_status varchar(20) NOT NULL DEFAULT 'TC001502'::character varying;
COMMENT ON COLUMN experdb_management.t_trans_sys_inf.exe_status IS '실행상태';

--COMMENT 변경
COMMENT ON COLUMN experdb_management.t_trans_sys_inf.trans_sys_id IS '전송_시스템_ID';
COMMENT ON COLUMN experdb_management.t_trans_sys_inf.trans_sys_nm IS '전송_시스템_명';
COMMENT ON COLUMN experdb_management.t_trans_sys_inf.dbms_dscd IS 'DBMS_구분코드';
COMMENT ON COLUMN experdb_management.t_trans_sys_inf.ipadr IS 'IP주소';
COMMENT ON COLUMN experdb_management.t_trans_sys_inf.spr_usr_id IS '슈퍼_사용자_ID';

-- T_TRANS_SYS_INF 테이블 종료 ---------------


-- t_trans_exrttrg_mapp 테이블 시작-------------------
COMMENT ON TABLE experdb_management.t_trans_exrttrg_mapp IS '전송_대상_매핑_정보';

-- COMMENT 변경
COMMENT ON COLUMN experdb_management.t_trans_exrttrg_mapp.trans_exrt_trg_tb_id IS '전송_대상_테이블_ID';
COMMENT ON COLUMN experdb_management.t_trans_exrttrg_mapp.exrt_trg_tb_nm IS '전송_대상_테이블_명';
COMMENT ON COLUMN experdb_management.t_trans_exrttrg_mapp.exrt_trg_scm_nm IS '전송_대상_스키마_명';
COMMENT ON COLUMN experdb_management.t_trans_exrttrg_mapp.schema_total_cnt IS '스키마_총_수';
COMMENT ON COLUMN experdb_management.t_trans_exrttrg_mapp.table_total_cnt IS '테이블_총_수';
COMMENT ON COLUMN experdb_management.t_trans_exrttrg_mapp.frst_regr_id IS '최초_등록자_ID';
COMMENT ON COLUMN experdb_management.t_trans_exrttrg_mapp.frst_reg_dtm IS '최초_등록_일시';
-- t_trans_exrttrg_mapp 테이블 끝-------------------


-- t_trans_exrtexct_mapp 테이블 시작-------------------
COMMENT ON TABLE experdb_management.t_trans_exrtexct_mapp IS '전송_제외_매핑_정보';

-- COMMENT 변경
COMMENT ON COLUMN experdb_management.t_trans_exrtexct_mapp.trans_exrt_exct_tb_id IS '전송_제외_테이블_ID';
COMMENT ON COLUMN experdb_management.t_trans_exrtexct_mapp.exrt_exct_tb_nm IS '전송_제외_테이블_명';
COMMENT ON COLUMN experdb_management.t_trans_exrtexct_mapp.exrt_exct_scm_nm IS '전송_제외_스키마_명';
COMMENT ON COLUMN experdb_management.t_trans_exrtexct_mapp.schema_total_cnt IS '스키마_총_수';
COMMENT ON COLUMN experdb_management.t_trans_exrtexct_mapp.table_total_cnt IS '테이블_총_수';
-- t_trans_exrtexct_mapp 테이블 끝-------------------


-- t_trans_con_inf 테이블 시작-------------------
COMMENT ON TABLE experdb_management.t_trans_con_inf IS 'trans_커넥트_정보';

-- COMMENT 변경
COMMENT ON COLUMN experdb_management.t_trans_con_inf.kc_id IS 'kafka커넥트_ID';
COMMENT ON COLUMN experdb_management.t_trans_con_inf.kc_nm IS 'kafka커넥트_명';
COMMENT ON COLUMN experdb_management.t_trans_con_inf.kc_ip IS 'kafka커넥트_IP';
COMMENT ON COLUMN experdb_management.t_trans_con_inf.kc_port IS 'kafka커넥트_포트';
COMMENT ON COLUMN experdb_management.t_trans_con_inf.frst_regr_id IS '최초_등록자_ID';
COMMENT ON COLUMN experdb_management.t_trans_con_inf.lst_mdfr_id IS '최종_수정자_ID';
COMMENT ON COLUMN EXPERDB_MANAGEMENT.t_trans_con_inf.EXE_STATUS IS '실행_상태';
-- t_trans_con_inf 테이블 끝-------------------


-- t_transcomcng_i 테이블 시작-------------------
COMMENT ON TABLE experdb_management.t_transcomcng_i IS 'TRANS_공통_설정_정보';

--NOT NULL 추가
ALTER TABLE experdb_management.t_transcomcng_i ALTER COLUMN TRANSFORMS_YN SET NOT NULL;

-- COMMENT 변경
COMMENT ON COLUMN experdb_management.t_transcomcng_i.trans_com_id IS '전송_기본_ID';
COMMENT ON COLUMN experdb_management.t_transcomcng_i.trans_com_cng_nm IS '전송_기본_설정_명';
COMMENT ON COLUMN experdb_management.t_transcomcng_i.plugin_name IS '플러그인_명';
COMMENT ON COLUMN experdb_management.t_transcomcng_i.heartbeat_interval_ms IS 'heartbeat_interval_ms';
COMMENT ON COLUMN experdb_management.t_transcomcng_i.heartbeat_action_query IS 'heartbeat_action_query';
COMMENT ON COLUMN experdb_management.t_transcomcng_i.max_batch_size IS 'max_batch_size';
COMMENT ON COLUMN experdb_management.t_transcomcng_i.max_queue_size IS 'max_queue_size';
COMMENT ON COLUMN experdb_management.t_transcomcng_i.offset_flush_interval_ms IS 'offset_flush_interval_ms';
COMMENT ON COLUMN experdb_management.t_transcomcng_i.offset_flush_timeout_ms IS 'offset_flush_timeout_ms';
COMMENT ON COLUMN experdb_management.t_transcomcng_i.auto_create IS 'auto_create';
COMMENT ON COLUMN experdb_management.t_transcomcng_i.transforms_yn IS 'transforms_yn';
COMMENT ON COLUMN experdb_management.t_transcomcng_i.frst_regr_id IS '최초_등록자_ID';
COMMENT ON COLUMN experdb_management.t_transcomcng_i.frst_reg_dtm IS '최초_등록_일시';
COMMENT ON COLUMN experdb_management.t_transcomcng_i.lst_mdfr_id IS '최종_수정자_ID';
COMMENT ON COLUMN experdb_management.t_transcomcng_i.lst_mdf_dtm IS '최종_수정_일시';
-- t_transcomcng_i 테이블 끝-------------------

-- t_trans_topic_i 토픽 테이블 추가 시작------
CREATE TABLE experdb_management.t_trans_topic_i (
	topic_id numeric NOT NULL, -- 토픽_ID
	topic_nm text not NULL, -- 토픽명
	src_trans_exrt_trg_tb_id numeric NOT NULL, -- 소스_전송_대상_아이디
  	tar_trans_exrt_trg_tb_id numeric NULL, -- 소스_전송_대상_아이디
	src_trans_id numeric NOT NULL, -- 소스_전송_아이디
  	tar_trans_id numeric NULL, -- 타겟_전송_아이디
	table_total_cnt numeric NULL, -- 전송대상테이블수
 	src_topic_use_yn varchar(1) NOT NULL DEFAULT 'N', -- 소스_토픽_사용여부
    write_use_yn varchar(1) NOT NULL DEFAULT 'Y', -- 등록 사용여부
	frst_regr_id varchar(30) NULL, -- 최초_등록자_ID
	frst_reg_dtm timestamp NOT NULL, -- 최초_등록_일시
	lst_mdfr_id varchar(30) NULL,
	lst_mdf_dtm timestamp NOT NULL DEFAULT clock_timestamp(),
	CONSTRAINT pk_t_trans_topic_i PRIMARY KEY (topic_id, topic_nm, src_trans_id)
);
COMMENT ON TABLE experdb_management.t_trans_topic_i IS 'TRANS_토픽_정보';

-- Column comments
COMMENT ON COLUMN experdb_management.t_trans_topic_i.topic_id IS '토픽_ID';
COMMENT ON COLUMN experdb_management.t_trans_topic_i.topic_nm IS '토픽_명';
COMMENT ON COLUMN experdb_management.t_trans_topic_i.src_trans_exrt_trg_tb_id IS '소스_전송_대상_테이블_ID';
COMMENT ON COLUMN experdb_management.t_trans_topic_i.tar_trans_exrt_trg_tb_id IS '타겟_전송_대상_테이블_ID';
COMMENT ON COLUMN experdb_management.t_trans_topic_i.src_trans_id IS '소스_전송_ID';
COMMENT ON COLUMN experdb_management.t_trans_topic_i.tar_trans_id IS '타겟_전송_ID';
COMMENT ON COLUMN experdb_management.t_trans_topic_i.table_total_cnt IS '테이블_총_수';
COMMENT ON COLUMN experdb_management.t_trans_topic_i.src_topic_use_yn IS '소스_토픽_사용_여부';
COMMENT ON COLUMN experdb_management.t_trans_topic_i.write_use_yn IS '등록_사용_여부';
COMMENT ON COLUMN experdb_management.t_trans_topic_i.frst_regr_id IS '최초_등록자_ID';
COMMENT ON COLUMN experdb_management.t_trans_topic_i.frst_reg_dtm IS '최초_등록_일시';
COMMENT ON COLUMN experdb_management.t_trans_topic_i.lst_mdfr_id IS '최종_수정자_ID';
COMMENT ON COLUMN experdb_management.t_trans_topic_i.lst_mdf_dtm IS '최종_수정_일시';

CREATE SEQUENCE Q_T_TRANS_TOPIC_I_01;
-- t_trans_topic_i 토픽 테이블 추가 끝------


-- cdc_rs_connector_cpu 테이블 추가 시작------
CREATE TABLE experdb_management.cdc_rs_connector_cpu (
	"time" timestamp NOT NULL DEFAULT clock_timestamp(),
	system_cpu_load numeric NOT NULL,
	process_cpu_load numeric NOT NULL,
	CONSTRAINT pk_cdc_rs_connector_cpu PRIMARY KEY ("time")
);
COMMENT ON TABLE experdb_management.cdc_rs_connector_cpu IS 'CDC_커넥터_CPU';

-- Column comments
COMMENT ON COLUMN experdb_management.cdc_rs_connector_cpu."time" IS '시간';
COMMENT ON COLUMN experdb_management.cdc_rs_connector_cpu.system_cpu_load IS '시스템_CPU_로드';
COMMENT ON COLUMN experdb_management.cdc_rs_connector_cpu.process_cpu_load IS '프로세스_CPU_로드';
-- cdc_rs_connector_cpu 테이블 추가 끝------


-- cdc_rs_connector_mem 테이블 추가 시작------
CREATE TABLE experdb_management.cdc_rs_connector_mem (
	"time" timestamp NOT NULL DEFAULT clock_timestamp(), -- 시간
	used numeric NOT NULL, -- 시용
	CONSTRAINT pk_cdc_rs_connector_mem PRIMARY KEY ("time")
);
COMMENT ON TABLE experdb_management.cdc_rs_connector_mem IS 'CDC_커넥터_MEMORY';

-- Column comments

COMMENT ON COLUMN experdb_management.cdc_rs_connector_mem."time" IS '시간';
COMMENT ON COLUMN experdb_management.cdc_rs_connector_mem.used IS '시용';
-- cdc_rs_connector_mem 테이블 추가 끝 ------


-- cdc_dbserver_snapshot 테이블 추가 시작------
CREATE TABLE experdb_management.cdc_dbserver_snapshot (
	"time" timestamp NOT NULL DEFAULT clock_timestamp(), -- 시간
	connector_src_name varchar(200) NOT NULL, -- 커넥터_소스_명
	number_of_events_filtered numeric NOT NULL, -- 필터링_된_이벤트_수 
	number_of_erroneous_events numeric NOT NULL, -- 오류_난_이벤트_수
	queue_total_capacity numeric NOT NULL, -- 대기열_총_용량
	queue_remaining_capacity numeric NOT NULL, -- 대기열_남은_용량
	remaining_table_count numeric NOT NULL, -- 남은_테이블_수
	CONSTRAINT pk_cdc_dbserver_snapshot PRIMARY KEY ("time", connector_src_name)
);
COMMENT ON TABLE experdb_management.cdc_dbserver_snapshot IS 'CDC_DB서버_스냅샷';

-- Column comments

COMMENT ON COLUMN experdb_management.cdc_dbserver_snapshot."time" IS '시간';
COMMENT ON COLUMN experdb_management.cdc_dbserver_snapshot.connector_src_name IS '커넥터_소스_명';
COMMENT ON COLUMN experdb_management.cdc_dbserver_snapshot.number_of_events_filtered IS '필터링_된_이벤트_수 ';
COMMENT ON COLUMN experdb_management.cdc_dbserver_snapshot.number_of_erroneous_events IS '오류_난_이벤트_수';
COMMENT ON COLUMN experdb_management.cdc_dbserver_snapshot.queue_total_capacity IS '대기열_총_용량';
COMMENT ON COLUMN experdb_management.cdc_dbserver_snapshot.queue_remaining_capacity IS '대기열_남은_용량';
COMMENT ON COLUMN experdb_management.cdc_dbserver_snapshot.remaining_table_count IS '남은_테이블_수';
-- cdc_dbserver_snapshot 테이블 추가 끝 ------


-- cdc_dbserver_streaming 테이블 추가 시작------
CREATE TABLE experdb_management.cdc_dbserver_streaming (
	"time" timestamp NOT NULL DEFAULT clock_timestamp(), -- 시간
	connector_src_name varchar(200) NOT NULL, -- 커넥터_소스_명
	milli_seconds_behind_source numeric NOT NULL, -- 소스_지연_시간 
	number_of_committed_transactions numeric NULL DEFAULT 0, -- commit_트랙젝션_수
	last_transaction_id numeric NOT NULL, -- 마지막_트랙젝션_ID
	milli_seconds_since_last_event numeric NOT NULL, -- 마지막_이벤트_후_밀리초
	total_number_of_events_seen numeric NOT NULL, -- 이벤트_총_수
	number_of_events_filtered numeric NOT NULL, -- 필터링_된_이벤트_수
	number_of_erroneous_events numeric NOT NULL, -- 오류난_이벤트_수
	queue_total_capacity numeric NOT NULL, -- 대기열_총_용량
	queue_remaining_capacity numeric NOT NULL, -- 대기열_남은_용량
	CONSTRAINT pk_cdc_dbserver_streaming PRIMARY KEY ("time", connector_src_name)
);
COMMENT ON TABLE experdb_management.cdc_dbserver_streaming IS 'CDC_DB서버_스트리밍';

-- Column comments
COMMENT ON COLUMN experdb_management.cdc_dbserver_streaming."time" IS '시간';
COMMENT ON COLUMN experdb_management.cdc_dbserver_streaming.connector_src_name IS '커넥터_소스_명';
COMMENT ON COLUMN experdb_management.cdc_dbserver_streaming.milli_seconds_behind_source IS '소스_지연_시간 ';
COMMENT ON COLUMN experdb_management.cdc_dbserver_streaming.number_of_committed_transactions IS 'commit_트랙젝션_수';
COMMENT ON COLUMN experdb_management.cdc_dbserver_streaming.last_transaction_id IS '마지막_트랙젝션_ID';
COMMENT ON COLUMN experdb_management.cdc_dbserver_streaming.milli_seconds_since_last_event IS '마지막_이벤트_후_밀리초';
COMMENT ON COLUMN experdb_management.cdc_dbserver_streaming.total_number_of_events_seen IS '이벤트_총_수';
COMMENT ON COLUMN experdb_management.cdc_dbserver_streaming.number_of_events_filtered IS '필터링_된_이벤트_수';
COMMENT ON COLUMN experdb_management.cdc_dbserver_streaming.number_of_erroneous_events IS '오류난_이벤트_수';
COMMENT ON COLUMN experdb_management.cdc_dbserver_streaming.queue_total_capacity IS '대기열_총_용량';
COMMENT ON COLUMN experdb_management.cdc_dbserver_streaming.queue_remaining_capacity IS '대기열_남은_용량';
-- cdc_dbserver_streaming 테이블 추가 끝 ------


-- cdc_connector_task_src 테이블 추가 시작------
CREATE TABLE experdb_management.cdc_connector_task_src (
	"time" timestamp NOT NULL DEFAULT clock_timestamp(), -- 시간
	connector_name varchar(200) NOT NULL, -- 커넥터_명
	source_record_active_count_max numeric NULL, -- kafka_기록되지_않은_소스_레코드_max 
	source_record_write_rate numeric NULL, -- kafka_기록된_초당_평균_소스_레코드_수
	source_record_poll_total numeric NULL, -- 폴링_된_총_소스_레코드_수
	source_record_poll_rate numeric NULL, -- 폴링_소스_평균_시간
	source_record_active_count numeric NULL, -- kafka_기록되지_않은_소스_레코드_수
	source_record_active_count_avg numeric NULL, -- kafka_기록되지_않은_평균_소스_레코드_수
	source_record_write_total numeric NULL, -- kafka_기록된_총_소스_레코드_수
	last_error_timestamp numeric NULL, -- 마지막_에러_시간
	total_errors_logged numeric NULL, -- 기록_된_오류_수
	deadletterqueue_produce_requests numeric NULL, -- 쓰기_시도_횟수
	deadletterqueue_produce_failures numeric NULL, -- 쓰기_실패_횟수
	total_record_failures numeric NULL, -- 레코드_처리_실패_총_수
	total_records_skipped numeric NULL, -- 미처리_레코드_총_수
	total_record_errors numeric NULL, -- 오류_총_수
	total_retries numeric NULL, -- 재시도_작업_총_수
	CONSTRAINT pk_cdc_connector_task_src PRIMARY KEY ("time", connector_name)
);
COMMENT ON TABLE experdb_management.cdc_connector_task_src IS 'CDC_소스_커넥터_통계';

-- Column comments
COMMENT ON COLUMN experdb_management.cdc_connector_task_src."time" IS '시간';
COMMENT ON COLUMN experdb_management.cdc_connector_task_src.connector_name IS '커넥터_명';
COMMENT ON COLUMN experdb_management.cdc_connector_task_src.source_record_active_count_max IS 'kafka_기록되지_않은_소스_레코드_max ';
COMMENT ON COLUMN experdb_management.cdc_connector_task_src.source_record_write_rate IS 'kafka_기록된_초당_평균_소스_레코드_수';
COMMENT ON COLUMN experdb_management.cdc_connector_task_src.source_record_poll_total IS '폴링_된_총_소스_레코드_수';
COMMENT ON COLUMN experdb_management.cdc_connector_task_src.source_record_poll_rate IS '폴링_소스_평균_시간';
COMMENT ON COLUMN experdb_management.cdc_connector_task_src.source_record_active_count IS 'kafka_기록되지_않은_소스_레코드_수';
COMMENT ON COLUMN experdb_management.cdc_connector_task_src.source_record_active_count_avg IS 'kafka_기록되지_않은_평균_소스_레코드_수';
COMMENT ON COLUMN experdb_management.cdc_connector_task_src.source_record_write_total IS 'kafka_기록된_총_소스_레코드_수';
COMMENT ON COLUMN experdb_management.cdc_connector_task_src.last_error_timestamp IS '마지막_에러_시간';
COMMENT ON COLUMN experdb_management.cdc_connector_task_src.total_errors_logged IS '기록_된_오류_수';
COMMENT ON COLUMN experdb_management.cdc_connector_task_src.deadletterqueue_produce_requests IS '쓰기_시도_횟수';
COMMENT ON COLUMN experdb_management.cdc_connector_task_src.deadletterqueue_produce_failures IS '쓰기_실패_횟수';
COMMENT ON COLUMN experdb_management.cdc_connector_task_src.total_record_failures IS '레코드_처리_실패_총_수';
COMMENT ON COLUMN experdb_management.cdc_connector_task_src.total_records_skipped IS '미처리_레코드_총_수';
COMMENT ON COLUMN experdb_management.cdc_connector_task_src.total_record_errors IS '오류_총_수';
COMMENT ON COLUMN experdb_management.cdc_connector_task_src.total_retries IS '재시도_작업_총_수';
-- cdc_connector_task_src 테이블 추가 끝------


-- cdc_connector_task_sink 테이블 추가 시작------
CREATE TABLE experdb_management.cdc_connector_task_sink (
	"time" timestamp NOT NULL DEFAULT clock_timestamp(), -- 시간
	connector_name varchar(200) NOT NULL, -- 커넥터_명
	sink_record_active_count numeric NULL DEFAULT 0, -- 싱크_중_레코드_수 
	put_batch_avg_time_ms numeric NULL DEFAULT 0, -- 싱크_레코드_배치_평균_시간 
	sink_record_active_count_max numeric NULL DEFAULT 0, -- 싱크_중_최대_레코드_수 
	offset_commit_completion_rate numeric NULL DEFAULT 0, -- 오프셋_초당_평균_커밋_완료_시간 
	sink_record_send_total numeric NULL DEFAULT 0, -- 싱크_완료_총_수 
	partition_count numeric NULL DEFAULT 0, -- 파티션_수 
	sink_record_active_count_avg numeric NULL DEFAULT 0, -- 싱크_작업_평균_레코드_수 
	sink_record_read_rate numeric NULL DEFAULT 0, -- 읽기_초당_평균_레코드_수 
	sink_record_send_rate numeric NULL DEFAULT 0, -- 쓰기_초당_평균_레코드_수 
	offset_commit_completion_total numeric NULL DEFAULT 0, -- 오프셋_완료_총_커밋_수 
	offset_commit_skip_rate numeric NULL DEFAULT 0, -- 오프셋_무시된_평균_커밋_수 
	put_batch_max_time_ms numeric NULL DEFAULT 0, -- 싱크_레코드_배치_최대_시간 
	offset_commit_seq_no numeric NULL DEFAULT 0, -- 오프셋_커밋_시퀀스_번호 
	offset_commit_skip_total numeric NULL DEFAULT 0, -- 오프셋_무시된_총_커밋_수 
	sink_record_read_total numeric NULL DEFAULT 0, -- 마지막_재시작_후_읽은_레코드_총_수 
	last_error_timestamp numeric NULL DEFAULT 0, -- 마지막_에러_시간 
	total_errors_logged numeric NULL DEFAULT 0, -- 기록_된_오류_수 
	deadletterqueue_produce_requests numeric NULL DEFAULT 0, -- 쓰기_시도_횟수 
	deadletterqueue_produce_failures numeric NULL DEFAULT 0, -- 쓰기_실패_횟수 
	total_record_failures numeric NULL DEFAULT 0, -- 레코드_처리_실패_총_수 
	total_records_skipped numeric NULL DEFAULT 0, -- 미처리_레코드_총_수 
	total_record_errors numeric NULL DEFAULT 0, -- 오류_총_수 
	total_retries numeric NULL DEFAULT 0, -- 재시도_작업_총_수 
	CONSTRAINT pk_cdc_connector_task_sink PRIMARY KEY ("time", connector_name)
);
COMMENT ON TABLE experdb_management.cdc_connector_task_sink IS 'CDC_싱크_커넥터_통계';

-- Column comments
COMMENT ON COLUMN experdb_management.cdc_connector_task_sink."time" IS '시간';
COMMENT ON COLUMN experdb_management.cdc_connector_task_sink.connector_name IS '커넥터_명';
COMMENT ON COLUMN experdb_management.cdc_connector_task_sink.sink_record_active_count IS '싱크_중_레코드_수';
COMMENT ON COLUMN experdb_management.cdc_connector_task_sink.put_batch_avg_time_ms IS '싱크_레코드_배치_평균_시간';
COMMENT ON COLUMN experdb_management.cdc_connector_task_sink.sink_record_active_count_max IS '싱크_중_최대_레코드_수';
COMMENT ON COLUMN experdb_management.cdc_connector_task_sink.offset_commit_completion_rate IS '오프셋_초당_평균_커밋_완료_시간';
COMMENT ON COLUMN experdb_management.cdc_connector_task_sink.sink_record_send_total IS '싱크_완료_총_수';
COMMENT ON COLUMN experdb_management.cdc_connector_task_sink.partition_count IS '파티션_수 ';
COMMENT ON COLUMN experdb_management.cdc_connector_task_sink.sink_record_active_count_avg IS '싱크_작업_평균_레코드_수';
COMMENT ON COLUMN experdb_management.cdc_connector_task_sink.sink_record_read_rate IS '읽기_초당_평균_레코드_수';
COMMENT ON COLUMN experdb_management.cdc_connector_task_sink.sink_record_send_rate IS '쓰기_초당_평균_레코드_수';
COMMENT ON COLUMN experdb_management.cdc_connector_task_sink.offset_commit_completion_total IS '오프셋_완료_총_커밋_수';
COMMENT ON COLUMN experdb_management.cdc_connector_task_sink.offset_commit_skip_rate IS '오프셋_무시된_평균_커밋_수';
COMMENT ON COLUMN experdb_management.cdc_connector_task_sink.put_batch_max_time_ms IS '싱크_레코드_배치_최대_시간';
COMMENT ON COLUMN experdb_management.cdc_connector_task_sink.offset_commit_seq_no IS '오프셋_커밋_시퀀스_번호';
COMMENT ON COLUMN experdb_management.cdc_connector_task_sink.offset_commit_skip_total IS '오프셋_무시된_총_커밋_수';
COMMENT ON COLUMN experdb_management.cdc_connector_task_sink.sink_record_read_total IS '마지막_재시작_후_읽은_레코드_총_수';
COMMENT ON COLUMN experdb_management.cdc_connector_task_sink.last_error_timestamp IS '마지막_에러_시간';
COMMENT ON COLUMN experdb_management.cdc_connector_task_sink.total_errors_logged IS '기록_된_오류_수';
COMMENT ON COLUMN experdb_management.cdc_connector_task_sink.deadletterqueue_produce_requests IS '쓰기_시도_횟수';
COMMENT ON COLUMN experdb_management.cdc_connector_task_sink.deadletterqueue_produce_failures IS '쓰기_실패_횟수';
COMMENT ON COLUMN experdb_management.cdc_connector_task_sink.total_record_failures IS '레코드_처리_실패_총_수';
COMMENT ON COLUMN experdb_management.cdc_connector_task_sink.total_records_skipped IS '미처리_레코드_총_수';
COMMENT ON COLUMN experdb_management.cdc_connector_task_sink.total_record_errors IS '오류_총_수';
COMMENT ON COLUMN experdb_management.cdc_connector_task_sink.total_retries IS '재시도_작업_총_수';
-- cdc_connector_task_sink 테이블 추가 끝------