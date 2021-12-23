-- CYX: Learning SQL with SRL Server(some MySQL examples are also recorded)


-- ###### SQL Server on mac using docker
-- docker run -d --name sql_server_demo -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=superStrongPwd123' -p 1433:1433 mcr.microsoft.com/mssql/server:2017-latest-ubuntu
-- docker ps

-- =========================================== 初始化数据库 ===========================================
-- ####### 以master权限管理数据库
USE [master]
GO

-- ####### 显示版本以及数据库名称
-- Dump SQL version and current DB (see multiple result sets)
-- SELECT @@VERSION
-- SELECT DB_NAME() as CurrentDB
-- GO

-- 查询数据库状态
-- select name,user_access,user_access_desc,
--     snapshot_isolation_state,snapshot_isolation_state_desc,
--     is_read_committed_snapshot_on
-- from sys.databases

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
-- Column Name + Data Type + SQL Constriants
-- 常用 SQL Constriants
-- NOT NULL：非空
-- UNIQUE：某列的每行唯一值
-- PRIMARY KEY：非空且有唯一值，每个表都要有且仅有一个主键
-- FOREIGN KEY：保证一个表中的数据匹配另一个表中的值的参照完整性, 要保证是一一对应的可以索引的，存在的，有unique或者primary等性质
-- CHECK：保证列中的值符合指定的条件
-- DEFAULT：规定没有给列赋值时的默认值


DROP TABLE IF EXISTS [Customers];
GO

CREATE TABLE [dbo].[Customers]
(
--  [CustId] [int] CHECK (CustId < 100),
-- # MySQL
-- AUTO_INCREMENT=99 可以设置起始值
-- # SQL Server
 [CustId] [int] IDENTITY(1,1),
--  [CustId] [int] IDENTITY(10,3), 可以设置起始值以及间隔值
 [FirstName] [nvarchar](50) NOT NULL,
 [LastName] [nvarchar](50),
 [DateOfBirth][date] NOT NULL,
 [YearOfBirth][int],
--  [YearOfBirth][int] DEFAULT 2020,

-- SQL Server 语法
 [Email] [nvarchar](50) UNIQUE,
-- MySQL 语法
-- [Email] [nvarchar](50) NOT NULL,
-- UNIQUE (Email)
-- 通用语法：并列定义多个约束或者合并定义约束，对约束进行命名
--  [Email] [nvarchar](50) NOT NULL,
--  CONSTRAINT Email UNIQUE (Email),
--  CONSTRAINT uc_PersonID UNIQUE (FirstName, CustId),

 [Country] [nvarchar](50) NOT NULL, 
--  [City] [nvarchar](50) NOT NULL,

 PRIMARY KEY CLUSTERED ([CustId] ASC) ON [PRIMARY]
);
GO

-- ####### 添加 or 修改 or 撤销 约束
-- MODIFY 为 MySQL/Oracle 语法
-- ALTER COLUMN column_name datatype constraints 为SQL Server 语法
-- ALTER TABLE Customers
-- ALTER COLUMN LastName [nvarchar](50) NOT NULL;
-- GO

-- 添加 UNIQUE / PRIMARY KEY / FOREIGN KEY / CHECK 约束
-- ALTER TABLE Customers
-- -- ADD UNIQUE (FirstName);
-- ADD CONSTRAINT my_FirstName UNIQUE (FirstName);
-- GO

-- 删除 UNIQUE / PRIMARY KEY / FOREIGN KEY / CHECK 约束，需要知道外键的名称才可以进行删除
-- ALTER TABLE Customers
-- DROP CONSTRAINT my_FirstName;
-- GO

DROP TABLE IF EXISTS [Customers_addinfo];
GO

