-- 1.What is the total amount each customer spent at the restaurant?
/*
Step 1: JOIN sales and menu table SELECT customer_id and price each customer has spent each day they have went to the rest
Step 2: Use AGG function SUM to get the total amount each customer has spent at the rest
Step 3: GROUP BY customer_id to get the final result
*/

SELECT
	s.customer_id,
    SUM(me.price) AS total_amount_spent
FROM sales AS s
INNER JOIN menu AS me ON s.product_id = me.product_id
GROUP BY s.customer_id
ORDER BY 1;

