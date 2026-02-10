# Otium: Reclaiming the Biological Capacity to Think
> *A biology-aligned focus and recovery system designed to restore digital sovereignty.*

<div align="center">

[![Flutter](https://img.shields.io/badge/Built_with-Flutter-02569B?style=for-the-badge&logo=flutter)](https://flutter.dev)
[![Offline First](https://img.shields.io/badge/Architecture-Offline_First-success?style=for-the-badge)](https://github.com/abhi-jithb/Otium)
[![License](https://img.shields.io/badge/License-MIT-blue?style=for-the-badge)](LICENSE)

</div>

---

## 📋 Problem Statement: The $1.3 Trillion "Negotium" Crisis

The global workforce is trapped in a cycle of **Negotium** — a state of constant, non-enjoyable digital busyness. By 2026, the boundary between human cognitive rhythms and algorithm-driven stimulation has blurred, creating a critical inflection point for technology overuse.

### The Productivity Paradox
Despite always-on connectivity, digital distractions contribute to an estimated **$1.3 trillion in annual global productivity loss**.

### Attention Fragmentation
The average employee switches tasks roughly every **47 seconds** due to notifications and app interruptions. Prolonged exposure to such environments has been associated with rising attention fragmentation and ADHD-like symptoms in digitally saturated contexts.

### AI-Induced Cognitive Offloading
Increased reliance on AI tools has accelerated "cognitive offloading," where users delegate thinking instead of engaging in it. This trend raises concerns about reduced independent problem-solving and critical-thinking endurance.

### Relationship Erosion
Nearly **1 in 4 relationships** are affected by phubbing (phone-snubbing), increasing social isolation even in moments of physical presence.

**Note**: Existing solutions focus on blocking apps or tracking time — they treat symptoms, not the biological cause.

---

## The Otium Solution

Otium is not an app blocker. It is a **biology-aligned focus and recovery system** designed to restore digital sovereignty by syncing device usage with natural cognitive rhythms.

### Pillar I: Ultradian Focus Sprints (Biology-Aligned Work Cycles)

Instead of enforcing the industrial-era 8-hour workday, Otium structures work into **90–120 minute focus sprints**.

**Why it works:**
- Human cognition operates in ultradian rhythms.
- Sustained effort beyond these cycles increases stress responses and cognitive fatigue.

**MVP Implementation:**
Otium guides users through timed focus sprints followed by intentional recovery periods, helping improve sustained attention and task completion efficiency.

### Pillar II: Usage Pattern Sensing (Lightweight Digital Phenotyping)

Otium detects early signs of cognitive fatigue before users slip into compulsive scrolling or burnout.

**Why it works:**
- Changes in interaction patterns — such as rapid task-switching — are strong indicators of mental overload.

**MVP Implementation:**
Instead of complex AI models, the MVP uses deterministic thresholds (e.g., rapid interaction bursts) to trigger timely micro-interventions like short breathing resets. This demonstrates adaptive behavior without over-claiming AI precision.

### Pillar III: Intentional Mental Recovery (DMN-Inspired Rest)

Otium protects the moments where insight happens.

**Why it works:**
- When external stimulation drops, the brain enters a reflective mode associated with memory consolidation and creative problem-solving.

**MVP Implementation:**
After each focus sprint, Otium enters a full-screen recovery mode and suggests an analog recovery ritual (e.g., stepping away from the screen, light movement, or nature viewing).

---

## 🏗 24-Hour MVP: Technical Setup

To deliver a complete and credible prototype within hackathon constraints, the MVP focuses on the **Sprint → Sense → Recover** loop while avoiding OS-level complexity.

### Tech Stack
- **Framework**: Flutter (single codebase for Android & iOS)
- **State & Storage**: Local state + lightweight persistence
- **Sensing Logic**: Deterministic, rule-based interaction thresholds
- **Future Extensions**: Placeholder for HealthKit / Health Connect integration

*Note: Biometric and OS-level enforcement are positioned as future extensions, not MVP claims.*

---

## 📱 Application Workflow

### 1. Onboarding
Users select a high-level focus profile (e.g., Student, Young Professional, Knowledge Worker).

### 2. Neuro-Sprint
- A 90-minute focus sprint begins.
- The UI shifts to a calm, low-stimulus color palette (soft greens/blues).

### 3. Passive Guard
- The app monitors interaction patterns.
- When overload patterns appear, a brief micro-intervention is triggered.

### 4. Recovery Mode
- At sprint completion, the app enters a full-screen recovery state.
- Displays an analog nudge (e.g., "Step away for 15 minutes").

### 5. Reclaim Dashboard
- Users log post-recovery energy levels (1–10).
- The dashboard visualizes:
  - Uninterrupted focus time
  - Recovery sessions completed
  - Self-reported mental clarity trends

---

## 🎯 Hackathon Presentation Hook

> "Every few seconds, our attention is interrupted. Otium doesn't track your time — **it restores your biological capacity to think.**"

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
