import { useState } from 'react'
import reactLogo from './assets/react.svg'
import Navbar from './pages/navbar.jsx'
import Footer from './pages/footer.jsx'
import viteLogo from '/vite.svg'

function App() {

  return (
    <>
    <Navbar />
        <div id="target-section">
    <img src={viteLogo} alt="vite logo" />
    </div>
    <div>
    <img src={viteLogo} alt="vite logo" />
    </div>
    <Footer />
    </>
  )
}

export default App
