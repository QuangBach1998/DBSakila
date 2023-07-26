-- ++++++++++++++++++++++++++++++++++++++++++++++++++++ level 1 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++:
-- câu 1: trả về họ và tên của tất cả các diễn viên
SELECT concat(first_name,' ',last_name) as full_name FROM actor;
-- câu 2: trả về tiêu đề của tất cả các bộ phim trong cơ sở dữ liệu, cùng với giá thuê và chi phí thay thế của chúng.
SELECT title from film;
-- câu 3: trả về 5 bộ phim được thuê nhiều nhất trong cơ sở dữ liệu, cùng với số lần chúng được thuê.
SELECT f.title AS film_title,COUNT(r.rental_id) AS rental_count
FROM film f JOIN inventory i ON f.film_id = i.film_id JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.title
ORDER BY
rental_count DESC
LIMIT 5;
-- câu 4: trả về thời lượng thuê trung bình cho từng danh mục phim trong cơ sở dữ liệu.
SELECT c.name as category_name , avg(f.rental_duration) as avg_rental_duration
from  film f join film_category fc on f.film_id = fc.film_id
join category c on c.category_id = fc.category_id
GROUP BY c.name;
-- câu 5: trả về tên và địa chỉ của tất cả khách hàng đã thuê phim trong tháng 5 năm 2005 (đề bài gốc ko có dữ liệu năm 2022).
SELECT concat(c.first_name,' ',last_name) as full_name, a.address as address
FROM customer c join address a on c.address_id = a.address_id join rental r on c.customer_id = r.customer_id
WHERE  EXTRACT(MONTH FROM r.rental_date) = 5
AND EXTRACT(YEAR FROM r.rental_date) = 2005;
-- câu 6: trả về doanh thu do mỗi cửa hàng tạo ra trong cơ sở dữ liệu cho năm 2005 (đề bài gốc ko có dữ liệu năm 2021).
SELECT s.store_id as store_id,
SUM(p.amount) as revenue FROM store s 
join staff st on s.store_id = st.store_id 
join payment p on st.staff_id = p.staff_id
WHERE EXTRACT(YEAR FROM p.payment_date) = 2005 GROUP BY s.store_id;
-- câu 7: trả về tên của tất cả các diễn viên đã xuất hiện trong hơn 20 bộ phim trong cơ sở dữ liệu.
SELECT concat(first_name,' ',last_name) as actor_name
FROM actor a join film_actor fa on a.actor_id = fa.actor_id
group by a.actor_id,actor_name
having count(fa.actor_id)>20;
-- câu 8: trả về tiêu đề của tất cả các phim trong cơ sở dữ liệu có xếp hạng 'PG-13' và thời lượng hơn 120 phút.
SELECT title from film WHERE film.rating = 'PG-13' and film.length>120;

