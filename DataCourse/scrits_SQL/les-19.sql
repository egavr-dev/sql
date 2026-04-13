-- Возьмем таблицу из урока по созданию таблиц в языке SQL

drop table if exists internet_customer;
create table internet_customer (
    customer_id serial not null,
    login varchar(20) not null,
    first_name varchar(20) not null,
    last_name varchar(20) not null,
    patronymic varchar(20) null,
    rating float default(0) not null,
    birthday date null
);

-- Наполним эту таблицу данными
insert into internet_customer 
(login, first_name, last_name, patronymic, birthday)
values 
    ('login1', 'Ivan', 'Petrov', NULL, '1987-01-03'),
    ('login2', 'Petr', 'Ivanov', 'Makarovich', '1991-10-11'),
    ('login3', 'Сергей', 'Иванов', 'Андреевич', '1995-11-02');

-- Запросим эти три строки
select * from internet_customer;

-- Создадим ограничение на длину поля login, пусть мы хотим
-- что-бы login не мог быть меньше шести символов

drop table if exists internet_customer;
create table internet_customer (
    customer_id serial not null,
    login varchar(20) not null check(length(login) >= 6),
    first_name varchar(20) not null,
    last_name varchar(20) not null,
    patronymic varchar(20) null,
    rating float default(0) not null,
    birthday date null
);

--Теперь такая вставка данных у нас не пройдет, так как одно из значений ('login')
-- не пройдет проверку, и запрос в целом не пройдет. 
-- А предыдущая наша вставка данных вполне пройдет
insert into internet_customer 
(login, first_name, last_name, patronymic, birthday)
values 
    ('login', 'Ivan', 'Petrov', NULL, '1987-01-03'),
    ('login2', 'Petr', 'Ivanov', 'Makarovich', '1991-10-11'),
    ('login3', 'Сергей', 'Иванов', 'Андреевич', '1995-11-02');

-- Для поля rating зададим проверку условия со своим имененм исключения которое 
-- будет выводится при несоблюдении этого условия, пусть рейтинг может быть
-- только >= (больше либо равен) нуля (0)

drop table if exists internet_customer;
create table internet_customer (
    customer_id serial not null,
    login varchar(20) not null check(length(login) >= 6),
    first_name varchar(20) not null,
    last_name varchar(20) not null,
    patronymic varchar(20) null,
    rating float default(0) not null constraint check_rating_wrong check(rating >= 0),
    birthday date null
);

-- ошибочная вставка данных
insert into internet_customer 
(login, first_name, last_name, patronymic, rating, birthday)
values 
    ('login1', 'Ivan', 'Petrov', NULL, -2, '1987-01-03');


-- Сделаем ограничение поля login не дадим сделать его равным полю 
-- имени (first_name) или равным полю фамилии (last_name)
drop table if exists internet_customer;
create table internet_customer (
    customer_id serial not null,
    login varchar(20) not null check( length(login) >= 6 
                                      and login != first_name 
                                      and login != last_name
                                    ),
    first_name varchar(20) not null,
    last_name varchar(20) not null,
    patronymic varchar(20) null,
    rating float default(0) not null constraint check_rating_wrong check(rating >= 0),
    birthday date null
);

insert into internet_customer 
(login, first_name, last_name, patronymic, birthday)
values 
    ('Ivan', 'Ivan', 'Petrov', NULL, '1987-01-03'),
    ('login2', 'Petr', 'Ivanov', 'Makarovich', '1991-10-11'),
    ('login3', 'Сергей', 'Иванов', 'Андреевич', '1995-11-02');

-- Немного другим способом, задавая условия отдельно от создания полей таблицы
drop table if exists internet_customer;
create table internet_customer (
    customer_id serial not null,
    login varchar(20) not null,
    first_name varchar(20) not null,
    last_name varchar(20) not null,
    patronymic varchar(20) null,
    rating float default(0) not null,
    birthday date null,
    check( 
           length(login) >= 6 and
           login != first_name and
           login != last_name
         ),
    constraint check_rating_wrong check(rating >= 0)
);

