--Highest Cost Orders
--Find the customer with the highest daily total order cost between 2019-02-01 to 2019-05-01. If customer had more than one order on a certain day, sum the order costs on daily basis. Output their first name, total cost of their items, and the date.

SELECT
    c.first_name,
    SUM(o.total_order_cost),
    o.order_date
FROM
    customers AS c
JOIN orders AS o ON o.cust_id = c.id
WHERE order_date BETWEEN '2019-02-01' AND '2019-05-01'
GROUP BY first_name, order_date
ORDER BY SUM(o.total_order_cost) DESC
LIMIT 1