--finding the average popularity of the Hack per office location.
SELECT
    emp.location,
    AVG(s.popularity) AS popularity_avg
FROM
    facebook_employees AS emp
JOIN
    facebook_hack_survey AS s ON s.employee_id = emp.id
GROUP BY location;