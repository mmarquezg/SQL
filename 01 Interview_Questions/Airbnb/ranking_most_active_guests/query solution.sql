---Ranking Most Active Guests
---Rank guests based on the number of messages they've exchanged with the hosts. Guests with the same number of messages as other guests should have the same rank. Do not skip rankings if the preceding rankings are identical. Output the rank, guest id, and number of total messages they've sent. Order by the highest number of total messages first.

--Query Solution:

SELECT
    DENSE_RANK() OVER(ORDER BY SUM(n_messages) DESC) AS rank,
    id_guest,
    SUM(n_messages) AS total_guess_messages
FROM airbnb_contacts
GROUP BY id_guest
ORDER BY total_guess_messages DESC


--Source -> Stratascrath url question : https://platform.stratascratch.com/coding/10159-ranking-most-active-guests?code_type=1