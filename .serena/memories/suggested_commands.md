# Suggested Commands for Development

## Flutter Commands

### Basic Development
```bash
flutter run                    # Run the app in debug mode
flutter run --release         # Run in release mode
flutter run -d chrome         # Run on Chrome for web development
flutter run -d macos          # Run on macOS desktop
```

### Code Quality
```bash
flutter analyze               # Static analysis of Dart code
flutter test                  # Run unit and widget tests
flutter pub get               # Install/update dependencies
flutter pub upgrade           # Upgrade all dependencies
flutter clean                 # Clean build cache
flutter pub deps              # Show dependency tree
```

### Build Commands
```bash
flutter build apk            # Build Android APK
flutter build ios            # Build iOS app
flutter build web            # Build web app
flutter build macos          # Build macOS app
```

### Development Tools
```bash
flutter doctor               # Check Flutter environment
flutter devices             # List available devices/emulators
flutter emulators            # List available emulators
flutter logs                 # Show device logs
```

## Git Commands (macOS)
```bash
git status                   # Check repository status
git add .                    # Stage all changes
git commit -m "message"      # Commit changes
git push                     # Push to remote repository
git pull                     # Pull latest changes
```

## System Commands (macOS/Darwin)
```bash
ls -la                       # List files with details
cd [directory]               # Change directory
grep -r "pattern" lib/       # Search for text in files
find lib/ -name "*.dart"     # Find Dart files
open .                       # Open current directory in Finder
```

## Package Management
```bash
flutter pub add [package]    # Add new dependency
flutter pub remove [package] # Remove dependency
flutter pub outdated         # Check for outdated packages
```