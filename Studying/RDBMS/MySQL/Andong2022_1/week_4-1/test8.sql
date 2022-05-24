use mydb;
show tables;

-- ex1) employees, departments테이블로 test1테이블을 만드시오
-- [조건1] employees, departments 테이블을 조인하여 쿼리를 만드시오
-- [조건2] 급여가  7000이상이면 '고급'  3000이상이면 '중급'  3000미만이면 '초급'으로 grade 컬럼으로 만드시오
--          (case when이용)
-- [조건3]   
--                last_name    department_name    salary       grade
--              -----------------------------------------------------
--                 King            Executive       24000        고급



     
select * from tab;
select * from test1;
drop table test1;
-- ----------------------------------------------------------------------------------------------
-- ex2) departments, locations2테이블로 test2테이블을 만드시오
--
--       departments(location_id) , locations2(loc_id)      
--      부서ID    부서명             도시
--      -----------------------------------------------------
--      60	      IT	             Southlake
--      50	     Shipping	         South San Francisco
--      10	     Administration	     Seattle




select * from test2;

-- ----------------------------------------------------------------------------------------------
-- ex3) employees테이블로 test3테이블을 만드시오
-- [조건1] self 조인을 이용하여 사원과 관리자를 연결하시오
-- [조건2] 모든 사원을 표시하시오
--
--        사원번호   사원이름      관리자
--        ----------------------------------
--        101          Kochhar       King   



-- ----------------------------------------------------------------------------------------------
-- ex4)employees테이블로 test4테이블을 만드시오
-- [조건1] 업무 id가 'SA_MAN'또는 ‘SA_REP'이면 'Sales Dept' 그 외 부서이면 'Another'로 표시
-- [조건2] case when을 이용하여 완성하시오
--        직무          분류
--       --------------------------
--       SA_MAN      Sales Dept
--       SA_REP      Sales Dept
--       IT_PROG      Another





    
    
    
    
    
    
