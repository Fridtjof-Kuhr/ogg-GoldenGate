# GoldenGate Monitoring App

A Flutter frontend for monitoring Oracle GoldenGate instances.

## 🔍 Functions

- Connection management with Hive (local storage)
- Overview and monitoring of:
- Extract processes
- Replicat processes
- Distribution paths
- Integration with REST APIs (Basic Auth)
- Dynamic representation of units per connection

## 🧱 Technology

- Flutter & Dart
- Hive for local data persistence
- HTTP for API communication
- Modular structure with widgets and services

## 📦 Setup

```bash
flutter pub get
flutter packages pub run build_runner build --delete-conflicting-outputs
