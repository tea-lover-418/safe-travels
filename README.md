> [!IMPORTANT]
> Safe travels is still under construction. 

# Safe Travels

Safe Travels is a privacy oriented travel platform for self hosting.

## Stack

This whole repo is setup using Turborepo.

- Web: Vercel
- App: Android

- API: Vercel functions
- Database: MongoDB
- Object storage: ???

## Development

### Web

`npm i` & `npm run dev` should take care of everything.

### Android

Make sure you are also running web, as this contains the API.

### Apps and Packages

- `apps/docs`: a future docusaurus app
- `apps/web`: another [Next.js](https://nextjs.org/) app
- `apps/android`: an android app, largely vibe coded

- `packages/ui`: a stub React component library shared by both `web` and `docs` applications
- `packages/eslint-config`: `eslint` configurations (includes `eslint-config-next` and `eslint-config-prettier`)
- `packages/typescript-config`: `tsconfig.json`s used throughout the monorepo
