# Task Manager

Task Manager is a cross-platform Flutter application that helps you create and manage projects and tasks.
It follows **Clean Architecture** and **GetX** for state management to keep the codebase scalable and testable.

The app consumes the REST API provided by the [nest-ingenius-test](https://github.com/Alex-diaz00/nest-ingenius-test) repository. Make sure you have the API running locally or have access to a deployed instance before using the app.

## Features

* Authentication (sign-up, sign-in, sign-out)
* Create, read, update and delete (CRUD) projects
* Manage project members
* Create and track tasks within projects
* Responsive UI for Android, iOS, Web and Desktop (Flutter 3)
* Offline-first: network checker and failure handling
* Secure storage for credentials (flutter_secure_storage)
* Beautiful SVG icons & custom fonts

## Project Structure

The project uses the Clean Architecture guidelines:

```text
lib/
  core/        # cross-cutting concerns (network, errors, middleware, widgets)
  features/
    auth/      # feature modules with data/domain/presentation layers
    project/
    task/
  routes/       # application routing powered by GetX
  main.dart     # app entry point & dependency injection
```

Each feature is split into:

* `data` – remote datasources, models and repositories
* `domain` – entities, repository contracts and use-cases
* `presentation` – GetX controllers, pages and widgets

## Getting Started

### Prerequisites

1. [Flutter](https://docs.flutter.dev/get-started/install) >= 3.7.0 (stable channel recommended)
2. Dart SDK >= 3.7.2
3. A running instance of the [nest-ingenius-test API](https://github.com/Alex-diaz00/nest-ingenius-test)

### Clone the repository

```bash
git clone https://github.com/your_username/task_manager.git
cd task_manager
```

### Install dependencies

```bash
flutter pub get
```

### Configure environment variables

Create a `.env` file at the project root:

```env
API_BASE_URL=http://localhost:3000
```

Adjust the URL to match where your API instance is running.

### Run the application

```bash
# Android / iOS / Web
flutter run

# Specify a device
flutter run -d chrome          # web
flutter run -d emulator-5554   # android emulator
```

## Running the Backend Locally

Follow the instructions in the [nest-ingenius-test README](https://github.com/Alex-diaz00/nest-ingenius-test#readme):

```bash
git clone https://github.com/Alex-diaz00/nest-ingenius-test.git
cd nest-ingenius-test
pnpm install
pnpm start:dev
```

By default the API listens on `http://localhost:3000`.

## Build & Release

```bash
# APK
flutter build apk --release

# iOS
flutter build ios --release

# Web
flutter build web --release
```

## Testing

```bash
flutter test
```

## Useful Commands

* `dart run build_runner build` – generate files (if you add code generation in future)
* `flutter pub run flutter_launcher_icons` – regenerate app icons

## Contributing

1. Fork the repository
2. Create your feature branch: `git checkout -b feature/my-feature`
3. Commit your changes: `git commit -am 'Add my feature'`
4. Push to the branch: `git push origin feature/my-feature`
5. Open a Pull Request

## License

Distributed under the MIT License. See `LICENSE` for more information.
