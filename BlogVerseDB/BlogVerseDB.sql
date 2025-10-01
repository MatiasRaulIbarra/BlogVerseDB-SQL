CREATE DATABASE BlogVerseDB;

CREATE TABLE Users(Id  UNIQUEIDENTIFIER NOT NULL  PRIMARY KEY DEFAULT NEWID() ,
                   Username NVARCHAR(50),
                   Email NVARCHAR(100),
                   PassWordHash NVARCHAR(255),
                   Bio NVARCHAR(500),
                   CreatedAt DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
                   UpdatedAt DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
                   IsActive BIT);

CREATE TABLE Post(Id UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
                  Title NVARCHAR(200),
                  Content NVARCHAR(MAX),
                  AuthorId UNIQUEIDENTIFIER NOT NULL,
                  CreatedAt DATETIME2,
                  UpdatedAt DATETIME2,
                  Published BIT NULL DEFAULT 1,
                  CONSTRAINT FK_Posts_Users FOREIGN KEY(AuthorId) REFERENCES Users(Id) );

CREATE TABLE Comments (Id UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
                       Content NVARCHAR(MAX),
                       AuthorId UNIQUEIDENTIFIER,
                       PostId UNIQUEIDENTIFIER NOT NULL,
                       CreateAt DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
                       UpdateAt DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
                       CONSTRAINT FK_Comments_Users FOREIGN KEY(AuthorId) REFERENCES Users(Id),
                       CONSTRAINT FK_Comments_Posts FOREIGN KEY(PostId) REFERENCES Posts(Id)
                       );

CREATE TABLE Roles(Id UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
                    Name  NVARCHAR(50) NOT NULL UNIQUE);

CREATE TABLE UserRoles(UserId UNIQUEIDENTIFIER NOT NULL,
                       RoleId UNIQUEIDENTIFIER NOT NULL,
                       CONSTRAINT PK_UsersRoles PRIMARY KEY (UserId,RoleId),
                       CONSTRAINT PK_Users_Roles FOREIGN KEY (UserId) REFERENCES Users(Id),
                       CONSTRAINT PK_Roles_Users FOREIGN KEY(RolesId) REFERENCES Posts(Id));