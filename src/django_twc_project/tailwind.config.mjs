const { getTemplateFiles } = require("@django-twc-ui/tailwind/tailwind.config");

/** @type {import('tailwindcss').Config} */
export default {
  presets: [require("@django-twc-ui/tailwind/tailwind.config")],
  content: [].concat(getTemplateFiles()),
};
