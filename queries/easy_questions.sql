/* Question Set 1 - Easy */

-- Q1. Who is the senior most employee based on job title? 
SELECT * FROM EMPLOYEE
ORDER BY LEVELS DESC
LIMIT 1;


-- Q2. Which countries have the most Invoices?
SELECT BILLING_COUNTRY, COUNT(*) AS Most_Invoices FROM INVOICE
GROUP BY BILLING_COUNTRY
ORDER BY Most_Invoices DESC;


-- Q3. What are top 3 values of total invoice?
SELECT TOTAL FROM INVOICE
ORDER BY TOTAL DESC
LIMIT 3;


-- Q4. Which city has the best customers? 
-- A. We would like to throw a promotional Music Festival in the city we made the most money. 
-- B. Write a query that returns one city that has the highest sum of invoice totals. 
-- C. Return both the city name & sum of all invoice totals.
SELECT BILLING_CITY, SUM(TOTAL) AS Invoice_Totals FROM INVOICE
GROUP BY BILLING_CITY
ORDER BY Invoice_Totals DESC
LIMIT 1;


-- Q5. Who is the best customer? 
-- A. The customer who has spent the most money will be declared the best customer. 
-- B. Write a query that returns the person who has spent the most money.
SELECT C.CUSTOMER_ID, C.FIRST_NAME, C.LAST_NAME, SUM(I.TOTAL) AS TOTAL_AMOUNT
FROM CUSTOMER AS C
JOIN INVOICE AS I 
ON C.CUSTOMER_ID = I.CUSTOMER_ID
GROUP BY C.CUSTOMER_ID
ORDER BY TOTAL_AMOUNT DESC
LIMIT 1;
