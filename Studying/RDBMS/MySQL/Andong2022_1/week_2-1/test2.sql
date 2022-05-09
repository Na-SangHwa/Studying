-- [4]내장 함수
-- 1. 숫자함수 : mod(나머지), round(반올림), trunc(내림), ceil(올림) 
-- 2. 문자함수 : lower, upper, length, substr, ltrim, rtrim, trim
-- ========================================================================
use mydb;     -- mydb 데이터베이스 사용
show tables;  -- 테이블 목록 확인

-- ex1)절댓값:abs


-- ex2)10을 3으로 나눈 나머지 구하시오(mod)


-- ex3)올림(ceil)


-- ex4) 내림(foor)


-- ex4)반올림(round)


-- ex4)숫자를 기준으로 버림(truncate)


-- ex5)거듭제곱(pow)


-- ex6)나머지(mod)


-- ex7)최댓값(greatest), 최솟값(least)


-- ex8)Ascii코드


-- ex9)100번 사원의 이름 Steven King


-- ex10)hello ssafy !!!


-- ex11)바꾸기(replace)


-- ex12)문자열의 위치(instr)


-- ex13)위치부터 갯수만큼리턴(mid, substring)


-- ex14)반대로 나열(reverse)


-- ex15)소문자로 바꾸기(lower, lcase)
select lower('hELlo SsaFy !!!'), lcase('hELlo SsaFy !!!')
from dual;

-- ex16)대문자로 바꾸기(upper, ucase)
select upper('hELlo SsaFy !!!'), ucase('hELlo SsaFy !!!')
from dual;

-- ex17)왼쪽에서 개수만큼추출(left),  오른쪽에서 개수만큼추출(right)
select left('hello ssafy !!!', 5), right('hello ssafy !!!', 6)
from dual;

-- ex18)
select now(), sysdate(), current_timestamp()
from dual;

-- ex19)
select curdate(), current_date(), curtime(), current_time()
from dual;

-- ex20)
select now() 현재시간, 
date_add(now(), interval 5 second) 5초후,
date_add(now(), interval 5 hour) 5시간후, 
date_add(now(), interval 5 day) 5일후
from dual;

-- ex21)
select year(now()), month(now()), monthname(now()), 
dayname(now()), dayofmonth(now()), dayofweek(now()), 
weekday(now()), dayofyear(now()), week(now())
from dual;

-- ex22)
select now(), 
date_format(now(), '%Y %M %e %p %l %i %S'),
date_format(now(), '%y-%m-%d %H:%i:%s'),
date_format(now(), '%y.%m.%d %W'), 
date_format(now(), '%H시%i분%s초')
from dual;

-- ex23)if(논리식, 값1, 값2)논리식이 참이면 값1이 리턴, 거짓이면 값2 리턴
--     ifnull(값1, 값2) 값1이 NULL이면 값2로 대치, NULL이 아니면 값1리턴.
--     nullif(값1, 값2) 값1 = 값2이 TRUE이면 NULL이 그렇지 않으면 값1이 리턴.
select if(3 > 2, '크다', '작다'), if(3 > 5, '크다', '작다'),
nullif(3, 3), nullif(3, 5),
ifnull(null, 'b'), ifnull('a', 'b')
from dual;

-- ex24)사원의 총수, 급여의 합, 급여의 평균, 최고급여, 최저급여









-- ========================================================================
-- [5]group by / having절
-- ※ select 
-- select [distinct] [컬럼1,컬럼2,.....][as 별명][ || 연산자][*]  --- 6
-- from 테이블명     --- 1
-- [where 조건절]    --- 2
-- [group by컬럼명]  --- 3
-- [having 조건절]   --- 4
-- [order by 컬럼명 asc|desc ]  --- 5

-- group by: 그룹함수(max,min,sum,avg,count..)와 같이 사용
-- having: 묶어놓은 그룹의 조건절

-- 세자리마다 콤마찍기 
-- [형식] format(컬럼명,소수점이하 자리수)
-- =========================================================================
-- ex1) 사원테이블에서 급여의 평균을 구하시오
--     조건)소수이하는 절삭,세자리마다 콤마(,)
--     사원급여평균
--     ------------
--            6,461
select concat(format(avg(salary),0),'달러')as "사원급여평균"
from employees;

-- ex2) 부서별로 급여평균을 구해서 부서ID, 급여평균을 출력하시오
select department_id as "부서id", avg(salary) as "급여평균"
from employees
group by department_id;



-- ex3) 업무ID별 급여의 합계를 구해서 업무ID, 급여합계를 출력하시오
select job_id as "업무id", format(avg(salary),0) as "급여평균"
from employees
group by job_id
order by 1 desc;


-- ex4) 부서별 급여평균을 구해서 사원명,부서별 급여평균을 출력하시오 (X)
select last_name, avg(salary)
from employees
group by department_id;


-- ex5) group by / having절
-- 부서별 급여평균을 구해서 평균급여가  6000이상인 부서만 출력  (8건)
-- (평균급여는 소수점 이하 절삭)
--      부서ID   평균급여
--     -----------------------
--        NULL    7000
--        20      9500
select department_id 부서ID, floor(avg(salary))
from employees
group by department_id
having avg(salary)>6000;




-- ex6)부서별 급여평균을 구하시오 (9건)
--    조건1) 소수이하는 반올림
--    조건2) 세자리마다콤마, 화페단위 ￦를 표시
--    조건3)  부서코드        평균급여
--           ---------------------------
--            NULL    ￦7,000
--            20      ￦9,500
--    조건4) 부서별로 오름차순정렬하시오 
--    조건5) 평균급여가 5000이상인 부서만 표시하시오

select department_id 부서코드, concat('$',format(avg(salary),0)) 평균급여
from employees
group by department_id
having avg(salary)>=5000
order by department_id asc;

-- ex7) 비효율적인 having절
-- 10과 20 부서에서 최대급여를 받는사람의 급여를 구하시오, 부서별로 오름차순 정렬하시오
-- department_id     max_salary
-----------------------------
-- 10                    4400
-- 20                    13000 
select department_id, max(salary) as "max_salary"
from employees
group by department_id
having department_id=10 or department_id=20
order by 1;
-- 비효율 제거
select department_id, max(salary) as "max_salary"
from employees
where department_id in(10,20)
group by department_id
order by 1;

-- ex8) having절 (where + group by + having)
-- 10과 20 부서에서 최대급여를 받는사람의 급여를 구하시오.  --1건
-- [조건1] 부서별로 오름차순 정렬하시오
-- [조건2] 최대급여가 5000이상인 부서만 출력하시오
--         department_id     max_salary
--         -----------------------------------
--           20                    13000 
select department_id, max(salary) as "max_salary"
from employees
where department_id in(10,20)
group by department_id
having max(salary)>=5000
order by 2;

