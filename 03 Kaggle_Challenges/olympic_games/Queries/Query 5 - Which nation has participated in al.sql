--5. Which nation has participated in all of the olympic games
with tot_games AS(
	SELECT COUNT(DISTINCT games) AS total_games
	FROM olympics_history),
	tot_games_per_country AS(
	SELECT 
		nr.region AS country, 
		COUNT(DISTINCT games) AS total_games_country
	FROM olympics_history AS o
	JOIN noc_regions AS nr ON nr.noc = o.noc
	GROUP BY country
	ORDER BY total_games_country DESC
	)
SELECT * FROM tot_games_per_country AS t_g_c
JOIN tot_games AS t_g ON t_g.total_games = t_g_c.total_games_country