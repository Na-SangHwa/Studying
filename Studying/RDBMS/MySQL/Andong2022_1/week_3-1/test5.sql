-- [뷰-인라인(inline)개념]  
--  : 별칭을 사용하는 서브쿼리 (일반적으로 from절에서 사용)
--   ex) select * from (select employee_id, last_name from employees);
   
-- [뷰-Top N분석]
--  Top N분석 : 조건에 맞는 최상위(최하위) 레코드를 N개 식별해야 하는 경우에 사용
--   예) 최상위 소득자3명
--       최근 6개월동안 가장 많이 팔린 제품3가지
--       실적이 가장 좋은 영업사원 5명
   
--   MySQL에서 Top N분석원리
--    - 원하는 순서대로 정렬한 후 최상위, 최하위를 구한다.
-- ----------------------------------------------------------------------------
use mydb;
show tables;

select last_name, d.department_name
from employees
left join (select department_id, department_name from departments) d using (department_id);

-- ex1) 뷰-인라인
-- 모든 사원의 평균 급여보다 적게 받는 사원들과 같은 부서에서 근무하는 
-- 사원의 사번, 이름, 급여, 부서번호를 구하시오 --93건
select e.employee_id, e.last_name, e.salary, d.department_id
from (select distinct department_id
	  from employees 
	  where salary < (select avg(salary) from employees)) d
join employees e on(d.department_id = e.department_id);
-- 인라인은 from절 다음에 테이블이 아닌 select절이 나오는 경우

-- ex2) 모든 사원의 사번,이름,급여를 출력하시오.
-- 조건1) 사원 정보를 급여순으로 정렬
-- 조건2) 한 페이지당 5명을 출력
-- 조건3) 현재페이지가 3페이지라고 가정 (급여순 11등 ~ 15등까지 출력)

-- 방법1) 인라인 뷰(inline View) – TopN질의
set @pageno=3; -- 변수 설정

select b.rn, b.employee_id, b.first_name, b.salary
from(select @rownum := @rownum + 1 as rn, a.*
	 from(select employee_id, first_name, salary
		  from employees
		  order by salary desc
		  ) a, (select @rownum := 0) tmp
	) b
where b.rn > (@pageno * 5 - 5) and b.rn <= (@pageno * 5);
-- 이클립스에서는 실행 안됨 / Workbench에서 실행할것

-- 방법2) 인라인 뷰(inline View) – limt 활용 (MySQL)
select employee_id, first_name, salary
from employees
order by salary desc limit 5, 5;  -- limit start+1 end
 
select a.employee_id, a.first_name, a.salary
from (select @rownum := @rownum + 1 as rn, employee_id, first_name, salary
	  from employees e, (select @rownum := 0) tmp
	  order by salary desc
	 )a limit 5, 5;

select a.*
from (select  employee_id, first_name, salary
     from employees e
     order by salary desc
    )a limit 0, 5;

-- ※ 스칼라 서브 쿼리 (Scalar Subquery)
-- 1.SELECT 절에 있는 서브 쿼리이다.
-- 2.한 개의 행만 반환한다.

-- 상관쿼리(correlated  subquery)   
--  : 메인쿼리 한행을 읽고 해당값을 서브쿼리에서 참조하여 서브쿼리결과에 존재하면 true를 반환
-- ex3)직급 아이디가 IT_PROG인 사원의 사번, 이름, 업무ID, 부서이름을 구하시오
select e.employee_id, e.first_name, job_id,
	  (select department_name from departments d 
	   where e.department_id = d.department_id) as department_name
from employees e
where job_id = 'IT_PROG';

-- ex4)60번 부서에 근무하는 사원의 사번, 이름, 급여,부서번호, 60번부서의 평균급여를 구하시오
select e.employee_id, e.first_name, salary, department_id,
	(select avg(salary) from employees where department_id = 60) as avg60
from employees e
where department_id = 60;

-- ex5)부서번호가 50인 부서의 총급여, 60인 부서의 평균급여, 90인 부서의 최고급여, 90인 부서의 최저급여를 구하시오
select
	(select sum(salary) from employees where department_id = 50) sum50,
	(select avg(salary) from employees where department_id = 60) avg60,
	(select max(salary) from employees where department_id = 90) max90,
	(select min(salary) from employees where department_id = 90) min90
from dual;   -- 가상테이블

select 3 + 4 from dual;

-- ※ 스칼라 서브 쿼리 (Scalar Subquery)
-- 서브 쿼리를 이용해서 CREATE, INSERT, UPDATE, DELETE를 할수 있다.

-- ex6) employees table을 emp_copy라는 이름으로 복사 하시오
--      (단, 컬럼 이름은 동일하게 복사한다)
create table emp_copy
select * from employees;

show tables;
select * from emp_copy;

-- ex7) employees table의 구조만 emp_blank라는 이름으로 생성하시오
--      (단, 컬럼 이름은 동일하게 복사한다)
create table emp_blank
select * from employees
where 1 = 0;

select * from emp_blank;

-- ex8) 50번 부서의 사번(eid), 이름(name), 급여(sal), 부서번호(did)만 emp50 이라는 이름으로 생성하시오
create table emp50;

select employee_id as "eid", first_name name, salary sal, department_id did
from employees
where department_id = 50;

select * from emp50;

-- ex9) employees table에서 부서번호가 80인 사원의 모든 정보를 emp_blank에 insert하시오
insert into emp_blank
select * from employees
where department_id = 80;

select * from emp_blank;

-- ex10) employees table의 모든 사원의 평균 급여보다 적게 받는 emp50 table의 사원의 급여를 500 인상하시오.
update emp50
set sal = sal + 500
where sal < (select avg(salary) from employees);

select * from emp50;

-- ex11)employees table의 모든 사원의 평균 급여보다 적게 받는 emp50 table의 사원은 퇴사처리 하시오.
delete 
from emp50
where sal < (select avg(salary) from employees);




