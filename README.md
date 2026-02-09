# Otium: Reclaiming the Biological Capacity to Think
> *A seatbelt for your attention span.*

<div align="center">

<!-- Add your demo video link or GIF here -->
![Otium Demo](path/to/demo.gif)

[![Flutter](https://img.shields.io/badge/Built_with-Flutter-02569B?style=for-the-badge&logo=flutter)](https://flutter.dev)
[![Offline First](https://img.shields.io/badge/Architecture-Offline_First-success?style=for-the-badge)](https://github.com/abhi-jithb/Otium)
[![License](https://img.shields.io/badge/License-MIT-blue?style=for-the-badge)](LICENSE)

</div>

---

## 🧠 The Philosophy
Otium is not another pomodoro timer. It is a **biological regulation system** for your phone.

Traditional apps try to squeeze *more output* from you using streaks and notifications. Otium does the opposite: it protects your **cognitive capacity** by enforcing recovery when your nervous system shows signs of overload.

### The "Seatbelt" Model
You don't "use" a seatbelt constantly; you only notice it when it protects you.
1.  **Work Anywhere**: Otium runs silently while you work.
2.  **Coping Signal**: When you start "doomscrolling" or rapidly switching apps (coping mechanisms), Otium detects the friction.
3.  **Intervention**: It intervenes *only* when necessary—forcing a 60-second recovery break.
4.  **Disappear**: Once regulated, it gets out of your way.

---

## 📱 Features

### 1. Adaptive Cognitive Profiles
Otium adapts its sensitivity based on your role, not your personality.

| Role | Threshold | Sprint | Recovery |
|------|-----------|--------|----------|
| **Student** | Low (30) | 60m | 12m |
| **Knowledge Worker** | Medium (40) | 90m | 15m |
| **Creative** | High (50) | 90m | 18m |
| **Heavy User** | Adaptive | 45m | 10m |

### 2. Time-Weighted Friction Detection
We don't just count taps. We measure **cognitive cost**:
*   **Simple Tap**: 1 point
*   **Rapid Burst (<500ms)**: 3 points (Panic/Doomscrolling)
*   **Context Switch**: 20 points (Fragmented Attention)

### 3. Default Mode Network (DMN) Activation
When overload hits, Otium forces a **60-second breathing exercise**. This idle state activates the brain's **Default Mode Network**, essential for:
*   Insight generation
*   Emotional processing
*   Memory consolidation

---

## 📸 Screenshots


<div align="center">
![ss1](https://github.com/user-attachments/assets/caca5c48-606d-476b-a8a9-d6ebaa340466)
![ss2](https://github.com/user-attachments/assets/05e72773-be64-4281-b522-f4de3d956500)
![ss3](https://github.com/user-attachments/assets/b64411f6-2f17-4fa9-b38b-1ddb12b25be2)

</div>

---

## 🏗 Technical Architecture

### Offline-First & Privacy-Centric
> *"All data stays on your device."*

- **No Cloud**: Zero backend calls. No servers.
- **Local Persistence**: `SharedPreferences` stores your behavioral baseline.
- **No Login**: Install and use immediately.

### Smart Adaptation Engine
The app learns from yesterday to improve today:
```dart
// Simplified Learning Logic
if (overloadCount > 2) {
  // Too much strain yesterday?
  nextSprintDuration -= 10; // Reduce load today
} else if (overloadCount == 0) {
  // Too easy?
  frictionThreshold += 5; // Increase tolerance
}
```

### Critical Implementation Details
*   **Overlay Permission**: Utilizes `SYSTEM_ALERT_WINDOW` (Android) to intervene over other apps.
*   **Foreground Service**: Ensures tracking continues even when the app is "closed."
*   **Battery Efficient**: Only wakes up on interaction events.

---

## 🚀 Getting Started

1.  **Clone the repository**
    ```bash
    git clone https://github.com/abhi-jithb/Otium.git
    ```

2.  **Install dependencies**
    ```bash
    flutter pub get
    ```

3.  **Run the app**
    ```bash
    flutter run
    ```

---

## 🔮 Future Roadmap
- [ ] iOS "Screen Time" API Integration
- [ ] Cross-session analytics dashboard
- [ ] Wearable integration for heart-rate variability (HRV) triggers

---

**Built with ❤️ for cognitive preservation by team THUDARUM**
