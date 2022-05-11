-- [8] 하위질의(SubQuery)
-- : 하나의 쿼리에 다른 쿼리가 포함되는 구조,()로처리
-- 1. 단일행 서브쿼리(단일행반환) :  > , < , >=, <= , <>
--     Main Query
               
--         Sub  Query      -- 1개결과 

-- 2. 다중행 서브쿼리(여러행반환) : in, any, all
--     Main Query
     
--          Sub Query      -- 여러개의 결과  

--       < any : 비교대상중 최대값보다 작음
--                (ex. 과장직급의 최대급여보다 적게 받는 사원조회) 
--       > any : 비교대상중 최소값보다 큼   
--                (ex. 과장직급의 최소급여보다 많이 받는 사원조회)
--       = any : in연산자와 동일
--                (ex. 과장 직급과 동일한 급여를 받는 사원조회)
--       <  all : 비교대상중 최소값보다 작음
--                (ex. 과장직급의 최소 급여보다 적게 받는 사원조회) 
--       >  all : 비교대상중 최대값보다 큼  
--                (ex. 과장직급의 최대 급여보다 많이 받는 사원조회)
-- ==============================================================================
use mydb;
show tables;

-- ex1) Neena사원의 부서명을 알아내시오
select department_id  from employees  where first_name='Neena';   -- -> 90
select department_name  from departments  where department_id=90; -- -> Executive

select department_name
from departments
where department_id=(
	select department_id
	from employees
	where first_name='Neena');

select department_id  
from employees  
where first_name='Neena';   -- -> 90


-- ex2) Valli Pataballa의  업무명(job_title)을 알아내시오
-- [참고] job_id(IT_PROG)
select job_title
from jobs
where job_id=(
	select job_id
	from employees
	where first_name='Valli' and last_name='Pataballa');

-- -----------------------------------------------------------------------------------
-- ex3) Alexander Hunold의 근무지(city)를 알아내시오
-- [참고] department_id(60) -> location_id(1400) -> city(Southlake)

select city
from locations
where location_id=(
					select location_id
					from departments
					where department_id=(select department_id
									from employees
									where first_name='Alexander' and last_name='Hunold'));




-- ------------------------------------------------------------------------------------
-- ex4) Steven King가 근무하는 나라(country_name)를 알아내시오
-- [참고] 답 : United States of America
select country_name
from countries
where country_id=(select country_id
                                   from locations
                                   where location_id=(select location_id
                                                      from departments
                                                      where department_id=(select department_id
                                                                           from employees
                                                                           where first_name = 'Steven' and last_name = 'King')));



-- ------------------------------------------------------------------------------------
-- ex5) Diana Lorentz가 근무하는 지역(region_name)을 알아내시오
select region_name
from regions
where region_id=(select region_id
                 from countries
                 where country_id=(select country_id
                                   from locations
                                   where location_id=(select location_id
                                                      from departments
                                                      where department_id=(select department_id
                                                                           from employees
                                                                           where first_name = 'Diana' and last_name = 'Lorentz'))));

-- ------------------------------------------------------------------------------------
-- ex6) Neena사원의 부서에서 Neena사원보다 급여를 많이 받는 사원들을 구하시오  ==> 1건
--                  (90)         (17000)
-- first_name    department_id    salary
-- ----------------------------------------
-- Steven	     90	           24000
select first_name, department_id, salary
from employees
where department_id=(
	select department_id
	from employees
	where first_name='Neena')
    
and salary > (select salary
	from employees
	where first_name='Neena');

-- ------------------------------------------------------------------------------------
-- ex7) oliver와 같은 업무ID이면서 같은 부서가 아닌 사원의 
--         이름(first_name),업무ID, 부서ID를 출력하시오  ==> 1건 
--                       (SA_REP)  (80)       
--       first_name        job_id        department_id
--       ------------------------------------------------
--       Kimberely	SA_REP	
select * from employees;
              
select first_name,job_id,department_id
from employees
where job_id=(
	select job_id
	from employees
	where lower(first_name)='oliver')
and ifnull(department_id,0) != (select department_id
	from employees
	where lower(first_name)='oliver');






              
select distinct department_id
from employees;
                                        
select distinct ifnull(department_id,1000)
from employees;
-- -------------------------------------------------------------------------------------
-- ex8) Austin과 같은부서이면서 같은 급여를 받는사원들의 이름, 부서명, 급여를 구하시오 ==> 2건
--                    (60)                  (4800)
             
--         last_name     department_name   salary
--        -------------------------------------------------  
--        Austin	          IT            4800
--        Pataballa           IT            4800     
select last_name,department_name,salary
from employees
left join departments using(department_id)
where department_id=(select department_id
					from employees
					where last_name='Austin')
