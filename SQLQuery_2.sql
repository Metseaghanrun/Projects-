SELECT * FROM  Human_Resources_Data

EXEC sp_help Human_Resources_Data


--Count the total number of employee by gender 
SELECT Sex, count (*) AS count 
  FROM Human_Resources_Data
  WHERE Termd = 0
  GROUP BY Sex;

--Count the number of race in the company 
SELECT RaceDesc, COUNT (*) AS RaceCount 
  FROM Human_Resources_Data
  WHERE Termd = 0
  GROUP BY RaceDesc
  ORDER BY RaceCount DESC;

--Age distribution of employees in company 
SELECT 
  MIN(Age) AS Youngest,
  MAX(Age) AS Oldest 
  FROM Human_Resources_Data
  WHERE Termd = 0;


-- Count the number of employees in each department
SELECT Department, COUNT (*) AS Emp_Department 
FROM Human_Resources_Data
WHERE Termd = 0
GROUP BY Department
ORDER BY Emp_Department DESC;

--Average Tenure of employement for employees who have been terminated in ceach department
SELECT  Department,
(AVG(DATEDIFF(year,DateofHire, DateofTermination)))AS Avg_employment_year 
FROM Human_Resources_Data
WHERE Termd = 1
GROUP BY Department
ORDER BY Avg_employment_year DESC;

-- The most recruitmentSource for employment ( This helps company to know the area to target during job posting)
SELECT RecruitmentSource, COUNT (*) AS Highest_RecruitmentSource
FROM Human_Resources_Data
WHERE Termd = 0
GROUP BY RecruitmentSource
ORDER BY Highest_RecruitmentSource DESC;

--Number of Employee in each Department 
SELECT Department , COUNT (*) AS Num_Employee
FROM Human_Resources_Data 
WHERE Termd = 0
GROUP BY Department 
ORDER BY Num_Employee DESC;

--Department with the highest turnover rate 
SELECT Department,
 Num_Employee,
 Terminated_Count
FROM (
   SELECT Department,
   COUNT (*) AS Num_Employee,
   SUM (CASE WHEN Termd = 1 THEN 1 ELSE  0 END ) AS Terminated_Count
FROM Human_Resources_Data
GROUP BY Department 
) AS Subquery 
ORDER BY Terminated_Count DESC


--Distributions of employees across location by city and State
SELECT State, COUNT (*) AS Count 
FROM Human_Resources_Data 
WHERE Termd = 0
GROUP BY State
ORDER BY Count DESC;

-- Average  Salary Distribution across departments

SELECT Department,
    (round ((AVG(Salary)),0 )) AS Avg_salary 
FROM Human_Resources_Data
WHERE Termd = 0
GROUP BY Department
ORDER BY Avg_salary DESC;

--Employee performance
SELECT Employee_Name, Department, SpecialProjectsCount,PerformanceScore, EngagementSurvey, EmpSatisfaction
FROM Human_Resources_Data
WHERE Termd = 0
ORDER BY SpecialProjectsCount DESC;














  
