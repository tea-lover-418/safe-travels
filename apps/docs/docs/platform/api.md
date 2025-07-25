---
sidebar_position: 1
---

# API

The API is hosted as part of the web application, with base url `https://yourwebsite.com/api`.

## Routes

### POST - `/api/location`:

Insert a new location as part of a trip. Apps will call this endpoint in the background to track your progress.

#### Headers

`Authorization: bearer token`

#### Body

```json
{
  "latitude": 52.402515,
  "longitude": 4.71076,
  "timestamp": "2025-06-13T07:19:16.820Z" // optional, the api will create one when empty
}
```

#### Response

- `200` Location created successfully
- `400` Missing latitude or longitude
- `401` Unauthorized
- `403` Too close to home address
- `500` Server error

---

### POST - `/api/feed`

Post a new update or activity. Users create feed updates in the apps, and submitting will call this endpoint.

#### Headers

`Authorization: bearer token`

#### Body

```json
{
  "type": "FeedImage", // "currently the only supported type"
  "images": [
    "https://example.com/image1.jpg",
    "https://example.com/image2.jpg"
  ], // optional
  "title": "New Update",
  "decription": "A brief description of the update", // optional
  "location": {
    "latitude": 52.402515,
    "longitude": 4.71076
  } // optional
}
```

#### Response

- `200` Feed item created successfully
- `400` Missing type or title
- `401` Unauthorized
- `500` Server error

---

### POST - `/api/get-bucket-url`

Retrieve a bucket URL for uploading images

#### Headers

`Authorization: bearer token`

#### Body

```json
{
  "filename": "example.jpg"
}
```

#### Response

- `200` + string response - Bucket URL to upload image
- `400` Missing filename
- `401` Unauthorized
- `500` Server error
