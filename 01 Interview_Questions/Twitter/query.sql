--Highest Salary In Department
--Find the employee with the highest salary per department.
--Output the department name, employee's first name along with the corresponding salary.

SELECT department, first_name, salary
FROM employee
WHERE salary IN 
(SELECT MAX(salary) AS highest_salary
FROM employee
GROUP BY department)