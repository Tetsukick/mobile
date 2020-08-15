# Splits.io Mobile App
This is a work-in-progress mobile (Android/iOS) app for Splits.io. It is in
an early-alpha state.

The published Android app is on the [Google Play Store][android]. The iOS app
is not yet published.

[android]: https://play.google.com/store/apps/details?id=io.splits

## Getting Started

### Prerequisites
- [Flutter][flutter] 

[flutter]: https://flutter.dev/docs/get-started/install

### Overview
Flutter is a platform-agnostic mobile framework by Google that uses the Dart
language for both logic and layout. It's very similar to modern JavaScript
and easy to get spun up on.

The code base is shared between Android and iOS.

You need Android Studio to develop in Flutter, but you don't need to actually
use it -- only have it installed. I recommend Visual Studio Code as a very
good and newbie-friendly Flutter development environment.

### Release pipeline

#### CI/CD
Every push, the latest commit will be built by [YourBase][yourbase], uploaded
to the Google Play Console, reviewed by Google, then released to the
open beta track (opt in from: [web][beta-web] / [Android][beta-android]).
The Google review process may take several hours, but no manual action is
required to release it into beta afterwards.

[yourbase]: https://yourbase.io/
[beta-web]: https://play.google.com/apps/testing/io.splits
[beta-android]: https://play.google.com/store/apps/details?id=io.splits

#### Automating version increases
_You don't need to read this section unless you are contributing frequently!_

Without a different build number (e.g. `1234`) and version (e.g. `1.1.9`) for
each build, CI will not be able to release new builds automatically.

Therefore we use [`pubumgo`][pubumgo] to automate increasing these numbers
every commit. The build number and the patch component of the build name are
both incremented by 1 every commit.

If a build is worthy of a minor or major version bump you can change the values
directly in `pubspec.yaml`; they take the format `version+build`, e.g.
`1.1.9+1234`.

Otherwise, we automate 1 patch bump per commit for simplicity. This automation
needs to be set up on each developer's machine individually.

To set it up on a new machine, follow these steps:

1. Install the build bumper:
   ```sh
   go get -u gitlab.com/ad-on-is/pubumgo
   ```
2. If you are using zsh, run this to add the Git pre-commit hook:
   ```sh
   # zsh only:
   echo "#\!/bin/bash\n\npubumgo patch -b\ngit add pubspec.yaml" > .git/hooks/pre-commit
   ```
   If you are not using zsh, make the file manually and fill it out according
   to `pubumgo`'s README.
3. Done! Every Git commit you perform will also automatically bump the build
   and version.

[pubumgo]: https://gitlab.com/ad-on-is/pubumgo
