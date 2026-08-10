# RaceDay Part 1 — ERD

## Entities
- Users
- Events
- Categories
- Enrolments
- Results
- RefreshTokens

## Relationships
- Users (Organiser) → Events: one-to-many
- Events → Categories: one-to-many
- Users (Participant) ↔ Events: many-to-many resolved through Enrolments
- Categories → Enrolments: one-to-many
- Enrolments → Results: one-to-one
- Users → RefreshTokens: one-to-many

## Mermaid ERD

```mermaid
erDiagram
    USERS ||--o{ EVENTS : organises
    EVENTS ||--o{ CATEGORIES : has
    USERS ||--o{ ENROLMENTS : enrols
    EVENTS ||--o{ ENROLMENTS : receives
    CATEGORIES ||--o{ ENROLMENTS : selected_in
    ENROLMENTS ||--o| RESULTS : produces
    USERS ||--o{ REFRESHTOKENS : owns
```

The detailed attributes and constraints are documented in the original PoE document.
