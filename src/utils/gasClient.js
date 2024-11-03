// src/contexts/gasClient.js
import { GASClient } from 'gas-client';

// Initialize server functions
const { serverFunctions } = new GASClient();

// Helper function to handle API requests based on environment
const callServerFunction = async (functionName, params = []) => {
    if (process.env.NODE_ENV === 'development') {
        // Local development: Use json-server API
        const response = await fetch(`http://localhost:3001/${functionName}`);
        return response.json();
    } else {
        // Production: Use GAS server function
        return serverFunctions[functionName](...params);
    }
};

export { callServerFunction };
