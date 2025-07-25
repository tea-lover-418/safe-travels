# Roadmap

This roadmap is subject to many changes. The purpose is to reflect the intentions of the platform.

# MVP

The intent behind these features is to make the platform useable for general users.

- iOS app with basic support
- Android refactor of config and globals
  - user feedback
  - dry-run test
  - api token in a password field
- Android refactor of feed form
  - user feedback
  - easier location overriding

### Setup

- Setup cli script in apps/setup

### Config

- Add home location in app config
- Add config as database model
- Password protection of user facing website

# Beyond

### Offline tracking

- When disconnected your app will no longer update your location. We can solve this by storing your location in a local cache, and pop this on the next worker that does have internet connection.
- Already supported in API.

### Multi-journey

- Right now safe travels supports one journey only. If you go
  It is a big change to support multi-journeys, but it is the future for the platform.

### Tracking improvements

- android battery permissions
