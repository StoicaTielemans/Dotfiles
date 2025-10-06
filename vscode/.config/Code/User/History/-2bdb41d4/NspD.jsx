import Container from 'react-bootstrap/Container';
import Nav from 'react-bootstrap/Nav';
import Navbar from 'react-bootstrap/Navbar';
import NavDropdown from 'react-bootstrap/NavDropdown';

// ...existing code...
import Button from 'react-bootstrap/Button';

function BasicExample() {
  // Scroll handler
  const handleScroll = (elementId) => {
    const section = document.getElementById(elementId);
    if (section) {
      const yOffset = -70; // Adjust this value to match your navbar height
      const y = section.getBoundingClientRect().top + window.pageYOffset + yOffset;
      window.scrollTo({ top: y, behavior: 'smooth' });
    }
  };

  return (
    <Navbar expand="lg" className="bg-body-tertiary" sticky="top">
        <Navbar.Brand>React-Bootstrap</Navbar.Brand>
        <Navbar.Toggle aria-controls="basic-navbar-nav" />
        <Navbar.Collapse id="basic-navbar-nav">
          <Nav className="me-auto">
            <Nav.Link href="#home">Home</Nav.Link>
            <Nav.Link href="#link">Link</Nav.Link>
            {/* Add your scroll button here */}
            <Button
              variant="outline-primary"
              onClick={() => handleScroll("target-section")}
            >
              Go to Section
            </Button>

            <Button
              variant="outline-primary"
              onClick={() => handleScroll("footer")}
            >
              Go to Section
            </Button>
          </Nav>
        </Navbar.Collapse>
    </Navbar>
  );
}
// ...existing code...
export default BasicExample;