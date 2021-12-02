-- CYX: Learning SQL with SRL Server(some MySQL examples are also recorded)


-- =========================================== 初始化数据库 ===========================================
-- ####### 以master权限管理数据库
USE [master]
GO

-- ####### 显示版本以及数据库名称
-- Dump SQL version and current DB (see multiple result sets)
-- SELECT @@VERSION
-- SELECT DB_NAME() as CurrentDB
-- GOtest

-- ####### 创建不重名的新数据库
-- Create the a test database
DROP DATABASE IF EXISTS [cyx_testdb];
GO
CREATE DATABASE [cyx_testdb];
GO
ALTER DATABASE [cyx_testdb] SET COMPATIBILITY_LEVEL = 130;
GO

-- ####### 显示用户名以及权限
-- Show user name and permission
-- USE [cyx_testdb];
-- EXECUTE AS USER = N'dbo';
-- SELECT UserName = USER_NAME()
--     , SystemLoginName = SUSER_SNAME();
-- SELECT mp.entity_name
--     , mp.permission_name
-- FROM sys.fn_my_permissions(NULL, N'DATABASE') mp
-- REVERT

-- ####### 检查当前所有数据库
-- Check if the test database was created
-- SELECT * from sys.databases;
-- GO

USE [cyx_testdb];
-- SELECT DB_NAME() as CurrentDB
-- GO

-- ####### 创建示例表格
-- Create a test table
CREATE TABLE [dbo].[Customers]
(
 [CustId] [int] NOT NULL,
 [FirstName] [nvarchar](50) NOT NULL,
 [LastName] [nvarchar](50) NOT NULL,
 [DateOfBirth][date] NOT NULL,
 [YearOfBirth][int] NOT NULL,
 [Email] [nvarchar](50) NOT NULL,
 [Country] [nvarchar](50) NOT NULL,

 PRIMARY KEY CLUSTERED ([CustId] ASC) ON [PRIMARY]
);
GO

CREATE TABLE [dbo].[Customers_addinfo]
(
 [CustId] [int] NOT NULL,
 [Country] [nvarchar](50) NOT NULL,
 [City] [nvarchar](50) NOT NULL,

 PRIMARY KEY CLUSTERED ([CustId] ASC) ON [PRIMARY]
);
GO

