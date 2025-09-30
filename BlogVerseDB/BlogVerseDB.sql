CREATE DATABASE BlogVerseDB;

CREATE TABLE Users(Id  UNIQUEIDENTIFIER NOT NULL  PRIMARY KEY DEFAULT NEWID() ,
                   Username NVARCHAR(50),
                   Email NVARCHAR(100),
                   PassWordHash NVARCHAR(255),
                   Bio NVARCHAR(500),
                   CreatedAt DATETIME2,
                   UpdatedAt DATETIME2,
                   IsActive BIT);

CREATE TABLE Post(Id UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
                  Title NVARCHAR(200),
                  Content NVARCHAR(MAX),
                  AuthorId UNIQUEIDENTIFIER,
                  CreatedAt DATETIME2,
                  UpdatedAt DATETIME2,
                  Published bit);

CREATE TABLE Comments (Id UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
                       Content NVARCHAR(MAX),
                       AuthorId UNIQUEIDENTIFIER,
                       PostId UNIQUEIDENTIFIER,
                       CreateAt DATETIME2,
                       UpdateAt DATETIME2);

CREATE TABLE Roles(Id UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
                    Name  NVARCHAR(50));
CREATE TABLE UserRoles(UserId UNIQUEIDENTIFIER,
                       RoleId UNIQUEIDENTIFIER);