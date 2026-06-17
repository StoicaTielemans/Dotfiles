import { FC, useState, useEffect, useMemo, useRef, useCallback } from "react";
import { Link, useLocation, useNavigate } from "react-router-dom";
import { useTranslation } from "react-i18next";
import "../i18next";

interface Project {
    id: number;
    title: string;
}

interface NavItem {
    id: string;
    type: "scroll" | "link";
    label?: string;
    translationKey?: string;
    path?: string;
}

const SCROLL_SECTIONS = ["home", "aboutMe", "stage", "portfolio", "contact"];

const NAV_ITEMS: NavItem[] = [
    { id: "home",      type: "scroll", translationKey: "home" },
    { id: "aboutMe",   type: "scroll", translationKey: "aboutMe" },
    { id: "cv",        type: "link",   label: "CV", path: "/Cv" },
    { id: "stage",     type: "scroll", translationKey: "stageNav" },
    { id: "portfolio", type: "scroll", translationKey: "projectNav" },
    { id: "contact",   type: "scroll", translationKey: "contactNav" },
];

const projectNavItem: NavItem = {
    id: "portfolio", 
    type: "scroll",
    translationKey: "projectNav",
};

const BASE_ITEM_CLASS =
    "font-bold no-underline hover:text-primary-dark transition-all duration-300 relative " +
    "after:absolute after:bottom-0 after:left-0 after:bg-primary-dark " +
    "after:h-0.5 after:w-0 hover:after:w-full after:transition-all after:duration-300 " +
    "hover:-translate-y-[2px]";

const MOBILE_ITEM_CLASS = "py-3 px-4 text-left hover:bg-accent/20 hover:pl-6 hover:shadow-md";
const DESKTOP_ACTIVE_CLASS = "text-primary-dark after:w-full";
const MOBILE_ACTIVE_CLASS = "bg-accent/20 text-primary-dark";

function useScrollSpy(sections: string[], enabled: boolean) {
    const [activeSection, setActiveSection] = useState("home");
    const observerRef = useRef<IntersectionObserver | null>(null);

    const setup = useCallback(() => {
        observerRef.current?.disconnect();
        observerRef.current = new IntersectionObserver(
            (entries) => {
                entries.forEach((entry) => {
                    if (entry.isIntersecting) setActiveSection(entry.target.id);
                });
            },
            { root: null, rootMargin: "-50% 0px -50% 0px", threshold: 0 }
        );
        sections.forEach((id) => {
            const el = document.getElementById(id);
            if (el) observerRef.current!.observe(el);
        });
    }, [sections]);

    useEffect(() => {
        if (!enabled) {
            setActiveSection("home");
            observerRef.current?.disconnect();
            observerRef.current = null;
            return;
        }
        setActiveSection("home");
        const timer = setTimeout(setup, 50);
        return () => {
            clearTimeout(timer);
            observerRef.current?.disconnect();
            observerRef.current = null;
        };
    }, [enabled, setup]);

    return activeSection;
}

interface NavItemProps {
    item: NavItem;
    activeClass: string;
    isMobile: boolean;
    onClick: () => void;
    label: string;
}

const NavButton: FC<NavItemProps> = ({ item, activeClass, isMobile, onClick, label }) => (
    <button
        key={item.id}
        onClick={onClick}
        className={[
            py-3
            BASE_ITEM_CLASS,
            isMobile ? MOBILE_ITEM_CLASS : "",
            activeClass,
            "bg-transparent border-none cursor-pointer",
        ].join(" ")}
    >
        {label}
    </button>
);

const NavLink: FC<NavItemProps> = ({ item, activeClass, isMobile, onClick, label }) => (
    <Link
        key={item.id}
        to={item.path!}
        onClick={onClick}
        className={[BASE_ITEM_CLASS, isMobile ? MOBILE_ITEM_CLASS : "", activeClass].join(" ")}
    >
        {label}
    </Link>
);

