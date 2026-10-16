# Changelog

All notable changes to this project are documented in this file.

Each release needs an entry `## [<version>] - <YYYY-MM-DD>`, where `<version>` is the
`version` from `pubspec.yaml` (e.g. `1.2.3`). The release workflow fails if the respective
entry for the to-be-released version is missing. Everything up to the next `## ` heading
becomes the release notes on GitHub and the "What's new" text in AltStore.

## [0.2.2] - 2026-10-08

- Added app version to settings screen.
- Otherwise mostly maintenance.

## [0.2.1] - 2026-04-21

Added possibility to pick upload location (queue or collector) when uploading dlc files.
Note that uploading dlc files now requires a pyLoad version of 0.5.0b3.dev98 or newer.

## [0.2.0] - 2026-03-26

**Note: Breaking change**

With the introduction of API keys in pyLoad, this version clears all configured servers
from the app and requires you to re-add them with an API key instead of username & password
authentication.
After updating pyLoad to the most recent version, you can create an API key under:
**Settings** → **Users** → **Actions** → **Manage API Keys**

