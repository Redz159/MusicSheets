# MusicSheets

A sheet music library for tablets, built with Flutter. Import PDFs, organise them into folders and setlists, annotate them, play along with a metronome or recordings, and optionally fetch song metadata from MusicBrainz.

Runs on Android and on iPadOS 15 and above (iPhone builds too, but iPad is the focus).

## Installing on an iPad

The app is not on the App Store. The release IPA is unsigned on purpose, so you either re-sign it yourself (Option A) or build it from source (Option B).

### Requirements

- iPad running **iPadOS 15 or later**
- A Mac or Windows PC to install from
- A free Apple ID is enough. Apps signed with a free Apple ID **expire after 7 days** and have to be re-signed; a paid Apple Developer account lasts a year.

### Step 0: Enable Developer Mode (once per iPad)

1. Connect the iPad to your computer with a cable and trust the computer when asked.
2. On the iPad open **Settings → Privacy & Security → Developer Mode**, switch it on and restart.
   (The entry only appears after you have connected the iPad to a Mac with Xcode, or started a sideloading tool once.)
3. After the restart, confirm **Turn On**.

### Option A: Install the release IPA with AltStore or Sideloadly

1. Download `MusicSheets.ipa` from the latest [GitHub release](https://github.com/Redz159/MusicSheets/releases).
2. Install one of these tools on your computer:
   - [AltStore](https://altstore.io): installs the app and can refresh it automatically over Wi-Fi while AltServer is running.
   - [Sideloadly](https://sideloadly.io): simple drag and drop, but you refresh manually.
3. Connect the iPad, open the tool, sign in with your Apple ID and install `MusicSheets.ipa`.
4. On the iPad open **Settings → General → VPN & Device Management**, select your Apple ID under *Developer App* and tap **Trust**.
5. Start **MusicSheets**.

When the 7 days are up the app stops launching. Re-install or refresh it with the same tool. Your library is kept as long as you refresh the app instead of deleting it first.

### Option B: Build and install from source

You need a Mac with Xcode and an iOS Simulator runtime, [Flutter](https://docs.flutter.dev/get-started/install) (the release workflow uses 3.47.7) and CocoaPods.

```sh
git clone https://github.com/Redz159/MusicSheets.git
cd MusicSheets
flutter pub get
open ios/Runner.xcworkspace
```

In Xcode:

1. Select the **Runner** project, then the **Runner** target, then **Signing & Capabilities**.
2. Tick *Automatically manage signing* and pick your team (your Apple ID works).
3. Change the **Bundle Identifier** to something unique, for example `com.yourname.musicsheets`. The default one is already taken.
4. Select your iPad as the run destination and press **Run**.

Or, once signing is set up, from the terminal:

```sh
flutter devices                    # find the iPad's id
flutter run --release -d <id>
```

Use `--release`: debug builds on iOS can only be launched from Xcode or Flutter tooling, not from the home screen.

### Troubleshooting

- **"Untrusted Developer" when opening the app:** do step 4 of Option A.
- **Developer Mode is missing in Settings:** connect the iPad to the computer and start Xcode or the sideloading tool first, then check again.
- **App no longer opens after about a week:** the free signing certificate expired. Re-sign it as described above.
- **Xcode says the bundle identifier is not available:** use your own identifier (Option B, step 3).

## Using the app on iPad

- Import PDFs with **Import PDFs** in the library. Files are copied into the app, so the originals can be removed afterwards.
- The wide layout with a navigation rail is used automatically on iPad. It also adapts when the window is resized.
- Library data (database, PDFs, recordings) lives inside the app's own storage. Use **Settings** to create and restore backups. Deleting the app deletes the library, so make a backup first.
- Metadata lookups are optional (Settings) and use MusicBrainz. On iOS they run while the app is open; there are no background lookups on iOS.

## Development

```sh
flutter pub get
flutter analyze
flutter test
flutter run
```

Releases are built by [.github/workflows/release.yml](.github/workflows/release.yml) when a `v*` tag is pushed. It produces the signed Android APK and the unsigned iOS IPA. Without the `ANDROID_KEYSTORE_BASE64` secret the APK is signed with the debug key.
