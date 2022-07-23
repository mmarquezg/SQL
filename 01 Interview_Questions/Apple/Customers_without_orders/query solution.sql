---Customers Without Orders 
---Find customers who have never made an order. Output the first name of the customer.

--Query Solution:

SELECT
    c.first_name
FROM customers AS c
LEFT JOIN orders AS o ON c.id = o.cust_id
WHERE o.cust_id IS NULL
GROUP BY first_name


--Source -> Stratascrath url question : https://platform.stratascratch.com/coding/9896-customers-without-orders?code_type=1