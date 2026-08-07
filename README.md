## RaceDay — Road Event Management System

## Portfolio of Evidence — Part 1
## System Planning and Database
## ERD • REST API Endpoint Plan • SQL Server Database

## 1. Project Overview

RaceDay is a web-based event management platform designed for the South African road running, walking, and cycling community.

The system is intended to improve the management of road events by providing a structured platform where Event Organisers can create and manage events, categories, participants, enrolments, and results, while Participants can browse upcoming events, enter events, and view their personal performance history.

Part 1 focuses on system planning and database design. No application or API implementation is included at this stage.

The three major deliverables are:

Entity Relationship Diagram (ERD)
RESTful API Endpoint Plan
SQL Server database creation and seed script

These components have been designed to remain consistent so that the API in Part 2 and MVC application in Part 3 can be implemented from the same design.

## 2. Project Objectives

The main objectives of RaceDay are to:

Provide a structured platform for road event management.
Allow Organisers to create and manage events.
Allow Organisers to define event categories.
Allow Participants to browse upcoming events.
Allow Participants to enrol in events.
Prevent duplicate enrolments for the same event.
Allow Organisers to capture participant results.
Allow Participants to view their personal results.
Provide public access to appropriate event and results information.
Provide JWT-based authentication planning for future API implementation.
Maintain consistency between the ERD, API and database.

## 3. User Roles

RaceDay contains exactly two system roles:

Role	Description
Organiser	Creates and manages events, categories, enrolments and participant results.
Participant	Browses events, enrols in events and views personal enrolments and results.

No Administrator or Superuser role is introduced in Part 1.

Role Responsibilities
Organiser

An Organiser can:

Create events.
Update events they own.
Delete events they own.
Create event categories.
Update categories.
Delete categories.
View enrolments for their events.
Capture participant results.
Update results.
Participant

A Participant can:

Browse upcoming events.
View event details.
View categories.
Enrol in an event.
View their own enrolments.
Cancel their own enrolment.
View their personal results history.

## 4. System Assumptions

The following assumptions are used in the RaceDay database and API design:

There are exactly two roles: Organiser and Participant.
An Organiser who creates an event becomes the owner of that event.
Each Event has one Organiser.
A Category belongs to exactly one Event.
An Enrolment specifies exactly one Category.
A Participant can enrol in the same Event only once.
Duplicate enrolments are prevented using a unique constraint on ParticipantId + EventId.
A Result belongs to a specific Enrolment.
Passwords are stored using PasswordHash, not plain-text passwords.
JWT authentication is planned for Part 2.
Refresh tokens are included to support secure JWT renewal.
Weather and route information are stored as descriptive Event fields rather than separate database entities.

## 5. Entity Relationship Diagram

The RaceDay database contains six entities:

1. Users
2. Events
3. Categories
4. Enrolments
5. Results
6. RefreshTokens

The ERD represents the database structure, primary keys, foreign keys and relationships between the entities.

Entity    	Purpose
Users	   -   Stores Organisers and Participants.
Events	  -  Stores road running, walking and cycling events.
Categories	- Stores categories associated with an event.
Enrolments	- Connects Participants to Events and records their selected Category.
Results	  -  Stores results belonging to an Enrolment.
RefreshTokens	- Supports JWT authentication and token renewal.

## 6. Users Entity

The Users entity stores both Organisers and Participants.

# Attributes
Attribute	Type	Description
UserId - INT	- Primary Key and identity value.
FullName	- NVARCHAR(150)	- User's full name.
Email -	NVARCHAR(256) -	Unique user email address.
PasswordHash	- NVARCHAR(MAX)	- Hashed password.
Role	- NVARCHAR(20)	- Organiser or Participant.
PhoneNumber	- NVARCHAR(20)	- Optional phone number.
CreatedAt	- DATETIME2	- Date/time the user was created.
# Constraints
UserId is the Primary Key.
Email must be unique.
Email cannot be NULL.
Role must be either Organiser or Participant.
Passwords must never be stored as plain text.

## 7. Events Entity

The Events entity stores events created and managed by Organisers.

