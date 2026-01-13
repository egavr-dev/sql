-- Создание и наполнение таблиц. Типы данных. Изменение, вставка, 
-- удаление данных из таблиц

drop table internet_customer;
create table internet_customer (
    internet_customer_id int not null,
    login varchar(20) not null
);

-- Добавим значения в нашу таблицу internet_customer

insert into internet_customer (internet_customer_id, login)
values 
    (1, 'login1'),
    (2, 'login2'),
    (3, 'login3');

-- Теперь можем обратиться посмотреть записи этой таблицы

select * from internet_customer;

-- Пересоздадим таблицу с типом данных char
drop table internet_customer;
create table internet_customer (
    internet_customer_id int not null,
    login char(20) not null
);

-- Добавим значения в нашу таблицу internet_customer
insert into internet_customer (internet_customer_id, login)
values 
    (1, 'login1'),
    (2, 'login2'),
    (3, 'login3');

select * from internet_customer;

-- Вернемся к типу varchar, и добавим поля Фаилии, Имени, Отчества для пользователя.

drop table internet_customer;
create table internet_customer (
    internet_customer_id int not null,
    login varchar(20) not null,
    first_name varchar(20) not null,
    last_name varchar(20) not null,
    patronymic varchar(20) null
);

insert into internet_customer (internet_customer_id, login, first_name, last_name)
values 
    (1, 'login1', 'Иван', 'Петров'),
    (2, 'login2', 'Петр', 'Иванов'),
    (3, 'login3', 'Mark', 'Stevens');

select * from internet_customer;

drop table internet_customer;
create table internet_customer (
    internet_customer_id int not null,
    login varchar(20) not null,
    first_name varchar(20) not null,
    last_name varchar(20) not null,
    patronymic varchar(20) null
);

insert into internet_customer 
(internet_customer_id, login, first_name, last_name, patronymic)
values 
    (1, 'login1', 'Иван', 'Петров', 'Александрович'),
    (2, 'login2', 'Петр', 'Иванов', NULL),
    (3, 'login3', 'Mark', 'Stevens', NULL);

select * from internet_customer;

-- Добавим поле rating

drop table internet_customer;
create table internet_customer (
    internet_customer_id int not null,
    login varchar(20) not null,
    first_name varchar(20) not null,
    last_name varchar(20) not null,
    patronymic varchar(20) null,
    rating float default(0) not null
);

insert into internet_customer 
(internet_customer_id, login, first_name, last_name, patronymic)
values 
    (1, 'login1', 'Иван', 'Петров', 'Александрович'),
    (2, 'login2', 'Петр', 'Иванов', NULL),
    (3, 'login3', 'Mark', 'Stevens', NULL);

select * from internet_customer;

-- Добавим поле birthday

drop table internet_customer;
create table internet_customer (
    internet_customer_id int not null,
    login varchar(20) not null,
    first_name varchar(20) not null,
    last_name varchar(20) not null,
    patronymic varchar(20) null,
    rating float default(0) not null,
    birthday date null
);

insert into internet_customer 
(internet_customer_id, login, first_name, last_name, patronymic, birthday)
values 
    (1, 'login1', 'Иван', 'Петров', 'Александрович', '1987-01-05'),
    (2, 'login2', 'Петр', 'Иванов', NULL, '1991-11-06'),
    (3, 'login3', 'Mark', 'Stevens', NULL, '1995-12-16');

select * from internet_customer;

-- Добавим поле registered дата и время регистрации пользователя

drop table internet_customer;
create table internet_customer (
    internet_customer_id int not null,
    login varchar(20) not null,
    first_name varchar(20) not null,
    last_name varchar(20) not null,
    patronymic varchar(20) null,
    rating float default(0) not null,
    birthday date null,
    registered timestamp default(now()) not null
);

insert into internet_customer 
(internet_customer_id, login, first_name, last_name, patronymic, birthday)
values 
    (1, 'login1', 'Иван', 'Петров', 'Александрович', '1987-01-05'),
    (2, 'login2', 'Петр', 'Иванов', NULL, '1991-11-06'),
    (3, 'login3', 'Mark', 'Stevens', NULL, '1995-12-16');

