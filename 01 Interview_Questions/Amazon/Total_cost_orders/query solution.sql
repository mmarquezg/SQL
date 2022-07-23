---Total Cost Of Orders: 
---Find the total cost of each customer's orders. Output customer's id, first name, and the total order cost. Order records by customer's first name alphabetically.

--Query Solution:

SELECT 
    c.id,
    c.first_name,
    SUM(o.total_order_cost) AS total_cost
FROM customers AS c
JOIN orders AS o ON c.id = o.cust_id
GROUP BY c.id, c.first_name
ORDER BY c.first_name ASC

--Source -> Stratascrath url question : https://platform.stratascratch.com/coding/10183-total-cost-of-orders
