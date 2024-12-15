# QR Code Scanner App

## Overview

A simple **QR Code Scanner Application** built in **Flutter**. The app enables users to scan QR codes, view their content, and access a history of previous scans. Designed with light and dark mode themes and permission handling for a seamless user experience.

---

## Features

- **QR Code Scanning**: Automatically starts scanning on app launch, with results displayed in a dialog.
- **Scan History**: Maintains a persistent, timestamped history of scans.
- **Permission Handling**: Requests and manages camera permissions for both Android and iOS.
- **Light and Dark Themes**: Adapts to system settings for a consistent appearance.

---

## Setup Instructions

### Prerequisites

- Flutter SDK installed
- A physical Android or iOS device (camera functionality may not work on simulators)
- Required Flutter dependencies:
    
    ```yaml
    dependencies:
      flutter:
        sdk: flutter
      barcode_scan2: ^4.3.3
      shared_preferences: ^2.1.0
      intl: ^0.18.0
      permission_handler: ^10.2.0
    
    ```
    

### Steps

1. **Clone the Repository**:
    
    ```bash
    git clone <repository-url>
    cd <project-folder>
    
    ```
    
2. **Install Dependencies**:
    
    ```bash
    flutter pub get
    
    ```
    
3. **Configure iOS Permissions**:
    - Add the following to `ios/Runner/Info.plist`:
        
        ```xml
        <key>NSCameraUsageDescription</key>
        <string>Camera access is needed to scan QR codes.</string>
        
        ```
        
4. **Run the App**:
    
    ```bash
    flutter run
    
    ```
    

---

## Project Structure

```
lib/
├── main.dart                              # Entry point of the application
├── domain/
│   ├── entities/
│   │   └── scan_entity.dart              # Entity for scanned QR codes
│   ├── repositories/
│   │   └── scan_repository.dart          # Abstract repository interface
├── data/
│   ├── repositories/
│   │   └── scan_repository_impl.dart     # Repository implementation
├── presentation/
│   ├── screens/
│   │   └── scan_history_screen.dart      # Screen for scan history
│   ├── widgets/
│   │   ├── history_list_widget.dart      # Widget to display scan history
│   │   └── scan_result_dialog.dart       # Dialog for scan results
├── utils/
│   ├── app_themes.dart                   # Light and dark themes
│   ├── permission_handler.dart           # Handles camera permissions

```

---

## Improvements and Extensions

- **State Management**: Introduce state management (e.g., Provider or Riverpod) for scalability.
- **Search and Filter**: Add functionality to search or filter scan history.
- **Export History**: Enable exporting scan history to text or CSV files.
- **Testing**: Add unit and widget tests for reliability.

---

## Conclusion

This app demonstrates effective handling of camera permissions, persistent data storage, and a modular architecture. It serves as a strong foundation for further enhancements and features.

Feel free to contribute or suggest improvements! 🚀
