-- 8. What is the total items and amount spent for each member before they became a member?

/*
Step 1: Identify the purchases done by the members with the total price and total items purchased
Step 2: WHERE condition order_date before join_date
Step 3: GROUP BY customer_id and product_name
*/

SELECT
	s.customer_id,
    COUNT(me.product_name) AS total_products_purchased,
    SUM(me.price) AS total_amount_spent
FROM sales AS s
INNER JOIN members AS mm ON s.customer_id = mm.customer_id
INNER JOIN menu AS me ON s.product_id = me.product_id
WHERE s.order_date < mm.join_date
GROUP BY s.customer_id;