# Attributes
Attribute	Type	Description
• EventId	- INT	- Primary Key and identity value.
• OrganiserId	- INT	- Foreign Key to Users.UserId.
• Name	- NVARCHAR(150)	- Name of the event.
• EventType	- NVARCHAR(50)	- Event type such as Marathon, Cycling or Walk.
• EventDate	- DATETIME2	- Date and time of the event.
• Location	- NVARCHAR(200)	- Event location.
• Description	- NVARCHAR(MAX)	- Optional event description.
• RouteInfo	- NVARCHAR(MAX)	- Route description or link.
• WeatherInfo	- NVARCHAR(MAX)	- Weather-related information.
• CreatedAt	- DATETIME2	- Date/time the event was created.
• Relationship

Each Event belongs to exactly one Organiser.

One Organiser can create many Events.

# Relationship:

Users 1 → Many Events

## 8. Categories Entity

The Categories entity stores categories associated with individual events.

Examples include:

5km Fun Run
10km Road Race
21.1km Half Marathon
40km Cycle
80km Cycle
Attributes
Attribute	Type	Description
CategoryId	INT	Primary Key and identity value.
EventId	INT	Foreign Key to Events.EventId.
Name	NVARCHAR(100)	Category name.
DistanceKm	DECIMAL(5,2)	Distance in kilometres.
MinAge	INT	Optional minimum age.
MaxAge	INT	Optional maximum age.
Relationship

One Event can have many Categories.

Each Category belongs to exactly one Event.

Relationship:

Events 1 → Many Categories

## 9. Enrolments Entity

The Enrolments entity represents the relationship between Participants and Events.

It also records the Category selected by the Participant.

# Attributes
Attribute	Type	Description
EnrolmentId	INT	Primary Key and identity value.
ParticipantId	INT	Foreign Key to Users.UserId.
EventId	INT	Foreign Key to Events.EventId.
CategoryId	INT	Foreign Key to Categories.CategoryId.
EnrolmentDate	DATETIME2	Date/time of enrolment.
Status	NVARCHAR(20)	Enrolment status.
Important Constraint

A Participant cannot enrol in the same Event more than once.

This is enforced using:

UNIQUE (ParticipantId, EventId)
Relationship

## 10. Results Entity

The Results entity stores the performance result of a participant's enrolment.

# Attributes
Attribute	Type	Description
ResultId	INT	Primary Key and identity value.
EnrolmentId	INT	Foreign Key to Enrolments.EnrolmentId.
FinishTime	TIME	Participant's finishing time.
Position	INT	Participant's finishing position.
Status	NVARCHAR(20)	Result status.
RecordedAt	DATETIME2	Date/time result was recorded.
Relationship

Each Enrolment can have at most one Result.

This is enforced using:

UNIQUE (EnrolmentId)

Therefore:

Enrolments 1 → 0..1 Results

Possible result statuses include:

Pending
Finished
DNF
DNS

Participants and Events have a many-to-many relationship resolved through Enrolments.

Users ↔ Events
      |
 Enrolments

## 11. RefreshTokens Entity

The RefreshTokens entity supports JWT authentication and secure token renewal planned for Part 2.

# Attributes
Attribute	Type	Description
TokenId	INT	Primary Key and identity value.
UserId	INT	Foreign Key to Users.UserId.
Token	NVARCHAR(MAX)	Refresh token value.
ExpiresAt	DATETIME2	Token expiry date/time.
CreatedAt	DATETIME2	Token creation date/time.
Revoked	BIT	Indicates whether token has been revoked.
Relationship

One User can have many RefreshTokens.

Users 1 → Many RefreshTokens

## 12. ERD Relationships

The complete RaceDay relationship structure is:

USERS
  │
  ├───────────────< EVENTS
  │                    │
  │                    └────────< CATEGORIES
  │                                  │
  │                                  │
  ├───────────────< ENROLMENTS >─────┘
  │                     │
  │                     └──── 0..1 RESULT
  │
  └───────────────< REFRESH TOKENS
