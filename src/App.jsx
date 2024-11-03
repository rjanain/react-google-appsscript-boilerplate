import { Route, Routes } from "react-router-dom";
import Header from "./components/Header";
import Home from "./components/Home";
import Footer from "./components/Footer";
import ErrorBoundary from "./Error";
import About from "./components/About";


function App() {
  const title = "React Bootstrap Boilerplate For Google Apps Script"
  const headerTitle = "React Bootstrap Boilerplate"
  return (
    <>
      <Header title={headerTitle} />
        <ErrorBoundary>
          <Routes>
            <Route path="/" element={<Home title={title} />} />
            <Route path="about" element={<About />} />
            <Route path="*" element={<Home />} />
          </Routes>
        </ErrorBoundary>
      <Footer />
    </>
  );
}

export default App;
