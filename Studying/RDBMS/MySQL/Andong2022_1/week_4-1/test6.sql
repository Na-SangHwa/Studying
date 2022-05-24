-- [12] 테이블 생성/수정/복사/삭제
-- 1.테이블생성
-- create table 테이블명(컬럼명1   컬럼타입  [제약조건],컬럼명2  컬럼타입  [제약조건],.....);

--  -  문자로 시작: 영문 대소문자,숫자,특수문자( _ , $ , # ),한글
--  -  중복되는 이름은 사용안됨
--  -  예약어(create, table, column등)은 사용할수 없다

--  -  자료형
--    varchar(M):  문자,문자열(가변형) ==> M은 1~255
--    char(M)   :  문자,문자열(고정형) ==> M은 1~65535
--    text(M)   :  문자,문자열        ==> 최대 65535 
--    int(M)    :  정수형 숫자
--    float / double(M,D) : 실수형 숫자
--    datetime :    YYYY-MM-DD HH:MM:SS('1001-01-01 00:00:00' ~ '9999-12-31 23:59:59')
--    timestamp(M) : 1970-01-01 ~ 2037년 임의 시간(1970-01-01 00:00:00 를 0으로 해서 1초단위로 표기

--  - 제약조건
--     not null:  해당컬럼에 NULL을 포함되지 않도록 함 
--     unique:  해당컬럼 또는 컬럼 조합값이 유일하도록 함
--     primary key: 각 행을 유일하게 식별할수 있도록함(P.K:기본키)
--     foreign key: references를 이용하여 어떤 컬럼에 어떤 데이터를 참조하는지 반드시 지정(F.K:참조키,외래키)
--     default: NULL값이 들어올 경우 기본 설정되는 값을 지정
--     check : 해당컬럼에 특정 조건을 항상 만족시키도록함
--             MySQL의 경우 작성은 가능하지만(에러발생 x) 적용은 안됨

--     [참고]  primary key = unique + not null

--     ex)       idx          int          auto_increment    자동 값증가   
--               userid       varchar(16)  not null          아이디 
--               username     varchar(20)                    이름
-- 	             userpwd      varchar(16)                    비밀번호
--               emailid      varchar(16)                    이메일아이디
--               emaildomain  varchar(16)                    이메일도메인
--               joindate     timestamp    current_timestamp 가입일 
-- -----------------------------
-- 2.테이블수정
-- (1)테이블 내용 수정
-- alter  table 테이블명 
-- add    컬럼명  데이터타입 [제약조건]
-- add    constraint  제약조건명  제약조건타입(컬럼명)
-- modify 컬럼명 데이터타입 
-- drop   column  컬럼명 [cascade constraints]
-- drop   primary key [cascade] | union (컬럼명,.....) [cascade] .... | constraint 
-- 제약조건명 [cascade]

-- (2)테이블 이름변경
-- alter table  기존테이블명  rename to  새테이블명
-- rename table  기존테이블명  to 새테이블명

-- (3)테이블 컬럼이름 변경
-- alter table 테이블명 rename column  기존컬럼명 to 새컬럼명
-- alter table 테이블명 rename constraint 기존제약조건명 to 새제약조건명
-- ---------------------------------------------------------------------------------
-- [12]추가하기: insert
-- : 테이블에 데이터(새로운 행)추가 -- 행의 수가 변경

-- insert into 테이블명 [ (column1, column2, .....)]   values (value1,value2,.....)
--  -  column과 values의 순서일치
--  -  column과 values의 개수 일치
-- ---------------------------------------------------------------------------------
-- [13]수정하기: update
-- : 테이블에 포함된 기존 데이터수정 -- 행의 수가 변경되지 않음
--   전체 데이터 건수(행수)는 달라지지 않음
--   조건에 맞는 행(또는 열)의 컬럼값을 갱신할수 있다

-- update 테이블명  set  컬럼명1=value1, 컬럼명2=value2 ..... [where  조건절]
--   - where 이 생략이 되면 전체행이 갱신
--   - set절은 서브쿼리사용가능, default옵션 사용가능 
-- ---------------------------------------------------------------------------------
-- [14]삭제하기:delete
--  : 테이블에 포함된 기존데이터를 삭제  -- 행의 수가 변경
--    행 단위로 삭제되므로 전체행수가 달라짐
   
-- delete [from] 테이블명 [where  조건절];
-- - where을 생략하면 전체행이 삭제됨
--  - 데이터는 삭제되고 테이블 구조는 유지됨
-- ---------------------------------------------------------------------------------
-- [15]tracnsation처리
-- commit: 일의 시작과 끝이 완벽하게 마무리가 되면 테이블에 적용
-- rollback: 처리도중 인터럽트(interrupt:장애)가 발생하면 되돌아옴
-- =================================================================================
use mydb;     -- mydb 데이터베이스 사용
show tables;  -- 테이블 목록 확인

-- ex1) 테이블생성과 자동값증가
-- 테이블명 : book
-- num      int    p.k  자동값증가
-- subject  varchar(50)
-- price    int
-- year     date

