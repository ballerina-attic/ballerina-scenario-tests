IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'simpledb')
BEGIN
    CREATE DATABASE simpledb;
END;
/
USE simpledb;
/
