--Customer Revenue In March
--Calculate the total revenue from each customer in March 2019. Include only customers who were active in March 2019. 

SELECT
    cust_id,
    SUM(total_order_cost) AS total_revenue
FROM orders
WHERE order_date BETWEEN '2019-03-01' AND '2019-03-31'
GROUP BY cust_id
ORDER BY total_revenue DESC;
