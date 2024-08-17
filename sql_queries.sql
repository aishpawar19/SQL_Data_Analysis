---1.	Which canva size costs the most?

select distinct c.label , sale_price
	from product_size p join canvas_size c
on p.size_id = c.size_id::text
order by sale_price desc
limit 1


---2. Delete duplicate records from work, product_size, subject and image_link tables

delete from work 
	where ctid not in (
		select min(ctid) 
		from work	
		group by work_id, name, museum_id, style, artist_id)
		
delete from product_size 
	where ctid not in (
		select min(ctid) 
		from product_size	
		group by work_id, size_id, sale_price, regular_price)  
		
delete from subject 
	where ctid not in (
		select min(ctid) 
		from subject	
		group by work_id, subject) 
		
delete from image_link 
	where ctid not in (select min(ctid)
						from image_link
						group by work_id )
						
---3. Identify the museums with invalid city information in the given dataset

select city from museum
where city !~ '([A-Za-z\s]+)'

or 

select city from museum
where city ~ '^[0-9]+$'


---4. Museum_Hours table has 1 invalid entry. Identify it and remove it.

delete from museum_hours
	where ctid not in (
select min(ctid) from museum_hours
	group by museum_id , day)


---5. Fetch the top 10 most famous painting subject

select  subject, count(*) as no_of_paintings, 
	row_number() over(order by count(*) desc) as rnk 
	from subject
group by subject
order by count(*) desc
limit 10

-- if there's a tie 

select * from (	
select subject , count(*) as no_of_paintings , dense_rank() over(order by count(*) desc) as rnk 
from subject
group by 1) where rank <= 10

--- 6. Identify the museums which are open on both Sunday and Monday. Display
museum name, city.

select name, city from museum 
where museum_id in (
	select museum_id from museum_hours
	where day in ('Sunday', 'Monday')
	group by 1
	having count(*) > 1
	order by name)

---alternative solution

select distinct name, city from museum m join museum_hours mh
on m.museum_id = mh.museum_id
where day = 'Sunday'
and exists (select 1 from museum_hours mh 
				where m.museum_id = mh.museum_id
					and mh.day = 'Monday'
				order by name)
				

--- 7. How many museums are open every single day?		

select count(*)
	from (select museum_id, count(*)
		  from museum_hours
		  group by museum_id
		  having count(1) = 7) x;
		  
				
--- 8. Which are the top 5 most popular museum? (Popularity is defined based on most
no of paintings in a museum). Output museum_id, name , city , number of paintings and rank.

select m.museum_id, m.name, city , count(work_id) as number_of_paintings,
	rank() over(order by count(work_id) desc) as rnk
from work w join museum m 
	on w.museum_id = m.museum_id	
group by 1 ,2, 3
order by count(work_id) desc
limit 5


--- 9. Who are the top 5 most popular artist? (Popularity is defined based on most no of
paintings done by an artist). Output artist name , style and number of paintings.

select full_name as "artist name" , w.style , count(*) as num_of_paintings,
	rank() over(order by count(*) desc) as rnk
from work w join artist a
on w.artist_id = a.artist_id
group by 1,2
order by count(*) desc
limit 5


--- 10. Which museum is open for the longest during a day. Dispay museum name, state, day , opens , clsoe and hours open?

select name, state, day, open, close, duration as hours_open 
	from museum m join (
select museum_id, open, close, 
	to_timestamp(close,'HH:MI PM') - to_timestamp(open,'HH:MI AM') as duration, day 
from museum_hours
order by duration desc
limit 1) x on m.museum_id = x.museum_id


--- 11. Identify the artists whose paintings are displayed in multiple countries

with cte as (
select distinct a.full_name as artist , country
	from work w join museum m 
on w.museum_id = m.museum_id join artist a
on a.artist_id = w.artist_id)

select artist , count(*) as no_of_countries
from cte 
group by 1 having count(*) > 1


--- 12. Identify the artist and the museum where the most expensive and least expensive painting is placed. 
Display the artist name, sale_price, painting name, museum name, museum city and canvas label

with cte as 
		(select *
		, rank() over(order by sale_price desc) as rnk
		, rank() over(order by sale_price ) as rnk_asc
		from product_size )
		
		
	select w.name as painting
	, cte.sale_price
	, a.full_name as artist
	, m.name as museum, m.city
	, cz.label as canvas
	from cte
	join work w on w.work_id=cte.work_id
	join museum m on m.museum_id=w.museum_id
	join artist a on a.artist_id=w.artist_id
	join canvas_size cz on cz.size_id = cte.size_id::NUMERIC
	where rnk=1 or rnk_asc=1
	
	
13. Which artist has the most no of Portraits paintings outside USA?. Display artist name, no of paintings and the artist nationality.

select full_name as artist_name, nationality, no_of_paintings
	from (
		select a.full_name, a.nationality
		,count(1) as no_of_paintings
		,rank() over(order by count(1) desc) as rnk
		from work w
		join artist a on a.artist_id=w.artist_id
		join subject s on s.work_id=w.work_id
		join museum m on m.museum_id=w.museum_id
		where s.subject='Portraits'
		and m.country != 'USA'
		group by a.full_name, a.nationality) x
	where rnk=1;
						
		




