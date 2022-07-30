--8. Fetch the total no of sports played in each olympic games
SELECT
	games,
	COUNT(DISTINCT sport) AS total_of_sport
FROM olympics_history
GROUP BY games
ORDER BY total_of_sport DESC;