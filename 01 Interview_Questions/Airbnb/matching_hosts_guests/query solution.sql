---Find matching hosts and guests in a way that they are both of the same gender and nationality
---Find matching hosts and guests pairs in a way that they are both of the same gender and nationality. Output the host id and the guest id of matched pair.

--Query Solution:

SELECT
    h.host_id,
    g.guest_id
FROM airbnb_hosts AS h
INNER JOIN airbnb_guests AS g ON h.gender = g.gender
WHERE h.nationality = g.nationality
GROUP BY host_id, guest_id
ORDER BY host_id


-- Source --> https://platform.stratascratch.com/coding/10078-find-matching-hosts-and-guests-in-a-way-that-they-are-both-of-the-same-gender-and-nationality?code_type=1