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
