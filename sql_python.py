

#################################################  pymssql  #################################################

import pymssql 


def connect():
    connect = pymssql.connect(host='localhost', user='', password='', database='cyx_testdb', port='1433') #服务器名,账户,密码,数据库名
    if connect:
        print("Successfully connected !")
    return connect


if __name__ == '__main__':

    database = connect()
    cursor = database.cursor()
    
    # CREATE TABLE
    cursor.execute("DROP TABLE IF EXISTS [Customers_py]") 
    database.commit()

    cursor.execute("CREATE TABLE [dbo].[Customers_py](\
        [CustId] [int] IDENTITY(1,1),\
            [FirstName] [nvarchar](50) NOT NULL,\
                [LastName] [nvarchar](50),\
                    [DateOfBirth][date] NOT NULL,\
                        [YearOfBirth][int],\
                            [Email] [nvarchar](50) UNIQUE,\
                                [Country] [nvarchar](50) NOT NULL, \
                                    PRIMARY KEY CLUSTERED ([CustId] ASC) ON [PRIMARY])") 
    database.commit()
    
    # INSERT DATA
    sql = "INSERT INTO [dbo].[Customers_py]([FirstName],[LastName],[DateOfBirth], [YearOfBirth],[Email],[Country])\
            VALUES\
            ('Amitabh', 'Bachchan', '1942-07-10', '1942', 'angry_young_man@gmail.com','China'),\
                ('Abhishek', 'Bachchan', '1976-05-06', '1976', 'abhishek@abhishekbachchan.org','China'),\
                    ('Aishwarya', 'Rai', '1973-11-06', '1973', 'ash@gmail.com','America'),\
                        ('Aamir', 'Khan', '1965-04-28', '1965', 'aamir@khan.com','China'),\
                            ('Abcd', 'Xyz', '1965-04-28', '1965', 'abc@xyz.com','China'),\
                                ('Abcde', 'Xyz', '1965-04-28', '1965', 'abcde@xyz.com','America'),\
                                    ('Python', 'Python', '9999-01-01', '9999', 'python@python.com','World')"

    try:
        cursor.execute(sql)
        database.commit()
    except:
        database.rollback()
        print("Something Wrong !")
    
    # SELECT DATA
    # row = cursor.fetchone()
    # row = cursor.fetchall()
    # cursor.rowcount
    sql = "SELECT * FROM Customers_py"
    cursor.execute(sql)   
    row = cursor.fetchone()
    while row:
        print("CustID=%s, FirstName=%s, LastName=%s, DateOfBirth=%s, YearOfBirth=%s, Email=%s, Country=%s" % (row[0],row[1],row[2],row[3],row[4],row[5],row[6]))
        row = cursor.fetchone()

    sql = "SELECT * FROM Customers_py"
    cursor.execute(sql)  
    row = cursor.fetchall()
    index = 0
    while index < cursor.rowcount:
        print(row[index])
        index += 1


    # CLOSE ALL
    cursor.close()   
    database.close()  



















#################################################  MySQLdb  #################################################

# import MySQLdb

# # 打开数据库连接
# db = MySQLdb.connect("localhost", "root", " ", "mysql", charset='utf8' )

# # 使用cursor()方法获取操作游标 
# cursor = db.cursor()

# # 使用execute方法执行SQL语句
# cursor.execute("SELECT VERSION()")

# # 使用 fetchone() 方法获取一条数据
# data = cursor.fetchone()

# print("Database version : %s " % data)

# # 关闭数据库连接
# db.close()