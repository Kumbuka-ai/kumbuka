// @ts-check
import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';
import starlightLinksValidator from 'starlight-links-validator';
import remarkHeadingId from 'remark-heading-id';

// https://astro.build/config
export default defineConfig({
  site: 'https://docs.kumbuka.ai',
  // Allow explicit `## Heading {#id}` anchors so cross-locale links can use a
  // single stable (English) anchor id regardless of the translated heading text.
  markdown: {
    remarkPlugins: [[remarkHeadingId, { defaults: false }]],
  },
  integrations: [
    starlight({
      plugins: [starlightLinksValidator()],
      title: 'kumbuka',
      description:
        'Shared, persistent memory for AI assistants working with a team — served over MCP, curated through an admin console, with a private space that stays private.',
      logo: {
        src: './src/assets/kumbuka-mark-orange.svg',
        alt: 'kumbuka',
      },
      favicon: '/favicon.svg',
      customCss: ['./src/styles/brand.css'],
      social: [
        {
          icon: 'github',
          label: 'GitHub',
          href: 'https://github.com/kumbuka-ai/kumbuka',
        },
      ],
      // English is the root locale (served at /), German under /de/.
      defaultLocale: 'root',
      locales: {
        root: { label: 'English', lang: 'en' },
        de: { label: 'Deutsch', lang: 'de' },
      },
      // Untranslated pages fall back to the English version automatically.
      sidebar: [
        {
          label: 'Get started',
          translations: { de: 'Einstieg' },
          items: [
            { slug: 'get-started/overview' },
            { slug: 'get-started/quickstart' },
            { slug: 'get-started/connecting-an-assistant' },
          ],
        },
        {
          label: 'Concepts',
          translations: { de: 'Konzepte' },
          items: [
            { slug: 'concepts/data-model' },
            { slug: 'concepts/editions' },
          ],
        },
        {
          label: 'Reference',
          translations: { de: 'Referenz' },
          items: [
            { slug: 'reference/mcp-tools' },
            { slug: 'reference/configuration' },
          ],
        },
        {
          label: 'Operations',
          translations: { de: 'Betrieb' },
          items: [
            { slug: 'operations/architecture' },
            { slug: 'operations/security' },
          ],
        },
      ],
    }),
  ],
});