-- ####### 显示当前数据，仅有表头
-- Show the current database (note that we don't have any records yet)
-- SELECT * FROM Customers;
-- GO

-- ####### 插入数据
-- Insert sample data into table


INSERT INTO [dbo].[Customers]([CustId],[FirstName],[LastName],[DateOfBirth], [YearOfBirth],[Email],[Country])
VALUES
(1, 'Amitabh', 'Bachchan', '1942-07-10', '1942', 'angry_young_man@gmail.com','China'),
(2, 'Abhishek', 'Bachchan', '1976-05-06', '1976', 'abhishek@abhishekbachchan.org','China'),
(3, 'Aishwarya', 'Rai', '1973-11-06', '1973', 'ash@gmail.com','America'),
(4, 'Aamir', 'Khan', '1965-04-28', '1965', 'aamir@khan.com','China'),
(5, 'abcd', 'xyz', '1965-04-28', '1965', 'abc@xyz.com','China'),
(6, 'abcd', 'xyz', '1965-04-28', '1965', 'abc@xyz.com','America')
GO

INSERT INTO [dbo].[Customers_addinfo]([CustId],[Country],[City])
VALUES
(1, 'China', 'Zhengzhou'),
(2, 'China', 'Shanghai'),
(3, 'America', 'New York')
GO

-- ####### 显示当前数据，可以按照关键词进行升序或者降序排列
-- Show the current database, (ordered by specific key, up or down)
SELECT * FROM Customers
-- ORDER BY DateOfBirth;
-- ORDER BY DateOfBirth DESC;
GO

SELECT * FROM Customers_addinfo
GO


-- =========================================== 各种查询数据方法 ===========================================
-- ####### 1、按照关键词查询数据
-- Find data by keys
-- SELECT CustId, FirstName FROM Customers;
-- GO

-- ####### 2、按照关键词数据范围查询数据，区分字符串和数值
-- Find data by keys' value and key's range defined by >=<
-- SELECT CustId, FirstName FROM Customers 
-- WHERE CustId<=2
-- OR CustId=4;
-- GO
-- SELECT * FROM Customers 
-- WHERE FirstName='Aamir';
-- GO
-- SELECT * FROM Customers 
-- WHERE FirstName IN ('Aamir', 'abcd', 'xyz');
-- GO

-- SELECT * FROM Customers 
-- WHERE YearOfBirth BETWEEN 1000 AND 1942;
-- WHERE YearOfBirth NOT BETWEEN 1000 AND 1942;
-- WHERE DateOfBirth BETWEEN '1000-1-1' AND '1942-12-12';
-- WHERE LastName BETWEEN 'A' AND 'H';
-- GO

-- ####### 3、按照关键词查询不同的数据
-- Find data that distincts
-- SELECT DISTINCT LastName FROM Customers;
-- GO

-- ####### 4、按照关键词查询头部数据，这里MySQL语法有区别
-- Find data on the top
-- SQL Server Example
-- SELECT TOP 50 PERCENT * FROM Customers;
-- ## 按照某顺序排序后的头部数据
-- SELECT TOP 50 PERCENT * FROM Customers
-- ORDER BY YearOfBirth ASC;
-- ## 按照某顺序排序后的尾部数据
-- SELECT TOP 50 PERCENT * FROM Customers
-- ORDER BY YearOfBirth DESC;
-- GO
-- MySQL Example
-- SELECT * FROM Customers LIMIT 2,1;
-- GO

-- ####### 5、按照关键词查找特定模式的数据，%替代多个字符，_替代单个字符，通配符
-- Find data in specific patterns (like), if the key include '_' or '%' use '\' to transfer meaning
-- SELECT * FROM Customers
-- start with B
-- WHERE LastName LIKE 'B%';
-- end with B
-- WHERE LastName LIKE '%an';
-- include ha
-- WHERE LastName LIKE '%ha%';
-- include bc with specific length of key
-- WHERE FirstName LIKE '_bc_';
-- include cd with specific length of key
-- WHERE FirstName LIKE '__cd';
-- MySQL Examples
-- using regexp defining specific patterns, '^[A-Z]', '^[^A-Z]'(not)
-- WHERE FirstName REGEXP '^[A-Z]';
-- WHERE FirstName NOT REGEXP '^[A-Z]';
-- GO

-- ####### 6、别名
-- SELECT CustId, CONCAT(FirstName, '. ', Lastname, ', ', DateOfBirth) AS info FROM  Customers;
-- GO


-- =========================================== 各种更新数据方法 ===========================================


-- ####### 1、更新
-- Update 2 records
-- UPDATE Customers
-- SET Email = 'bachchans@gmail.com'
-- WHERE LastName = 'Bachchan'
-- GO

-- -- Show the current database
-- SELECT * FROM Customers;
-- GO

-- ####### 2、删除
-- Delete a record
-- DELETE FROM Customers
-- WHERE DateOfBirth = '1965-04-28'
-- GO

-- -- Show the current database 
-- SELECT * FROM Customers;
-- GO


-- ####### 3、连接
-- #### INNER JOIN 至少存在一个匹配时进行的匹配
-- SELECT Customers.CustId, Customers.FirstName, Customers_addinfo.Country, Customers_addinfo.City
-- FROM Customers
-- INNER JOIN Customers_addinfo
-- ON Customers.CustId=Customers_addinfo.CustId;
-- -- ORDER BY Customers.CustId;
-- GO


-- #### LEFT JOIN 左表优先，null补全
-- SELECT Customers.CustId, Customers.FirstName, Customers_addinfo.Country, Customers_addinfo.City
-- FROM Customers
-- LEFT JOIN Customers_addinfo
-- ON Customers.CustId=Customers_addinfo.CustId;
-- GO

-- #### RIGHT JOIN 右表优先，null补全
-- SELECT Customers.CustId, Customers.FirstName, Customers_addinfo.Country, Customers_addinfo.City
-- FROM Customers
-- RIGHT JOIN Customers_addinfo
-- ON Customers.CustId=Customers_addinfo.CustId;
-- GO

-- #### FULL JOIN 右表优先，null补全
-- SELECT Customers.CustId, Customers.FirstName, Customers_addinfo.Country, Customers_addinfo.City
-- FROM Customers
-- FULL JOIN Customers_addinfo
-- ON Customers.CustId=Customers_addinfo.CustId;
-- GO

-- ####### 4、合并
-- #### UNION 只合并不相同的值，列名以前一个的列名为准
SELECT Country FROM Customers
UNION
SELECT Country FROM Customers_addinfo;
GO

SELECT Country FROM Customers
UNION ALL
SELECT Country FROM Customers_addinfo;
GO

SELECT CustId, Country FROM Customers
WHERE Country='China'
UNION ALL
SELECT CustId, Country FROM Customers_addinfo
WHERE Country<>'China';
GO


-- =========================================== 各种统计数据方法 ===========================================

-- ####### 求和
-- SELECT SUM(YearOfBirth) AS Total FROM Customers;
-- GO
-- ####### 去重求和
-- SELECT SUM(DISTINCT YearOfBirth) AS Total FROM Customers;
-- GO

-- ####### 计数，非null
-- SELECT COUNT(YearOfBirth) AS Total FROM Customers;
-- GO
-- ####### 去重计数
-- SELECT COUNT(DISTINCT YearOfBirth) AS Total FROM Customers;
-- GO

-- #### 添加case判断筛选
-- SELECT SUM(
--     case when YearOfBirth>1942 and LastName IN ('Rai', 'xyz') then 1
--     else 0 end
--     ) AS Total FROM Customers;
-- GO

-- ####### 平均值
-- SELECT AVG(YearOfBirth) AS Average FROM Customers;
-- GO

-- SELECT * FROM Customers
-- WHERE YearOfBirth > (SELECT AVG(YearOfBirth) AS Average FROM Customers);
-- GO

-- ####### 最大值
-- SELECT MAX(YearOfBirth) AS Maximum FROM Customers;
-- GO

-- ####### 最小值
-- SELECT MIN(YearOfBirth) AS Minimum FROM Customers;
-- GO