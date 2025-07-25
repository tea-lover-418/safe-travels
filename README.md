> [!IMPORTANT]
> Safe Travels is not yet ready for general use.
> Feel free to take a professional interest or contribute, but consider the application to be in early beta.

# [Safe Travels](https://safe-travels.app)

Safe Travels is a privacy oriented travel platform for self hosting. Check out the [public demo](https://demo.safe-travels.app), or our [documentation](https:safe-travels.app/docs)

![Hero of SafeTravels](https://raw.githubusercontent.com/tea-lover-418/safe-travels/refs/heads/main/public/github_hero.png)

## Features

### Location tracking

Show your current location and travelled route. Your location is tracked no measurable effect on your battery life, and works while the app is not even running or open in the background.

### Feed

Upload photos and text onto a feed.

### Privacy

Privacy is a cornerstone of SafeTravels. While many platforms collect and sell your data, SafeTravels let's you control the data and will never sell this in any way.

Includes other safety features like:

- Blocking location tracking near your home

## Self hosting

You should be able to host Safe Travels yourself, for free. However it does require some technical knowledge to set up.

Web hosting: [Vercel](https://vercel.com)

- Large free tier
- Automatic static generation & optimization
- Built in analytics

Database: [MongoDB (Atlas)](https://www.mongodb.com/products/platform/atlas-database)

- Large free tier
- Document structure allows for a lot of customization
- Relational databases are for nerds 🤓

Object storage: [Cloudflare R2](https://developers.cloudflare.com/r2/pricing/)

- Great free tier

## Local Development

### Web

Create a `.env` in `apps/web` based on the `.env.example`.
`npm i` & `npm run dev` should take care of everything.

- localhost:3000 will run apps/web
- localhost:3001 will run apps/docs

#### Seeding data

You can run `cd packages/tools && npm run seed` to seed you own environment with test data. To clear it, remove your database.

### Android

Make sure you are also running web, as this contains the API.

### Repo structure

#### Apps

- `apps/docs`: a docusaurus app serving as the main website of safe travels.
- `apps/quick-setup`: (under construction) a cli tool that can set up your database and hosting.
- `apps/web`: the web app that visualizes your journey.
- `apps/android`: the android app for personal tracking and updating your feed.

#### Packages

- `packages/models`: Shared API models for all apps.
- `packages/tools`: Tools to set up and manage a local environment
- `packages/eslint-config`: eslint configurations.
- `packages/typescript-config`: tsconfig's used throughout the monorepo.

### Recommended extensions

#### VSCode

- Prettier - Code formatter - _by Prettier_
- ESLint - _by Microsoft_
