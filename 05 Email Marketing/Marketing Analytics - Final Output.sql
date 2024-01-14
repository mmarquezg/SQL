-- PART 1: CATEGORY INSIGHTS
/*Objetives:
1. Identify top 2 categories for each customer based off their past rental history
2. For each customer recommend up to 3 popular unwatched films for each category
3. Generate 1st category insights that includes:
    - How many total films have they watched in their top category?
    - How many more films has the customer watched compared to the average DVD Rental Co customer?
    - How does the customer rank in terms of the top X% compared to all other customers in this film category?
4. Generate 2nd insights that includes:
    - How many total films has the customer watched in this category?
    - What proportion of each customer’s total films watched does this count make?
5. Identify each customer’s favorite actor and film count, then recommend up to 3 more unwatched films starring the same actor
    - Which actor has featured in the customer’s rental history the most?
    - How many films featuring this actor has been watched by the customer?
    - What are the top 3 recommendations featuring this same actor which have not been watched by the customer?*/
	
	
	
/*-------------------------------------------
1. Create a main dataset to use it as rawdata
for category insights
--------------------------------------------*/
DROP TABLE IF EXISTS film_by_cust;
CREATE TEMP TABLE film_by_cust AS (
	SELECT
      r.customer_id
      ,i.film_id
      ,f.title
      ,c.name AS category
      ,r.rental_date
  FROM dvd_rentals.rental AS r
  INNER JOIN dvd_rentals.inventory AS i ON r.inventory_id = i.inventory_id
  INNER JOIN dvd_rentals.film AS f ON i.film_id = f.film_id
  INNER JOIN dvd_rentals.film_category AS fc ON f.film_id = fc.film_id
  INNER JOIN dvd_rentals.category AS c ON fc.category_id = c.category_id);

/*-------------------------------------------
2. Calculate customer rental for each category
--------------------------------------------*/
DROP TABLE IF EXISTS total_rent_by_cat;
CREATE TEMP TABLE total_rent_by_cat AS (
    SELECT
      customer_id
      ,category
      ,COUNT(category) AS total_films_cat
      ,MAX(rental_date) AS latest_rental_date -- to deal with ties
    FROM film_by_cust
    GROUP BY 1,2);
	  
	  
/*-------------------------------------------
3. Calculate total films watched by customer
--------------------------------------------*/
DROP TABLE IF EXISTS total_rent_by_cust;
CREATE TEMP TABLE total_rent_by_cust AS (
    SELECT
      customer_id
      ,SUM(total_films_cat) AS total_films_cust
    FROM total_rent_by_cat
    GROUP BY 1);

/*-------------------------------------------
4. Calculate film watched average by category
--------------------------------------------*/
DROP TABLE IF EXISTS rent_avg_by_cat;
CREATE TEMP TABLE rent_avg_by_cat AS (
    SELECT
      category
      ,COUNT(DISTINCT customer_id) AS total_customers
      ,SUM(total_films_cat) AS total_films_cat
      ,FLOOR(AVG(total_films_cat)) AS avg_cat_rental_counts
    FROM total_rent_by_cat
    GROUP BY 1);

/*-------------------------------------------
5. Identifying top 2 categories for each customer
--------------------------------------------*/
DROP TABLE IF EXISTS top_categories;
CREATE TEMP TABLE top_categories AS (
WITH rank_cat_by_cust AS (
	SELECT
      customer_id
      ,category
      ,total_films_cat
      ,latest_rental_date
      ,DENSE_RANK() OVER(PARTITION BY customer_id ORDER BY total_films_cat DESC, latest_rental_date DESC, category) AS rank -- sorting by the latest rental date to deal with ties
      ,CAST(CEILING(100 * PERCENT_RANK() OVER(PARTITION BY category ORDER BY total_films_cat DESC)) AS integer) AS percentile
    FROM total_rent_by_cat)
    
	SELECT
      customer_id
      ,category
      ,total_films_cat
      ,rank
      ,CASE WHEN percentile = 0 THEN 1 ELSE percentile END AS percentile
    FROM rank_cat_by_cust
    WHERE rank <= 2
    ORDER BY customer_id, rank);
	  
