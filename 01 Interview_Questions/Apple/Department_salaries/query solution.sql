---Department Salaries
---Find the number of male and female employees per department and also their corresponding total salaries. Output department names along with the corresponding number of female employees, the total salary of female employees, the number of male employees, and the total salary of male employees.

--Query Solution:

SELECT
    department,
    MAX(female_count) AS total_female,
    MAX(female_salary) AS total_female_salary,
    MAX(male_count) AS total_male,
    MAX(male_salary) AS total_male_salary
FROM(
SELECT
    department,
    CASE WHEN sex = 'F' THEN COUNT(sex) END AS female_count,
    CASE WHEN sex = 'F' THEN SUM(salary) END AS female_salary,
    CASE WHEN sex = 'M' THEN COUNT(sex) END AS male_count,
    CASE WHEN sex = 'M' THEN SUM(salary) END AS male_salary
FROM employee
GROUP BY department, sex) AS listing_count
GROUP BY department


--Source -> Stratascrath url question : https://platform.stratascratch.com/coding/9921-department-salaries?code_type=1