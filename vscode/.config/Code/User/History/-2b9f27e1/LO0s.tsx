import { FC, useEffect } from "react";
import { useLocation } from "react-router-dom";
import Welcome from "./welcome";
import Projects from "./project";
import AboutMeDetails from "./aboutMeDetails.tsx";
import Stage from "./stage.tsx";
import Contact from "./contact.tsx";

const Home: FC = () => {
  const location = useLocation();

  useEffect(() => {
    // Handle scroll to sections when hash is provided
    if (location.hash) {
      const sectionId = location.hash.substring(1);
      // Small delay to ensure DOM elements are rendered
      const timer = setTimeout(() => {
        const section = document.getElementById(sectionId);
        if (section) {
          section.scrollIntoView({ behavior: "smooth", block: "start" });
        }
      }, 100);
      return () => clearTimeout(timer);
    }
  }, [location.hash]);

  return (
    <div className="bg-gray-100 h-full">
      <div className="container mx-auto flex flex-col justify-center">
        <div id="home">
          <Welcome />
        </div>
        <div id="aboutMe">
          <AboutMeDetails/>
        </div>
        <div id="stage">
          <Stage/>
        </div>
        <div id="portfolio">
          <Projects />
        </div>
        <div id="contact">
          <Contact/>
        </div>
<footer className="w-full py-8 mt-10 border-t border-gray-200 text-center text-gray-600">
      <p className="mb-2 text-sm">
        © {new Date().getFullYear()} Stoica Tielemans. Alle rechten voorbehouden.
      </p>
      <div className="text-xs text-gray-400 px-4">
        <p>
          <strong className="text-gray-500">AI-vermelding:</strong> Teksten op dit platform 
          zijn gecontroleerd en gecorrigeerd met behulp van kunstmatige intelligentie voor 
          spelling, grammatica en tekstuele verbeteringen.
        </p>
      </div>
    </footer>
      </div>
    </div>
  );
};

export default Home;


