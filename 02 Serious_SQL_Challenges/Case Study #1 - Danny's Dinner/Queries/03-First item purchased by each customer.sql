-- 3.What was the first item from the menu purchased by each customer?
/*
Step 1: Identify the first purchase day for each customer with MIN()
Step 2: Check if some customer has purchased different items at the same day
Step 3:	Using a Common Table Expression (CTE) to have the customer_id and the day they have done their first purchase
Step 4: JOIN sales table with menu table to get the product_name and after with the CTE "date_first_item_purchased" matching the order_date
Step 5: GROUP BY customer_id and product_name
*/

WITH date_first_item_purchased AS(
	SELECT
		customer_id,
		MIN(order_date) AS order_date
	FROM sales
	GROUP BY customer_id) -- Getting first purchase date
SELECT
	s.customer_id,
    s.order_date AS first_order_date,
    me.product_name AS first_product_purchased
FROM sales AS s
INNER JOIN menu AS me ON s.product_id = me.product_id
INNER JOIN date_first_item_purchased AS d ON s.order_date = d.order_date
GROUP BY 1, 3;