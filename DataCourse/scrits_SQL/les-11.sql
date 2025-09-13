-- Фильтрация в агрегатных функциях Filter

-- сколько всего в таблице film строк с фильмами
select 
    count(*)
from film f;

-- сколько всего в таблице film строк с фильмами 
-- продолжительность больше 100
select 
    count(*)
from film f
where 
    f.length > 100;

-- объединим оба показателя в одном запросе используя FILTER()
select 
    count(*),
    count(*) filter(where f.length > 100)
from film f;

-- Использование FILTER() совместно с GROUP by группировками
select
    f.rating,
    count(*),
    count(*) filter(where f.length > 100)
from film f
group by f.rating;

-- Домашнее задание одна задача
-- 
select 
    f.rating,
    count(*),
    count(*) filter(where f.rental_duration >= 5)
from film f
group by f.rating;

-- Для проверки
select 
    f.rating,
    f.rental_duration,
    count(*)
from film f
group by f.rating, rental_duration
order by rating, rental_duration;
