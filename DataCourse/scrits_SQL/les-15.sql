-- Порядок выполнения частей запроса
select 
    f.title,
    f.rating,
    count(f.rating) over(partition by f.rating) as film_rating_cnt
from film f 
limit 10;

-- Напишем общее табличное выражение, которое для каждого film_id фильмов 
-- рассчитает сумму продаж

-- 1 with
with film_amount as (
    select 
        i.film_id,
        sum(p.amount) as total_amount
    from 
        inventory i 
    join rental r using (inventory_id)
    join payment p using (rental_id)
    group by i.film_id
)
-- 6 SELECT и тут же оконки OVER
-- 7 DISTINCT
select distinct 
    substring(f.title, 1, 3) as short_title,
    f.rental_duration,
    count(*) over(partition by f.rental_duration) as rent_dur_film_cnt,
    sum(fa.total_amount) as total_amount
-- 2 FROM
from
    film f
join film_amount fa using (film_id)
-- 3 WHERE
where 
    f.rating = 'G'
-- 4 GROUP BY
group by
    substring(f.title, 1, 3),
    f.rental_duration
-- 5 HAVING
having 
    count(*) = 1
-- 8 ORDER BY
order by 
    total_amount 
-- 9 LIMIT и OFFSET
limit 10
offset 5;