/*-------------------------------------------
6. Generate top 1 category insight
--------------------------------------------*/
DROP TABLE IF EXISTS first_cat_insights;
CREATE TEMP TABLE first_cat_insights AS (
SELECT
  tc.customer_id
  ,tc.category
  ,tc.total_films_cat AS rental_count
  ,CAST(tc.total_films_cat - rac.avg_cat_rental_counts AS integer) AS avg_comparison
  ,tc.percentile
FROM top_categories AS tc
INNER JOIN rent_avg_by_cat AS rac ON tc.category = rac.category
INNER JOIN total_rent_by_cust AS tcc ON tc.customer_id = tcc.customer_id
WHERE rank = 1
ORDER BY tc.customer_id, tc.rank);


/*-------------------------------------------
7. Generate top 2 category insight
--------------------------------------------*/
DROP TABLE IF EXISTS second_cat_insights;
CREATE TEMP TABLE second_cat_insights AS (
SELECT
  tc.customer_id
  ,tc.category
  ,tc.total_films_cat AS rental_count
  ,CAST(CEILING(100 * tc.total_films_cat / tcc.total_films_cust) AS integer) AS total_percentage
FROM top_categories AS tc
INNER JOIN rent_avg_by_cat AS rac ON tc.category = rac.category
INNER JOIN total_rent_by_cust AS tcc ON tc.customer_id = tcc.customer_id
WHERE rank = 2
ORDER BY tc.customer_id, tc.rank);

--Part 1 OUTPUT:
| customer_id | category  | total_films_cat | rank | percentile |
|-------------|-----------|-----------------|------|------------|
| 1           | Classics  | 6               | 1    | 1          |
| 1           | Comedy    | 5               | 2    | 1          |
| 2           | Sports    | 5               | 1    | 3          |
| 2           | Classics  | 4               | 2    | 2          |
| 3           | Action    | 4               | 1    | 5          |
| 3           | Sci-Fi    | 3               | 2    | 15         |
| 4           | Horror    | 3               | 1    | 8          |
| 4           | Drama     | 2               | 2    | 32         |
| 5           | Classics  | 7               | 1    | 1          |
| 5           | Animation | 6               | 2    | 2          |

/*-------------------------------------------
**********************************************
***********CATEGORY RECOMMENDATIONS***********
**********************************************
--------------------------------------------*/

/*-------------------------------------------
1. Calculate total rental count for each film
with their category to rank the films by popularity
--------------------------------------------*/

DROP TABLE IF EXISTS film_count;
CREATE TEMP TABLE film_count AS (
  SELECT DISTINCT
    i.film_id
    ,f.title
    ,f.category
    ,COUNT(*) OVER(PARTITION BY film_id) AS rental_count
  FROM dvd_rentals.rental AS r
  INNER JOIN dvd_rentals.inventory AS i ON r.inventory_id = i.inventory_id
  INNER JOIN dvd_rentals.film_list AS f ON i.film_id = f.fid
  ORDER BY rental_count DESC);
  
/*-------------------------------------------
2. Create a table with the films already watched 
by each customer and exclude them from the recommedation list
--------------------------------------------*/

DROP TABLE IF EXISTS film_exclusions;
CREATE TEMP TABLE film_exclusions AS (
  SELECT DISTINCT
    customer_id
    ,film_id
    ,concat(customer_id,'-',film_id) AS exclusion_id
  FROM film_by_cust);
  
/*-------------------------------------------
3. Generate film recommendations according to 
customers' top categories
--------------------------------------------*/
DROP TABLE IF EXISTS category_recommendations;
CREATE TEMP TABLE category_recommendations AS (  
WITH reco_cte AS (
  SELECT
    t2c.customer_id
    ,t2c.category
    ,t2c.total_films_cat
    ,t2c.rank AS category_rank
    ,t2c.percentile
    ,fc.film_id
    ,fc.title
    ,fc.rental_count
    ,DENSE_RANK() OVER(PARTITION BY t2c.customer_id, t2c.rank ORDER BY rental_count DESC, fc.title) AS reco_rank
  FROM top_categories AS t2c
  INNER JOIN film_count AS fc ON t2c.category = fc.category
--to get only those films that ARE NOT in our film exclusion table
  WHERE NOT EXISTS (
    SELECT *
    FROM film_exclusions AS fe
    WHERE t2c.customer_id = fe.customer_id 
    AND fc.film_id = fe.film_id)
--Using LEFT JOIN as similar approach as WHERE NOT EXISTS (ANTI JOIN)
	/*LEFT JOIN film_exclusions AS fe ON concat(t2c.customer_id,'-',fc.film_id) = fe.exclusion_id WHERE fe.exclusion_id IS NULL -- */
  )
	SELECT
	  *
	FROM reco_cte
	WHERE reco_rank <= 3
	ORDER BY customer_id, category_rank, reco_rank);
	
