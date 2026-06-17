import { FC } from "react";
import { Link } from "react-router-dom";
import { useTranslation } from "react-i18next";

const AboutMeDetails: FC = () => {
  const { t } = useTranslation();

  return (
      <div className="bg-gray-100 min-h-screen mt-20 pt-18 px-4 sm:px-6 md:px-10 ">
        <div className="max-w-6xl mx-auto space-y-5">
      <div className="flex flex-col">
        <h2 className="text-4xl font-bold text-center text-[#2d4667] mb-2">
          {t("aboutMe")}
        </h2>
        <div className="grid grid-cols-1 lg:grid-cols-4 items-start">

          <div className="w-full lg:row-span-2 flex flex-col lg:pt-10 justify-center items-center ">
            {/* Image section */}
              <img
                  src="/profile.png"
                  alt="Profile"
                  className="rounded-3xl object-cover w-full max-w-xs sm:max-w-sm"
              />

            {/* icons */}
            <div className="flex justify-center m-5">
              <Link
                  to="/CV"
                  className="font-bold mx-2.5 no-underline group relative"
              >
                <svg
                    width="48"
                    height="48"
                    viewBox="0 0 24 24"
                    xmlns="http://www.w3.org/2000/svg"
                    className="transition-colors duration-300 fill-[#2d4667] hover:fill-[#3a5b85]"
                >
                  <path d="M3 24h19v-23h-1v22h-18v1zm17-24h-18v22h18v-22zm-3 17h-12v1h12v-1zm0-3h-12v1h12v-1zm0-3h-12v1h12v-1zm-7.348-3.863l.948.3c-.145.529-.387.922-.725 1.178-.338.257-.767.385-1.287.385-.643 0-1.171-.22-1.585-.659-.414-.439-.621-1.04-.621-1.802 0-.806.208-1.432.624-1.878.416-.446.963-.669 1.642-.669.592 0 1.073.175 1.443.525.221.207.386.505.496.892l-.968.231c-.057-.251-.177-.449-.358-.594-.182-.146-.403-.218-.663-.218-.359 0-.65.129-.874.386-.223.258-.335.675-.335 1.252 0 .613.11 1.049.331 1.308.22.26.506.39.858.39.26 0 .484-.082.671-.248.187-.165.322-.425.403-.779zm3.023 1.78l-1.731-4.842h1.06l1.226 3.584 1.186-3.584h1.037l-1.734 4.842h-1.044z" />
                </svg>
                <div className="absolute bottom-full left-1/2 transform -translate-x-1/2 -translate-y-1 bg-[#2d4667] text-white text-xs px-2 py-1 rounded opacity-0 group-hover:opacity-100 transition-opacity duration-200 pointer-events-none whitespace-nowrap">
                  CV
                  <div className="absolute top-full left-1/2 transform -translate-x-1/2 border-4 border-transparent border-t-[#2d4667]"></div>
                </div>
              </Link>

              <a
                  className="mx-2.5 relative group"
                  href="https://github.com/StoicaTielemans"
              >
                <svg
                    width="48"
                    height="48"
                    viewBox="0 0 128 128"
                    className="transition-colors duration-300 fill-[#2d4667] hover:fill-[#3a5b85]"
                >
                  <path d="M64 5.103c-33.347 0-60.388 27.035-60.388 60.388 0 26.682 17.303 49.317 41.297 57.303 3.017.56 4.125-1.31 4.125-2.905 0-1.44-.056-6.197-.082-11.243-16.8 3.653-20.345-7.125-20.345-7.125-2.747-6.98-6.705-8.836-6.705-8.836-5.48-3.748.413-3.67.413-3.67 6.063.425 9.257 6.223 9.257 6.223 5.386 9.23 14.127 6.562 17.573 5.02.542-3.903 2.107-6.568 3.834-8.076-13.413-1.525-27.514-6.704-27.514-29.843 0-6.593 2.36-11.98 6.223-16.21-.628-1.52-2.695-7.662.584-15.98 0 0 5.07-1.623 16.61 6.19C53.7 35 58.867 34.327 64 34.304c5.13.023 10.3.694 15.127 2.033 11.526-7.813 16.59-6.19 16.59-6.19 3.287 8.317 1.22 14.46.593 15.98 3.872 4.23 6.215 9.617 6.215 16.21 0 23.194-14.127 28.3-27.574 29.796 2.167 1.874 4.097 5.55 4.097 11.183 0 8.08-.07 14.583-.07 16.572 0 1.607 1.088 3.49 4.148 2.897 23.98-7.994 41.263-30.622 41.263-57.294C124.388 32.14 97.35 5.104 64 5.104z"></path>
                </svg>
                <div className="absolute bottom-full left-1/2 transform -translate-x-1/2 -translate-y-1 bg-[#2d4667] text-white text-xs px-2 py-1 rounded opacity-0 group-hover:opacity-100 transition-opacity duration-200 pointer-events-none whitespace-nowrap">
                  Github
                  <div className="absolute top-full left-1/2 transform -translate-x-1/2 border-4 border-transparent border-t-[#2d4667]"></div>
                </div>
              </a>

              <a
                  className="mx-2.5 relative group"
                  href="https://www.linkedin.com/in/stoica-tielemans/"
              >
                <svg
                    width="48"
                    height="48"
                    viewBox="0 0 128 128"
                    className="transition-colors duration-300 fill-[#2d4667] hover:fill-[#3a5b85]"
                >
                  <path d="M116 3H12a8.91 8.91 0 00-9 8.8v104.42a8.91 8.91 0 009 8.78h104a8.93 8.93 0 009-8.81V11.77A8.93 8.93 0 00116 3zM39.17 107H21.06V48.73h18.11zm-9-66.21a10.5 10.5 0 1110.49-10.5 10.5 10.5 0 01-10.54 10.48zM107 107H88.89V78.65c0-6.75-.12-15.44-9.41-15.44s-10.87 7.36-10.87 15V107H50.53V48.73h17.36v8h.24c2.42-4.58 8.32-9.41 17.13-9.41C103.6 47.28 107 59.35 107 75z"></path>
                </svg>
                <div className="absolute bottom-full left-1/2 transform -translate-x-1/2 -translate-y-1 bg-[#2d4667] text-white text-xs px-2 py-1 rounded opacity-0 group-hover:opacity-100 transition-opacity duration-200 pointer-events-none whitespace-nowrap">
                  LinkedIn
                  <div className="absolute top-full left-1/2 transform -translate-x-1/2 border-4 border-transparent border-t-[#2d4667]"></div>
                </div>
              </a>

            </div>

          </div>

          {/*
          Second Column: Contains the text blocks.
        */}
          <div className="w-full flex flex-col lg:col-span-3 justify-center">
            <div className="space-y-6">
              {/* Row 1 Text Field - Study choice reason */}
              <div className="bg-white backdrop-blur-sm rounded-lg p-4 lg:ml-8 sm:p-6 shadow-lg border border-white/10 ">
                <h2 className="text-lg sm:text-xl font-bold mb-3 sm:mb-4 text-primary">
                  {t("aboutMeTitle1")}
                </h2>
                <p className="text-sm sm:text-base">{t("aboutMeText1")}</p>
              </div>


              {/*soft skill field*/}
              <div className="bg-white backdrop-blur-sm rounded-lg p-4 lg:ml-8 sm:p-6 shadow-lg border border-white/10 ">
                <h2 className="text-lg sm:text-xl font-bold mb-3 sm:mb-4 text-primary">
                  {t("aboutMeTitle3")}
                </h2>
                <p className="text-sm sm:text-base mb-2">{t("aboutMeText3")}</p>
<div className="space-y-4 text-sm sm:text-base text-gray-600">
  <div>
    <p className="font-semibold text-gray-800">Analytisch & Strategisch</p>
    <p>Ik hou ervan om voor complexe problemen effectief oplossingen te bedenken.</p>
  </div>
  <div>
    <p className="font-semibold text-gray-800">Leergierig & Zelfstandig</p>
    <p>De IT-wereld staat nooit stil. Ik pak graag nieuwe technologieën op.</p>
  </div>
  <div>
    <p className="font-semibold text-gray-800">Samenwerken</p>
    <p>Ik functioneer uitstekend in teamverband. Zowel tijdens softwareprojecten als in het dagelijkse contact zorg ik voor een heldere communicatie.</p>
  </div>
</div>
          </div>

        </div>
      </div>

      {/* Unique hobbies - full width row */}
      <div className="lg:col-span-4 pt-4">
        <div className="bg-white backdrop-blur-sm rounded-lg p-4 sm:p-6 shadow-lg border border-white/10">
          <h2 className="text-lg sm:text-xl font-bold mb-3 sm:mb-4 text-primary">
            {t("aboutMeTitle2")}
          </h2>
          <p className="text-sm sm:text-base mb-2">{t("aboutMeText2")}</p>
        </div>
      </div>
        </div>
      </div>
      </div>
      </div>
  );
};

export default AboutMeDetails;
