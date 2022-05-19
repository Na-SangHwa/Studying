-- [16] VIEW 
--  다른 테이블이나 뷰에 포함된 맞춤표현(virtual table)
--  join하는 테이블의 수가 늘어나거나 질의문이 길고 복잡해지면 작성이 어려워지고 유지보수가 어려울수 있다. 
--  이럴때 스크립트를 만들어두거나 stored query를 사용해서
--  데이터베이스 서버에 저장해두면 필요할때 마다 호출해서 사용할수 있다

--  * 자체적으로 데이터를 포함하지 않는다
--  * 베이스테이블(Base table) : 뷰를 통해 보여지는 실제테이블
--  * 선택적인 정보만 제공 가능

-- [형식]
-- create [or  replace] [force | noforce ] view 뷰이름 [(alias [,alias,.....)]
-- as 서브쿼리
-- [with check option [constraint 제약조건이름]]
-- [with read only [constraint 제약조건이름]]

--  - create or replace : 지정한 이름의 뷰가 없으면 새로생성, 동일이름이 있으면 수정
--   - force | noforce
--          force  : 베이스테이블이 존재하는 경우에만 뷰생성가능
--          noforce: 베이스테이블이 존재하지 않아도 뷰생성가능
--  - alias  
--        뷰에서 생성할 표현식 이름(테이블의 컬럼이름 의미)
--        생략하면 서브쿼리의 이름적용
--        alias의 갯수는 서브쿼리의 갯수와 동일해야함
--  - 서브쿼리 : 뷰에서 표현하는 데이터를 생성하는 select구문
--  - 제약조건 
--        with check option : 뷰를 통해 접근가능한 데이터에 대해서만 DML작업가능
--        with read only : 뷰를 통해 DML작업안됨
--        제약조건으로 간주되므로 별도의 이름지정가능
-- ===================================================================================
-- ex1) 사원테이블에서 부서가 90인 사원들을 v_view1으로 뷰테이블을 만드시오
--     (사원ID,사원이름,급여,부서ID만 추가)
use mydb;

create or replace view v_view1(사원ID,사원이름,급여,부서ID)
as select employee_id, last_name, salary,department_id
	from employees
    where department_id=90;

show tables;
select * from v_view1;
-- -----------------------------------------------------------------------------------
-- ex2) 사원테이블에서 급여가  5000이상 10000이하인 사원들만 v_view2으로 뷰를 만드시오 --43건
--    (사원ID , 사원이름, 급여, 부서ID)
create or replace view v_view2(사원ID,사원이름,급여,부서ID)
as  select employee_id, last_name, salary, department_id
    from employees
    where salary>=5000 and salary<=10000;   

create or replace view v_view2(사원ID,사원이름,급여,부서ID)
as  select employee_id, last_name, salary, department_id
    from employees
    where salary between 5000 and 10000;     
    
select * from v_view2;   
-- ------------------------------------------------------------------------------------
-- ex3) v_view2 테이블에서  103사원의 급여를 9000.00에서 12000.00으로 수정하시오.
set autocommit=0;

update v_view2 set 급여=12000 where 사원ID=103;

select * from v_view2;
rollback;   -- 원본을 보존하기 위해 rollback

select * from employees where employee_id=103;
-- ------------------------------------------------------------------------------------
-- ex4)사원테이블과 부서테이블에서 사원번호,사원명,부서명을 v_view3로 뷰테이블을만드시오
--     조건1) 부서가 10,90인 사원만 표시하시오
--     조건2) 타이틀은  사원번호, 이름, 부서이름으로 출력하시오
--     조건3) 사원번호로 오름차순정렬하시오
create or replace view v_view3(사원번호, 이름, 부서이름)
as select employee_id, last_name, department_name
   from employees
   left join departments using(department_id)
   where department_id in(10,90)
   order by 1 asc;
    
select * from v_view3;
show tables;
-- --------------------------------------------------------------------------------------
-- ex5) 부서ID가 10,90번 부서인 사원들의 부서 위치를 표시하시오
--     조건1) v_view4로 뷰테이블을 만드시오
--     조건2) 타이틀을  사원번호,사원명,급여,입사일,부서명,부서위치(city)로 표시하시오
--     조건3) 사원번호순으로 오름차순정렬하시오
--     조건4) 급여는 천단위절삭하고,세자리마다 콤마와 '달러'을 표시하시오
--     조건5) 입사일은  '2004년 10월 02일' 형식으로 표시하시오  





select * from v_view4;
-- ----------------------------------------------------------------------------------------
-- ex6) 
-- 사원테이블을 가지고 부서별 평균급여를 뷰(v_view5)로 작성하시오
-- 조건1) 반올림해서 1000단위까지 구하시오
-- 조건2) 타이틀은  부서ID,부서평균
-- 조건3) 부서별로 오름차순정렬하시오
-- 조건4) 부서ID가 없는 경우 5000으로 표시하시오




select * from v_view5;
-- ----------------------------------------------------------------------------------------
-- ex9)뷰 - 인라인
-- 부서별 최대급여를 받는 사원의 부서명,최대급여를 출력하시오(단, null은 제외)



-- -----------------------------------------------------------------------------------------
-- ex10) Top N분석
-- 급여를 가장많이 받는 사원3명의 이름,급여를 표시하시오


-- -----------------------------------------------------------------------------------------
-- ex11) 최고급여를 받는 사원1명을 구하시오


-- ------------------------------------------------------------------------------------------
-- ex12) 급여의 순위를 내림차순정렬했을때, 3개씩 묶어서 2번째 그룹을 출력하시오
--      (4,5,6 순위의 사원출력  ==> 페이징처리기법) 
--        employee_id      last_name      salary
--        --------------------------------------
--         145             John       14000.00
--         146             Karen      13500.00
--         201             Michael    13000.00

-- 방법1)
select a.*
from (select  employee_id, first_name, salary
     from employees e
     order by salary desc
    )a limit 3, 3;

-- 방법2)
select e.employee_id,e.first_name,salary, e.page
from(select  tt.*, ceil(@rownum := @rownum + 1/3) as page
	 from (select * from employees, (select @rownum := 0) tmp  order by salary desc) tt) e
where page=2; 
-- ----------------------------------------------------------------------------------------------
-- ex13) 사원들의 연봉을 구한후 최하위 연봉자 5명을 추출하시오
--      조건1) 연봉 = 급여*12+(급여*12*커미션)
--      조건2) 타이틀은  사원이름 , 부서명, 연봉
--      조건3) 연봉은  $25,000 형식으로 하시오

-- 사원이름        부서명       연봉
-- -------------------------------
-- Olson	    Shipping     $25,200
-- Markle       Shipping     $26,400
-- Philtanker   Shipping     $26,400
-- Gee          Shipping     $28,800
-- Landry       Shipping     $28,800




      
select salary*12* ifnull(commission_pct, 0) from employees;




