-- 7. Which item was purchased just before the customer became a member?

/*
SOLUTION USING CTE AND WINDOWS FUNCTION
Step 1: Identify the purchases done by the members
Step 2: Determinate the lastest order date before became a member using DENSE_RANK and making the PARTITION BY customer_id to have a ranking according the customer
Step 3: Create a CTE with the query done according to the previous steps and SELECT with WHERE condition ranking = 1
*/

WITH last_order_bf_member AS (
	SELECT
		s.customer_id,
        me.product_name,
		s.order_date,
        DENSE_RANK() OVER(PARTITION BY s.customer_id ORDER BY s.order_date DESC) AS ranking
	FROM sales AS s
	INNER JOIN members AS mm ON s.customer_id = mm.customer_id
    INNER JOIN menu AS me ON s.product_id = me.product_id
	WHERE order_date < join_date)
SELECT
	customer_id,
    product_name,
    order_date AS last_order_bf_membership
FROM last_order_bf_member
WHERE ranking = 1;
