-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, 
-- not just sushi - how many points do customer A and B have at the end of January?

/*
Step 1: Identify the total purchases done by each customer for each product
Step 2: INNER JOIN between sales and menu to get the prices
Step 3: Use DATE_ADD in order to obtain the last day of the first week after a customer joins
Step 4: Use a CASE WHEN to applying the 2x multiplier when an order_date is between join_date and 7 days after
Step 5: WHERE condition for only take into consideration the orders done in January
Step 6: Using the code done before as a subquery to SUM() the total points in order to obtain the total point for each customer
*/

SELECT
	customer_id,
    SUM(total_points) AS member_points
FROM (
	SELECT
		s.customer_id,
		CASE
			WHEN order_date BETWEEN join_date AND DATE_ADD(join_date, INTERVAL 7 DAY) THEN me.price * 20
		ELSE me.price * 10
		END AS total_points,
		s.order_date,
		DATE_ADD(join_date, INTERVAL 7 DAY) AS last_promo_day
	FROM sales AS s
	INNER JOIN members AS mm ON s.customer_id = mm.customer_id
	INNER JOIN menu AS me ON s.product_id = me.product_id
	WHERE order_date <= '2021-01-31'
	ORDER BY s.customer_id, s.order_date) AS ranking_members
GROUP BY customer_id
ORDER BY customer_id;


