USE master;
GO
IF DB_ID('UniversityDB') IS NOT NULL
BEGIN
    ALTER DATABASE UniversityDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE UniversityDB;
END
GO
CREATE DATABASE UniversityDB;
GO
USE UniversityDB;
GO

CREATE TABLE Faculties (
    FacultyId INT IDENTITY(1,1) PRIMARY KEY,
    Name      NVARCHAR(100) NOT NULL
);

CREATE TABLE Students (
    StudentId INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName  NVARCHAR(50) NOT NULL,
    Age       INT NOT NULL,
    Email     NVARCHAR(150) NULL,
    FacultyId INT NULL,
    CONSTRAINT FK_Students_Faculties FOREIGN KEY (FacultyId) REFERENCES Faculties(FacultyId)
);

CREATE TABLE Courses (
    CourseId INT IDENTITY(1,1) PRIMARY KEY,
    Name     NVARCHAR(100) NOT NULL
);

CREATE TABLE Grades (
    GradeId   INT IDENTITY(1,1) PRIMARY KEY,
    StudentId INT NOT NULL,
    CourseId  INT NOT NULL,
    Score     INT NOT NULL CHECK (Score BETWEEN 0 AND 100),
    CONSTRAINT FK_Grades_Students FOREIGN KEY (StudentId) REFERENCES Students(StudentId),
    CONSTRAINT FK_Grades_Courses  FOREIGN KEY (CourseId)  REFERENCES Courses(CourseId)
);
GO

INSERT INTO Faculties (Name) VALUES
(N'İnformatika'), (N'Riyaziyyat'), (N'Fizika'), (N'Kimya');

INSERT INTO Students (FirstName, LastName, Age, FacultyId) VALUES
(N'Aysel', N'Məmmədova', 19, 1),
(N'Rəşad', N'Əliyev',    21, 1),
(N'Leyla', N'Hüseynova', 20, 2),
(N'Tural', N'Quliyev',   22, 3),
(N'Murad', N'Mikayılov', 18, 2),
(N'Nigar', N'Məlikova',  23, 1),
(N'Elvin', N'Həsənov',   20, NULL),
(N'Səbinə', N'Rzayeva',  21, 3);

INSERT INTO Courses (Name) VALUES (N'C#'), (N'SQL'), (N'Analiz'), (N'Fizika');

INSERT INTO Grades (StudentId, CourseId, Score) VALUES
(1, 1, 90), (1, 2, 85),
(2, 1, 70), (2, 2, 75),
(3, 3, 88), (3, 1, 72),
(4, 4, 60), (4, 2, 65),
(5, 3, 95), (5, 1, 55),
(6, 1, 78), (6, 2, 82);
GO

USE UniversityDB;
GO


SELECT s.FirstName, s.LastName, c.Name AS Course, g.Score
FROM Grades g
INNER JOIN Students s ON s.StudentId = g.StudentId
INNER JOIN Courses  c ON c.CourseId  = g.CourseId;

SELECT s.FirstName, s.LastName, c.Name AS Course, g.Score
FROM Grades g
INNER JOIN Students s ON s.StudentId = g.StudentId
INNER JOIN Courses  c ON c.CourseId  = g.CourseId
WHERE c.Name = N'C#'
ORDER BY g.Score DESC;

SELECT c.Name AS Course, AVG(g.Score * 1.0) AS [Orta qiymət]
FROM Courses c
INNER JOIN Grades g ON g.CourseId = c.CourseId
GROUP BY c.Name;

SELECT s.StudentId, s.FirstName, s.LastName
FROM Students s
LEFT JOIN Grades g ON g.StudentId = s.StudentId
WHERE g.GradeId IS NULL;
