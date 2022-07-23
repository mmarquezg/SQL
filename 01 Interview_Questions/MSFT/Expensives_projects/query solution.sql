---Expensive Projects: 
---Given a list of projects and employees mapped to each project, calculate by the amount of project budget allocated to each employee . The output should include the project title and the project budget per employee rounded to the closest integer. Order your list by projects with the highest budget per employee first.

--Query Solution:

SELECT 
    p.title,
    MAX(p.budget)/COUNT(p.id) AS budget_per_employee
FROM ms_projects AS p
JOIN ms_emp_projects AS emp ON p.id = emp.project_id
GROUP BY p.title
ORDER BY budget_per_employee DESC;


--Source -> Stratascrath url question : https://platform.stratascratch.com/coding/10301-expensive-projects
