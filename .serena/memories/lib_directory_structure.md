# Lib Directory Structure

The `/lib` directory follows a clean architecture pattern with feature-based organization:

## Core Structure

### `/lib/main.dart`
- Application entry point
- Sets up providers, routing, and device preview
- Initializes Japanese date formatting
- Configures Material Design theme

### `/lib/config/`
- `router.dart` - Go Router configuration for navigation
- `themes.dart` - Application theming and styling

### `/lib/core/` (Framework Structure)
- `config/` - Core configuration files
- `constants/` - Application constants
- `utils/` - Utility functions and helpers

### `/lib/features/` (Feature Modules)
Each feature follows a modular structure:

#### `/lib/features/auth/`
- `login_screen.dart` - Authentication interface

#### `/lib/features/home/`
- `home_screen.dart` - Main dashboard screen

#### `/lib/features/tasks/`
- `task_list_screen.dart` - Task and goal management interface

#### `/lib/features/calendar/`
- `calender_screen.dart` - Calendar view for scheduling

#### `/lib/features/profile/`
- `profile_screen.dart` - User profile management
- `status_screen.dart` - User status and progress display
- `profile_data_input_screen.dart` - Profile data entry

#### `/lib/features/game/` (Gaming Module)
- `game.dart` - Main game logic using Flame engine
- `game_screen.dart` - Game interface wrapper
- `stage_screen.dart` - Stage selection
- `battle/battle_screen.dart` - Battle mechanics
- `components/` - Game components (character, background)

### `/lib/shared/` (Shared Resources)

#### `/lib/shared/models/`
- `user.dart` - User data model
- `task.dart` - Task and goal models with Provider state management

#### `/lib/shared/widgets/`
- `shell.dart` - Navigation shell/layout
- `BottomNavigationBar.dart` - Bottom navigation component
- `add_edit_medium_goal_dialog.dart` - Medium goal dialog
- `add_edit_small_goal_dialog.dart` - Small goal dialog

### `/lib/game/` & `/lib/components/` (Legacy Game Files)
- Appears to contain older game-related components
- Includes character sprites, effects, and backgrounds
- May be transitioning to the `/features/game/` structure

## Architecture Pattern
- **Feature-based**: Each major feature has its own directory
- **Shared resources**: Common models and widgets in `/shared/`
- **Clean separation**: UI, business logic, and data models separated
- **Provider pattern**: State management using Provider for reactive UI updates