SELECT
    cust.first_name,
    cust.last_name,
    cust.city,
    ord.order_details
FROM
    customers AS cust
LEFT JOIN
    orders AS ord ON ord.cust_id = cust.id
 ORDER BY first_name, order_details ASC;  