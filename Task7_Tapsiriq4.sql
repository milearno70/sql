USE master;
GO
IF DB_ID('LibraryDB') IS NOT NULL BEGIN ALTER DATABASE LibraryDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE; DROP DATABASE LibraryDB; END
GO
CREATE DATABASE LibraryDB;
GO
USE LibraryDB;
GO

CREATE TABLE Authors (
    AuthorId INT IDENTITY(1,1) PRIMARY KEY,
    FullName NVARCHAR(100) NOT NULL
);

CREATE TABLE Books (
    BookId      INT IDENTITY(1,1) PRIMARY KEY,
    Title       NVARCHAR(200) NOT NULL,
    PublishYear INT NOT NULL,
    AuthorId    INT NOT NULL,
    Price       DECIMAL(8,2) NOT NULL CHECK (Price > 0),
    CONSTRAINT FK_Books_Authors FOREIGN KEY (AuthorId) REFERENCES Authors(AuthorId)
);

CREATE TABLE Members (
    MemberId INT IDENTITY(1,1) PRIMARY KEY,
    FullName NVARCHAR(100) NOT NULL,
    Email    NVARCHAR(150) NOT NULL UNIQUE
);

CREATE TABLE Loans (
    LoanId     INT IDENTITY(1,1) PRIMARY KEY,
    BookId     INT NOT NULL,
    MemberId   INT NOT NULL,
    LoanDate   DATETIME NOT NULL DEFAULT GETDATE(),
    ReturnDate DATETIME NULL,
    CONSTRAINT FK_Loans_Books   FOREIGN KEY (BookId)   REFERENCES Books(BookId),
    CONSTRAINT FK_Loans_Members FOREIGN KEY (MemberId) REFERENCES Members(MemberId)
);
GO

INSERT INTO Authors (FullName) VALUES
(N'Nizami Gəncəvi'), (N'Cəfər Cabbarlı'), (N'Anar Rzayev'), (N'Elçin Əfəndiyev');

INSERT INTO Books (Title, PublishYear, AuthorId, Price) VALUES
(N'Leyli və Məcnun',   1188, 1, 12.50),
(N'Xosrov və Şirin',   1180, 1, 11.00),
(N'Od gəlini',         1928, 2, 9.90),
(N'Sevil',             1929, 2, 8.75),
(N'Beşmərtəbəli evin altıncı mərtəbəsi', 1980, 3, 10.20),
(N'Mahmud və Məryəm',  1978, 4, 13.40),
(N'Ağ dəvə',           1982, 4, 7.60),
(N'Dantenin yubileyi', 1979, 3, 9.30);

INSERT INTO Members (FullName, Email) VALUES
(N'Aysel Məmmədova', 'aysel@mail.az'),
(N'Rəşad Əliyev',    'resad@mail.az'),
(N'Leyla Hüseynova', 'leyla@mail.az'),
(N'Tural Quliyev',   'tural@mail.az');

INSERT INTO Loans (BookId, MemberId, LoanDate, ReturnDate) VALUES
(1, 1, '2026-10-01', '2026-10-15'),
(2, 1, '2026-10-05', NULL),
(3, 2, '2026-10-07', '2026-10-20'),
(4, 2, '2026-10-10', NULL),
(5, 3, '2026-10-12', '2026-10-25'),
(6, 3, '2026-10-15', NULL),
(1, 4, '2026-10-20', NULL),
(3, 1, '2026-11-01', '2026-11-08');
GO

SELECT b.BookId, b.Title, b.PublishYear, b.Price, a.FullName AS Author
FROM Books b
INNER JOIN Authors a ON a.AuthorId = b.AuthorId;

SELECT b.BookId, b.Title
FROM Books b
LEFT JOIN Loans l ON l.BookId = b.BookId
WHERE l.LoanId IS NULL;

SELECT m.MemberId, m.FullName, COUNT(l.LoanId) AS LoanCount
FROM Members m
LEFT JOIN Loans l ON l.MemberId = m.MemberId
GROUP BY m.MemberId, m.FullName;

SELECT b.Title, m.FullName AS Member, l.LoanDate
FROM Loans l
INNER JOIN Books   b ON b.BookId   = l.BookId
INNER JOIN Members m ON m.MemberId = l.MemberId
WHERE l.ReturnDate IS NULL;
