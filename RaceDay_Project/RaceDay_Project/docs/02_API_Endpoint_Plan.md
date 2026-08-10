# RaceDay API Endpoint Plan

Base path: `/api/`

## Authentication
| Method | Endpoint | Role |
|---|---|---|
| POST | `/api/auth/register` | None |
| POST | `/api/auth/login` | None |
| POST | `/api/auth/refresh` | None |
| POST | `/api/auth/logout` | Any |

## User Profile
| Method | Endpoint | Role |
|---|---|---|
| GET | `/api/users/me` | Any |
| PUT | `/api/users/me` | Any |

## Events
| Method | Endpoint | Role |
|---|---|---|
| GET | `/api/events` | None |
| GET | `/api/events/{eventId}` | None |
| POST | `/api/events` | Organiser |
| PUT | `/api/events/{eventId}` | Organiser |
| DELETE | `/api/events/{eventId}` | Organiser |
| GET | `/api/events/{eventId}/weather` | None |

## Categories
| Method | Endpoint | Role |
|---|---|---|
| GET | `/api/events/{eventId}/categories` | None |
| POST | `/api/events/{eventId}/categories` | Organiser |
| PUT | `/api/categories/{categoryId}` | Organiser |
| DELETE | `/api/categories/{categoryId}` | Organiser |

## Enrolments
| Method | Endpoint | Role |
|---|---|---|
| POST | `/api/events/{eventId}/enrolments` | Participant |
| GET | `/api/users/me/enrolments` | Participant |
| GET | `/api/events/{eventId}/enrolments` | Organiser |
| DELETE | `/api/enrolments/{enrolmentId}` | Participant |

## Results
| Method | Endpoint | Role |
|---|---|---|
| POST | `/api/enrolments/{enrolmentId}/result` | Organiser |
| PUT | `/api/results/{resultId}` | Organiser |
| GET | `/api/events/{eventId}/results` | None |
| GET | `/api/users/me/results` | Participant |

Organiser ownership checks must confirm that `Events.OrganiserId` equals the authenticated user's `UserId`.
