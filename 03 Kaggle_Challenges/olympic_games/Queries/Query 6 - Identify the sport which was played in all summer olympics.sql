--Total de juegos olímpicos de verano Q1
SELECT COUNT(DISTINCT games) FROM olympics_history
WHERE season = 'Summer';


--Total de participaciones en los juegos olímpicos de verano por deporte Q2
SELECT sport, COUNT(games) AS total_games
FROM(
select distinct o.sport, o.games from olympics_history AS o
GROUP BY o.sport, o.games, season
HAVING season = 'Summer'
ORDER BY games
) AS total_games_per_sport
GROUP BY sport
ORDER BY total_games DESC;

--Identificar cual ha sido el deporte más jugado en los juegos olímpicos de verano
SELECT
	sport,
	total_games
FROM
(
SELECT sport, COUNT(games) AS total_games
FROM(
SELECT DISTINCT o.sport, o.games FROM olympics_history AS o
GROUP BY o.sport, o.games, season
HAVING season = 'Summer'
ORDER BY games
) AS total_games_per_sport
GROUP BY sport
ORDER BY total_games DESC
) total_games
GROUP BY sport, total_games
HAVING total_games = (
SELECT COUNT(DISTINCT games) FROM olympics_history
WHERE season = 'Summer'
);