--13. Fetch the top 5 most successful countries in olympics. Success is defined by no of medals won
SELECT
	nr.region AS country,
	COUNT(o.medal) AS total_medals,
	DENSE_RANK() OVER(ORDER BY COUNT(o.medal) DESC) AS rnk
FROM olympics_history AS o
JOIN noc_regions AS nr ON nr.noc = o.noc
WHERE o.medal <> 'NA'
GROUP BY country
LIMIT 5;