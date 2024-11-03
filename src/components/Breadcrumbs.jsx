// src/components/Breadcrumbs.jsx

import React from "react";
import { Link } from "react-router-dom";
import PropTypes from "prop-types";

const Breadcrumbs = ({ items }) => {
    return (
        <nav aria-label="breadcrumb">
            <ol className="breadcrumb">
                {items.map((item, index) => (
                    <li
                        key={index}
                        className={`breadcrumb-item ${index === items.length - 1 ? "active" : ""
                            }`}
                        aria-current={index === items.length - 1 ? "page" : undefined}
                    >
                        {index === items.length - 1 ? (
                            item.label
                        ) : (
                            <Link to={item.path}>{item.label}</Link>
                        )}
                    </li>
                ))}
            </ol>
        </nav>
    );
};

Breadcrumbs.propTypes = {
    items: PropTypes.arrayOf(
        PropTypes.shape({
            label: PropTypes.string.isRequired,
            path: PropTypes.string,
        })
    ).isRequired,
};

export default Breadcrumbs;
