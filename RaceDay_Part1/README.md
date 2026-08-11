# RaceDay - Part 1: System Planning and Database

## Overview
RaceDay is a full-stack web-based event management system for the South African
road running, walking, and cycling community. This repository contains the
planning deliverables for Part 1 of the PROG6212 POE: an ERD, an API endpoint
plan, and a SQL database script.

## Repository Structure
```
/
├── docs/
│   ├── RaceDay_ERD.png                  # Entity Relationship Diagram
│   ├── RaceDay_ERD.mermaid              # ERD source (Mermaid syntax, for reference)
│   ├── RaceDay_API_Endpoint_Plan.md     # Full API endpoint plan
│   └── RaceDay_Database_Script.sql      # SQL Server schema + seed data
├── .github/
│   └── workflows/
│       └── validate-docs.yml            # CI check that required docs are present
└── README.md
```

## Setup Instructions
1. Install SQL Server (Developer Edition) and SQL Server Management Studio (SSMS).
2. Open `docs/RaceDay_Database_Script.sql` in SSMS.
3. Connect to a local/clean SQL Server instance and run the script (F5).
4. Confirm all six tables (Organisers, Participants, Events, Categories,
   Enrolments, Results) are created and seeded without errors.

## Video
- Unlisted YouTube link: ADD_YOUR_LINK_HERE

## CI/CD
- Workflow file: `.github/workflows/validate-docs.yml`
- Screenshot of successful green build: ADD_SCREENSHOT_HERE

## Roles
- **Organiser** - create, edit, delete events; manage categories; capture results; view all enrolments.
- **Participant** - create account; browse events; enter events via category; view own enrolments and results.
