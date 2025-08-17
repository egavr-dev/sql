-- Операторы логических условий

select *
from film
where rental_rate = 4.99;

select *
from film
where rental_rate < 3;

select *
from film
where rental_rate > 3;

select *
from film
where rental_rate >= 2.99;

select *
from film
where rental_rate <= 2.99;

select *
from film
where rental_rate != 2.99;

select *
from film
where rental_duration <> 7; --тоже самое что оператор !=

select *
from rental
where return_date between '2005.05.26' and '2005.05.29';

select *
from film
where title like '%Airport%';

select *
from film
where title like '%Airport_%';

select *
from film
where description not like '%Epic%';

select *
from address;

select *
from address
where address2 is null;

select *
from address
where address2 is not null;

select *
from film
where rental_duration in (3, 4, 7);

-- Теперь рассмотрим операторы для комбинаций из логических условий
-- Для "комметирования" кода есть комбинация клавиш - (<ctrl> + /)

select *
from film
where not rental_duration = 7; --тоже самое что оператор != и оператор <>

-- Идентичные записи 
select *
from film
where description not like '%Epic%';

select *
from film
where not description like '%Epic%';

select *
from film
where 
        rental_duration in (6, 7) 
    and rental_rate > 1
    and title like 'P%';

select *
from film
where 
        rental_duration in (1, 6) 
    or title like 'P%';

select *
from film
where
    rental_duration in (6, 7) or
    (rental_rate > 1 
     and title like 'P%') or 
    (length between 70 and 120 
     and cast(rating AS text) like 'PG');

select *
from film
where
    rental_duration in (6, 7) or
    (rental_rate > 1 
     and title like 'P%') or 
    (length between 70 and 120 
     and rating = 'PG');
    
select *
from film
where
    rental_duration in (6, 7) or
    (rental_rate > 1 
     and title like 'P%') or 
    (length between 70 and 120 
     and cast(rating AS text) like 'PG');

-- Homework lesson 4

-- Задание 1

select *
from 
    payment
where 
    amount > 7 and 
    payment_date between '2007-03-01' and '2007-03-31';

-- Задание 2

select *
from 
    payment
where 
    amount > 7 or amount between 3.3 and 5.5;

-- Задание 3

select *
from
    payment
where
    not amount > 7 and
    not amount between 3.3 and 5.5;
    
-- Задание 4
    
select *
from
    payment
where
    payment_id % 10 = 1;

-- Задание 5

select *
from
    actor
where
    first_name like 'R%';

-- Задание 6
    
select *
from
    actor
where
    lower(last_name) like '%a%';

-- Задание 7

select *
from
    film
where
    length in (87, 116, 184);
