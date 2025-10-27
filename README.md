# Campus Activity Platform

## Team Members

Zihao He, Jiabao Li, Xingping Liu, Kewei Wu, Yuzhe Huang

2025/10/21
## Task Assignment
|Name|Role|
|-|-|
|Zihao He|PM|
|Xingping Liu|Front-End Developer|
|Yuzhe Huang|Front-End Developer|
|Jiabao Li|Back-End Developer|
|Kewei Wu|Database Developer|
----------
## Overview of the Campus Activity Platform


The Campus Activity Platform is a web-based application designed to streamline the process of publishing, managing, and signing up for campus activities. It provides a centralized solution for student organizations and participants.

### Key Features


#### Activity Management


-   APIs to create, update, and retrieve activities.
-   Supports operations like publishing, editing, and managing activity details.
-   Tracks activity information such as time, location, capacity, and registration status.

#### Registration Management


-   APIs to handle participant registration and cancellation
-   Manages registration details including custom form fields and participant data.
-   Supports operations like "register", "cancel", and "view participants".

#### User Management


-   Comprehensive user authentication and authorization system.
-   Role-based access control for participants, organizers, and administrators.

#### API Documentation


-   Integrated Swagger UI for API documentation.
-   Provides detailed documentation for all endpoints, including request and response formats.

----------

## Project Structure


```
CampusActivityPlatform/
├── app.js                 # Main entry point of the application
├── config/
│   └── db.js             # Database configuration and connection pool
├── controllers/
│   ├── authController.js      # Handles user authentication operations
│   ├── activityController.js  # Handles activity-related operations
│   ├── registrationController.js # Handles registration operations
│   └── userController.js      # Handles user management operations
├── models/
│   ├── userModel.js          # Database queries for users
│   ├── activityModel.js      # Database queries for activities
│   └── registrationModel.js  # Database queries for registrations
├── routes/
│   ├── auth.js              # Routes for authentication APIs
│   ├── activities.js        # Routes for activity-related APIs
│   ├── registrations.js     # Routes for registration APIs
│   └── users.js             # Routes for user management APIs
├── middleware/
│   └── authMiddleware.js    # Authentication and authorization middleware
└── swagger.js              # Swagger configuration for API documentation

```

----------
## Key Components


### 1. Database Configuration (`config/db.js`)


-   Uses  `mysql2/promise`  to manage database connections.
-   Provides a connection pool for efficient database operations.

### 2. Controllers


-   **`assetsController.js`**: Handles user registration, login, and session management.
-   **`activityController.js`**: Handles activity creation, updates, retrieval, and management.
-   **`registrationController.js`**: Manages participant registration, cancellation, and participant lists.
-   **`userController.js`**: Handles user profile management and administrative user operations.

### 3. Models


-   **`userModel.js`**: Contains database queries for managing users, including authentication and profile management.
-   **`activityModel.js`**: Contains database queries for managing activities, including CRUD operations and filtering.
-   **`registrationModel.js`**: Contains database queries for managing registrations and participant data.

### 4. Routes


-   **`auth.js`**: Defines routes for authentication operations (e.g.,  `POST /auth/register`,  `POST /auth/login`).
-   **`activities.js`**: Defines routes for activity-related operations (e.g.,  `GET /activities`,   `POST /activities`,  `PUT /activities/:id`).
-   **`registrations.js`**: Defines routes for registration operations (e.g.,  `POST /registrations`,  `DELETE /registrations/:id`).
-   **`users.js`**: Defines routes for user management operations (e.g.,  `GET /users/profile`,  `PUT /users/profile`).

### 5. Swagger Integration (`swagger.js`)


-   Configures Swagger UI for API documentation.
-   Automatically generates documentation from annotations in route files.

----------

## Example API Endpoints


### Authentication

-   `POST /auth/register`: User registration.
-   `POST /auth/login`: User login.
-   `POST /auth/logout`: User logout.

### Activity Management


-   `GET /activities`: Fetch all published activities.
-   `POST /activities`: Create a new activity (organizers only).
-   `GET /activities/:id`: Fetch specific activity details.
-   `PUT /activities/:id`: Update an activity.
-   `DELETE /activities/:id`: Delete an activity.

### Registration Management


-   `POST /registrations`: Register for an activity.
-   `DELETE /registrations/:id`: Cancel registration.
-   `GET /activities/:id/participants`: Get participant list (organizers only).

----------

## Technologies Used


-   **Node.js**: Backend runtime environment.
-   **Express.js**: Web framework for building APIs.
-   **MySQL**: Relational database for storing users, activities, and registrations.
-   **Swagger**: API documentation and testing.
-   **Yahoo Finance API**:JSON Web Tokens for authentication.

----------

## How to Run the Project


### Install Dependencies

npm install

### Start the Server


node app.js

### Access the API Documentation


Open  [http://localhost:3000/api-docs](http://localhost:3000/api-docs)  in your browser.

### Test the APIs


Use tools like Postman or cURL to test the endpoints.

----------

## Potential Enhancements


-   ****Email Notifications****: Implement email service for activity reminders and notifications.
-   ****Real-time Chat****:  Add real-time messaging for activity discussions and Q&A.
-   ****Mobile Application****: Develop companion mobile app for better user experience.
-   ****Advanced Analytics****:Add reporting and analytics for activity participation trends.
-   ****Calendar Integration****: Sync activities with popular calendar applications.

This project provides a solid foundation for managing campus activities, registrations, and user interactions, with room for further enhancements.
