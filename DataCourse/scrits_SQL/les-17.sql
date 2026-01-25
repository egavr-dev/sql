select 
    f.rental_rate 
from
    film f;
    
-- Преобразуем числвой тип данных поля f.rental_rate (numeric(4,2)) 
-- к строковому типу данных (varchar(10))
select
     f.rental_rate,
    cast(f.rental_rate as varchar(10)) 
from
    film f;

-- неявное приведение типов при объединении запросов
select 1 as filed1
union all
select 1.5 as filed1;

with cte as (
    select 1 as filed1
    union all
    select 1.5 as filed1
)
select 
    filed1,
    pg_typeof(filed1)
from
    cte;

-- фактическо оно равносильно такому:

select cast(1 as numeric) as filed1
union all
select 1.5 as filed1;

-- или в postgres можно так
select 1::numeric as filed1
union all
select 1.5 as filed1;

-- объединим две целые чифры для примера
select 1 as filed1
union all
select 1 as filed1;

select pg_typeof(filed1) from (
select 1 as filed1
union all
select 1 as filed1);

-- соединиv цифру и строку, как же у нас сработает неявное преобразование типов, 
-- и сработает ли вообще. Как видим получится в итоге у нас все неявно будет приведено 
-- к типу int4

select 1 as filed1
union all
select '2' as filed1;

-- Если строку невозможно преобразовать к числу, то получится ошибка

select 1 as filed1
union all
select 'some text' as filed1;
-- получим ошибку: invalid input syntax for type integer: "some text"


-- Теперь оба примера приведем к строке явным преобразованием.
select cast(1 as varchar) as filed1
union all
select '2' as filed1;

select cast(1 as varchar) as filed1
union all
select 'some text' as filed1;

-- пример с типом bool:

select 1 as filed1
union all
select false as filed1;
-- такое неявное преобразование не поддерживается, будем получать ошибку
--UNION types integer and boolean cannot be matched

-- А вот с таким явным преобразованием все получится
select '1' as filed1
union all
select false::varchar as filed1;

select 1 as filed1
union all
select false::int as filed1;

-- Отдельной темой является преобразование типов дат к строке, и в обратную сторону 
-- из строк в дату. Для этого есть функция NOW() которая возвращает 
-- тип данных TIMESTAMP с текущей временем и датой

select now();

-- функция TO_CHAR()
select 
    to_char(now(), 'yyyy-MM-dd'),
    to_char(now(), 'yyyy-MM-dd HH:mi'),
    to_char(now(), 'dd-mon-yyyy'),
    to_char(now(), 'dd/Month/yy');

-- Преобразует строку в дату.
select 
    cast('2021-10-01' as date),
    cast('01/10/2021' as timestamp),
    cast('01/10/2021 10:21:02' as timestamp),
    to_date('21/10/01', 'yy/MM/dd'),
    to_timestamp('21/10/01 10:11', 'yy/MM/dd HH24:mi'); 
