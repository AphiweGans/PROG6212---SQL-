# RaceDay - Part 1: System Planning and Database

## Description

RaceDay is a full-stack, web-based event management system built for the South African road running, walking, and cycling community. It allows **Event Organisers** to create and manage events, categories, and participant results, while **Participants** can browse upcoming events, enter events, and track their personal performance history.

This repository contains **Part 1** of the RaceDay Portfolio of Evidence: system planning, including the Entity Relationship Diagram (ERD), the API endpoint plan, and the SQL database creation script. No application code is included in this part.

## Roles

| Role | Capabilities |
|---|---|
| **Organiser** | Create, edit, and delete events; manage event categories; capture participant results; view all enrolments for their events. |
| **Participant** | Create an account; browse events; enter an event by selecting a category; view their own enrolments; track their personal results. |

## Repository Structure

```
/docs
  erd.png                  - Entity Relationship Diagram
  api-endpoint-plan.md     - Full API endpoint specification
  database-script.sql      - SQL Server database creation + seed script
.github/workflows
  validate-docs.yml        - CI workflow validating repo structure
README.md
```

## Database Setup Instructions

1. Install SQL Server (Express or Developer edition) and SQL Server Management Studio (SSMS).
2. Open SSMS and connect to your local SQL Server instance.
3. Open `docs/database-script.sql`.
4. Execute the full script (F5). This will:
   - Create the `RaceDayDB` database (if it doesn't already exist)
   - Drop and recreate all tables (Organiser, Participant, Event, Category, Enrolment, Result)
   - Seed the database with sample data (2 Organisers, 2 Participants, 3 Events, 4 Categories, 3 Enrolments, 1 Result)
5. Run the verification queries at the bottom of the script (uncomment them) to confirm the data was inserted correctly.

## CI/CD

A GitHub Actions workflow (`.github/workflows/validate-docs.yml`) runs on every push and pull request. It verifies that the `/docs` folder and all required planning documents (ERD, endpoint plan, SQL script) and the README exist in the repository.

**Build status:** ✅ *(insert green build screenshot here)*

```
![CI Build Status](docs/ci-success-screenshot.png)
```

## Video Walkthrough

📺 *(insert unlisted YouTube link here)*

The video covers:
- A walkthrough of the ERD and the reasoning behind entity and relationship design decisions
- A walkthrough of the API endpoint plan and role-based access choices
- A live run of the SQL script in SSMS, showing successful table creation and data seeding
