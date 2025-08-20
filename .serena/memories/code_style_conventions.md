# Code Style and Conventions

## Dart/Flutter Conventions

### Naming Conventions
- **Files**: snake_case (e.g., `home_screen.dart`, `task_list_screen.dart`)
- **Classes**: PascalCase (e.g., `HomeScreen`, `GoalModel`, `MyGame`)
- **Variables/Methods**: camelCase (e.g., `_mediumGoals`, `addMediumGoal`)
- **Constants**: UPPER_SNAKE_CASE
- **Private members**: Prefix with underscore (e.g., `_HomeScreenState`, `_notify`)

### File Organization
- Each screen/widget in its own file
- Models separated in `/shared/models/`
- Reusable widgets in `/shared/widgets/`
- Feature-specific code in respective `/features/` directories

### Import Organization
```dart
// Flutter/Dart imports first
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// External package imports
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';

// Internal imports last
import 'package:sennsi_app/config/router.dart';
import 'package:sennsi_app/shared/models/task.dart';
```

### Widget Structure
- StatefulWidget for components with state
- StatelessWidget for static components
- Proper key usage (e.g., `super.key`)
- Material Design 3 components preferred

### State Management
- Provider pattern for app-wide state
- ChangeNotifier for model classes
- Private fields with public getters
- Notification methods after state changes

### Code Quality Rules
- Uses `flutter_lints` package for linting
- Analysis options configured in `analysis_options.yaml`
- Material Design 3 guidelines followed
- Japanese localization support included

### Comments and Documentation
- Japanese comments present in some files
- Self-documenting code preferred
- Constructor documentation when needed