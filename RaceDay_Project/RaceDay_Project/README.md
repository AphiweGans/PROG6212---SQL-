# RaceDay — Road Event Management System

## Portfolio of Evidence — Part 1

RaceDay is a web-based event management platform for South African road running, walking and cycling events.

Part 1 establishes the system planning and database foundation:
- Entity Relationship Diagram (ERD)
- REST API Endpoint Plan
- SQL Server/T-SQL database script
- Consistency documentation

## System Roles
- Organiser
- Participant

## Core Entities
1. Users
2. Events
3. Categories
4. Enrolments
5. Results
6. RefreshTokens

## API Base Path
`/api/`

JWT Bearer authentication is planned for protected endpoints.

## Documentation
- `docs/01_Part1_Overview_and_ERD.md`
- `docs/02_API_Endpoint_Plan.md`
- `docs/03_RaceDay_Database_Script.sql`
- `docs/04_Consistency_Docs_README_GitHub.md`

## Database
Database name: `RaceDayDB`

Platform: Microsoft SQL Server / T-SQL

The SQL script should be tested in SQL Server Management Studio before being treated as final.

## GitHub
The Part 1 PoE requires at least 20 meaningful commits. Commits should represent genuine project progress and should not be fabricated.

## AI Usage Disclosure
AI tools were used to assist with planning, structuring, reviewing and/or proofreading aspects of this work. The final design and submitted work must be reviewed and adapted by the student to ensure that the student understands the content and that it complies with the PoE requirements.
