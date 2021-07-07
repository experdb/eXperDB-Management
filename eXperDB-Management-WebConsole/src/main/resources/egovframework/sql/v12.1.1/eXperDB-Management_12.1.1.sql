CREATE SEQUENCE Q_RESTORE_MACHINE_01; 


create table experdb_management.restoremachine(
restoremachine_id     numeric not null default nextval('q_restore_machine_01'),
mac varchar(512) NOT NULL,
ip varchar(512) NOT NULL,
subnetmask varchar(512) NOT NULL,
gateway varchar(512) NOT NULL,
dns varchar(512) NOT NULL,
network varchar(512) NULL DEFAULT 'static',
hostname varchar(512) NULL ,
reboot varchar(512) NULL DEFAULT 'no',
username varchar(512) NULL ,
password  varchar(512) NULL);


