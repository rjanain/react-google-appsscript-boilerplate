import React, { useEffect, useState, useMemo } from 'react';
import PropTypes from 'prop-types';
import { ThemeContext } from './theme';
import { saveToLocalStorage, loadFromLocalStorage } from '../utils/localStorage';

const ThemeProvider = ({ children }) => {
    // Load theme and dark mode from localStorage or use defaults
    const [theme, setTheme] = useState(() => loadFromLocalStorage('theme', 'zephyr'));
    const [themeMode, setThemeMode] = useState(() => loadFromLocalStorage('themeMode', 'light'));

    // Update theme CSS on theme change
    useEffect(() => {
        const themeLink = document.getElementById('theme-style');
        themeLink.href = `https://cdn.jsdelivr.net/npm/bootswatch@5.3.3/dist/${theme}/bootstrap.min.css`;
        saveToLocalStorage('theme', theme); // Persist theme
    }, [theme]);

    // Update theme mode on mode change
    useEffect(() => {
        const html = document.documentElement;
        if (themeMode === 'dark') {
            html.setAttribute('data-bs-theme', 'dark');
        } else {
            html.removeAttribute('data-bs-theme');
        }
        saveToLocalStorage('themeMode', themeMode); // Persist theme mode
    }, [themeMode]);

    // Memoized functions for toggling theme and dark mode
    const toggleTheme = useMemo(
        () => (newTheme) => setTheme(() => (newTheme === 'default' ? 'zephyr' : newTheme)),
        []
    );

    const toggleDarkMode = useMemo(
        () => () => setThemeMode((prevMode) => (prevMode === 'dark' ? 'light' : 'dark')),
        []
    );

    return (
        <ThemeContext.Provider value={{ theme, themeMode, toggleTheme, toggleDarkMode }}>
            {children}
        </ThemeContext.Provider>
    );
};

ThemeProvider.propTypes = {
    children: PropTypes.node.isRequired,
};

export default ThemeProvider;
