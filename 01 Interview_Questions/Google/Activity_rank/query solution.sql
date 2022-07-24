---Activity Rank
---Find the email activity rank for each user. Email activity rank is defined by the total number of emails sent. The user with the highest number of emails sent will have a rank of 1, and so on. Output the user, total emails, and their activity rank. Order records by the total emails in descending order. Sort users with the same number of emails in alphabetical order. In your rankings, return a unique value (i.e., a unique rank) even if multiple users have the same number of emails.

--Query Solution:

SELECT
    from_user AS user,
    COUNT(from_user) AS total_emails_sent,
    DENSE_RANK() OVER(ORDER BY COUNT(from_user) DESC) AS activity_rank
FROM google_gmail_emails
GROUP BY from_user
ORDER BY total_emails_sent DESC, from_user ASC;

-- Source --> https://platform.stratascratch.com/coding/10351-activity-rank?code_type=1
