import { useState } from 'react'
import reactLogo from './assets/react.svg'
import Navbar from './pages/navbar.jsx'
import Maps from './pages/maps.jsx'
import Feature from './pages/feature.jsx'
import Hero from './pages/hero.jsx'
import Footer from './pages/footer.jsx'
import viteLogo from '/vite.svg'

function App() {

  return (
    <>
    <Navbar />
    <Hero />

    <div id="feature-section">
      <Feature />
    </div>

        <div id="maps-section">
    <Maps />
    </div>

    <Footer />
    </>
  )
}

export default App
