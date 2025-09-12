-- Получим все фильмы с объемом продаж больше 150
select
    f.film_id,
    f.title,
    sum(p.amount)
from 
    film f
join inventory i
    on f.film_id = i.film_id 
join rental r 
    using(inventory_id) 
join payment p 
    on r.rental_id = p.rental_id
group by f.film_id 
having sum(p.amount) > 150;

-- Получим фильмы у которых 
-- rental_rate (арендная плата) больше 4
select
    f.film_id,
    f.title
from 
    film f
where f.rental_rate > 4;

-- Теперь объединим эти два запроса
-- UNION удоляет дубликаты
select
    f.film_id,
    f.title
from 
    film f
join inventory i using(film_id)
join rental r using(inventory_id) 
join payment p using(rental_id)
group by f.film_id 
having sum(p.amount) > 150
union
select
    f.film_id,
    f.title
from 
    film f
where f.rental_rate > 4;

-- UNION ALL не удоляет дубликаты
select
    f.film_id,
    f.title
from 
    film f
join inventory i using(film_id)
join rental r using(inventory_id) 
join payment p using(rental_id)
group by f.film_id 
having sum(p.amount) > 150
union all
select
    f.film_id,
    f.title
from 
    film f
where f.rental_rate > 4;

-- теперь объединим так же но укажим 
-- признак по которому куда эта записи к нам попала используем UNION ALL
select
    f.title,
    'amount' as src
from 
    film f
join inventory i using(film_id)
join rental r using(inventory_id) 
join payment p using(rental_id)
group by f.film_id 
having sum(p.amount) > 150
union all
select
    f.title,
    'rental_rate' as src
from 
    film f
where f.rental_rate > 4;

-- Теперь тоже самое но используем UNION будет
select
    f.title,
    'amount' as src
from 
    film f
join inventory i using(film_id)
join rental r using(inventory_id) 
join payment p using(rental_id)
group by f.film_id 
having sum(p.amount) > 150
union
select
    f.title,
    'rental_rate' as src
from 
    film f
where f.rental_rate > 4;

-- Названия полей для результирующей таблицы берутся из первого запроса
select
    f.title,
    'amount' as src
from 
    film f
join inventory i using(film_id)
join rental r using(inventory_id) 
join payment p using(rental_id)
group by f.film_id 
having sum(p.amount) > 150
union all
select
    f.title as some_alias,
    'rental_rate' as some_src
from 
    film f
where f.rental_rate > 4;

-- Условиями объединения запросов:
-- 1) Количество столбцов равное.
-- 2) Типы данных столбцов одинаковые.

-- Операция исключения одного запроса из другого EXCEPT

-- Сделаем список всех фильмов у которых 
-- во первых, выручка (amount) по всем продажам больше 150, 
-- а во вторых, у которых rental_rate не больше 4

-- не правильный вариант
select
    f.title,
    f.rental_rate,
    'amount' as src
from 
    film f
join inventory i using(film_id)
join rental r using(inventory_id) 
join payment p using(rental_id)
group by f.film_id 
having sum(p.amount) > 150
except 
select
    f.title as some_alias,
    f.rental_rate,
    'rental_rate' as some_src
from 
    film f
where f.rental_rate > 4;

-- правильный вариант который вернет ноль строк ;) 
select
    f.title,
    f.rental_rate
from 
    film f
join inventory i using(film_id)
join rental r using(inventory_id) 
join payment p using(rental_id)
group by f.film_id 
having sum(p.amount) > 150
except 
select
    f.title as some_alias,
    f.rental_rate
from 
    film f
where f.rental_rate > 4;

-- Операция объединения запросов INTERSECT

-- Сделаем список всех фильмов у которых 
-- во первых, выручка (amount) по всем продажам больше 150, 
-- а во вторых, у которых rating 'G' (Нет возрастных ограничений)
select
    f.title,
    f.rental_rate,
    f.rating
from 
    film f
join inventory i using(film_id)
join rental r using(inventory_id) 
join payment p using(rental_id)
group by f.film_id 
having sum(p.amount) > 150
intersect
select
    f.title as some_alias,
    f.rental_rate,
    f.rating
from 
    film f
where f.rating = 'G';

-- Домашняя работа

-- Задание 1

-- Получим все фильмы (film.title) с рейтингом 'G' (film.rating)
select
    f.film_id,
    f.title,
    f.rating
