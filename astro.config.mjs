// @ts-check
import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';
import starlightLinksValidator from 'starlight-links-validator';
import remarkHeadingId from 'remark-heading-id';
import mermaid from 'astro-mermaid';

// https://astro.build/config
export default defineConfig({
  site: 'https://docs.kumbuka.ai',
  // Allow explicit `## Heading {#id}` anchors so cross-locale links can use a
  // single stable (English) anchor id regardless of the translated heading text.
  markdown: {
    remarkPlugins: [[remarkHeadingId, { defaults: false }]],
  },
  integrations: [
    // Render ```mermaid fences as diagrams (client-side, theme-aware). Must run
    // before Starlight so the blocks are transformed ahead of code highlighting.
    mermaid({ theme: 'neutral', autoTheme: true }),
    starlight({
      plugins: [starlightLinksValidator()],
      title: 'kumbuka',
      description:
        'Geteiltes, dauerhaftes Gedächtnis für KI-Assistenten in der Teamarbeit — bereitgestellt über MCP, kuratiert über eine Admin-Konsole, mit einem privaten Bereich, der privat bleibt.',
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
      // German is the root locale (served at /), English under /en/.
      defaultLocale: 'root',
      locales: {
        root: { label: 'Deutsch', lang: 'de' },
        en: { label: 'English', lang: 'en' },
      },
      // Untranslated pages fall back to the German (root) version automatically.
      sidebar: [
        {
          label: 'Einstieg',
          translations: { en: 'Get started' },
          items: [
            { slug: 'get-started/overview' },
            { slug: 'get-started/quickstart' },
            { slug: 'get-started/connecting-an-assistant' },
          ],
        },
        {
          label: 'Konzepte',
          translations: { en: 'Concepts' },
          items: [
            { slug: 'concepts/data-model' },
            { slug: 'concepts/editions' },
          ],
        },
        {
          label: 'Referenz',
          translations: { en: 'Reference' },
          items: [
            { slug: 'reference/mcp-tools' },
            { slug: 'reference/configuration' },
          ],
        },
        {
          label: 'Betrieb',
          translations: { en: 'Operations' },
          items: [
            { slug: 'operations/architecture' },
            { slug: 'operations/security' },
          ],
        },
      ],
    }),
  ],
});
