import { defineConfig, fontProviders } from 'astro/config';
import sitemap from '@astrojs/sitemap';
import tailwindcss from '@tailwindcss/vite';

export default defineConfig({
  site: 'https://stevensinatra.id',
  fonts: [
    {
      provider: fontProviders.google(),
      name: 'Rubik',
      cssVariable: '--font-rubik',
      weights: [400, 500],
      styles: ['normal', 'italic'],
      subsets: ['latin'],
      fallbacks: ['system-ui', 'sans-serif'],
    },
  ],
  integrations: [sitemap()],
  markdown: {
    syntaxHighlight: 'prism',
  },
  security: {
    csp: {
      directives: [
        "default-src 'self'",
        "img-src 'self' data:",
        "connect-src 'self' https://*.usefathom.com",
      ],
      scriptDirective: {
        resources: ["'self'", 'https://cdn.usefathom.com'],
      },
    },
  },
  vite: {
    plugins: [tailwindcss()],
  },
});
