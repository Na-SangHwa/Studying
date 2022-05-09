-- [6]조인(join)

-- (employees)     (departments)     (join)
--   사       부                 부        부                   사     부    부
--   원       서       +    서        서     =      원     서    서
--   이       번                 번        이                   이     번    이
--   름       호                 호        름                   름     호    름

-- ※종류
-- 0. natural join(자연조인) : 같은컬럼이 여러개 있을때 같은 컬럼 모두를 and연산해서 연결
-- 1. Inner join(내부조인) : 같은것 끼리만 연결
-- 2. Outer join(외부조인) : 한쪽을 기준(모두포함)해서 연결
--                         left  join : 왼쪽컬럼 모두포함
--                         right join : 오른쪽컬럼 모두포함
-- 3. self join : 자기자신 테이블과 연결
-- 4. cross join : 모든 경우의 수로 연결
-- 5. non equijoin : 범위에 속하는지 여부를 확인
-- 6. n개 테이블 조인 : 여러개의 테이블 조인

-- ※방법
-- 1. MySQL구문
-- 2. Ansi표준구문
-- ==========================================================================
select * from employees;    -- 107 (부서없는 사원 1명)
select * from departments;  -- 27

-- ex1) inner join : 같은것끼리만 조인
-- 사원테이블과 부서테이블에서 부서가 같을경우 사원번호,부서번호,부서이름을 출력하시오  -- 106건

-- 방법1(MySQL구문)
select employee_id, employees.department_id, department_name
from employees, departments
where employees.department_id = departments.department_id;

-- 방법2(MySQL구문)
select employee_id, e.department_id, department_name
from employees e, departments d
where e.department_id = d.department_id;

-- 방법3(Ansi표준구문)
select employee_id, department_id, department_name
from employees 
inner join departments using(department_id);


-- ex2)부서테이블과 위치테이블을 연결하여 부서가 위치한 도시를 알아내시오(inner join) ==> 27건
--     (departments, locations)
--  department_id     city
-- --------------------------------
--  10                   Seattle

select * from departments;
select * from locations;

-- 방법1(MySQL구문)
select department_id, city
from departments d, locations l
where d.location_id=l.location_id;


-- 방법2(Ansi표준구문)
select department_id, city
from departments
join locations using(location_id);


-- ex3) outer join(left) : 왼쪽 테이블은 모두포함하여 조인
-- 사원테이블과 부서테이블에서 부서번호가 같은 사원을 조인하시오 ==> 107건
-- 조건 1) 사원이름, 부서ID, 부서이름을 출력하시오
-- 조건 2) 사원테이블의 모든 사원을 포함하시오

select employee_id, department_id, department_name
from employees
left join departments using(department_id);

-- ex4) outer join(right) : 오른쪽 테이블은 모두 포함 하여 조인
-- 사원테이블과 부서테이블에서 부서번호가 같은 사원을 조인하시오 ===> 122건
-- 조건 1) 사원이름, 부서ID, 부서이름을 출력하시오
-- 조건 2) 부서테이블의 모든 부서를 포함하시오
select employee_id, department_id, department_name
from employees
right join departments using(department_id);

select * from departments;
select * from locations;
-- ex5) departments 와  locations 자연조인의 비교(같은컬럼 : location_id)  ==> 27건
--        두개의 테이블을 연결해서 부서위치(location_id), 도시(city), 부서이름(department_name)을 출력하시오
-- 방법1(natural  join)
select location_id, city, department_name
from departments
natural join locations;


-- 방법2(inner join)
select location_id, city, department_id
from departments
join locations using(location_id);


-- ex6) inner join,  natural join : 두개의 컬럼이 일치하는경우
--        부서ID와 매니저ID가  같은 사원을 연결하시오
--       (관련테이블 : departments, employees)  : 32건

--        last_name     department_id   manager_id
--        ------------------------------------------
-- 방법1(MySQL구문)

select last_name, e.department_id, e.manager_id
from employees e, departments d
where e.department_id=d.department_id and e.manager_id=d.manager_id;
 

-- 방법2(Ansi표준)
select last_name, department_id, manager_id
from employees
join departments using(department_id, manager_id);



-- 방법3(natural 조인이용)

select last_name, department_id, manager_id
from employees
natural join departments;

-- ex7) 내용은 같은데 컬럼명이 다른경우에 조인으로 연결하기
--       departments(location_id) , locations2(loc_id)
        
--      부서ID    부서명                       도시
--      -----------------------------------------------------
--      60	     IT	              Southlake
--      50	     Shipping	      South San Francisco
--      10	     Administration	  Seattle 

