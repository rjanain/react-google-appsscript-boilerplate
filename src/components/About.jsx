import { Container } from "react-bootstrap";
import Breadcrumbs from "./Breadcrumbs";
import { useEffect, useState } from "react";
import { callServerFunction } from "../utils/gasClient";

const breadcrumbItems = [
    { label: 'Home', path: '/' },
    { label: 'About', path: '/about' },
];

function About(props) {
    const [data, setData] = useState(null);
    const [error, setError] = useState(null);

    useEffect(() => {
        callServerFunction('getData')
            .then(response => {
                if (response.error) {
                    setError(response.error); // Set error message
                } else {
                    setData(response); // Set fetched data
                }
            })
            .catch(err => setError(`Unexpected error: ${err.message}`));
    }, []);

    return (
        <>
            <Breadcrumbs items={breadcrumbItems} />
            <Container className="p-3 d-flex flex justify-content-evenly align-items-center">
                <Container className="p-5 mb-4 bg-light rounded-3">
                    <h1 className="header">About</h1>
                    <div>
                        <h4>Data from Server</h4>
                        {error ? <p style={{ color: 'red' }}>{error}</p> : <pre>{JSON.stringify(data, null, 2)}</pre>}
                    </div>
                </Container>

            </Container>

        </>
    );
}

export default About;
