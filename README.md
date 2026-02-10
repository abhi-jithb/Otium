# Otium

**A nervous-system-aware focus and recovery system.**

Otium helps you notice when your phone has become a coping mechanism instead of a tool. It doesn't block apps, track productivity, or reward streaks. It simply notices cognitive fragmentation patterns and offers a moment to breathe.

---

## 🧠 The Problem

Modern smartphone usage creates a specific type of stress:

| Behavior | What's Actually Happening |
|----------|--------------------------|
| Rapid tapping | Agitation signal — nervous system is dysregulated |
| Doom-scrolling | Seeking dopamine hits — avoiding present-moment discomfort |
| Rapid app switching | Cognitive fragmentation — brain can't sustain attention |
| Compulsive checking | Phone as anxiety coping mechanism, not tool |

**Traditional solutions fail because:**
- **App blockers** are punitive — they don't address *why* you're reaching for your phone
- **Screen time trackers** create shame without offering regulation
- **Productivity apps** with streaks/badges train more dopamine-seeking behavior
- **Willpower-based approaches** deplete an already exhausted nervous system

### Otium's Approach

Otium treats cognitive overload as a **biological signal, not a moral failing**. When it detects fragmentation patterns, it doesn't block or shame — it offers a 60-second breathing exercise that activates the brain's Default Mode Network (DMN), enabling genuine recovery.

---

## ✨ Features

### 1. Focus Sprints (Ultradian Rhythm Alignment)

| Feature | Description |
|---------|-------------|
| **Configurable Duration** | 45, 60, or 90-minute sessions based on cognitive mode |
| **Minimal UI** | Just a timer — zero cognitive load from interface chrome |
| **State Persistence** | Sprint survives app restarts, phone reboots |
| **Pause/Resume** | Can leave and return without losing progress |
| **Live Friction Counter** | Shows current interaction score vs. threshold |

### 2. Pattern Sensing (Fragmentation Detection)

| Signal Detected | Weight | Why It Matters |
|----------------|--------|----------------|
| Normal tap | 1 | Baseline interaction |
| Rapid tap (<500ms) | 2 | Agitation indicator |
| Scroll gesture | 1-5 | Duration-based (doom-scrolling detection) |
| App switch | 3 | Context break |
| Rapid app switch (<10s) | 5 | Severe cognitive fragmentation |

**Algorithm:**
- Uses a **60-second rolling window**
- Events older than 60 seconds are automatically pruned
- When weighted sum exceeds profile threshold → intervention triggers

### 3. Breathing Intervention

| Feature | Description |
|---------|-------------|
| **4-4-4 Pattern** | Inhale (4s) → Hold (4s) → Exhale (4s) → Hold (4s) |
| **60-Second Duration** | Minimum effective dose for DMN activation |
| **Cannot Skip** | Prevents impulsive dismissal |
| **Visual Guidance** | Animated breathing circle with phase indicators |
| **Persistence** | If interrupted, resumes where it left off |

### 4. Cognitive Mode Selection

Before each sprint, users select their current activity type:

| Mode | Threshold | Sprint | Use Case |
|------|-----------|--------|----------|
| **Learning** | 30 | 60 min | Reading, studying, absorbing new info |
| **Deep Work** | 40 | 90 min | Writing, coding, analysis |
| **Creating** | 50 | 90 min | Design, art, building — needs flow protection |
| **Already Scattered** | 25 | 45 min | Starting depleted — gentler thresholds |

### 5. Recovery Periods

| Feature | Description |
|---------|-------------|
| **15-Minute Timer** | Follows each sprint |
| **Analog Nudges** | "Step away", "Hydrate", "Light movement" |
| **Voluntary Exit** | Can end early — respects user autonomy |
| **Ambient Animation** | Calming wave patterns |

### 6. System Features

| Feature | Description |
|---------|-------------|
| **Overlay Intervention** | Can appear over other apps (Android) |
| **Offline-First** | All data stored locally via SharedPreferences |
| **No Cloud/No Login** | Zero data leaves device |
| **App Lifecycle Handling** | Foreground/background state management |

---

## 🔧 Architecture

### Application Flow

```
┌─────────────┐     ┌──────────────────┐     ┌─────────────┐
│   Splash    │ ──► │  Mode Selection  │ ──► │   Sprint    │
│   Screen    │     │  "What are you   │     │   Timer     │
│             │     │   doing now?"    │     │             │
└─────────────┘     └──────────────────┘     └──────┬──────┘
                                                    │
                    ┌───────────────────────────────┘
                    │
                    ▼ (if friction > threshold)
            ┌───────────────┐
            │   Breathing   │
            │  Intervention │
            │    (60s)      │
            └───────┬───────┘
                    │
                    ▼ (sprint continues or ends)
            ┌───────────────┐     ┌────────────────┐
            │   Recovery    │ ──► │   Reflection   │
            │   (15 min)    │     │                │
            └───────────────┘     └───────┬────────┘
                                          │
                                          ▼
                                    ┌──────────┐
                                    │   Home   │
                                    └──────────┘
```

### Tech Stack

| Component | Technology |
|-----------|------------|
| Framework | Flutter (Dart) |
| State Management | Provider |
| Navigation | GoRouter |
| Persistence | SharedPreferences |
| Platform Channels | MethodChannel (Android overlay) |