--Part 1 OUTPUT:	
| customer_id | category | total_films_cat | category_rank | percentile | film_id | title               | rental_count | reco_rank |
|-------------|----------|-----------------|---------------|------------|---------|---------------------|--------------|-----------|
| 1           | Classics | 6               | 1             | 1          | 891     | TIMBERLAND SKY      | 31           | 1         |
| 1           | Classics | 6               | 1             | 1          | 358     | GILMORE BOILED      | 28           | 2         |
| 1           | Classics | 6               | 1             | 1          | 951     | VOYAGE LEGALLY      | 28           | 3         |
| 1           | Comedy   | 5               | 2             | 1          | 1000    | ZORRO ARK           | 31           | 1         |
| 1           | Comedy   | 5               | 2             | 1          | 127     | CAT CONEHEADS       | 30           | 2         |
| 1           | Comedy   | 5               | 2             | 1          | 638     | OPERATION OPERATION | 27           | 3         |
	
-- PART 2: ACTOR INSIGHTS

/*-------------------------------------------
1. Create a main dataset to use it as rawdata
for actor insights
--------------------------------------------*/

DROP TABLE IF EXISTS actors_rawdata;
CREATE TEMP TABLE actors_rawdata AS (
	SELECT
    r.customer_id
    ,r.rental_id
    ,r.rental_date
    ,i.film_id
    ,f.title
    ,a.actor_id
    ,a.first_name
    ,a.last_name
  FROM dvd_rentals.rental AS r
  INNER JOIN dvd_rentals.inventory AS i ON r.inventory_id = i.inventory_id
  INNER JOIN dvd_rentals.film AS f ON i.film_id = f.film_id
  INNER JOIN dvd_rentals.film_actor AS fa ON f.film_id = fa.film_id
  INNER JOIN dvd_rentals.actor AS a ON fa.actor_id = a.actor_id);

/*-------------------------------------------
2. Calculate top actor counts
--------------------------------------------*/
DROP TABLE IF EXISTS top_actor_by_cust;
CREATE TEMP TABLE top_actor_by_cust AS (
WITH actor_cte AS (
  SELECT
    customer_id
    ,actor_id
    ,first_name
    ,last_name
    ,COUNT(actor_id) AS total_films_actor
    ,MAX(rental_date) AS latest_rental_date
  FROM actors_rawdata
  GROUP BY 1,2,3,4),
rank_actor_count AS (
  SELECT
    customer_id
    ,actor_id
    ,first_name
    ,last_name
    ,total_films_actor
    ,DENSE_RANK() OVER(PARTITION BY customer_id ORDER BY total_films_actor DESC, latest_rental_date, first_name, last_name DESC) AS rank_actor
  FROM actor_cte)

SELECT
  customer_id
  ,actor_id
  ,first_name
  ,last_name
  ,total_films_actor
FROM rank_actor_count
WHERE rank_actor = 1);


/*-------------------------------------------
**********************************************
*********** ACTOR RECOMMENDATIONS ************
**************************************customer********
--------------------------------------------*/

/*-------------------------------------------
1. Calculate total rental count for each film
by actor to rank the films by popularity
--------------------------------------------*/

DROP TABLE IF EXISTS actor_film_count;
CREATE TEMP TABLE actor_film_count AS (
WITH film_count AS (
  SELECT
    film_id
    ,title
    ,COUNT(DISTINCT rental_id) AS rental_count
  FROM actors_rawdata
  GROUP BY 1,2
)

SELECT DISTINCT
  ar.film_id
  ,ar.title
  ,ar.actor_id
  ,fc.rental_count
FROM actors_rawdata AS ar
LEFT JOIN film_count AS fc ON ar.film_id = fc.film_id);

/*-------------------------------------------
2. Create a table with the films already watched 
by each customer and exclude them from the recommedation list
--------------------------------------------*/

DROP TABLE IF EXISTS actor_film_exclusions;
CREATE TEMP TABLE actor_film_exclusions AS (
  (SELECT DISTINCT
    customer_id
    ,film_id
    ,concat(customer_id,'-',film_id) AS exclusion_id
  FROM film_by_cust)
  
  UNION -- with catergory recommendations table to avoid recommend twice the same film!
 
  (SELECT DISTINCT
    customer_id
    ,film_id
    ,concat(customer_id,'-',film_id) AS exclusion_id
  FROM category_recommendations
    )
);

