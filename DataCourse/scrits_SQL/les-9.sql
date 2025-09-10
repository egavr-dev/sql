-- Получаем первые пять десятков фильмов
select 
    f.title 
from film f
order by f.title
limit 50;

-- Получаем вторые пять десятков фильмов
select 
    f.title 
from film f
order by f.title
limit 50
offset 50;

-- Получаем с 501-ого фильма и до конца
select 
    f.title 
from film f
order by f.title
offset 500;

-- Второй вариант
select 
    f.title 
from film f
order by f.title
limit all
offset 500;

-- Третий вариант
select 
    f.title 
from film f
order by f.title
limit null
offset 500;

-- Задача 1 домашки
select 
    a.first_name || ' ' || a.last_name as first_last_name,
    count(f.film_id) as film_count
from film f
join film_actor fa 
    on f.film_id = fa.film_id 
join actor a 
    on fa.actor_id = a.actor_id 
group by a.actor_id
order by film_count desc
limit 5
offset 5;

-- можно сократить
select 
    a.first_name || ' ' || a.last_name as first_last_name,
    count(fa.film_id) as film_count
from film_actor fa 
join actor a 
    on fa.actor_id = a.actor_id 
group by a.actor_id
order by film_count desc, first_last_name
limit 5
offset 5;

-- Другой вариант (наиболее правильный вариант)
select 
    a.first_name || ' ' || a.last_name as first_last_name,
    count(fa.film_id) as film_count
from film_actor fa 
join actor a 
    on fa.actor_id = a.actor_id 
group by a.actor_id 
order by film_count desc, a.actor_id 
limit 5
offset 5;
