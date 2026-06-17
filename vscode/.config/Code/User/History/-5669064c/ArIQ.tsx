import { FC } from "react";
import {useTranslation} from "react-i18next";
import "../i18next";

const Stage: FC = () => {
  const { t } = useTranslation();

  const openPDF = (filename: string) => {
    window.open(`/stage/${filename}`, "_blank");
  };

  return (
    <div className="bg-gray-100 min-h-screen pt-28 pb-16 px-4 sm:px-6 md:px-10 lg:px-20">
      <div className="max-w-5xl mx-auto space-y-10">
          {/* Header Section */}
          <div className="space-y-3 text-center text-[#2d4667]">
            <p className="text-sm font-semibold uppercase tracking-[0.2em] text-[#f1ad49]">
              Mijn stage
            </p>
            <h1 className="text-3xl sm:text-4xl font-bold">Uitwerking van de verkoop factuur module bij As One</h1>
          </div>
          {/* Description Section */}
          <div className="bg-white rounded-lg shadow-md p-8 md:p-12">
            <div className="space-y-6 text-gray-700 leading-relaxed">
              <h1 className="text-2xl font-bold text-primary">Intro</h1>
              <p className="text-lg">
                Tijdens de stageperiode bij As One was het hoofddoel het ontwikkelen van een nieuwe verkoopfactuurmodule binnen het bestaande project 'Gint'. As One is een softwarebedrijf dat zowel aan consultancy doet als applicaties op maat maakt. Gint is zo'n applicatie op maat voor het interieurbedrijf G-interieur, en vormt een geavanceerde combinatie van een CRM (Customer Relationship Management) en een BOM-systeem (Bill of Materials). Het centraliseert alle data, calculaties, materialen en dossiers die nodig zijn om projecten efficiënt te berekenen, te beheren en op te volgen.
              </p>
              <h1 className="text-2xl font-bold text-primary">Opdracht</h1>
              <p className="text-lg">
                Het hoofddoel van deze opdracht was het ontwerpen, implementeren en testen van een nieuwe verkoopfactuurmodule. Deze module biedt functionaliteiten voor het aanmaken van nieuwe verkoopfacturen gekoppeld aan specifieke dossiers, het aanpassen van facturen en het verwijderen van conceptfacturen. Daarnaast is er functionaliteit om een PDF te genereren voor de verkoopfacturen. Al deze functionaliteiten bevinden zich op verschillende pagina's, waaronder een overzichtspagina waar je kan zoeken naar een of meerdere verkoopfacturen, een detailpagina waar je alle informatie van een verkoopfactuur kan bekijken, en een aanmaak en aanpas pagina waar je nieuwe of bestaande facturen kunt aanmaken en aanpassen. Belangrijk is dat de structuur zo wordt opgezet dat het systeem toekomstbestendig is en eenvoudig kan worden afgestemd op de nieuwe Peppol-wetgeving voor digitale facturatie, waarbij factuurgegevens voorbereid worden op de e-invoicing standaarden. Voor meer informatie over het plan dat ik heb opgesteld voor de stageopdracht, bekijk het Projectplan document in de documenten sectie hieronder. Voor meer informatie over de uitwerking van de nieuwe verkoopmodule, bekijk het Realisatie document.
              </p>
              <h1 className="text-2xl font-bold text-primary">Wat Heb ik geleerd?</h1>
              <p className="text-lg">Tijdens de stage heb ik veel geleerd over het ontwikkelen van software in een professionele omgeving. Ik heb geleerd hoe je goed kunt communiceren met collega's en hoe je moet omgaan met feedback en verbeteringen. Daarnaast heb ik geleerd hoe je efficiënt kunt werken binnen een bestaande expertise-applicatie en hoe je goede pull requests kunt opstellen.</p>
            </div>

        </div>


        {/* Documents Section */}
        <div>
          <h2 className="text-2xl font-semibold text-[#2d4667] text-center">
            Stage Documenten
          </h2>
          <p className="text-lg p-10">
            Hieronder vindt u de documenten die ik heb gerealiseerd tijdens mijn stageperiode, waaronder het projectplan, het realisatiedocument en het reflectiedocument, met als aanvullend document mijn voortgangsverslag.
          </p>
          <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
            <button
              onClick={() => openPDF("projectplan.pdf")}
              className="bg-accent hover:bg-accent-dark text-primary font-semibold py-3 px-6 rounded-lg shadow-md hover:shadow-lg transition-all duration-300 transform hover:-translate-y-1"
            >
              <svg
                xmlns="http://www.w3.org/2000/svg"
                className="w-5 h-5 inline mr-2"
                fill="none"
                viewBox="0 0 24 24"
                stroke="currentColor"
              >
                <path
                  strokeLinecap="round"
                  strokeLinejoin="round"
                  strokeWidth={2}
                  d="M7 21h10a2 2 0 002-2V9.414a1 1 0 00-.293-.707l-5.414-5.414A1 1 0 0012.586 3H7a2 2 0 00-2 2v14a2 2 0 002 2z"
                />
              </svg>
              Projectplan
            </button>

            <button
              onClick={() => openPDF("realisatiedocument.pdf")}
              className="bg-accent hover:bg-accent-dark text-primary font-semibold py-3 px-6 rounded-lg shadow-md hover:shadow-lg transition-all duration-300 transform hover:-translate-y-1"
            >
              <svg
                xmlns="http://www.w3.org/2000/svg"
                className="w-5 h-5 inline mr-2"
                fill="none"
                viewBox="0 0 24 24"
                stroke="currentColor"
              >
                <path
                  strokeLinecap="round"
                  strokeLinejoin="round"
                  strokeWidth={2}
                  d="M7 21h10a2 2 0 002-2V9.414a1 1 0 00-.293-.707l-5.414-5.414A1 1 0 0012.586 3H7a2 2 0 00-2 2v14a2 2 0 002 2z"
                />
              </svg>
              Realisatiedocument
            </button>

            <button
              onClick={() => openPDF("reflectiedocument.pdf")}
              className="bg-primary hover:bg-primary-dark text-white font-semibold py-3 px-6 rounded-lg shadow-md hover:shadow-lg transition-all duration-300 transform hover:-translate-y-1"
            >
              <svg
                xmlns="http://www.w3.org/2000/svg"
                className="w-5 h-5 inline mr-2"
                fill="none"
                viewBox="0 0 24 24"
                stroke="currentColor"
              >
                <path
                  strokeLinecap="round"
                  strokeLinejoin="round"
                  strokeWidth={2}
                  d="M7 21h10a2 2 0 002-2V9.414a1 1 0 00-.293-.707l-5.414-5.414A1 1 0 0012.586 3H7a2 2 0 00-2 2v14a2 2 0 002 2z"
                />
              </svg>
              Reflectiedocument
            </button>

            <button
              onClick={() => openPDF("stageverslag.pdf")}
              className="bg-primary hover:bg-primary-dark text-white font-semibold py-3 px-6 rounded-lg shadow-md hover:shadow-lg transition-all duration-300 transform hover:-translate-y-1"
            >
              <svg
                xmlns="http://www.w3.org/2000/svg"
                className="w-5 h-5 inline mr-2"
                fill="none"
                viewBox="0 0 24 24"
                stroke="currentColor"
              >
                <path
                  strokeLinecap="round"
                  strokeLinejoin="round"
                  strokeWidth={2}
                  d="M7 21h10a2 2 0 002-2V9.414a1 1 0 00-.293-.707l-5.414-5.414A1 1 0 0012.586 3H7a2 2 0 00-2 2v14a2 2 0 002 2z"
                />
              </svg>
              Extra voortgangsverslag
            </button>
          </div>
        </div>

      </div>
    </div>
  );
};

export default Stage;


