---Finding Updated Records: 
---We have a table with employees and their salaries, however, some of the records are old and contain outdated salary information. Find the current salary of each employee assuming that salaries increase each year. Output their id, first name, last name, department ID, and current salary. Order your list by employee ID in ascending order.

--Query Solution:

SELECT
    id,
    first_name,
    last_name,
    department_id,
    MAX(salary)
FROM ms_employee_salary
GROUP BY id, first_name, last_name, department_id
ORDER BY id ASC;

--Source -> Stratascrath url question : https://platform.stratascratch.com/coding/10299-finding-updated-records?code_type=1