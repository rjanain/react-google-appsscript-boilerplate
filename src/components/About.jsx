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

    useEffect(() => {
        // Replace 'getData' with the actual GAS function name or JSON key in db.json
        callServerFunction('getData').then((response) => setData(response));
    }, []);

    return (
        <>
            <Breadcrumbs items={breadcrumbItems} />
            <Container className="p-3 d-flex flex justify-content-evenly align-items-center">
                <Container className="p-5 mb-4 bg-light rounded-3">
                    <h1 className="header">About</h1>
                    <div>
                        <h1>Data from Server</h1>
                        <pre>{JSON.stringify(data, null, 2)}</pre>
                    </div>
                </Container>

            </Container>

        </>
    );
}

export default About;
