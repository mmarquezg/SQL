SELECT
    g.gender,
    AVG(r.review_score) AS highest_avg_review
FROM
    airbnb_reviews AS r
JOIN
    airbnb_guests AS g ON g.guest_id = r.from_user
GROUP BY gender
ORDER BY highest_avg_review DESC
LIMIT 1;