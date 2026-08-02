/**
 * Catppuccin Mocha Color Palette
 */
const colors = {
  rosewater: "#f5e0dc",
  flamingo: "#f2cdcd",
  pink: "#f5c2e7",
  mauve: "#cba6f7",
  red: "#f38ba8",
  maroon: "#eba0ac",
  peach: "#fab387",
  yellow: "#f9e2af",
  green: "#a6e3a1",
  teal: "#94e2d5",
  sky: "#89dceb",
  sapphire: "#74c7ec",
  blue: "#89b4fa",
  lavender: "#b4befe",
  text: "#cdd6f4",
  subtext1: "#bac2de",
  subtext0: "#a6adc8",
  overlay2: "#9399b2",
  overlay1: "#7f849c",
  overlay0: "#6c7086",
  surface2: "#585b70",
  surface1: "#45475a",
  surface0: "#313244",
  base: "#1e1e2e",
  mantle: "#181825",
  crust: "#11111b"
};

const bar = {
	height: 20,
	itemSpacing: 6,             // gap between items within a bar section
	moduleBorderWidth: 2,       // border thickness on bar module boxes and their popups
	popupPadding: 8,            // inner padding for popup/tooltip content
	popupIdleUnload: 15 * 60 * 1000, // unload a lazy-loaded popup after this long unused
}

const animation = {
	fast: 100,   // e.g. menu item hover
	normal: 150, // e.g. workspace indicator hover
}

const font = {
	fontFamily: "JetBrainsMono Nerd Font",
	fontSize: 10,
	sizes: {
		xs: 8,          // fine print, e.g. year-grid day numbers
		sm: 9,           // secondary/fine labels, e.g. weekday initials, workspace numbers
		base: 10,        // default body text
		md: 11,          // secondary emphasis, e.g. weekday labels, month names
		label: 12,       // bar module text and menu items
		heading: 14,     // popup section headers
		tooltip: 15,     // tooltip / popup body text
		title: 16,       // large title text, e.g. year number
		display: 40,     // large full-screen icons, e.g. power menu buttons
	},
}
