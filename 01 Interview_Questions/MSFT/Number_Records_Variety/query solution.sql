---Number Of Records By Variety: 
---Find the total number of records that belong to each variety in the dataset. Output the variety along with the corresponding number of records. Order records by the variety in ascending order.

--Query Solution:

SELECT 
    variety,
    COUNT(variety) AS total_count 
FROM iris
GROUP BY variety;


--Source -> Stratascrath url question : https://platform.stratascratch.com/coding/10168-number-of-records-by-variety
