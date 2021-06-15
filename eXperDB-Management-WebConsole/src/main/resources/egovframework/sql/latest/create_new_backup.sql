ALTER USER experdb SET search_path = public,experdb_management,experdb_encrypt;


CREATE DATABASE "ActivityLog";
\c "ActivityLog";


CREATE TABLE SyncFlag (RecordID INTEGER NOT NULL );


CREATE SEQUENCE serial_activitylog START 1;
CREATE TABLE  ActivityLog (
	RecordID     INTEGER PRIMARY KEY DEFAULT nextval('serial_activitylog'), 
	ServerName   varchar(512)  NOT NULL, 
	TargetName   varchar(512)  NULL,
	JobName      varchar(256)  NULL,
	JobUUID      varchar(80)  NULL,
	JobID        INTEGER  NULL,
	JobType	     INTEGER  NULL,
	Type         INTEGER  NOT NULL,
	Time         INTEGER  NOT NULL,
	Message      varchar(2048)  NULL,
	SourceMachineName  varchar(256)  NULL,
	SourceMachineUUID  varchar(256)  NULL,
	ErrorCode    varchar(64)  NULL
); 
CREATE INDEX TargetName_idx ON ActivityLog(TargetName);
CREATE INDEX JobName_idx ON ActivityLog(JobName);
CREATE INDEX JobID_idx ON ActivityLog(JobID);
CREATE INDEX JobType_idx ON ActivityLog(JobType);
CREATE INDEX Type_idx ON ActivityLog(Type);
CREATE INDEX Time_idx ON ActivityLog(Time);



CREATE DATABASE "JobHistory";
\c "JobHistory";
CREATE TABLE SyncFlag (RecordID INTEGER NOT NULL );
CREATE SEQUENCE serial_jobhistory START 1;    

CREATE TABLE  JobHistory (
	RecordID		INTEGER PRIMARY KEY DEFAULT nextval('serial_jobhistory'), 
	ServerName		varchar(512)  NOT NULL, 
	TargetName		varchar(512)  NULL,
	JobName			varchar(256)  NULL,
	JobUUID			varchar(80)  NULL,
	JobID			INTEGER  NULL,
	JobType			INTEGER  NOT NULL,
	JobMethod	    INTEGER  NULL,
	DestinationLocation	varchar(2048) NOT NULL,
	EncryptionAlgoName	varchar(32)  NULL,
	CompressLevel		INTEGER NULL,
	ExecuteTime		INTEGER NULL,
	FinishTime		INTEGER NULL,
	Throughput		INTEGER NULL,
	WriteThroughput		INTEGER NULL,
	WriteData		INTEGER NULL,
	ProcessedData		INTEGER NULL,
	ProtectedData		INTEGER NULL,
	RpsHostName		varchar(80)  NULL,
	RpsUUID		    varchar(80)  NULL,
	DataStoreName	varchar(80)  NULL,
	DataStoreUUID	varchar(80)  NULL,
	SourceMachineName  varchar(256)  NULL,
	SourceMachineUUID  varchar(256)  NULL,
	Status			INTEGER NULL,
	OperationType	INTEGER NULL,
	SessionGUID		varchar(80)	NULL
); 
CREATE INDEX TargetName_history_idx ON JobHistory(TargetName);
CREATE INDEX JobName_history_idx ON jobHistory(JobName);
CREATE INDEX JobID_history_idx ON jobHistory(JobID);
CREATE INDEX JobUUID_history_idex on JobHistory(JobUUID);
CREATE INDEX ExecuteTime_history_idex on JobHistory(ExecuteTime);
CREATE INDEX Status_history_idex on JobHistory(Status);
CREATE INDEX JobType_history_idx ON JobHistory(JobType);
CREATE INDEX JobMethod_history_idx ON JobHistory(JobMethod);


CREATE DATABASE "ARCserveLinuxD2D";
\c "ARCserveLinuxD2D";

CREATE TABLE  TargetMachine (
	Name			varchar(512)  NOT NULL PRIMARY KEY,
	"User"			varchar(66)  NULL,
	Password		varchar(512)  NULL,
	OperatingSystem		varchar(512)  NULL,
	Description		varchar(512)  NULL,
	IsProtected		INTEGER  NOT NULL,
	JobName			varchar(512)  NULL,
	LicenseStatus		INTEGER  NULL,
	ConnectionStatus 	INTEGER  NULL,
	LastResult		INTEGER  NULL,
	RecoveryPointCount	INTEGER  NULL,
	RecoverySetCount	INTEGER  NULL,
	ExcludeVolumes		varchar(4096)  NULL,
	BackupLocationType		INTEGER  NULL,
	MachineType		 INTEGER  NULL,
	UUID          varchar(512) NULL
);