-- ++++++++++++++++++++++++++++++++++++++++++++++++++++ level 2 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- câu 1: trả về 10 khách hàng hàng đầu đã tạo ra nhiều doanh thu nhất cho cửa hàng, bao gồm tên của họ và tổng doanh thu được tạo ra.
select concat(c.first_name,' ',c.last_name) as customer_name ,
sum(p.amount) as totalAmount
from customer c join payment p on c.customer_id = p.customer_id
group by c.customer_id,customer_name order by totalAmount desc
limit 10;
-- câu 2: trả về tên và thông tin liên hệ của tất cả khách hàng đã thuê phim ở tất cả các danh mục trong cơ sở dữ liệu.
select distinct (concat(c.first_name,' ',c.last_name)) as customer_name,
a.phone as  dien_thoai_lien_he
from customer c join rental r on c.customer_id =r.customer_id join address a on c.address_id = a.address_id;
-- câu 3: trả về tiêu đề của tất cả các phim trong cơ sở dữ liệu đã được thuê ít nhất một lần nhưng không bao giờ trả lại.
select DISTINCT f.title
from film f join inventory i on f.film_id = i.film_id
join rental r on i.inventory_id = r.inventory_id where r.return_date is null; 
-- câu 4: trả về tên của tất cả các diễn viên đã xuất hiện trong ít nhất một bộ phim trong mỗi danh mục trong cơ sở dữ liệu.
select DISTINCT concat(a.first_name,' ',a.last_name) as actor_name
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id;
-- câu 5: trả về tên của tất cả các khách hàng đã thuê cùng một bộ phim nhiều lần trong một giao dịch, cùng với số lần họ đã thuê bộ phim đó.
SELECT CONCAT(c.first_name, ' ', c.last_name) AS customer_name, 
COUNT(*) AS rental_count
FROM rental r
JOIN customer c ON r.customer_id = c.customer_id
GROUP BY customer_name
HAVING COUNT(*) > 1;
-- câu 6: trả về tổng doanh thu do mỗi diễn viên tạo ra trong cơ sở dữ liệu, dựa trên phí thuê phim mà họ đã xuất hiện.
SELECT CONCAT(a.first_name, ' ', a.last_name) AS actor_name,
SUM(f.rental_rate) AS total_revenue
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
GROUP BY actor_name
ORDER BY total_revenue DESC;
-- câu 7: trả về tên của tất cả các diễn viên đã xuất hiện trong ít nhất một bộ phim có xếp hạng 'R', nhưng chưa bao giờ xuất hiện trong một bộ phim có xếp hạng 'G'.
select DISTINCT concat(a.first_name,' ',a.last_name) as actor_name
from actor a join film_actor fa on a.actor_id = fa.actor_id join film f on fa.film_id = f.film_id
where f.rating = 'R' and f.rating != 'G';
-- câu 8: trả về tiêu đề của tất cả các phim trong cơ sở dữ liệu đã được thuê bởi hơn 50 khách hàng, nhưng chưa bao giờ được thuê bởi cùng một khách hàng nhiều lần.
select distinct f.title
from film f
join inventory i ON f.film_id = i.film_id
join rental r ON i.inventory_id = r.inventory_id
group by f.title
HAVING COUNT(DISTINCT r.customer_id) > 50
AND COUNT(DISTINCT r.rental_id) = COUNT(r.customer_id);
-- câu 9: trả về tên của tất cả các khách hàng đã thuê phim từ danh mục mà họ chưa từng thuê trước đó.
select concat(c.first_name,' ', c.last_name) as full_name
from customer c  join rental r on c.customer_id = r.customer_id 
join inventory i on i.inventory_id = r.inventory_id
join film f on i.film_id = f.film_id
where f.film_id not in(select f2.film_id
    FROM customer c2
    JOIN rental r2 ON c2.customer_id = r2.customer_id
    JOIN inventory i2 ON r2.inventory_id = i2.inventory_id
    JOIN film f2 ON i2.film_id = f2.film_id
    WHERE c2.customer_id = c.customer_id);
-- câu 10: trả về tiêu đề của tất cả các phim trong cơ sở dữ liệu đã được thuê bởi mọi khách hàng đã từng thuê phim từ danh mục 'Hành động'.    
SELECT f.title
FROM film f
WHERE NOT EXISTS (
    SELECT c.customer_id
    FROM customer c
    JOIN rental r ON c.customer_id = r.customer_id
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film_category fc ON i.film_id = fc.film_id
    JOIN category cat ON fc.category_id = cat.category_id
    WHERE cat.name = 'Action' AND NOT EXISTS (
        SELECT 1
        FROM rental r2
        JOIN inventory i2 ON r2.inventory_id = i2.inventory_id
        WHERE c.customer_id = r2.customer_id AND i.film_id = i2.film_id
    )
);

