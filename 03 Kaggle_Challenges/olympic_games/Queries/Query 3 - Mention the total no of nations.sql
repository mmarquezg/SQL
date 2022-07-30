--All countries
SELECT nr.region FROM olympics_history AS o
JOIN noc_regions AS nr ON nr.noc = o.noc
GROUP BY nr.region;

--Mention the total no of nations who participated in each olympics game?
SELECT 
	o.games, 
	COUNT(DISTINCT nr.region) AS total_country
FROM olympics_history AS o
JOIN noc_regions AS nr ON nr.noc = o.noc
GROUP BY o.games;
