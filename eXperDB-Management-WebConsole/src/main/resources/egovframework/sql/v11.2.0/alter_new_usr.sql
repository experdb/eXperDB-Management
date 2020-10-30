alter table t_usr_i add column sessionkey varchar(50) not null default 'none';
alter table t_usr_i add column sessionlimit timestamp;


COMMENT ON COLUMN t_usr_i.sessionkey IS 'session_key';
COMMENT ON COLUMN t_usr_i.sessionlimit IS 'session_일자';
