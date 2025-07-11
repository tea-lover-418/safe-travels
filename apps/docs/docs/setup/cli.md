---
sidebar_position: 0
---

# CLI

Using the CLI is the easiest way to initialize your SafeTravels platform.

## Instructions

1. Create or login with a github account, and [fork the safe-travels repository](https://github.com/tea-lover-418/safe-travels/fork).

2. Clone your forked repository to your local machine.

```bash
  git clone https://github.com/<your-github-id>/safe-travels.git
  cd safe-travels
```

3. Use the setup script by running `npm run setup`. In here you will do the following:

> This is currently under construction

- Create your vercel account if you don't already have one, and initialize the project.
- Create your Atlas MongoDB account, and connect it in Vercel.
- Create your cloudflare account, and connect R2 as a storage bucket in Vercel.
- A file should be created `tbd.json` with all your environment info. Keep this file, you may need it in the future. Do not share the contents to anyone else.

4. Install the Android app

> A .apk will soon be in the releases, but as of now you need to build this yourself.
> Not available in stores.

- Allow all permissions that are requested.
- Fill the configuration tab info with your environment variables.
  They should match `tbd.json` file contents.
