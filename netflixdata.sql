-- View datasetdemo

SELECT *
FROM netflix1 

-- The show ID column is the unique id column for the dataset. Therefore we need to check for duplicates. 

SELECT show_id, 
count (*)
from netflix1
GROUP by show_id
ORDER by show_id DESC
-- no duplicate found.

--check null values across column. 

SELECT COUNT(*) FILTER (WHERE show_id IS NULL) AS showid_nulls,
       COUNT(*) FILTER (WHERE type IS NULL) AS type_nulls,
       COUNT(*) FILTER (WHERE title IS NULL) AS title_nulls,
       COUNT(*) FILTER (WHERE director IS NULL) AS director_nulls,
       COUNT(*) FILTER (WHERE cast IS NULL) AS movie_cast_nulls,
       COUNT(*) FILTER (WHERE country IS NULL) AS country_nulls,
       COUNT(*) FILTER (WHERE date_added IS NULL) AS date_addes_nulls,
       COUNT(*) FILTER (WHERE release_year IS NULL) AS release_year_nulls,
       COUNT(*) FILTER (WHERE rating IS NULL) AS rating_nulls,
       COUNT(*) FILTER (WHERE duration IS NULL) AS duration_nulls,
       COUNT(*) FILTER (WHERE listed_in IS NULL) AS listed_in_nulls,
       COUNT(*) FILTER (WHERE description IS NULL) AS description_nulls
FROM netflix1;



---- Below, we find out if some directors are likely to work with particular cast.

WITH cte AS
(
SELECT title, CONCAT(director, '---', cast) AS director_genre 
FROM netflix1
)

SELECT director_genre, COUNT(*) AS count
FROM cte
GROUP BY director_genre
HAVING COUNT(*) > 1
ORDER BY COUNT(*) DESC;

--With this, we can now populate NULL rows in directors with help of genre. 

UPDATE netflix1
set director = 'Not Given'
WHERE director IS NULL

-- view after updating.
SELECT *
FROM netflix1

----Populate the country using the director column

SELECT COALESCE(nt.country,nt2.country) 
FROM netflix1  AS nt
JOIN netflix1 AS nt2 
ON nt.director = nt2.director 
AND nt.show_id <> nt2.show_id
WHERE nt.country IS NULL;
UPDATE netflix1
SET country = nt2.country
FROM netflix1 AS nt2
WHERE netflix1.director = nt2.director and netflix1.show_id <> nt2.show_id 
AND netflix1.country IS NULL;

--To confirm if there are still directors linked to country that refuse to update. 

SELECT director, country, date_added
FROM netflix1
where country is NULL

-- populate the rest of the null in country as 'not given'. 

UPDATE netflix1
set country = 'Not Given'
WHERE country is null

--Check to confirm the number of rows are the same (no null). 

SELECT count(*) filter (where show_id IS NOT NULL) AS showid_nulls,
       count(*) filter (where type IS NOT NULL) AS type_nulls,
       count(*) filter (where title IS NOT NULL) AS title_nulls,
       count(*) filter (where director IS NOT NULL) AS director_nulls,
       count(*) filter (where country IS NOT NULL) AS country_nulls,
       count(*) filter (where date_added IS NOT NULL) AS date_addes_nulls,
       count(*) filter (where release_year IS NOT NULL) AS release_year_nulls,
       count(*) filter (where rating IS NOT NULL) AS rating_nulls,
       count(*) filter (where duration IS NOT NULL) AS duration_nulls,
       count(*) filter (where listed_in IS NOT NULL) AS listed_in_nulls
FROM netflix1;

-- for visualisation purpose, spliting the country column.

SELECT *,
       SPLIT_PART(country,',',1) AS countryy, 
           SPLIT_PART(country,',',2),
       SPLIT_PART(country,',',4),
       SPLIT_PART(country,',',5),
       SPLIT_PART(country,',',6),
       SPLIT_PART(country,',',7),
       SPLIT_PART(country,',',8),
       SPLIT_PART(country,',',9),
       SPLIT_PART(country,',',10) 

FROM netflix1;

-- creating new column 'country1' and updating it first split country. 

ALTER TABLE netflix1
add country1 VARCHAR(500);
UPDATE netflix1
set country1 = SPLIT_PART(country, ',' ,1)

-- Delete column

ALTER table netflix1
DROP column country;

-- Rename the country1 as country. 

ALTER TABLE netflix1
RENAME column country1 to country;

SELECT * 
from netflix1


