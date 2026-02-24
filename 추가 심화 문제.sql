--1. 조직도 시각화 및 경로 추적: 모든 사원에 대해 
--최상위관리자명 > 중간관리자명 > ... > 본인명 형태의 
--전체 보고 경로(Full Path)를 출력하고, 각 사원의
--계층 레벨(Level)만큼 이름 앞에 공백(indent)을 추가하여
--시각화하세요. (SYS_CONNECT_BY_PATH 활용)
 SELECT SYS_CONNECT_BY_PATH(LPAD(FIRST_NAME, (LEVEL + LENGTH(FIRST_NAME)), ' '), '>') AS MANAGER_PATH
   FROM EMPLOYEES 
  START WITH EMPLOYEE_ID = 100
CONNECT BY PRIOR EMPLOYEE_ID = MANAGER_ID
;
--2. 부서별 급여 Pareto 분석: 각 부서 내에서 
--사원들의 급여가 해당 부서 전체 급여 합계에서
--차지하는 누적 백분율을 구하세요. 누적 백분율이
--80% 이내에 드는 '핵심 인재군'만 출력하세요.
SELECT FIRST_NAME 
	 , IS_TALENT
  FROM (SELECT E.FIRST_NAME 
			 , E.DEPARTMENT_ID 
			 , E.SALARY 
			 , CASE WHEN (SELECT SUM(E2.SALARY)
					 	    FROM EMPLOYEES E2
					 	   WHERE E2.DEPARTMENT_ID = E.DEPARTMENT_ID 
					 	     AND E2.SALARY >= E.SALARY) / DEPT_SAL_SUM.SAL_SUM * 100 >= 80 THEN '핵심 인재군'
					ELSE '비핵심 인재군' END IS_TALENT
		  FROM EMPLOYEES E
		 INNER JOIN (SELECT DEPARTMENT_ID 
						  , SUM(SALARY) AS SAL_SUM
					   FROM EMPLOYEES
					  GROUP BY DEPARTMENT_ID) DEPT_SAL_SUM
			ON E.DEPARTMENT_ID = DEPT_SAL_SUM.DEPARTMENT_ID
		 ORDER BY E.DEPARTMENT_ID
		 	 , E.SALARY DESC)
 WHERE IS_TALENT = '핵심 인재군'
;
SELECT E.FIRST_NAME 
			 , E.DEPARTMENT_ID 
			 , E.SALARY 
			 ,(SELECT SUM(E2.SALARY)
		 	     FROM EMPLOYEES E2
		 	    WHERE E2.DEPARTMENT_ID = E.DEPARTMENT_ID 
		 	      AND E2.SALARY >= E.SALARY) AS "부서 내의 본인까지의 월급"
		 	 , DEPT_SAL_SUM.SAL_SUM AS "부서별 월급의 합"
		  FROM EMPLOYEES E
		 INNER JOIN (SELECT DEPARTMENT_ID 
						  , SUM(SALARY) AS SAL_SUM
					   FROM EMPLOYEES
					  GROUP BY DEPARTMENT_ID) DEPT_SAL_SUM
			ON E.DEPARTMENT_ID = DEPT_SAL_SUM.DEPARTMENT_ID
		 ORDER BY E.DEPARTMENT_ID 
		 	 , E.SALARY DESC
;
--3. 입사일 기반의 이동 평균(Moving Average): 
--각 사원의 입사일을 기준으로 해당 사원보다
--앞서 입사한 2명과 본인, 그리고 바로 뒤에 
--입사한 1명(총 4명)의 평균 급여를 계산하여 출력하세요.

;
--4. Job History Gap 분석: JOB_HISTORY 테이블을 참조하여
--사원별로 직무가 변경될 때 발생한 공백 기간
--(근무하지 않은 기간)의 일수를 계산하세요.
--또한, 한 번이라도 직무가 원래대로 돌아온(A -> B -> A) 
--'재부메랑' 사원이 있는지 확인하는 쿼리를 작성하세요.

--5. Pivot을 이용한 지역별 직무 분포: 각 REGION을 컬럼(열)으로
--JOB_ID를 행으로 하여 각 지역별로 해당 직무를 수행하는 사원 수를 집계하세요. 
--(Dynamic Pivot이 아닌 일반 PIVOT 또는 DECODE 활용)

--6. 급여 등급별 인건비 비중: SALARY를 5개 구간(NTILE(5))으로 나누고
--각 구간별 최고 급여와 최저 급여의 차이, 그리고 해당 구간이
--회사 전체 급여 지출액에서 차지하는 비중(%)을 구하세요.

--7. 가상 시나리오(What-If) 분석: 커미션(COMMISSION_PCT)이 없는 
--사원들에게는 부서별 평균 커미션의 50%를 소급 적용하고
--기존 커미션 보유자는 10% 인상했을 때
--회사 전체의 추가 지출 비용을 부서별로 산출하세요.

--8. 연속 근무자 탐색: 동일한 부서 내에서 입사일이
--연속된 날짜(주말 제외 3일 이내)에 집중된
--'입사 동기 그룹'을 찾아내고 이 그룹의 사원 명단을
--콤마(,)로 구분하여 한 행에 출력하세요. (LISTAGG 활용)

--9. PL/SQL Anonymous Block: EMPLOYEES 테이블의 데이터를 읽어
--급여가 전체 평균보다 낮은 사원들의 급여를 10% 인상하되
--인상 후 금액이 해당 직무(JOB_ID)의 MAX_SALARY를 초과할 경우
--MAX_SALARY로 고정하는 로직을 작성하세요. (수행 전/후 총액 변화 출력)

--10. 복합 제약 분석: LOCATIONS와 DEPARTMENTS를 활용하여 사원이 단 한 명도 없는 도시(City) 중
--해당 국가(Country) 내에서는 부서가 존재하는 도시들의 목록을 추출하고
--그 이유(부서가 있으나 사원이 없는 경우 vs 부서 자체가 없는 경우)를 구분하여 표시하세요.
