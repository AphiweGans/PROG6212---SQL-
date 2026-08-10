# RaceDay Consistency and GitHub Documentation

## ERD ↔ SQL
All six planned ERD entities have corresponding SQL tables:
- Users
- Events
- Categories
- Enrolments
- Results
- RefreshTokens

Primary keys and foreign keys correspond between the design and SQL schema. The Enrolment-to-Result one-to-one relationship is enforced with a unique constraint on `Results.EnrolmentId`. Duplicate participant enrolments in an event are prevented by a unique constraint on `ParticipantId + EventId`.

## ERD ↔ API
The API endpoint groups map directly to Users, Events, Categories, Enrolments, Results and RefreshTokens.

## Roles
- Public read-only event/category/results endpoints: None
- Profile and logout: Any authenticated user
- Event/category management and result management: Organiser
- Enrolment and personal results: Participant

## GitHub
Part 1 requires at least 20 meaningful commits. Do not fabricate commits, screenshots, video links or build results.

## Testing
The SQL script must be genuinely tested in SSMS before being marked as final.
