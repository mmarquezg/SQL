---Active Users Per Platform
---For each platform (e.g. Windows, iPhone, iPad etc.), calculate the number of users. Consider unique users and not individual sessions. Output the name of the platform with the corresponding number of users.

--Query Solution:

SELECT
    *
FROM(
    SELECT 
        platform,
        user_id,
        COUNT(user_id) AS total_sessions
    FROM user_sessions
    GROUP BY platform, user_id
    ORDER BY user_id) AS user_sessions_2
WHERE total_sessions >= 2


--Source -> Stratascrath url question : https://platform.stratascratch.com/coding/2072-active-users-per-platform?code_type=1