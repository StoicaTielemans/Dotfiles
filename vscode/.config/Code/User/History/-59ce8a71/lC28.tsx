import { Link } from "react-router-dom";
import { useTranslation} from "react-i18next";
import { FC } from "react";

interface Technology {
  icon: string;
  name: string;
}

interface ProjectType {
  id: number;
  title: string;
  image: string;
  description: string;
  technologies: Technology[];
}

const Portfolio: FC = () => {
  const { t, i18n } = useTranslation("projects");
  const projects: ProjectType[] = (i18n.getResourceBundle(i18n.language, "projects") as ProjectType[]) || [];


  return (
    <section id="portfolio" className="py-20">
      <div className="max-w-6xl mx-auto ">
        <h2 className="text-4xl font-bold text-center text-primary mb-2">
          {t("portfolioTitle", {
            ns: "translation",
            defaultValue: "Mijn Portfolio",
          })}
        </h2>

        <div className="grid grid-cols-1 gap-10 mt-10">
          {projects.map((project, index) => (
            <div
              key={project.id}
              className={`bg-white rounded-lg overflow-hidden shadow-lg transition-transform duration-300 hover:-translate-y-2 flex flex-col ${
                index % 2 === 0 ? "md:flex-row" : "md:flex-row-reverse"
              }`}
            >
              <Link
                  to={`/project/${project.id}`}
                  className={"flex flex-col md:flex-row h-full" }
              >
              {/* Image Section */}
              <div className="md:w-1/2 h-64 md:h-80 overflow-hidden relative">
                <img
                  src={project.image}
                  alt={project.title}
                  className="w-full h-full object-cover object-top"
                />
              </div>

              {/* Content Section */}
              <div className="p-6 md:w-1/2 flex flex-col justify-between">
                <div>
                  <h3 className="text-2xl font-semibold text-gray-800 mb-3">
                    {project.title}
                  </h3>
                  <p className="text-gray-600 mb-6 leading-relaxed">
                    {project.description}
                    <Link
                      to={`/project/${project.id}`}
                      className="hidden md:inline-block lg:hidden items-center ml-2 px-6 py-2 bg-primary text-xs text-white font-semibold rounded hover:bg-primary-light transition-colors duration-200"
                    >
                      {t("moreInfo", {
                        ns: "translation",
                        defaultValue: "Meer Info",
                      })}
                    </Link>
                  </p>
                </div>
                <div className="md:hidden lg:block">
                  <h4 className="text-sm font-semibold text-gray-700 mb-2">
                    {t("technologiesUsed", {
                      ns: "translation",
                      defaultValue: "Gebruikte technologieën:",
                    })}
                  </h4>
                  <div className="flex flex-wrap gap-3">
                    {project.technologies.map((tech) => (
                      <div key={tech.name} className="relative group">
                        <div className="w-10 h-10 flex items-center justify-center bg-gray-100 rounded-full">
                          <img
                            src={tech.icon}
                            alt={tech.name}
                            className="w-6 h-6 transition-transform duration-200 group-hover:scale-125"
                          />
                        </div>
                        <div className="absolute bottom-full left-1/2 transform -translate-x-1/2 -translate-y-1 bg-primary text-white text-xs px-2 py-1 rounded opacity-0 group-hover:opacity-100 transition-opacity duration-200 pointer-events-none whitespace-nowrap">
                          {tech.name}
                          <div className="absolute top-full left-1/2 transform -translate-x-1/2 border-4 border-transparent border-t-gray-800"></div>
                        </div>
                      </div>
                    ))}

                    <Link
                      to={`/project/${project.id}`}
                      className=" items-center ml-1 flex px-6 py-2 bg-primary text-sm text-white font-semibold rounded hover:bg-primary-light transition-colors duration-200"
                    >
                      {t("moreInfo", {
                        ns: "translation",
                        defaultValue: "Meer Info",
                      })}
                    </Link>
                  </div>
                </div>
              </div>
              </Link>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
};

export default Portfolio;


