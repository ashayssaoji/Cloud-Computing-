## Assignment 1
# webapp 

# Motto: To implement a health Check API

The **Health Check API** is a simple API designed to check the health status of an application. It provides an endpoint (`/healthz`) that checks if the application is running properly.

This API:
- Accepts only **GET** requests.
- Returns `200 OK` for successful health checks.
- Rejects all other HTTP methods (`POST`, `PUT`, `DELETE`, `HEAD`, etc.) with a `405 Method Not Allowed`.

---

## Prerequisites
Install the following:

- **Node.js** 
- **npm** (comes with Node.js)
- **MySQL**
- **Git** (to clone the repository)

---

## Installation & Setup

### 1. Clone the Repository**

git clone <your-SSH-repository-url>
cd <your-project-directory>

2. Install the dependencies: 

npm install

3. Configure the Database

npm install sequelize mysql2

4. Create a .env file

DB_DIALECT=mysql
DB_HOST=localhost
DB_PORT=3306
DB_NAME=healthz
DB_USER=your_username
DB_PASSWORD=your_password

5. Setup the database config file with the environment variables 

## Running the Application
1. Start the Application
Using Nodemon:
npm run dev
2. Verify Database Connection
If Sequelize connects successfully, you should see
Database connected successfully!
3. API Endpoints
Health Check (GET /healthz)
URL: /healthz
Method: GET
Response:
json
{
  "status": "OK"
}
Status Code: 200 OK

Invalid HTTP Methods
If POST, PUT, DELETE, or HEAD is used on /healthz, the API will return:
Response: No body
Status Code: 405 Method Not Allowed

Testing the API
1. Using cURL
Check Health (GET /healthz)

curl -X GET http://localhost:3000/healthz -v
Expected Response:

HTTP/1.1 200 OK

## Troubleshooting


If you see this error:

1. Port Already in Use

2. address already in use :::3000
Run:
npx kill-port 3000

## Stop the Application
In VS Code, open the Terminal and press Ctrl + C. 


## Testing
Installed jest and supertest to carry out the integration testing of the webapp application 


## Commands to install Jest and Supertest
npm install --save-dev jest
npm install --save-dev supertest

## Updating the script inside package.json

"scripts": {
  "test": "jest"
}

## Running the tests:
npm test


This will lead to a running of all the describes tests in the tests folder of the applcation and on succesfull compeltion will show the desired error codes for the respective test. 

## Results from the test cases: 

 PASS  tests/healthz.test.js
  Health Check API /healthz
    ✓ Should return 200 OK when database is connected (150 ms) 
    ✓ Should return 400 Bad Request if query parameters are sent (4 ms)
    ✓ Should return 405 Method Not Allowed for POST (2 ms)
    ✓ Should return 405 Method Not Allowed for PUT (2 ms)
    ✓ Should return 405 Method Not Allowed for DELETE (2 ms)
    ✓ Should return 405 Method Not Allowed for PATCH (2 ms)
    ✓ Should return 405 Method Not Allowed for HEAD (2 ms)
    ✓ Should return 405 Method Not Allowed for options (2 ms)
    ✓ Should return 404 Not Found for unknown routes (4 ms)
    ✓ Should return 503 Service Unavailable when database is down (3 ms)

Test Suites: 1 passed, 1 total
Tests:       10 passed, 10 total
Snapshots:   0 total
Time:        0.852 s, estimated 1 s

