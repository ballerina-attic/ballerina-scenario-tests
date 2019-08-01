IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'testdb')
BEGIN
    CREATE DATABASE testdb;
END;
/
USE testdb;
/
