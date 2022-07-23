---Highest Total Miles
---You’re given a table of Uber rides that contains the mileage and the purpose for the business expense.  You’re asked to find business purposes that generate the most miles driven for passengers that use Uber for their business transportation. Find the top 3 business purpose categories by total mileage.

--Query Solution:

SELECT
    purpose,
    SUM(miles) AS total_miles
FROM my_uber_drives
GROUP BY purpose
ORDER BY total_miles DESC
LIMIT 3

-- Source --> https://platform.stratascratch.com/coding/10169-highest-total-miles?code_type=1
