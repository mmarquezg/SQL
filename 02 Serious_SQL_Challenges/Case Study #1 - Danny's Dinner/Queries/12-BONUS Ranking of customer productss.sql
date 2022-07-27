/* Bonus Questions: Danny also requires further information about the ranking of customer products, 
but he purposely does not need the ranking for non-member 
purchases so he expects null ranking values for the records when customers are not yet part of the loyalty program */

/* JOIN ALL THE THINGS TOGETHER 
Step 1: INNER JOIN in order to obtain the customer_id, order_date, product_name and price
Step 2: LEFT JOIN in order to obtain the join_date from members table. With this, we can compare the order_date with join_date
Step 3: Use a CASE WHEN in order to determinate if the customer was a member when he made an order
Step 4: Use all the query done before as a CTE in order to be able make the DENSE_RANK making a PARTITION BY members and customer_id.
		This is the way we'll make the ranking taking only in consideration the orders that were done when the customer was member
*/

WITH cte1 AS (SELECT
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
ORDER BY s.customer_id, s.order_date, me.product_name)
SELECT
	*,
	CASE
		WHEN member = 'Y' THEN DENSE_RANK() OVER (PARTITION BY member, customer_id ORDER BY order_date)
		ELSE 'null'
    END ranking    
FROM cte1