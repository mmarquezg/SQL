-- 5. Which item was the most popular for each customer?

/*
SOLUTION USING CTE AND WINDOWS FUNCTION
Step 1: Identify the total of purchases of each product for each customer
Step 2: Determinate the most purchased product by customer using DENSE_RANK and making the PARTITION BY customer_id to have a ranking according the customer
Step 3: Create a CTE with the query done according to the previous steps and SELECT with WHERE condition ranking = 1
*/

WITH customer_purchases AS (SELECT
	s.customer_id,
	me.product_name,
	COUNT(s.product_id) AS total_purchases,
    DENSE_RANK() OVER(PARTITION BY customer_id ORDER BY COUNT(s.product_id) DESC) AS ranking
FROM sales AS s
INNER JOIN menu AS me ON s.product_id = me.product_id
GROUP BY s.customer_id, me.product_name
ORDER BY ranking)
SELECT
	customer_id,
    product_name,
    total_purchases
FROM customer_purchases
WHERE ranking = 1;