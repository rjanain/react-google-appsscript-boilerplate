import { Col, Container, Row } from "react-bootstrap";
import { useTheme } from "../../contexts/theme";

function Welcome(props) {
  //define some sample data
  const {themeMode} = useTheme();
  const className = `p-1 mb-0 bg-${themeMode} d-flex flex justify-content-evenly align-items-center`
  return (
    <>
        <Container
        fluid
        className={className}
      >
        <Container className="p-5">
          <Row>
            <Col md={{ span: 8 }}>
            <h1>{props.title}</h1>
            <p>{props.description}</p>
            </Col>
          </Row>
        </Container>
      </Container>     
    </>
  )
}

export default Welcome