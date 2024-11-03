import { NavDropdown } from "react-bootstrap";
import Container from "react-bootstrap/Container";
import Nav from "react-bootstrap/Nav";
import Navbar from "react-bootstrap/Navbar";
import { FaDatabase, FaMoon, FaSun } from "react-icons/fa";
import { Link, useLocation } from "react-router-dom";

import { useTheme } from "../contexts/theme";
import { themeStyles } from "../styles/navStyle";

const themes = [
  "cerulean", // good theme for dark mode
  "cosmo", // dark mode checked
  "cyborg", // dark based theme
  "darkly",
  "flatly",
  "journal",
  "litera",
  "lumen", // note look good for light
  "lux",
  "materia",
  "minty",
  "morph",
  "pulse",
  "quartz",
  "sandstone",
  "simplex",
  "sketchy",
  "slate",
  "solar",
  "spacelab",
  "superhero",
  "united",
  "vapor",
  "yeti",
  "zephyr",
];

const VerticalDivider = () => (
  <Nav.Item as="li" className="py-1 py-lg">
    <div className="vr d-none d-lg-flex h-100 mx-lg-0 text-white"></div>
    <hr className="d-lg-none my-2 text-white-50" />
  </Nav.Item>
);

function Header(props) {
  const { theme, themeMode, toggleTheme, toggleDarkMode } = useTheme();
  const location = useLocation();
  const navbarStyle = themeStyles[theme] ?? themeStyles["zephyr"];

  return (
    <>
      <Navbar
        collapseOnSelect
        expand="lg"
        bg="dark"
        variant="dark"
        style={navbarStyle}
      >
        <Container>
          <Navbar.Brand as={Link} to={"/"}>
            <FaDatabase size={"1.5rem"} className="mx-1" />
            {props.title ?? "A sample website"}
          </Navbar.Brand>
          <Navbar.Toggle aria-controls="responsive-navbar-nav" />
          <Navbar.Collapse id="responsive-navbar-nav">
            <Nav className="me-auto" as="ul" activeKey={location?.pathname}>
              <Nav.Item as="li">
                <Nav.Link
                  as={Link}
                  className="nav-link"
                  eventKey={"/"}
                  to={"/"}
                >
                  Home
                </Nav.Link>
              </Nav.Item>

              <Nav.Item as="li">
                <Nav.Link
                  as={Link}
                  className="nav-link"
                  eventKey={"/about"}
                  to={"/about"}
                >
                  About
                </Nav.Link>
              </Nav.Item>
            </Nav>
            <Nav as="ul" className="ms-md-auto">
              <VerticalDivider />
              <Nav.Item as="li">
                <NavDropdown title="Themes" id="themes" align="end">
                  <NavDropdown.Item onClick={() => toggleTheme("default")}>
                    Default
                  </NavDropdown.Item>
                  {themes.map((theme) => (
                    <NavDropdown.Item
                      key={theme}
                      onClick={() => toggleTheme(theme)}
                    >
                      {theme.charAt(0).toUpperCase() + theme.slice(1)}
                    </NavDropdown.Item>
                  ))}
                </NavDropdown>
              </Nav.Item>
              {/* Vertical Divider */}
              <VerticalDivider />
              <Nav.Item as="li">
                {/* Dark/Light Mode Toggle Dropdown */}
                <Nav.Link onClick={() => toggleDarkMode()}>
                  {themeMode === "dark" ? (
                    <FaSun size="1.5rem" />
                  ) : (
                    <FaMoon size="1.5rem" />
                  )}
                </Nav.Link>
              </Nav.Item>
            </Nav>
          </Navbar.Collapse>
        </Container>
      </Navbar>
    </>
  );
}

export default Header;
