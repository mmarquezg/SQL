-- 6. Which item was purchased first by the customer after they became a member?

/*
Step 1: JOIN sales with members to find the customers that became as a member
Step 2: WHERE condition indicating the orders made after customers became a member
Step 3: Using MIN() to get the minimum date of the list for each member being this the next day they made an order
*/

SELECT
	s.customer_id,
    me.product_name,
    MIN(order_date) AS next_order_after_membership
FROM sales AS s
INNER JOIN members AS mm ON s.customer_id = mm.customer_id
INNER JOIN menu AS me ON s.product_id = me.product_id
WHERE order_date >= join_date
GROUP BY s.customer_id;