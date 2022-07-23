---Lowest Priced Orders
---Find the lowest order cost of each customer. Output the customer id along with the first name and the lowest order price.

--Query Solution:

--JOIN customers table with orders to have the total order cost in one table
--MIN Aggregate function to find the lowest order cost for each customer
--GROUP BY id and first_name
SELECT
    c.id,
    c.first_name,
    MIN(o.total_order_cost) AS min_order_cost
FROM customers AS c
INNER JOIN orders AS o ON o.cust_id = c.id
GROUP BY c.id, c.first_name

-- Source --> https://platform.stratascratch.com/coding/9912-lowest-priced-orders?code_type=1
