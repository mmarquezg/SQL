---Highest Salaried Employees
---Find the employee with the highest salary in each department. Output the department name, employee's first name, and the salary.

--Query Solution:

WITH max_salary_per_dpt AS (
    SELECT
        department,
        MAX(SALARY) AS max_salary
    FROM worker
    GROUP BY 1
    )
SELECT
    w1.department,
    w1.first_name,
    w1.salary
FROM worker AS w1
INNER JOIN max_salary_per_dpt AS s ON w1.salary = s.max_salary
ORDER BY department

-- Source --> https://platform.stratascratch.com/coding/9865-highest-salaried-employees?code_type=1
