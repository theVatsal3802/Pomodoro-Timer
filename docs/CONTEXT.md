# Step-by-Step Breakdown for Pomodoro App

## 1. **Project Setup**

- Set up your development environment (e.g., Flutter or React Native).
- Ensure the app uses **dark mode only** throughout (no toggle).
- Add required dependencies (e.g., wakelock, audio player, navigation libraries).

---

## 2. **Splash Screen**

- Create a splash screen with the app name/logo.
- Display it briefly before navigating to the next screen.
- Add a fade or scaling animation for visual polish.

---

## 3. **Time Selection Screen**

- Design a layout with:
  - **Dropdowns or segmented controls** to select:
    - Focus session duration (e.g., 25, 30, 45 minutes).
    - Short break duration (e.g., 5, 10 minutes).
    - Long break duration (e.g., 15, 20 minutes).
  - A **stepper or dropdown** to select the number of focus sessions per cycle (e.g., 1–6).
- **Bottom of screen:** Add a prominent **Start** button.
- Include a **Tutorial** button somewhere visible on this screen.

---

## 4. **Tutorial Screen**

- A separate screen that clearly explains:
  - How to set up session durations and breaks.
  - What happens during each session.
  - How to pause/resume the timer (tap once).
  - How to stop and confirm exit (double tap).
  - Alert sounds on mode transitions.
  - That the screen won’t sleep during the timer.
- Ensure the tutorial matches actual app behavior.

---

## 5. **Timer Screen**

- Show a large **dial timer** in the center with a drop shadow.
- Indicate current mode: "Focus", "Short Break", or "Long Break".
- Implement **tap actions**:
  - **Single tap**: Toggle pause/resume of timer.
  - **Double tap**: Pause and show **exit confirmation dialog**:
    - If "Yes": Return to time selection screen.
    - If "No": Resume timer.

---

## 6. **Timer Logic**

- Start countdown based on selected durations.
- After each focus session:
  - If total sessions completed < selected number:
    - Switch to short break.
  - Else:
    - Switch to long break and reset session count.
- Ensure **mode transitions** automatically after each timer ends.

---

## 7. **Wakelock Integration**

- Use wakelock to **prevent screen from sleeping** during timer.
- Enable wakelock when the timer starts.
- Disable wakelock when the timer ends or user exits.

---

## 8. **Sound Alerts**

- Play a short **alarm sound**:
  - When transitioning from focus to break or vice versa.
- Keep sound subtle but noticeable.

---

## 9. **Navigation and State Management**

- Use a **navigation stack** to move between:
  - Splash Screen → Time Selection Screen → Timer Screen → (Optional: Tutorial Screen).
- Use a **state management approach** (like Provider, Bloc, or Context API) to:
  - Track timer state.
  - Handle transitions.
  - Manage pause/resume.

---

## 10. **Polish and Testing**

- Ensure:
  - Dark theme is consistent.
  - Timer handles edge cases (e.g., tap rapidly).
  - Sounds are not intrusive.
  - UX is smooth and transitions are well animated.
