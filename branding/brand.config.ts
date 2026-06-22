// wir.social brand on the runtime branding mechanism (replaces branding/constants/*.js).
//
// Authored in TypeScript against @ocelot-social/branding: `defineBranding` type-checks these
// overrides against the branding schema (BrandingOverrides); a wrong key or type FAILS the build.
// Only values that differ from the framework defaults are set (sparse override).
//
// Content layout (one served assets folder, dynamically bound at runtime): assets/ = images,
// html/ = static page HTML per locale, locales/ = i18n overrides (none). Paths are ROOT-relative;
// the multi-brand build namespaces them to /branding/wir/… (collision-free).
//
// NOT here: e-mails (SUPPORT_EMAIL / *_LINK) are ENV → set in the deployment env.
import { defineBranding, type LinkPageKey } from '@ocelot-social/branding'

const HTML_FILE: Partial<Record<LinkPageKey, string>> = {
  organization: 'organization',
  donate: 'donate',
  imprint: 'imprint',
  termsAndConditions: 'terms-and-conditions',
  codeOfConduct: 'code-of-conduct',
  dataPrivacy: 'data-privacy',
  faq: 'faq',
  support: 'support',
}
const html = Object.fromEntries(
  Object.entries(HTML_FILE).map(([page, file]) => [
    page,
    { de: `html/de/${file}.html`, en: `html/en/${file}.html` },
  ]),
)

export default defineBranding({
  about: {
    description: 'wir.social — a community network operated by Webcraft-Media.',
    license: {
      logosReusable: false,
      colorsReusable: false,
      note: 'The wir.social name and logos belong to Webcraft-Media — ask before reuse.',
    },
  },
  metadata: {
    applicationName: 'wir.social',
    applicationShortName: 'wir.social',
    applicationDescription: 'Wir Social Community',
    organizationName: 'Webcraft-Media',
    organizationJurisdiction: 'Deutschland',
  },
  group: {
    // stricter than the default (3): require a longer group description.
    descriptionMinLength: 10,
  },
  links: {
    pages: {
      // organization is an internal page (the framework default points it at ocelot.social).
      organization: { externalLink: null },
      donate: {
        externalLink: {
          url: 'https://webcraft-media.de/donate-for-wir-social.html',
          target: '_blank',
        },
      },
      imprint: { externalLink: { url: 'https://www.webcraft-media.de/#!impressum', target: '_blank' } },
      dataPrivacy: {
        externalLink: { url: 'https://www.webcraft-media.de/#!datenschutz', target: '_blank' },
      },
      support: { externalLink: { url: 'https://www.webcraft-media.de/#!contact', target: '_blank' } },
    },
    // wir.social uses the framework default footer order.
  },
  logos: {
    headerPath: 'assets/logo-horizontal.svg',
    headerMobilePath: 'assets/logo-horizontal.svg',
    signupPath: 'assets/logo-squared.svg',
    welcomePath: 'assets/logo-squared.svg',
    logoutPath: 'assets/logo-squared.svg',
    passwordResetPath: 'assets/logo-squared.svg',
  },
  assets: {
    css: [],
    html,
    favicon: 'assets/favicon.ico',
  },
})
