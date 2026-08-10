IF DB_ID('RaceDayDB') IS NULL
BEGIN
    CREATE DATABASE RaceDayDB;
END
GO

USE RaceDayDB;
GO

IF OBJECT_ID('dbo.Results', 'U') IS NOT NULL DROP TABLE dbo.Results;
IF OBJECT_ID('dbo.Enrolments', 'U') IS NOT NULL DROP TABLE dbo.Enrolments;
IF OBJECT_ID('dbo.Categories', 'U') IS NOT NULL DROP TABLE dbo.Categories;
IF OBJECT_ID('dbo.RefreshTokens', 'U') IS NOT NULL DROP TABLE dbo.RefreshTokens;
IF OBJECT_ID('dbo.Events', 'U') IS NOT NULL DROP TABLE dbo.Events;
IF OBJECT_ID('dbo.Users', 'U') IS NOT NULL DROP TABLE dbo.Users;
GO

CREATE TABLE dbo.Users (
    UserId INT IDENTITY(1,1) PRIMARY KEY,
    FullName NVARCHAR(150) NOT NULL,
    Email NVARCHAR(256) NOT NULL,
    PasswordHash NVARCHAR(MAX) NOT NULL,
    Role NVARCHAR(20) NOT NULL,
    PhoneNumber NVARCHAR(20) NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT UQ_Users_Email UNIQUE (Email),
    CONSTRAINT CK_Users_Role CHECK (Role IN ('Organiser', 'Participant'))
);
GO

CREATE TABLE dbo.Events (
    EventId INT IDENTITY(1,1) PRIMARY KEY,
    OrganiserId INT NOT NULL,
    Name NVARCHAR(150) NOT NULL,
    EventType NVARCHAR(50) NOT NULL,
    EventDate DATETIME2 NOT NULL,
    Location NVARCHAR(200) NOT NULL,
    Description NVARCHAR(MAX) NULL,
    RouteInfo NVARCHAR(MAX) NULL,
    WeatherInfo NVARCHAR(MAX) NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_Events_Organiser FOREIGN KEY (OrganiserId)
        REFERENCES dbo.Users(UserId)
);
GO

CREATE TABLE dbo.Categories (
    CategoryId INT IDENTITY(1,1) PRIMARY KEY,
    EventId INT NOT NULL,
    Name NVARCHAR(100) NOT NULL,
    DistanceKm DECIMAL(5,2) NULL,
    MinAge INT NULL,
    MaxAge INT NULL,
    CONSTRAINT FK_Categories_Event FOREIGN KEY (EventId)
        REFERENCES dbo.Events(EventId) ON DELETE CASCADE
);
GO

CREATE TABLE dbo.Enrolments (
    EnrolmentId INT IDENTITY(1,1) PRIMARY KEY,
    ParticipantId INT NOT NULL,
    EventId INT NOT NULL,
    CategoryId INT NOT NULL,
    EnrolmentDate DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    Status NVARCHAR(20) NOT NULL DEFAULT 'Active',
    CONSTRAINT FK_Enrolments_Participant FOREIGN KEY (ParticipantId)
        REFERENCES dbo.Users(UserId),
    CONSTRAINT FK_Enrolments_Event FOREIGN KEY (EventId)
        REFERENCES dbo.Events(EventId),
    CONSTRAINT FK_Enrolments_Category FOREIGN KEY (CategoryId)
        REFERENCES dbo.Categories(CategoryId),
    CONSTRAINT UQ_Enrolments_Participant_Event UNIQUE (ParticipantId, EventId)
);
GO

CREATE TABLE dbo.Results (
    ResultId INT IDENTITY(1,1) PRIMARY KEY,
    EnrolmentId INT NOT NULL,
    FinishTime TIME NULL,
    Position INT NULL,
    Status NVARCHAR(20) NOT NULL DEFAULT 'Pending',
    RecordedAt DATETIME2 NULL,
    CONSTRAINT FK_Results_Enrolment FOREIGN KEY (EnrolmentId)
        REFERENCES dbo.Enrolments(EnrolmentId),
    CONSTRAINT UQ_Results_Enrolment UNIQUE (EnrolmentId)
);
GO

CREATE TABLE dbo.RefreshTokens (
    TokenId INT IDENTITY(1,1) PRIMARY KEY,
    UserId INT NOT NULL,
    Token NVARCHAR(MAX) NOT NULL,
    ExpiresAt DATETIME2 NOT NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    Revoked BIT NOT NULL DEFAULT 0,
    CONSTRAINT FK_RefreshTokens_User FOREIGN KEY (UserId)
        REFERENCES dbo.Users(UserId)
);
GO
