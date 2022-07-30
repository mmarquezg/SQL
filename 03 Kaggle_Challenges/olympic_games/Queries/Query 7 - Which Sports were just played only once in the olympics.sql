--7. Which Sports were just played only once in the olympics.
WITH t1 AS (
	SELECT DISTINCT 
		o.sport, 
		o.games 
	FROM olympics_history AS o
	GROUP BY o.sport, o.games
	ORDER BY games),
	t2 AS (
	SELECT
		sport,
		COUNT(games) as total_presences
	FROM t1
	GROUP BY sport
	ORDER BY total_presences
	)
SELECT *
FROM t2
WHERE total_presences = 1