ALTER TABLE experdb_management.t_trans_encrypt ADD salt_key varchar(100) NULL;
COMMENT ON COLUMN experdb_management.t_trans_encrypt.salt_key IS 'salt값';

UPDATE T_USR_I SET PWD = '60c624e9763eb6f0f88a37756c404e173d10a5bf7cfbf59d747772681469e584', encp_use_yn='Y' WHERE USR_ID = 'experdb';
UPDATE T_USR_I SET PWD = '9f77637ab35a8f08650b5dcab525722418a3062d38949fba22d33d168978c1d2' WHERE USR_ID = 'admin';

WITH UPSERT AS(UPDATE T_TRANS_ENCRYPT SET SALT_KEY = '94f3e5b50df6b9ea6442', TRANS_CHK_KEY = 'UP7x6XqHQsGUZoa5ZXphGQ=='
                WHERE TRANS_ID  = 'experdb' RETURNING *)
               INSERT INTO T_TRANS_ENCRYPT (TRANS_ID, TRANS_CHK_KEY, SALT_KEY, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM)
               SELECT 'experdb', 'UP7x6XqHQsGUZoa5ZXphGQ==', '94f3e5b50df6b9ea6442', 'admin', clock_timestamp(), 'admin', clock_timestamp()
         WHERE NOT EXISTS ( SELECT * FROM UPSERT );

WITH UPSERT AS(UPDATE T_TRANS_ENCRYPT SET SALT_KEY = '0fbb37635578fb1dd164', TRANS_CHK_KEY = 'UP7x6XqHQsGUZoa5ZXphGQ=='
                WHERE TRANS_ID  = 'admin' RETURNING *)
               INSERT INTO T_TRANS_ENCRYPT (TRANS_ID, TRANS_CHK_KEY, SALT_KEY, FRST_REGR_ID, FRST_REG_DTM, LST_MDFR_ID, LST_MDF_DTM)
               SELECT 'admin', 'UP7x6XqHQsGUZoa5ZXphGQ==', '0fbb37635578fb1dd164', 'admin', clock_timestamp(), 'admin', clock_timestamp()
         WHERE NOT EXISTS ( SELECT * FROM UPSERT );
