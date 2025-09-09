-- Пример проверяем длину строки в зависимости от этого ее обрезаем
select 
    a.first_name || ' ' || a.last_name as actor_name,
    length(a.first_name || ' ' || a.last_name),
    case
        when length(a.first_name || ' ' || a.last_name) > 15
        then substring(a.first_name, 1, 7) || ' ' || substring(a.last_name, 1, 7) -- мы хотим взять от имени 7 символов и от фамилии 7 символов, указав между ними пробел
        else a.first_name || ' ' || a.last_name
    end
from actor a;

-- найти актеров имя которых начинается на буквы 'CA', то есть нам нужно 
-- получить сокращенные имена всех актеров
select 
    case
        when length(a.first_name || ' ' || a.last_name) > 15
        then left(a.first_name, 7) || ' ' || left(a.last_name, 7)
        else a.first_name || ' ' || a.last_name
    end
from actor a
where
    left(
        case
            when length(a.first_name || ' ' || a.last_name) > 15
            then left(a.first_name, 7) || ' ' || left(a.last_name, 7)
            else a.first_name || ' ' || a.last_name
        end, 
        2
    ) = 'Ca';

-- тот же результат но с функцией substring()
select 
    case
        when length(a.first_name || ' ' || a.last_name) > 15
        then substring(a.first_name, 1, 7) || ' ' || substring(a.last_name, 1, 7) -- мы хотим взять от имени 7 символов и от фамилии 7 символов, указав между ними пробел
        else a.first_name || ' ' || a.last_name
    end
from actor a
where
    substring(
        case
        when length(a.first_name || ' ' || a.last_name) > 15
        then substring(a.first_name, 1, 7) || ' ' || substring(a.last_name, 1, 7) -- мы хотим взять от имени 7 символов и от фамилии 7 символов, указав между ними пробел
        else a.first_name || ' ' || a.last_name
    end,
    1,
    2    
    ) = 'Ca';

-- тот же результат но без страшного второго case :) результат такой же будет
select 
    case
        when length(a.first_name || ' ' || a.last_name) > 15
        then substring(a.first_name, 1, 7) || ' ' || substring(a.last_name, 1, 7) -- мы хотим взять от имени 7 символов и от фамилии 7 символов, указав между ними пробел
        else a.first_name || ' ' || a.last_name
    end
from actor a
where
   left(a.first_name, 2) = 'Ca';

--Сделаем такой пример, выведем информацию по языку фильма, 
-- из таблицы (language) где язык указан на латинице, 
-- а мы хотим вывести на русском (на кириллице)
select * 
from language l; -- посмотрим саму таблицу language

-- реализуем нашу задачу
select 
    f.title,
    case
        when l.language_id = 1 then 'Английский'
        when l.language_id = 2 then 'Итальянский'
        when l.language_id = 3 then 'Японский'
        when l.language_id = 4 then 'Мандарин'
        when l.language_id = 5 then 'Французский'
        when l.language_id = 6 then 'Немецкий'
    end as language_film
from film f
join language l
    on f.language_id = l.language_id;

-- второй вариант решения
select 
    f.title,
    case
        when l.language_id = 1 then 'Английский'
        when l.language_id = 2 then 'Итальянский'
        when l.language_id = 3 then 'Японский'
        when l.language_id = 4 then 'Мандарин'
        when l.language_id = 5 then 'Французский'
        when l.language_id = 6 then 'Немецкий'
        else 'Неизвестный язык'
    end as language_film
from film f
join language l
    on f.language_id = l.language_id;

--Третий вариант написания такого же запроса
select 
    f.title,
    case
        l.language_id
        when 1 then 'Английский'
        when 2 then 'Итальянский'
        when 3 then 'Японский'
        when 4 then 'Мандарин'
        when 5 then 'Французский'
        when 6 then 'Немецкий'
    end as language_film
from film f
join language l
    on f.language_id = l.language_id;

-- Фильмы для маленьких выводим что они все на Итальянском языке
-- вот нам так надо, не смотря на то что в базе у нас все фильмы на Английском
select 
    f.title,
    f.rating,
    case
        when l.language_id = 1 and f.rating = 'G' then 'Итальянский'
        when l.language_id = 1 then 'Английский'
        when l.language_id = 2 then 'Итальянский'
        when l.language_id = 3 then 'Японский'
        when l.language_id = 4 then 'Мандарин'
        when l.language_id = 5 then 'Французский'
        when l.language_id = 6 then 'Немецкий'
    end as language_film
from film f
join language l
    on f.language_id = l.language_id;

-- Другой вариант
select 
    f.title,
    f.rating,
    case
        when l.language_id = 1 then 'Английский'
        when l.language_id = 2 then 'Итальянский'
        when l.language_id = 3 then 'Японский'
        when l.language_id = 4 then 'Мандарин'
        when l.language_id = 5 then 'Французский'
        when l.language_id = 6 then 'Немецкий'
    end as language_film
from film f
join language l
    on
    case
        when f.rating  = 'G'
        then l.language_id = 2
        else f.language_id = l.language_id
    end;
    
-- case с агрегатными функциями
select 
    f.title,
    sum(p.amount) as total_amount,
    case
        when sum(p.amount) >= 150 then 'Top amount'
        when sum(p.amount) >= 100 then 'Middle amount'
        else 'Low amount'
    end as amount_rating
from film f
join inventory i
    on f.film_id = i.film_id
join rental r
    on i.inventory_id = r.inventory_id
join payment p 
    on r.rental_id = p.rental_id
group by f.film_id;

-- Задача 1
select 
    f.title,
    f.rating,
    case
        when rating = 'G' then 'Нет возрастных ограничений'
        when rating = 'PG' then 'Рекомендуется присутствие родителей'
        when rating = 'PG-13' then 'Детям до 13 лет просмотр не желателен'
        when rating = 'R' then 'Лицам да 17 лет обязательно присутствие взрослого'
        when rating = 'NC-17' then 'Лицам до 18 лет просмотр запрещен'
    end as "расшифровка рейтинга фильма"
from film f;

-- Задача 2
select 
    f.title,
    f.rating,
    f.length
from film f
where
    (case
        when f.rating = 'G'
        then f.length * 2
        else f.length 
    end) > 180;

-- Задача 3
    -- вариант 1
select 
    f.title,
    c.name,
    fc.category_id,
    c.category_id
from film f
join film_category fc
    on f.film_id = fc.film_id 
left join category c 
    on 
    case 
        when fc.category_id = 5 then c.category_id = 1
        else fc.category_id = c.category_id
    end;
    
    -- вариант 2
select 
    f.title,
    case
        when c.category_id = 5 then 'Action'
        else c.name
    end
from film f
join film_category fc
    on f.film_id = fc.film_id 
join category c 
    on fc.category_id = c.category_id;
