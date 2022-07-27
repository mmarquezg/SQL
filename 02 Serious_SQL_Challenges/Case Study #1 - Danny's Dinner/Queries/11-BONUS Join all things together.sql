-- Bonus Questions: Danny and his team can use to quickly derive insights without needing to join the underlying tables using SQL
/* JOIN ALL THE THINGS TOGETHER 
Step 1: INNER JOIN in order to obtain the customer_id, order_date, product_name and price
Step 2: LEFT JOIN in order to obtain the join_date from members table. With this, we can compare the order_date with join_date
Step 3: Using a CASE WHEN in order to determinate if the customer was a member when he made an order
*/

SELECT
	s.customer_id,
	s.order_date,
	me.product_name,
	me.price,
    CASE
		WHEN order_date >= join_date THEN 'Y'
        ELSE 'N'
	END AS member
FROM sales AS s
INNER JOIN menu AS me ON s.product_id = me.product_id
LEFT JOIN members AS mm ON s.customer_id = mm.customer_id
ORDER BY s.customer_id, s.order_date, me.product_name; 