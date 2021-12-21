-- CYX: Learning SQL with Leetcode


-- ###### SQL Server on mac using docker
-- docker run -d --name sql_server_demo -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=superStrongPwd123' -p 1433:1433 mcr.microsoft.com/mssql/server:2017-latest-ubuntu
-- docker ps

-- =========================================== 初始化数据库 ===========================================
-- ####### 以master权限管理数据库
USE mysql;

DROP DATABASE IF EXISTS cyx_testdb;
CREATE DATABASE cyx_testdb;

USE cyx_testdb;

CREATE TABLE IF NOT EXISTS Customers
(
    CustId INT UNSIGNED AUTO_INCREMENT,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    DateOfBirth DATE NOT NULL,
    YearOfBirth INT NOT NULL,
    Email VARCHAR(50) UNIQUE,
    Country VARCHAR(50) NOT NULL,
    PRIMARY KEY (CustId)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS Customers_addinfo
(
 CustId INT UNSIGNED AUTO_INCREMENT,
 Country VARCHAR(50) NOT NULL,
 City VARCHAR(50) NOT NULL,
 Email VARCHAR(50) UNIQUE,
 PRIMARY KEY (CustId),
 FOREIGN KEY (Email) REFERENCES Customers(Email)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO Customers
(FirstName, LastName, DateOfBirth, YearOfBirth, Email, Country)
VALUES
("Amitabh", "Bachchan", "1942-07-10", 1942, "angry_young_man@gmail.com", "China"),
("Abhishek", "Bachchan", "1976-05-06", 1976, "abhishek@abhishekbachchan.org", "China"),
("Aishwarya", "Rai", "1973-11-06", 1973, "ash@gmail.com", "America"),
("Aamir", "Khan", "1965-04-28", 1965, "aamir@khan.com", "China"),
("Abcd", "Xyz", "1965-04-28", 1965, "abc@xyz.com", "China"),
("Abcde", "Xyz", "1965-04-28", 1965, "abcde@xyz.com", "America");


INSERT INTO Customers_addinfo
(Country,City,Email)
VALUES
("China", "Zhengzhou", "angry_young_man@gmail.com"),
("China", "Shanghai", "abhishek@abhishekbachchan.org"),
("America", "New York", "ash@gmail.com");

SELECT * FROM Customers;

SELECT * FROM Customers_addinfo;


-- 175、组合两个表，保证左表完整

-- select FirstName, LastName, City, State
-- from Person left join Address
-- on Person.PersonId = Address.PersonId
-- ;



-- 176、获取第二高的数据
-- 如果不存在第二高的薪水，那么查询应返回 null

-- SELECT
--     (SELECT DISTINCT
--             YearOfBirth
--         FROM
--             Customers
--         ORDER BY YearOfBirth DESC
--         LIMIT 1 OFFSET 1) AS SecondHighest;