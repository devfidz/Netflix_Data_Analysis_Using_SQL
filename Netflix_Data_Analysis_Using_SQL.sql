-- Netflix Project
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix(
	show_id VARCHAR(6),
	type VARCHAR(10),
	title VARCHAR(150),
	director VARCHAR(208),
	casts VARCHAR(1000),
	country VARCHAR(150),
	date_added VARCHAR(50),
	release_year INT,
	rating VARCHAR(10),
	duration VARCHAR(15),
	listed_in VARCHAR(100),
	description VARCHAR(250)
	);

	SELECT * FROM netflix;

	SELECT COUNT(*) 
	FROM netflix AS tota_movies;

	SELECT DISTINCT type
	FROM netflix;

	SELECT COUNT(*) AS movie_count
	FROM netflix
	WHERE type = 'Movie';
	
-- 1. Count the number of Movies vs TV Shows
	SELECT * FROM netflix
	
	SELECT type, COUNT(*) "count of movies by type"
	FROM netflix
	GROUP BY type;

--2. Find the most common rating for movies and TV shows
	SELECT * FROM netflix
	
	SELECT type, rating
	FROM
	(
		SELECT type, rating,count(*),
		RANK() OVER(PARTITION BY type ORDER BY COUNT(*)DESC) AS ranking
		FROM netflix
		GROUP BY 1,2
	)t
	WHERE ranking = 1



	
--3. List all movies released in a specific year (e.g., 2020)
	SELECT * FROM netflix

	SELECT COUNT(*) as no_of_movies_in_2020
	FROM netflix
	WHERE release_year = 2020
	
	SELECT title
	FROM netflix
	WHERE release_year = 2020
	

	SELECT release_year, COUNT(*)no_of_movies_in_a_yr
	FROM netflix
	--WHERE release_year = 2020
	GROUP BY release_year
	ORDER BY no_of_movies_in_a_yr DESC
	LIMIT 5
	
	
--4. Find the top 5 countries with the most content on Netflix
	SELECT * FROM netflix
	
	SELECT UNNEST(STRING_TO_ARRAY(country,',')) AS new_country_list,
	count(show_id)tsd
	FROM netflix
	WHERE COUNTRY IS NOT NULL
	GROUP BY 1
	ORDER BY 2 DESC
	LIMIT 5

--5. Identify the longest movie
	SELECT * FROM netflix
	
	SELECT title, duration FROM netflix
	WHERE type = 'Movie' AND duration=(SELECT MAX(duration) FROM netflix)
	
--6. Find content added in the last 5 years
	SELECT * FROM netflix
	
	SELECT * FROM netflix
	WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';

	
	
--7. Find all the movies/TV shows by director 'Rajiv Chilaka'!
	SELECT * FROM netflix

	SELECT type, title, director FROM netflix
	WHERE director LIKE '%Rajiv Chilak%' 
	
--8. List all TV shows with more than 5 seasons
	SELECT * FROM netflix
	
	SELECT 
		   title, type,
		   duration,
		   SPLIT_PART(duration, ' ', 1) :: numeric > 5
	FROM NETFLIX
	WHERE type = 'TV Show'
		
	
--9. Count the number of content items in each genre
	SELECT * FROM netflix

	SELECT 
		UNNEST(STRING_TO_ARRAY(listed_in, ',' )) AS genre,
		COUNT(show_id) AS total_content
	FROM netflix
	GROUP BY 1
	
--10.Find each year and the average numbers of content release in India on netflix. 
	return top 5 year with highest avg content release!
	
	SELECT * FROM netflix
	SELECT 
		EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) AS year,
		COUNT(*) ::numeric AS yearly_content,
		ROUND(
		COUNT(*)::numeric/(SELECT COUNT(*) FROM netflix WHERE country = 'India')::numeric *100, 2
		) AS avg_content_per_year
	FROM netflix
	WHERE country = 'India'
	GROUP BY 1
	ORDER BY 1
	

--11. List all movies that are documentaries
	SELECT * FROM netflix
	WHERE 
		listed_in ILIKE '%documentaries%'

--12. Find all content without a director
	SELECT * FROM netflix
	WHERE 
		director IS NULL

	
--13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
	SELECT * FROM netflix
	WHERE
		casts ILIKE '%Salman Khan%' 
	AND release_year > EXTRACT(YEAR FROM CURRENT_DATE)-10
		
	
--14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
	SELECT 
		--show_id,
		--casts,
		UNNEST(STRING_TO_ARRAY(casts, ',')) AS actors,
	    COUNT(*) AS total_content
	FROM netflix
	WHERE country ILIKE '%India%'
	GROUP BY 1
	ORDER BY 2 DESC
	LIMIT 10

	
--15. Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
	the description field. Label content containing these keywords as 'Bad' and all other 
	content as 'Good'. Count how many items fall into each category.
	
	WITH new_table AS(
		SELECT *,
				CASE
					WHEN
						description ILIKE '%kill%' OR
						description ILIKE '%violence%' 
						THEN 'Bad_Content' 
					ELSE 'Good Content'
				END category
		FROM netflix)
	SELECT
		category,
		COUNT(*) AS total_content
	FROM new_table
	GROUP BY 1
		

	