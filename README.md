> [!IMPORTANT]
> Safe Travels is still under construction.

# Safe Travels

Safe Travels is a privacy oriented travel platform for self hosting.

## Features

### Location tracking

Show your current location and travelled route. Updates every ~15 minutes even when the app is not open or in the background.

### Feed

Upload photos and text onto a feed.

## Self hosting

You should be able to host Safe Travels yourself, for free. However it does require some technical knowledge to set up.

Web hosting: [Vercel](https://vercel.com)

- Large free tier
- Automatic static generation & optimization
- Built in analytics

Database: [MongoDB (Atlas)](https://www.mongodb.com/products/platform/atlas-database)

- Large free tier
- Document strucutre allows for a lot of customization
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

- `apps/docs`: a future docusaurus app
- `apps/web`: a [Next.js](https://nextjs.org/) react app and api
- `apps/android`: an android app

- `packages/models`: Shared API models for all apps.
- `packages/eslint-config`: `eslint` configurations (includes `eslint-config-next` and `eslint-config-prettier`)
- `packages/typescript-config`: `tsconfig.json`s used throughout the monorepo
