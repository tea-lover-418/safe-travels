import { themes as prismThemes } from "prism-react-renderer";
import type { Config } from "@docusaurus/types";
import type * as Preset from "@docusaurus/preset-classic";

// This runs in Node.js - Don't use client-side code here (browser APIs, JSX...)

const config: Config = {
  title: "Safe Travels",
  tagline: "The privacy friendly travel diary, for self hosting",
  favicon: "img/favicon.ico",

  // Set the production url of your site here
  url: "https://safe-travels.app",
  baseUrl: "/",
  organizationName: "safe-travels",
  projectName: "safe-travels",

  onBrokenLinks: "throw",
  onBrokenMarkdownLinks: "warn",

  i18n: {
    defaultLocale: "en",
    locales: ["en"],
  },

  presets: [
    [
      "classic",
      {
        docs: {
          sidebarPath: "./sidebars.ts",
          editUrl: "https://github.com/tea-lover-418/safe-travels/apps/docs",
        },
        blog: {
          showReadingTime: true,
          onInlineTags: "warn",
          onInlineAuthors: "warn",
          onUntruncatedBlogPosts: "warn",
        },
        theme: {
          customCss: "./src/css/custom.css",
        },
      } satisfies Preset.Options,
    ],
  ],

  themeConfig: {
    image: "img/icon-2.png",
    navbar: {
      title: "Safe Travels",
      logo: {
        alt: "Safe Travels Logo",
        src: "img/icon-2.png",
      },
      items: [
        {
          type: "docSidebar",
          sidebarId: "docSidebar",
          position: "left",
          label: "Docs",
        },
        { to: "/blog", label: "Blog", position: "left" },
        {
          href: "https://github.com/tea-lover-418/safe-travels",
          label: "GitHub",
          position: "right",
        },
      ],
    },
  } satisfies Preset.ThemeConfig,
};

export default config;
