-- Получим план построения запроса
explain
select * 
from film f;

-- Запрос с условием записей в таблице
explain analyze
select * 
from film f
where f.length > 120;

-- Создадим индекс для оптимизации запроса из предыдущего примера
-- с фильтром поlength > 120
create index film_length_idx on film(length);

-- И посмотрим синтаксис удаления индекса
drop index film_length_idx;

-- Теперь создадим этот индекс, и попробуем для сравнения
-- результатов запустим предыдущий запрос с фильтром по length > 120
create index film_length_idx on film(length);

explain analyze
select * 
from film f
where f.length > 200;

-- Посмотрим на планировщик запроса. Создадим запрос который 
-- будет получать название фильма и сумму всех платежей по этому фильму
explain analyze
select 
    f.title,
    p.amount 
from 
    film f
join inventory i using(film_id)
join rental r using(inventory_id)
join payment p using(rental_id);

-- Домашние задания
-- Задача 1
explain analyze
select * 
from film f 
where f.rental_duration = 7;

create index film_rental_duration_idx on film(rental_duration);

explain analyze
select * 
from film f 
where f.rental_duration = 7;
