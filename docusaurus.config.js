module.exports = {
  title: 'Learn mTLS the Hard Way',
  tagline: 'Certificates should be fun!',
  url: 'https://flyinprogrammer.com',
  baseUrl: '/learn-mtls-the-hard-way/',
  favicon: 'img/favicon.ico',
  organizationName: 'flyinprogrammer', // Usually your GitHub org/user name.
  projectName: 'learn-mtls-the-hard-way', // Usually your repo name.
  themeConfig: {
    navbar: {
      title: 'Learn mTLS the Hard Way',
      logo: {
        alt: 'My Site Logo',
        src: 'img/noun_Happy_43931.svg',
      },
      links: [
        {to: 'https://flyinprogrammer.com', label: 'Blog', position: 'left'},
        {to: 'docs/certificates', label: 'Workshop', position: 'left'},
        {
          href: 'https://github.com/flyinprogrammer/learn-mtls-the-hard-way',
          label: 'GitHub',
          position: 'right',
        },
      ],
    },
    footer: {
      style: 'dark',
      links: [
        {
          title: 'Community',
          items: [
            {
              label: 'Github Issues',
              href: 'https://github.com/flyinprogrammer/learn-mtls-the-hard-way/issues',
            },
            {
              label: 'Discord',
              href: 'https://discord.gg/P4Swasv',
            },
          ],
        },
        {
          title: 'Social',
          items: [
            {
              label: 'Blog',
              to: 'https://flyinprogrammer.com',
            },
            {
              label: 'GitHub',
              href: 'https://github.com/flyinprogrammer/learn-mtls-the-hard-way',
            },
            {
              label: 'Twitter',
              href: 'https://twitter.com/flyinprogrammer',
            },
          ],
        },
      ],
      copyright: `Copyright © ${new Date().getFullYear()} HpyDev LLC. Built with Docusaurus.`,
    },
  },
  presets: [
    [
      '@docusaurus/preset-classic',
      {
        docs: {
          sidebarPath: require.resolve('./sidebars.js'),
          editUrl:
            'https://github.com/flyinprogrammer/learn-mtls-the-hard-way/edit/master/',
        },
        theme: {
          customCss: require.resolve('./src/css/custom.css'),
        },
      },
    ],
  ],
};