-- Или вообще объединить эти условия вот так, что тоже будет корректно

drop table if exists internet_customer;
create table internet_customer (
    customer_id serial not null,
    login varchar(20) not null,
    first_name varchar(20) not null,
    last_name varchar(20) not null,
    patronymic varchar(20) null,
    rating float default(0) not null,
    birthday date null,
    constraint check_login_AND_rating_wrong check( 
                                                   length(login) >= 6 and
                                                   login != first_name and
                                                   login != last_name and 
                                                   rating >= 0
                                                 )
);

insert into internet_customer 
(login, first_name, last_name, patronymic, birthday)
values 
    ('Ivan', 'Ivan', 'Petrov', NULL, '1987-01-03'),
    ('login2', 'Petr', 'Ivanov', 'Makarovich', '1991-10-11'),
    ('login3', 'Сергей', 'Иванов', 'Андреевич', '1995-11-02');

-- Наложим второй тип ограничений, ограничения на уникальность поля в таблице
drop table if exists internet_customer;
create table internet_customer (
    customer_id serial not null,
    login varchar(20) not null unique,
    first_name varchar(20) not null,
    last_name varchar(20) not null,
    patronymic varchar(20) null,
    rating float default(0) not null,
    birthday date null,
    constraint check_login_AND_rating_wrong check( 
                                                   length(login) >= 6 and
                                                   login != first_name and
                                                   login != last_name and 
                                                   rating >= 0
                                                 )
);

-- Второй способ задать уникальности полям таблицы
drop table if exists internet_customer;
create table internet_customer (
    customer_id serial not null,
    login varchar(20) not null,
    first_name varchar(20) not null,
    last_name varchar(20) not null,
    patronymic varchar(20) null,
    rating float default(0) not null,
    birthday date null,
    constraint check_login_AND_rating_wrong check( 
                                                   length(login) >= 6 and
                                                   login != first_name and
                                                   login != last_name and 
                                                   rating >= 0
                                                 ),
    unique(login)                                 
);

-- Или можно задать уникальность одновременно нескольких полей
drop table if exists internet_customer;
create table internet_customer (
    customer_id serial not null,
    login varchar(20) not null unique,
    first_name varchar(20) not null,
    last_name varchar(20) not null,
    patronymic varchar(20) null,
    rating float default(0) not null,
    birthday date null,
    constraint check_login_AND_rating_wrong check( 
                                                   length(login) >= 6 and
                                                   login != first_name and
                                                   login != last_name and 
                                                   rating >= 0
                                                 ),
    unique(first_name, last_name)
);

-- Такому написанному ограничению мы тоже можем задать свое имя выдаваемому исключению
drop table if exists internet_customer;
create table internet_customer (
    customer_id serial not null,
    login varchar(20) not null unique,
    first_name varchar(20) not null,
    last_name varchar(20) not null,
    patronymic varchar(20) null,
    rating float default(0) not null,
    birthday date null,
    constraint check_login_AND_rating_wrong check( 
                                                   length(login) >= 6 and
                                                   login != first_name and
                                                   login != last_name and 
                                                   rating >= 0
                                                 ),
    constraint check_unique_fio unique(first_name, last_name)
);

insert into internet_customer 
(login, first_name, last_name, patronymic, birthday)
values 
    ('login2', 'Petr', 'Ivanov', 'Makarovich', '1991-10-11'),
    ('login2', 'Petr', 'Ivanov', 'Makarovich', '1991-10-11'),
    ('login3', 'Сергей', 'Иванов', 'Андреевич', '1995-11-02');

insert into internet_customer 
(login, first_name, last_name, patronymic, birthday)
values 
    ('login2', 'Petr', 'Ivanov', 'Makarovich', '1991-10-11'),
    ('login3', 'Petr', 'Ivanov', 'Makarovich', '1991-10-11'),
    ('login4', 'Сергей', 'Иванов', 'Андреевич', '1995-11-02');

