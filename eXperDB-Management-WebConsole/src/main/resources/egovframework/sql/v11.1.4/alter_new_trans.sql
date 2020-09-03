ALTER TABLE T_TRANSCNG_I ADD COLUMN meta_data varchar(50);
COMMENT ON COLUMN T_TRANSCNG_I.meta_data IS '메타데이터 사용유무';