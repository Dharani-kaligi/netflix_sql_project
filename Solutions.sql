select count(*) from [dbo].[netflix_titles]

select * from [dbo].[netflix_titles]

---15 Business Problems

--1. Count the Number of Movies vs TV Shows

SELECT type,
Count (*) as total_Content
from [dbo].[netflix_titles]
GROUP BY type

--2. Find the Most Common Rating for Movies and TV Shows

SELECT 
    type, 
    rating
FROM 
(
    SELECT 
        type,
        rating,
        COUNT(*) AS rating_count,
        RANK() OVER (PARTITION BY type ORDER BY COUNT(*) DESC) AS ranking
    FROM [dbo].[netflix_titles]
    GROUP BY type, rating
) AS RankedRatings
WHERE 
    ranking = 1;

---3. List All Movies Released in a Specific Year (e.g., 2020)

select * from [dbo].[netflix_titles]

SELECT
  * 
  FROM [dbo].[netflix_titles]
  WHERE type='Movie' AND release_year = '2020'


---4. Find the Top 5 Countries with the Most Content on Netflix

SELECT TOP 5
    country,
    COUNT(*) AS content_count
FROM [dbo].[netflix_titles]
GROUP BY country
ORDER BY content_count DESC;


---5. Identify the Longest Movie

Select top 1 title, duration
from [dbo].[netflix_titles]
WHERE type = 'Movie' 
ORDER BY duration DESC


---6. Find Content Added in the Last 5 Years

SELECT *
FROM [dbo].[netflix_titles]
WHERE date_added >= DATEADD(YEAR, -5, GETDATE());


---7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'

SELECT type, title, director
FROM  [dbo].[netflix_titles]
WHERE director LIKE '%Rajiv Chilaka%'


---8. List All TV Shows with More Than 5 Seasons

SELECT *
FROM [dbo].[netflix_titles]
WHERE type = 'TV Show' and duration like '%Season%' 
AND duration >'5 Seasons'

---9. Count the Number of Content Items in Each Genre

SELECT listed_in, Count(title) AS No_of_Content_Items FROM
[dbo].[netflix_titles]
GROUP BY listed_in
ORDER BY No_of_Content_Items DESC


---10.Find each year and the average numbers of content release in India on netflix.

-- Find each year and the average number of content releases in India on Netflix

WITH YearlyCounts AS (
    SELECT
        YEAR(CONVERT(DATE, date_added, 120)) AS release_year,
        COUNT(*) AS yearly_count
    FROM 
        [dbo].[netflix_titles]
    WHERE
        country = 'India'
    GROUP BY
        YEAR(CONVERT(DATE, date_added, 120))
),
AverageCounts AS (
    SELECT
        AVG(yearly_count) AS average_releases_per_year
    FROM
        YearlyCounts
)
SELECT
    release_year,
    yearly_count,
    (SELECT average_releases_per_year FROM AverageCounts) AS average_releases_per_year
FROM
    YearlyCounts
ORDER BY
    release_year;


---11. List All Movies that are Documentaries

SELECT * FROM [dbo].[netflix_titles]
WHERE type = 'Movie' AND listed_in LIKE '%Documentaries%'


---12. Find All Content Without a Director

SELECT * FROM 
[dbo].[netflix_titles]
WHERE director IS NULL
  

---13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years


SELECT * FROM
[dbo].[netflix_titles]
WHERE date_added >= DATEADD(YEAR, -10, GETDATE()) AND cast LIKE '%Salman Khan%'

---14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India

WITH ActorCounts AS (
    SELECT
        actor,
        COUNT(*) AS movie_count
    FROM (
        SELECT
            TRIM(value) AS actor  -- Remove any leading/trailing spaces from the actor names
        FROM 
            [dbo].[netflix_titles]
        CROSS APPLY
            STRING_SPLIT(cast, ',')  -- Split the cast column into individual actors
        WHERE
            country = 'India'
            AND type = 'Movie'
    ) AS ActorList
    GROUP BY
        actor
)
SELECT 
    TOP 10
    actor,
    movie_count
FROM 
    ActorCounts
ORDER BY 
    movie_count DESC;


---15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords

With Categorisedcontent AS(
SELECT 
    *,
    CASE 
        WHEN description LIKE '%kill%' OR description LIKE '%Violence%' THEN 'GOOD'
        ELSE 'BAD'
    END AS Category
FROM 
    [dbo].[netflix_titles]
)

---Count of total content
SELECT 
      category,
	  COUNT(*) AS total_content
FROM Categorisedcontent
GROUP BY Category






















