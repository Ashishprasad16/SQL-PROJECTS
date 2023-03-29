-- project 2  MUSIC COMPANY

-- senior most employee
select top 1 first_name,last_name from employee order by levels desc; 

-- Each country with their highest invoice
select MAX(total) as highest_invoice,billing_country from invoice group by billing_country order by highest_invoice desc;

-- total no of invoices according to country
select COUNT(total) as no_of_invoices,billing_country from invoice group by billing_country order by no_of_invoices desc;

-- top 3 countries with the max no of invoices
select top 3 COUNT(total) as no_of_invoices,billing_country from invoice group by billing_country order by no_of_invoices desc;

-- company wants to throw a promotional music fest so it wants to no hishest sum of invoices by city name
select SUM(total) as sum_of_invoices,billing_city from invoice group by billing_city order by 1 desc;

-- BEST CUSTOMER (customer who spends the most money)
select top 1 customer.customer_id,customer.first_name,customer.last_name,invoice.total from customer
join invoice on invoice.customer_id= customer.customer_id order by invoice.total desc

-- want all the listeners of 'Rock' Genre with their email id(rock has the genre id as 1)

select distinct customer.email,customer.first_name,customer.last_name from customer  
join invoice on invoice.customer_id = customer.customer_id
join invoice_line on invoice_line.invoice_id = invoice.invoice_id
join track on track.track_id = invoice_line.track_id
join genre on genre.genre_id = track.genre_id
where genre.genre_id=1 order by customer.email

-- second method for the same upper question ( customers listening to rock music)
select distinct customer.email,customer.first_name,customer.last_name from customer  
join invoice on invoice.customer_id = customer.customer_id
join invoice_line on invoice_line.invoice_id = invoice.invoice_id
where track_id in(
select track_id from track
join genre on genre.genre_id= track.genre_id
where genre.name like 'rock'
)
order by customer.email


-- COUNT OF TOP 10 ROCK BAND AND THE ARTIST NAME

SELECT top 10 artist.name,COUNT(artist.artist_id) as total_count from artist
join album on  album.artist_id= artist.artist_id
join track on track.album_id= Album.album_id
join genre on genre.genre_id= track.genre_id
where genre.genre_id=1
group by artist.name
order by total_count desc

-- ALL THE TRACK NAMES THAT HAVE SONG LENTH LOMGER THAN AVG SONG LENGTH(RETURN SONG NAME AND MILLISECOND)

select name,milliseconds from track where milliseconds >
(SELECT AVG(milliseconds) as standard_length from track)
order by milliseconds desc

-- AMOUNT SPENT BY EACH CUSTOMER ON EACH ARTIST
SELECT distinct customer.first_name,customer.last_name,artist.name,SUM(invoice_line.quantity*invoice_line.unit_price)over(partition by artist.name) as total_spend from customer
join invoice on invoice.customer_id= customer.customer_id
join invoice_line on invoice_line.invoice_id=invoice.invoice_id
join track on track.track_id=invoice_line.track_id
join Album on Album.album_id= track.album_id
join artist on artist.artist_id= Album.artist_id
order by total_spend desc

--another way by ctc(temporary table)

with best_artist as (
select top 5 artist.artist_id as artist_id,artist.name as artist_name,sum(invoice_line.unit_price*invoice_line.quantity) as total_spent 
from invoice_line
join track on track.track_id=invoice_line.track_id
join album on track.album_id=Album.album_id
join artist on artist.artist_id=Album.artist_id
group by artist.artist_id,artist.name
order by 3 desc
)
select  customer.first_name,customer.last_name,best_artist.artist_name,best_artist.total_spent  from best_artist
join album on best_artist.artist_id=Album.artist_id
join track on Album.album_id=track.album_id
join invoice_line on track.track_id=invoice_line.track_id
join invoice on invoice_line.invoice_id=invoice.invoice_id
join customer on invoice.customer_id=customer.customer_id
group by best_artist.artist_name, customer.first_name,customer.last_name,best_artist.total_spent
order by total_spent desc


--most popular genre from each country (genre with highest spent)
select customer.country as country,max(invoice.total) as highest_spent,genre.name from customer
join invoice on invoice.customer_id = customer.customer_id
join invoice_line on invoice_line.invoice_id = invoice.invoice_id
join track on track.track_id = invoice_line.track_id
join genre on genre.genre_id = track.genre_id
group by country,genre.name
order by highest_spent desc

-- most papular genre from each country based on count of quantity sold
select customer.country as country,count(invoice_line.quantity) as highest_spent,genre.name from customer
join invoice on invoice.customer_id = customer.customer_id
join invoice_line on invoice_line.invoice_id = invoice.invoice_id
join track on track.track_id = invoice_line.track_id
join genre on genre.genre_id = track.genre_id
group by country,genre.name
order by highest_spent desc

--customer that has spend most money from each country
select distinct customer.country, customer.first_name,customer.last_name,max(invoice.total) over (partition by genre.name) as highest_spent,genre.name from customer
join invoice on invoice.customer_id = customer.customer_id
join invoice_line on invoice_line.invoice_id = invoice.invoice_id
join track on track.track_id = invoice_line.track_id
join genre on genre.genre_id = track.genre_id

order by highest_spent desc






