--List down all Olympics games held so far.
SELECT
	o.year,
	o.season,
	o.city
FROM olympics_history AS o
GROUP BY o.year, o.season, o.city
ORDER BY year