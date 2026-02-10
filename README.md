# Otium

**A nervous-system–aware focus and recovery system.**

Otium helps you notice when your phone has become a coping mechanism instead of a tool. It doesn't block apps, track productivity, or reward streaks. It simply notices cognitive fragmentation patterns and offers a moment to breathe.

---

## What Otium Does Today

### Focus Sprints
- Configurable focus sessions (45–90 minutes) aligned with ultradian rhythms
- Minimal interface: just a timer, nothing else to distract
- Session state persists if you close the app

### Pattern Sensing
- Detects rapid tapping (agitation signal)
- Detects rapid app switching (cognitive fragmentation)
- Detects scroll patterns (doom-scrolling behavior)
- Uses a 60-second rolling window with weighted events
- All sensing is local, transparent, and explainable

### Breathing Intervention
- When fragmentation patterns exceed threshold, a 60-second breathing exercise appears
- 4-4-4 breathing pattern (inhale, hold, exhale, hold)
- Cannot be dismissed until complete
- Activates the brain's Default Mode Network for genuine recovery

### Mode Selection
- Select your current cognitive mode before each sprint
- **Learning**: Lower threshold, 60-minute sprints
- **Deep Work**: Balanced threshold, 90-minute sprints  
- **Creating**: Higher threshold for flow protection
- **Already Scattered**: Gentler thresholds when you're depleted

### Recovery Periods
- 15-minute recovery after each sprint
- Analog nudges: "Step away", "Hydrate", "Light movement"
- Can exit early (respects autonomy)

---

## Architecture

### Offline-First, Local-Only
- All data stored on device via SharedPreferences
- No cloud, no login, no accounts
- No data leaves your phone

### State Persistence
- Sprint timer survives app restarts
- Fatigue state persists across sessions
- Intervention progress is saved if interrupted
- Daily counters reset automatically

### Transparent Heuristics
All detection logic is rule-based and explainable:
- Normal tap: weight 1
- Rapid tap (<500ms): weight 2
- Scroll gesture: weight 1-5 based on duration
- App switch: weight 3
- Rapid app switch (<10s): weight 5

Threshold triggers intervention when rolling 60-second window exceeds profile limit.

---

## Known Limitations

### What Works
- ✅ Sprint timer with persistence
- ✅ Tap and scroll friction detection
- ✅ App switch detection (when returning to Otium)
- ✅ Breathing intervention with persistence
- ✅ Profile-based threshold adaptation
- ✅ Foreground/background lifecycle handling

### What Partially Works
- ⚠️ Background sensing: Only detects when you *return* to Otium, not what you did elsewhere
- ⚠️ Cross-day learning: Basic threshold adjustment exists but isn't heavily tested
- ⚠️ Android overlay: Requires manual permission grant, iOS not yet supported

### What Is NOT Implemented
- ❌ System-wide app usage tracking (requires accessibility services)
- ❌ Biometric integration (HRV, stress detection)
- ❌ iOS Screen Time API integration
- ❌ Cross-session analytics dashboard
- ❌ Wearable device integration

---

## What Otium Will Never Include

| Feature | Why Not |
|---------|---------|
| Streaks, badges, or achievements | Creates extrinsic motivation; trains dopamine-seeking |
| Productivity scores | Reduces human complexity to metrics |
| Social comparison | Induces performance anxiety |
| Cloud sync | Enables surveillance; creates data anxiety |
| AI-generated insights | Offloads thinking to the system |
| App blocking | Punitive; doesn't address root cause |
| Notification nudges | Becomes another interruption source |

---

## Technical Stack

- **Framework**: Flutter (Dart)
- **State Management**: Provider
- **Navigation**: GoRouter
- **Persistence**: SharedPreferences (local)
- **Platform**: Android (iOS partial)

---

## Philosophy

Otium is designed to be a **seatbelt, not a steering wheel**. You don't "use" it constantly—you only notice it when it protects you.

The system is built on these principles:

1. **Autonomy**: User is never coerced. Recovery can be exited early.
2. **Transparency**: All rules are visible and explainable.
3. **Biological alignment**: Respects ultradian rhythms and DMN activation.
4. **Dignity**: No shame, no performance pressure, no gamification.
5. **Privacy**: Data stays on-device, period.

---

## Getting Started

```bash
# Clone
git clone https://github.com/abhi-jithb/Otium.git

# Install dependencies
flutter pub get

# Run
flutter run
```

### Android Overlay Permission
For the intervention to appear over other apps:
1. Go to Settings → Apps → Otium
2. Enable "Display over other apps"

---

## Honest Assessment

Otium is a **functional prototype** demonstrating:
- Focus sprint cycles
- Local pattern sensing
- Breathing intervention
- State persistence

It is **not** a production-ready wellness app. The sensing logic is approximate, the UI is functional but not polished, and cross-platform support is incomplete.

What makes it meaningful is the *philosophy*: a system that treats cognitive overload as a biological signal, not a moral failing, and responds with regulation, not punishment.

---

**Built with care for cognitive preservation.**

*The goal is not to use Otium well. The goal is to need Otium less.*
