# Web Architecture (Landing Page)

## Overview
While VeloMetric is a native iOS application, an open-source or commercial app requires a promotional landing page. This document outlines the architecture for the `VeloMetric` website hosted on **GitHub Pages**.

## Architecture Decision Record

### Hosting Strategy
- **Platform**: GitHub Pages
- **Why?**: It is free, natively integrated into the repository (via the `gh-pages` branch or `/docs` folder), and perfect for static promotional sites.

### Technical Stack
- **Framework**: Plain HTML5, CSS3 (Tailwind CSS via CDN for rapid MVP styling), and Vanilla JS.
- **Why?**: For a single-page app landing site, a heavy JS framework (like Next.js) is overkill and increases build complexity.

### CI/CD Pipeline
GitHub Actions will be configured to deploy the `/docs` directory to GitHub Pages on every push to `main`.

## Preview Environments
To support PR previews, we recommend integrating **Vercel** alongside GitHub Pages. Vercel automatically deploys every PR, allowing designers to review CSS changes before merging to `main`.

---
> [!NOTE]
> A basic `index.html` scaffold has been placed in `docs/` to kickstart the landing page!
