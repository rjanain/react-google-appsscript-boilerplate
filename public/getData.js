/**
 * Fetches data from a specified Google Sheet and returns it as JSON.
 * @param {string} sheetName - The name of the sheet to retrieve data from.
 * @returns {Array<Object>} - An array of objects representing the rows in the sheet.
 */
function getData(sheetName="data") {
    try {
        const spreadsheet = SpreadsheetApp.getActiveSpreadsheet();
        const sheet = spreadsheet.getSheetByName(sheetName);

        if (!sheet) {
            throw new Error(`Sheet with name "${sheetName}" not found.`);
        }

        const data = sheet.getDataRange().getValues();
        const headers = data.shift(); // Extract headers from the first row

        // Map each row to an object using headers as keys
        return data.map(row => {
            return headers.reduce((obj, header, index) => {
                obj[header] = row[index];
                return obj;
            }, {});
        });
    } catch (error) {
        Logger.log(`Error in getData: ${error.message}`);
        return { error: `Failed to retrieve data: ${error.message}` };
    }
}
