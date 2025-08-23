select 1, 5 + 6, 1 = 6, 4 = 4;

select null = 'Some string'; -- Результат будет NULL

select '' = 'Some string'; -- Результат false

select '' = '' -- Результат true

select 'text' = 'text' -- Результат true

select 'text' = 'new_text' -- Результат false

select '' = null; -- Результат NULL

select null = null; -- Результат будет NULL

select '' || 'Some string';  -- Результат будет строка Some string

select null || 'Some string';  -- Результат будет NULL

select 1 = 1 or null = ''; -- Результат true

-- Любая логическая операция с NULL вернет NULL кроме операции OR

-- Обратимся к таблице address

select *
from address; -- в поле address2 есть несколько значения NULL и остальные значения пустые

select *
from address
where address2 <> 'Moscow' -- тут мы в выборке не увидим строчек со значением NULL

-- тобы нам добавить строки и со значениями NULL 
-- нужно дописать следующее

select *
from address
where 
    address2 <> 'Moscow' or
    address2 is null; -- Тут уже строчки со значением NULL будут присутствовать

-- Сортировка по одному полю
select *
from actor
order by first_name;

-- Сортировка по несколькм полям
select *
from actor
order by first_name, last_name;

-- Сортировка с условием отбора where
select *
from actor
where LOWER(first_name) like '%a%'
order by first_name, last_name;

-- Сортировка по убыванию имени (first_name) и сортировка
-- по возрастанию фамилий (last_name)
select *
from actor
order by first_name DESC, last_name ASC; -- 

-- сортировка по вычисляемому полю
select *
from actor
order by first_name || last_name;

-- Сортировка по результату остатка от деления на 10 (десять)
select 
    *,
    mod(actor_id, 10)
from actor
order by mod(actor_id, 10);

-- сортировка с псевдонимами
select 
    first_name f,
    last_name l,
    actor_id i    
from actor
order by  f, l;

-- с заданием порядка сортировки псевдонимам
select 
    first_name f,
    last_name l,
    actor_id i    
from actor
order by  f DESC, l ASC;

-- с заданием сортировки по номеру в выборке select
select 
    first_name f,
    last_name l,
    actor_id i    
from actor
order by  1, 2;

-- с заданием порядка сортировки по номеру в выборке select
select 
    first_name f,
    last_name l,
    actor_id i    
from actor
order by  1 DESC, 2 ASC;

-- Получим данные из таблицы address с сортировкой по возрастанию поля address2
select *  
from address
order by address2;

-- Получим данные из таблицы address с сортировкой по убыванию поля address2
select *  
from address
order by address2 DESC;

-- Получим данные из таблицы address с сортировкой по возрастанию поля address2 и 
-- NULL FIRST
select *  
from address
order by address2 nulls first;

-- Получим данные из таблицы address с сортировкой по убыванию поля address2 и 
-- NULL LAST
select *  
from address
order by address2 DESC nulls last;

-- Получим данные из таблицы staff (персонал)
select *  
from staff
order by picture
