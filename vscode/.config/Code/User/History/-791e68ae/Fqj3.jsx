import { useState } from 'react'
import reactLogo from './assets/react.svg'
import Navbar from './pages/navbar.jsx'
import Maps from './pages/maps.jsx'
import Feature from './pages/feature.jsx'
import Footer from './pages/footer.jsx'
import viteLogo from '/vite.svg'

function App() {

  return (
    <>
    <Navbar />
        <div id="target-section">
    <Maps />
    </div>

    <div id="target-section">
      <Feature />
    </div>
    <Footer />
    </>
  )
}

export default App