/*-------------------------------------------
3. Generate film recommendations according to 
customers' top actor
--------------------------------------------*/
DROP TABLE IF EXISTS actor_recommendations;
CREATE TEMP TABLE actor_recommendations AS (
WITH actor_reco_cte AS (
  SELECT
    tac.customer_id
    ,tac.actor_id
    ,tac.first_name
    ,tac.last_name
    ,tac.total_films_actor
    ,afc.title
    ,afc.film_id
    ,DENSE_RANK() OVER(PARTITION BY tac.customer_id ORDER BY afc.rental_count DESC, afc.title DESC) AS reco_rank
  FROM top_actor_by_cust AS tac
  LEFT JOIN actor_film_count AS afc ON tac.actor_id = afc.actor_id
  WHERE NOT EXISTS (
  SELECT *
  FROM actor_film_exclusions AS afe
  WHERE tac.customer_id = afe.customer_id AND afc.film_id = afe.film_id)
  )
SELECT
  *
FROM actor_reco_cte
WHERE reco_rank <= 3);

--Part 2 OUTPUT:
| customer_id | actor_id | first_name | last_name | total_films_actor | title             | film_id | reco_rank | reco_rank |
|-------------|----------|------------|-----------|-------------------|-------------------|---------|-----------|-----------|
| 1           | 37       | VAL        | BOLGER    | 6                 | PRIMARY GLASS     | 697     | 1         | 1         |
| 1           | 37       | VAL        | BOLGER    | 6                 | METROPOLIS COMA   | 572     | 2         | 2         |
| 1           | 37       | VAL        | BOLGER    | 6                 | ALASKA PHANTOM    | 12      | 3         | 3         |
| 2           | 107      | GINA       | DEGENERES | 5                 | WIFE TURN         | 973     | 1         | 1         |
| 2           | 107      | GINA       | DEGENERES | 5                 | GOODFELLAS SALUTE | 369     | 2         | 2         |
| 2           | 107      | GINA       | DEGENERES | 5                 | DOGMA FAMILY      | 239     | 3         | 3         |

--PART 3: PUTTING ALL TOGETHER
/*Now that we already have all the insights for each customer, 
we need to make a extra step before making the last transformation to make life easier to our email marketing team. 
The idea is to have all the data for each customer in one single row, like a table where they can filter by customer_id and get all the data needed
*/

/*-------------------------------------------
1. Generate insights rawdata for each customer
--------------------------------------------*/

DROP TABLE IF EXISTS insights_rawdata;
CREATE TEMP TABLE insights_rawdata AS (
  WITH cat_insights AS (
    SELECT
      fci.customer_id
      ,fci.category AS cat_1
      ,fci.rental_count AS cat_1_rental_count
      ,fci.avg_comparison AS cat_1_avg_comparison
      ,fci.percentile AS cat_1_percentile
      ,sci.category AS cat_2
      ,sci.rental_count AS cat_2_rental_count
      ,sci.total_percentage AS cat_2_total_percentage
    FROM first_cat_insights AS fci
    LEFT JOIN second_cat_insights AS sci ON fci.customer_id = sci.customer_id),
  cat_reco AS (
    SELECT
      customer_id
      --using INITCAP to transform into Title Case
      ,INITCAP(MAX(CASE WHEN category_rank = 1 AND reco_rank = 1 THEN title END)) AS cat_1_reco_1
      ,INITCAP(MAX(CASE WHEN category_rank = 1 AND reco_rank = 2 THEN title END)) AS cat_1_reco_2
      ,INITCAP(MAX(CASE WHEN category_rank = 1 AND reco_rank = 3 THEN title END)) AS cat_1_reco_3
      ,INITCAP(MAX(CASE WHEN category_rank = 2 AND reco_rank = 1 THEN title END)) AS cat_2_reco_1
      ,INITCAP(MAX(CASE WHEN category_rank = 2 AND reco_rank = 2 THEN title END)) AS cat_2_reco_2
      ,INITCAP(MAX(CASE WHEN category_rank = 2 AND reco_rank = 3 THEN title END)) AS cat_2_reco_3
    FROM category_recommendations
    GROUP BY customer_id),
  actor_reco AS (
    SELECT
      customer_id
      ,total_films_actor AS actor_rental_count
      ,INITCAP(first_name) AS actor_first_name
      ,INITCAP(last_name) AS actor_last_name
      ,INITCAP(MAX(CASE WHEN reco_rank = 1 THEN title END)) AS actor_reco_1
      ,INITCAP(MAX(CASE WHEN reco_rank = 2 THEN title END)) AS actor_reco_2
      ,INITCAP(MAX(CASE WHEN reco_rank = 3 THEN title END)) AS actor_reco_3
    FROM actor_recommendations
    GROUP BY 1,2,3,4
  )
  
  SELECT
    t1.customer_id
    ,t1.cat_1
    ,t1.cat_1_rental_count
    ,t1.cat_1_avg_comparison
    ,t1.cat_1_percentile
    ,t1.cat_2
    ,t1.cat_2_rental_count
    ,t1.cat_2_total_percentage
    ,t2.cat_1_reco_1
    ,t2.cat_1_reco_2
    ,t2.cat_1_reco_3
    ,t2.cat_2_reco_1
    ,t2.cat_2_reco_2
    ,t2.cat_2_reco_3
    ,t3.actor_first_name
    ,t3.actor_last_name
    ,t3.actor_rental_count
    ,t3.actor_reco_1
    ,t3.actor_reco_2
    ,t3.actor_reco_3
  FROM cat_insights AS t1
  INNER JOIN cat_reco AS t2 ON t1.customer_id = t2.customer_id
  INNER JOIN actor_reco AS t3 ON t1.customer_id = t3.customer_id);

