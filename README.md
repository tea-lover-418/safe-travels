> [!IMPORTANT]
> Safe Travels is still under construction.

# Safe Travels

Safe Travels is a privacy oriented travel platform for self hosting.

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

Create a `.env` in `apps/web` based on the `.env.example`.

### Web

`npm i` & `npm run dev` should take care of everything.

### Android

Make sure you are also running web, as this contains the API.

### Apps and Packages

- `apps/docs`: (under construction) a future docusaurus app.
- `apps/quick-setup`: (under construction) a cli tool that can set up your database and hosting.
- `apps/web`: the web app that visualizes your journey.
- `apps/android`: the android app for personal tracking and updating your feed.

- `packages/models`: Shared API models for all apps.
- `packages/eslint-config`: eslint configurations
- `packages/typescript-config`: tsconfig's used throughout the monorepo.
