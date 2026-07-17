# Bangunin

Bangunin is a location-based iOS alarm application designed specifically for 9-to-5 workers who commutes daily.


## Core Features
### Active Alarm Card
A card that keeps commuters informed with their current active alarm, real-time estimated time remaining until their destination, and quick access to stop the alarm.

### Live Activity
A live activity that lets commuters monitor their journey at a glance with the destination, remaining time, progress bar, and quick alarm controls.

### Apple Watch Companion
A companion app that displays the active alarm, delivers sound and haptic alerts upon arrival, and lets commuters stop the alarm directly from their wrist.


## Tech Stack & Architecture
- **UI Framework:** SwiftUI
- **Architecture:** MVVM
- **Location Services:** CoreLocation for geofencing and region Monitoring
- **Notifications:** UserNotifications
- **Connection between WatchOS** AppIntents for passing liveactivity from iOS to WatchOS

## Installation
Clone the repository: 
   ```bash
   git clone https://github.com/kyoronginus/Bangunin.git
  ```
Open the project in Xcode:
  ```bash
  cd Bangunin
  open Bangunin.xcodeproj
  ```
Build and Run:
- Select your target device or simulator in Xcode.
- Press Cmd + R to run the app.
- Note: To test location features on a simulator, you can use Xcode's Location Simulation feature (Features -> Location). However, it's recommended to use a physical device for the best experience.

## Permissions
To function correctly, Bangunin requires permissions below :
- Location Access
- Standard Notifications
- AlarmKit Authorization
- Live Activities

## Contributing
Contributions, issues, or any feature requests are welcome. Feel free to check the issues page if you want to contribute.

## License
This project is licensed under the MIT License. 
