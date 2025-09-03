-- Группировки. Group By, Having

-- Первая группировка

select 
    rating
from film f 
group by 
    rating; 

-- аналогичный запрос по выводим данным

select distinct 
    rating
from film f;

-- но на саммо деле появляются дополнительные возможности работы с 
-- группами при группировке используя функции группировок


-- Функция COUNT()
select 
    rating,
    count(*)
from film f 
group by 
    rating; 

-- Функция SUM()
select 
    rating,
    count(*) films_count,
    sum(length) total_lenght
from film f 
group by 
    rating; 

-- Функция MAX()
select 
    rating,
    count(*) films_count,
    sum(length) total_lenght,
    max(length) max_lenght
from film f 
group by 
    rating; 

-- Функция MIN()
select 
    rating,
    count(*) films_count,
    sum(length) total_lenght,
    min(length) min_lenght
from film f 
group by 
    rating; 

-- Функция AVG()
select 
    rating,
    count(*) films_count,
    avg(length) avg_lenght
from film f 
group by 
    rating; 

-- Функция BOOL_AND()
select 
    rating,
    count(*) films_count,
    max(length) max_lenght,
    bool_and(length < 185) 
from film f 
group by 
    rating; 

-- Функция BOOL_OR()
select 
    rating,
    count(*) films_count,
    max(length) max_lenght,
    bool_or(length >= 185) 
from film f 
group by 
    rating; 

-- Функция STRING_AGG()

select 
    rating,
    count(*) films_count,
    string_agg(title, '; ')
from film f 
group by 
    rating;

-- применение группировочных функций без указания group by
select 
    count(*) films_count
from film f;

-- группировка по нескольким полям сразу
select 
    rating,
    rental_rate,
    count(*)
from film f
group by
    rating,
    rental_rate
order by
    rating,
    rental_rate;

-- группировка по вычисляемым выражениям.
select 
    rating,
    rental_rate,
    substr(title, 1, 1),
    count(*)
from film f
group by
    rating,
    rental_rate,
    substr(title, 1, 1)
order by
    rating,
    rental_rate;

-- посмотрим сколько у нас дисков во всех магазинах каждого фильма
select 
    f.title,
    count(*)
from inventory i
join film f
    on  f.film_id = i.film_id 
group by f.title;

-- посмотрим сколько у нас дисков по всем возможным фильмам
select 
    f.title,
    count(*)
from  film f
left join inventory i
    using(film_id) -- аналогично on  f.film_id = i.film_id 
group by f.title;

-- посмотрим сколько у нас дисков по всем возможным фильмам
select 
    f.title,
    count(i.film_id) -- что бы функция count() не считала строки со значением NULL
from  film f
left join inventory i
    using(film_id)
group by f.title;

-- для каждого актера посчитаем в скольких фильмах он снимался, 
-- и в скольки категориях фильмов он снимался
select 
    a.first_name || ' ' || a.last_name,
    count(*) as films_count,
    count(distinct fc.category_id) -- расчет коли-ва уникальных категорий фильмов
from actor a
join film_actor fa 
    using (actor_id)
join film_category fc 
    on fa.film_id = fc.film_id 
group by
    a.first_name || ' ' || a.last_name;

-- Посмотрим как происходит выборка по условию (HAVING) в сочитании с группирокой (GROUP BY)
select 
    f.title,
    count(*) as payment_count
from film f
join inventory i 
    on f.film_id = i.film_id
join rental r 
    on r.inventory_id = i.inventory_id 
join payment p 
    on p.rental_id = r.rental_id 
where f.rental_rate > 2
group by 
    title
having count(*) > 10
order by 
    payment_count;

-- По каждому актеру найдем количество фильмов с рейтингом G 
-- в которых он снимался.
select 
    a.first_name || ' ' || a.last_name as actor_name,
   count(*)
from actor a 
left join film_actor fa 
    on a.actor_id = fa.actor_id
left join film f 
    on fa.film_id = f.film_id
where f.rating = 'G'
group by 
    actor_name;

-- Так мы отсеем всех других актеров которые снимались в других рейтингах
-- а нам хотелось бы для них выводить что 0 фильмов с рейтенгом 'G'
select 
    a.first_name || ' ' || a.last_name as actor_name,
    count(f.title )
from actor a 
left join film_actor fa 
    on a.actor_id = fa.actor_id
left join film f 
    on fa.film_id = f.film_id
    and f.rating = 'G'
group by 
    actor_name;
