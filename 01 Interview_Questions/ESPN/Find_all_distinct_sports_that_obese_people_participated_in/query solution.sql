---Find all distinct sports that obese people participated in
---Find all distinct sports that obese people participated in. A person is considered as obese if his or her body mass index exceeds 30. The body mass index is calculated as weight / (height * height)

--Query Solution:

SELECT DISTINCT 
    sport
FROM olympics_athletes_events
WHERE weight / (height/100 * height/100) > 30


-- Source --> https://platform.stratascratch.com/coding/9945-find-all-distinct-sports-that-obese-people-participated-in?code_type=1
