SELECT
    city,
    property_type,
    AVG(bathrooms) AS bath_avg,
    AVG(bedrooms) AS bed_avg
FROM airbnb_search_details
GROUP BY city, property_type
ORDER BY city;