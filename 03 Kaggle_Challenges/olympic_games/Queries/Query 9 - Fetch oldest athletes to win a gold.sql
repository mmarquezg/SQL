--9. Fetch oldest athletes to win a gold medal
SELECT DISTINCT
	name,
	sex,
	age,
	team,
	games,
	city,
	sport,
	event,
	medal
FROM olympics_history
WHERE medal = 'Gold' and age = (
SELECT MAX(age) FROM olympics_history
WHERE age <> 'NA' and medal = 'Gold');

WITH max_age AS(
	SELECT MAX(age) AS age FROM olympics_history
	WHERE age <> 'NA' and medal = 'Gold'	
	),
	gold_medalist AS(
	SELECT DISTINCT
		name,
		sex,
		age,
		team,
		games,
		city,
		sport,
		event,
		medal
	FROM olympics_history
	WHERE medal = 'Gold'
	)
SELECT *
FROM gold_medalist
JOIN max_age ON max_age.age = gold_medalist.age;