---

## 👥 Who Should Use Otium?

### Primary Users

| User Type | Why Otium Helps |
|-----------|-----------------|
| **Knowledge Workers** | Writers, analysts, researchers who need sustained focus |
| **Students** | Learners who need memory consolidation breaks |
| **Developers/Engineers** | Deep work requiring uninterrupted flow |
| **Creative Professionals** | Designers, artists who need flow-state protection |
| **Anyone with ADHD tendencies** | Pattern recognition helps externalize self-regulation |

### Specific Use Cases

- **"I keep picking up my phone without realizing"** — Otium detects rapid app-switching and offers breathing intervention
- **"I lose hours to Instagram/TikTok"** — Scroll pattern detection catches doom-scrolling
- **"I want to focus but keep getting distracted"** — Sprint timer creates intentional focus container
- **"I feel exhausted after phone use"** — Recovery periods allow genuine DMN rest
- **"Productivity apps make me feel worse"** — No streaks, no badges, no shame

---

## 🛡️ Design Philosophy

### The "Seatbelt, Not Steering Wheel" Principle

You don't constantly interact with a seatbelt — you only notice it when it protects you. Otium works the same way:
- Invisible during normal use
- Activates only when fragmentation is detected
- Gentle intervention, not aggressive blocking

### Core Principles

| Principle | Implementation |
|-----------|----------------|
| **Autonomy** | User can exit recovery early |
| **Transparency** | All heuristics are visible and explainable |
| **Biological Alignment** | Respects ultradian rhythms and DMN activation |
| **Dignity** | No shame, no scores, no comparison |
| **Privacy** | All data stays on device |

### What Otium Will NEVER Include

| Feature | Reason |
|---------|--------|
| Streaks/Badges | Trains dopamine-seeking behavior |
| Productivity Scores | Reduces humans to metrics |
| Social Comparison | Induces performance anxiety |
| Cloud Sync | Enables surveillance |
| AI Insights | Offloads thinking to machines |
| App Blocking | Punitive, doesn't address root cause |
| Notification Nudges | Becomes another interruption |

---

## 📊 The Science Behind Otium

### Ultradian Rhythms

Humans have natural 90-minute focus cycles. Working against these cycles leads to:
- Cognitive depletion
- Compensatory phone use
- Fragmentation spirals

Otium aligns sprint duration with these natural cycles.

### Default Mode Network (DMN)

The brain's DMN activates during:
- Rest and reflection
- Mind-wandering
- Emotional processing

Constant stimulation (scrolling) prevents DMN activation. The 60-second breathing intervention creates a minimum viable DMN rest period.

### Nervous System Regulation

The 4-4-4 breathing pattern activates the parasympathetic nervous system:
- Slows heart rate
- Reduces cortisol
- Creates felt-sense of safety

This addresses the *root cause* of compulsive phone use: nervous system dysregulation.

---

## 🚀 Getting Started

```bash
# Clone repository
git clone https://github.com/abhi-jithb/Otium.git
cd Otium

# Install dependencies
flutter pub get

# Run on connected device
flutter run
```

### Android Overlay Permission

For intervention to appear over other apps:
1. Settings → Apps → Otium
2. Enable "Display over other apps"

---

## 📁 Project Structure

```
lib/
├── app/
│   ├── app.dart              # Root widget with lifecycle management
│   └── router.dart           # GoRouter navigation configuration
├── core/
│   ├── theme/                # App theming
│   ├── utils/                # Persistence, intervention services
│   └── services/             # Overlay service
├── features/
│   ├── splash/               # App launch screen
│   ├── onboarding/           # First-time user flow
│   ├── home/                 # Main entry point
│   ├── mode_selection/       # Cognitive mode picker
│   ├── sprint/               # Focus timer
│   ├── intervention/         # Breathing exercise
│   ├── recovery/             # Post-sprint rest
│   ├── reflection/           # Session check-in
│   └── dashboard/            # Session summary
├── models/
│   ├── session.dart          # Session state enum
│   └── user_profile.dart     # Cognitive profiles
├── state/
│   ├── user_provider.dart    # User profile state
│   ├── sprint_provider.dart  # Timer state
│   └── fatigue_provider.dart # Pattern sensing state
└── widgets/                  # Reusable UI components
```

---

## 📝 Known Limitations

### What Works
- ✅ Sprint timer with persistence
- ✅ Tap and scroll friction detection
- ✅ App switch detection (when returning to Otium)
- ✅ Breathing intervention with persistence
- ✅ Profile-based threshold adaptation
- ✅ Foreground/background lifecycle handling

### What Partially Works
- ⚠️ Background sensing: Only detects when you *return* to Otium
- ⚠️ Android overlay: Requires manual permission grant
- ⚠️ iOS not yet supported for overlay features

### What Is NOT Implemented
- ❌ System-wide app usage tracking (requires accessibility services)
- ❌ Biometric integration (HRV, stress detection)
- ❌ iOS Screen Time API integration
- ❌ Wearable device integration

---

## 🤝 Contributing

Contributions welcome! Please read the design philosophy above before proposing features that conflict with Otium's core principles.

---

## 📄 License

MIT License — see LICENSE file for details.

---

**Built with care for cognitive preservation.**

*"The goal is not to use Otium well. The goal is to need Otium less."*