drop table locations2;          -- 테이블 삭제

create table locations2 
as select * from locations;     -- 테이블복사

show tables;                    -- 테이블 목록확인
select * from locations2;       -- locations2 내용확인

alter table locations2 rename column location_id to loc_id;   
-- location_id를 loc_id로 변경

-- 방법1(MySQL구문)
select department_id, department_name, city
from departments d, locations2 l
where d.department_id=l.loc_id;

-- 방법2(Ansi표준)
select department_id, department_name, city
from departments 
join locations2 on(location_id=loc_id);


-- ex8) self 조인 : 자기자신의 테이블과 조인하는경우
--        사원과 관리자를 연결하시오, 모든 사원을 표시하시오  --107건

--        사원번호   사원이름      관리자
--        ----------------------------------
--        101      Kochhar      King   

select e.employee_id as "사원번호", e.last_name as "사원이름", m.last_name as "관리자"
from employees e
left join employees m on(e.manager_id=m.employee_id);
-- ex9) cross join: 모든행에 대해 가능한 모든조합을 생성하는 조인
select count(*) from countries;     -- 25
select count(*) from locations;     -- 23

select * from countries; 
select * from locations; 

-- 방법1(MySQL구문)
select * from countries,locations;  -- 25 * 23 = 575건

-- 방법2(Ansi표준)
select * 
from countries
cross join locations;

-- ex10) Non Equijoin (넌 이큐조인) 
--      : 컬럼값이 같은경우가 아닌 범위에 속하는지 여부를 확인할때
--      [형식]  on (컬럼명 between 컬럼명1 and 컬럼명2)

show tables;
select * from salgrades;
--   grade   losal   hisal
--     1     2100    4000
--     2     4001    7000
--     3     7001    9000
--     4     9001   13000
--     5     13001  25000

-- ex11) 자신이 받는 급여가 어느등급인지를 확인하시오 -- 107건
--    조건1) 타이틀은 사원이름, 급여, 급여등급
--    조건2) 급여별 내림차순으로 정렬하시오
--           사원이름       급여      급여등급
--           ------------------------------------
--            King	       24000	       5
--            De Haan      17000	       5
select last_name as "사원이름", salary as "급여", grade as "등급"
from employees
left join salgrades on(salary between losal and hisal)
order by 2 desc;


-- ex12) n(여러)개의 테이블은 조인
-- 업무ID같은 사원들의 사원이름,업무내용,부서이름을 출력하시오  -- 107건
-- (employees, jobs, departments테이블을 조인)

-- [분석]
-- employees           jobs            departments
-- --------------------------------------------------
-- department_id      job_id          department_id
-- job_id

-- [조건]
-- 1. 부서이름 정렬후 같은 부서이름인 경우 업무명으로 오름차순 정렬하시오
-- 2. 사원이름, 부서이름, 업무명의 이름으로 출력하시오

-- [출력]
-- 사원이름      부서이름                 업무명    ===> employees   departments   jobs
-- --------------------------------------------------
-- Higgins	Accounting Manager	 Accounting
-- Gietz		Public Accountant	 Accounting
select last_name as "사원이름", department_name as "부서이름", job_title as "업무명"
from employees
left join departments using(department_id)
left join jobs using(job_id)
order by 2,3;


-- ----------------------------------------------------------------------------------
-- [문제1] manager_id가 같은 사원을 조인하여 
--       이름(last_name), 부서이름, 매니저ID를 출력하시오   -4건
--       (관련테이블 : employees, departments)

--  조건1)부서이름이 IT인 사원만 출력하시오
--  조건2)이름별로 오름차순 출력하시오
--  조건3)Ansi표준을 이용하여 join하시오

--  이름           부서이름   매니저ID
--  ----------------------------
--  Austin	   IT	  103
--  Ernst	   IT	  103
--  Lorentz	   IT	  103
--  Pataballa  IT	  103
select last_name as "이름", department_name as "부서이름", manager_id as "매니저id"
from employees
join departments using(manager_id)
where department_name="IT"
order by last_name asc;


select last_name as "사원이름", d.department_name as "부서이름", e.manager_id as "매니저id"
from employees e, departments d
where e.manager_id=d.manager_id and department_name='IT'
order by last_name;


-- ----------------------------------------------------------------------------------
-- [문제2] 부서테이블과 위치테이블을 조인하여 도시를 알아내시오   --21건
--        (관련테이블 : departments, locations)

-- 조건1) 도시가 'Seattle'만 출력하시오
-- 조건2) 부서ID별 내림차순 정렬하시오

