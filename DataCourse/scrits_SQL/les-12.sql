-- Подзапросы

-- найдем каких идентификаторов (address.address_id)
--- нет в (customer.address_id)
-- функция not exists()
select *
from 
    address a 
where
    not exists(
        select 1  -- что бы не нагружать базу запрашивая дополнительно данные из таблицы
        from customer c 
        where
            c.address_id = a.address_id 
    );
-- Это был коррелированный запрос
  
select *
from address a;

select *
from customer c;

-- Функция IN

-- получим все фильмы, из категорий в которых, больше 70-и фильмов суммарно.
-- отдельно подзапрос для задачи в примере
select 
    fc.category_id,
    count(*)
from film_category fc 
group by 
    fc.category_id
having count(*) > 70;

-- сам запрос
select 
    f.title,
    c.name 
from film f 
join film_category fc
    on f.film_id = fc.film_id 
join category c 
    on fc.category_id  = c.category_id 
where 
    c.category_id in (
                        select 
                            fc.category_id
                        from film_category fc 
                        group by 
                            fc.category_id
                        having count(*) > 70
                     );

-- Получаемые значения в вункции IN
select 1 in (1, 2); -- true
select 1 in (2, 3); -- false

select 1 in (1, 2, null); -- true
select 1 in (2, 3, null); -- NULL
select null in (1, 2, null); -- NULL
select null in (2, 3); -- NULL

-- Функция ANY() SOME() они идентичны

-- Выведем для начала все возможные платежи которые у нас
-- в порядке возростания (от самого маленького).
select  
    p.amount 
from 
    payment p
order by 
    p.amount;
-- видим самый маленький у нас нуль

-- мы хотим исключить самый маленький платеж из всех имеющихся в базе
-- ранее мы выяснили что это платеж с нулем
select 
    p.amount 
from 
    payment p 
where
    p.amount > any (    -- если хотя-бы одно сравнение окажется 
        select distinct -- истина, то результат any тоже истина  
            p2.amount 
        from payment p2
    )
order by 
    p.amount;

-- Функция ALL()
-- мы хотим найти самые крупные платеж из всех имеющихся в базе
select 
    p.amount 
from 
    payment p 
where
    p.amount >= all (    -- если хотя-бы одно сравнение окажется 
        select distinct -- лож, то результат ALL тоже лож  
            p2.amount 
        from payment p2
    )
order by 
    p.amount;

-- Хорошая практика использования подзапросов, при расчете значения 
-- поля в сеции select.
select 
    f.title,
    f.rating,
    (
        select 
            count(*)
        from 
            film f2
        where
            f2.rating = f.rating 
    ) as film_rating_count,
    (
        select count(*)
        from film f3
    ) as film_all_count,
    (
        select c.name
        from film_category fc
        join category c 
            on fc.category_id = c.category_id 
        where fc.film_id = f.film_id 
    ) as category_name
from film f;

-- Получим список всех фильмов в которых снялось
-- больше 10 актеров, с использованием подзапросов

select
    fa.film_id
from film_actor fa
group by fa.film_id 
having count(fa.actor_id) > 10;

-- используем подзапрос в секции where

select f.title 
from film f
where 
    10 < (
        select count(*)
        from film_actor fa 
        where fa.film_id  = f.film_id 
    );

-- используем подзапрос в секции from
select f.title, fi.actor_count 
from film f
join (
    select
    fa.film_id,
    count(fa.actor_id) as actor_count
    from film_actor fa
    group by fa.film_id 
    having count(fa.actor_id) > 10
) as fi
    on fi.film_id = f.film_id;

-- Еще пример используем подзапрос в секции from
select f.title, f.rating, fr.cnt 
from film f 
join (
    select 
        f.rating, 
        count(*) as cnt
    from film f
    group by f.rating 
) as fr
    on f.rating = fr.rating;

-- Домашняя работа

-- задача 1
select l.name
from language l 
where not exists (
    select 1
    from film f 
    where f.language_id = l.language_id
);

-- задача 2
select a.actor_id
from actor a 
where a.last_name like('Chase%');

select f.title
from film f 
join film_actor fa
    on f.film_id = fa.film_id
where fa.actor_id in 
    (
        select a.actor_id
        from actor a 
        where a.last_name like('Chase%')
    );

-- задача 3
select 
    f.title,
    (
        select l.name
        from language l
        where l.language_id = f.language_id
    )
from film f;

-- задача 4
select
    f2.rental_duration, 
    count(*) as count
from film f2
group by
      f2.rental_duration;

select 
    f.title,
    f.rental_duration,
    film_2.count 
from film f
join 
    (
        select
            f2.rental_duration, 
            count(*) as count
        from film f2
        group by
            f2.rental_duration 
    ) as film_2
    on f.rental_duration = film_2.rental_duration;
