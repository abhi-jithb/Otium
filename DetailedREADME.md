# Otium Technical Documentation

Otium is a productivity system built on the principle of **Nervous System Aware Productivity**. Unlike traditional apps that maximize output through pressure (streaks, badges, notifications), Otium minimizes cognitive strain through monitored cycles of work and forced regulation.

## 🏗 Architecture & Core Modules

### 1. State Management (The "Brain")
We use the `Provider` package to manage state across three primary domains:

*   **`SprintProvider`**: Manages the 90-minute Ultradian cycle. It tracks remaining time and handles the transition from `SessionState.focus` to `SessionState.recovery`.
*   **`FatigueProvider`**: The core heuristic engine. It monitors "Cognitive Friction" (interaction counts, app switching) and triggers a fatigued state when thresholds are met.
*   **`UserProvider`**: Manages user profiles and role-based personalization (Creator, Student, etc.).

### 2. Heuristic Logic (Overload Detection)
Instead of complex AI models, Otium uses transparent, on-device rules:
- **Interaction Friction**: Incremented by taps and clicks. Threshold: 40 units.
- **Distraction Penalty**: Switching away from Otium during a sprint adds a +10 penalty to the friction count.
- **Trigger**: Once friction > 40, the system emits a fatigue signal, forcing an immediate transition to the `BreathingScreen`.

### 3. Regulation Flow
The application enforces a "Control → Regulation → Return" loop:
1.  **Focus**: User enters a 90m deep work block.
2.  **Detection**: If overload is detected via friction heuristics.
3.  **Regulation**: User is moved to `BreathingScreen`. A 60-second 4-4-4 breathing cycle is enforced with a timed lockout.
4.  **Reset**: Interaction counts are wiped after regulation, allowing the user to resume with a fresh cognitive slate.

## 🛠 Technical Stack
- **Framework**: Flutter (Dart)
- **Navigation**: GoRouter (for declarative, state-based routing)
- **Persistence**: SharedPreferences (On-device local storage for privacy)
- **Design System**: Vanilla CSS-like styling in Dart with a "paper-like" low-blue-light theme.

## 🔒 Privacy & Local-First Philosophy
> *"All behavioral data is stored locally on the device. Otium learns usage patterns without sending data anywhere."*

Otium intentionally avoids cloud backends to ensure that sensitive productivity habits and cognitive data never leave the user's physical device. Every insight is generated on-the-fly using local state.

## 🚀 Key Rules
- **Anti-Optimization**: No streaks. No fireworks. No gamification.
- **Enforced Recovery**: Recovery sessions are hard-locked using `PopScope` to prevent impulsive exits.
- **Organic Visuals**: State indicators use slow pulse animations (2s duration) to down-regulate the user's nervous system visually.
