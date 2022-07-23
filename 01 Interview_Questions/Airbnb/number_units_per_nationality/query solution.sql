---Number Of Units Per Nationality
---Find the number of apartments per nationality that are owned by people under 30 years old. Output the nationality along with the number of apartments. Sort records by the apartments count in descending order.

--Query Solution:

SELECT
    h.nationality,
    COUNT(DISTINCT u.unit_id) AS total_apartments
FROM airbnb_hosts AS h
INNER JOIN airbnb_units AS u ON h.host_id = u.host_id
WHERE h.age < 30 AND u.unit_type = 'Apartment'
GROUP BY h.nationality, h.age, u.unit_type


-- Source --> https://platform.stratascratch.com/coding/10156-number-of-units-per-nationality?code_type=1