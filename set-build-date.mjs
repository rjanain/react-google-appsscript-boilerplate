import fs from 'fs/promises';
import path from 'path';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url)); // To handle __dirname in ES modules

const buildDateTime = new Date().toISOString(); // Full ISO string
const formatDate = buildDateTime.split('T')[0]; // Just the date part
const formatTime = buildDateTime.split('T')[1].substring(0, 5); // Just the time part (hh:mm)


const buildDate = `${formatDate} ${formatTime}`
const envPath = path.join(__dirname, '.env');

async function setBuildDate() {
    try {
        let envContent = await fs.readFile(envPath, 'utf-8');

        // Regex to find and replace existing build date
        const buildDateRegex = /^VITE_BUILD_DATE=.*$/m;
        const newBuildDateLine = `VITE_BUILD_DATE=${buildDate}`;

        if (buildDateRegex.test(envContent)) {
            envContent = envContent.replace(buildDateRegex, newBuildDateLine);
        } else {
            envContent += `\n${newBuildDateLine}`;
        }

        await fs.writeFile(envPath, envContent, 'utf-8');
        console.log('Build date set in .env:', buildDate);
    } catch (error) {
        console.error('Failed to set the build date:', error);
    }
}

setBuildDate();
