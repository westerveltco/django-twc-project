const defaultColors = require("tailwindcss/colors");
const defaultTheme = require("tailwindcss/defaultTheme");
const plugin = require("tailwindcss/plugin");

const westerveltColors = {
  "corp-green": {
    DEFAULT: "#1A5632",
    50: "#7ED8A2",
    100: "#6AD294",
    200: "#43C677",
    300: "#32A460",
    400: "#267D49",
    500: "#1A5632",
    600: "#164A2B",
    700: "#133F24",
    800: "#0F331E",
    900: "#0C2717",
  },
  "wes-blue": {
    DEFAULT: "#34657F",
    white: "#F2F9FC",
    light: "#D7EFFC",
    dark: "#0F374D",
    black: "#081C26",
    50: "#EFF5F8",
    100: "#D0E2EC",
    200: "#A1C5D9",
    300: "#72A9C5",
    400: "#4688AA",
    500: "#34657F",
    600: "#2B5469",
    700: "#224254",
    800: "#19313E",
    900: "#102028",
  },
  "forest-resources-green": {
    DEFAULT: "#638C3D",
    50: "#B4D298",
    100: "#ABCD8B",
    200: "#99C272",
    300: "#86B75A",
    400: "#75A548",
    500: "#638C3D",
    600: "#547734",
    700: "#45612A",
    800: "#364C21",
    900: "#273718",
  },
  "wood-products-brown": {
    DEFAULT: "#AF7C58",
    50: "#E3D1C5",
    100: "#DDC8B9",
    200: "#D2B5A0",
    300: "#C6A288",
    400: "#BB8F70",
    500: "#AF7C58",
    600: "#936646",
    700: "#745037",
    800: "#553B29",
    900: "#36251A",
  },
  "lumber-green": {
    DEFAULT: "#006937",
    50: "#00DC73",
    100: "#00CF6C",
    200: "#00B55F",
    300: "#009C52",
    400: "#008344",
    500: "#006937",
    600: "#005A2F",
    700: "#004A27",
    800: "#003B1F",
    900: "#002C17",
  },
  "westervelt-yellow": {
    DEFAULT: "#E7DD75",
    50: "#F8F5D7",
    100: "#F6F2CC",
    200: "#F2EDB6",
    300: "#EFE8A0",
    400: "#EBE28B",
    500: "#E7DD75",
    600: "#DFD24A",
    700: "#D2C224",
    800: "#A69A1D",
    900: "#7B7215",
  },
  "westervelt-light-blue": {
    DEFAULT: "#CFE0D8",
    50: "#F9FBFA",
    100: "#F4F8F6",
    200: "#EBF2EF",
    300: "#E2ECE7",
    400: "#D8E6E0",
    500: "#CFE0D8",
    600: "#C0D6CB",
    700: "#B0CCBF",
    800: "#A1C2B2",
    900: "#91B8A6",
  },
  "westervelt-tan": {
    DEFAULT: "#DEC9A2",
    50: "#FCFAF7",
    100: "#F9F5ED",
    200: "#F2EADA",
    300: "#EBDFC8",
    400: "#E5D4B5",
    500: "#DEC9A2",
    600: "#D2B580",
    700: "#C6A25E",
    800: "#B68D41",
    900: "#947334",
  },
};

// https://noumenal.es/notes/tailwind/django-integration/
// Resolve path to directory containing manage.py file.
// This is the root of the project.
// Then assumed layout of <main-app>/static/css/tailwind.config.js, so up 3 levels.
// Adjust for your needs.
const path = require("path");
const projectRoot = path.resolve(__dirname);

const { spawnSync } = require("child_process");

// Function to execute the Django management command and capture its output
const getTemplateFiles = () => {
  const command = "python"; // Requires virtualenv to be activated.
  const args = ["manage.py", "tailwind", "list_templates"]; // Requires cwd to be set.
  const options = { cwd: projectRoot };
  const result = spawnSync(command, args, options);

  if (result.error) {
    throw result.error;
  }

  if (result.status !== 0) {
    console.log(result.stdout.toString(), result.stderr.toString());
    throw new Error(
      `Django management command exited with code ${result.status}`
    );
  }

  return result.stdout
    .toString()
    .split("\n")
    .map((file) => file.trim())
    .filter(function (e) {
      return e;
    });
};

