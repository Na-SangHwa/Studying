-- ※ MySQL DML
-- [1] MySQL의 개요
-- 1. 데이타 조작어(DML : Data Manipulation Language)
--    : insert, update, delete
-- 2. 데이타 정의어(DDL : Data Definition Language)
--     : create, alter, drop, rename, truncate    
-- 3. 데이타검색
--    : select 
-- 4. 트랜젝션제어
--    : commit, rollback, savepoint
-- 5. 데이타 제어어(DCL : Data Control Language)
--     : grant,  revoke
-- ------------------------------------------------------------------------
-- [2] MySQL 데이터베이스 생성/삭제/사용
-- 1. 데이터베이스 생성
-- create database 데이터베이스명;
-- create database 데이터베이스명 default character set 값 collate 값;
--    --특정 문자 셋에 의해 데이터베이스에저장된 값들을 비교검색하거나 정렬 등의
--      작업을 위해 문자들을 서로 ＇비교＇ 할 때 사용하는 규칙들의 집합을 의미
--    -- 예) 다국어 처리(utf8mb3)  
--           create database dbtest
--           default character set utf8mb3 collate utf8mb3_general_ci;

-- 2. 데이터베이스 변경
-- alter database 데이터베이스명 default character set 값 collate 값;  

-- 3. 데이터베이스 삭제
-- drop database 데이터베이스명;

-- 4. 데이터베이스 사용
-- use 데이터베이스명;

-- 5. 테이블 목록확인
-- show tables;
-- ------------------------------------------------------------------------
-- [3]검색하기(select)
-- [형식]
-- select [distinct] [컬럼1,컬럼2,.....][as 별명][*]  --- 6
-- from 테이블명     --- 1
-- [where 조건절]    --- 2
-- [group by컬럼명]  --- 3
-- [having 조건절]   --- 4
-- [order by 컬럼명 asc|desc ]  --- 5

-- [조건]
-- distinct: 중복제거
-- *: 모든
-- 조건절 : and,or,like,in,between and,is null,is not null

-- [연산자]
-- =  : 같다
-- !=,  ^=,  <> : 같지않다
-- >=, <=, >, < : 크거나같다,작거나같다,크다,작다
-- and, or, between and, in, like, is null/is not null

-- [정렬]
-- order by 정렬방법
--          asc  - 오름차순(생략가능)
--          desc - 내림차순
-- 컬럼명 : 숫자로도 가능

-- [그룹과 조건]
-- group by : 그룹함수(max,min,sum,avg,count..)와 같이 사용
-- having : 묶어놓은 그룹의 조건절
-- =================================================================================
use mydb;
show tables;

select * from employees;   -- employees테이블의 내용확인하기
select * from departments; 

-- ex1)employees테이블의 모든 사원의 사원번호(employee_id),이름(last_name),급여(salary) 검색
select employee_id, last_name, salary 
from employees;

-- ex2)employees테이블에서 모든 사원의 이름, 입사일(hire_date), 업무ID(job_id)만 검색
select last_name, job_id, hire_date
from employees;

-- ex3)employees테이블에서 모든 사원의 이름(last_name), 연봉(salary*12)만 검색
select last_name, salary*12
from employees;

-- ex4)별명붙이기(as는 생략가능)
--    employees테이블의 모든 사원의 사원번호,이름(last_name),급여 검색
--    조건) title 사원번호, 이름 ,급여로 출력할것
select employee_id as "사원번호", last_name as "이름", salary as "급여"
from employees;

select employee_id  "사원번호", last_name  "이름", salary  "급여"
from employees;

select employee_id  사원번호, last_name  이름, salary  급여
from employees;

select employee_id  사원번호, last_name  "이  름", salary  "급  여"
from employees; -- 띄워쓰기 있으면 " " 생략 불가

-- ex5)employee테이블에서 사원번호,이름,연봉을 구하시오
--     조건1) 연봉 = 급여 * 12
--     조건2) 제목을 사원번호,이  름,연  봉으로 출력
select employee_id  사원번호, last_name  "이  름", salary *12  "연 봉"
from employees;

-- ex6)연결연산자(concat): 컬럼을 연결해서 출력
--    first_name과  last_name을 연결해서 출력하시오
--     이   름
--     ------------
--     Ellen   Abel
-- 일반적인 DBMS에서는 ||로 문자열을 연결하지만 MySQL에서는 ||을 사용할수 없다. 
-- concat()사용해야 한다.
select concat(first_name, concat(' ',last_name))
as "이 름" from employees;