Mermaid ERD
erDiagram

    USERS ||--o{ EVENTS : "organises"
    EVENTS ||--o{ CATEGORIES : "has"

    USERS ||--o{ ENROLMENTS : "enrols as participant"
    EVENTS ||--o{ ENROLMENTS : "receives"
    CATEGORIES ||--o{ ENROLMENTS : "selected in"

    ENROLMENTS ||--o| RESULTS : "produces"

    USERS ||--o{ REFRESHTOKENS : "owns"

    USERS {
        int UserId PK
        string FullName
        string Email
        string PasswordHash
        string Role
        string PhoneNumber
        datetime CreatedAt
    }

    EVENTS {
        int EventId PK
        int OrganiserId FK
        string Name
        string EventType
        datetime EventDate
        string Location
        string Description
        string RouteInfo
        string WeatherInfo
        datetime CreatedAt
    }

    CATEGORIES {
        int CategoryId PK
        int EventId FK
        string Name
        decimal DistanceKm
        int MinAge
        int MaxAge
    }

    ENROLMENTS {
        int EnrolmentId PK
        int ParticipantId FK
        int EventId FK
        int CategoryId FK
        datetime EnrolmentDate
        string Status
    }

    RESULTS {
        int ResultId PK
        int EnrolmentId FK
        time FinishTime
        int Position
        string Status
        datetime RecordedAt
    }

    REFRESHTOKENS {
        int TokenId PK
        int UserId FK
        string Token
        datetime ExpiresAt
        datetime CreatedAt
        bit Revoked
    }

## 13. REST API Endpoint Plan

The RaceDay API uses RESTful endpoints beginning with:

/api/

JWT Bearer authentication is planned for protected endpoints.

JWT claims are expected to contain:

UserId
Role
Access Levels
Access Level	Meaning
None	Public endpoint. No authentication required.
Any	Any authenticated user.
Organiser	Authenticated Organiser only.
Participant	Authenticated Participant only.

## 14. Authentication Endpoints
Method	Endpoint	Purpose	Role
POST	/api/auth/register	Register a new Organiser or Participant.	None
POST	/api/auth/login	Authenticate and issue access/refresh tokens.	None
POST	/api/auth/refresh	Exchange refresh token for a new access token.	None
POST	/api/auth/logout	Revoke a refresh token.	Any
Registration
POST /api/auth/register

Request:

{
  "fullName": "Example User",
  "email": "user@example.com",
  "password": "password",
  "role": "Participant",
  "phoneNumber": "0730000000"
}

Expected responses:

201 Created
409 Conflict
Login
POST /api/auth/login

Request:

{
  "email": "user@example.com",
  "password": "password"
}

Expected response includes:

accessToken
refreshToken
role

## 15. User Profile Endpoints
Get Current User
GET /api/users/me

Role:

Any authenticated user

Returns the authenticated user's own profile.

Expected responses:

200 OK
401 Unauthorized
Update Current User
PUT /api/users/me

Request:

{
  "fullName": "Updated Name",
  "phoneNumber": "0730000000"
}

Expected responses:

200 OK
400 Bad Request
Security Rule

The /me endpoints must always use the authenticated user's UserId from the JWT.

A user must not be able to access or edit another user's profile using these endpoints.

## 16. Event Endpoints
Method	Endpoint	Role
GET	/api/events	None
GET	/api/events/{eventId}	None
POST	/api/events	Organiser
PUT	/api/events/{eventId}	Organiser
DELETE	/api/events/{eventId}	Organiser
GET	/api/events/{eventId}/weather	None
Event Creation
POST /api/events

Request fields:

name
eventType
eventDate
location
description
routeInfo

Expected:

201 Created
400 Bad Request
Categories
Method	Endpoint	Role
GET	/api/events/{eventId}/categories	None
POST	/api/events/{eventId}/categories	Organiser
PUT	/api/categories/{categoryId}	Organiser
DELETE	/api/categories/{categoryId}	Organiser

Category request fields:

name
distanceKm
minAge
maxAge

## 17. Enrolment Endpoints
Method	Endpoint	Role
POST	/api/events/{eventId}/enrolments	Participant
GET	/api/users/me/enrolments	Participant
GET	/api/events/{eventId}/enrolments	Organiser
DELETE	/api/enrolments/{enrolmentId}	Participant
Enrolment Request
{
  "categoryId": 2
}

Expected responses may include:

201 Created
404 Not Found
409 Conflict

A 409 Conflict occurs when the Participant is already enrolled in the Event.

Result Endpoints
Method	Endpoint	Role
POST	/api/enrolments/{enrolmentId}/result	Organiser
PUT	/api/results/{resultId}	Organiser
GET	/api/events/{eventId}/results	None
GET	/api/users/me/results	Participant

Result fields:

finishTime
position
status

## 18. API Role Enforcement

Protected endpoints must enforce the role associated with the authenticated JWT.

Organiser Ownership

An Organiser can only manage Events they own.

The API must verify:

Events.OrganiserId == authenticated UserId

before allowing actions such as:

Updating an event.
Deleting an event.
Managing categories.
Viewing event enrolments.
Capturing results.
Updating results.
Public Endpoints

The following types of information are intentionally public:

Upcoming events.
Individual event details.
Event categories.
Event results boards.
Route/weather preparation information.

This allows visitors to browse RaceDay before creating an account.

## 19. SQL Server Database
Commit 19 — SQL Database Script

RaceDay uses Microsoft SQL Server / T-SQL.

The database is named:

RaceDayDB
Database Creation
IF DB_ID('RaceDayDB') IS NULL
BEGIN
    CREATE DATABASE RaceDayDB;
END
GO

USE RaceDayDB;
GO
Table Creation Order

Foreign-key dependencies determine the table creation order:

Users
   ↓
Events
   ↓
Categories
   ↓
Enrolments
   ↓
Results

Users
   ↓
RefreshTokens
Users Table
CREATE TABLE dbo.Users (
    UserId INT IDENTITY(1,1) PRIMARY KEY,
    FullName NVARCHAR(150) NOT NULL,
    Email NVARCHAR(256) NOT NULL,
    PasswordHash NVARCHAR(MAX) NOT NULL,
    Role NVARCHAR(20) NOT NULL,
    PhoneNumber NVARCHAR(20) NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),

    CONSTRAINT UQ_Users_Email UNIQUE (Email),

    CONSTRAINT CK_Users_Role
        CHECK (Role IN ('Organiser', 'Participant'))
);
GO
Events Table
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

    CONSTRAINT FK_Events_Organiser
        FOREIGN KEY (OrganiserId)
        REFERENCES dbo.Users(UserId)
);
GO
Categories Table
CREATE TABLE dbo.Categories (
    CategoryId INT IDENTITY(1,1) PRIMARY KEY,
    EventId INT NOT NULL,
    Name NVARCHAR(100) NOT NULL,
    DistanceKm DECIMAL(5,2) NULL,
    MinAge INT NULL,
    MaxAge INT NULL,

    CONSTRAINT FK_Categories_Event
        FOREIGN KEY (EventId)
        REFERENCES dbo.Events(EventId)
        ON DELETE CASCADE
);
GO
Enrolments Table
CREATE TABLE dbo.Enrolments (
    EnrolmentId INT IDENTITY(1,1) PRIMARY KEY,
    ParticipantId INT NOT NULL,
    EventId INT NOT NULL,
    CategoryId INT NOT NULL,
    EnrolmentDate DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    Status NVARCHAR(20) NOT NULL DEFAULT 'Active',

    CONSTRAINT FK_Enrolments_Participant
        FOREIGN KEY (ParticipantId)
        REFERENCES dbo.Users(UserId),

    CONSTRAINT FK_Enrolments_Event
        FOREIGN KEY (EventId)
        REFERENCES dbo.Events(EventId),

    CONSTRAINT FK_Enrolments_Category
        FOREIGN KEY (CategoryId)
        REFERENCES dbo.Categories(CategoryId),

    CONSTRAINT UQ_Enrolments_Participant_Event
        UNIQUE (ParticipantId, EventId)
);
GO
Results Table
CREATE TABLE dbo.Results (
    ResultId INT IDENTITY(1,1) PRIMARY KEY,
    EnrolmentId INT NOT NULL,
    FinishTime TIME NULL,
    Position INT NULL,
    Status NVARCHAR(20) NOT NULL DEFAULT 'Pending',
    RecordedAt DATETIME2 NULL,

    CONSTRAINT FK_Results_Enrolment
        FOREIGN KEY (EnrolmentId)
        REFERENCES dbo.Enrolments(EnrolmentId),

    CONSTRAINT UQ_Results_Enrolment
        UNIQUE (EnrolmentId)
);
GO
RefreshTokens Table
CREATE TABLE dbo.RefreshTokens (
    TokenId INT IDENTITY(1,1) PRIMARY KEY,
    UserId INT NOT NULL,
    Token NVARCHAR(MAX) NOT NULL,
    ExpiresAt DATETIME2 NOT NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    Revoked BIT NOT NULL DEFAULT 0,

    CONSTRAINT FK_RefreshTokens_User
        FOREIGN KEY (UserId)
        REFERENCES dbo.Users(UserId)
);
GO
## 20. Seed Data, Consistency, Setup and Documentation
20.1 Sample Data

The database uses fictional South African-inspired sample data for development and demonstration.

Users
INSERT INTO dbo.Users
    (FullName, Email, PasswordHash, Role, PhoneNumber)
VALUES
    ('Thabo Nkosi', 'thabo.organiser@example.com',
     'HASHED_PASSWORD_1', 'Organiser', '0821234567'),

    ('Lerato Dube', 'lerato.organiser@example.com',
     'HASHED_PASSWORD_2', 'Organiser', '0827654321'),

    ('Sipho Mahlangu', 'sipho.participant@example.com',
     'HASHED_PASSWORD_3', 'Participant', '0731112222'),

    ('Anja van Wyk', 'anja.participant@example.com',
     'HASHED_PASSWORD_4', 'Participant', '0733334444'),

    ('Naledi Molefe', 'naledi.participant@example.com',
     'HASHED_PASSWORD_5', 'Participant', '0735556666');
GO
Events
INSERT INTO dbo.Events
    (OrganiserId, Name, EventType, EventDate, Location, Description, RouteInfo)
VALUES
    (1,
     'Highveld Community Fun Run',
     'Road Race',
     '2026-09-12 07:00',
     'Johannesburg, Gauteng',
     'A community charity run through the Highveld suburbs.',
     'Flat tarred route, closed to traffic.'),

    (1,
     'Vaal River Cycle Challenge',
     'Cycling',
     '2026-10-03 06:30',
     'Vanderbijlpark, Gauteng',
     'An open-road cycling event along the Vaal River.',
     'Rolling hills, water tables at 15km intervals.'),

    (2,
     'Garden Route Half Marathon',
     'Marathon',
     '2026-11-08 06:00',
     'George, Western Cape',
     'A scenic half marathon along the Garden Route.',
     'Coastal road route with moderate elevation gain.');
GO
Categories
INSERT INTO dbo.Categories
    (EventId, Name, DistanceKm, MinAge, MaxAge)
VALUES
    (1, '5km Fun Run', 5.0, NULL, NULL),
    (1, '10km Road Race', 10.0, 16, NULL),
    (2, '40km Cycle', 40.0, 18, NULL),
    (2, '80km Cycle', 80.0, 18, NULL),
    (3, '21.1km Half Marathon', 21.1, 18, NULL);
GO
Enrolments
INSERT INTO dbo.Enrolments
    (ParticipantId, EventId, CategoryId, Status)
VALUES
    (3, 1, 2, 'Active'),
    (4, 2, 3, 'Active'),
    (5, 3, 5, 'Active');
GO
Results
INSERT INTO dbo.Results
    (EnrolmentId, FinishTime, Position, Status, RecordedAt)
VALUES
    (1, '00:52:14', 12, 'Finished', SYSUTCDATETIME());
GO
20.2 ERD ↔ SQL Consistency

The ERD and SQL database are designed to match.

Entity Consistency

Every ERD entity has a corresponding SQL table:

Users          → dbo.Users
Events         → dbo.Events
Categories     → dbo.Categories
Enrolments     → dbo.Enrolments
Results        → dbo.Results
RefreshTokens  → dbo.RefreshTokens
Primary Key Consistency

Each ERD Primary Key corresponds to an SQL IDENTITY PRIMARY KEY.

Foreign Key Consistency

Each ERD Foreign Key has a matching SQL FOREIGN KEY constraint.

Relationship Consistency

The following relationships are maintained:

Users → Events
Events → Categories
Users → Enrolments
Events → Enrolments
Categories → Enrolments
Enrolments → Results
Users → RefreshTokens

The one-to-one relationship between Enrolments and Results is enforced using:

UNIQUE (EnrolmentId)

The duplicate enrolment rule is enforced using:

UNIQUE (ParticipantId, EventId)
20.3 ERD ↔ API Consistency

The API maps directly to the database design.

Database Entity	API Endpoint Group
Users	/api/auth/* and /api/users/me
Events	/api/events/*
Categories	/api/events/{eventId}/categories and /api/categories/*
Enrolments	/api/events/{eventId}/enrolments and /api/users/me/enrolments
Results	/api/enrolments/{enrolmentId}/result and /api/results/*
RefreshTokens	/api/auth/refresh and /api/auth/logout
20.4 API Role Consistency
Public
Browse events
View event details
View categories
View event results
View weather/route information
Any Authenticated User
View own profile
Update own profile
Logout
Organiser
Create events
Update own events
Delete own events
Manage categories
View event enrolments
Capture results
Update results
Participant
Enrol in events
View own enrolments
Cancel own enrolment
View own results

No third role is introduced.

20.5 Project Documentation

The recommended /docs folder is:

/docs
│
├── 01_Part1_Overview_and_ERD.md
├── 02_API_Endpoint_Plan.md
├── 03_RaceDay_Database_Script.sql
├── 04_Consistency_Docs_README_GitHub.md
└── RaceDay_ERD.png

The root README provides a consolidated explanation of:

Project overview.
System roles.
System assumptions.
ERD.
Database entities.
Database relationships.
API endpoint plan.
API security.
SQL Server database.
SQL table structures.
Sample data.
ERD/SQL/API consistency.
Documentation structure.
20.6 Database Setup
Requirements

The database script requires:

Microsoft SQL Server
SQL Server Management Studio (SSMS)
Setup Procedure
Open SQL Server Management Studio.
Connect to a local/development SQL Server instance.
Open the RaceDay SQL script.
Execute the script.
Confirm that RaceDayDB has been created.
Confirm that the six tables exist.
Confirm that the sample records have been inserted.
Test the database before treating the script as final.
Tables Expected
Users
Events
Categories
Enrolments
Results
RefreshTokens

Testing note: The project documentation should only state that the SQL script has been successfully tested after the student has actually tested it in SSMS.

20.7 Future API and MVC Implementation
Part 2 — API

The API can be implemented using ASP.NET Core.

The endpoint plan provides:

HTTP methods.
Routes.
Roles.
Request bodies.
Expected responses.
Ownership rules.

The endpoints are therefore ready to be translated into controllers and API actions.

Part 3 — MVC Application

The MVC application can consume the planned API endpoints.

The API and MVC layers should maintain the same:

User roles.
Event ownership.
Enrolment rules.
Result relationships.
Authentication rules.
20.8 Future Improvements

The current Part 1 design intentionally keeps the database within the required scope.

Possible future additions include:

Event Images

An ImageUrl field could be added to Events if required for future Azure Blob Storage integration.

Weather Integration

Weather information can later be populated dynamically through an external weather service.

Route Integration

Route information can later be connected to a mapping or GPS service.

Docker

The database schema does not contain environment-specific dependencies and can therefore support future containerisation.

20.9 AI Usage Disclosure

AI tools were used to assist with planning, structuring, reviewing and/or proofreading aspects of this work.

The final design and submitted work must be reviewed and adapted by the student to ensure that the student understands the content and that it complies with the Portfolio of Evidence requirements.
