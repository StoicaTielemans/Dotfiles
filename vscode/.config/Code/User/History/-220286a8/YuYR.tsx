import { FC } from "react";
import { useTranslation} from "react-i18next";
import "../i18next";

const Welcome: FC = () => {
  const { t } = useTranslation();
  const scrollTo = (id: string) => {
  document.getElementById(id)?.scrollIntoView({ behavior: "smooth", block: "start" });
};

  return (
    <div className="px-4 sm:px-6 md:px-10 lg:px-20 flex flex-col">
      <div className="flex flex-col lg:flex-row justify-center items-center min-h-screen py-10">
        {/* Content section */}
        <div className="w-full lg:w-7/12 lg:pr-8 order-2 lg:order-1 mt-8 lg:mt-0">
          {/* title */}
          <h1 className="text-3xl sm:text-4xl text-center font-bold text-[#f1ad49] mb-4">
            Stoica Tielemans
          </h1>
          <p className="text-center text-sm sm:text-base font-semibold text-[#2d4667] bg-[#f1ad49]/15 border border-[#f1ad49]/40 rounded-full block w-fit mx-auto px-4 py-1 mb-4">
            {t("fullstackLabel")}
          </p>

          <p className="text-base sm:text-lg mb-4">
            {t("aboutText")}
            {/* text about me */}
          </p>

          {/* icons */}
          <div className="flex justify-center m-5">

            <button
                onClick={() => scrollTo("portfolio")}
                className="flex items-center justify-center w-[80%] mx-4 py-4 bg-primary text-md text-white font-semibold rounded hover:bg-primary-dark transition-colors duration-200"
            >
              {t("projectNav")}
            </button>
            <button
                onClick={() => scrollTo("aboutMe")}
                className="flex items-center justify-center w-[80%] mx-4 py-4 bg-accent text-md text-white font-semibold rounded hover:bg-accent-dark transition-colors duration-200"
            >
              {t("aboutMe")}
            </button>
          </div>

        </div>
      </div>


    </div>
  );
};

export default Welcome;


