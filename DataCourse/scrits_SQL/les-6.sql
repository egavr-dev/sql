-- оператор DISTINCT для выбори уникальных значений.
select distinct
    rental_rate
from film;

-- посмотрим сколько у нас в таблице actor всего фамилий актеров
select 
    last_name
from actor;
-- всех 200

-- посмотрим сколько у нас в таблице actor уникальных фамилий актеров
select distinct
    last_name
from actor;
-- всех 121

-- посмотрим сколько у нас в таблице actor уникальных значений фамилий и имен актеров
select distinct
    last_name,
    first_name
from actor;
-- всех 199

-- Такой синтаксис специфичен для postgres не является стандартным для SQL
-- позволяет найти для уникальных рейтингов найти по одному любому описанию фильма
select distinct on (rental_rate)
    rental_rate,
    title 
from film;

-- чобы посмотреть отличие от такого кода
select distinct 
    rental_rate,
    title 
from film;


select distinct on (inventory_id)
    rental_id,
    rental_date,
    inventory_id,
    customer_id,
    return_date,
    staff_id,
    last_update
from
    rental;

select
    rental_id,
    rental_date,
    inventory_id,
    customer_id,
    return_date,
    staff_id,
    last_update
from
    rental
where inventory_id = 1;

-- Выбираем renrental_date в секции группировки для правильной 
-- выборки дат в distinct on (inventory_id)
-- будут выведены даты аренды именно последней сдачи в аренду конкретных дисков
select distinct on (inventory_id)
    rental_id,
    rental_date,
    inventory_id,
    customer_id,
    return_date,
    staff_id,
    last_update
from
    rental
order by inventory_id, rental_date desc;

-- Посмотрим таблицу платежей payment
-- хотим найти по каждому продавцу максимальный платеж который он проводил.
-- В группировке order by обязательно первым должно идти поле 
-- указанное в select distinct on (staff_id)
select distinct on (staff_id)
    staff_id,
    amount
from payment
order by staff_id, amount desc;

-- домашка по DISTINCT

-- Задача 1
select distinct
    rental_duration
from film

-- Задача 2
select distinct
    left(first_name, 3)
from actor
-- получилось 114 уникальных значений

-- Задача 3
select distinct on (customer_id)
    payment_id,
    customer_id,
    amount,
    payment_date
from payment
order by customer_id, amount DESC;
-- всего у нас в базе 599 уникальных покупателя

select
    payment_id,
    customer_id,
    amount,
    payment_date
from payment
order by customer_id, amount;

-- Разберемся с соединением таблиц JOIN

-- Создадим внутреннее соединение INNER JOIN
select * from film;

select * from language; 

select 
    f.title,
    l.name
from 
    film f                                -- используем псевдоним для удобства задания условий
inner join language l
    on f.language_id = l.language_id; -- условие соединения двух таблиц

select 
    f.title,
    l.name
from 
    film f
inner join language l
    on f.language_id = l.language_id
where f.title like 'C%';

-- получаем пары данных название фильма и имя актера который в нем снимался

-- данные в таблице film
select * from film f;

-- данные в таблице actor
select * from actor a;

select *
from film_actor fa
inner join actor a
    on fa.actor_id = a.actor_id
inner join film f 
    on fa.film_id = f.film_id;

select 
    f.title,
    a.first_name || ' ' || a.last_name 
from film_actor fa
inner join actor a
    on fa.actor_id = a.actor_id
inner join film f 
    on fa.film_id = f.film_id
order by f.title;

-- таблица с фильмами на дисках которые есть в наличии
select * from inventory i;

-- получим имя и фамилию актеров которые есть у нас дисках в магазинах
select distinct 
    a.first_name || ' ' || a.last_name as actor_name
from film_actor fa
inner join actor a
    on fa.actor_id = a.actor_id
inner join film f 
    on fa.film_id = f.film_id
inner join inventory i 
    on i.film_id = f.film_id 
order by 1;

select distinct 
    a.first_name || ' ' || a.last_name as actor_name
from film_actor fa
inner join actor a
    using (actor_id)
inner join film f 
    using (film_id)
inner join inventory i 
    using (film_id) 
order by 1;

