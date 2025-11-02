--Пишем PARTITION BY (аналог group by) и указываем на какие группы 
--мы хотим делить все строки и какую группу взять.
--Мы возьмем поле rating это будет значить что при расчете этой 
-- функции у нас будут взяты все строки в таблице film 
-- c таким же значением f.rating как у текущей строки 
-- (в нашем случае для первой строки это NC-1, 
-- для второй это 'R' и так далее).
--Дадим этой строке название min_rating_length.

select 
    f.title,
    f.rating,
    f.length,
    min(f.length) over(partition by f.rating) as min_rating_length,
    max(f.length) over(partition by f.rating) as max_rating_length,
    avg(f.length) over(partition by f.rating) as avg_rating_length,
    sum(f.length) over(partition by f.rating) as sum_rating_length,
    count(f.length) over(partition by f.rating) as count_rating_length,
    min(f.length) over() as min_length
from film f 
order by
    f.rating,
    f.length;
    
-- Определение оконной функции отдельно, и использование их по имени
select 
    f.title,
    f.rating,
    f.length,
    min(f.length) over w as min_rating_length,
    max(f.length) over w as max_rating_length,
    avg(f.length) over w as avg_rating_length,
    sum(f.length) over w as sum_rating_length,
    count(f.length) over w as count_rating_length
from film f 
window w as (partition by f.rating)
order by
    f.rating,
    f.length;

-- Рассмотрим примеры ранжирующий функций для оконных функций
-- Ранжирующие функции это такие функции которые каждой строке 
-- дают какой то номер.

-- ROW_NUMBER()
select 
    f.title,
    f.rating,
    f.length,
    row_number() over(partition by f.rating) as rn
from film f
--order by
--    f.rating,
--    f.length;

-- Если мы хотим не просто в любом порядке пронумеровать, 
-- то мы можем внутри OVER() использовать ORDER BY

select 
    f.title,
    f.rating,
    f.length,
    row_number() over(partition by f.rating order by f.length) as r_n
from film f;

-- Функция RANK()

select 
    f.title,
    f.rating,
    f.length,
    row_number() over(partition by f.rating order by f.length) as r_n,
    rank() over(partition by f.rating order by f.length) as rank,
    dense_rank() over(partition by f.rating order by f.length) as d_rank
from film f;

-- Получение предыдущей строки в окне, или следующей строки в окне 

select 
    f.title,
    f.rating,
    f.length,
    lag(f.length, 1) over(partition by f.rating order by f.length) as prev_length
from film f;

-- Получение следующей строки в окне, относительно текущеей строки в окне

select 
    f.title,
    f.rating,
    f.length,
    lag(f.length, 1) over(partition by f.rating order by f.length) as prev_length,
    lead(f.length, 1) over(partition by f.rating order by f.length) as next_length
from film f;

-- Плучим разницу между длиной текущего фильма и длиной предыдущего фильма

select 
    f.title,
    f.rating,
    f.length,
    lag(f.length, 1) over(partition by f.rating order by f.length) as prev_length,
    lead(f.length, 1) over(partition by f.rating order by f.length) as next_length,
    f.length - lag(f.length, 1) over(partition by f.rating order by f.length) as diff_length
from film f;

---------------------------------------------------------------------------------------
-- Дополнительные примеры того, что применяется значительбно реже
---------------------------------------------------------------------------------------

-- функцию NTILE() ей в качестве аргумента передаем количество групп (это 8 в нашем случае) 
-- на которые нужно разделить, и внутри OVER() мы можем указать в рамках каких групп нам 
-- делить на эти группы, в нашем случае мы хотим все фильмы, поэтому тут ничего на группы 
-- не делим (не используем partition by)

select 
    c."name",
    c.category_id,
    ntile(8) over(order by c.category_id) as group_id
from category c;

-- Посчитать на каждую дату сколько было фактов сдачи в аренду в эту дату. 
-- И так же на сколько в эту дату у нас отличается сдача в аренду от предыдущей даты.

select 
    date(r.rental_date) as date,
    count(*) as count_for_date,
    lag(count(*), 1) over(order by date(r.rental_date)),
    count(*) - lag(count(*), 1) over(order by date(r.rental_date)) as diff_cnt
from rental r
group by
    date    
order by
    date;

-- мы хотим получить значения колебаний сдач в аренду за каждые три дня работы.
-- За текущую дату, за вчера, и за позавчера.