and salary=(select salary
			from employees
            where last_name='Austin');




-- ----------------------------------------------------------------------------------------------
-- ex9) 최저급여를 받는 사원들의 이름과 급여를 구하시오
--       last_name   salary
--       ---------------------
--       Olson       2100  
select last_name,salary
from employees
where salary=(select min(salary)
			from employees);



-- ----------------------------------------------------------------------------------------------
-- ex10) 평균급여를 받는 사원들의 이름과 급여를 구하시오  ==> 2건
--       조건1)평균급여를 천단위 절삭하시오       
--       사원명        급여
--       ----------------------
--       Ernst          6000
--       Fay            6000
select last_name,salary
from employees
where salary=(
	select truncate(avg(salary),-3)
	from employees);

-- truncate(숫자,버릴 자릿수): 숫자를 버릴 자릿수 아래로 버림
-- ----------------------------------------------------------------------------------------------
-- ex11) 업무ID별 급여평균중 전체평균급여보다 적게 받는 업무ID의  
--      업무명과  급여평균를 구하시오(단일행 서브쿼리)  ==> 6건
--     조건1) 업무별 급여평균을 구한다
--     조건2) 급여평균은 천단위 절삭한다
--     조건3) 타이틀은 업무명,급여합계로 한다
--     조건4) 모든 사원을 포함한다

--    업무명                                             급여평균
--    ---------------------------------
--    Programmer	             5000
--    Purchasing Clerk	         2000
--    Marketing Representative   6000
--    Administration Assistant   4000
--    Stock Clerk	             2000
--    Shipping Clerk	         3000
select job_title as "업무명", truncate(avg(salary),-3) as "급여평균"
from employees
left join jobs using(job_id)
group by job_title
having avg(salary) < (select avg(salary) from employees);

select avg(salary)
from employees;


-- -----------------------------------------------------------------------------------
-- 다중행 서브쿼리
-- ex12) 'SA_REP' 직급보다 급여가 많은 'ST_MAN'직급 직원들을 조회하시오    -- 4건
                                           
-- [분석]
-- ST_MAN 사원의 급여 8000, 8200,7900,6500,5800 중 5800만 제외됨
-- SA_REP의 최소급여는 6100이기 때문

select distinct salary  from employees  where job_id='SA_REP' order by 1;
select distinct salary  from employees  where job_id='ST_MAN';

-- last_name   job_id   salary
-- -----------------------------
-- Weiss       ST_MAN    8000
-- Fripp       ST_MAN    8200
-- Kaufling    ST_MAN    7900
-- Vollman     ST_MAN    6500


-- -----------------------------------------------------------------------------------
-- ex13) 'SA_REP' 직급의 최소급여보다 급여가 적은 'ST_MAN'직급 직원들을 조회하시오   -- 1건
-- last_name   job_id   salary
-- -----------------------------
-- Mourgos	ST_MAN	5800



-- --------------------------------------------------------------------------------------
--       (9000,4800,4200,6000)
-- ex14) 'IT_PROG' 직급중 가장 많이 받는 사원의 급여보다,더 많은급여를 받는   -- 10건
--      'FI_ACCOUNT' 또는 'SA_REP' 직급 직원들을 조회하시오
--      조건1) 급여순으로 내림차순정렬하시오
--      조건2) 급여는 세자리마다 콤마(,) 찍고 화폐단위 '달러'을 붙이시오
--      조건3) 타이틀은  사원명, 업무ID, 급여로 표시하시오

--      사원명      업무ID          급여
--      ----------------------------------------
--      Ozer         SA_REP        11,500달러
--      Abel         SA_REP        11,000달러
--      Vishney      SA_REP        10,500달러




-- --------------------------------------------------------------------------------------
--      9000  4800  4200 6000
-- ex15) 'IT_PROG'와 같은 급여를 받는 사원들의 이름,업무ID,급여를 전부 구하시오  ==> 10건
-- 이름    업무ID   급여
-- -------------------------
-- Hunold    IT_PROG    9000.00
-- Ernst     IT_PROG    6000.00



-- -------------------------------------------------------------------------------------
-- ex16) 전체직원에 대한 관리자와 직원을 구분하는 표시를 하시오(in, not in이용)
--       조건1) 구분별 오름차순하고 사원번호별 오름차순정렬하시오
-- 사원번호      이름          구분
-------------------------------------
-- 100      King    관리자

select employee_id,last_name,manager_id from employees order by 3;
                  
-- 방법1 (case, in연산자)


--  방법2 (uinon, in, not in연산자)