-- department_id      city
-- -----------------------------
-- 10                      Seattle

select * from locations;
select * from departments;

select department_id, city
from departments
join locations using(location_id)
where city='Seattle'
order by 1 desc;


-- ----------------------------------------------------------------------------------
-- [문제3] 부서번호가 같은 사원을 Ansi표준으로 조인하시오  --9건
--        (관련테이블 : departments, employees)
--  조건1) 타이틀은  사원이름(last_name), 부서ID, 부서이름으로 출력하시오
--  조건2) 부서번호가 30번 또는 90번인 사원들만 출력하시오
--  조건3) 사원이름별 오름차순 정렬하시오

select last_name as '사원이름', department_id as '부서id', department_name as '부서이름'
from employees
left join departments using(department_id)
where department_id in (30,90)
order by 2,3 asc;

-- department_id=30 or department_id=90 또는 department_id in(30,90)
-- ----------------------------------------------------------------------------------
-- [문제4] 위치ID를 연결해서 사원이름,도시,부서이름을 출력하시오  ==> 52건
--        (관련테이블 : employees, locations2, departments)

-- 	조건1 : 사원이름 ,도시,부서이름로 제목을 표시하시오	
-- 	조건2 : Seattle 또는 Oxford 에서 근무하는 사원
-- 	조건3 : 도시순으로 오름차순정렬하시오 
-- 	조건4 : 모든 사원을 포함한다

--  사원이름      도    시     부서이름
-- ----------------------------------
--   Hall        Oxford       Sales

-- [분석]
-- employees                departments            locations2
-- -----------------------------------------------------------
-- department_id            department_id
--                         location_id              loc_id            



-- ----------------------------------------------------------------------------------
-- [문제5] 부서ID,나라ID,부서위치를 연결해서 다음과 같이 완성하시오   -- 1건
--        (관련테이블 : employees,locations2, departments,countries)
--      조건1 : 사원번호,사원이름,부서이름,도시,도시주소(street_address),나라명로 제목을 표시하시오
--      조건2 : 도시주소에  Vi 또는 St가 포함되어 있는 데이터만 표시하시오
--      조건3 : 나라명, 도시별로 오름차순정렬하시오
--      조건4 : 모든사원을 포함한다






-- ==========================================================================
-- [7]SET operator
-- 두개 이상의 쿼리결과를 하나로 결합시키는 연산자

-- 1. UNION      : 양쪽쿼리를 모두 포함(중복 결과는 1번만 포함)     --> 합집합
-- 2. UNION  ALL : 양쪽쿼리를 모두 포함(중복 결과도 모두 포함)  
-- 3. INTERSECT  : 양쪽쿼리 결과에 모두 포함되는 행만 표현                   --> 교집합(MySQL에서는 지원 안함)
-- 4. MINUS      : 쿼리1결과에 포함되고 쿼리2결과에는 포함되지 않는 행만 표현    --> 차집합(MySQL에서는 지원 안함)

-- ----------------------------------------------------------------------------
-- [연습용테이블]

drop table employees_role;

create table employees_role
as  select * from employees  where 1=0;         -- 테이블 구조만 복사

select * from employees_role;

insert into employees_role  values(101,'Neena','Kochhar','NKOCHHAR','515.123.4568',
'2005-09-21','AD_VP',17000.00,NULL,100,90);

insert into employees_role  values(101,'Neeno','Kochhar','NKOCHHAR','515.123.4568',
'2005-09-21','AD_VP',17000.00,NULL,100,90);

insert into employees_role values(300,'GeaHee','Kim','Jenni7','010.123.4567',
'2007-03-01','IT_PROG',23000.00,NULL,100,90);
commit;

delete from employees_role where first_name='GeaHee';
-- -----------------------------------------------------------------------------------
--ex1) union 
--     employees테이블과 employees_role테이블을 union으로 연결하시오  ==> 108건
--     조건1) employee_id, last_name이 같을경우 중복제거 하시오
--     조건2) 출력
--               emoloyee_id   last_name
--               ----------------------------






--employee_id   first_name    last_name
--101             Neena         Kochhar   <-- employees , employees_role둘다 있음
--101             Neeno         Kochhar   <-- employees_role에만 있음

--[참고]  ===> 109 레코드
select employee_id, first_name
from employees
union 
select employee_id, first_name
from employees_role
order by 1;

--ex2) union all
--     employees테이블과 employees_role테이블을 union all으로 연결하시오  ==> 110건
--     조건1) employee_id, last_name이 같을경우 중복 하시오
--     조건2) 출력
--               emoloyee_id   last_name
--               ----------------------------











