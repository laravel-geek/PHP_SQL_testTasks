
/*
Тестовое задание для PHP-разработчика (Senior, Middle+)
Срок реализации не ограничен.
Результат выполнения необходимо предоставить в виде ссылки на расшаренный документ (github repo/gist, gitlab repo/snippet, gogole doc/drive, yandex disk и т.п.).
Если задание выполнено не на 100% верно, но логика реализации в правильном направление на 2/3, то выполнение будет засчитано.

Задание 1
Написать SQL-запросы (MySQL):

Выборки пользователей, у которых количество постов больше, чем у пользователя их пригласившего.
Выборки пользователей, имеющих максимальное количество постов в своей группе.
Выборки групп, количество пользователей в которых превышает 10000.
Выборки пользователей, у которых пригласивший их пользователь из другой группы.
Выборки групп с максимальным количеством постов у пользователей.

create table groups
(
    id   int         not null primary key,
    name varchar(50) not null
);

create table users
(
    id                      int         not null primary key,
    group_id                int         not null,
    invited_by_user_id      int         not null,
    name                    varchar(50) not null,
    posts_qty               int         not null,
    constraint  fk_users_group_id
        foreign key (group_id) references `groups` (id)
            on update cascade on delete cascade
);

insert into groups
    (id, name)
values
    (1, 'Группа 1'),
    (2, 'Группа 2');

insert into users
    (id, group_id, parent_id, name, posts_qty)
values
    (1, 1, 0, 'Пользователь 1', 0),
    (2, 1, 1, 'Пользователь 2', 2),
    (3, 1, 2, 'Пользователь 3', 5),
    (4, 2, 3, 'Пользователь 4', 7),
    (5, 2, 4, 'Пользователь 5', 1);

*/

# Выборки пользователей, у которых количество постов больше, чем у пользователя их пригласившего.
SELECT a.*  FROM users a WHERE a.posts_qty > (SELECT posts_qty FROM users b WHERE b.id = a.invited_by_user_id);

# Выборки пользователей, имеющих максимальное количество постов в своей группе.
SELECT *, MAX(posts_qty) FROM users GROUP BY group_id;

# Выборки групп, количество пользователей в которых превышает 10000.
SELECT groups.name
FROM groups
         LEFT JOIN users ON users.group_id = groups.id
GROUP BY groups.name
HAVING COUNT(users.group_id) > 10000;

#Выборки пользователей, у которых пригласивший их пользователь из другой группы.
SELECT a.*  FROM users a WHERE NOT a.group_id = (SELECT group_id FROM users b WHERE b.id = a.invited_by_user_id);

# Выборки групп с максимальным количеством постов у пользователей.
# не уверен, что правильно понял, но если речь идет о группе, где максимальная сумма постов всех пользователей группы, тогда так:

SELECT group_id, MAX(summed) FROM (SELECT group_id, SUM(posts_qty) AS summed FROM users GROUP BY group_id) as maxgroup;



# ЗАДАНИЕ 2
# Написать SQL-запросы (MySQL) для добавления трех полей, изменения имени одного поля и добавления двух индексов в базу данных размером свыше 100 ГБ и более 8 миллионов строк.

/*
 С таким задачами я в реальных проектах не встречался, вариантов,предположу, множество:

 1) в лоб (ALTER TABLE... ADD COLUMN/RENAME COLUMN/ADD INDEX/ ), понятно, никто делать не будет - все зависнет, на слейве остановится репликация, все это займет дни, если не недели  и т. д.
 2) создать новую таблицу с нужной структурой, заполнить поля из старой, переименовать старую, переименовать новую, триггеры, конечно. (здесь запрос слишком простой, чтобы его писать, но если надо - напишу)
 3) в сети рекомендуют утилиту pt-online-schema-change компании Percona, которая изменяет структуру таблицы как ALTER TABLE, но не блокирует операции чтения и записи. Посмотрел доки, утилита работает с копией таблицы и потом одномоментно RENAME TABLE.
 4)  Active-Passive Master-Master репликация, ALTER TABLE выполнить на пассивном сервере, а потом поменять их местами. Но здесь нужно знать тонкости репликации.

 */



