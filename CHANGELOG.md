# Changelog

Changelog


## Version 9.6.1.2(2019.09.22)
■ 버그 수정
 - 마스터키 파일 사용안하고 패스워드만 사용하는 기능 수정
 - 백업시 아카이브로그 경로 변경 TOBE = -A $PGALOG
 - 덤프 등록 및 수정 화면에서 database 선택하는 select option명 '전체'를 '선택'으로 변경
 - About eXperDB 팝업화면 year 2018->2019 수정
 - tiles version 2.0 -> 3.0 upgrade
 - 스케줄 실행 후 상태변경
 - 백업 work 수정시, init이 수행되지않아 백업이 안됬던 문제 수정
 
 
## Version 10.7.1.2(2019.09.19)
 ■ 버그수정
 - 마스터키 파일 사용안하고 패스워드만 사용하는 기능 수정
 - 백업시 아카이브로그 경로 변경 TOBE = -A $PGALOG
 - 덤프 등록 및 수정 화면에서 database 선택하는 select option명 '전체'를 '선택'으로 변경
 - About eXperDB 팝업화면 year 2018->2019 수정
 - tiles version 2.0 -> 3.0 upgrade
 - 스케줄 실행 후 상태변경
 - 백업 work 삭제 로직 수정
 - 대시보드 작업상태 관리서버 식 변경
 
 
## Version 10.7.1.0(2019.04.09)
 ■ 추가기능
- 긴급복원, 시점복원, 덤프복원, 복구이력 개발
- Dashboard 화면 재구성

 ■ 버그수정
- [My스케줄] 다음수행시간 정보 나오도록 수정
- [백업설정] 덤프백업 수정시 validation 추가        


## Version 9.6.1.1(2018.08.13)
 ■ 추가기능
 - [보안정책등록] 암호화 알고리즘 SHA-256 추가
 - [암호화 에이전트 모니터링] 삭제 기능 추가  
 - [스크립트] 스크립트 조회, 등록, 삭제, 수정 기능 추가
 - [스크립트] WORK 추가, 스케줄기능 추가, 스크립트 스케줄수행이력 추가  
 - [DB서버수정] 포트 수정
 - properties pg_audit 사용여부 추가, version 9.6.1.1 버전업
 - 폰트 맑은고딕 수정

 ■ 버그수정
 - [백업이력] DUMP 백업시 백업파일 사이즈가 클 경우, NumberFormatException 에러 발생 FileSize int -> long 타입 수정
 - [스케줄등록] 에러시,다음수행 Y,N 소문자로 Insert , [스케줄수정] 에러시,다음수행 Y,N 대문자로 Insert -> 스케줄등록 Y,N 대문자로 Insert 수정
 - [DB서버등록] DB서버 삭제 수정
 - [감사설정] 로그종류 미선택시 에러 발생 -> 쿼리 수정
 - [사용자정보관리] 패스워드 변경 버그 수정
 - 다중 로그인 방지 익스플로러 버그 수정        
 
 
## Version 9.6.1.0(2018.05.16)
Initial release.
