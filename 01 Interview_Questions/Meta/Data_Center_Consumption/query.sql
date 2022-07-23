--Query to UNION ALL the tables
SELECT
    *
FROM
    (SELECT
            date,
            consumption
        FROM fb_eu_energy AS eu
        UNION ALL SELECT
            date,
            consumption
        FROM
            fb_asia_energy AS a
    UNION ALL SELECT
            date,
            consumption
        FROM
            fb_na_energy AS na) AS total_consumption_table
--Query to obtain the highest consumption
SELECT
    SUM(consumption) AS total_consumption
FROM
    (SELECT
            date,
            consumption
        FROM fb_eu_energy AS eu
        UNION ALL SELECT
            date,
            consumption
        FROM
            fb_asia_energy AS a
    UNION ALL SELECT
            date,
            consumption
        FROM
            fb_na_energy AS na) AS total_consumption_table
GROUP BY date
ORDER BY total_consumption DESC
LIMIT 1;
--Query to obtain the dates with the highest consumption
SELECT
    date,
    SUM(consumption)
FROM
    (SELECT
            date,
            consumption
        FROM fb_eu_energy AS eu
        UNION ALL SELECT
            date,
            consumption
        FROM
            fb_asia_energy AS a
    UNION ALL SELECT
            date,
            consumption
        FROM
            fb_na_energy AS na) AS total_consumption_table
GROUP BY date
HAVING SUM(consumption) = (SELECT
    SUM(consumption) AS total_consumption
FROM
    (SELECT
            date,
            consumption
        FROM fb_eu_energy AS eu
        UNION ALL SELECT
            date,
            consumption
        FROM
            fb_asia_energy AS a
    UNION ALL SELECT
            date,
            consumption
        FROM
            fb_na_energy AS na) AS total_consumption_table
GROUP BY date
ORDER BY total_consumption DESC
LIMIT 1); 