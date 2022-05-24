-- [17]MySQL 관계형 데이터베이스
-- 관계형 데이터베이스란 데이터의 종속성을 관계(relationship)로 표현하는 것이다.
-- 현재 가장 많이 사용되고 있는 데이터베이스의 한 종류이다.

-- 1. foreign key(외래키):
-- 제약 조건에 의해 참조되는 테이블에서 데이터의 수정이나 삭제가 발생하면,
-- 참조하고 있는 테이블의 데이터도 같이 영향을 받는다.
-- 이때, 참조하고 있는 테이블의 동작은 다음 키워드를 사용하여 foreign key 제약 조건에서 미리 설정할 수 있다.

-- 2. 부모테이블과 자식테이블 사이에 삭제 또는 수정할 때 규칙이 있다.
-- (1) on delete
-- (2) on update
--     - 삭제(or 수정) RULE
--       ①cascade: 대상 데이터를 삭제하거나 수정하면,해당 데이터를 참조하는 데이터도 삭제 또는 수정된다.
--       ②set null: 대상 데이터를 삭제하거나 수정하면,해당 데이터를 참조하는 데이터는 NULL로 변경된다.
--       ③no action: 참조되는 테이블에서 데이터를 삭제하거나 수정해도, 참조하는 테이블의 데이터는 변경되지 않는다.
--       ④set default : 참조되는 테이블에서 데이터를 삭제하거나 수정하면, 
--                     참조하는 테이블의 데이터는 필드의 기본값으로 설정된다.
--       ⑤restrict:  참조하는 테이블에 데이터가 남아 있으면, 참조되는 테이블의 데이터를 삭제하거나 수정할 수 없다.

-- ※ 테이블 생성
-- [형식]
-- create table 테이블이름(필드이름 필드타입,필드이름 필드타입,.....,
--                     [constraint 제약조건이름]
--                     foreign key (필드이름)
--                     references 테이블이름 (필드이름)
-- )

-- ※ 테이블 수정
-- [형식]
-- alter table 테이블이름
-- add [constraint 제약조건이름]
-- foreign key (필드이름)
-- references 테이블이름 (필드이름)
-- ----------------------------------------------------------------------------------------
--ex1)dept, emp 테이블을 생성 한후 행을 추가하시오
--테이블명 : dept
--deptno    number         ==> 기본키
--dname     varcahr2(30)   ==> 널 허용안됨



-- --------------------------------------------------------------------------
--테이블명 : emp
--empno   int          ==> 기본키
--ename   varchar2(30) ==> 널허용안됨
--deptno  int          ==> 외래키
--                         대상데이터를 삭제하고 참조하는데이터는 NULL로 바꿈
--                         대상데이터를 수정하면 참조하는 데이터도 같이 변경                    




show tables;
-- --------------------------------------------------------------------------
insert into dept(deptno,dname) values(10,'개발부');
insert into dept(deptno,dname) values(20,'영업부');
insert into dept(deptno,dname) values(30,'관리부');
insert into dept(dname) values(40,'경리부');      --오류: 컬럼갯수가 안맞음
insert into dept values(40,'경리부'); 
commit
select * from dept;

insert into emp(empno,ename,deptno) values(100,'둘리',10);
insert into emp(empno,ename,deptno) values(101,'또치',20);
insert into emp(empno,ename,deptno) values(102,'도우넛',50); 
           -- 50번부서 없음(무결성제약조건위배)-부모키가 없다
insert into emp(empno,ename,deptno) values(102,'도우넛',40);
insert into emp(empno,ename) values(103,'희동이');
insert into emp(ename,deptno) values('마이콜',10); -- 오류: primary key는 NULL허용 안함
insert into emp(empno,ename,deptno) values(104,'마이콜',10);
commit
select * from emp;
-- --------------------------------------------------------------------------
-- ex2)삭제
-- dept테이블에서 20번 부서를 삭제하시오 


-- --------------------------------------------------------------------------
-- ex3)삭제된 행을 되돌리시오


-- --------------------------------------------------------------------------
-- 참고)  
-- dept테이블의  deptno=20과  emp테이블의 deptno=20이 releation이 형성된경우 
--  ==> 삭제안됨(자식레코드가 발견되었습니다)
-- on delete cascade를 설정하면 부모테이블과 자식테이블의 레코드가 함께 삭제됨
-- on delete set null를 설정하면 부모테이블은 삭제되고 자식테이블은 null로 바뀜
-- --------------------------------------------------------------------------
-- ex4)수정(update)
-- 10번 부서를 100으로 수정하시오




-- --------------------------------------------------------------------------
-- ex5)테이블 삭제








