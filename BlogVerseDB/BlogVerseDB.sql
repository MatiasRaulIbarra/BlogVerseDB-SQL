CREATE DATABASE BlogVerseDB;

CREATE TABLE Users(Id  UNIQUEIDENTIFIER NOT NULL  PRIMARY KEY DEFAULT NEWID() ,
                   Username NVARCHAR(50),
                   Email NVARCHAR(100),
                   PassWordHash NVARCHAR(255),
                   Bio NVARCHAR(500),
                   CreatedAt DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
                   UpdatedAt DATETIME2 NOT NULL DEFAULT SYSDATETIME()
                   );

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


-- Insert initial test data into Users table
INSERT INTO Users (Username, Email) VALUES ('Matias', 'matias.test@blog.com');
INSERT INTO Users (Username, Email) VALUES ('Juan', 'juan.test@blog.com');
INSERT INTO Users (Username, Email) VALUES ('Pedro', 'pedro.test@blog.com');

--Insert initial test data into Posts table
INSERT INTO Posts(Id,Title,AuthorId) VALUES('b23fa8d1-7a4c-43c1-b549-a258fccf8801','Programming','76af12c8-629b-4d16-8916-1240f39bde7b');
INSERT INTO Posts(Id,Title,AuthorId) VALUES('4e2a1f09-5721-491e-9111-0f1dcb333280','Data Analyst','a8ab3259-294a-4af9-a775-bc21fc74d654');
INSERT INTO Posts(Id,Title,AuthorId) VALUES('98c79646-ec28-4759-8b94-162784b70676','Data Science','4a7a48c6-56a3-4bc4-9b96-58e1de604592');

--Queries in SQL Server 
SELECT * FROM Users ORDER BY Username;

--POST TABLE 
SELECT COUNT(Username) AS TOTAL FROM Users;
SELECT * FROM Posts WHERE AuthorId = '76AF12C8-629B-4D16-8916-1240F39BDE7B';


--INNER JOIN  between Users and posts

SELECT * FROM Users
INNER JOIN Posts
ON Users.Id = Posts.AuthorId;

--LEFT JOIN between Post + comments post 

SELECT 
    p.Id AS PostId,
    p.Title,
    p.Content,
    p.CreatedAt,
    u.Username AS Author,
    COUNT(c.Id) AS CommentCount
FROM Posts p
LEFT JOIN Users u ON p.AuthorId = u.Id
LEFT JOIN Comments c ON p.Id = c.PostId
GROUP BY 
    p.Id, 
    p.Title, 
    p.Content, 
    p.CreatedAt, 
    u.Username
ORDER BY p.CreatedAt DESC;

--TOTAL OF POST BY USERS
SELECT 
u.Username,
COUNT(p.Id) AS TotalPost
FROM Users  u
LEFT  JOIN 
Posts p ON u.Id = p.AuthorId
GROUP BY
u.Username
ORDER BY
TotalPost DESC;

--

SELECT 
    u.Username,
    COUNT(p.Id) AS TotalPosts
FROM 
    Users u
LEFT JOIN 
    Posts p ON u.Id = p.AuthorId
GROUP BY 
    u.Username;


--View_PublishedPosts
CREATE VIEW View_PublishedPosts
AS
SELECT 
    p.Id AS PostId,
    p.Title,
    p.Content,
    p.CreatedAt,
    u.Username AS Author,
    COUNT(c.Id) AS CommentCount
FROM Posts p
LEFT JOIN Users u ON p.AuthorId = u.Id
LEFT JOIN Comments c ON p.Id = c.PostId
WHERE p.Published = 1
GROUP BY 
    p.Id, 
    p.Title, 
    p.Content, 
    p.CreatedAt, 
    u.Username;


--
CREATE FUNCTION fn_CountPostsByUser (@UserId UNIQUEIDENTIFIER)
RETURNS INT
AS
BEGIN
    DECLARE @TotalPosts INT;

    SELECT @TotalPosts = COUNT(*)
    FROM Posts
    WHERE AuthorId = @UserId;

    RETURN @TotalPosts;
END;

SELECT 
    u.Username,
    dbo.fn_CountPostsByUser(u.Id) AS TotalPosts
FROM 
    Users u;
--store procedure
CREATE PROCEDURE sp_RegisterUser
    @Username NVARCHAR(50),
    @Email NVARCHAR(100),
    @PasswordHash NVARCHAR(255),
    @Bio NVARCHAR(500) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Users (Username, Email, PasswordHash, Bio, CreatedAt, UpdatedAt)
    VALUES (@Username, @Email, @PasswordHash, @Bio, SYSDATETIME(), SYSDATETIME());
END;
