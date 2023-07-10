# Music Store Data Analysis 🎧

This project focuses on analyzing music store data with SQL. The dataset has 11 tables: Employee, Customer, Invoice, InvoiceLine, Track, MediaType, Genre, Album, Artist, PlaylistTrack, and Playlist. This project intends to answer many questions and obtain important insights into the music store's operations by applying SQL queries to the dataset.

## Table of Contents

- [Introduction](#introduction)
- [Dataset](#dataset)
- [Questions and Answers](#questions-and-answers)
	- [Question Set 1 - Easy](#question-set-1---easy)
	- [Question Set 2 - Moderate](#question-set-2---moderate)
	- [Question Set 3 - Advanced](#question-set-3---advanced)
- [Project Structure](#project-structure)
- [Usage](#usage)
- [Contributing](#contributing)

## Introduction

The "Music Store Data Analysis" project offers a comprehensive analysis of the music store's data to facilitate better decision-making, identify trends, and understand customer behavior. By leveraging SQL queries and data exploration, this project provides valuable answers to optimize inventory management, target marketing campaigns, and make informed business decisions.

## Dataset

The dataset for this project has 11 tables: Employee, Customer, Invoice, InvoiceLine, Track, MediaType, Genre, Album, Artist, PlaylistTrack, and Playlist, as well as their associations.

![Schema](https://imgur.com/UU2tQp7.png)

## Questions and Answers

#### Question Set 1 - Easy

Q1. Who is the most senior employee based on job title? 

```sql
SELECT * FROM EMPLOYEE
ORDER BY LEVELS DESC
LIMIT 1;
```

Q2. Which countries have the most Invoices?

```sql
SELECT BILLING_COUNTRY, COUNT(*) AS Most_Invoices FROM INVOICE
GROUP BY BILLING_COUNTRY
ORDER BY Most_Invoices DESC;
```

Q3. What are top 3 values of total invoice?

```sql
SELECT TOTAL FROM INVOICE
ORDER BY TOTAL DESC
LIMIT 3;
```

Q4. Which city has the best customers? 
- We would like to throw a promotional Music Festival in the city we made the most money. 
- Write a query that returns one city that has the highest sum of invoice totals. 
- Return both the city name & sum of all invoice totals.

```sql
SELECT BILLING_CITY, SUM(TOTAL) AS Invoice_Total FROM INVOICE
GROUP BY BILLING_CITY
ORDER BY Invoice_Total DESC
LIMIT 1;
```

Q5. Who is the best customer? 
- The customer who has spent the most money will be declared the best customer. 
- Write a query that returns the person who has spent the most money.

```sql
SELECT C.CUSTOMER_ID, C.FIRST_NAME, C.LAST_NAME, SUM(I.TOTAL) AS TOTAL_AMOUNT
FROM CUSTOMER AS C
JOIN INVOICE AS I
ON C.CUSTOMER_ID = I.CUSTOMER_ID
GROUP BY C.CUSTOMER_ID
ORDER BY TOTAL_AMOUNT DESC
LIMIT 1;
```

#### Question Set 2 - Moderate

Q1. Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
- Return your list ordered alphabetically by email starting with A.

```sql
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
```

Q2. Let's invite the artists who have written the most rock music in our dataset. 
- Write a query that returns the Artist name and total track count of the top 10 rock bands.

```sql
SELECT AR.NAME, COUNT(AR.ARTIST_ID) AS NUMBER_OF_SONGS
FROM TRACK AS TR
JOIN ALBUM AS AL ON TR.ALBUM_ID = AL.ALBUM_ID
JOIN ARTIST AS AR ON AL.ARTIST_ID = AR.ARTIST_ID
JOIN GENRE AS GE ON TR.GENRE_ID = GE.GENRE_ID
WHERE GE.NAME LIKE 'Rock'
GROUP BY AR.ARTIST_ID
ORDER BY NUMBER_OF_SONGS DESC LIMIT 10;
```

Q3. Return all the track names that have a song length longer than the average song length. 
- Return the Name and Milliseconds for each track. 
- Order by the song length with the longest songs listed first.

```sql
SELECT NAME, MILLISECONDS
FROM TRACK
WHERE MILLISECONDS > (
 SELECT AVG(MILLISECONDS) AS AVG_SONG_LENGTH
 FROM TRACK
)
ORDER BY MILLISECONDS DESC;
```

#### Question Set 3 - Advanced

Q1. Find how much amount spent by each customer on artists? 
- Write a query to return customer name, artist name and total spent.

```sql
WITH BEST_SELLING_ARTIST AS (
	SELECT ART.ARTIST_ID, ART.NAME, SUM(IVL.UNIT_PRICE * IVL.QUANTITY) AS TOTAL_AMOUNT
	FROM INVOICE_LINE AS IVL
	JOIN TRACK AS TRK ON IVL.TRACK_ID = TRK.TRACK_ID
	JOIN ALBUM AS ALB ON TRK.ALBUM_ID = ALB.ALBUM_ID
	JOIN ARTIST AS ART ON ALB.ARTIST_ID = ART.ARTIST_ID
	GROUP BY ART.ARTIST_ID
	ORDER BY TOTAL_AMOUNT DESC LIMIT 1
)
SELECT CUS.CUSTOMER_ID, CUS.FIRST_NAME, CUS.LAST_NAME, BSA.NAME AS ARTIST_NAME, SUM(IVL.UNIT_PRICE * IVL.QUANTITY) AS AMOUNT_SPENT
FROM INVOICE AS INV
JOIN CUSTOMER AS CUS ON INV.CUSTOMER_ID = CUS.CUSTOMER_ID
JOIN INVOICE_LINE AS IVL ON INV.INVOICE_ID = IVL.INVOICE_ID
JOIN TRACK AS TRK ON IVL.TRACK_ID = TRK.TRACK_ID
JOIN ALBUM AS ALB ON TRK.ALBUM_ID = ALB.ALBUM_ID
JOIN BEST_SELLING_ARTIST AS BSA ON ALB.ARTIST_ID = BSA.ARTIST_ID
GROUP BY CUS.CUSTOMER_ID, BSA.NAME;
```

Q2. We want to find out the most popular music Genre for each country. 
- We determine the most popular genre as the genre with the highest amount of purchases. 
- Write a query that returns each country along with the top Genre. 
- For countries where the maximum number of purchases is shared return all Genres.

```sql
WITH POPULAR_GENRE AS (
	SELECT CU.COUNTRY, COUNT(IL.QUANTITY) AS TOTAL_PURCHASES, GE.NAME AS TOP_GENRE, GE.GENRE_ID,
		ROW_NUMBER() OVER(
			PARTITION BY CU.COUNTRY ORDER BY COUNT(IL.QUANTITY) DESC
		) AS ROW_NUM
	FROM CUSTOMER AS CU
	JOIN INVOICE AS IV ON CU.CUSTOMER_ID = IV.CUSTOMER_ID
	JOIN INVOICE_LINE AS IL ON IV.INVOICE_ID = IL.INVOICE_ID
	JOIN TRACK AS TR ON IL.TRACK_ID = TR.TRACK_ID
	JOIN GENRE AS GE ON TR.GENRE_ID = GE.GENRE_ID
	GROUP BY CU.COUNTRY, GE.NAME, GE.GENRE_ID
	ORDER BY CU.COUNTRY, TOTAL_PURCHASES DESC
)
SELECT COUNTRY, TOP_GENRE, TOTAL_PURCHASES
FROM POPULAR_GENRE WHERE ROW_NUM = 1;
```

Q3. Write a query that determines the customer that has spent the most on music for each country. 
- Write a query that returns the country along with the top customer and how much they spent. 
- For countries where the top amount spent is shared, provide all customers who spent this amount.

```sql
WITH CUSTOMER_WITH_COUNTRY AS (
	SELECT CU.COUNTRY, CU.CUSTOMER_ID, CU.FIRST_NAME, CU.LAST_NAME, SUM(IV.TOTAL) AS AMOUNT_SPENT,
		ROW_NUMBER() OVER(
			PARTITION BY CU.COUNTRY ORDER BY SUM(IV.TOTAL) DESC
		) AS ROW_NUM
	FROM INVOICE AS IV
	JOIN CUSTOMER AS CU ON IV.CUSTOMER_ID = CU.CUSTOMER_ID
	GROUP BY CU.COUNTRY, CU.CUSTOMER_ID, CU.FIRST_NAME, CU.LAST_NAME
	ORDER BY CU.COUNTRY, AMOUNT_SPENT DESC
)
SELECT COUNTRY, CUSTOMER_ID, FIRST_NAME, LAST_NAME, AMOUNT_SPENT
FROM CUSTOMER_WITH_COUNTRY
WHERE ROW_NUM = 1;
```

## Project Structure

The project repository is structured as follows:

```
├── data/                  # Directory containing the dataset
├── queries/               # Directory containing SQL query files
└── README.md              # Project README file
```

## Usage

1. Clone the repository:

   ```
   git clone https://github.com/kishlayjeet/Music-Store-Data-Analysis.git
   ```

2. Import the dataset into your SQL database management system.

3. Run SQL queries located in the `queries/` directory against the database to perform data analysis and generate insights.

## Contributing

Contributions to this project are welcome. If you have suggestions for improvements or find any issues, feel free to open a pull request or submit an issue in the repository.
