-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

/*
Step 1: Identify the total purchases done by each customer for each product
Step 2: INNER JOIN between sales and menu to get the prices
Step 3: Use a CASE WHEN to apply the two conditions. 2x multiplier for sushi purchases
Step 4: Using the code done before as a subquery to SUM() the total points in order to obtain the total point for each customer
*/

SELECT
	customer_id,
    SUM(points) AS customer_points
FROM (
	SELECT
		s.customer_id,
		me.product_name,
		COUNT(s.product_id) AS amount_purchases,
		CASE 
			WHEN me.product_name = 'sushi' THEN me.price * 20 * COUNT(s.product_id)
			ELSE me.price * 10 * COUNT(s.product_id)
		END AS points
	FROM sales AS s
	INNER JOIN menu AS me ON s.product_id = me.product_id
	GROUP BY s.customer_id, me.product_name
	ORDER BY s.customer_id) AS ranking_points
GROUP BY customer_id
ORDER BY customer_id;