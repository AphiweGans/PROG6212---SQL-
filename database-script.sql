/* =========================================================
   RaceDay - Database Creation & Seed Script
   Part 1 - System Planning and Database
   Run in SQL Server Management Studio (SSMS) on a clean instance
   ========================================================= */

IF DB_ID('RaceDayDB') IS NULL
BEGIN
    CREATE DATABASE RaceDayDB;
END
GO

USE RaceDayDB;
GO

/* =========================================================
   DROP TABLES (for re-runs on a clean instance)
   Order matters because of foreign key dependencies
   ========================================================= */
IF OBJECT_ID('dbo.Result', 'U') IS NOT NULL DROP TABLE dbo.Result;
IF OBJECT_ID('dbo.Enrolment', 'U') IS NOT NULL DROP TABLE dbo.Enrolment;
IF OBJECT_ID('dbo.Category', 'U') IS NOT NULL DROP TABLE dbo.Category;
IF OBJECT_ID('dbo.Event', 'U') IS NOT NULL DROP TABLE dbo.Event;
IF OBJECT_ID('dbo.Participant', 'U') IS NOT NULL DROP TABLE dbo.Participant;
IF OBJECT_ID('dbo.Organiser', 'U') IS NOT NULL DROP TABLE dbo.Organiser;
GO

/* =========================================================
   TABLE: Organiser
   ========================================================= */
CREATE TABLE dbo.Organiser (
    OrganiserId     INT IDENTITY(1,1) PRIMARY KEY,
    FullName        NVARCHAR(150) NOT NULL,
    Email           NVARCHAR(150) NOT NULL UNIQUE,
    PasswordHash    NVARCHAR(255) NOT NULL,
    Organisation    NVARCHAR(150) NULL,
    CreatedAt       DATETIME NOT NULL DEFAULT GETDATE()
);
GO

/* =========================================================
   TABLE: Participant
   ========================================================= */
CREATE TABLE dbo.Participant (
    ParticipantId   INT IDENTITY(1,1) PRIMARY KEY,
    FullName        NVARCHAR(150) NOT NULL,
    Email           NVARCHAR(150) NOT NULL UNIQUE,
    PasswordHash    NVARCHAR(255) NOT NULL,
    DateOfBirth     DATE NULL,
    CreatedAt       DATETIME NOT NULL DEFAULT GETDATE()
);
GO

/* =========================================================
   TABLE: Event
   ========================================================= */
CREATE TABLE dbo.Event (
    EventId         INT IDENTITY(1,1) PRIMARY KEY,
    OrganiserId     INT NOT NULL,
    Name            NVARCHAR(200) NOT NULL,
    Description     NVARCHAR(1000) NULL,
    EventDate       DATE NOT NULL,
    Location        NVARCHAR(200) NOT NULL,
    EventType       NVARCHAR(50) NOT NULL, -- e.g. Running, Cycling, Walking
    CreatedAt       DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_Event_Organiser FOREIGN KEY (OrganiserId)
        REFERENCES dbo.Organiser(OrganiserId)
        ON DELETE CASCADE
);
GO

/* =========================================================
   TABLE: Category
   ========================================================= */
CREATE TABLE dbo.Category (
    CategoryId      INT IDENTITY(1,1) PRIMARY KEY,
    EventId         INT NOT NULL,
    Name            NVARCHAR(100) NOT NULL, -- e.g. "10km", "21km"
    DistanceKm      DECIMAL(5,2) NOT NULL,
    EntryFee        DECIMAL(8,2) NOT NULL DEFAULT 0,
    MaxParticipants INT NOT NULL DEFAULT 500,
    CONSTRAINT FK_Category_Event FOREIGN KEY (EventId)
        REFERENCES dbo.Event(EventId)
        ON DELETE CASCADE
);
GO

/* =========================================================
   TABLE: Enrolment
   ========================================================= */