CREATE TABLE  BackupLocation (
	UUID   		varchar(80)  NOT NULL,
	Location	varchar(2048)  NOT NULL,
	Username	varchar(66)  NULL,
	Password	varchar(512)  NULL,
	Free		bigint  NULL,
	Total		bigint  NULL,
	Type		INTEGER  NOT NULL,
	IsRunScript	INTEGER  NULL,
	Script		varchar(2048)  NULL,
	FreeAlert	INTEGER  NULL,
	FreeAlertUnit   INTEGER  NULL,
	JobLimit   INTEGER  DEFAULT 0,
	CurrentJobCount   INTEGER  DEFAULT 0,
	WaitingJobCount   INTEGER  DEFAULT 0,
	Time		bigint  NOT NULL,
	rpsServer   varchar(100) NULL,
    rpsUserName  varchar(80) NULL,
    rpsPassword  varchar(512) NULL,
	rpsUUID   varchar(80) NULL,
    rpsProtocol  varchar(20) NULL,
    rpsPort INTEGER   NULL,
    dsUuid  varchar(50) Null,
    dsName  varchar(100) NULL,
    enableDedup INTEGER NULL
); 

CREATE TABLE  JobScript (
	TemplateID	varchar(80)  NOT NULL PRIMARY KEY,
	Name		varchar(512)  NULL,
	JobType		INTEGER NOT NULL,
	BackupLocation	varchar(80)  NULL,
	CompressLevel   INTEGER  NULL,
	EncryptAlgoName	varchar(32)  NULL,
	IsTemplate	INTEGER  NULL,
	ScriptXML	varchar(20480) NULL,
	PlanID		INTEGER  NULL,
	TaskUUID    varchar(256) NULL
);

CREATE TABLE JobQueue (
	UUID		varchar(80)  NOT NULL PRIMARY KEY,
	JobName		varchar(256)  NOT NULL,
	JobType		INTEGER  NULL,
	JobMethod	INTEGER  NULL,
	TargetName	varchar(512)  NOT NULL,
	BackupLocation	varchar(80)  NOT NULL,
	IsRepeat	INTEGER NOT NULL,
	JobStatus	INTEGER  NOT NULL,
	LastResult	INTEGER NOT NULL,
	Priority	INTEGER NULL,
	TemplateID	varchar(80)  NOT NULL
); 
CREATE INDEX JobQueue_JobName_idx ON JobQueue(JobName);
CREATE INDEX JobQueue_JobType_idx ON JobQueue(JobType);
CREATE INDEX JobQueue_JobMethod_idx ON JobQueue(JobMethod);
CREATE INDEX JobQueue_TargetName_idx ON JobQueue(TargetName);
CREATE INDEX JobQueue_BackupLocation_idx ON JobQueue(BackupLocation);
CREATE INDEX JobQueue_LastResult_idx ON JobQueue(LastResult);
CREATE INDEX JobQueue_JobStatus_idx ON JobQueue(JobStatus);
CREATE INDEX JobQueue_Priority_idx ON JobQueue(Priority);


CREATE SEQUENCE serial_d2dserver START 1;

CREATE TABLE  D2DServer (
	RecordID		INTEGER PRIMARY KEY DEFAULT nextval('serial_d2dserver'), 
	Name			varchar(512)  NOT NULL, 
	Protocol		varchar(32)  NOT NULL,
	Port			INTEGER  NOT NULL,
	UUID			varchar(80)  NULL,
	IsLocal			INTEGER  NULL,
	ManagedServerUUID	varchar(80)  NULL,
	ManagedServerName	varchar(512)  NULL,
	ManagedServerURL	varchar(512)  NULL,
	ManagedServerWSDL	varchar(2048)  NULL,
	AuthKey			varchar(512)  NULL,
	ManagedServerType	INTEGER  NULL,
	JobInfoSyncMethod	INTEGER  NULL
);


CREATE SEQUENCE serial_account START 1;
CREATE TABLE  Account (
	RecordID		INTEGER PRIMARY KEY DEFAULT nextval('serial_account'), 
	Username		varchar(66)  NOT NULL, 
	Password		varchar(512)  NOT NULL,
	LoginFailureTime	INTEGER  NOT NULL,
	LastLoginTime	INTEGER  NOT NULL,
	LoginIP		varchar(100)  NULL,
	Status			INTEGER  NULL
);


CREATE DATABASE "License";
\c "License";

CREATE TABLE LicensedMachine (
	ComponentCode    varchar(20)  NOT NULL,
	MachineName      varchar(512)  NOT NULL,
	ServerName       varchar(512)  NULL,
	MachineType		 INTEGER  NOT NULL,
	SocketNumber		 INTEGER  NOT NULL
); 

CREATE INDEX ComponentCode_idx ON LicensedMachine(ComponentCode);
CREATE INDEX MachineName_idx ON LicensedMachine(MachineName);


