USE imdb;
#Count the total number of records in each table of the database.
SELECT count(*)AS DIRECTOR,
(SELECT count(*) FROM genre) AS GENRE,
(SELECT count(*) FROM movie) AS MOVIE,
(SELECT count(*) FROM names) AS NAMES,
(SELECT count(*) FROM ratings) AS RATINGS,
(SELECT count(*) FROM role_mapping) AS ROLE_MAPPING
FROM director_mapping;
#2.Identify which columns in the movie table contain null values.
SELECT 'country' AS NULL_VALUES FROM movie WHERE country is null
UNION
SELECT 'worlwide_gross_income' AS NULL_VALUES FROM movie WHERE worlwide_gross_income is null
UNION
SELECT 'languages' AS NULL_VALUES FROM movie WHERE languages is null
UNION
SELECT 'production_company' AS NULL_VALUES FROM movie WHERE production_company is null;

#3.Determine the total number of movies released each year, and analyze how the trend changes month-wise.
SELECT count(title),year (date_published) AS RELEASED_YEAR, month (date_published) AS MONTH_WISE
FROM movie
GROUP BY RELEASED_YEAR,MONTH_WISE
ORDER BY RELEASED_YEAR,MONTH_WISE;

#4.How many movies were produced in either the USA or India in the year 2019?
SELECT count(title),year,country
FROM movie
GROUP BY year,country
HAVING (country = 'USA'or country ='india') and year=2019;
#5.List the unique genres in the dataset, and count how many movies belong exclusively to one genre. 
SELECT movie_id ,count(genre)AS count_movie
FROM genre
group by movie_id
having count_movie =1;
#6.Which genre has the highest total number of movies produced?
select genre,count(movie_id)AS highest_movie
from genre
group by genre
order by highest_movie desc
limit 1;
#7.Calculate the average movie duration for each genre
select g.genre,avg(m.duration)AS average_duration
from genre g
join movie m
ON m.id = g.movie_id
group by g.genre;
#8.Identify actors or actresses who have appeared in more than three movies with an average rating below 5
 SELECT category, COUNT(avg_rating) AS movie_count
FROM role_mapping
inner JOIN ratings 
ON ratings.movie_id = role_mapping.movie_id
WHERE  avg_rating<5
GROUP BY category
HAVING COUNT(avg_rating)>3;
#9.Find the minimum and maximum values for each column in the ratings table, excluding the movie_id column. 
SELECT max(avg_rating),max(total_votes) ,
max(median_rating),min(avg_rating) ,min(total_votes) ,
min(median_rating)FROM ratings;

#10.Which are the top 10 movies based on their average rating
SELECT r.avg_rating,m.title AS MOVIES
FROM ratings r
INNER JOIN movie m 
ON r.movie_id = m.id
ORDER BY avg_rating DESC
LIMIT 10;

#11.Summarize the ratings table by grouping movies based on their median ratings.
SELECT r.median_rating,count(title)AS MOVIES
FROM ratings r
INNER JOIN movie m
ON r.movie_id = m.id
GROUP BY r.median_rating
ORDER BY r.median_rating asc;

#12.How many movies, released in March 2017 in the USA within a specific genre, had more than 1,000 votes? 
 SELECT COUNT(G.MOVIE_ID)AS MOVIE_COUNT ,YEAR,COUNTRY,GENRE
 FROM MOVIE M 
 JOIN GENRE G ON M.ID = G.MOVIE_ID
 JOIN RATINGS R ON G.MOVIE_ID = R.MOVIE_ID
 WHERE M.YEAR = 2017 AND M.COUNTRY = 'USA' AND R.TOTAL_VOTES>1000
 GROUP BY G.GENRE;

#13.Find movies from each genre that begin with the word “The” and have an average rating greater than 8. 
SELECT TITLE, GENRE,AVG_RATING 
FROM MOVIE M
JOIN GENRE G
ON M.ID=G.MOVIE_ID
JOIN RATINGS R
ON G.MOVIE_ID=R.MOVIE_ID
WHERE m.title LIKE 'The%' AND r.avg_rating >8;

