-- 4. Which year saw the highest and lowest no of countries participating in olympics

ith games_total_countries AS (
SELECT 
	o.games, 
	COUNT(DISTINCT nr.region) AS total_countries
FROM olympics_history AS o
JOIN noc_regions AS nr ON nr.noc = o.noc
GROUP BY o.games)
SELECT DISTINCT
	concat(first_value(games) over(order by total_countries)
	, ' - '
	, first_value(total_countries) over(order by total_countries)) as Lowest_Countries,
	concat(first_value(games) over(order by total_countries desc)
	, ' - '
	, first_value(total_countries) over(order by total_countries desc)) as Highest_Countries		   
FROM games_total_countries;