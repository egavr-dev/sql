-- Мы уже ни раз, писали запрос получения общей суммы продаж наших дисков.
-- Создадим Представления (VIEW) для такого нужного запроса.

create view film_amount as
select 
    f.film_id,
    sum(p.amount) as sum_amount
from film f 
left join inventory i on f.film_id = i.film_id
left join rental r on i.inventory_id = r.inventory_id
left join payment p on r.rental_id = p.rental_id
group by f.film_id;

-- Теперь можем запрашивать данные из этого представления (VIEW)
-- как из простой таблицы

select * from film_amount fa;

-- Это будет нематериализованное Представления (VIEW)
-- Тоесть, каждый раз при обрашении к VIEW будет выполнятся
-- само тело VIEW 

-- Есть такая вешь как план построения запроса выводится при
-- помощи ключевого слова explain

explain
select * from film_amount fa;

explain
select 
    f.film_id,
    sum(p.amount) as sum_amount
from film f 
left join inventory i on f.film_id = i.film_id
left join rental r on i.inventory_id = r.inventory_id
left join payment p on r.rental_id = p.rental_id
group by f.film_id;

-- Видим что по плану выполнения запросов эти два запроса
-- выполняются одинаково

-- Теперь сделаем материализванное создание представления VIEW
-- сделаем ему другое имя, что-бы их разлечать.
-- и что-бы не нужно было удалять старое 

create materialized view film_amount_mat as
select 
    f.film_id,
    sum(p.amount) as sum_amount
from film f 
left join inventory i on f.film_id = i.film_id
left join rental r on i.inventory_id = r.inventory_id
left join payment p on r.rental_id = p.rental_id
group by f.film_id;

-- сделаем запрос из материализованного представления (VIEW)
select * from film_amount_mat fa;

-- Сделаем план построения запроса материализованного представления
explain
select * from film_amount_mat fa;

-- Материализованное представление создаестся в момент его создания,
-- поэтому с ним не стоит расчитывать на актуальность данных, при запросах к ним

-- для обновления данных в материализованных представлениях есть refresh

refresh materialized view film_amount_mat;

-- При выполнении этой команды, будут обновлены данные в этом 
-- материализованном представлении с именем film_amount_mat

-- Задача 1

create view film_actor_count as
select 
    f.film_id,
    count(fa.actor_id) as actor_cnt
from film f
left join film_actor fa on f.film_id = fa.film_id
group by f.film_id
order by actor_cnt;

select * from film_actor_count;

-- Задача 2

select 
    f.title,
    fac.actor_cnt
from film_actor_count fac
join film f on fac.film_id = f.film_id
order by actor_cnt;

-- Задача 3

drop view if exists film_actor_count;