#14.Of the movies released between April 1, 2018, and April 1, 2019, how many received a median rating of 8? 
SELECT year, COUNT(m.id)AS RECEIVED_MEDIAN_RATING
FROM movie m
 JOIN ratings r
ON m.id = r.movie_id
WHERE date(m.date_published)BETWEEN '2018-04-01' AND '2019-04-01' AND r.median_rating=8
group by year;
    
#15. Do German movies receive more votes on average than Italian movies?
SELECT country, AVG(R.total_votes) 
FROM movie M
join ratings R
on M.id = R.movie_id
GROUP BY M.country
HAVING M.COUNTRY IN ('GERMANY','ITALY');

#16. Identify the columns in the names table that contain null values.
SELECT 'country' AS NULL_VALUES FROM movie WHERE country is null
UNION
SELECT 'worlwide_gross_income' AS NULL_VALUES FROM movie WHERE worlwide_gross_income is null;
SELECT 'id' AS NULL_VALUES FROM names WHERE id is null
UNION
SELECT 'name' AS NULL_VALUE FROM names WHERE name is null
UNION
SELECT 'height' AS NULL_VALUES FROM names WHERE height is null
UNION
SELECT 'date_of_birth' AS NULL_VALUES FROM names WHERE date_of_birth is null
UNION
SELECT 'known_for_movies' AS NULL_VALUES FROM names WHERE known_for_movies is null;

#17.Who are the top two actors whose movies have a median rating of 8 or higher?
SELECT n.name,r.median_rating
FROM names n
 JOIN role_mapping rm
ON n.id = rm.name_id
 JOIN ratings r 
ON r.movie_id = rm.movie_id
WHERE r.median_rating>=8
ORDER BY r.median_rating DESC
LIMIT 2;
#18. Which are the top three production companies based on the total number of votes their movies received? 
SELECT production_company, SUM(total_votes) AS Numberofvotes
FROM movie 
JOIN ratings 
ON movie.id = ratings.movie_id
GROUP BY production_company
ORDER BY numberofvotes DESC
LIMIT 3;
#19. How many directors have worked on more than three movies?
SELECT count(*) AS DIRECTORS
FROM(SELECT name_id FROM director_mapping
GROUP BY name_id having count(movie_id>3))AS DIRECTOR_THREE_MOVIE;
    
#20.Calculate the average height of actors and actresses separately.
SELECT r.category,AVG(n.height)AS average_height
FROM role_mapping r
JOIN names n
ON n.id = r.name_id
GROUP BY r.category;
#21. List the 10 oldest movies in the dataset along with their title, country, and director. 
SELECT m.title, m.country,n.name, date(m.date_published)
FROM movie m
INNER JOIN director_mapping d
ON d.movie_id = m.id
INNER JOIN names n
ON d.name_id = n.id
ORDER BY date(m.date_published)
LIMIT 10;
#22.List the top 5 movies with the highest total votes, along with their genres. 
SELECT m.title,r.total_votes,(SELECT group_concat(distinct g.genre) FROM genre g
WHERE g.movie_id = m.id) AS GENRE
FROM movie m
INNER JOIN ratings r
ON r.movie_id = m.id
ORDER BY r.total_votes DESC
LIMIT 5;
#23. Identify the movie with the longest duration, along with its genre and production company.
SELECT m.title,m.duration,(SELECT group_concat(g.genre)
FROM genre g
WHERE g.movie_id = m.id) AS MOVIE
FROM movie m
ORDER BY m.duration DESC
LIMIT 1;
#24.Determine the total number of votes for each movie released in 2018.
select year(m.date_published) AS YEAR, m.title,r.total_votes
FROM movie m
INNER JOIN ratings r
ON m.id = r.movie_id
WHERE year(m.date_published)='2018';
#25.What is the most common language in which movies were produced?
SELECT languages, COUNT(title) AS movie_count
FROM movie
GROUP BY languages
ORDER BY movie_count DESC
LIMIT 1;