/** @type {import('tailwindcss').Config} */
export default {
  content: [].concat(getTemplateFiles()),
  safelist: [
    "btn",
    "btn-primary",
    "btn-secondary",
    "btn-destructive",
    "btn-outline",
    "btn-ghost",
    "btn-link",
  ],
  theme: {
    extend: {
      colors: {
        ...westerveltColors,
        primary: westerveltColors["corp-green"],
        secondary: defaultColors.gray,
        tertiary: defaultColors.green,
        aspect: defaultColors.orange,
        danger: defaultColors.red,
      },
      fontFamily: {
        sans: ["Inter var", ...defaultTheme.fontFamily.sans],
      },
    },
  },
  plugins: [
    require("@tailwindcss/aspect-ratio"),
    require("@tailwindcss/container-queries"),
    require("@tailwindcss/forms"),
    require("tailwindcss-animate"),
    require("tailwindcss-debug-screens"),
    plugin(function ({ addVariant }) {
      addVariant("htmx-settling", ["&.htmx-settling", ".htmx-settling &"]);
      addVariant("htmx-request", ["&.htmx-request", ".htmx-request &"]);
      addVariant("htmx-swapping", ["&.htmx-swapping", ".htmx-swapping &"]);
      addVariant("htmx-added", ["&.htmx-added", ".htmx-added &"]);
    }),
    plugin(function ({ addComponents, theme }) {
      addComponents({
        ".btn": {
          display: "inline-flex",
          alignItems: "center",
          borderRadius: theme("borderRadius.md"),
          padding: `${theme("spacing.2")} ${theme("spacing.3")}`,
          fontSize: theme("fontSize.sm"),
          lineHeight: theme("lineHeight.5"),
          fontWeight: theme("fontWeight.semibold"),
          "&:focus-visible": {
            outlineOffset: "2px",
            outlineStyle: "solid",
            outlineWidth: "2px",
          },
        },
        ".btn-primary": {
          backgroundColor: theme("colors.primary.600"),
          color: theme("colors.white"),
          boxShadow: theme("boxShadow.sm"),
          "&:hover": {
            backgroundColor: theme("colors.primary.700"),
          },
          "&:focus-visible": {
            outlineColor: theme("colors.primary.600"),
          },
        },
        ".btn-secondary": {
          backgroundColor: theme("colors.secondary.200"),
          color: theme("colors.secondary.800"),
          boxShadow: theme("boxShadow.sm"),
          "&:hover": {
            backgroundColor: theme("colors.secondary.300"),
          },
          "&:focus-visible": {
            outlineColor: theme("colors.secondary.400"),
          },
        },
        ".btn-destructive": {
          backgroundColor: theme("colors.danger.600"),
          color: theme("colors.white"),
          boxShadow: theme("boxShadow.sm"),
          "&:hover": {
            backgroundColor: theme("colors.danger.700"),
          },
          "&:focus-visible": {
            outlineColor: theme("colors.danger.600"),
          },
        },
        ".btn-outline": {
          border: `1px solid ${theme("colors.gray.300")}`,
          color: theme("colors.gray.800"),
          boxShadow: theme("boxShadow.sm"),
          "&:hover": {
            backgroundColor: theme("colors.gray.200"),
          },
          "&:focus-visible": {
            outlineColor: theme("colors.gray.400"),
          },
        },
        ".btn-ghost": {
          "&:hover": {
            backgroundColor: theme("colors.gray.200"),
          },
        },
        ".btn-link": {
          color: theme("colors.primary.500"),
          textUnderlineOffset: "4px",
          "&:hover": {
            textDecoration: "underline",
          },
        },
      });
    }),
  ],
};
