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

### 2. Adaptive Cognitive Profiles

**Role differentiation is NOT about identity—it's about initial cognitive tolerance.**

| User Type | Interaction Threshold | Sprint Duration | Recovery Duration | Purpose |
|-----------|----------------------|-----------------|-------------------|---------|
| Student | 30 | 60 min | 12 min | Lower threshold for learning-focused work |
| Knowledge Worker | 40 | 90 min | 15 min | Balanced threshold for sustained focus |
| Creative / Builder | 50 | 90 min | 18 min | Higher threshold for flow-state work |
| Heavy Screen User | 25 | 45 min | 10 min | Adaptive threshold for high-stimulation users |

**This selection adapts overload sensitivity, not personality.**

### 3. Heuristic Logic (Overload Detection)
Instead of complex AI models, Otium uses transparent, on-device rules:
- **Interaction Friction**: Incremented by taps and clicks. Threshold: User-specific (25-50).
- **Distraction Penalty**: Switching away from Otium during a sprint adds a +10 penalty to the friction count.
- **Trigger**: Once friction > threshold, the system emits a fatigue signal, forcing an immediate transition to the `BreathingScreen`.

> *"We use transparent rules, not hidden AI."*

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
