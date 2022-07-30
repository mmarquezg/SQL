
--12. Top 5 athletes who have won the most medals (gold/silver/bronze).
WITH cte1 AS (
		SELECT 
			o.name, 
			o.team, 
			COUNT(o.medal) as total_medals 
		FROM olympics_history AS o
		WHERE o.medal IN ('Gold', 'Silver', 'Bronze')
		GROUP BY o.name, o.team
		ORDER BY total_medals DESC),
	cte2 AS(
		SELECT
			*,
			DENSE_RANK() OVER(ORDER BY total_medals DESC) AS rnk
		FROM cte1)
	SELECT name, team, total_medals
	FROM cte2
	WHERE rnk <= 5;