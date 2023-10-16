-- 4. Which year saw the highest and lowest no of countries participating in olympics

WITH games_total_countries AS (
SELECT 
	o.games, 
	COUNT(DISTINCT nr.region) AS total_countries
FROM olympics_history AS o
JOIN noc_regions AS nr ON nr.noc = o.noc
GROUP BY o.games)
SELECT DISTINCT
	CONCAT(FIRST_VALUE(games) OVER(ORDER BY total_countries)
	, ' - '
	, FIRST_VALUE(total_countries) OVER(ORDER BY total_countries)) AS Lowest_Countries,
	CONCAT(FIRST_VALUE(games) OVER(ORDER BY total_countries DESC)
	, ' - '
	, FIRST_VALUE(total_countries) OVER(ORDER BY total_countries DESC)) AS Highest_Countries		   
FROM games_total_countries;
