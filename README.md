Campus Activity Publisher
Team Members
Lasson Li, Eric Huang, David Zhao, Shea Jin, Rina Li
2025/07/28

Task Assignment
Name	Role
Lasson Li	Back-End Developer
Rina Li	Back-End Developer
Shea Jin	PM, Back-End Developer
David Zhao	Front-End Developer
Eric Huang	Front-End Developer
Overview of the Campus Activity Publisher Project
The Campus Activity Publisher is a web-based application system built to streamline campus activity management. It provides a centralized platform for organizations to publish activities and for students to browse and register for events efficiently.

Key Features
User Authentication & Permission Management
User registration, login/logout functionality

Role-based access control (students, organizers, administrators)

Password recovery system

Activity Core Functions
Create, browse, search, and register for activities

Activity details with comprehensive information

Custom registration forms for different activities

Personal Center & Management
Track personal registrations and published activities

Message notifications for system and activity updates

User profile management

Data & Content Management (Admin)
User account and permission management

Activity review and management system

Activity category/tag management

Extended Features
Activity comment/Q&A section for user interaction

Advanced search and filtering capabilities

Project Structure
Campus Activity Publisher
app.js # Main entry point of the application

config/

db.js # Database configuration and connection pool

controllers/

authController.js # Handles user authentication operations

activityController.js # Handles activity-related operations

userController.js # Handles user management operations

models/

userModel.js # Database queries for users

activityModel.js # Database queries for activities

registrationModel.js # Database queries for registrations

routes/

auth.js # Routes for authentication APIs

activities.js # Routes for activity-related APIs

users.js # Routes for user management APIs

swagger.js # Swagger configuration for API documentation

node_modules/ # Dependencies installed via npm

Key Components
1. Database Configuration (config/db.js)
Uses mysql2/promise to manage database connections

Provides a connection pool for efficient database operations

2. Controllers
authController.js: Handles user authentication, registration, and session management

activityController.js: Manages activity creation, updates, retrieval, and registration processes

userController.js: Handles user profile management and administrative functions

3. Models
userModel.js: Contains database queries for user management, authentication, and profile operations

activityModel.js: Contains database queries for activity CRUD operations and search functionality

registrationModel.js: Contains database queries for managing activity registrations and participant data

4. Routes
auth.js: Defines routes for authentication operations (POST /auth/register, POST /auth/login)

activities.js: Defines routes for activity operations (GET /activities, POST /activities, PUT /activities/:id)

users.js: Defines routes for user management (GET /users/profile, PUT /users/profile)

5. Swagger Integration (swagger.js)
Configures Swagger UI for comprehensive API documentation

Example API Endpoints
Authentication
POST /auth/register: User registration

POST /auth/login: User login

POST /auth/logout: User logout

Activity Management
GET /activities: Fetch all published activities with filtering

POST /activities: Create a new activity (organizer role required)

GET /activities/:id: Fetch detailed information for a specific activity

PUT /activities/:id: Update an existing activity

Registration Management
POST /activities/:id/register: Register for an activity

DELETE /activities/:id/register: Cancel registration

User Management
GET /users/profile: Get user profile information

PUT /users/profile: Update user profile

GET /users/my-registrations: Get user's activity registrations

GET /users/my-activities: Get user's published activities

Potential Enhancements
Real-time Notifications: Implement WebSocket for real-time activity updates and messages

Mobile Application: Develop companion mobile apps for iOS and Android

Calendar Integration: Sync activities with popular calendar applications

Analytics Dashboard: Provide organizers with participation analytics and insights

Payment Integration: Support paid activities with secure payment processing

Social Features: Add activity sharing and social media integration

This project provides a comprehensive foundation for managing campus activities, with extensive room for future enhancements and scalability.

Technologies Used
Node.js: Backend runtime environment

Express.js: Web framework for building APIs

MySQL: Relational database for storing users, activities, and registrations

Swagger: API documentation and testing

JWT: JSON Web Tokens for secure authentication

How to Run the Project
Install Dependencies
bash
npm install
Start the Server
bash
node app.js
Access the API Documentation
Open http://localhost:3000/api-docs in your browser.

Test the APIs
Use tools like Postman or cURL to test the endpoints, or utilize the integrated Swagger UI for interactive testing.

