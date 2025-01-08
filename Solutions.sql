   --Netflix Project--
DROP TABLE IF EXISTS Netflix;

CREATE TABLE Netflix
(
    show_id	VARCHAR(7),
    type	VARCHAR(10),
    title	VARCHAR(150),
    director VARCHAR(210),
    casts	VARCHAR(1000),
    country	VARCHAR(150),
    date_added	VARCHAR(50),
    release_year	INT,
    rating	VARCHAR(10),
    duration  VARCHAR(15),
    listed_in VARCHAR(100),
    description VARCHAR(250)
);

SELECT * FROM Netflix;

SELECT 
    COUNT (*) as total_content
FROM Netflix;

SELECT 
    DISTINCT type
FROM Netflix;

SELECT * FROM Netflix;

-- 15 Business Problems --

1. Count the number of Movies vs TV Shows.

SELECT 
    type,
	COUNT(*) as total_content
	
FROM Netflix
GROUP BY type
2. Find the most common rating for Movies and TV Shows.

SELECT
   type,
   rating
FROM    

WITH aggregated_data AS (
    SELECT 
        type,
        rating,
        COUNT(*) AS count,
        RANK() OVER (PARTITION BY type ORDER BY COUNT(*) DESC) AS ranking
    FROM Netflix
    GROUP BY type, rating
)
SELECT *
FROM aggregated_data
WHERE ranking = 1;

3. List all movies released in a specific year (e.g., 2020)
-- filter 2020
-- movies

SELECT * FROM Netflix
WHERE 
    type ='Movie'
	AND
	release_year = 2020

4. Find the top 5 countries with most content on Netflix


SELECT 
    UNNEST(STRING_TO_ARRAY(country,',')) as new_country,
	COUNT(show_id) as total_content
FROM Netflix
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

5. Identify the longest movie?

SELECT * FROM Netflix
WHERE
    type = 'Movie'
	AND
	duration = (SELECT MAX(duration) FROM Netflix)

6. Find content added in the last 5 years.

SELECT 
    *
FROM Netflix
WHERE
    TO_DATE(date_added, 'Month DD,YYYY') >= CURRENT_DATE - INTERVAL '5 years'

SELECT CURRENT_DATE - INTERVAL '5 years'

7. Find all the movies/TV shows by director 'Rajiv Chilaka'!

SELECT * FROM Netflix
WHERE director ILIKE '%Rajiv Chilaka%'

8. List all TV shows with more than 5 seasons

SELECT 
    *	
FROM Netflix
WHERE 
    type = 'TV Show'
	AND
	SPLIT_PART(duration,' ', 1):: numeric > 5 


9. Count the number of content items in each genre

SELECT
    UNNEST(STRING_TO_ARRAY(listed_in,',')) as genre,
	COUNT(show_id) as total_content
FROM Netflix
GROUP BY 1

10. Find each year and the average number of contents released in India on Netflix.
Return top 5 year with the highest avg content release!
total content 333/972

SELECT 
    EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) as year,
	COUNT(*) as yearly_content,
	ROUND(
	COUNT(*)::numeric/(SELECT COUNT(*) FROM Netflix WHERE country = 'India'):: numeric * 100 
	,2) as avg_content_per_year
	
FROM Netflix
WHERE country = 'India'
GROUP BY 1

11. List all the movies that are documentaries.

SELECT * FROM Netflix
WHERE
    listed_in ILIKE '%documentaries'

12. Find all content without a director.

SELECT * FROM Netflix
WHERE
    director IS NULL

13. Find the top 10 actors who have appeared in the highest 
number of movies produced in India.

SELECT 
UNNEST(STRING_TO_ARRAY(casts,',')) as actors,
COUNT(*) as total_content
FROM Netflix
WHERE country ILIKE '%india'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10

14. Categorize the content based on the keywords 'kill' and 'voilence' in 
the description field. Label content containing these keywords as 'Action' 
and all other content as 'Good' . Count how many items fall into each category.


WITH new_table
AS
(
SELECT 
*, 
    CASE
	WHEN 
	     description ILIKE '%kill%' OR
	     description ILIKE '%voilence%' THEN 'Action_Content'
		 ELSE 'Good Content'
	END category
	
FROM Netflix
)
SELECT
    category,
	COUNT(*) as total_content

FROM new_table
GROUP BY 1








