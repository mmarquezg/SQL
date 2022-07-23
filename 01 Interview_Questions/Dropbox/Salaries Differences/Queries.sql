--Obteniendo Trabajadores por departamento Marketing y Engineering
SELECT
    e.salary,
    d.department
FROM 
    db_employee AS e
        JOIN
    db_dept AS d ON e.department_id = d.id
WHERE department = 'marketing' or department = 'engineering';

--Máximo salario marketing
SELECT
    MAX(salary) as max_marketing
FROM 
    db_employee AS e
        JOIN
    db_dept AS d ON e.department_id = d.id
WHERE department = 'marketing';


--Máximo salario engineering
SELECT
    MAX(salary) AS engineering
FROM 
    db_employee AS e
        JOIN
    db_dept AS d ON e.department_id = d.id
WHERE department = 'engineering';

--Obteniendo la diferencia entre max_marketing y max_engineering
SELECT ABS(
(SELECT
    MAX(salary) as max_marketing
FROM 
    db_employee AS e
        JOIN
    db_dept AS d ON e.department_id = d.id
WHERE department = 'marketing') - 
(SELECT
    MAX(salary) as max_engineering
FROM 
    db_employee AS e
        JOIN
    db_dept AS d ON e.department_id = d.id
WHERE department = 'engineering')) AS max_salaries_difference;