from film f
where f.rating = 'G';

-- Получим фильмы в которых снимался актер 
-- с фамилией (actor.last_name = 'Grant')
select
    a.actor_id,
    a.first_name,
    a.last_name,
    fa.film_id,
    f.title,
    f.rating,
    'last_name_actor = Grant' as last_name_actor
from actor a
join film_actor fa 
    on a.actor_id = fa.actor_id and a.last_name = 'Grant'
join film f 
    on fa.film_id = f.film_id;
    
-- Теперь объединим эти два запроса можно union 
select
    f.film_id,
    f.title,
    f.rating,
    'film_rating = G' as film_rating_G
from film f
where f.rating = 'G'
union 
select
    f.film_id,
    f.title,
    f.rating,
    'last_name_actor = Grant' as last_name_actor
from actor a
join film_actor fa 
    on a.actor_id = fa.actor_id and a.last_name = 'Grant'
join film f 
    on fa.film_id = f.film_id;
    
-- можно используя union all так само 
--правильно так как не будет дополнительно потребления ресурсов при объединении
select
    f.film_id,
    f.title,
    f.rating,
    'film_rating = G' as film_rating_G
from film f
where f.rating = 'G'
union all
select
    f.film_id,
    f.title,
    f.rating,
    'last_name_actor = Grant' as last_name_actor
from actor a
join film_actor fa 
    on a.actor_id = fa.actor_id and a.last_name = 'Grant'
join film f 
    on fa.film_id = f.film_id;

-- Задача 2

-- Это более простое решение
select
    a.actor_id,
    a.first_name,
    a.last_name,
    fa.film_id,
    f.title,
    f.rating,
    'last_name_actor = Grant' as last_name_actor
from actor a
join film_actor fa 
    on a.actor_id = fa.actor_id and a.last_name = 'Grant'
join film f 
    on fa.film_id = f.film_id
where f.rating = 'G';

-- Получим список фильмов с рейтингом G

select
    f.film_id,
    f.title,
    f.rating,
    'film_rating = G' as film_rating_G
from film f
where f.rating = 'G';

-- Получить фильмы в которых снимался актер Grant
select
    a.actor_id,
    a.first_name,
    a.last_name,
    fa.film_id,
    f.title,
    f.rating,
    'last_name_actor = Grant' as last_name_actor
from actor a
join film_actor fa 
    on a.actor_id = fa.actor_id and a.last_name = 'Grant';

-- Объединим список с фильмами в которых актер Grant, 
--и список фильмов с рейтингом 'G'

select
    f.film_id,
    f.title
from actor a
join film_actor fa 
    on a.actor_id = fa.actor_id and a.last_name = 'Grant'
join film f 
    on fa.film_id = f.film_id
intersect 
select
    f.film_id,
    f.title
from film f
where f.rating = 'G';

-- Задача 3

-- Получим список фильмов с рейтингом НЕ 'G'
select
    f.film_id,
    f.title,
    f.rating 
from film f
where f.rating != 'G';

-- Получим список фильмов где снимался актер Grant, 
select
    f.film_id,
    f.title,
    a.last_name,
    f.rating
from actor a
join film_actor fa 
    on a.actor_id = fa.actor_id and a.last_name = 'Grant'
join film f 
    on fa.film_id = f.film_id;

-- Проще задачу решить простым запросом
    
select
    f.film_id,
    f.title,
    a.last_name,
    f.rating
from actor a
join film_actor fa 
    on a.actor_id = fa.actor_id and a.last_name = 'Grant'
join film f 
    on fa.film_id = f.film_id and f.rating != 'G';

-- Объединим список с фильмами в которых актер Grant, 
--и список фильмов с рейтингом НЕ 'G'

select
    f.film_id,
    f.title,
    f.rating
from film f
where f.rating != 'G'
intersect
select
    f.film_id,
    f.title,
    f.rating
from actor a
join film_actor fa 
    on a.actor_id = fa.actor_id and a.last_name = 'Grant'
join film f 
    on fa.film_id = f.film_id;
    
-- или вот так еще вариант

select
    f.film_id,
    f.title
from actor a
join film_actor fa 
    on a.actor_id = fa.actor_id and a.last_name = 'Grant'
join film f 
    on fa.film_id = f.film_id
except
select
    f.film_id,
    f.title
from film f
where f.rating = 'G';
    