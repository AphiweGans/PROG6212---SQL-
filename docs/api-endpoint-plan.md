# RaceDay - API Endpoint Plan

This document lists every API endpoint planned for the RaceDay system. This plan was completed before any API code was written in Part 2. The implemented API in Part 2 closely follows this plan.

**Roles:** `None` = public/unauthenticated, `Any` = any logged-in user, `Organiser` = Organiser role only, `Participant` = Participant role only.

---

## Authentication

| HTTP Method | Route | Description | Role Required | Request Body | Expected Response |
|---|---|---|---|---|---|
| POST | /api/auth/register | Registers a new user as either an Organiser or a Participant. | None | `{ fullName, email, password, role, organisation? , dateOfBirth? }` | 201 Created - user object (no password)<br>400 Bad Request - invalid input<br>409 Conflict - email already in use |
| POST | /api/auth/login | Authenticates a user and returns a JWT token. | None | `{ email, password }` | 200 OK - `{ token, role, userId }`<br>401 Unauthorized - invalid credentials |

## User Profile

| HTTP Method | Route | Description | Role Required | Request Body | Expected Response |
|---|---|---|---|---|---|
| GET | /api/users/me | Retrieves the profile of the currently logged-in user. | Any | None | 200 OK - user profile object<br>401 Unauthorized |
| PUT | /api/users/me | Updates the profile of the currently logged-in user. | Any | `{ fullName, organisation? , dateOfBirth? }` | 200 OK - updated profile<br>400 Bad Request<br>401 Unauthorized |

## Events

| HTTP Method | Route | Description | Role Required | Request Body | Expected Response |
|---|---|---|---|---|---|
| GET | /api/events | Lists all upcoming events. Supports optional filtering (e.g. by type or location). | None | None | 200 OK - array of events |
| GET | /api/events/{id} | Retrieves full details for a single event, including its categories. | None | None | 200 OK - event object with categories<br>404 Not Found |
| POST | /api/events | Creates a new event owned by the logged-in Organiser. | Organiser | `{ name, description, eventDate, location, eventType }` | 201 Created - new event object<br>400 Bad Request<br>401 Unauthorized |
| PUT | /api/events/{id} | Updates an existing event. Only the owning Organiser may update it. | Organiser | `{ name, description, eventDate, location, eventType }` | 200 OK - updated event<br>403 Forbidden - not the owner<br>404 Not Found |
| DELETE | /api/events/{id} | Deletes an event and its related categories/enrolments. Only the owning Organiser may delete it. | Organiser | None | 204 No Content<br>403 Forbidden<br>404 Not Found |

## Categories

| HTTP Method | Route | Description | Role Required | Request Body | Expected Response |
|---|---|---|---|---|---|
| GET | /api/events/{eventId}/categories | Lists all categories for a specific event. | None | None | 200 OK - array of categories<br>404 Not Found |
| POST | /api/events/{eventId}/categories | Adds a new category (e.g. distance) to an event. | Organiser | `{ name, distanceKm, entryFee, maxParticipants }` | 201 Created - new category<br>400 Bad Request<br>403 Forbidden<br>404 Not Found |
| PUT | /api/categories/{id} | Updates an existing category. | Organiser | `{ name, distanceKm, entryFee, maxParticipants }` | 200 OK - updated category<br>403 Forbidden<br>404 Not Found |
| DELETE | /api/categories/{id} | Deletes a category. | Organiser | None | 204 No Content<br>403 Forbidden<br>404 Not Found |

## Event Enrolments

| HTTP Method | Route | Description | Role Required | Request Body | Expected Response |
|---|---|---|---|---|---|
| POST | /api/categories/{categoryId}/enrol | Enrols the logged-in Participant into a category. Generates a race number. | Participant | None | 201 Created - enrolment object with race number<br>400 Bad Request - category full<br>401 Unauthorized<br>409 Conflict - already enrolled |
| GET | /api/users/me/enrolments | Lists all enrolments (past and upcoming) for the logged-in Participant. | Participant | None | 200 OK - array of enrolments |
| GET | /api/events/{eventId}/enrolments | Lists all participants enrolled in an event's categories. Used by Organisers for planning. | Organiser | None | 200 OK - array of enrolments with participant info<br>403 Forbidden<br>404 Not Found |
| DELETE | /api/enrolments/{id} | Cancels/withdraws an enrolment. | Participant | None | 204 No Content<br>403 Forbidden - not the owner<br>404 Not Found |

## Results

| HTTP Method | Route | Description | Role Required | Request Body | Expected Response |
|---|---|---|---|---|---|
| POST | /api/enrolments/{enrolmentId}/result | Captures a finish result for a specific enrolment. | Organiser | `{ finishTime, overallPosition, categoryPosition }` | 201 Created - result object<br>400 Bad Request<br>403 Forbidden<br>404 Not Found<br>409 Conflict - result already captured |
| PUT | /api/results/{id} | Updates a previously captured result. | Organiser | `{ finishTime, overallPosition, categoryPosition }` | 200 OK - updated result<br>403 Forbidden<br>404 Not Found |
| GET | /api/users/me/results | Retrieves the logged-in Participant's personal result history across all events. | Participant | None | 200 OK - array of results with event/category info |
| GET | /api/events/{eventId}/results | Retrieves all results for an event (e.g. for publishing a results board). | None | None | 200 OK - array of results<br>404 Not Found |

---

### Notes
- All `Organiser`-only routes must verify that the logged-in Organiser owns the Event/Category/Enrolment being modified before allowing the action (enforced at the API level in Part 2).
- Race numbers are generated server-side on enrolment to guarantee uniqueness.
- Weather/route information endpoints (external API integration) are planned for Part 3 and are not part of the core data API above.