const Navbar: FC = () => {
    const { t, i18n } = useTranslation();
    const location = useLocation();
    const navigate = useNavigate();

    const isHomePage = location.pathname === "/";
    const activeSection = useScrollSpy(SCROLL_SECTIONS, isHomePage);
    const [isMobileMenuOpen, setIsMobileMenuOpen] = useState(false);

    const closeMobileMenu = () => setIsMobileMenuOpen(false);

    useEffect(() => {
        closeMobileMenu();
    }, [location.pathname]);

    useEffect(() => {
        if (!isHomePage) return;
        const hash = location.hash.slice(1);
        if (!hash) return;
        const timer = setTimeout(() => {
            document.getElementById(hash)?.scrollIntoView({ behavior: "smooth", block: "start" });
            window.history.replaceState(null, "", "/");
        }, 50);
        return () => clearTimeout(timer);
    }, [isHomePage, location.hash]);

    const scrollToSection = (sectionId: string) => {
        if (!isHomePage) {
            navigate(`/#${sectionId}`);
            return;
        }
        document.getElementById(sectionId)?.scrollIntoView({ behavior: "smooth", block: "start" });
        window.history.replaceState(null, "", "/");
    };

    const getItemActiveClass = (item: NavItem, isMobile: boolean): string => {
        const activeClass = isMobile ? MOBILE_ACTIVE_CLASS : DESKTOP_ACTIVE_CLASS;
        if (item.type === "link") {
            return location.pathname === item.path ? activeClass : "";
        }
        return isHomePage && activeSection === item.id ? activeClass : "";
    };

    const renderNavItem = (item: NavItem, isMobile: boolean) => {
        const sharedProps: NavItemProps = {
            item,
            isMobile,
            activeClass: getItemActiveClass(item, isMobile),
            label: item.translationKey ? t(item.translationKey) : (item.label ?? ""),
            onClick: () => {
                if (item.type === "scroll") scrollToSection(item.id);
                if (isMobile) closeMobileMenu();
            },
        };
        return item.type === "link" ? <NavLink {...sharedProps} /> : <NavButton {...sharedProps} />;
    };

    const projects = useMemo<Project[]>(
        () =>
            isMobileMenuOpen
                ? ((i18n.getResourceBundle(i18n.language, "projects") as Project[]) ?? [])
                : [],
        [isMobileMenuOpen, i18n]
    );

    return (
        <nav className="fixed top-0 left-0 right-0 z-10 flex justify-between items-center px-4 md:px-8 py-4 bg-accent/80 text-primary shadow-md mb-2">

            {/* Left side - Logo/Name (both mobile and desktop) */}
            <Link
                to="/"
                onClick={closeMobileMenu}
                className={[
                    "font-bold text-xl flex hover:text-primary-dark relative",
                    "after:absolute after:bottom-0 after:left-0 after:bg-primary-dark",
                    "after:h-0.5 after:w-0 hover:after:w-full after:transition-all after:duration-300"
                ].join(" ")}
            >
                Stoica Tielemans
            </Link>

            {/* Right side - Desktop nav items */}
            <ul className="hidden md:flex list-none items-center gap-4">
                {NAV_ITEMS.map((item) => (
                    <li key={item.id}>{renderNavItem(item, false)}</li>
                ))}
            </ul>

            {/* Right side - Mobile hamburger */}
            <button
                onClick={() => setIsMobileMenuOpen((prev) => !prev)}
                className="text-primary focus:outline-none ml-2 md:hidden hover:scale-110 transition-transform duration-300 active:scale-90"
                aria-label={isMobileMenuOpen ? "Close menu" : "Open menu"}
                aria-expanded={isMobileMenuOpen}
            >
                {isMobileMenuOpen ? (
                    <svg xmlns="http://www.w3.org/2000/svg" className="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
                    </svg>
                ) : (
                    <svg xmlns="http://www.w3.org/2000/svg" className="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4 6h16M4 12h16M4 18h16" />
                    </svg>
                )}
            </button>

            {/* Mobile menu drawer */}
            <div
                className={`fixed inset-0 top-16 bg-white z-20 transform transition-transform duration-300 ease-in-out md:hidden ${
                    isMobileMenuOpen ? "translate-x-0" : "translate-x-full"
                }`}
            >
                <div className="flex flex-col p-4 h-full overflow-y-auto">
                    {NAV_ITEMS.map((item) => (
                        <div key={item.id}>{renderNavItem(item, true)}</div>
                    ))}
                    <div className="mt-4">
                        <h2 className="text-lg font-bold text-primary border-b border-gray-200">
                            {renderNavItem(projectNavItem, true)}
                        </h2>
                        <ul className="mt-2">
                            {projects.map((project) => (
                                <li key={project.id}>
                                    <Link
                                        to={`/project/${project.id}`}
                                        onClick={closeMobileMenu}
                                        className="block py-2 px-6 text-primary hover:bg-accent/20 transition-all duration-300 hover:pl-8 hover:shadow-md"
                                    >
                                        {project.title}
                                    </Link>
                                </li>
                            ))}
                        </ul>
                    </div>
                </div>
            </div>
        </nav>
    );
};

export default Navbar;
