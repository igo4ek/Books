/*source C:\Program Files\phpServer\htdocs\mysql\run.sql*/

DROP DATABASE IF EXISTS dataBase1;
CREATE DATABASE dataBase1;
USE dataBase1;

CREATE TABLE books (
 id                INTEGER PRIMARY KEY,
 ISBN              VARCHAR(20) UNIQUE,
 title             VARCHAR(255) CHARACTER SET utf8 ,
 page_count        INTEGER(5) NOT NULL,
 publication_date  DATE
)ENGINE MEMORY;

CREATE TABLE authors (
 id                INTEGER PRIMARY KEY,
 author_name       VARCHAR(100) CHARACTER SET utf8 ,
 author_surname    VARCHAR(100) CHARACTER SET utf8
)ENGINE MEMORY;;

CREATE TABLE genres(
 id                INTEGER PRIMARY KEY,
 genre_name        VARCHAR(30) CHARACTER SET utf8
)ENGINE MEMORY;;

CREATE TABLE books_authors(
 author_id         INTEGER NOT NULL,
 book_id           INTEGER NOT NULL,
 FOREIGN KEY (author_id) REFERENCES authors(id),
 FOREIGN KEY (book_id)   REFERENCES books(id)
)ENGINE MEMORY;;

CREATE TABLE books_genres(
 book_id           INTEGER NOT NULL,
 genre_id          INTEGER NOT NULL,
 FOREIGN KEY (genre_id) REFERENCES genres(id),
 FOREIGN KEY (book_id)  REFERENCES books(id)
)ENGINE MEMORY;;


insert into authors(id, author_name, author_surname)
values(1, 'Лев','Толстой'),      /*1*/
      (2, 'Александр','Пушкин'), /*2*/
      (3, 'Джордж','Оруел'),     /*3*/
      (4, 'Джоан','Роулинг'),    /*4*/
      (5, 'Михаил','Булгаков'),  /*5*/
      (6, 'Игорь','Гагарев'),    /*6*/
      (7, 'Ваня','Пронькин'),    /*7*/
      (8, 'Гоша','Куценко'),     /*8*/
      (9, 'Валентин','Распутин');/*9*/

insert into genres(id, genre_name)
values(1, 'роман'),                /*1*/
      (2, 'эпопея'),               /*2*/
      (3, 'роман в стихах'),       /*3*/
      (4, 'фантастика'),           /*4*/
      (5, 'мистика'),              /*5*/
      (6, 'несмешная комедия'),    /*6*/
      (7, 'поэма'),                /*7*/
      (8, 'фэнтези'),              /*8*/
      (9, 'рассказ');              /*9*/


insert into books(id, ISBN, title, page_count, publication_date)
values(1, '978-5-699-70287-9', 'Война и Мир',                   1300,'1996-10-30'),
      (2, '978-2-54-43267-2',  'Евгений Онегин',                141, '2011-11-11'),
      (3, '975-3-02-56707-1',  '1984',                          318, '1984-02-12'),
      (4, '978-3-98-33221-1',  'Гарри Поттер и узник Азкабана', 451, '2006-04-30'),
      (5, '974-3-21-34117-1',  'Гарри Поттер и Орден Феникса',  638, '2006-04-30'),
      (6, '978-3-56-34117-1',  'Гарри Поттер и тайная комната', 447, '2006-04-30'),
      (7, '958-3-86-34117-1',  'Вафельное сердце',              140, '2006-04-30'),
      (8, '988-3-73-34117-1',  'Мастер и Маргарита',            543, '1887-08-27'),
      (9, '977-3-58-34117-1',  'Марсианская Собака',            25,  '2017-12-21'),
      (10,'900-3-02-00117-1',  'Уроки французского',            21,  '1917-08-01');

insert into books_authors (book_id, author_id)
values(1,1),
 (2,2),
 (3,3),
 (4,4),
 (5,4),
 (6,4),
 (7,4),
 (8,5),
 (9,6),
 (9,7),
 (9,8),
 (10,9);

insert into books_genres(book_id, genre_id)
values(1,1),
 (1,2),
 (2,3),
 (2,7),
 (3,4),
 (4,8),
 (5,8),
 (6,8),
 (7,8),
 (8,5),
 (9,4),
 (9,6),
 (9,8),
 (10,9);

/*3. Вывести название книги и ее авторов для жанра “Фантастика”.*/
SELECT books.title, authors.author_name, authors.author_surname
FROM books JOIN books_authors JOIN authors JOIN books_genres JOIN genres
  ON books.id=books_authors.book_id AND authors.id=books_authors.author_id AND
     books.id=books_genres.book_id  AND genres.id =books_genres.genre_id
WHERE genres.genre_name = 'фантастика';


/*4. Вывести автора, который написал больше всего книг.ПОПЫТКА #2*/
SELECT author_name, author_surname FROM authors
WHERE authors.id  IN
      (
        SELECT books_authors.author_id FROM books_authors
        GROUP BY books_authors.author_id
        HAVING SUM(1) = (
                            SELECT MAX(table_summ.summ)
                            FROM
                              (
                                SELECT author_name, author_surname, SUM(1) AS summ
                                FROM books_authors, authors
                                WHERE authors.id  = books_authors.author_id
                                GROUP BY authors.id
                              ) AS table_summ
                          )
      );
