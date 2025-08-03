select 
    actor_id actorIdentity,
    first_name as firstName,
    last_name "Last Name",
    last_update as "Last Update"
from 
    actor;

-- посмотрим на математические операции.
select 
    amount,
    amount + 2, -- Можем прибавлять значения
    amount - 3, -- Можем вычитать значения
    amount * 1.5, -- Можем умножать на значение
    amount / 3, -- Можем делить на значение
    amount ^ 2, -- Можем возводить в степень (например в квадрат)
    amount % 4, -- Можем вычислять остаток от деления (например на 4)
    mod(amount, 4), -- Можем вычислять остаток от деления (например на 4) функцией mode()
    div(amount, 3), -- Возвращает результат деления (например на 2) отбрасывая дробную часть 
    round(amount / 2, 4), -- Переданное число округляет по правилам математики до указанной точности 
    floor(amount / 3), -- Переданное число округляет до целого в меньшую сторону
    ceil(amount / 3) -- Переданное число округляет до целого в большую сторону 
from
    public.payment; -- более общая форма запроса таблицы через схему, так тоже можно
    
-- посмотрим на работу со строками.
select 
    first_name,
    last_name,
    concat( first_name, ' ', last_name), -- Функция конкатенации ей как аргументы передаем все нужные строки
    first_name || ' ' || last_name, -- Оператор конкатенации
    char_length(first_name || ' ' || last_name), -- Функция считающая длину переданной ей строки
    left(first_name || ' ' || last_name, 15), -- функция оставляет указанное количество символов в строке
    trim(' ' || first_name || ' '), -- функция убирает пробелы, если они есть в начале и в конце строки
    trim(leading ' ' || first_name || ' '), -- функция убирает пробелы, если они есть в начале строки
    trim(trailing ' ' || first_name || ' '), -- функция убирает пробелы, если они есть в конце строки
    substring(first_name, 2, 3),    -- функция выведет начиная с второго символа в строке, всего три символа
    substring(first_name, 1, 3) || ' ' || substring(last_name, 1, 3), -- выводим 3 символа имени и 3 символа фамилии
    upper(first_name), -- переводит символы строки в верхний регистр
    lower(first_name) -- переводит символы строки в нижний регистр
    from 
    actor;
    
-- посмотрим таблицу персонала, получим имя пользователя из адреса электронной почты.
select
    email,
    strpos(email, '@'), -- получим позицию символа '@' в строке поля email
    substring(email, 1, strpos(email, '@') - 1 ) -- получаем имя пользователя в адресе почты
from
    staff 

-- Homework lesson 3
    
-- Задание 1
select 
    payment_id as "№ платежа", 
    customer_id as "№ покупателя", 
    amount as "Сумма платежа"
from 
    payment
    
-- Задание 2
select
    amount as "Сумма в долларах",
    ceil(amount * 3.27) as "Сумма в рублях"
from
    payment
    
-- Задание 3
select 
    concat('title: ', title, '; description: ', description) as "fullTitle",
    trim(leading 'A ' from description) as "trimmedDescription",
    substring(title, 1, strpos(title, ' ') - 1) as "titleFirstWord"
from
    film

