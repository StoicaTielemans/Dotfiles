import { useParams, Link } from "react-router-dom";
import { useEffect, useState, FC } from "react";
import { useTranslation } from "react-i18next";

interface Technology {
  icon?: string;
  name: string;
}

interface ProjectType {
  id: number;
  title: string;
  image: string;
  description: string;
  fullDescription: string;
  technologies: Technology[];
  extraImages?: string[];
  github?: string;
  link?: string;
  course?: string;
  team?: string;
  features?: string[];
  learnings?: string[];
  contribution?: string;
  githubModalText?: string;
  liveModalText?: string;
}

const ProjectDetail: FC = () => {
  const { id } = useParams<{ id: string }>();
  const [project, setProject] = useState<ProjectType | null>(null);
  const [loading, setLoading] = useState(true);
  const [currentImageIndex, setCurrentImageIndex] = useState(0);
  const { t, i18n } = useTranslation(["projects", "translation"]);

  // Modal state
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [currentLink, setCurrentLink] = useState("");
  const [linkType, setLinkType] = useState<"github" | "live">("github");

  useEffect(() => {
    // Load project data
    const loadProjectData = () => {
      // Get projects from i18n resources based on current language
      const projectsData = (i18n.getResourceBundle(i18n.language, "projects") as ProjectType[]) || [];
      // Find the project with matching ID
      const projectFound = projectsData.find((p) => p.id === Number.parseInt(id || "0"));

      if (projectFound) {
        setProject(projectFound);
        setLoading(false);
      } else {
        setLoading(false);
      }
    };

    loadProjectData();

    // Add an event listener for language changes
    const handleLanguageChanged = () => {
      loadProjectData();
    };

    i18n.on("languageChanged", handleLanguageChanged);

    // Clean up the event listeners when component unmounts
    return () => {
      i18n.off("languageChanged", handleLanguageChanged);
    };
  }, [id, i18n]);

  const nextImage = () => {
    if (project) {
      const totalImages = 1 + (project.extraImages?.length || 0);
      setCurrentImageIndex((prevIndex) => (prevIndex + 1) % totalImages);
    }
  };

  const prevImage = () => {
    if (project) {
      const totalImages = 1 + (project.extraImages?.length || 0);
      setCurrentImageIndex(
        (prevIndex) => (prevIndex - 1 + totalImages) % totalImages,
      );
    }
  };

  // Modal handling functions
  const openGithubModal = () => {
    setLinkType("github");
    setCurrentLink(project?.github || "");
    setIsModalOpen(true);
  };

  const openLiveModal = () => {
    setLinkType("live");
    setCurrentLink(project?.link || "");
    setIsModalOpen(true);
  };

  const navItems = [
  { id: "img", translationKey: "img" },
  { id: "project-context", translationKey: "projectContext" },
  { id: "technologies", translationKey: "technologies" },
  { id: "features", translationKey: "keyFeatures" },
  { id: "role", translationKey: "myRoleContribution" },
  { id: "what-i-learned", translationKey: "whatILearned" },

];

  const allImages = project
    ? [project.image, ...(project.extraImages || [])]
    : [];

  if (loading) {
    return (
      <div className="flex justify-center items-center h-screen">
        <p className="text-2xl text-gray-700">
          {t("loading", { ns: "translation", defaultValue: "Laden..." })}
        </p>
      </div>
    );
  }

  if (!project) {
    return (
      <div className="flex flex-col justify-center items-center h-screen">
        <h2 className="text-2xl font-bold text-gray-800 mb-4">
          {t("projectNotFound", {
            ns: "translation",
            defaultValue: "Project niet gevonden",
          })}
        </h2>
        <Link
          to="/"
          className="bg-blue-500 hover:bg-blue-600 text-white py-2 px-4 rounded transition-colors duration-300"
        >
          {t("backToPortfolio", {
            ns: "translation",
            defaultValue: "Terug naar portfolio",
          })}
        </Link>
      </div>
    );
  }

  return (
      <div className="mt-10 bg-gray-50 min-h-screen py-16 relative">
        {/* Sidebar Navigation */}
        <div className="hidden lg:block fixed left-4 top-1/2 -translate-y-1/2 z-40">
          <nav className="sticky top-1/2 -translate-y-1/2 bg-white rounded-lg shadow-md p-4 w-48">
            <h4 className="font-semibold text-gray-800 mb-4 text-sm uppercase tracking-wide">
              {t("sections", {
                ns: "translation"
              })}
            </h4>
            <ul className="space-y-2">
              {navItems.map((item) => (
                  <li key={item.id}>
                    <a
                        href={`#${item.id}`}
                        className="text-gray-600 hover:text-blue-500 transition-colors text-sm font-medium flex items-center gap-2"
                        onClick={(e) => {
                          e.preventDefault();
                          document.getElementById(item.id)?.scrollIntoView({ behavior: "smooth" });
                        }}
                    >
                      {t(item.translationKey, { ns: "translation" })}
                    </a>
                  </li>
              ))}
            </ul>
          </nav>
        </div>

      <div className="max-w-4xl mx-auto px-2">
        <Link
          to="/"
          className="inline-flex items-center text-gray-700 hover:text-blue-500 mb-8 transition-colors duration-300"
        >
          <svg
            xmlns="http://www.w3.org/2000/svg"
            className="h-5 w-5 mr-2"
            viewBox="0 0 20 20"
            fill="currentColor"
          >
            <path
              fillRule="evenodd"
              d="M9.707 16.707a1 1 0 01-1.414 0l-6-6a1 1 0 010-1.414l6-6a1 1 0 011.414 1.414L5.414 9H17a1 1 0 110 2H5.414l4.293 4.293a1 1 0 010 1.414z"
              clipRule="evenodd"
            />
          </svg>
          {t("backToPortfolio", {
            ns: "translation",
            defaultValue: "Terug naar portfolio",
          })}
        </Link>

        <div className="flex justify-between items-start flex-wrap mb-8">
          <h1 className="text-4xl font-bold text-gray-800 mb-4 md:mb-0">
            {project.title}
          </h1>
            <div id="img" className="scroll-mt-20 flex gap-3">
            {project.github && (
              <button
                onClick={openGithubModal}
                className="bg-gray-800 hover:bg-gray-900 text-white px-4 py-2 rounded-md inline-flex items-center transition-colors duration-300"
              >
                <i className="devicon-github-original w-5 h-5 mr-2"></i>
                {t("viewCode", {
                  ns: "translation",
                  defaultValue: "Bekijk Code",
                })}
              </button>
            )}
            {project.link && (
              <button
                onClick={openLiveModal}
                className="bg-blue-500 hover:bg-blue-600 text-white px-4 py-2 rounded-md inline-flex items-center transition-colors duration-300"
              >
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  className="h-5 w-5 mr-2"
                  viewBox="0 0 20 20"
                  fill="currentColor"
                >
                  <path d="M11 3a1 1 0 100 2h2.586l-6.293 6.293a1 1 0 101.414 1.414L15 6.414V9a1 1 0 102 0V4a1 1 0 00-1-1h-5z" />
                  <path d="M5 5a2 2 0 00-2 2v8a2 2 0 002 2h8a2 2 0 002-2v-3a1 1 0 10-2 0v3H5V7h3a1 1 0 000-2H5z" />
                </svg>
                {t("viewLive", {
                  ns: "translation",
                  defaultValue: "Bekijk live",
                })}
              </button>
            )}
          </div>
        </div>

        {/* Rest of the component remains the same */}
        <div className="mb-10 overflow-hidden rounded-lg shadow-md relative">
          {/* Image gallery code... */}
          {allImages.length > 0 && (
            <>
              <img
                src={allImages[currentImageIndex]}
                alt={`${project.title} ${currentImageIndex + 1}`}
                className="w-full object-cover"
              />
              {allImages.length > 1 && (
                <>
                  <button
                    onClick={prevImage}
                    className="absolute left-4 top-1/2 -translate-y-1/2 bg-black bg-opacity-50 hover:bg-opacity-70 text-white rounded-full p-2 transition-all duration-300"
                    aria-label={t("previousImage", {
                      ns: "translation",
                      defaultValue: "Vorige afbeelding",
                    })}
                  >
                    <svg
                      xmlns="http://www.w3.org/2000/svg"
                      className="h-6 w-6"
                      fill="none"
                      viewBox="0 0 24 24"
                      stroke="currentColor"
                    >
                      <path
                        strokeLinecap="round"
                        strokeLinejoin="round"
                        strokeWidth={2}
                        d="M15 19l-7-7 7-7"
                      />
                    </svg>
                  </button>
                  <button
                    onClick={nextImage}
                    className="absolute right-4 top-1/2 -translate-y-1/2 bg-black bg-opacity-50 hover:bg-opacity-70 text-white rounded-full p-2 transition-all duration-300"
                    aria-label={t("nextImage", {
                      ns: "translation",
                      defaultValue: "Volgende afbeelding",
                    })}
                  >
                    <svg
                      xmlns="http://www.w3.org/2000/svg"
                      className="h-6 w-6"
                      fill="none"
                      viewBox="0 0 24 24"
                      stroke="currentColor"
                    >
                      <path
                        strokeLinecap="round"
                        strokeLinejoin="round"
                        strokeWidth={2}
                        d="M9 5l7 7-7 7"
                      />
                    </svg>
                  </button>
                </>
              )}
            </>
          )}

          {/* Image counter */}
          <p className="text-center text-sm text-gray-400">
            {currentImageIndex + 1} / {stageImages.length}
          </p>
        </div>

        <div className="space-y-10">
          {/* Project content sections... */}
          <div id="project-context" className="scroll-mt-20">
            <h3 className="text-2xl font-semibold text-gray-800 mb-4">
              {t("projectContext", {
                ns: "translation",
                defaultValue: "Projectcontext",
              })}
            </h3>
            <div className="bg-white p-6 rounded-lg shadow-sm">
              <p className="text-gray-600 leading-relaxed">
                {project.fullDescription}
              </p>
              {project.course && (
                <p className="mt-4 text-gray-700">
                  <span className="font-semibold">
                    {t("course", { ns: "translation", defaultValue: "Cursus" })}
                    :
                  </span>{" "}
                  {project.course}
                </p>
              )}
              {project.team && (
                <p className="mt-2 text-gray-700">
                  <span className="font-semibold">
                    {t("team", { ns: "translation", defaultValue: "Team" })}:
                  </span>{" "}
                  {project.team}
                </p>
              )}
            </div>
          </div>

          {/* Tech stack */}
          <div id="technologies" className="scroll-mt-20">
            <h3 className="text-2xl font-semibold text-gray-800 mb-4">
              {t("technologies", {
                ns: "translation",
                defaultValue: "Technologieën",
              })}
            </h3>
            <div className="flex flex-wrap gap-3">
              {project.technologies.map((tech) => (
                <div
                  key={tech.name}
                  className="bg-blue-50 text-[#2d4667] px-4 py-2 rounded-lg flex items-center gap-2"
                >
                  {tech.icon && (
                    <img src={tech.icon} alt={tech.name} className="w-5 h-5" />
                  )}
                  <span>{tech.name}</span>
                </div>
              ))}
            </div>
          </div>

          {/* Concrete Realizations */}
          {project.features && (
            <div id="features" className="scroll-mt-20">
              <h3 className="text-2xl font-semibold text-gray-800 mb-4">
                {t("keyFeatures", {
                  ns: "translation",
                  defaultValue: "Belangrijkste functies",
                })}
              </h3>
              <div className="bg-white p-6 rounded-lg shadow-sm">
                <ul className="list-disc pl-5 space-y-2 text-gray-600">
                  {project.features.map((feature) => (
                    <li key={feature} className="leading-relaxed">
                      {feature}
                    </li>
                  ))}
                </ul>
              </div>
            </div>
          )}

          {/* Role & Contribution */}
          {project.contribution && (
              <div id="role" className="scroll-mt-20">
                <h3 className="text-2xl font-semibold text-gray-800 mb-4">
                  {t("myRoleContribution", {
                    ns: "translation",
                    defaultValue: "Mijn rol & bijdrage",
                  })}
                </h3>
                <div className="bg-white p-6 rounded-lg shadow-sm">
                  <p className="text-gray-600 leading-relaxed">
                    {project.contribution}
                  </p>
                </div>
              </div>
          )}

          {/* What I Learned */}
          {project.learnings && (
              <div id="what-i-learned" className="scroll-mt-20">
              <h3 className="text-2xl font-semibold text-gray-800 mb-4">
                {t("whatILearned", {
                  ns: "translation",
                  defaultValue: "Wat ik heb geleerd",
                })}
              </h3>
              <div className="bg-white p-6 rounded-lg shadow-sm">
                <ul className="list-disc pl-5 space-y-2 text-gray-600">
                  {project.learnings.map((learning) => (
                    <li key={learning} className="leading-relaxed">
                      {learning}
                    </li>
                  ))}
                </ul>
              </div>
            </div>
          )}

        </div>
      </div>

      {/* Link Modal */}
      {isModalOpen && (
        <div className="fixed inset-0 bg-gray-800 bg-opacity-75 flex items-center justify-center z-50">
          <div className="bg-white rounded-lg p-6 max-w-md w-full mx-4">
            <h3 className="text-xl font-bold mb-4">
              {linkType === "github"
                ? t("githubModalTitle", {
                    ns: "translation",
                    defaultValue: "Bekijk code op GitHub",
                  })
                : t("liveModalTitle", {
                    ns: "translation",
                    defaultValue: "Bekijk live project",
                  })}
            </h3>
            <p className="mb-6 text-gray-600">
              {linkType === "github"
                ? t(project.githubModalText || "github", {
                    ns: "translation",
                  })
                : t(project.liveModalText || "live", {
                    ns: "translation",
                  })}
            </p>
            <div className="flex justify-end space-x-4">
               <button
                 className="px-4 py-2 bg-gray-300 text-gray-800 rounded hover:bg-gray-400 transition-colors"
                 onClick={() => setIsModalOpen(false)}
               >
                 {t("cancel", { ns: "translation", defaultValue: "Annuleren" })}
               </button>
               <a
                 href={currentLink}
                 target="_blank"
                 rel="noopener noreferrer"
                 className={`px-4 py-2 text-white rounded hover:opacity-90 transition-colors ${
                   linkType === "github" ? "bg-gray-800" : "bg-primary"
                 }`}
                 onClick={() => setIsModalOpen(false)}
               >
                {linkType === "github"
                  ? t("proceedToGithub", {
                      ns: "translation",
                      defaultValue: "Ga naar GitHub",
                    })
                  : t("proceedToSite", {
                      ns: "translation",
                      defaultValue: "Ga naar site",
                    })}
              </a>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default ProjectDetail;


