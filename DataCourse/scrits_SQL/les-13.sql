-- CTE (common table expression)

select *
from film f 

-- Создадим CTE (общее табличное выражением)
-- фильтрующее категории фильмов в которых 
-- болеше 70 фильмов

with filtered_category as (
    select
        fc.category_id,
        c.name as category_name,
        count(*) as film_count
    from 
        film_category fc 
        join category c 
            on fc.category_id = c.category_id 
    group by fc.category_id, c.name
    having count(*) > 70
)
-- теперь можем использовать названию filtered_category
-- как обычную таблицу в обычном SELECT запросе
select 
    f.title,
    c.category_name,
    c.film_count
from film f 
join film_category fc 
    on f.film_id = fc.film_id
join filtered_category c
    on c.category_id = fc.category_id;

-- отдельно сам запрос, хотя его можно выполнить
-- отдельно выделив и выполнив в DBeaver

select
    fc.category_id,
    c.name as category_name,
    count(*) as film_count
from 
     film_category fc 
     join category c 
        on fc.category_id = c.category_id 
group by fc.category_id, c.name
having count(*) > 70;

-- Видим что таких категорий всего две (у которых 
-- фильмов > 70)

-- Добавить общий объем выручки для каждого фильма 
-- из предыдущей выборки фильмов из категорий 
-- в которых больше 70-и фильмов.
-- Тоесть к первому CTE добавим второе CTE

with filtered_category as (
    select
        fc.category_id,
        c.name as category_name,
        count(*) as film_count
    from 
        film_category fc 
        join category c 
            on fc.category_id = c.category_id 
    group by fc.category_id, c.name
    having count(*) > 70
),
film_amount as (
    select
        i.film_id,
        sum(p.amount) as amount
    from inventory i
    join rental r
        on i.inventory_id = r.inventory_id 
    join payment p 
     on r.rental_id = p.rental_id
    group by 
        i.film_id
)
select 
    f.title,
    c.category_name,
    c.film_count,
    fa.amount
from film f 
join film_category fc 
    on f.film_id = fc.film_id
join filtered_category c
    on c.category_id = fc.category_id
left join film_amount fa
    on f.film_id = fa.film_id;

with filtered_category as (
    select
        fc.category_id,
        c.name as category_name,
        count(*) as film_count
    from 
        film_category fc 
        join category c 
            on fc.category_id = c.category_id 
    group by fc.category_id, c.name
    having count(*) > 70
),
film_amount as (
    select
        i.film_id,
        sum(p.amount) as amount
    from inventory i
    join rental r
        on i.inventory_id = r.inventory_id 
    join payment p 
     on r.rental_id = p.rental_id
    group by 
        i.film_id
)
select 
    f.title,
    c.category_name,
    c.film_count,
    coalesce(fa.amount, 0) as film_amount -- что бы не было значений NULL
from film f 
join film_category fc 
    on f.film_id = fc.film_id
join filtered_category c
    on c.category_id = fc.category_id
left join film_amount fa
    on f.film_id = fa.film_id;

-- добавим к запросу всю сумму выручки по выбранным фильмам
with filtered_category as (
    select
        fc.category_id,
        c.name as category_name,
        count(*) as film_count
    from 
        film_category fc 
        join category c 
            on fc.category_id = c.category_id 
    group by fc.category_id, c.name
    having count(*) > 70
),
film_amount as (
    select
        i.film_id,
        sum(p.amount) as amount
    from inventory i
    join rental r
        on i.inventory_id = r.inventory_id 
    join payment p 
     on r.rental_id = p.rental_id
    group by 
        i.film_id
),
total_amount as (
    select sum(fa.amount) as total_amount
    from film_amount fa
)
select 
    f.title,
    c.category_name,
    c.film_count,
    coalesce(fa.amount, 0) as film_amount,
    (select total_amount from total_amount)
from film f 
join film_category fc 
    on f.film_id = fc.film_id
join filtered_category c
    on c.category_id = fc.category_id
left join film_amount fa
    on f.film_id = fa.film_id;

-- Тот же запрос но с явным указанием создавать либо нет
-- временную таблицу в памяти базы данных (MATERIALIZED)  
-- или (NOT MATERIALIZED)
with filtered_category as materialized (
    select
        fc.category_id,
        c.name as category_name,
        count(*) as film_count
    from 
        film_category fc 
        join category c 
            on fc.category_id = c.category_id 
    group by fc.category_id, c.name
    having count(*) > 70
),
film_amount as not materialized (
    select
        i.film_id,
        sum(p.amount) as amount
    from inventory i
    join rental r
        on i.inventory_id = r.inventory_id 
    join payment p 
     on r.rental_id = p.rental_id
    group by 
        i.film_id
),
total_amount as not materialized (
    select sum(fa.amount) as total_amount
    from film_amount fa
)
select 
    f.title,
    c.category_name,
    c.film_count,
    coalesce(fa.amount, 0) as film_amount,
    (select total_amount from total_amount)
from film f 
join film_category fc 
    on f.film_id = fc.film_id
join filtered_category c
    on c.category_id = fc.category_id
left join film_amount fa
    on f.film_id = fa.film_id;

-- Домашняя работа 

-- Задача 1

with count_actor as (
    select 
        f.film_id,
        count(fa.actor_id) as count_actor
    from film f
    left join film_actor fa 
        on f.film_id = fa.film_id
    group by f.film_id
),
sum_payment_amount as (
    select 
        f.film_id,
        (
         case when sum(p.amount) is null then 0
         else sum(p.amount) 
         end
        ) as sum_amount
    from film f 
    left join inventory i 
        on f.film_id = i.film_id 
    left join rental r 
        on i.inventory_id = r.inventory_id
    left join payment p
        on r.rental_id = p.rental_id
    group by f.film_id 
)
select f.title, ca.count_actor, sa.sum_amount
from film f 
join count_actor ca
    on f.film_id = ca.film_id
join sum_payment_amount sa
    on f.film_id = sa.film_id;

-- Задача 2

with sum_payment_amount as (
    select 
        f.film_id,
        (
         case when sum(p.amount) is null then 0
         else sum(p.amount) 
         end
        ) as sum_amount
    from film f 
    left join inventory i 
        on f.film_id = i.film_id 
    left join rental r 
        on i.inventory_id = r.inventory_id
    left join payment p
        on r.rental_id = p.rental_id
    group by f.film_id 
),
total_amount as (
    select sum(sa.sum_amount)
    from sum_payment_amount sa
)
select 
    f.title, 
    sa.sum_amount as sum_amount,
    (select * from total_amount) as total_sum,
    (sum_amount / (select * from total_amount)) * 100 prosent_amount
from film f 
join sum_payment_amount sa
    on f.film_id = sa.film_id;

-- test с разбора домашки
select fa.film_id, count(fa.actor_id)
from film_actor fa
group by fa.film_id