with rent_day as (
    select 
        date(r.rental_date) as day_date,
        count(*) as count_for_date
    from 
        rental r 
    group by
        day_date
)
select 
    r.day_date,
    r.count_for_date,
    sum(r.count_for_date) over(order by r.day_date rows between 2 preceding and current row) as tree_days_cnt,
    sum(r.count_for_date) over(order by r.day_date rows between current row and current row) as current_cnt,
    sum(r.count_for_date) over(order by r.day_date rows between 3 preceding and 3 following) as week_cnt,
    sum(r.count_for_date) over(order by r.day_date rows between unbounded preceding and current row) as week_cnt,
    sum(r.count_for_date) over(order by r.day_date rows between unbounded preceding and unbounded following) as total_cnt
from 
    rent_day r;

-- CURREN ROW (текущая строка)
-- PRECEDING (предыдущих)
-- FOLLOWING (следующих)
-- PRECEDING (предыдущий)
-- FOLLOWING (следующих)
-- UNBOUNDED (безграничный)

-- Если мы хотим просуммировать три дня до и три дня после тоесть за неделю
-- sum(r.count_for_date) over(order by r.day_date rows between 2 preceding and 3 following) as week_cnt

-- Рассмотрим когда мы пишем вместо ROWS а RANGE

-- Для понимания как это работает, нужно ввести понятие родственных строк.
-- Мы отсортировали все фильмы по продолжительности, но фильмы с одинаковой продолжительностью являются родственными, 
-- то-есть при выполнении запроса с ROWS мы действительно берем весь указанный диапазон строк и текущую строку, 
-- и делаем то что написано, когда используется RANGE то мы берем указанный диапазон, текущую строку, а так же 
-- добавляем все родственные строки для текущей

select 
  f.title,
  f.rating,
  f.length,
  sum(f.length) over(partition by f.rating order by f.length rows between unbounded preceding and current row) as cum_l_row,
  sum(f.length) over(partition by f.rating order by f.length range between unbounded preceding and current row) as cum_l_range
from film f;

-- Какое есть следствие из такой логики, а мы попробуем выполнить расчет общую суммарную продолжительность всех фильмов 
-- с рейтингом как у текущего фильма, когда мы не задаем явно рамки окна, с помощью ROWS или RANGE, то у нас, по умолчанию, 
-- проставляется рамка окна вот такая `range between unbounded preceding and current row`.

-- Но при этом, если сортировка не заданна отсутствует (order by), то у нас все строки, в рамках одной группы являются 
-- родственными, так как мы не знаем как их сортировать. А если сортировка заданна, то мы уже действительно берем только 
-- строки которые идут до текущей строки, текущую строку и родственные текущей если они есть. Поэтому у нас получается 
-- накопительный итог такой своеобразный.

select 
  f.title,
  f.rating,
  f.length,
  sum(f.length) over(partition by f.rating),
  sum(f.length) over(partition by f.rating order by f.length),
  sum(f.length) over(partition by f.rating order by f.length, f.film_id),
  f.film_id,
  sum(f.length) over(partition by f.rating order by f.film_id)
from film f;

select 
  f.title,
  f.rating,
  f.length,
  f.film_id,
  sum(f.length) over(partition by f.rating order by f.film_id)
from film f;

select 
  f.title,
  f.rating,
  f.length,
  sum(f.length) over(partition by f.rating),
  sum(f.length) over(partition by f.rating order by f.length),
  sum(f.length) over(partition by f.rating order by f.length, f.film_id),
  sum(f.length) over(partition by f.rating order by f.length range between current row and unbounded following)
from film f;

-- Функция FIRST_VALUE()

select 
  f.title,
  f.rating,
  f.length,
  first_value(f.length) over(partition by f.rating order by f.length) as first_length,
  last_value(f.length) over(partition by f.rating order by f.length) as lst_length,
  last_value(f.length) over(partition by f.rating order by f.length range between unbounded preceding and current row) as l_len,
  last_value(f.length) over(partition by f.rating order by f.length range between unbounded preceding and unbounded following) as l_len
from film f;

-- Домашняя работа

-- Задача 1

select 
    f.title,
    f.rental_duration,
    count(*) over(partition by f.rental_duration)
from film f
order by f.title;

-- Задача 2

select 
    f.title,
    f.rental_duration,
    f.length,
    row_number() over(partition by f.rental_duration order by f.length, f.title)
from film f;

-- Задача 3 (со звездочкой ***)

select
    DATE(p.payment_date),
    p.amount,
    sum(p.amount) over(order by p.payment_date rows between unbounded preceding and current row) as cum_sum
from payment p;
