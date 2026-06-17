import { useEffect, FC } from "react";
import {
  useLocation,
  BrowserRouter,
  Route,
  Routes,
} from "react-router-dom";
import Home from "./components/home";
import PDFPage from "./components/pdfPage";
import Navbar from "./components/navbar";
import ProjectDetail from "./components/projectDetail";
import { Analytics } from "@vercel/analytics/react"

// Make sure a new page opens at the top
const ScrollToTop: FC = () => {
  const { pathname } = useLocation();

  useEffect(() => {
    window.scrollTo(0, 0);
  }, [pathname]);

  return null;
}

const Main: FC = () => {
  return (
    <div>
      <ScrollToTop />
      <Navbar />
      <main>
        <Routes>
          <Route path="/" element={<Home />} />
          <Route path="/Cv" element={<PDFPage />} />
          <Route path="/project/:id" element={<ProjectDetail />} />
        </Routes>
      </main>
    </div>
  );
}

const App: FC = () => {
  return (
    <BrowserRouter>
    <Analytics />
      <Main />
    </BrowserRouter>
  );
}

export default App;

