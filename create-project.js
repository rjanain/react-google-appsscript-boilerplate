// create-project.js

import { execSync } from 'child_process';

// Default values
let title = 'A Sample Dashboard';
let rootDir = './dist';

// Parse command-line arguments
process.argv.forEach((arg, index) => {
    if (arg === '--title' && process.argv[index + 1]) {
        title = process.argv[index + 1];
    }
    if (arg === '--rootDir' && process.argv[index + 1]) {
        rootDir = process.argv[index + 1];
    }
});

try {
    // Run clasp create command with dynamic title and rootDir
    execSync(`npx clasp create --title "${title}" --rootDir ${rootDir}`, { stdio: 'inherit' });
    console.log(`Project created with title: "${title}" and root directory: "${rootDir}"`);
    console.log(`Move .clasp.json from "${rootDir}" to the project root directory.`)
    console.log(`Move appsscript.json from "${rootDir}" to the "./public" directory.`)
} catch (error) {
    console.error('Failed to create project:', error);
}