CREATE TABLE dbo.Enrolment (
    EnrolmentId     INT IDENTITY(1,1) PRIMARY KEY,
    ParticipantId   INT NOT NULL,
    CategoryId      INT NOT NULL,
    EnrolmentDate   DATETIME NOT NULL DEFAULT GETDATE(),
    RaceNumber      NVARCHAR(20) NOT NULL UNIQUE,
    Status          NVARCHAR(20) NOT NULL DEFAULT 'Active', -- Active, Cancelled, Withdrawn
    CONSTRAINT FK_Enrolment_Participant FOREIGN KEY (ParticipantId)
        REFERENCES dbo.Participant(ParticipantId)
        ON DELETE CASCADE,
    CONSTRAINT FK_Enrolment_Category FOREIGN KEY (CategoryId)
        REFERENCES dbo.Category(CategoryId)
        ON DELETE CASCADE,
    CONSTRAINT UQ_Enrolment_Participant_Category UNIQUE (ParticipantId, CategoryId)
);
GO

/* =========================================================
   TABLE: Result
   ========================================================= */
CREATE TABLE dbo.Result (
    ResultId          INT IDENTITY(1,1) PRIMARY KEY,
    EnrolmentId       INT NOT NULL UNIQUE,
    FinishTime        TIME NOT NULL,
    OverallPosition    INT NULL,
    CategoryPosition   INT NULL,
    CapturedAt        DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_Result_Enrolment FOREIGN KEY (EnrolmentId)
        REFERENCES dbo.Enrolment(EnrolmentId)
        ON DELETE CASCADE
);
GO

/* =========================================================
   SEED DATA
   ========================================================= */

-- Organisers
INSERT INTO dbo.Organiser (FullName, Email, PasswordHash, Organisation) VALUES
('Thabo Nkosi',   'thabo.nkosi@raceday.co.za',   'HASHED_PASSWORD_1', 'Comrades Marathon Association'),
('Lindiwe Zulu',  'lindiwe.zulu@raceday.co.za',  'HASHED_PASSWORD_2', 'Two Oceans Marathon NPC');
GO

-- Participants
INSERT INTO dbo.Participant (FullName, Email, PasswordHash, DateOfBirth) VALUES
('Sarah van der Merwe', 'sarah.vdm@example.com', 'HASHED_PASSWORD_3', '1994-03-12'),
('Sipho Dlamini',       'sipho.dlamini@example.com', 'HASHED_PASSWORD_4', '1989-07-25');
GO

-- Events
INSERT INTO dbo.Event (OrganiserId, Name, Description, EventDate, Location, EventType) VALUES
(1, 'Comrades Marathon 2027', 'The ultimate human race between Pietermaritzburg and Durban.', '2027-06-13', 'Pietermaritzburg, KZN', 'Running'),
(2, 'Two Oceans Marathon 2027', 'Scenic ultra-marathon around the Cape Peninsula.', '2027-04-10', 'Cape Town, WC', 'Running'),
(1, 'Cape Town Cycle Tour 2027', 'The world''s largest individually timed cycle race.', '2027-03-08', 'Cape Town, WC', 'Cycling');
GO

-- Categories
INSERT INTO dbo.Category (EventId, Name, DistanceKm, EntryFee, MaxParticipants) VALUES
(1, 'Comrades Down Run - 87km', 87.00, 950.00, 20000),
(2, 'Two Oceans Ultra - 56km', 56.00, 850.00, 11000),
(2, 'Two Oceans Half Marathon - 21km', 21.10, 550.00, 16000),
(3, 'Cycle Tour - 109km', 109.00, 750.00, 35000);
GO

-- Enrolments
INSERT INTO dbo.Enrolment (ParticipantId, CategoryId, RaceNumber, Status) VALUES
(1, 3, 'RD-2027-0001', 'Active'),  -- Sarah entered the Two Oceans Half Marathon
(2, 1, 'RD-2027-0002', 'Active'),  -- Sipho entered the Comrades Down Run
(2, 4, 'RD-2027-0003', 'Active');  -- Sipho also entered the Cycle Tour
GO

-- Results (only for past/completed enrolments in this sample)
INSERT INTO dbo.Result (EnrolmentId, FinishTime, OverallPosition, CategoryPosition) VALUES
(1, '01:48:32', 452, 87);
GO

/* =========================================================
   VERIFICATION QUERIES (optional - run manually to check)
   ========================================================= */
-- SELECT * FROM dbo.Organiser;
-- SELECT * FROM dbo.Participant;
-- SELECT * FROM dbo.Event;
-- SELECT * FROM dbo.Category;
-- SELECT * FROM dbo.Enrolment;
-- SELECT * FROM dbo.Result;