CREATE TABLE [dbo].[Customers_addinfo]
(
 [CustId] [int] PRIMARY KEY,
 [Country] [nvarchar](50) NOT NULL,
 [City] [nvarchar](50) NOT NULL,
 [Email] [nvarchar](50) FOREIGN KEY REFERENCES Customers(Email),

--  PRIMARY KEY CLUSTERED ([CustId] ASC) ON [PRIMARY]
);
GO


-- ####### 显示当前数据，仅有表头
-- Show the current database (note that we don't have any records yet)
-- SELECT * FROM Customers;
-- GO

-- ####### 插入数据
-- Insert sample data into table


-- INSERT INTO [dbo].[Customers]([CustId],[FirstName],[LastName],[DateOfBirth], [YearOfBirth],[Email],[Country])
-- VALUES
-- (1, 'Amitabh', 'Bachchan', '1942-07-10', '1942', 'angry_young_man@gmail.com','China'),
-- (2, 'Abhishek', 'Bachchan', '1976-05-06', '1976', 'abhishek@abhishekbachchan.org','China'),
-- (3, 'Aishwarya', 'Rai', '1973-11-06', '1973', 'ash@gmail.com','America'),
-- (4, 'Aamir', 'Khan', '1965-04-28', '1965', 'aamir@khan.com','China'),
-- (5, 'abcd', 'xyz', '1965-04-28', '1965', 'abc@xyz.com','China'),
-- (6, 'abcdE', 'xyz', '1965-04-28', '1965', 'abcde@xyz.com','America')
-- GO


-- 测试 AUTO INCREMENT
INSERT INTO [dbo].[Customers]([FirstName],[LastName],[DateOfBirth], [YearOfBirth],[Email],[Country])
VALUES
('Amitabh', 'Bachchan', '1942-07-10', '1942', 'angry_young_man@gmail.com','China'),
('Abhishek', 'Bachchan', '1976-05-06', '1976', 'abhishek@abhishekbachchan.org','China'),
('Aishwarya', 'Rai', '1973-11-06', '1973', 'ash@gmail.com','America'),
('Aamir', 'Khan', '1965-04-28', '1965', 'aamir@khan.com','China'),
('Abcd', 'Xyz', '1965-04-28', '1965', 'abc@xyz.com','China'),
('Abcde', 'Xyz', '1965-04-28', '1965', 'abcde@xyz.com','America')
GO


-- 测试缺省 Default 测试
-- ALTER TABLE Customers
-- ADD CONSTRAINT ab_c DEFAULT 1999 FOR YearOfBirth;
-- GO

-- INSERT INTO [dbo].[Customers]([CustId],[FirstName],[LastName],[DateOfBirth],[Email],[Country])
-- VALUES
-- (1, 'Amitabh', 'Bachchan', '1942-07-10', 'angry_young_man@gmail.com','China'),
-- (2, 'Abhishek', 'Bachchan', '1976-05-06', 'abhishek@abhishekbachchan.org','China'),
-- (3, 'Aishwarya', 'Rai', '1973-11-06', 'ash@gmail.com','America'),
-- (4, 'Aamir', 'Khan', '1965-04-28', 'aamir@khan.com','China'),
-- (5, 'abcd', 'xyz', '1965-04-28', 'abc@xyz.com','China'),
-- (6, 'abcdE', 'xyz', '1965-04-28', 'abcde@xyz.com','America')
-- GO


INSERT INTO [dbo].[Customers_addinfo]([CustId],[Country],[City],[Email])
VALUES
(1, 'China', 'Zhengzhou', 'angry_young_man@gmail.com'),
-- ## 因为前方选择了 FOREIGN KEY 属性，这里如果选择了插入指向表中不存在的内容，会产生冲突
-- (1, 'China', 'Zhengzhou', 'angry@gmail.com'),
(2, 'China', 'Shanghai', 'abhishek@abhishekbachchan.org'),
(3, 'America', 'New York', 'ash@gmail.com')
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
-- WHERE LastName IS NULL;
-- WHERE LastName IS NOT NULL;
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

-- ####### 7、设置索引
-- CREATE INDEX my_Index
-- CREATE UNIQUE INDEX my_Index
-- ON Customers (LastName)
-- GO

-- ####### 8、视图
-- 将表格可视化
-- 1、视图隐藏了底层的表结构，简化了数据访问操作，客户端不再需要知道底层表的结构及其之间的关系。
-- 2、视图提供了一个统一访问数据的接口。（即可以允许用户通过视图访问数据的安全机制，而不授予用户直接访问底层表的权限）
-- 3、从而加强了安全性，使用户只能看到视图所显示的数据。
-- 4、视图还可以被嵌套，一个视图中可以嵌套另一个视图。
-- CREATE VIEW [Current List] AS
-- SELECT *
-- FROM Customers
-- WHERE CustId<99;
-- GO

-- SELECT * FROM [Current List]
-- GO

-- ####### 9、NULL函数
-- ISNULL(key, n) 如果key为NULL，则返回值n


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
-- SELECT Country FROM Customers
-- UNION
-- SELECT Country FROM Customers_addinfo;
-- GO

-- SELECT Country FROM Customers
-- UNION ALL
-- SELECT Country FROM Customers_addinfo;
-- GO

-- SELECT CustId, Country FROM Customers
-- WHERE Country='China'
-- UNION ALL
-- SELECT CustId, Country FROM Customers_addinfo
-- WHERE Country<>'China';
-- GO

-- ####### 5、复制插入
-- #### SELECT INTO 复制数据到一个新的表中
-- SELECT CustId, Country
-- INTO  newtabel
-- FROM Customers
-- WHERE Country='China';
-- GO

-- SELECT * FROM newtabel
-- GO

-- #### INSERT INTO SELECT 复制数据到一个已经存在的表中

-- INSERT INTO newtabel (CustId, Country)
-- SELECT CustId, Country
-- FROM Customers
-- WHERE Country='China';
-- GO

-- SELECT * FROM newtabel
-- GO

-- ####### 6、插入 or 删除 or 清空

-- 删除
-- DROP TABLE newtabel
-- DROP DATABASE cyx_testdb

-- ALTER TABLE newtabel
-- DROP COLUMN Country

-- 插入
-- ALTER TABLE newtabel
-- ADD City [nvarchar](50)

-- 清空
-- TRUNCATE TABLE newtabel

-- SELECT * FROM newtabel;
-- GO

-- ####### 7、修改大小写
-- 大写 SQL Server: UPPER   SQL: UCASE
-- SELECT CustId, UPPER(FirstName) AS UP_FirstName
-- FROM Customers;
-- GO

-- 小写 SQL Server: LOWER   SQL: LCASE
-- SELECT CustId, LOWER(LastName) AS LOW_LastName
-- FROM Customers;
-- GO



-- =========================================== 各种统计数据方法 ===========================================

-- ####### 1、SUM 求和
-- SELECT SUM(YearOfBirth) AS Total FROM Customers;
-- GO
-- ####### 2、DISTINCT SUM 去重求和
-- SELECT SUM(DISTINCT YearOfBirth) AS Total FROM Customers;
-- GO

-- ####### 3、COUNT 计数，非null
-- SELECT COUNT(YearOfBirth) AS Total FROM Customers;
-- GO
-- ####### 4、DISTINCT COUNT去重计数
-- SELECT COUNT(DISTINCT YearOfBirth) AS Total FROM Customers;
-- GO

-- #### 添加case判断筛选
-- SELECT SUM(
--     case when YearOfBirth>1942 and LastName IN ('Rai', 'xyz') then 1
--     else 0 end
--     ) AS Total FROM Customers;
-- GO

-- ####### 5、AVG 平均值
-- SELECT AVG(YearOfBirth) AS Average FROM Customers;
-- GO

-- SELECT * FROM Customers
-- WHERE YearOfBirth > (SELECT AVG(YearOfBirth) AS Average FROM Customers);
-- GO

-- ####### 6、Maximum 最大值
-- SELECT MAX(YearOfBirth) AS Maximum FROM Customers;
-- GO

-- ####### 7、Minimum 最小值
-- SELECT MIN(YearOfBirth) AS Minimum FROM Customers;
-- GO

-- ####### 8、GROUP BY 分组
-- SELECT Country, SUM(Customers.YearOfBirth) AS nums
-- FROM Customers GROUP BY Country;

-- SELECT CustId, SUM(Customers.YearOfBirth) AS nums
-- FROM Customers GROUP BY CustId;


-- ####### 9、HAVING 组合使用 WHERE 与聚合函数（avg、sum、max、min、count）
-- SELECT Customers.Country, SUM(Customers.YearOfBirth) AS nums FROM (Customers
-- INNER JOIN Customers_addinfo
-- ON Customers.CustId=Customers_addinfo.CustId)
-- GROUP BY Customers.Country
-- HAVING SUM(Customers.YearOfBirth) > 2000;
-- GO


-- ####### 10、EXISTS 判断存在
-- SELECT Customers.CustId, Customers.Country, Customers.Email
-- FROM Customers
-- -- WHERE EXISTS (SELECT City FROM Customers_addinfo WHERE Customers.CustId = Customers_addinfo.CustId AND City = 'Shanghai');
-- WHERE NOT EXISTS (SELECT City FROM Customers_addinfo WHERE Customers.CustId = Customers_addinfo.CustId AND City = 'Shanghai');
-- GO

-- ####### 11、SUBSTRING 从文本字段中提取字符
-- SQL 中是 MID， SQL Server 中是 SUBSTRING
-- SELECT SUBSTRING(column_name,start[,length]) FROM table_name;
-- column_name: 要提取字符的字段（必需）
-- start: 规定开始位置（起始值是 1）（必需）
-- length: 要返回的字符数。如果省略，则 MID() 函数返回剩余文本（可选）

-- SELECT CustId, SUBSTRING(FirstName, 1, 4) AS ShortTitle
-- FROM Customers;
-- GO

-- ####### 12、LEN 文本字段的长度 MySQL：LENGTH()
-- SELECT LEN(FirstName) FROM Customers;
-- GO

-- ####### 13、ROUND 把数值字段舍入为指定的小数位数
-- SELECT ROUND(column_name,decimals) FROM TABLE_NAME;
-- SELECT ROUND(YearOfBirth, 1) FROM Customers;
-- GO

-- ####### 14、NOW 返回当前系统的日期和时间
-- SELECT ROUND(column_name,decimals) FROM TABLE_NAME;
-- SQL Server: getdate   SQL: NOW()
-- SELECT getdate() AS Date_Now FROM Customers;
-- GO


-- ####### 15、FORMAT 对字段的显示进行格式化
-- SELECT FORMAT(column_name,format) FROM table_name;
-- SELECT CustId, FORMAT(getdate(), 'd','en-US') AS date
-- SELECT CustId, FORMAT(getdate(), 'd','de-de') AS date
-- SELECT CustId, FORMAT(getdate(), 'd','zh-cn') AS date
-- FROM Customers;
-- GO

-- SELECT CustId, FORMAT(YearOfBirth, '#-##-#') AS date
-- FROM Customers;
-- GO

-- SELECT CustId, FORMAT(SYSDATETIME(), 'hh\:mm') AS date
-- SELECT CustId, FORMAT(SYSDATETIME(), 'hh\.mm') AS date
-- SELECT CustId, FORMAT(SYSDATETIME(), 'HH\:mm') AS date
-- SELECT CustId, FORMAT(SYSDATETIME(), 'HH\:mm tt') AS date
-- SELECT CustId, FORMAT(SYSDATETIME(), 'HH\:mm t') AS date
-- FROM Customers;
-- GO

