-- Рекурсия в SQL

-- Создадим таблицу employees (сотрудники) и наполним ее

drop table if exists employees;
create table employees (
    employees_id serial primary key,
    full_name varchar not null,
    manager_id int
);

insert into employees
(employees_id, full_name, manager_id)
values 
    (1, 'Michael North', NULL),
    (2, 'Megan Berry', 1),
    (3, 'Sarah Berry', 1),
    (4, 'Zoe Black', 1),
    (5, 'Tim James', 1),
    (6, 'Bella Tucker', 2),
    (7, 'Ryan Metcalfe', 2),
    (8, 'Max Mills', 2),
    (9, 'Benjamin Glover', 2),
    (10, 'Carolyn Henderson', 3),
    (11, 'Nicola Kelly', 3),
    (12, 'Alexandra Climo', 3),
    (13, 'Dominic King', 3),
    (14, 'Leonard Gray', 4),
    (15, 'Eric Rampling', 4),
    (16, 'Piers Paige', 7),
    (17, 'Ryan Henderson', 7),
    (18, 'Frank Tucker', 8),
    (19, 'Nathan Ferguson', 8),
    (20, 'Kevin Rampling', 8);

select * from employees;

-- Для нахождения всех подчиненных сотрудника с id = 2
-- Воспользуемся специальной возможностью 
-- общих табличных выражений CTE создавать рекурсивные вызовы
with recursive subordinates as (
    select
        e.employees_id,
        e.full_name
    from
        employees e
    where e.employees_id = 2
    
    union
    
    select
        e.employees_id,
        e.full_name
    from subordinates s
    join employees e
        on s.employees_id = e.manager_id
)

select * from subordinates

-- Теперь для сотрудника с employees_id = 18 найдем
-- всех его руководителей на любом уровне кому он подчиняется

with recursive managers as (
    select 
        e.employees_id,
        e.full_name,
        e.manager_id
    from
        employees e
    where e.employees_id = 18

    union

    select
        e.employees_id,
        e.full_name,
        e.manager_id
    from managers m
    join employees e
        on m.manager_id = e.employees_id 
)

select * from managers

-- Напишем расчет факториала числа на SQL например для числа 5
with recursive factorial as(
    select
        1 as n,
        1 as res
    union all
    select 
        f.n + 1 as n,
        f.res * (f.n + 1) as res
    from
        factorial f
    where f.n < 5
)

select * from factorial

-- Домашняя работа урока 
-- Задача 1






