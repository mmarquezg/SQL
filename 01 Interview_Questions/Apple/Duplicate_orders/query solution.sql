---Duplicate Orders: 
---FFind customers who appear in the orders table more than three times.

--Query Solution:

WITH orders_table AS 
    (SELECT  
        cust_id,
        COUNT(cust_id) AS total_count
    FROM orders
    GROUP BY cust_id),
duplicate_orders AS
    (SELECT
        *
    FROM orders_table)
SELECT * FROM duplicate_orders
WHERE total_count > 3


--Source -> Stratascrath url question : https://platform.stratascratch.com/coding/9893-duplicate-orders?code_type=1
