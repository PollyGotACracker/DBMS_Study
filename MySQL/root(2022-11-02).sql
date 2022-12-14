-- 여기는 root 접속화면
/*
root 권한은 DBA(Datbase Administer)역할을 수행하며
Database System 의 모든 권한을 갖는 사용자이다
root 권한은 매우 신중하게 관리해야 하며
잘못 관리하면 DB System 에 문제를 발생시킬 수 있다
*/

/*
SQL : 대부분의 RDBMS 데이터 관리 소프트웨어에서 공통으로 통용되는 Data 관련 언어
DDL, DML, DCL, TCL
DML : CRUD 를 수행하기 위한 언어
DDL : 객체(Object)를 수행한다

Database 객체란
		물리적인 데이터 저장소
			SCHEMA(database), Table, index 등등
        사용자(user) : root 보다 다소 제한된 권한을 사용자에게 부여하여
		Data 관리를 할 수 있도록 만든 계정(Account, login 이 가능한 사람)        
*/

-- 새로운 Schema 생성하기 : 보통 root 권한으로 생성한다.
-- Schema를 생성할 때는 DDL 명령을 사용한다.
-- 물리적으로 데이터가 저장되는 공간을 설정하기
CREATE DATABASE schoolDB;

-- 데이터가 실제로 저장될 table 을 생성
USE schooldb;

CREATE TABLE tbl_student (
	st_num	VARCHAR(5)	NOT NULL	PRIMARY KEY,
	st_name	VARCHAR(10)	NOT NULL,	
	st_dept	VARCHAR(20),		
	st_grade	INT,		
	st_tel	VARCHAR(15),		
	st_addr	VARCHAR(125)		
);

-- 테이블의 구조를 확인하기
DESCRIBE tbl_student;
DESC tbl_student;

-- 현재 open 된 Schema(Database)에 있는 Table 목록
SHOW TABLES;

-- 현재 MySQL System 의 Schema 목록
-- 이 명령은 사용자의 권한에 따라 실행할 수 없는 경우도 있다.
SHOW DATABASES;

-- 생성된 table 에 데이터 만들기(Create) : Insert 명령을 사용
-- cf) INTO 안 써도 됨
INSERT tbl_student(st_num, st_name, st_dept, st_grade, st_tel, st_addr)
VALUES('S0001','홍길동','컴퓨터공학',3,'090-2222-2222','서울특별시');

SELECT * FROM tbl_student;

INSERT tbl_student(st_num, st_name)
VALUES('S0002','이몽룡');

SELECT * FROM tbl_student;

-- 아래 코드는 st_num 값만 있고, st_name 값이 없는 SQL 이다.
-- st_name 칼럼은 NOT NULL 제약조건이 설정되어 있기 때문에
-- 반드시 값(데이터)이 있어야 한다.
-- Error Code: 1364. Field 'st_name' doesn't have a default value
INSERT tbl_student(st_num)
VALUES('S0003');
-- cf) 마우스 우클릭 하고 Copy Response

-- 순서를 바꿔도 추가 가능하다.
INSERT tbl_student(st_name, st_num)
VALUES('성춘향','S0003');
SELECT * FROM tbl_student;

-- st_num 칼럼은 PK 로 설정되어 있다.
-- PK 로 설정된 칼럼은 자동으로 UNIQUE 성질을 갖는다.
-- 절대 중복된 데이터를 저장할 수 없다.
-- Error Code: 1062. Duplicate entry 'S0003' for key 'tbl_student.PRIMARY'
INSERT tbl_student(st_num, st_name)
VALUES('S0003','임꺽정');


-- S0003 인 임꺽정 데이터를 추가하려고 했더니 학번이 중복되었다는 오류가 났다.
-- 임꺽정의 학번은 분명 S0003이 맞다. 그렇다면 이전에 입력된 학번이 잘못 입력되었다는 것이다.
-- S0003 학번의 학생이 누구인지 찾아라
SELECT * FROM tbl_student WHERE st_num = 'S0003';

-- 찾았더니 성춘향 학생의 학번이 S0003으로 저장되어 있다.
-- 원본 데이터를 확인해보니 성춘향 학생의 학번이 S0033 이더라...
-- 첫 번째 방법 : 성춘향 학생의 데이터를 삭제하고, 임꺽정 학생 데이터 추가
-- 두 번째 방법 : 성춘향 학생의 학번을 S0003 에서 S0033 으로 변경(수정)
DELETE FROM tbl_student
WHERE st_num = 'S0001';

-- WHERE 문에서 반드시 PK 를 사용하여 수정이상이 발생하지 않도록 할 것
UPDATE tbl_student
SET st_num = 'S0033'
WHERE st_num = 'S0003';

INSERT INTO tbl_student(st_num, st_name)
VALUES('S0003','임꺽정');

-- tbl_student table 의 st_num 칼럼에 PK 설정되어 있다.
-- PK 가 설정된 칼럼은 index 가 기본으로 설정되고
-- index 가 설정된 칼럼을 기준으로 정렬된 결과를 기본적으로 보여준다
SELECT * FROM tbl_student;

UPDATE tbl_student
SET st_dept = '국어국문학과'
WHERE st_num = 'S0002';
SELECT * FROM tbl_student;

-- 학번(PK)이 st_num 인 학생의 학년, 전화번호, 주소를 변경(Update)
UPDATE tbl_student
SET st_dept='국어국문학과',  -- 중복으로 변경 가능
	st_grade = 1,
	st_tel = '090-3333-3333',
	st_addr = '전북 익산시'
WHERE st_num = 'S0002';
SELECT * FROM tbl_student;

-- 학번이 S0033 인 학생의 학번을 S0001 로 변경하라
-- 학번이 S0033 인 데이터를 WHERE 하여 학번 데이터를 S0001 로 Update
-- Error Code: 1062. Duplicate entry 'S0001' for key 'tbl_student.PRIMARY'
-- 학번이 S0033 인 학생의 학번을 S0001 로 변경하려고 시도했더니
-- 이미 S0001 인 학생의 데이터가 있다. 때문에 데이터 변경이 거부된다.
UPDATE tbl_student
SET st_num = 'S0001'
WHERE st_num = 'S0033';
 

