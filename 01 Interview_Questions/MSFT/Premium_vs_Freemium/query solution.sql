---Premium vs Freemium
---Find the total number of downloads for paying and non-paying users by date. Include only records where non-paying customers have more downloads than paying customers. The output should be sorted by earliest date first and contain 3 columns date, non-paying downloads, paying downloads.

--Query Solution:

SELECT
    *
FROM(
SELECT
    date,
    SUM(CASE WHEN paying_customer = 'no' THEN downloads END) AS non_paying_customer,
    SUM(CASE WHEN paying_customer = 'yes' THEN downloads END) AS paying_customer
FROM ms_user_dimension AS mud
LEFT JOIN ms_acc_dimension AS mad ON mud.acc_id = mad.acc_id
LEFT JOIN ms_download_facts AS mdf ON mud.user_id = mdf.user_id
GROUP BY date
ORDER BY date DESC) AS t1
WHERE paying_customer < non_paying_customer


--Source -> Stratascrath url question : https://platform.stratascratch.com/coding/10300-premium-vs-freemium?code_type=1