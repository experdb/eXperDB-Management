ALTER TABLE experdb_management.t_sysdtl_c ADD sys_cd_nm_en varchar(60) NULL;
COMMENT ON COLUMN experdb_management.t_sysdtl_c.sys_cd_nm_en IS '시스템_코드_명_영어';

UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Login' WHERE SYS_CD = 'DX-T0003';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Logout' WHERE SYS_CD = 'DX-T0003_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Main' WHERE SYS_CD = 'DX-T0004';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'DBMS Registration Page' WHERE SYS_CD = 'DX-T0005';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Database Save' WHERE SYS_CD = 'DX-T0005_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'DBMS Delete' WHERE SYS_CD = 'DX-T0005_02';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'DBMS Registration Popup' WHERE SYS_CD = 'DX-T0006';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'DBMS Registration' WHERE SYS_CD = 'DX-T0006_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'DBMS Connection Test' WHERE SYS_CD = 'DX-T0006_02';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'DBMS Modify Popup' WHERE SYS_CD = 'DX-T0007';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'DBMS Modification' WHERE SYS_CD = 'DX-T0007_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'DBMS Management' WHERE SYS_CD = 'DX-T0008';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'DBMS Search' WHERE SYS_CD = 'DX-T0008_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Management Databases Page' WHERE SYS_CD = 'DX-T0009';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Database Delete' WHERE SYS_CD = 'DX-T0009_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Database Search' WHERE SYS_CD = 'DX-T0009_02';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Database Registration Popup' WHERE SYS_CD = 'DX-T0010';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Database Save' WHERE SYS_CD = 'DX-T0010_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Backup Settings Page' WHERE SYS_CD = 'DX-T0021';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Online Backup Search' WHERE SYS_CD = 'DX-T0021_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Backup Work Delete' WHERE SYS_CD = 'DX-T0021_02';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Dump Backup Search' WHERE SYS_CD = 'DX-T0021_03';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Online Backup Registered Popup' WHERE SYS_CD = 'DX-T0022';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Online Backup Registration' WHERE SYS_CD = 'DX-T0022_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Online Backup Modify Popup' WHERE SYS_CD = 'DX-T0023';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Online Backup Modification' WHERE SYS_CD = 'DX-T0023_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Dump Backup Registered Popup' WHERE SYS_CD = 'DX-T0024';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Dump Backup Registration' WHERE SYS_CD = 'DX-T0024_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Dump Backup Modify Popup' WHERE SYS_CD = 'DX-T0025';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Dump Backup Modification' WHERE SYS_CD = 'DX-T0025_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Backup History Page' WHERE SYS_CD = 'DX-T0026';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Online Backup History Search' WHERE SYS_CD = 'DX-T0026_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Dump Backup History Search' WHERE SYS_CD = 'DX-T0026_02';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Server Access Setting Page' WHERE SYS_CD = 'DX-T0027';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Server Access Delete' WHERE SYS_CD = 'DX-T0027_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Server Access Apply' WHERE SYS_CD = 'DX-T0027_02';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Server Access Add Popup' WHERE SYS_CD = 'DX-T0028';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Server Access Registration' WHERE SYS_CD = 'DX-T0028_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Server Access Modify Popoup' WHERE SYS_CD = 'DX-T0029';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Server Access Modification' WHERE SYS_CD = 'DX-T0029_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Setting Change History' WHERE SYS_CD = 'DX-T0030';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Setting Change History Search' WHERE SYS_CD = 'DX-T0030_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Setting Change History Restoration' WHERE SYS_CD = 'DX-T0030_02';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Audit Setting Page' WHERE SYS_CD = 'DX-T0031';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Audit Setting Apply' WHERE SYS_CD = 'DX-T0031_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Audit History Page' WHERE SYS_CD = 'DX-T0032';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Audit History Search' WHERE SYS_CD = 'DX-T0032_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Audit History Download' WHERE SYS_CD = 'DX-T0032_02';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Manage Users Page' WHERE SYS_CD = 'DX-T0033';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Manage Users Search' WHERE SYS_CD = 'DX-T0033_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'User Delete' WHERE SYS_CD = 'DX-T0033_02';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'User Register Popup' WHERE SYS_CD = 'DX-T0034';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'User Registration' WHERE SYS_CD = 'DX-T0034_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Users Modify Popup' WHERE SYS_CD = 'DX-T0035';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'User Modification' WHERE SYS_CD = 'DX-T0035_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Manage Menu Permissions Page' WHERE SYS_CD = 'DX-T0036';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Menu Authority Save' WHERE SYS_CD = 'DX-T0036_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Manage Server Permissions Page' WHERE SYS_CD = 'DX-T0037';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'DB Server Menu Authority Save' WHERE SYS_CD = 'DX-T0037_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Management Database Permissions' WHERE SYS_CD = 'DX-T0038';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'DB Authority Save' WHERE SYS_CD = 'DX-T0038_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Page Access Histories' WHERE SYS_CD = 'DX-T0039';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Page Access Histories Save as Excel' WHERE SYS_CD = 'DX-T0039_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Page Access Histories Search' WHERE SYS_CD = 'DX-T0039_02';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Management Agent Page' WHERE SYS_CD = 'DX-T0040';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Management Agent Search' WHERE SYS_CD = 'DX-T0040_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'About Extensions' WHERE SYS_CD = 'DX-T0041';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Schedule Registration Page' WHERE SYS_CD = 'DX-T0042';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Schedule Registration' WHERE SYS_CD = 'DX-T0042_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Add Work Popup' WHERE SYS_CD = 'DX-T0043';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Work Search' WHERE SYS_CD = 'DX-T0043_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Schedule Modify Page' WHERE SYS_CD = 'DX-T0044';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Schedule Modification' WHERE SYS_CD = 'DX-T0044_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Manage Schedules Page' WHERE SYS_CD = 'DX-T0045';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Schedule Search' WHERE SYS_CD = 'DX-T0045_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Schedule History Page' WHERE SYS_CD = 'DX-T0046';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Schedule History Search' WHERE SYS_CD = 'DX-T0046_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Schedule Failed Page' WHERE SYS_CD = 'DX-T0047';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Manage User Information Page' WHERE SYS_CD = 'DX-T0048';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'User Information Save' WHERE SYS_CD = 'DX-T0048_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Change Password Popup' WHERE SYS_CD = 'DX-T0049';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Change Password' WHERE SYS_CD = 'DX-T0049_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Manage My Schedules' WHERE SYS_CD = 'DX-T0050';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'My Schedules Search' WHERE SYS_CD = 'DX-T0050_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'My Schedules Delete' WHERE SYS_CD = 'DX-T0050_02';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'My Schedules Enable' WHERE SYS_CD = 'DX-T0050_03';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'My Schedules Disable' WHERE SYS_CD = 'DX-T0050_04';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Schedule of Backup Page' WHERE SYS_CD = 'DX-T0051';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Schedule of Backup Creation Popup' WHERE SYS_CD = 'DX-T0052';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Online Help' WHERE SYS_CD = 'DX-T0053';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'About eXperDB' WHERE SYS_CD = 'DX-T0054';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Dashboard' WHERE SYS_CD = 'DX-T0055';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Server Property' WHERE SYS_CD = 'DX-T0073';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Security Policy Management Page' WHERE SYS_CD = 'DX-T0101';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Security Policy Management Search' WHERE SYS_CD = 'DX-T0101_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Security Policy Management Delete' WHERE SYS_CD = 'DX-T0101_02';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Register Security Policy Page' WHERE SYS_CD = 'DX-T0102';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Register Security Policy' WHERE SYS_CD = 'DX-T0102_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Register Security Policy Add' WHERE SYS_CD = 'DX-T0103';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Access Control Policy Add Popup' WHERE SYS_CD = 'DX-T0104';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Security Policy Management Modify Page' WHERE SYS_CD = 'DX-T0105';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Security Policy Management Modification' WHERE SYS_CD = 'DX-T0105_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Encryption Key Management Page' WHERE SYS_CD = 'DX-T0106';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Encryption Key Management Search' WHERE SYS_CD = 'DX-T0106_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Encryption Key Management Delete' WHERE SYS_CD = 'DX-T0106_02';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Encryption Key Registration Popup' WHERE SYS_CD = 'DX-T0107';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Encryption Key Registration' WHERE SYS_CD = 'DX-T0107_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Encryption Key Modify Popup' WHERE SYS_CD = 'DX-T0108';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Encryption Kye Modification' WHERE SYS_CD = 'DX-T0108_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Encryption/Decryption Page' WHERE SYS_CD = 'DX-T0110';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Encryption/Decryption Search' WHERE SYS_CD = 'DX-T0110_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Management Server' WHERE SYS_CD = 'DX-T0111';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Management Server Search' WHERE SYS_CD = 'DX-T0111_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Management Server Detail Popup' WHERE SYS_CD = 'DX-T0112';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Encryption Key Page' WHERE SYS_CD = 'DX-T0113';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Encryption Key Search' WHERE SYS_CD = 'DX-T0113_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Encryption Key Detail Popup' WHERE SYS_CD = 'DX-T0114';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Security Policy Option Setting Page' WHERE SYS_CD = 'DX-T0115';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Security Policy Option Setting Save' WHERE SYS_CD = 'DX-T0115_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Encryption Agent Setting Page' WHERE SYS_CD = 'DX-T0118';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Encryption Agent Setting Modify Popup' WHERE SYS_CD = 'DX-T0119';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Encryption Agent Setting Modification' WHERE SYS_CD = 'DX-T0119_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Setting the Master Key Page' WHERE SYS_CD = 'DX-T0121';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Setting the Master Key Save' WHERE SYS_CD = 'DX-T0121_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Encrypt Agent Monitoring Page' WHERE SYS_CD = 'DX-T0123';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Encrypt Agent Search' WHERE SYS_CD = 'DX-T0123_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Encrypt Agent Delete' WHERE SYS_CD = 'DX-T0123_02';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Encrypt Statistics Page' WHERE SYS_CD = 'DX-T0124';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Encrypt Statistics Search' WHERE SYS_CD = 'DX-T0124_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Batch Settings page' WHERE SYS_CD = 'DX-T0125';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Batch Settings Search' WHERE SYS_CD = 'DX-T0125_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Batch Settings Delete' WHERE SYS_CD = 'DX-T0125_02';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Register Batch Command Popup' WHERE SYS_CD = 'DX-T0126';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Register Batch Command' WHERE SYS_CD = 'DX-T0126_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Modify Batch Command Popup' WHERE SYS_CD = 'DX-T0127';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Modify Batch Command' WHERE SYS_CD = 'DX-T0127_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Batch History Page' WHERE SYS_CD = 'DX-T0128';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Batch History Search' WHERE SYS_CD = 'DX-T0128_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Emergency Restore Page' WHERE SYS_CD = 'DX-T0129';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Emergency Restore Run' WHERE SYS_CD = 'DX-T0129_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Point-in-Time Restore' WHERE SYS_CD = 'DX-T0130';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Point-in-Time Run' WHERE SYS_CD = 'DX-T0130_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Dump Restore Page' WHERE SYS_CD = 'DX-T0131';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Dump Restore Search' WHERE SYS_CD = 'DX-T0131_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Dump Restore Registration Page' WHERE SYS_CD = 'DX-T0132';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Dump Restore Run' WHERE SYS_CD = 'DX-T0132_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Restore History Page' WHERE SYS_CD = 'DX-T0133';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Restore History Search' WHERE SYS_CD = 'DX-T0133_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Source/Target DBMS Mgmt Page' WHERE SYS_CD = 'DX-T0134';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Source/Target DBMS Mgmt Search' WHERE SYS_CD = 'DX-T0134_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Source/Target DBMS Mgmt Delete' WHERE SYS_CD = 'DX-T0134_02';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Source/Target DBMS Mgmt Registration Popup' WHERE SYS_CD = 'DX-T0135';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Source/Target DBMS Mgmt Registration' WHERE SYS_CD = 'DX-T0135_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Source/Target DBMS Mgmt Modify Popoup' WHERE SYS_CD = 'DX-T0136';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Source/Target DBMS Mgmt Modification' WHERE SYS_CD = 'DX-T0136_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Setting Information Mgmt Page' WHERE SYS_CD = 'DX-T0137';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'DDL Search' WHERE SYS_CD = 'DX-T0137_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'DDL Delete' WHERE SYS_CD = 'DX-T0137_02';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'DDL Create replica' WHERE SYS_CD = 'DX-T0137_03';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'DDL Run Immediately' WHERE SYS_CD = 'DX-T0137_04';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'DDL Registration Popup' WHERE SYS_CD = 'DX-T0138';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'DDL Registration' WHERE SYS_CD = 'DX-T0138_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'DDL Modify Popup' WHERE SYS_CD = 'DX-T0139';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'DDL Modification' WHERE SYS_CD = 'DX-T0139_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'MIGRATION Search' WHERE SYS_CD = 'DX-T0140_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'MIGRATION Delete' WHERE SYS_CD = 'DX-T0140_02';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'MIGRATION Create replica' WHERE SYS_CD = 'DX-T0140_03';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'MIGRATION Run Immediately' WHERE SYS_CD = 'DX-T0140_04';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'MIGRATION Registration Popup' WHERE SYS_CD = 'DX-T0141';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'MIGRATION Registration' WHERE SYS_CD = 'DX-T0141_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'MIGRATION Modify Popup' WHERE SYS_CD = 'DX-T0142';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'MIGRATION Modification' WHERE SYS_CD = 'DX-T0142_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Performance History' WHERE SYS_CD = 'DX-T0143';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'DDL Performance History' WHERE SYS_CD = 'DX-T0143_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'MIGRATION Performance History' WHERE SYS_CD = 'DX-T0143_02';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Source DBMS System Information' WHERE SYS_CD = 'DX-T0144';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Target DBMS System Information' WHERE SYS_CD = 'DX-T0145';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Table Information' WHERE SYS_CD = 'DX-T0146';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Node Manual Scale Page' WHERE SYS_CD = 'DX-T0056';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Node Manual Scale Search' WHERE SYS_CD = 'DX-T0056_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Node Manual Scale In' WHERE SYS_CD = 'DX-T0056_02';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Node Manual Scale Out' WHERE SYS_CD = 'DX-T0056_03';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Node Manual Detail' WHERE SYS_CD = 'DX-T0056_04';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Node Manual Scale Security Group Detail' WHERE SYS_CD = 'DX-T0056_05';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Node Manual Run Popup' WHERE SYS_CD = 'DX-T0056_06';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Node Scale History Page' WHERE SYS_CD = 'DX-T0057';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Node Scale History Search' WHERE SYS_CD = 'DX-T0057_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Node Auto-Expansion Scale History Search' WHERE SYS_CD = 'DX-T0057_02';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Node Auto Scale Settings Page' WHERE SYS_CD = 'DX-T0058';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Node Auto Scale Settings Search' WHERE SYS_CD = 'DX-T0058_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Node Auto Scale Setting Delete' WHERE SYS_CD = 'DX-T0058_02';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Node Auto Scale Registration Popup' WHERE SYS_CD = 'DX-T0059';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Node Auto Scale Registration' WHERE SYS_CD = 'DX-T0059_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Node Auto Scale Modify Popup' WHERE SYS_CD = 'DX-T0060';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Node Auto Scale Modification' WHERE SYS_CD = 'DX-T0060_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Node Auto Scale Register Default Settings Popup' WHERE SYS_CD = 'DX-T0061';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Node Auto Scale Register Default Settings' WHERE SYS_CD = 'DX-T0061_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Data Transfer Target DBMS Settings' WHERE SYS_CD = 'DX-T0147';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Data Transfer Target DBMS Settings Search' WHERE SYS_CD = 'DX-T0147_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Transmission Management Page' WHERE SYS_CD = 'DX-T0148';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Transmission Management Search' WHERE SYS_CD = 'DX-T0148_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Target System Register Transmission Settings Page' WHERE SYS_CD = 'DX-T0149';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Target System Register Transmission Settings' WHERE SYS_CD = 'DX-T0149_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Target System Modify Transmission Settings Page' WHERE SYS_CD = 'DX-T0150';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Target System Transmission Modification' WHERE SYS_CD = 'DX-T0150_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Target System Transmission Delete' WHERE SYS_CD = 'DX-T0147_02';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Kafka Settings Page' WHERE SYS_CD = 'DX-T0153';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Transmission Management Registration' WHERE SYS_CD = 'DX-T0151_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Transmission Management Modification' WHERE SYS_CD = 'DX-T0152_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Transmission Management Delete' WHERE SYS_CD = 'DX-T0151_02';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Transmission Management Regist Default Settings Page' WHERE SYS_CD = 'DX-T0156';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Transmission Management Default Setting Registration' WHERE SYS_CD = 'DX-T0156_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Transmission Management Default Settings Page' WHERE SYS_CD = 'DX-T0157';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Transmission Management Defualt Seettings Search' WHERE SYS_CD = 'DX-T0157_01';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Transmission Management Default Delete' WHERE SYS_CD = 'DX-T0157_02';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Transmission Management Modify Default Settings Page' WHERE SYS_CD = 'DX-T0158';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Transmission Management Default Settings Modification' WHERE SYS_CD = 'DX-T0158_01';



UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Daily' WHERE SYS_CD = 'TC001601';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Weekly' WHERE SYS_CD = 'TC001602';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Monthly' WHERE SYS_CD = 'TC001603';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'Yearly' WHERE SYS_CD = 'TC001604';
UPDATE T_SYSDTL_C SET SYS_CD_NM_EN = 'One Time' WHERE SYS_CD = 'TC001605';





