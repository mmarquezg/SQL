--Obtenemos oro, plata y bronce por pais en una final distinta por cada tipo de medalla
SELECT 
	nr.region AS country,
	medal,
	COUNT(1) AS total_medals
FROM olympics_history AS oh
JOIN noc_regions AS nr ON nr.noc = oh.noc
WHERE medal <> 'NA'
GROUP BY country, medal
ORDER BY country, medal;

--Creación de tabla utilizando CROSSTAB
SELECT 	country,
		coalesce(gold, 0) AS gold,
		coalesce(silver, 0) AS silver,
		coalesce(bronze, 0) AS bronze
FROM crosstab('SELECT 
					nr.region AS country,
					medal,
					COUNT(1) AS total_medals
				FROM olympics_history AS oh
				JOIN noc_regions AS nr ON nr.noc = oh.noc
				WHERE medal <> ''NA''
				GROUP BY country, medal
				ORDER BY country, medal',
			 	'values (''Gold''), (''Silver''), (''Bronze'')')
			AS RESULT (country varchar, gold bigint, silver bigint,bronze bigint)
ORDER BY gold DESC