-- ++++++++++++++++++++++++++++++++++++++++++++++++++++ level 3 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- câu 1: trả về thời lượng thuê trung bình cho từng tổ hợp diễn viên và danh mục trong cơ sở dữ liệu, 
-- ngoại trừ các diễn viên chưa xuất hiện trong bất kỳ phim nào trong danh mục.
select  concat(a.first_name,' ',a.last_name) as full_name
,c.name as category_name,
avg(timestampdiff(hour,r.rental_date,r.return_date)) as avg_duration
from actor a join film_actor fa on a.actor_id = fa.actor_id
join film_category fc on fa.film_id = fc.film_id
join category c on fc.category_id = c.category_id
join inventory i ON fc.film_id = i.film_id
join rental r ON i.inventory_id = r.inventory_id
group by a.first_name, a.last_name, c.name
having COUNT(DISTINCT fc.film_id) > 0;
-- câu 2: trả về tên của tất cả các diễn viên đã xuất hiện trong một bộ phim có xếp hạng 'R' 
-- và thời lượng hơn 2 giờ, nhưng chưa bao giờ xuất hiện trong một bộ phim có xếp hạng 'G'.
SELECT DISTINCT CONCAT(a.first_name, ' ', a.last_name) AS full_name
FROM actor a
join film_actor fa ON a.actor_id = fa.actor_id
join film f ON fa.film_id = f.film_id where f.rating = 'R' AND f.length > 120
AND not exists (SELECT 1 FROM film f2 join film_actor fa2 on f2.film_id = fa2.film_id
    JOIN actor a2 ON fa2.actor_id = a2.actor_id
    WHERE f2.rating = 'G' AND a.actor_id = a2.actor_id
);
-- câu 3: trả về tên của tất cả khách hàng đã thuê hơn 10 bộ phim trong một giao dịch, cùng với số lượng phim họ đã thuê và tổng phí thuê.
select c.customer_id, concat(c.first_name,' ',c.last_name) as full_name,
COUNT(r.rental_id) as total_film_rental,
sum(p.amount) as total_fee
from customer c join rental r on c.customer_id = r.customer_id
join payment p on r.rental_id = p.rental_id group by c.customer_id,full_name
HAVING count(r.rental_id)>10;
-- câu 4:  trả về tên của tất cả các khách hàng đã thuê mọi bộ phim trong một danh mục, cùng với tổng số phim đã thuê và tổng phí thuê.
select concat(c.first_name,' ',c.last_name) as full_name,  count(distinct i.film_id) as total_film_rental
, sum(p.amount) as total_fee
from customer c join rental r on c.customer_id = r.customer_id
join payment p on r.rental_id = p.rental_id
join inventory i on r.inventory_id = i.inventory_id
join film_category fc on fc.film_id = i.film_id
where fc.category_id = 2
group by c.customer_id , full_name;
-- câu 5: trả về tiêu đề của tất cả các phim trong cơ sở dữ liệu đã được cùng một khách hàng thuê nhiều lần trong một ngày, 
-- cùng với tên của những khách hàng đã thuê phim và số lần họ thuê.
SELECT f.title , concat(c.first_name,' ',c.last_name) as full_name, count(*) as total_rental
from film f join inventory i on f.film_id = i.film_id
join rental r on i.inventory_id= r.inventory_id
join customer c on c.customer_id = r.customer_id
WHERE  date(r.rental_date)= date(now())
GROUP BY f.title,full_name
having count(*)>1;
-- câu 6: trả về tên của tất cả các diễn viên đã xuất hiện trong ít nhất một bộ phim cùng với mọi diễn viên khác trong cơ sở dữ liệu,
-- cùng với số lượng phim họ đã xuất hiện cùng nhau.
select concat(a1.first_name,' ',a1.last_name) as actor_name1 ,
concat(a2.first_name,' ',a2.last_name) as actor_name2,
count(DISTINCT f1.film_id) as total_show_together
from actor a1
join film_actor fa1 on a1.actor_id = fa1.actor_id
join film f1 on fa1.film_id = f1.film_id
join film_actor fa2 on fa1.film_id = fa2.film_id and fa1.actor_id != fa2.actor_id
join actor a2 on a2.actor_id  = fa2.actor_id
group by actor_name1, actor_name2
order by total_show_together desc;
-- câu 7: trả về tên của tất cả khách hàng đã thuê ít nhất một phim từ mỗi danh mục trong cơ sở dữ liệu, 
-- cùng với số lượng phim đã thuê từ mỗi danh mục.
select concat(c.first_name,' ',c.last_name) as customer_name,
count(DISTINCT r.inventory_id) as total_film_rentaled,
count(DISTINCT fc.category_id)  as total_category_rentaled
from customer c 
join rental r on c.customer_id = r.customer_id
join  inventory i on r.inventory_id = i.inventory_id
join film_category fc on fc.film_id = i.film_id
group by c.customer_id , customer_name
having count(distinct fc.category_id) = (select count(*) from category);
-- câu 8: trả về tiêu đề của tất cả các phim trong cơ sở dữ liệu đã được thuê hơn 30 lần, 
-- nhưng chưa bao giờ được thuê bởi bất kỳ khách hàng nào đã thuê phim có xếp hạng 'G'.
select DISTINCT(f.title) as title_of_film from film f
join inventory i on i.film_id = f.film_id
left join rental r on i.inventory_id = r.inventory_id
left join (select r2.inventory_id from rental r2 join inventory i2 on i2.inventory_id = r2.inventory_id
join film f2  on f2.film_id =i2.film_id where f2.rating = 'G') g on i.inventory_id = g.inventory_id
where g.inventory_id is null
group by f.film_id,f.title having count(r.inventory_id)>30;
-- câu 9: trả về tên của tất cả các khách hàng đã thuê phim từ danh mục mà họ chưa bao giờ thuê trước đây
-- và cũng chưa bao giờ thuê phim dài hơn 3 giờ.
select concat(c.first_name,' ',c.last_name) as customer_name from customer c
join rental r on c.customer_id = r.customer_id
join inventory i on r.inventory_id = i.inventory_id
join film_category fc on fc.film_id = i.film_id
join film f on f.film_id = fc.film_id where f.length <=180
	and fc.category_id not in (
     select fc1.category_id
    from film_category fc1
    join inventory i1 ON fc1.film_id = i1.film_id
    join rental r1 ON i1.inventory_id = r1.inventory_id
    JOIN customer c1 ON r1.customer_id = c1.customer_id
    where c1.customer_id = c.customer_id);
