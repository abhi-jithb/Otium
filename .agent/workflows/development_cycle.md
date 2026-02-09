---
description: Otium Development and Deployment Cycle
---

// turbo-all
# Otium Development Workflow

Follow these steps for any feature addition or bug fix to maintain the "cognitive preservation" philosophy of Otium.

### 1. Implementation
- Implement the feature focusing on **state management** and **automated triggers**.
- Ensure UI components are minimal and follow the `AppColors.calm` palette.
- Use `Provider` for state and `GoRouter` for navigation.

### 2. Verification
- Run `flutter run` to verify the application launches.
- Check for any lint errors using `flutter analyze`.

### 3. Version Control
- Stage changes: `git add .`
- Commit with a descriptive prefix (`feat:`, `fix:`, `chore:`, `doc:`).
- Push to remote: `git push origin master`.

### 4. Documentation
- Update `DetailedREADME.md` if the core logic or state transitions change.
