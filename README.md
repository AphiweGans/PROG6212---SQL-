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
