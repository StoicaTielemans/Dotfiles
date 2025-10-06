import ""
import './App.css'
import { Link, Element } from "react-scroll";

function App() {
  return (
    <div>
      {/* Navbar */}
      <nav className="fixed top-0 left-0 w-full bg-gray-900 text-white p-4 flex gap-6">
        <Link to="home" smooth={true} duration={500}>Home</Link>
        <Link to="about" smooth={true} duration={500}>About</Link>
        <Link to="contact" smooth={true} duration={500}>Contact</Link>
      </nav>

      {/* Sections */}
      <Element name="home" className="h-screen flex items-center justify-center bg-blue-100">
        <h1 className="text-4xl">Home</h1>
      </Element>

      <Element name="about" className="h-screen flex items-center justify-center bg-green-100">
        <h1 className="text-4xl">About</h1>
      </Element>

      <Element name="contact" className="h-screen flex items-center justify-center bg-red-100">
        <h1 className="text-4xl">Contact</h1>
      </Element>
    </div>
  );
}


export default App
