---Count the number of user events performed by MacBookPro users: 
---Count the number of user events performed by MacBookPro users. Output the result along with the event name. Sort the result based on the event count in the descending order.

--Query Solution:

SELECT
    event_name,
    COUNT(device) AS total_MacBookPro_events
FROM
    playbook_events
WHERE device = 'macbook pro'
GROUP BY event_name
ORDER BY total_MacBookPro_events DESC


--Source -> Stratascrath url question : https://platform.stratascratch.com/coding/9653-count-the-number-of-user-events-performed-by-macbookpro-users?code_type=1
