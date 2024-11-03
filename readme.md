# React-Vite Google Apps Script Boilerplate

![HTML5](https://img.shields.io/badge/html5-%23E34F26.svg?style=for-the-badge&logo=html5&logoColor=white) 
![JavaScript](https://img.shields.io/badge/javascript-%23323330.svg?style=for-the-badge&logo=javascript&logoColor=%23F7DF1E)
![NodeJS](https://img.shields.io/badge/node.js-%2343853D.svg?style=for-the-badge&logo=node.js&logoColor=white)
![Vite](https://img.shields.io/badge/Vite-%23646CFF.svg?style=for-the-badge&logo=vite&logoColor=white)
![React](https://img.shields.io/badge/react-%2320232a.svg?style=for-the-badge&logo=react&logoColor=%2361DAFB)
![React Router](https://img.shields.io/badge/React_Router-CA4245?style=for-the-badge&logo=react-router&logoColor=white)
![React Bootstrap](https://img.shields.io/badge/React_Bootstrap-%23563D7C.svg?style=for-the-badge&logo=bootstrap&logoColor=white)
![Bootswatch](https://img.shields.io/badge/Bootswatch-%23563D7C.svg?style=for-the-badge&logo=bootstrap&logoColor=white)
![Google Spreadsheet](https://img.shields.io/badge/Google%20Sheet-4285F4?style=for-the-badge&logo=googlesheet&logoColor=white)
![Google AppsScript](https://img.shields.io/badge/Google%20AppsScript-4285F4?style=for-the-badge&logo=googleappsscript&logoColor=white)
[![MIT License](https://img.shields.io/badge/License-MIT-green.svg)](https://choosealicense.com/licenses/mit/)


## Table of Contents

- [Introduction](#introduction)
- [Features](#features)
- [Installation](#installation)
- [Theme Customization](#theme-customization)
- [Using JSON Server for Local Development](#using-json-server-for-local-development)
- [Build Date with `setBuildDate` Script](#build-date-with-setbuilddate-script)
- [Deployment](#deployment)
- [Contribution](#contribution)
- [License](#license)

## Introduction

This boilerplate project provides a foundation to build a React web application integrated with Google Apps Script for backend functions, specifically for interacting with Google Sheets. It uses Vite for development and builds, React Router for multipage support, and supports dynamic theming with React Bootstrap and Bootswatch.

## Features

- **Multipage Routing**: Powered by React Router.
- **Dynamic Theming**: Allows switching themes using Bootswatch themes.
- **Google Apps Script Integration**: Backend communication with Google Sheets and other Google services.
- **JSON Server**: Mock backend API for local development.
- **Optimized Builds**: Single-file output using Vite for seamless Google Apps Script deployment.

## Installation

### Prerequisites

- Node.js (v14 or higher recommended)
- Google Apps Script CLI (CLASP)

### Setup

1. **Clone the repository**:

    ```bash
    git clone https://github.com/yourusername/react-google-appsscript-boilerplate.git
    cd react-google-appsscript-boilerplate
    ```

2. **Install dependencies**:

    ```bash
    npm install
    ```

3. **Configure Google Apps Script**:

    - Login with CLASP:
      ```bash
      npm run login
      ```
    - Check your login stauts with CLASP:
      ```bash
      npm run loginStatus
      ```
    - Create a new Apps Script project (or link an existing one):
    While creting a new apps script make sure you have used webapp from the dropdown menu.
     
      ```bash
      npm run create
      ```
      or, to specify a custom title and root directory:

      ```bash
      npm run create -- --title "Custom Project Title" --rootDir "./dist"
      ```

    - Move `.clasp.json` to the root directory if created in `dist`.

4. **Google Apps Script Scopes**:

   Update `public/appsscript.json` with necessary scopes as per your requirements, such as:

   ```json
   {
     "oauthScopes": [
       "https://www.googleapis.com/auth/spreadsheets.currentonly",
        "https://www.googleapis.com/auth/userinfo.email"
       "https://www.googleapis.com/auth/script.external_request"
     ]
   }
   ```

### Development Server

1. Start the development server:
   ```bash
   npm run dev
   ```

   The app will be accessible at `http://localhost:5173`.

2. **Start JSON Server**:
   To mock API requests locally, run:
   ```bash
   npm run json-server
   ```

   JSON Server will start at `http://localhost:3001`, and you can adjust data in `data/db.json` for testing. See the section [using JSON Server for Local Development](#using-json-server-for-local-development) on how to create a local database in `data/db.json`.

## Theme Customization

This boilerplate includes support for dynamic theming with React Bootstrap and Bootswatch. You can change themes by updating the dropdown in your app to apply different Bootswatch themes.

## Using JSON Server for Local Development

During local development, this project uses JSON Server to mock API requests, allowing you to simulate data responses that would typically come from Google Apps Script functions. The `data/db.json` file in the data directory serves as the mock database.

### Setting up`db.json`

Create a `data/db.json` file with Keys to match function names, thatb is, each key in `db.json` should exactly match the name of the corresponding function in Google Apps Script. This allows the application to seamlessly switch between using local mock data and real data from Google Apps Script without code changes. Here is one such example. 

```json
{
  "getData": [
    { "id": 1, "name": "Alice" },
    { "id": 2, "name": "Bob" }
  ],
  "getUserInfo": {
    "userId": "12345",
    "name": "John Doe",
    "email": "johndoe@example.com"
  }
}
```

Run the server with:

```bash
npm run json-server
```

You can then access the mock API at `http://localhost:3001/getData` or `http://localhost:3001/getUserInfo`.


## Build Date with `setBuildDate` Script

The `set-build-date` script automatically sets the current build date and time in the `.env` file before building the project. This can be useful for tracking build versions or displaying build information in the application.

### How It Works

1. **Define Date and Time**: The script gets the current date and time in ISO format, then extracts the date (YYYY-MM-DD) and time (HH:MM).
2. **Update or Insert**: The script reads the `.env` file content, looks for an existing `VITE_BUILD_DATE` entry, and updates it with the new date and time. If the entry doesn’t exist, it appends a new line with `VITE_BUILD_DATE=<current_date_and_time>`.
3. **Write Back to File**: The updated content is saved to `.env`.

### Usage

The `setBuildDate` script is run automatically before each build through the `prebuild` script in `package.json`. This setup ensures that the build date is always up-to-date before deployment.

## Deployment

### Important Checks

- `public` Directory: This directory must contain `appsscript.json`, which defines the Apps Script configuration. Additionally, any JavaScript files that interact with Google Sheets (e.g., `doGet.js` for serving the frontend, `getData.js` for fetching data) should be stored here.


1. **Build for Google Apps Script**:
   ```bash
   npm run build
   ```

   This will output files into the `dist` directory, compatible with Google Apps Script.

2. **Deploy with CLASP**:
   ```bash
   npm run publish
   ```

3. **Open in Apps Script**:
   ```bash
   clasp open
   ```

To deploy as a web app, go to **Deploy** > **Test deployments** in the Apps Script editor.

## Contribution

Contributions are welcome! Fork the repository and submit pull requests with your proposed changes.

## License

This project is licensed under the [MIT License](LICENSE).