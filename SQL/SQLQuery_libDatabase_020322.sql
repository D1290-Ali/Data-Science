CREATE DATABASE libDatabase;
USE libDatabase;
CREATE SCHEMA book ;
CREATE SCHEMA person ;
--create Book.Book table
CREATE TABLE [Book].[Book](
    [Book_ID] [int] PRIMARY KEY NOT NULL,
    [Book_Name] [nvarchar](50) NOT NULL,
    Author_ID INT NOT NULL,
    Publisher_ID INT NOT NULL
    );
--create Book.Author table
CREATE TABLE [Book].[Author](
    [Author_ID] [int],
    [Author_FirstName] [nvarchar](50) Not NULL,
    [Author_LastName] [nvarchar](50) Not NULL
    );
--create Publisher Table
CREATE TABLE [Book].[Publisher](
    [Publisher_ID] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
    [Publisher_Name] [nvarchar](100) NULL
    );
-- CREATE TABLE Book.Publisher (
--  Publisher_ID int PRIMARY KEY IDENTITY(1,1) NOT NULL,
--  Publisher_Name nvarchar(100) NULL
-- );
CREATE TABLE [Person].[Person](
    [SSN] [bigint] PRIMARY KEY NOT NULL,
    [Person_FirstName] [nvarchar](50) NULL,
    [Person_LastName] [nvarchar](50) NULL
    );
--create Person.Loan table
CREATE TABLE [Person].[Loan](
    [SSN] BIGINT NOT NULL,
    [Book_ID] INT NOT NULL,
    PRIMARY KEY ([SSN], [Book_ID])
    );
--cretae Person.Person_Phone table
CREATE TABLE [Person].[Person_Phone](
    [Phone_Number] [bigint] PRIMARY KEY NOT NULL,
    [SSN] [bigint] NOT NULL
    );
--cretae Person.Person_Mail table
CREATE TABLE [Person].[Person_Mail](
    [Mail_ID] INT PRIMARY KEY IDENTITY (1,1),
    [Mail] NVARCHAR(MAX) NOT NULL,
    [SSN] BIGINT UNIQUE NOT NULL
    );
-- INSERT --
INSERT INTO Person.Person (SSN, Person_FirstName, Person_LastName)
	VALUES (75056659595,'Zehra', 'Tekin'
	);
select *
from Person.Person
;
INSERT INTO Person.Person (SSN, Person_FirstName) 
VALUES (889623212466,'Kerem');

INSERT Person.Person VALUES (15078893526,'Mert','Yetiþ');

INSERT Person.Person VALUES (55556698752, 'Esra', Null);

INSERT Person.Person VALUES (35532888963,'Ali','Tekin');-- Tüm tablolara deðer atanacaðý varsayýlmýþtýr.
INSERT Person.Person VALUES (88232556264,'Metin','Sakin')

INSERT INTO Person.Person_Mail (Mail, SSN) 
VALUES ('zehtek@gmail.com', 75056659595),
	   ('meyet@gmail.com', 15078893526),
	   ('metsak@gmail.com', 35532558963)
	   ;

select *
from Person.Person_Mail
;
select @@IDENTITY

SELECT @@ROWCOUNT

select	*      -- Person tablosunun ayný yapýsýnda Person2 isimli bir tablo oluþturduk.
into	Person.Person2
from	Person.Person

select	*
from	person.Person
where	Person_FirstName like 'M%'


insert into person.Person2
from	person.Person
where	Person_FirstName like 'M%';

insert into Book.Publisher
default values;

UPDATE person.Person2 
SET Person_FirstName = 'Default_Name'

UPDATE person.Person2 
SET Person_FirstName = 'Can' 
WHERE SSN = 75056659595

select *
from person.Person2
;

SELECT *
FROM person.Person2 AS A
Inner Join person.Person as B
ON A.SSN=B.SSN



UPDATE person.Person2
SET Person_FirstName = B.Person_FirstName
FROM person.Person2 A Inner Join person.Person B
ON A.SSN=B.SSN
WHERE B.SSN = 75056659595

-- DELETE
select *
from book.Publisher

Delete from Book.Publisher

TRUNCATE table book.publisher  -- DELETE ile farký indexi sýfýrlýyor

insert Book.Publisher values ('ÝLETÝÞÝM')
insert Book.Publisher values ('BÝLÝÞÝM')

Delete from Book.Publisher
WHERE Publisher_Name ='BILISIM'

DROP TABLE person.Person2;
DROP TABLE person.Person3;
TRUNCATE TABLE person.Person_Mail;
TRUNCATE TABLE person.Person;
TRUNCATE TABLE book.Publisher;

ALTER TABLE book.Book
ADD CONSTRAINT FK_Author
FOREIGN KEY (Author_ID)
REFERENCES book.Author (Author_ID);

ALTER TABLE book.Author
ADD CONSTRAINT pk_author
PRIMARY KEY (Author_ID);

ALTER TABLE book.Author
ALTER COLUMN Author_ID
INT NOT NULL;

ALTER TABLE person.Loan
ADD CONSTRAINT FK_PERSON
FOREIGN KEY (SSN)
REFERENCES person.Person (SSN);

ALTER TABLE Person.Loan 
ADD CONSTRAINT FK_book 
FOREIGN KEY (Book_ID) 
REFERENCES Book.Book (Book_ID);

Alter table person.Person_Mail 
add constraint FK_Person4 
Foreign key (SSN) 
References person.Person(SSN);