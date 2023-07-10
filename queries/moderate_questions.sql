/* Question Set 2 - Moderate */

-- Q1. Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
-- Return your list ordered alphabetically by email starting with A.
SELECT DISTINCT CUS.EMAIL, CUS.FIRST_NAME, CUS.LAST_NAME
FROM CUSTOMER AS CUS
JOIN INVOICE AS INV ON CUS.CUSTOMER_ID = INV.CUSTOMER_ID
JOIN INVOICE_LINE AS INVL ON INV.INVOICE_ID = INVL.INVOICE_ID
WHERE INVL.TRACK_ID IN(
	SELECT T.TRACK_ID
	FROM TRACK AS T
	JOIN GENRE AS G ON T.GENRE_ID = G.GENRE_ID
	WHERE G.NAME LIKE 'Rock'
)
ORDER BY CUS.EMAIL;


-- Q2. Let's invite the artists who have written the most rock music in our dataset. 
-- Write a query that returns the Artist name and total track count of the top 10 rock bands.
SELECT AR.NAME, COUNT(AR.ARTIST_ID) AS NUMBER_OF_SONGS
FROM TRACK AS TR 
JOIN ALBUM AS AL ON TR.ALBUM_ID = AL.ALBUM_ID
JOIN ARTIST AS AR ON AL.ARTIST_ID = AR.ARTIST_ID
JOIN GENRE AS GE ON TR.GENRE_ID = GE.GENRE_ID
WHERE GE.NAME LIKE 'Rock'
GROUP BY AR.ARTIST_ID
ORDER BY NUMBER_OF_SONGS DESC LIMIT 10;


-- Q3. Return all the track names that have a song length longer than the average song length. 
-- A. Return the Name and Milliseconds for each track. 
-- B. Order by the song length with the longest songs listed first.
SELECT NAME, MILLISECONDS
FROM TRACK
WHERE MILLISECONDS > (
	SELECT AVG(MILLISECONDS) AS AVG_SONG_LENGTH
	FROM TRACK
)
ORDER BY MILLISECONDS DESC;
