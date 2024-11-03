import React from "react";
import { Container, Row, Col } from "react-bootstrap";

const Footer = () => {
  const version = import.meta.env.VITE_BUILD_VERSION;
  return (
    <footer
      className="bg-primary text-white py-3 mt-auto"
      style={{ borderTop: "5px solid var(--bs-warning )" }}
    >
      <Container>
    <Row>
      <Col md={4} sm={6} xs={6} className="text-left">
        <p className="mb-0">
          <span className="text-warning">
            Email
          </span>{" "}
          <small></small>
        </p>
      </Col>
      <Col md={4} sm={2} xs={2} className="text-center">
        <p className="mb-0">
          <span className="text-warning">v{version}</span>
        </p>
      </Col>
      <Col md={4} sm={4} xs={4} className="text-end">
        <p className="mb-0">
          <small>©{new Date().getFullYear()}</small>
        </p>
      </Col>
    </Row>
  </Container>
    </footer>
  );
};

export default Footer;
