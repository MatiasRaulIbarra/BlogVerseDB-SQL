CREATE DATABASE BlogVerseDB;

CREATE TABLE Users(Id  INT NOT NULL IDENTITY ,
                   Username NVARCHAR(50),
                   Email NVARCHAR(100),
                   PassWordHash NVARCHAR(255),
                   Bio NVARCHAR(500),
                   CreatedAt DATETIME2,
                   UpdatedAt DATETIME2,
                   IsActive BIT);