-- Тепере получим список фильмов которых у нас нет в прокате
-- нам понадобится левое внешннее соединение LEFT OUTER JOIN

select f.title 
from film f
left outer join inventory i 
    using (film_id)
where i.inventory_id is NULL;

-- таже задача только для правого внешнего соединения RIGHT OUTTER JOIN
select f.title 
from inventory i
right outer join  film f
    using (film_id)
where i.inventory_id is NULL;

-- таже задача только для полного внешнего соединения FULL OUTER JOIN
select f.title 
from inventory i
full outer join  film f
    using (film_id)
where i.inventory_id is NULL;

-- получим все возможные пары фильмов и актеров вне зависимости снимался актер 
-- в фильме или нет.
-- Для этого используем "декартовым произведением" CROSS JOIN
select 
    f.title,
    a.first_name || ' ' || a.last_name as actor_name
from film f 
cross join actor a;

-- тот же результат получим так
select 
    f.title,
    a.first_name || ' ' || a.last_name as actor_name
from film f 
inner join actor a
    on true; -- тоесть указав услове соединения таблиц которое всегда истино
    
-- тот же результат получим так
select 
    f.title,
    a.first_name || ' ' || a.last_name as actor_name
from film f, actor a; -- просто перечислив соединяемые таблицы    
    
-- Посмотрим на "декартовым произведением" CROSS JOIN трех таблиц
select 
    f.title,
    a.first_name ||' ' || a.last_name as actor_name,
    c.name 
from film f 
cross join actor a
cross join category c; 

-- Мы выводили все возможные комбинации фильмов и актеров в нашей базе, 
-- используя декартово произведение, а теперь к этому выводу добавим колонку в 
-- которой будет отображаться, снимался в этом фильме этот актер или нет.

select 
    f.title,
    a.first_name || ' ' || a.last_name as actor_name,
    fa.actor_id is not null
from film f  
cross join actor a
left join film_actor fa
    on fa.film_id = f.film_id and
    fa.actor_id = a.actor_id;

-- такой же запрос
select 
    f.title,
    a.first_name || ' ' || a.last_name as actor_name,
    fa.actor_id is not null 
from film f 
cross join actor a
left outer join film_actor fa
    on fa.film_id = f.film_id and
    fa.actor_id = a.actor_id;

-- домашка по JOIN соединениям таблиц.
-- Задание 1 (JOIN)

select
    f.title,
    a.first_name,
    a.last_name 
from film f
inner join film_actor fa
    on fa.film_id = f.film_id
inner join actor a 
    on fa.actor_id = a.actor_id
order by title;

select
    f.title,
    a.first_name,
    a.last_name 
from film f
inner join film_actor fa
    on fa.film_id = f.film_id
inner join actor a 
    on fa.actor_id = a.actor_id
where f.title = 'Chamber Italian'
order by title;

-- Задание 2 (JOIN)

select 
    f.title
from film_category fc 
inner join film f 
    on f.film_id = fc.film_id
inner join category c 
    on c.category_id = fc.category_id 
where c.name = 'Comedy';

-- Задание 3 (JOIN)

select 
    f.title,
    c.name
from film_category fc 
inner join film f 
    on f.film_id = fc.film_id
inner join category c 
    on c.category_id = fc.category_id;

-- Задачи со звездочкой ***

-- Задание 1

select f.title, c.name, fc.category_id = c.category_id  
from film f
full join category c 
    on true
left outer join film_category fc
    on fc.film_id = f.film_id  
order by f.title;

select f.title, c.name, *
from film f
full join category c 
    on true
left outer join film_category fc
    on fc.film_id = f.film_id  
order by f.title;

select *
from film_category fc 
    
select *
from category c    
    
-- Задание 2

select 
    f.title
from film f 
left join  inventory i
    on f.film_id = i.film_id
where i.film_id is NULL;

select f.title,
    f.film_id,
    i.inventory_id 
from film f 
left join  inventory i
    on f.film_id = i.film_id
where title in('Wake Jaws');

-- узнаем типы данных, и другие метаданные о интересующих таблицах

select column_name, data_type, character_maximum_length, column_default, is_nullable
from INFORMATION_SCHEMA.COLUMNS where table_name = 'film';
