-- 4.What is the most purchased item on the menu and how many times was it purchased by all customers?

/*
SOLUTION USING LIMIT
Step 1: COUNT() total of purchases of each product from sales table, grouping by product_id
Step 2: ORDER BY total_purchases in descending order
Step 3: JOIN sales with menu to get product_name
Step 4: Use LIMIT to show only 1 row (first one)
*/

SELECT
	me.product_name,
    COUNT(s.product_id) AS total_purchases
FROM sales AS s
INNER JOIN menu AS me ON s.product_id = me.product_id
GROUP BY me.product_name
ORDER BY 2 DESC
LIMIT 1;

/*
SOLUTION USING SUBQUERIES AND WINDOWS FUNCTION DENSE_RANK
Step 1: COUNT() total of purchases of each product from sales table, grouping by product_id
Step 2: ORDER BY total_purchases in descending order
Step 3: JOIN sales with menu to get product_name
Step 4: We use the query created before as a subquery where we only want to get the product with the best ranking
*/
SELECT
	*
FROM (SELECT
	me.product_name,
    COUNT(s.product_id) AS total_purchases,
    DENSE_RANK() OVER(ORDER BY COUNT(s.product_id) DESC) AS ranking
FROM sales AS s
INNER JOIN menu AS me ON s.product_id = me.product_id
GROUP BY me.product_name) AS product_sales_ranking
WHERE ranking = 1

