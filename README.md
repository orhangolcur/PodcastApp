# Podkes App 🎧

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=flat&logo=Flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-%230175C2.svg?style=flat&logo=dart&logoColor=white)
![BLoC](https://img.shields.io/badge/BLoC-State_Management-blue?style=flat)

Podkes is a modern, feature-rich podcast application built with **Flutter**. It provides an intuitive user interface for discovering, listening to, and managing podcast episodes, fully integrated with a custom .NET Core backend via REST APIs.

## 💡 Motivation & Background

This application was initially developed as a client-side project that successfully secured me an internship. Following that achievement, I expanded the project by developing a complete custom backend (PodcastAPI) and seamlessly integrating this mobile application with it, transforming the app from a UI prototype into a fully functional, production-ready product.

## 🏗️ Architecture & State Management

The application is structured using a feature-based architecture to ensure scalability and ease of maintenance:
* **State Management:** Implemented using **BLoC (Cubit)** to clearly separate business logic from the UI layer.
* **Navigation:** Managed via **GoRouter** for efficient and deep-linkable routing across the app.
* **Network Layer:** A custom `ApiClient` handles all HTTP requests, featuring concurrency locking for token refreshes, global error parsing, and multipart request support.

## ✨ Key Features

* **Full Authentication Flow:** Secure Login, Registration, and Logout features with proper session state management, JWT token persistence, and a robust refresh token mechanism.
* **Dynamic Content Discovery:** Server-side search integration with debounce logic in `DiscoverCubit`, supporting filtering by categories, titles, and trends.
* **Profile Management:** Users can edit their profiles, including uploading profile images via multipart API requests, with localized UI and form validations.
* **Seamless Audio Experience:** Full-screen audio player with controls (play, pause, seek), dynamically fed by backend data.
* **Personalized Library:** Syncs users' favorite podcasts and listening history directly with the database.
* **Advanced Error Handling:** Global exception handling that translates backend validation errors directly into user-friendly UI messages.
* **UI/UX Polish:** Dark mode support, responsive layout across devices, input focus management across auth screens, and an app rating popup.

## 🛠️ Tech Stack

| Technology | Purpose |
|------------|---------|
| **Flutter** | Cross-platform UI Framework |
| **Dart** | Programming Language |
| **BLoC/Cubit** | State Management |
| **GoRouter** | Routing and Navigation |
| **http / Dio** | Network Client (API Communication) |

## 📂 Project Structure

```text
lib/
├── core/
│   ├── config/       # API endpoints, theme data, constants
│   ├── network/      # ApiClient, Interceptors, Error Handling
│   ├── router/       # GoRouter configurations
│   └── widgets/      # Reusable UI components
├── features/
│   ├── auth/         # Login, Register, Forgot Password
│   ├── discover/     # Search and category browsing
│   ├── favorites/    # User's saved podcasts
│   ├── now_playing/  # Audio player UI and logic
│   └── profile/      # User profile and edit screens
├── main.dart         # Application entry point
```

## 🚀 Getting Started

### Prerequisites

Before you begin, ensure you have met the following requirements:
* **Flutter SDK:** Ensure you have the latest stable version installed. ([Install Guide](https://flutter.dev/docs/get-started/install))
* **Backend:** This app requires the [PodcastAPI](https://github.com/orhangolcur/PodcastAPI) backend to be running for full functionality.

### Installation & Configuration

1. **Clone the repository:**
   ```bash
   git clone [https://github.com/orhangolcur/PodkesApp.git](https://github.com/orhangolcur/PodkesApp.git)
   ```

2. **Navigate to the project directory:**
   ```bash
   cd PodkesApp
   ```

3. **Install dependencies:**
   ```bash
   flutter pub get
   ```

4. **Configure the API URL:**
   * Open the network configuration file (e.g., in `lib/core/config/`) and set the base URL to match your local or hosted PodcastAPI instance.

5. **Run the application:**
   ```bash
   flutter run
   ```

### Running Tests

To run the available unit and widget tests:
```bash
flutter test
```

---
*This project was developed for educational purposes, portfolio demonstration, and internship evaluation.*
