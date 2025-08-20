# Task Completion Checklist

When completing any development task in this Flutter project, follow these steps:

## Code Quality Checks
1. **Run static analysis**:
   ```bash
   flutter analyze
   ```
   - Ensure no warnings or errors
   - Follow lint rules from `flutter_lints` package

2. **Run tests** (if tests exist):
   ```bash
   flutter test
   ```
   - Verify all existing tests pass
   - Add tests for new functionality if applicable

3. **Check formatting**:
   ```bash
   dart format lib/
   ```
   - Ensure consistent code formatting

## Build Verification
4. **Test app compilation**:
   ```bash
   flutter run --debug
   ```
   - Verify app builds and runs without errors
   - Test on multiple platforms if needed (iOS, Android, Web)

5. **Check dependencies**:
   ```bash
   flutter pub get
   flutter pub deps
   ```
   - Ensure all dependencies are properly resolved

## Code Review
6. **Review changes**:
   - Check imports are organized correctly
   - Verify naming conventions are followed
   - Ensure no Japanese comments are broken
   - Confirm Material Design 3 guidelines are followed

7. **Test functionality**:
   - Manually test new features
   - Verify navigation works correctly
   - Test state management (Provider updates)
   - Check game components if modified (Flame engine)

## Git Workflow
8. **Stage and commit**:
   ```bash
   git add .
   git status
   git commit -m "descriptive commit message"
   ```

## Environment Check
9. **Verify Flutter environment**:
   ```bash
   flutter doctor
   ```
   - Ensure no critical issues before deployment

## Special Considerations
- **Game features**: Test Flame engine components thoroughly
- **Audio**: Verify flame_audio functionality
- **Japanese localization**: Ensure date formatting works correctly
- **Device preview**: Test responsive design across device sizes