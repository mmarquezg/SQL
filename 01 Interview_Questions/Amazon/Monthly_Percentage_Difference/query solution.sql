---Monthly Percentage Difference
---Given a table of purchases by date, calculate the month-over-month percentage change in revenue. The output should include the year-month date (YYYY-MM) and percentage change, rounded to the 2nd decimal point, and sorted from the beginning of the year to the end of the year. The percentage change column will be populated from the 2nd month forward and can be calculated as ((this month's revenue - last month's revenue) / last month's revenue)*100.

--Query Solution:

SELECT
    TO_CHAR(created_at::date, 'YYYY-MM') AS year_month,
    ROUND(((SUM(value) - LAG(sum(value), 1) OVER (ORDER BY TO_CHAR(created_at::date, 'YYYY-MM'))) / LAG(sum(value), 1) OVER (ORDER BY TO_CHAR(created_at::date, 'YYYY-MM'))) * 100, 2) AS MoM 
FROM sf_transactions
GROUP BY year_month
ORDER BY year_month ASC


--An easier way to a better code understanding, using WINDOW
SELECT
    TO_CHAR(created_at::date, 'YYYY-MM') AS year_month,
    ROUND(((SUM(value) - LAG(sum(value), 1) OVER (w)) / LAG(sum(value), 1) OVER (w)) * 100, 2) AS MoM 
FROM sf_transactions
GROUP BY year_month
WINDOW w AS (ORDER BY TO_CHAR(created_at::date, 'YYYY-MM'))
ORDER BY year_month ASC

-- Source --> https://platform.stratascratch.com/coding/10351-activity-rank?code_type=1
