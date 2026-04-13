# Домашняя работа по созданию и наполнению таблиц

[link video](https://www.youtube.com/watch?v=x4dGPs-8ApA&list=PLzvuaEeolxkz4a0t4qhA0pxmttG8ZbBtd&index=64)

## Задача 1

Создать таблицу (internet_film) со списком фильмов, доступных для аренды онлайн.
Список полей:

- internet_film_id - Идентификатор фильма (Целое число. Должно проставляться автоматически. Первичный ключ).
- title - Название фильма (строка длиной до 50 символов. Обязательное для заполнения. Уникальное).
- price - Стоимость сдачи в прокат (число с плавающей точкой. Обязательное для заполнения. Должно быть больше 0 и меньше или равно 100).
- rental_duration - Количество дней, на которое фильм отдается в прокат (Целое число. Обязательное для заполнения. Больше 0).
- description - Описание фильма (строка длиной до 500 символов. Не обязательное для заполнения)

```SQL
drop table if exists internet_film;

create table if not exists internet_film (
    internet_film_id serial primary key,
    title varchar(50) not null unique,
    price numeric(5, 2) not null check(price > 0 and price <= 100),
    rental_duration smallint not null check(rental_duration > 0),
    description varchar(500) null check(length(description) <= 500)
);

select * from internet_film;
```
