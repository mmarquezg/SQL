---Top 5 medallas de oro
WITH top_5 AS (
	SELECT DISTINCT * FROM(
	SELECT COUNT(o.medal) as gold_medals FROM olympics_history AS o
	GROUP BY o.name, o.medal
	HAVING o.medal = 'Gold'
	ORDER BY gold_medals
	) AS top_five_gold_medals
	ORDER BY gold_medals DESC
	LIMIT 5
) SELECT gold_medals FROM top_5
--Top 5 medallistas de oro de los J.O
WITH gold_medalists AS
	(SELECT 
		o.name, 
		o.team, 
		COUNT(o.medal) as total_gold_medals 
	FROM olympics_history AS o
	GROUP BY o.name, o.team, o.medal
	HAVING o.medal = 'Gold'
	ORDER BY COUNT(o.medal) DESC),
top_5_gold_medalist AS
	(SELECT *, DENSE_RANK() OVER(ORDER BY total_gold_medals DESC) as rnk
	 FROM gold_medalists)
SELECT * FROM top_5_gold_medalist
WHERE rnk <= 5;