# Otium Technical Documentation

Otium is a productivity system built on the principle of **Nervous System Aware Productivity**. Unlike traditional apps that maximize output through pressure (streaks, badges, notifications), Otium minimizes cognitive strain through monitored cycles of work and forced regulation.

## � Current Status (Honest Assessment)

**What We Have:**
- ✅ Functional focus-overload-regulation loop
- ✅ Local-first data persistence (no cloud, no login)
- ✅ Adaptive thresholds based on user cognitive profile
- ✅ Default Mode Network (DMN) activation through forced idle states
- ✅ App lifecycle monitoring for distraction detection

**What's Next:**
- 🔄 Long-term behavioral adaptation (threshold learning over days)
- 🔄 Cross-session analytics dashboard
- 🔄 Explanation screen ("How Otium Works")

> *"Currently, Otium is a functional prototype that demonstrates focus, overload detection, and nervous-system regulation. Local learning and personalization are the next step, and we've intentionally designed the architecture to support offline adaptation."*

## �🏗 Architecture & Core Modules

### 1. State Management (The "Brain")
We use the `Provider` package to manage state across three primary domains:

*   **`SprintProvider`**: Manages the 90-minute Ultradian cycle. It tracks remaining time and handles the transition from `SessionState.focus` to `SessionState.recovery`.
*   **`FatigueProvider`**: The core heuristic engine. It monitors "Cognitive Friction" (interaction counts, app switching) and triggers a fatigued state when thresholds are met.
*   **`UserProvider`**: Manages user profiles and role-based personalization (Student, Knowledge Worker, Creative, Heavy User).

### 3. Heuristic Logic (Overload Detection)
Instead of complex AI models, Otium uses transparent, on-device rules:
- **Interaction Friction**: Incremented by taps and clicks. Threshold: User-specific (25-50).
- **Distraction Penalty**: Switching away from Otium during a sprint adds a +10 penalty to the friction count.
- **Trigger**: Once friction > threshold, the system emits a fatigue signal, forcing an immediate transition to the `BreathingScreen`.

> *"We use transparent rules, not hidden AI."*

## 🧠 Usage Model: The "Seatbelt" Philosophy

Otium is designed to be a **seatbelt, not a steering wheel**. You don't "use" it constantly; you only notice it when it protects you.

### How it works in real life:
1.  **Work Anywhere**: You work on your laptop, notebook, or code. You don't need to stare at Otium.
2.  **The "Coping" Signal**: When biology breaks down, the phone becomes a coping device. We track this via **compulsive unlocks** and **rapid app switching**.
3.  **The Intervention**: Otium appears *only* when it detects this restless friction.
    - No notifications.
    - No warnings.
    - Just intervention (Recovery Screen).
4.  **Disappear**: Once regulated (60s breathing), Otium steps back. No check-ins, no tracking charts.

> *"Otium appears only when the phone becomes a coping device."*

### 4. Default Mode Network (DMN) Activation

**What is DMN?**
The Default Mode Network is a brain state activated during:
- Idle moments
- Walking
- Breathing
- Mind-wandering

**Why it matters:**
DMN is responsible for:
- Insight generation
- Emotional processing
- Memory consolidation

**How Otium uses it:**
When overload is detected, we force a short idle state (60s breathing exercise). This:
- Stops task-oriented thinking
- Reduces external stimulation
- Forces idle attention
- **Activates DMN for recovery**

> *"When overload is detected, we force a short idle state. This activates the brain's Default Mode Network, which is essential for recovery and insight."*

### 5. Regulation Flow
The application enforces a "Control → Regulation → Return" loop:
1.  **Focus**: User enters a timed deep work block (duration based on profile).
2.  **Detection**: If overload is detected via friction heuristics.
3.  **Regulation**: User is moved to `BreathingScreen`. A 60-second 4-4-4 breathing cycle is enforced with a timed lockout.
4.  **Soft Reset**: Fatigue state is cleared, but interaction count persists (for learning).

## 🛠 Technical Stack
- **Framework**: Flutter (Dart)
- **Navigation**: GoRouter (for declarative, state-based routing)
- **Persistence**: SharedPreferences (On-device local storage for privacy)
- **Design System**: Vanilla CSS-like styling in Dart with a "paper-like" low-blue-light theme.

## 🔒 Privacy & Local-First Philosophy
> *"All behavioral data is stored locally on the device. Otium learns usage patterns without sending data anywhere."*

Otium intentionally avoids cloud backends to ensure that sensitive productivity habits and cognitive data never leave the user's physical device.

**What we store locally:**
- User cognitive profile (role + thresholds)
- Daily interaction count
- Overload event count
- Last sprint timestamp

**What "learning" means:**
Learning ≠ Machine Learning.

For our MVP:
> Learning = adjusting thresholds over time based on observed patterns.

Example:
```
If user hits overload 3 times/day
→ reduce sprint length tomorrow
```

This is **legitimate, rule-based learning**.

## 🚀 Key Rules
- **Anti-Optimization**: No streaks. No fireworks. No gamification.
- **Enforced Recovery**: Recovery sessions are hard-locked using `PopScope` to prevent impulsive exits.
- **Organic Visuals**: State indicators use slow pulse animations (2s duration) to down-regulate the user's nervous system visually.
- **Transparent Heuristics**: All detection logic is rule-based and explainable.

## 📊 What Makes This Different

Traditional productivity apps:
- Maximize output
- Use pressure (streaks, badges)
- Ignore biological limits

Otium:
- Minimizes cognitive strain
- Uses forced regulation
- Respects ultradian rhythms
- Activates DMN for recovery
- Works completely offline
- Uses transparent rules, not black-box AI

## ⚠️ Critical Implementation Strategies (Engineered Solutions)

### 1. The "Seatbelt" Overlay Challenge
**The Challenge:** Modern OSs (especially iOS/Android 14+) restrict apps from interrupting the user or "hijacking" the screen.
**Our Solution:**
- **Android**: We utilize the `SYSTEM_ALERT_WINDOW` permission to display the Recovery Screen over other apps during critical overload events. (Demo Note: This permission must be manually granted).
- **iOS**: We rely on **Critical Alerts** and Screen Time API integrations (Future Roadmap) to enforce limits respectfully.

### 2. Battery Optimization vs. Silent Tracking
**The Challenge:** OSs kill background apps to save battery, which would stop our "Daily Life" tracking.
**Our Solution:**
- Otium implements a lightweight **Foreground Service** with a persistent, low-priority notification. This signals to the OS: *"I am doing important regulation work, do not kill me."*

### 3. The "Coping Device" Heuristic (Refined Logic)
We don't just count taps. We use a **Time-Weighted Interaction Density** formula:
- **Simple Taps**: Low weight (1pt).
- **Rapid Bursts (<500ms)**: High weight (3pts) → Signals doomscrolling/panic.
- **Context Switches**: Heavy penalty (10-20pts) → Signals fragmented attention.

> *"Switching from Slack to Instagram to Email in 30 seconds is the friction we are looking for."*
