CREATE DATABASE ds;
SELECT 
*
FROM ds_salaries;

-- 1. Checking NULL on Dataset
SELECT
*
FROM ds_salaries
WHERE work_year IS NULL;


-- 2. Seeing all the job_title
SELECT DISTINCT job_title
FROM ds_salaries
ORDER BY job_title;

-- 3. job_title related to data analyst job position
SELECT DISTINCT job_title
FROM ds_salaries
WHERE job_title LIKE "%data analyst%"
ORDER BY job_title;

-- 4. How much average the amount pay for data analyst job-position
SELECT (AVG(salary_in_usd)*15693)/12 AS avg_salary_monthly_rp   #ECR BI Kurs on 5th Januari
FROM ds_salaries;

-- 4.1 How much average the amount pay for data analyst job position in various level experiences
SELECT experience_level, (AVG(salary_in_usd)*15693)/12 AS avg_salary_monthly_rp
FROM ds_salaries
GROUP BY experience_level;

-- 4.2 How much average the amount pay for data analyst job position in various level experiences and the state from employment-type
SELECT experience_level, 
employment_type,
	(AVG(salary_in_usd)*15693)/12 AS avg_salary_monthly
FROM ds_salaries
GROUP BY experience_level, employment_type
ORDER BY experience_level, employment_type;

-- 5. Country with high amaount pay for data analyst job, (FT-employment_type)
SELECT company_location,
	AVG(salary_in_usd) AS avg_salary_usd
FROM ds_salaries
WHERE job_title LIKE "%data analyst%" 
	AND employment_type = "FT"
    AND experience_level = "EN"
GROUP BY company_location
HAVING avg_salary_usd >= 30000;

-- 6. In witch year the highest increase of salary from mid to senior level experience (job position related to data analyst and FT employee status)
SELECT DISTINCT work_year
FROM ds_salaries;

WITH ds_1 AS (
	SELECT work_year,
		AVG(salary_in_usd) AS avg_sal_month_ex
	FROM ds_salaries
    WHERE employment_type = "FT"
		AND experience_level = "EX"
        AND job_title LIKE "%data analyst%"
        GROUP BY work_year
), ds_2 AS (
SELECT work_year,
		AVG(salary_in_usd) AS avg_sal_month_mid
	FROM ds_salaries
    WHERE employment_type = "FT"
		AND experience_level = "MI"
        AND job_title LIKE "%data analyst%"
        GROUP BY work_year
        
#Running query on Mysql doesn't support for full outter join for the null data on year salaries of 2020
	#new table t_year for alternatives query 
), t_year AS (				
	SELECT DISTINCT work_year
    FROM ds_salaries
) SELECT t_year.work_year,
ds_1.avg_sal_month_ex,
ds_2.avg_sal_month_mid,
ds_1.avg_sal_month_ex - ds_2.avg_sal_month_mid AS diff_gap
FROM t_year 
LEFT JOIN ds_1 ON ds_1.work_year = t_year.work_year
LEFT JOIN ds_2 ON ds_2.work_year = t_year.work_year;