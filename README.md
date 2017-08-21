
# DX-TControl
[![LICENSE](https://img.shields.io/badge/LICENSE-GPLv3-ff69b4.svg)](https://github.com/experdb/DX-TControl/blob/master/LICENSE)
[![VERSION](https://img.shields.io/badge/VERSION-1.0-orange.svg)](https://github.com/experdb/DX-TControl/blob/master/VERSION)
[![ISSUES](https://img.shields.io/github/issues/experdb/DX-TControl.svg)](https://github.com/experdb/DX-TControl/issues)


----------

**소개**

	DX-Tcontrol 입니다.

----------

**개발환경**

	* Framework : egovframework:dev3.6
	* Java version : jdk 1.7 이상
	* Servlet : 2.4 이상
	* Was : Apache Tomcat 8
	* Build : Ant Build
	* Deploy : Maven
	* DB : Postgresql 9.5.6

----------

**설치**

* DB 생성

		initdb -D $POG_HOME/pgdata -E UTF8 -U tcontrol
		CREATE ROLE tcontrol password 'tcontrol' login

		CREATE DATABASE tcontroldb
		  WITH OWNER = tcontrol
		       ENCODING = 'UTF8'
		       TABLESPACE = pg_default
		       LC_COLLATE = 'C'
		       LC_CTYPE = 'C'
		       CONNECTION LIMIT = -1;

* 스키마생성 

		create schema tcontrol;
	
* DB restore

		pg_restore -h 127.0.0.1 -p 5433 -U tcontrol -d tcontroldb tcontroldb.dmp


* Extention
 
    - admin pack
	
			설치 postgres=# create extension adminpack;
			확인 postgres=# select * from pg_extension;
		
	- pg_audit (https://www.pgaudit.org/)
	
			설치 postgres=# create extension pgaudit;
			확인 postgres=# select * from pg_extension;


* 초기 아이디/비밀번호

		아이디 : admin  비밀번호 : tcontrol

----------

**지원하는 기능**
 
* 모니터링시스템

		모니터링시스템
* 백업관리시스템

		백업관리시스템
* 접근제어시스템

		접근제어시스템
* 관리자시스템

		관리자시스템

----------

**제작자**

	박태혁, 변승우, 김주영

----------
Copyright (c) 2016-2017, eXperDB All rights reserved

