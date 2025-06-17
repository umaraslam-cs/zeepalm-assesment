# ZeePalm Assessment

# Web Demo GIF

![Web Demo](https://raw.githubusercontent.com/umaraslam-cs/zeepalm-assesment/main/web-demo.gif)

A cross-platform (Web, Android, iOS) Flutter application for video sharing, featuring login, signup, video feed, and video upload functionalities.

**Web Hosting URL:** [https://zeepalm-assesment.web.app](https://zeepalm-assesment.web.app)

## Features

- Firebase Authentication (Email/Password)
- Responsive UI for Web and Mobile
- Video Feed with Like/Save/Download (UI)
- Video Upload (via link)
- Persistent login session
- Logout functionality

## Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- [Firebase CLI](https://firebase.google.com/docs/cli) (for web deployment)
- Dart 3.x

### Setup

1. **Clone the repository:**
   ```bash
   git clone https://github.com/umaraslam-cs/zeepalm-assesment.git
   cd zeepalm_assesment
   ```
2. **Install dependencies:**
   ```bash
   flutter pub get
   ```
3. **Run on Web:**
   ```bash
   flutter run -d chrome
   ```
4. **Run on Mobile/Desktop:**
   ```bash
   flutter run
   ```

### Firebase Setup

Firebase is already configured for this project. If you want to use your own Firebase project, replace the configuration in `lib/main.dart` and add your own `google-services.json` (Android) and `GoogleService-Info.plist` (iOS).

## Project Structure

- `lib/views/screens/` — Main screens (login, signup, video feed, upload)
- `lib/viewmodels/` — State management (Provider)
- `lib/models/` — Data models
- `lib/core/` — Utilities and services
- `lib/routes/` — App routing

## Deployment

To deploy to Firebase Hosting:

```bash
flutter build web
firebase deploy
```

## License

This project is for assessment/demo purposes only.
