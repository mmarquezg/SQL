-- 2.How many days has each customer visited the restaurant?
/*
Step 1: SELECT customer_id and order_date to verify if some customer has gone to the rest more than one time at the same day
Step 2: Use COUNT(DISTINCT) to count order_date only once
Step 3: GROUP BY customer_id to get the final result
*/

SELECT
	customer_id,
    COUNT(DISTINCT order_date) AS total_days_visited
FROM sales
GROUP BY customer_id;