-- câu 10: trả về tên của tất cả các diễn viên đã xuất hiện trong một bộ phim có xếp hạng 'PG-13' và thời lượng hơn 2 giờ, 
-- đồng thời cũng đã xuất hiện trong một bộ phim có xếp hạng 'R' và thời lượng dưới 90 phút.
select concat(a.first_name,'',a.last_name) as actor_name from actor a 
join film_actor fa on a.actor_id = fa.actor_id join film f on f.film_id = fa.film_id
where f.rating = 'PG-13' and f.length >120
and exists (select 1
FROM actor a1 join film_actor fa1 on a1.actor_id = fa1.actor_id
join film f1 on f1.film_id = fa1.film_id
where f1.rating = 'R' and f1.length < 90);

-- ++++++++++++++++++++++++++++++++++++++++++++++++++++ level 4 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- câu 1: cập nhật giá thuê của tất cả các phim trong cơ sở dữ liệu đã được thuê hơn 100 lần, 
-- đặt giá thuê mới cao hơn 10% so với giá hiện tại.
update film 
inner join(
select f.film_id from film f join inventory i on f.film_id = i.film_id 
join rental r on r.inventory_id = i.inventory_id
group by f.film_id having count(r.rental_id) > 100)
AS subquery ON film.film_id = subquery.film_id
SET rental_rate = rental_rate * 1.1;
-- câu 2: cập nhật thời lượng thuê của tất cả các phim trong cơ sở dữ liệu đã được thuê hơn 5 lần, 
-- đặt thời lượng mới dài hơn 5% so với thời lượng hiện tại.
update film set 
length = length+ (length*0.05)
where film_id in(
select film_id from rental GROUP BY film_id having count(*)>5);
-- câu 3: cập nhật giá thuê của tất cả các phim trong danh mục 'Hành động' được phát hành trước năm 2005, 
-- đặt giá mới cao hơn 20% so với giá hiện tại.
update film f join(
select f.film_id from film f join film_category fc on f.film_id = fc.film_id
join category c on fc.category_id = c.category_id
where c.name ='Action' and f.release_year<2005
) s on f.film_id = s.film_id set f.rental_rate = f.rental_rate+(f.rental_rate*1.2);
-- câu 4: cập nhật địa chỉ email của tất cả khách hàng đã thuê phim từ danh mục 'Kinh dị' trong tháng 10 năm 2022, 
-- đặt địa chỉ email mới là sự kết hợp giữa địa chỉ email hiện tại của họ và chuỗi 'kinh dị'.
UPDATE customer
SET email = CONCAT(email, 'horrorlover')
WHERE customer_id IN (
SELECT customer_id
FROM (SELECT c.customer_id FROM customer c
join rental r ON c.customer_id = r.customer_id	
join inventory i ON r.inventory_id = i.inventory_id
join film f ON i.film_id = f.film_id
join film_category fc ON f.film_id = fc.film_id	
join category cat ON fc.category_id = cat.category_id	where cat.name = 'Horror'
AND YEAR(r.rental_date) = 2022 AND MONTH(r.rental_date) = 10
) subquery);
-- câu 5: cập nhật giá thuê của tất cả các phim trong cơ sở dữ liệu đã được hơn 10 khách hàng thuê, 
-- đặt giá mới cao hơn 5% so với giá hiện tại, nhưng không cao hơn $4,00.
update film set rental_rate = case when rental_rate*1.05<=4 then rental_rate * 1.05 else 4.00 end
where film_id in (
select film_id from rental GROUP BY film_id
having count(DISTINCT customer_id)>10);
-- câu 6: cập nhật giá thuê của tất cả các phim trong cơ sở dữ liệu có xếp hạng 'PG-13' 
-- và thời lượng hơn 2 giờ, đặt giá mới là $3,5.
update film set rental_rate = 3.5
where rating = 'PG-13' AND length > 120;
-- câu 7: cập nhật thời lượng cho thuê của tất cả các phim trong danh mục 'Khoa học viễn tưởng' được phát hành vào năm 2010
-- ,đặt thời lượng mới bằng với thời lượng của phim tính bằng phút.
update film f join (
select f.film_id
from film f join film_category fc on f.film_id = fc.film_id
join category c on fc.category_id = c.category_id
where c.name = 'Sci-Fi' and f.release_year = 2010 ) s
on f.film_id = s.film_id
SET rental_duration = length;
-- câu 8: cập nhật địa chỉ của tất cả các khách hàng sống trong cùng thành phố với một khách hàng khác có cùng họ
-- đặt địa chỉ mới là phần nối của địa chỉ hiện tại của họ và chuỗi 'samecity'.
update customer as c1
join customer AS c2 ON c1.last_name = c2.last_name AND c1.customer_id <> c2.customer_id
join address AS a1 ON c1.address_id = a1.address_id
join address AS a2 ON c2.address_id = a2.address_id
set a1.address = CONCAT(a1.address, ' samecity')
where a1.city_id = a2.city_id;
-- câu 9: cập nhật giá thuê của tất cả các phim trong danh mục 'Comedy' được phát hành vào năm 2007 trở đi, 
-- đặt giá mới thấp hơn 15% so với giá hiện tại.
update film
set rental_rate = rental_rate * 0.85
where film_id IN (
select film.film_id
from film join film_category ON film.film_id = film_category.film_id
join category ON film_category.category_id = category.category_id
where category.name = 'Comedy' AND YEAR(film.release_year) >= 2007
);
-- câu 10: cập nhật giá thuê của tất cả các phim trong cơ sở dữ liệu có xếp hạng 'G' và thời lượng dưới 1 giờ, đặt giá mới là $1,50.
UPDATE film
SET rental_rate = 1.50
WHERE rating = 'G' AND length < 60;



