--Details about the crime scene reports
SELECT
	*
FROM crime_scene_report
WHERE date = '20180115'
AND city = 'SQL City'
AND type = 'murder';

| date     | type   | description                                                            | city     |   |
|----------|--------|------------------------------------------------------------------------|----------|---|
| 20180115 | murder | Security footage shows that there were 2 witnesses:                    | SQL City |   |
|          |        | The first witness lives at the last house on "Northwestern Dr"         |          |   |
|          |        | The second witness, named Annabel, lives somewhere on "Franklin   Ave" |          |   |

--Interviews from the two witnesses
/*First Witness*/
SELECT
	p.id
	,p.name
	,i.transcript
FROM person AS p
INNER JOIN interview AS i ON p.id = i.person_id
WHERE address_number IN (
  SELECT --getting the last house on the street
  	max(address_number) 
  FROM person
  WHERE address_street_name = 'Northwestern Dr')

UNION

/*Second Witness*/
SELECT
	p.id
	,p.name
	,i.transcript
FROM person AS p
INNER JOIN interview AS i ON p.id = i.person_id
WHERE p.name LIKE '%Annabel%'
AND address_street_name = 'Franklin Ave';

| id    | name           | transcript                                                                                                                |
|-------|----------------|---------------------------------------------------------------------------------------------------------------------------|
| 14887 | Morty Schapiro | I heard a gunshot and then saw   a man run out.                                                                           |
|       |                | He had a "Get Fit Now   Gym" bag. The membership number on the bag started with "48Z"                                     |
|       |                | Only gold members have those   bags. The man got into a car with a plate that included "H42W".                            |
| 16371 | Annabel Miller | I saw the murder happen, and I   recognized the killer from my gym when I was working out last week on January   the 9th. |

 --Insights from first witness:
 /*Gold member, membership number starting with 48Z and H42W included on the plate number*/
 SELECT
	p.id
	,p.name
	,fnm.id AS membership_id
	,fnm.membership_status
	,dl.plate_number
FROM person AS p
INNER JOIN get_fit_now_member AS fnm ON p.id = fnm.person_id
INNER JOIN drivers_license AS dl ON p.license_id = dl.id
WHERE membership_status = 'gold'
AND fnm.id LIKE '48Z%'
AND plate_number LIKE '%H42W%'

| id    | name          | membership_id | membership_status | plate_number |
|-------|---------------|---------------|-------------------|--------------|
| 67318 | Jeremy Bowers | 48Z55         | gold              | 0H42W2       |

--Insights from second witness
/*Recognized the killer at gym on January the 9th*/
SELECT
	p.id
	,p.name
	,fnm.id AS membership_id
	,fnm.membership_status
	,fnc.check_in_date
FROM person AS p
INNER JOIN get_fit_now_member AS fnm ON p.id = fnm.person_id
INNER JOIN get_fit_now_check_in AS fnc ON fnm.id = fnc.membership_id 
WHERE check_in_date = '20180109'

| id    | name              | membership_id | membership_status | check_in_date |
|-------|-------------------|---------------|-------------------|---------------|
| 15247 | Shondra Ledlow    | X0643         | silver            | 20180109      |
| 28073 | Zackary Cabotage  | UK1F2         | silver            | 20180109      |
| 55662 | Sarita Bartosh    | XTE42         | gold              | 20180109      |
| 10815 | Adriane Pelligra  | 1AE2H         | silver            | 20180109      |
| 83186 | Burton Grippe     | 6LSTG         | gold              | 20180109      |
| 31523 | Blossom Crescenzo | 7MWHJ         | regular           | 20180109      |
| 92736 | Carmen Dimick     | GE5Q8         | gold              | 20180109      |
| 28819 | Joe Germuska      | 48Z7A         | gold              | 20180109      |
| 67318 | Jeremy Bowers     | 48Z55         | gold              | 20180109      |
| 16371 | Annabel Miller    | 90081         | gold              | 20180109      |

--Final Query to get The Killer
WITH first_witness_insights AS (
  SELECT
	  p.id
	  ,p.name
	  ,fnm.id AS membership_id
	  ,fnm.membership_status
	  ,dl.plate_number
  FROM person AS p
  INNER JOIN get_fit_now_member AS fnm ON p.id = fnm.person_id
  INNER JOIN drivers_license AS dl ON p.license_id = dl.id
  WHERE membership_status = 'gold'
  AND fnm.id LIKE '48Z%'
  AND plate_number LIKE '%H42W%'),

second_witness_insights AS (
  SELECT
	  p.id
	  ,p.name
	  ,fnm.id AS membership_id
	  ,fnm.membership_status
	  ,fnc.check_in_date
  FROM person AS p
  INNER JOIN get_fit_now_member AS fnm ON p.id = fnm.person_id
  INNER JOIN get_fit_now_check_in AS fnc ON fnm.id = fnc.membership_id 
  WHERE check_in_date = '20180109')

SELECT
	f.id
	,f.name
FROM first_witness_insights AS f
INNER JOIN second_witness_insights AS s ON f.id = s.id

| id    | name          |
|-------|---------------|
| 67318 | Jeremy Bowers |

--Details about suspect and his transcript... PLOT-TWIST! Who's the real killer?

| person_id | transcript                                                                    |
|-----------|-------------------------------------------------------------------------------|
| 67318     | I was hired by a woman with a lot of money.                                   |
|           | I don't know her name but I know she's around 5'5" (65") or   5'7" (67").     |
|           | She has red hair and she drives a Tesla Model S.                              |
|           | I know that she attended the SQL Symphony Concert 3 times in December   2017. |

WITH list_of_suspects AS (
	SELECT
		p.id
		,p.name
	FROM person AS p
	INNER JOIN drivers_license AS dl ON p.license_id = dl.id
	WHERE dl.height BETWEEN 65 AND 67
	AND dl.gender = 'female'
	AND dl.hair_color = 'red'
	AND dl.car_make = 'Tesla'
	AND dl.car_model = 'Model S'),

	 sql_concert_attendees AS (
	 SELECT
	 	person_id
	   ,COUNT(*) AS total_attendances
	 FROM facebook_event_checkin
	 WHERE event_name = 'SQL Symphony Concert'
	 AND date LIKE '201712%'
	 GROUP BY person_id)

--And the mastermind behind the murder is...
SELECT
	name
FROM list_of_suspects AS ls
INNER JOIN sql_concert_attendees AS sca ON ls.id = sca.person_id
WHERE total_attendances = 3

| name             |
|------------------|
| Miranda Priestly |
