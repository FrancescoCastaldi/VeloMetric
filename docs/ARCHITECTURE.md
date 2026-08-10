# VeloMetric Web Architecture

## Overview
The VeloMetric website serves as the landing page, progress tracker, and documentation hub for the iOS application.

## Hosting & Deployment
- **Platform**: GitHub Pages
- **Framework**: Plain HTML/CSS (Static) + Tailwind CSS (via CDN)
- **Rationale**: The site is currently a single landing page with a static progress tracker. A full framework like Next.js is overkill for the current MVP phase. GitHub Pages provides free, zero-configuration hosting directly from the repository, which is ideal for this use case.

## CI/CD Pipeline
- **Trigger**: Pushes to the `master` branch.
- **Action**: A GitHub Action (e.g., `jekyll-gh-pages.yml` or static HTML deploy) automatically builds and publishes the contents of the root or `docs/` folder to GitHub Pages. (Currently relying on standard GitHub Pages source folder settings).

## Assets & Design
- **Styling**: Tailwind CSS is used via CDN for rapid prototyping. Custom CSS handles scroll-driven animations and glassmorphism effects.
- **Imagery**: Real app UI representations are built using CSS mockups rather than static images. This allows the landing page to be perfectly crisp on all displays, highly maintainable, and interactive in the future, bypassing the need for asset regeneration when the UI slightly changes.
- **Logo**: A scalable SVG (`logo.svg`) is used for the brand identity, ensuring perfect rendering across all devices.

## Future Migration Path
If the website requires dynamic features (e.g., user login to view web dashboards, blog section, or complex routing):
1. **Target**: Migrate from plain HTML to Next.js or Astro.
2. **Hosting**: Move hosting to Vercel (for Next.js) or keep on GitHub Pages (if using Astro static export).
3. **Process**: Convert `index.html` to components, migrate CSS to module/global stylesheets, and set up a Node.js build pipeline in GitHub Actions.
