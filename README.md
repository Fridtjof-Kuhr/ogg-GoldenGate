# GoldenGate Monitoring App

Ein Flutter-Frontend zur Überwachung von Oracle GoldenGate-Instanzen.

## 🔍 Funktionen

- Verbindungsverwaltung mit Hive (lokale Speicherung)
- Übersicht und Monitoring von:
  - Extract-Prozessen
  - Replicat-Prozessen
  - Distribution Paths
- Integration mit REST-APIs (Basic Auth)
- Dynamische Darstellung von Einheiten pro Verbindung

## 🧱 Technologien

- Flutter & Dart
- Hive für lokale Datenpersistenz
- HTTP für API-Kommunikation
- Modularer Aufbau mit Widgets und Services

## 📦 Setup

```bash
flutter pub get
flutter packages pub run build_runner build --delete-conflicting-outputs
