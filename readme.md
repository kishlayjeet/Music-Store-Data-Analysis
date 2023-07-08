# Music Store Data Analysis 🎧

This project focuses on analyzing music store data with SQL. The dataset has 11 tables: Employee, Customer, Invoice, InvoiceLine, Track, MediaType, Genre, Album, Artist, PlaylistTrack, and Playlist. This project intends to answer many questions and obtain important insights into the music store's operations by applying SQL queries to the dataset.

## Table of Contents

- [Introduction](#introduction)
- [Dataset](#dataset)
- [Questions, Analysis and Insights](#questions-analysis-and-insights)
- [Project Structure](#project-structure)
- [Usage](#usage)
- [Contributing](#contributing)

## Introduction

The "Music Store Data Analysis" project provides a comprehensive analysis of the music store's data, enabling better decision-making, identifying trends, and understanding customer behavior. Through SQL queries and data exploration, this project offers insights and visualizations to optimize inventory management, target marketing campaigns, and make informed business decisions.

## Dataset

The dataset for this project has 11 tables: Employee, Customer, Invoice, InvoiceLine, Track, MediaType, Genre, Album, Artist, PlaylistTrack, and Playlist, as well as their associations.

![Schema](https://imgur.com/UU2tQp7.png)

## Questions, Analysis and Insights

#### Question Set 1 - Easy

Q1. Who is the senior most employee based on job title?

```sql
SELECT * FROM EMPLOYEE
ORDER BY LEVELS DESC
LIMIT 1;
```

| Employee ID | Last Name | First Name | Job Title              | Level | Birth Date | Hire Date  | Address            | City     | State | Country | Postal Code | Phone             | Fax               | Email                         |
| :---------- | :-------- | :--------- | :--------------------- | :---- | :--------- | :--------- | :----------------- | :------- | :---- | :------ | :---------- | :---------------- | :---------------- | :---------------------------- |
| 9           | Madan     | Mohan      | Senior General Manager | L7    | 1961-01-26 | 2016-01-14 | 1008 Vrinda Ave MT | Edmonton | AB    | Canada  | T5K 2N1     | +1 (780) 428-9482 | +1 (780) 428-3457 | <madan.mohan@chinookcorp.com> |

Q2. Which countries have the most Invoices?

```sql
SELECT BILLING_COUNTRY, COUNT(*) AS Most_Invoices FROM INVOICE
GROUP BY BILLING_COUNTRY
ORDER BY Most_Invoices DESC;
```

| Country        | Most Invoices |
| :------------- | :------------ |
| USA            | 131           |
| Canada         | 76            |
| Brazil         | 61            |
| France         | 50            |
| Germany        | 41            |
| Czech Republic | 30            |
| Portugal       | 29            |
| United Kingdom | 28            |
| India          | 21            |
| Chile          | 13            |

Q3. What are the top 3 values of total invoice?

```sql
SELECT TOTAL FROM INVOICE
ORDER BY TOTAL DESC
LIMIT 3;
```

| S.No. | Total Invoices     |
| :---- | :----------------- |
| 1     | 23.759999999999998 |
| 2     | 19.8               |
| 3     | 19.8               |

Q4. Which city has the best customers?

```sql
SELECT BILLING_CITY, SUM(TOTAL) AS Invoice_Total FROM INVOICE
GROUP BY BILLING_CITY
ORDER BY Invoice_Total DESC
LIMIT 1;
```

| City   | Invoice Total      |
| :----- | :----------------- |
| Prague | 273.24000000000007 |

Q5. Who is the best customer?

```sql
SELECT C.CUSTOMER_ID, C.FIRST_NAME, C.LAST_NAME, SUM(I.TOTAL) AS TOTAL_AMOUNT
FROM CUSTOMER AS C
JOIN INVOICE AS I
ON C.CUSTOMER_ID = I.CUSTOMER_ID
GROUP BY C.CUSTOMER_ID
ORDER BY TOTAL_AMOUNT DESC
LIMIT 1;
```

| Customer Id | First Name | Last Name | Total Amount       |
| :---------- | :--------- | :-------- | :----------------- |
| 5           | R          | Madhav    | 144.54000000000002 |

#### Question Set 2 - Moderate

Q1. Write a query to return the email, first name, last name, and Genre of all Rock Music listeners. Return the list ordered alphabetically by email starting with A.

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

| Email                         | First Name | Last Name |
| :---------------------------- | :--------- | :-------- |
| <aaronmitchell@yahoo.ca>      | Aaron      | Mitchell  |
| <alero@uol.com.br>            | Alexandre  | Rocha     |
| <astrid.gruber@apple.at>      | Astrid     | Gruber    |
| <bjorn.hansen@yahoo.no>       | Bjørn      | Hansen    |
| <camille.bernard@yahoo.fr>    | Camille    | Bernard   |
| <daan_peeters@apple.be>       | Daan       | Peeters   |
| <diego.gutierrez@yahoo.ar>    | Diego      | Gutiérrez |
| <dmiller@comcast.com>         | Dan        | Miller    |
| <dominiquelefebvre@gmail.com> | Dominique  | Lefebvre  |
| <edfrancis@yachoo.ca>         | Edward     | Francis   |

Q2. Let's invite the artists who have written the most rock music in our dataset. Write a query that returns the Artist name and total track count of the top 10 rock bands.

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

| Name                         | Number of Songs |
| :--------------------------- | :-------------- |
| Led Zeppelin                 | 114             |
| U2                           | 112             |
| Deep Purple                  | 92              |
| Iron Maiden                  | 81              |
| Pearl Jam                    | 54              |
| Van Halen                    | 52              |
| Queen                        | 45              |
| The Rolling Stones           | 41              |
| Creedence Clearwater Revival | 40              |
| Kiss                         | 35              |

Q3. Return all track names that have a song length longer than the average song length. Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first.

```sql
SELECT NAME, MILLISECONDS
FROM TRACK
WHERE MILLISECONDS > (
 SELECT AVG(MILLISECONDS) AS AVG_SONG_LENGTH
 FROM TRACK
)
ORDER BY MILLISECONDS DESC;
```

| Name                      | Milliseconds |
| :------------------------ | :----------- |
| Occupation / Precipice    | 5286953      |
| Through a Looking Glass   | 5088838      |
| Murder On the Rising Star | 2935894      |
| The Long Patrol           | 2925008      |
| Unfinished Business       | 2622038      |
| Further Instructions      | 2563980      |
| Alexander the Great       | 515631       |
| Heaven Can Wait           | 448574       |
| Powerslave                | 407823       |
| Wicked Ways               | 393691       |

#### Question Set 3 - Advanced

Q1. Find how much amount was spent by each customer on artists. Write a query to return the customer name, artist name, and total spent.

```sql

```

![Insights]()

Q2. Find the most popular music genre for each country. Write a query that returns each country along with the top genre. For countries where the maximum number of purchases is shared, return all genres.

```sql

```

![Insights]()

Q3. Find the customer that has spent the most on music for each country. Write a query that returns the country along with the top customer and how much they spent. For countries where the top amount spent is shared, provide all customers who spent this amount.

```sql

```

![Insights]()

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
   git clone https://github.com/kishlayjeet/music-store-data-analysis.git
   ```

2. Import the dataset into your SQL database management system.

3. Run SQL queries located in the `queries/` directory against the database to perform data analysis and generate insights.

## Contributing

Contributions to this project are welcome. If you have suggestions for improvements or find any issues, feel free to open a pull request or submit an issue in the repository.
