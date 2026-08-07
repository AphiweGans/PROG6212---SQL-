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
EventId	INT	Primary Key and identity value.
OrganiserId	INT	Foreign Key to Users.UserId.
Name	NVARCHAR(150)	Name of the event.
EventType	NVARCHAR(50)	Event type such as Marathon, Cycling or Walk.
EventDate	DATETIME2	Date and time of the event.
Location	NVARCHAR(200)	Event location.
Description	NVARCHAR(MAX)	Optional event description.
RouteInfo	NVARCHAR(MAX)	Route description or link.
WeatherInfo	NVARCHAR(MAX)	Weather-related information.
CreatedAt	DATETIME2	Date/time the event was created.
Relationship

Each Event belongs to exactly one Organiser.

One Organiser can create many Events.

# Relationship:

Users 1 → Many Events
