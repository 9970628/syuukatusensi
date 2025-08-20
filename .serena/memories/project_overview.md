# Project Overview

## Purpose
This is a Flutter application called "sennsi_app" (先生app) - an interactive goal tracking and task management app with gamification elements. The app appears to be focused on job hunting (就活/syuukatu) activities with features for:
- Task and goal management
- Calendar integration
- Gaming elements with battle screens
- Profile and status tracking
- Character interactions (sennsi/teacher character)

## Tech Stack
- **Framework**: Flutter 3.35.1 (SDK: ^3.7.2)
- **State Management**: Provider pattern
- **Routing**: go_router (^15.1.3)
- **Gaming Engine**: Flame (^1.11.0) for 2D game components
- **Audio**: flame_audio (^2.1.1) for background music
- **Storage**: shared_preferences (^2.5.3) for local data
- **UI**: Material Design 3
- **Internationalization**: intl (^0.20.2) for Japanese date formatting
- **Development Tools**: device_preview for responsive design testing

## Project Structure
The app follows a feature-based architecture with clear separation of concerns:
- Multi-platform support (iOS, Android, Web, Windows, macOS, Linux)
- Assets include character sprites, backgrounds, and audio files
- Japanese localization support