select concat(first_name, ' ',last_name)
as "이 름" from employees;

-- ex7)다음처럼 출력하시오
--   사원번호        이  름                 연 봉
--   ---------------------------------------------
--    100      Steven King   288000달러 

select employee_id as "사원번호", concat(first_name, ' ',last_name)as "이 름", concat(salary*12) as "연 봉"
from employees;
-- ex8) 다음처럼 출력하시오 (last_name, job_id이용)
--     Employee  Detail
--     --------------------
--     King  is a  AD_PRES
select concat(last_name,' is a ',job_id) as "employee detail"
from employees;

-- 중복제거(distinct)
-- ex9)employees테이블에서 부서를 출력하시오
--    조건1)중복되는 부서는 1번만 출력하시오
--    조건2)부서별 오름차순으로 보여주시오
select distinct department_id 
from employees 
order by department_id asc;

-- ex10) 10번부서 또는 90번부서 사원들의 이름,입사일,부서ID를 출력하시오
-- 방법1)or 연산자


-- 방법2)in연산자(or연산자의 다른표현)


-- ex11)급여가 2500이상 3500이하인 사원의 이름(last_name), 입사일, 급여를 검색하시오 --33건
-- 방법1)and 연산자


-- 방법2)between연산자(and연산자의 다른 표현): 초과,미만에서는 사용할수 없다


-- ex12) 급여가 2500이하 이거나 3000이상이면서, 90번 부서인 사원의 이름, 급여, 부서ID를 출력하시오. --3건
--      조건1) 제목은 사원명, 월  급, 부서코드로 하시오
--      조건2) 급여앞에 $를 붙이시오
--      조건3) 사원명은 first_name과 last_name을 연결해서 출력하시오


-- ex13)'King'사원의 모든 컬럼을 표시하시오
select * 
from employees
where last_name='King';          --->문자열검색할때 대.소문자를 구분

select *
from employees
where upper(last_name)='KING';   --->문자열을 대문자로

select *
from employees
where lower(last_name)='king';   --->문자열을 소문자로

-- like: 문자를 포함
-- '%d'      d로 끝나는 
-- 'a%'      a로 시작하는
-- '%test%'  test가 포함되어있는
-- 예)select * from employees where first_name like '%net%';

-- ex14)업무ID에 CL이 포함되어있는 사원들의 이름,업무ID,부서ID를 출력하시오  --45건


-- ex15)업무ID가  IT로 시작하는 사원들의 이름,업무ID,부서ID를 출력하시오  -- 5건


-- ex16) is null / is not null 
-- 커미션을 받는 사원들의 이름과 급여,커미션을 출력하시오 -- 35건


-- ex17)커미션을 받지 않는 사원들의 이름과 급여,커미션을 출력하시오 -- 72건


-- ex18) 사원명,부서ID,입사일을 부서별로 내림차순 정렬하시오


-- ex19) 사원명, 부서ID, 입사일을  부서별로 내림차순 정렬하시오
--     같은부서가 있을때는  입사일순으로 정렬하시오


-- ex20) 사원들의 연봉을 구한후 연봉순으로 내림차순정렬하시오   
-- 이 름     연 봉     
-- ---------------
-- King   28800달러


-- Data Manipulation Language (DML) : SELECT
-- [형식]
-- case [value] when  표현식  then  구문1
--              when  표현식  then  구문2
--                       :
--              else  구문3
-- end

-- ex21)업무 id가 'SA_MAN'또는'SA_REP'이면 'Sales Dept' 그 외 부서이면 'Another'로 표시
-- 조건) 분류별로 오름차순정렬
--        직무          분류
--       --------------------------
--       SA_MAN    Sales Dept
--       SA_REP      Sales Dept
--       IT_PROG    Another



-- ex22) 급여가 10000미만이면 초급, 20000미만이면 중급 그 외이면 고급을 출력하시오 
--      조건1) 컬럼명은  '구분'으로 하시오
--      조건2) 제목은 사원번호, 사원명, 구  분
--      조건3) 구분(오름차순)으로 정렬하고, 구분값이 같으면 사원명(오름차순)으로 정렬하시오







