---
sidebar_position: 0
---

# Providers

SafeTravels is a modular architecture that uses a set of interchangeable providers. This is an overview of the recommended providers, but each can be interchanged.

## Hosting -> Vercel

Vercel is the hosting provider that works best with Next.js, in which the API and web application are built. They offer a very large free tier and out of the box analytics. Vercel also has automatic static generation & optimization.

## Database -> MongoDB Atlas

The database is responsible for storing your location history and feed.
MongoDB is a document database, allowing for a lot of optimization without model changes. At Atlas you can host for free on a personal tier.

## Object storage -> Cloudflare R2

The object storage is responsible for storing your photos.
Cloudflare R2 uses the popular S3 API, but with a large free tier.