/*-------------------------------------------
*************  FINAL OUTPUT  ****************
--------------------------------------------*/

SELECT
  customer_id
  ,cat_1
  ,cat_1_reco_1
  ,cat_1_reco_2
  ,cat_1_reco_3
  ,cat_2
  ,cat_2_reco_1
  ,cat_2_reco_2
  ,cat_2_reco_3
  ,CONCAT(actor_first_name, ' ', actor_last_name) AS actor
  ,actor_reco_1
  ,actor_reco_2
  ,actor_reco_3
  ,CONCAT('You’ve watched ',cat_1_rental_count, ' ', cat_1, ' films, that''s ', cat_1_avg_comparison, ' more than the Netflix average and puts you in the top ', cat_1_percentile, '% of ', cat_1, ' gurus') AS insight_cat_1
  ,CONCAT('You’ve watched ', cat_2_rental_count,' ', cat_2, ' films making up ', cat_2_total_percentage, ' % of your entire viewing history!') AS insight_cat_2
  ,CONCAT('You’ve watched ', actor_rental_count, ' ', 'films featuring ', actor_first_name, ' ', actor_last_name,'! Here are some other films ', actor_first_name, ' stars in that might interest you!') AS insight_actor
FROM insights_rawdata

| customer_id | cat_1    | cat_2     | actor_reco_3          | insight_cat_1                                                                                                        | insight_cat_2                                                                   | insights_actor                                                                                                    |
|-------------|----------|-----------|-----------------------|----------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------|
| 1           | Classics | Comedy    | Alaska Phantom        | You’ve watched 6 Classics films, that's 4 more than the Netflix average and puts you in the top 1% of Classics gurus | You’ve watched 5 Comedy films making up 16 % of your entire viewing history!    | You’ve watched 6 films featuring Val Bolger! Here are some other films Val stars in that might interest you!      |
| 2           | Sports   | Classics  | Dogma Family          | You’ve watched 5 Sports films, that's 3 more than the Netflix average and puts you in the top 3% of Sports gurus     | You’ve watched 4 Classics films making up 15 % of your entire viewing history!  | You’ve watched 5 films featuring Gina Degeneres! Here are some other films Gina stars in that might interest you! |
| 3           | Action   | Sci-Fi    | Invasion Cyclone      | You’ve watched 4 Action films, that's 2 more than the Netflix average and puts you in the top 5% of Action gurus     | You’ve watched 3 Sci-Fi films making up 12 % of your entire viewing history!    | You’ve watched 4 films featuring Jayne Nolte! Here are some other films Jayne stars in that might interest you!   |
| 4           | Horror   | Drama     | Forrester Comancheros | You’ve watched 3 Horror films, that's 2 more than the Netflix average and puts you in the top 8% of Horror gurus     | You’ve watched 2 Drama films making up 10 % of your entire viewing history!     | You’ve watched 4 films featuring Kirk Jovovich! Here are some other films Kirk stars in that might interest you!  |
| 5           | Classics | Animation | Murder Antitrust      | You’ve watched 7 Classics films, that's 5 more than the Netflix average and puts you in the top 1% of Classics gurus | You’ve watched 6 Animation films making up 16 % of your entire viewing history! | You’ve watched 4 films featuring Susan Davis! Here are some other films Susan stars in that might interest you!   |