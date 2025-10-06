import Logo from '../assets/logo.svg';

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
    <header class="text-gray-600 body-font">
  <div class="container mx-auto flex flex-wrap p-5 flex-col md:flex-row items-center">
    <a class="flex title-font font-medium items-center text-gray-900 mb-4 md:mb-0">
          <img src={Logo} alt="logo" className="w-10 h-10 " />
          <span className="ml-3 text-xl">Beeca Technics</span>
    </a>
    <nav class="md:mr-auto md:ml-4 md:py-1 md:pl-4 md:border-l md:border-gray-400	flex flex-wrap items-center text-base justify-center">
      <div class="mr-5 hover:text-gray-900"               variant="outline-primary"
              onClick={() => handleScroll("target-section")}>First Link</div>
      <div class="mr-5 hover:text-gray-900"               variant="outline-primary"
              onClick={() => handleScroll("target-section")}>Second Link</div>
      <div class="mr-5 hover:text-gray-900"               variant="outline-primary"
              onClick={() => handleScroll("target-section")}>Third Link</div>
      <div class="mr-5 hover:text-gray-900"               variant="outline-primary"
              onClick={() => handleScroll("target-section")}>Fourth Link</div>
    </nav>
    <button class="inline-flex items-center bg-gray-100 border-0 py-1 px-3 focus:outline-none hover:bg-gray-200 rounded text-base mt-4 md:mt-0">Button
      <svg fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" class="w-4 h-4 ml-1" viewBox="0 0 24 24">
        <path d="M5 12h14M12 5l7 7-7 7"></path>
      </svg>
    </button>
  </div>
</header>
  );
}
// ...existing code...
export default BasicExample;