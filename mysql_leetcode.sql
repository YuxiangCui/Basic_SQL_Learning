-- CYX: Learning SQL with Leetcode


-- ###### SQL Server on mac using docker
-- docker run -d --name sql_server_demo -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=superStrongPwd123' -p 1433:1433 mcr.microsoft.com/mssql/server:2017-latest-ubuntu
-- docker ps

-- =========================================== 初始化数据库 ===========================================
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
 BossId INT UNSIGNED,
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
(FirstName, LastName, DateOfBirth, YearOfBirth, Email, Country, BossId)
VALUES
("Amitabh", "Bachchan", "1942-07-10", 1942, "angry_young_man@gmail.com", "China", 4),
("Abhishek", "Bachchan", "1976-05-06", 1976, "abhishek@abhishekbachchan.org", "China", 5),
("Aishwarya", "Rai", "1973-11-06", 1973, "ash@gmail.com", "America", 6),
("Bishwarya", "Rai", "1973-11-07", 1973, "bsh@gmail.com", "America", NULL),
("Aamir", "Khan", "1965-04-28", 1965, "aamir@khan.com", "China", NULL),
("Abcd", "Xyz", "1965-04-28", 1965, "abc@xyz.com", "China", NULL),
("Abcde", "Xyz", "1965-04-28", 1965, "abcde@xyz.com", "America", NULL);


INSERT INTO Customers_addinfo
(Country,City,Email)
VALUES
("China", "Zhengzhou", "angry_young_man@gmail.com"),
("China", "Shanghai", "abhishek@abhishekbachchan.org"),
("America", "New York", "ash@gmail.com");

SELECT * FROM Customers;

SELECT * FROM Customers_addinfo;


-- =========================================== LeetCode Examples ===========================================


-- 175、组合两个表，保证左表完整

-- select FirstName, LastName, Customers.Country, Customers.DateOfBirth, Customers.YearOfBirth, Customers_addinfo.City, Customers_addinfo.Email
-- from Customers left join Customers_addinfo
-- on Customers.CustId = Customers_addinfo.CustId
-- ;


-- 176、获取第二高的数据
-- 如果不存在第二高的薪水，那么查询应返回 null

-- SELECT
--     (SELECT DISTINCT
--             YearOfBirth
--         FROM
--             Customers
--         ORDER BY YearOfBirth DESC
--         LIMIT 1 OFFSET 1) AS SecondYoungest;


-- 177、获取第N高的数据
-- 如果不存在第二高的薪水，那么查询应返回 null
-- DECLARE temp_N INT;

-- CREATE FUNCTION getN_thYoungest(N INT) RETURNS INT DETERMINISTIC
-- BEGIN
--   SET N = N - 1;
--   RETURN (
--       SELECT
--        (SELECT DISTINCT
--             YearOfBirth
--         FROM
--             Customers
--         ORDER BY YearOfBirth DESC
--         LIMIT 1 OFFSET N) AS N_thYoungest
--   );
-- END;

-- SELECT getN_thYoungest(3);


-- 178、分数排名
-- 如果两个分数相同，则两个分数排名（Rank）相同。请注意，平分后的下一个名次应该是下一个连续的整数值。换句话说，名次之间不应该有“间隔”。

-- -- # 1
-- SELECT YearOfBirth, 
--     (SELECT count(DISTINCT YearOfBirth) FROM Customers WHERE YearOfBirth >= C.YearOfBirth) AS 'Rank_1'
-- FROM Customers C
-- ORDER BY YearOfBirth DESC;

-- -- # 2
-- SELECT a.YearOfBirth, COUNT(DISTINCT b.YearOfBirth) AS `RANK_2`
-- FROM Customers a, Customers b
-- WHERE a.YearOfBirth <= b.YearOfBirth
-- GROUP BY a.CustId
-- ORDER BY `RANK_2`;


-- 180、连续出现的数字
-- 编写一个 SQL 查询，查找所有至少连续出现三次的数字。返回的结果表中的数据可以按 任意顺序排列。

-- := 为赋值语句，返回True，与=不同，不仅是判断
-- @ 声明临时变量
-- 按顺序计数每个数据连续出现的次数
-- select YearOfBirth, 
--     case 
--       when @prev = YearOfBirth then @count := @count + 1
--       when (@prev := YearOfBirth) is not null then @count := 1
--     end as CNT
-- from Customers, (select @prev := null,@count := null) as t

-- 根据次数找到distinct的满足要求的数据
-- select distinct YearOfBirth as ConsecutiveNums
-- from (
--   select YearOfBirth, 
--     case 
--       when @prev = YearOfBirth then @count := @count + 1
--       when (@prev := YearOfBirth) is not null then @count := 1
--     end as CNT
--   from Customers, (select @prev := null,@count := null) as t
-- ) as temp
-- where temp.CNT >= 3

-- ### 定义变量
-- SET @A=TRUE;
-- SELECT @A;


-- 181、超过经理收入的员工
-- 编写一个 SQL 查询，该查询可以获取收入超过他们经理的员工的姓名

-- # 1
-- select c1.FirstName as Customer
-- from Customers c1, Customers c2
-- where c1.BossId= c2.CustId
-- and c1.YearOfBirth > c2.YearOfBirth

-- # 2
-- select c.FirstName as Customer
-- from Customers c
-- where YearOfBirth > (select YearOfBirth from Customers where CustId = c.BossId)