-- Успешный будет эта вставка данных
insert into internet_customer 
(login, first_name, last_name, patronymic, birthday)
values 
    ('login2', 'Vitaliy', 'Ivanov', 'Makarovich', '1991-10-11'),
    ('login3', 'Petr', 'Ivanov', 'Makarovich', '1991-10-11'),
    ('login4', 'Сергей', 'Иванов', 'Андреевич', '1995-11-02');

-- Зададим еще одно ограничение оно называется ограничением первичного ключа.
-- PRIMARY KEY (первичный ключ)
-- Представим два варианта первичного ключа "суррогатный" и "натуральный"
drop table if exists internet_customer;
create table internet_customer (
    customer_id serial primary key,
    login varchar(20) not null unique,
    first_name varchar(20) not null,
    last_name varchar(20) not null,
    patronymic varchar(20) null,
    rating float default(0) not null,
    birthday date null,
    constraint check_login_AND_rating_wrong check( 
                                                   length(login) >= 6 and
                                                   login != first_name and
                                                   login != last_name and 
                                                   rating >= 0
                                                 ),
    constraint check_unique_fio unique(first_name, last_name)
);

drop table if exists internet_customer;
create table internet_customer (
    login varchar(20) primary key,
    first_name varchar(20) not null,
    last_name varchar(20) not null,
    patronymic varchar(20) null,
    rating float default(0) not null,
    birthday date null,
    constraint check_login_AND_rating_wrong check( 
                                                   length(login) >= 6 and
                                                   login != first_name and
                                                   login != last_name and 
                                                   rating >= 0
                                                 ),
    constraint check_unique_fio unique(first_name, last_name)
);

-- Пример составного первичного ключа
drop table if exists internet_customer;
create table internet_customer (
    login varchar(20) not null unique,
    first_name varchar(20),
    last_name varchar(20),
    patronymic varchar(20) null,
    rating float default(0) not null,
    birthday date null,
    constraint check_login_AND_rating_wrong check( 
                                                   length(login) >= 6 and
                                                   login != first_name and
                                                   login != last_name and 
                                                   rating >= 0
                                                 ),
    constraint check_unique_fio unique(first_name, last_name),
    primary key(first_name, last_name)
);

-- Создание внешнего или вторичного ключа FOREIGN KEY
-- Для начала создадим таблицу заказов назовем ее internet_order
-- в таблице юудет информацию о том какой пользователь какой фильм 
-- у нас купил.

drop table if exists internet_customer;
create table internet_customer (
    customer_id serial primary key,
    login varchar(20) not null unique,
    first_name varchar(20) not null,
    last_name varchar(20) not null,
    patronymic varchar(20) null,
    rating float default(0) not null,
    birthday date null,
    constraint check_login_AND_rating_wrong check( 
                                                   length(login) >= 6 and
                                                   login != first_name and
                                                   login != last_name and 
                                                   rating >= 0
                                                 ),
    constraint check_unique_fio unique(first_name, last_name)
);

insert into internet_customer 
(login, first_name, last_name, patronymic, birthday)
values 
    ('login1', 'Ivan', 'Petrov', NULL, '1987-01-03'),
    ('login2', 'Ivan', 'Sergeev', 'Makarovich', '1991-10-11'),
    ('login3', 'Сергей', 'Иванов', 'Андреевич', '1995-11-02');

drop table if exists internet_order;
create table if not exist internet_order (
    internet_order_id serial primary key,
    internet_customer_id int references internet_customer(customer_id),
    film varchar(50)
);

insert into internet_order
(internet_customer_id, film)
values 
    (1, 'Some film');

-- Домашняя работа
-- Задача 1
drop table if exists internet_film;

create table if not exists internet_film (
    internet_film_id serial primary key,
    title varchar(50) not null unique,
    price numeric(5, 2) not null check(price > 0 and price <= 100),
    rental_duration smallint not null check(rental_duration > 0),
    description varchar(500) null check(length(description) <= 500)
);

select * from internet_film;