create table book(
num int primary key auto_increment,
subject varchar(50),
price int,
year date);

-- ex2) 데이터 추가
-- 오라클 무작정 따라하기, 10000, 오늘날짜
-- 자바 3일 완성,15000, 2019-01-12
-- JSP 달인되기,25000, 2021-04-05
-- 자동 커밋해제: set autocommit=0; / 자동 커밋설정: 
set autocommit=1;
insert into book(subject,price,year) values('오라클 무작정따라하기',10000, now());
insert into book(subject,price,year) values('자바 3일 완성',15000, '2017-01-12');
insert into book(subject,price,year) values('JSP 달인되기',25000,'2021-04-05');

commit;
delete from book;
select * from book;

-- 트랜젝션 처리를 안했을 경우 오류 상황
-- 콘솔창에서
update book set subject='JSP 20일 완성' where num=1;

-- MySQL Workbench에서
update book set subject='JSP 마스터북' where num=1;

-- -------------------------------------------------------------------------------------
-- ex3) 테이블생성과 자동값증가
CREATE TABLE member (
idx INT NOT NULL AUTO_INCREMENT,
userid VARCHAR(16) NOT NULL,
username VARCHAR(20),
userpwd VARCHAR(16),
emailid VARCHAR(20),
emaildomain VARCHAR(50),
joindate TIMESTAMP NOT NULL DEFAULT current_timestamp,
PRIMARY KEY (idx)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO member (userid, username, userpwd, emailid, emaildomain, joindate)
VALUES ('abcd', '김순신', '1234', 'kim', 'kim.com', now());

INSERT INTO member (username, userid , userpwd, joindate)
VALUES ('김순식', 'abcd', '1234', now());

INSERT INTO member (username, userid , userpwd, joindate)
VALUES
('김순신', 'abcd', '1234', now()), 
('박순신', 'xyz', '9876', now());

UPDATE member
SET userpwd = 9876, emaildomain = 'kim.co.kr'
WHERE userid = 'abcd';

DELETE from member
WHERE userid = 'abcd';
-- --------------------------------------------------------------------------------------
-- [문제]
-- 1)테이블명 : student
-- idx, 숫자(5), 기본키, 자동값증가 / name, 문자(10), 널허용X / kor, 숫자(5) / eng, 숫자(5) / mat, 숫자(5)

-- 2)데이타 : 둘리, 90, 80,95
--          또치, 75, 90,65
--          고길동, 100,95,90
--          마이콜, 60,60,60
--          도우넛, 75,80,75
--          희동이, 80,78,90
-- idx는 자동으로 1씩증가값을 넣으시오


-- 3)select문으로 다음과 같이 출력하시오
-- 조건1)평균별 내림차순 정렬하시오
-- 조건2)평균은 소수점이하 2째자리까지 출력하시오
-- 조건3)타이틀은 아래와 같이 처리해 주시오

-- 학번     이름    국어   영어   수학    총점   평균
-- -----------------------------------------------------
--  1      둘리    90     80     96       266    88.66