select * from internet_customer;

-- Добавим поле deleted состоянеи пользователя удален он либо нет

drop table internet_customer;
create table internet_customer (
    internet_customer_id int not null,
    login varchar(20) not null,
    first_name varchar(20) not null,
    last_name varchar(20) not null,
    patronymic varchar(20) null,
    rating float default(0) not null,
    birthday date null,
    registered timestamp default(now()) not null,
    deleted bool default(false) not null
);

insert into internet_customer 
(internet_customer_id, login, first_name, last_name, patronymic, birthday)
values 
    (1, 'login1', 'Иван', 'Петров', 'Александрович', '1987-01-05'),
    (2, 'login2', 'Петр', 'Иванов', NULL, '1991-11-06'),
    (3, 'login3', 'Mark', 'Stevens', NULL, '1995-12-16');

select * from internet_customer;

-- Использование ALTER TABLE

-- Добавим поле deleted в заполненной таблице internet_customer

alter table internet_customer add column confirmed bool default(false);
select * from internet_customer;

-- Удалим лишнее поле deleted в заполненной таблице internet_customer

alter table internet_customer drop column confirmed;
select * from internet_customer;

-- Добавление данных в таблицу, с помощью запроса
insert into internet_customer 
(internet_customer_id, login, first_name, last_name, patronymic, birthday)
select
    3 + row_number() over(),
    substring(a.first_name, 1, 1) || '.' || a.last_name,
    a.first_name,
    a.last_name,
    null,
    null
from actor a;
select * from internet_customer;

-- Добавление данных в таблицу, другой способ без указания колонок
insert into internet_customer 
select
    3 + row_number() over(),
    substring(a.first_name, 1, 1) || '.' || a.last_name,
    a.first_name,
    a.last_name,
    null,
    0,
    null,
    now(),
    false
from actor a;
select * from internet_customer;

-- Использование типа данных serial для автоматической нумерации.
drop table internet_customer;
create table internet_customer (
    internet_customer_id serial not null,
    login varchar(20) not null,
    first_name varchar(20) not null,
    last_name varchar(20) not null,
    patronymic varchar(20) null,
    rating float default(0) not null,
    birthday date null,
    registered timestamp default(now()) not null,
    deleted bool default(false) not null
);

insert into internet_customer 
(login, first_name, last_name, patronymic, birthday)
select
    substring(a.first_name, 1, 1) || '.' || a.last_name,
    a.first_name,
    a.last_name,
    null,
    null
from actor a;

insert into internet_customer 
(login, first_name, last_name, patronymic, birthday)
values 
    ('login1', 'Иван', 'Петров', 'Александрович', '1987-01-05'),
    ('login2', 'Петр', 'Иванов', NULL, '1991-11-06'),
    ('login3', 'Mark', 'Stevens', NULL, '1995-12-16');

select * from internet_customer;

-- Удаление строк из таблиц, оператор DELETE

-- удаление всех строк
delete from internet_customer;

-- удаление строк по условию:
delete from internet_customer
where last_name = 'Петров';

-- Редактируем записи, для этого мы пишем UPDATE название таблицы, и через 
-- set указываем что мы хотим изменить:

update internet_customer
set login = 'testlogin'
where last_name = 'Stevens';

-- Домашнее задание по созданию и наполнению таблиц

-- Задача 1
drop table  internet_film;

create table if not exists internet_film (
    internet_film_id serial not null,
    title varchar(50) not null,
    price real not null,
    rental_duration int not null,
    description varchar(500) null
);

select * from internet_film;

-- Задача 2
insert into internet_film
(title, price, rental_duration)
values
('Новый супер фильм ЧЕБУРАШКА', 10, 3),
('Курсы, мука или вымысел ;)', 9, 2),
('Новый супер фильм ЧЕБУРАШКА', 10, 3);

select * from internet_film;

-- Задача 3
insert into internet_film
(title, price, rental_duration)
select 
    title,
    2,
    rental_duration
from film f
where f.rating = 'G';

select * from internet_film;