select * from employees;  
-- ----------------------------------------------------------------------------------------------
-- ex17) 다음과 같은 조건에 맞는 행을 검색하시오   ==> 28건
--      조건1) 직급별 평균급여를 구한후 모든 사원중 그 급여를 받는 사원을 조회하시오
--            (단, 100단위 이하 절삭)
--      조건2) 출력할 급여는 세자리마다 콤마와 $표시
--      조건3) 사원이름(last_name),직무(job_title) ,급여(salary) 로 표시하시오
--      조건4) 급여순으로 오름차순 정렬하시오

--         사원이름                  직무                 급여
--         ---------------------------------------
--        Mikkilineni Stock Clerk    $2,700
--        Seo         Stock Clerk    $2,700
--        Nayer       Stock Clerk    $3,200




-- --------------------------------------------------------------------
-- MySQL에서 소계,합산 계산하는 rollup함수
-- [형식]
-- SELECT A, B, sum(C) FROM TABLE GROUP BY A, B WITH ROLLUP;

create table goods(
item varchar(10),
cost int);

insert into goods(item, cost) values('pencil', 100);
insert into goods(item, cost) values('erase', 200);
insert into goods(item, cost) values('pencil', 150);
insert into goods(item, cost) values('pencil', 130);
insert into goods(item, cost) values('erase', 190);
commit;
select * from goods;

-- 테스트1) group by


-- [결과]
-- item   sum
-- -----------
-- pencil 380
-- erase  390
-- -----------------------------------------
-- 테스트2) group by ~ with rollup
select item, sum(cost)as "sum" 
from goods 
group by item with rollup 

-- [결과]
-- item  sum
-- erase  390
-- pencil 380
-- NULL   770
-- ----------------------------------------------------------------------------
create table storegoods(
store varchar(10),
item varchar(10),
cnt int,
cost int);

insert into storegoods(store,item,cnt,cost) values("A Mart", "apple", 1, 100);
insert into storegoods(store,item,cnt,cost) values("A Mart", "orange", 1, 200);
insert into storegoods(store,item,cnt,cost) values("A Mart", "orange", 2, 390);
insert into storegoods(store,item,cnt,cost) values("B Mart", "apple", 1, 150);
insert into storegoods(store,item,cnt,cost) values("C Mart", "apple", 1, 130);
insert into storegoods(store,item,cnt,cost) values("C Mart", "apple", 2, 250);
insert into storegoods(store,item,cnt,cost) values("C Mart", "orange", 1, 190);

select * from storegoods;

-- 테스트1) group by




-- store     item    all_cnt   all_cost
-- --------------------------------------
-- A Mart   apple        1      100
-- A Mart   orange       3      590
-- B Mart   apple        1      150
-- C Mart   apple        3      380
-- C Mart   orange       1      190
-- -------------------------------------------------------------

-- 테스트2) rollup , grouping 


-- [결과]
-- store    item    all_cnt   all_cost
-- A Mart   apple        1      100
-- A Mart   orange       3      590
-- A Mart   NULL         4      690
-- B Mart   apple        1      150
-- B Mart   NULL         1      150
-- C Mart   apple        3      380
-- C Mart   orange       1      190
-- C Mart   NULL         4      570
-- NULL     NULL         9     1410
-- -------------------------------------------------------------

-- 테스트3)
select grouping(store) as "grp_store" , store , grouping(item) as "grp_item", 
       item , sum(cnt) as "all_cnt" , sum(cost) "as all_cost" 
from storegoods 
group by store, item 
with rollup;
-- [결과]
-- grp_store   grp_item   item     all_cnt  as all_cost
-- -------------------------------------------------
--  0 A Mart     0       apple        1         100
--  0 A Mart     0       orange       3         590
--  0 A Mart     1       NULL         4         690
--  0 B Mart     0       apple        1         150
--  0 B Mart     1       NULL         1         150
--  0 C Mart     0       apple        3         380
--  0 C Mart     0       orange       1         190
--  0 C Mart     1       NULL         4         570
--  1 NULL       1       NULL         9        1410
-- -------------------------------------------------------------

-- 테스트4) grouping
select case grouping(store) when 1 then 'total'   else store end as "store", 
       case grouping(item)  when 1 then 'subtotal' else item end as "store", 
       sum(cnt) as "all_cnt" , sum(cost) as "all_cost"
from storegoods 
group by store, item 
with rollup;
-- store     item    all_cnt   all_cost
-- --------------------------------------
-- A Mart   apple        1      100
-- A Mart   orange       3      590
-- A Mart   subtotal     4      690
-- B Mart   apple        1      150
-- B Mart   subtotal     1      150
-- C Mart   apple        3      380
-- C Mart   orange       1      190
-- C Mart   subtotal     4      570
-- total    subtotal     9     1410




