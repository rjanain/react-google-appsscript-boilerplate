/**
 * Serves the frontend HTML file to the user.
 * This function is triggered when the web app URL is accessed.
 * @returns {HtmlOutput} - The HTML output with the React app.
 */
function doGet() {
    // Load the main HTML file (index.html) from the deployed frontend files in Google Apps Script
    return HtmlService.createHtmlOutputFromFile('index')
        .setTitle('My Web App')
        .setXFrameOptionsMode(HtmlService.XFrameOptionsMode.ALLOWALL);
}
