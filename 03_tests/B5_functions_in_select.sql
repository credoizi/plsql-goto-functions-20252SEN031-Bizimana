-- =====================================================================
-- B5: Functions used in SQL (SELECT, WHERE, ORDER BY, GROUP BY)
-- Requires functions B1-B4 and the tables from 00_setup.
-- =====================================================================

-- 1. Functions in the SELECT list
SELECT d.doctor_id,
       d.first_name || ' ' || d.last_name AS doctor,
       d.monthly_salary,
       fn_annual_salary(d.monthly_salary)    AS annual_salary,
       fn_years_of_service(d.hire_date)      AS years_of_service,
       fn_calculate_tax(d.monthly_salary)    AS monthly_tax,
       fn_dept_name(d.ward_id)               AS ward
FROM   doctors d
ORDER BY d.doctor_id;

-- 2. Function in WHERE: doctors with at least 5 years of service
SELECT doctor_id, last_name, fn_years_of_service(hire_date) AS years_of_service
FROM   doctors
WHERE  fn_years_of_service(hire_date) >= 5
ORDER BY years_of_service DESC;

-- 3. Function in ORDER BY: highest tax first
SELECT doctor_id, last_name, monthly_salary, fn_calculate_tax(monthly_salary) AS monthly_tax
FROM   doctors
ORDER BY fn_calculate_tax(monthly_salary) DESC;

-- 4. Function in GROUP BY: doctors and average annual salary per ward
SELECT fn_dept_name(ward_id) AS ward,
       COUNT(*) AS doctors,
       ROUND(AVG(fn_annual_salary(monthly_salary))) AS avg_annual_salary
FROM   doctors
GROUP BY fn_dept_name(ward_id)
ORDER BY ward;

-- 5. Ward name for each patient (shows 'No ward assigned' for NULL)
SELECT patient_id, first_name || ' ' || last_name AS patient, fn_dept_name(ward_id) AS ward
FROM   patients
ORDER BY patient_id;
