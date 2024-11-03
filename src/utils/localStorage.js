/**
 * Save a value to localStorage.
 * @param {string} key - The key to store the value under.
 * @param {*} value - The value to store.
 */
export const saveToLocalStorage = (key, value) => {
    try {
        localStorage.setItem(key, JSON.stringify(value));
    } catch (error) {
        console.error("Error saving to localStorage", error);
    }
};

/**
 * Load a value from localStorage.
 * @param {string} key - The key of the value to retrieve.
 * @param {*} defaultValue - The default value to return if key is not found.
 * @returns {*} - The retrieved value or default value.
 */
export const loadFromLocalStorage = (key, defaultValue = null) => {
    try {
        const storedValue = localStorage.getItem(key);
        return storedValue ? JSON.parse(storedValue) : defaultValue;
    } catch (error) {
        console.error("Error loading from localStorage", error);
        return defaultValue;
    }
};
