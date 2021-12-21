-- CYX: Learning SQL with Leetcode


-- ###### SQL Server on mac using docker
-- docker run -d --name sql_server_demo -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=superStrongPwd123' -p 1433:1433 mcr.microsoft.com/mssql/server:2017-latest-ubuntu
-- docker ps

-- =========================================== 初始化数据库 ===========================================
-- ####### 以master权限管理数据库
USE [master]
GO

DROP DATABASE IF EXISTS [cyx_testdb];
GO

CREATE DATABASE [cyx_testdb];
GO
ALTER DATABASE [cyx_testdb] SET COMPATIBILITY_LEVEL = 130;
GO

USE [cyx_testdb];

DROP TABLE IF EXISTS [Customers];
GO

CREATE TABLE [dbo].[Customers]
(

 [CustId] [int] IDENTITY(1,1),
 [FirstName] [nvarchar](50) NOT NULL,
 [LastName] [nvarchar](50),
 [DateOfBirth][date] NOT NULL,
 [YearOfBirth][int],
 [Email] [nvarchar](50) UNIQUE,
 [Country] [nvarchar](50) NOT NULL, 

 PRIMARY KEY CLUSTERED ([CustId] ASC) ON [PRIMARY]
);
GO

DROP TABLE IF EXISTS [Customers_addinfo];
GO

CREATE TABLE [dbo].[Customers_addinfo]
(
 [CustId] [int] PRIMARY KEY,
 [Country] [nvarchar](50) NOT NULL,
 [City] [nvarchar](50) NOT NULL,
 [Email] [nvarchar](50) FOREIGN KEY REFERENCES Customers(Email),

);
GO

INSERT INTO [dbo].[Customers]([FirstName],[LastName],[DateOfBirth], [YearOfBirth],[Email],[Country])
VALUES
('Amitabh', 'Bachchan', '1942-07-10', '1942', 'angry_young_man@gmail.com','China'),
('Abhishek', 'Bachchan', '1976-05-06', '1976', 'abhishek@abhishekbachchan.org','China'),
('Aishwarya', 'Rai', '1973-11-06', '1973', 'ash@gmail.com','America'),
('Aamir', 'Khan', '1965-04-28', '1965', 'aamir@khan.com','China'),
('Abcd', 'Xyz', '1965-04-28', '1965', 'abc@xyz.com','China'),
('Abcde', 'Xyz', '1965-04-28', '1965', 'abcde@xyz.com','America')
GO

INSERT INTO [dbo].[Customers_addinfo]([CustId],[Country],[City],[Email])
VALUES
(1, 'China', 'Zhengzhou', 'angry_young_man@gmail.com'),
(2, 'China', 'Shanghai', 'abhishek@abhishekbachchan.org'),
(3, 'America', 'New York', 'ash@gmail.com')
GO

SELECT * FROM Customers
GO

SELECT * FROM Customers_addinfo
GO
