# DailyMenu UX Design Specification v2

_Created on 2025-12-01 by BMad_
_Extends: UX Design Specification v1.0_
_Generated using BMad Method - Create UX Design Workflow_

---

## Executive Summary

DailyMenu v2 extends the warm, vintage menu aesthetic with **journey-focused experiences** that celebrate personal growth without pressure. The design philosophy centers on **"engagement without anxiety"** — gamification that feels like collecting memories, not chasing metrics.

### Core Design Tenets

1. **Warm over clinical**: Every interaction feels handmade, not algorithmic
2. **Optional depth**: Surface simplicity hides optional layers for engaged users
3. **Celebration without comparison**: Personal journey, never leaderboards
4. **Grace over guilt**: Skip buttons are prominent; absence is never punished
5. **Artisanal aesthetic**: Stamps look inked, not rendered; seasons evoke nature

---

## 1. Design System Foundation

### 1.1 Design System Evolution

Building on the vintage menu aesthetic from v1, v2 introduces:

**Extended Palette:**
- **Journey Colors**: Golden progression from dawn to dusk
- **Mood Spectrum**: Warm tones for emotional states (never clinical)
- **Stamp Ink**: Faded, pressed-in appearance with slight rotation

**New Typography Roles:**
- **Celebration Text**: Slightly larger serif for moment announcements
- **Stat Numbers**: Elegant numerals for gamification displays
- **Prompt Text**: Gentle, question-style copy for mood check-ins

**Motion Principles:**
- **Collect**: Items drift gently into place (stamps, moments)
- **Reveal**: Gradual appearance like morning light
- **Celebrate**: Subtle pulse, never jarring confetti

---

## 2. Core User Experience

### 2.1 Defining Experience

**Primary Experience**: "Tending a personal garden of tiny joys"

Users should feel like:
- They're **collecting meaningful moments**, not grinding XP
- **Progress is visible but not urgent** — like watching seasons change
- **Skipping is natural** — gardens rest in winter too
- **Returning after absence feels welcoming**, not shameful

### 2.2 Experience Zones

| Zone | Purpose | Emotional Tone |
|------|---------|----------------|
| **Home** | Quick suggestion access | Energizing, inviting |
| **Journey** | Mood prompts, feedback | Reflective, gentle |
| **Calendar** | History review | Contemplative, proud |
| **Profile** | Stats, stamps, seasons | Celebratory, personal |
| **Settings** | Control, privacy | Trustworthy, clear |

---

## 3. Visual Foundation

### 3.1 Extended Color System

**Journey Progression (Seasons)**

| Season | Primary Color | Hex | Mood |
|--------|---------------|-----|------|
| First Light | Soft peach | #FFECD2 | Dawn awakening |
| Morning Dew | Gentle sage | #C8D5BB | Fresh start |
| Sunlit Path | Warm gold | #F4D03F | Growing confidence |
| Afternoon Tea | Rich amber | #D4A574 | Comfortable ritual |
| Golden Hour | Deep orange | #E67E22 | Peak warmth |
| Twilight Calm | Dusty rose | #C39BD3 | Gentle evening |
| Starlit | Deep purple | #5B2C6F | Quiet reflection |
| Full Moon | Silver blue | #85929E | Peaceful mastery |
| Aurora | Iridescent teal | #48C9B0 | Rare achievement |
| Eternal Garden | Emerald gold | #27AE60 | Lasting serenity |

**Mood Spectrum**

| State | Color | Hex | Usage |
|-------|-------|-----|-------|
| Low | Soft gray-blue | #A9CCE3 | Before-mood: tired |
| Okay | Warm neutral | #D5DBDB | Before-mood: steady |
| Good | Gentle green | #A9DFBF | Before-mood: ready |
| Lower | Muted coral | #F5B7B1 | After-mood: drained |
| Same | Balanced sage | #D5D8DC | After-mood: neutral |
| Better | Warm gold | #F9E79F | After-mood: lifted |

**Stamp Ink Colors**

| Category | Ink Color | Hex |
|----------|-----------|-----|
| Journey | Terracotta | #A04000 |
| Explorer | Forest green | #1E8449 |
| Mood | Dusty purple | #6C3483 |
| Time | Navy | #1B4F72 |
| Seasonal | Burnt sienna | #873600 |

### 3.2 Typography Extensions

**Celebration Moments**
- Font: System serif (New York)
- Size: 28pt
- Weight: Semibold
- Letter spacing: 0.5pt

**Mood Prompts**
- Font: System rounded (SF Rounded)
- Size: 20pt
- Weight: Regular
- Line height: 1.4

**Stat Display**
- Font: System serif (New York)
- Size: 48pt for large numbers
- Weight: Bold
- Color: Theme-appropriate season color

---

## 4. Component Library

### 4.1 Mood Check-In Component

**Before Mood Picker**

```
┌─────────────────────────────────────┐
│   How are you feeling right now?    │
│                                     │
│   ┌─────┐  ┌─────┐  ┌─────┐        │
│   │ 🌱  │  │ 🌿  │  │ 🌻  │        │
│   │ Low │  │Okay │  │Good │        │
│   └─────┘  └─────┘  └─────┘        │
│                                     │
│           [ Skip ]                  │
└─────────────────────────────────────┘
```

- **Icons**: Nature-based, not faces (reduces self-judgment)
- **Labels**: One-word, non-clinical
- **Skip**: Always visible, same visual weight as options
- **Animation**: Selected icon gently blooms

**After Mood Picker**

```
┌─────────────────────────────────────┐
│      How do you feel now?           │
│                                     │
│   ┌─────┐  ┌─────┐  ┌─────┐        │
│   │ ↓   │  │ →   │  │ ↑   │        │
│   │Lower│  │Same │  │Better│       │
│   └─────┘  └─────┘  └─────┘        │
│                                     │
│           [ Skip ]                  │
└─────────────────────────────────────┘
```

- **Icons**: Directional arrows (change, not state)
- **Visual delta**: If "Better" selected, subtle golden glow
- **Micro-celebration**: "+5 bonus moments" appears gently

### 4.2 Quick Feedback Component

```
┌─────────────────────────────────────┐
│         How was that?               │
│                                     │
│  ┌──────────┐ ┌──────────┐ ┌──────┐│
│  │  Loved   │ │  It was  │ │ Not  ││
│  │   it!    │ │   nice   │ │for me││
│  └──────────┘ └──────────┘ └──────┘│
│                                     │
│   Add a note... (optional)          │
│   ┌─────────────────────────────┐  │
│   │                             │  │
│   └─────────────────────────────┘  │
│                                     │
│           [ Skip ]                  │
└─────────────────────────────────────┘
```

- **"Loved it"**: Heart icon, warm coral background
- **"It was nice"**: Smile icon, neutral sage
- **"Not for me"**: Wave icon (goodbye, not thumbs down)
- **Note field**: Expands on tap, max 200 chars
- **Future use**: Feedback influences suggestion ranking

### 4.3 Warmth Gauge Component

```
        Warmth: Cozy

    ○───○───●───○───○
  Spark Glow Cozy Warm Radiant

    Keep it up! 3 more activities
    to reach Warm.
```

- **Visual**: Horizontal gauge with filled/unfilled dots
- **Labels**: Warm names, not numbers
- **Progress text**: Encouraging, never shaming
- **Decay message**: "Your warmth is gently cooling..." (soft warning)
- **Never**: "Streak broken!" or red indicators

### 4.4 Stamp Gallery Component

```
┌─────────────────────────────────────┐
│         My Stamp Collection         │
│                                     │
│   Journey           3/4 collected   │
│   ┌────┐ ┌────┐ ┌────┐ ┌────┐     │
│   │ ✓  │ │ ✓  │ │ ✓  │ │ ?  │     │
│   │Srvd│ │Reg │ │Freq│ │Hse │     │
│   └────┘ └────┘ └────┘ └────┘     │
│                                     │
│   Explorer          1/5 collected   │
│   ┌────┐ ┌────┐ ┌────┐ ┌────┐     │
│   │ ✓  │ │ ?  │ │ ?  │ │ ?  │     │
│   │Smpl│ │Strt│ │Main│ │Dsrt│     │
│   └────┘ └────┘ └────┘ └────┘     │
│                                     │
└─────────────────────────────────────┘
```

- **Earned stamps**: Inked appearance, slight rotation (3-7°)
- **Locked stamps**: Faded outline, "?" center
- **Tap earned**: Shows date earned, description
- **Tap locked**: Shows requirement, progress
- **Animation**: New stamp "presses" into place

### 4.5 Calendar Grid Component

```
┌─────────────────────────────────────┐
│   < November 2025 >    [Today]      │
│                                     │
│   M   T   W   T   F   S   S        │
│                       1   2        │
│   3   4   5   6   7   8   9        │
│   ●   ○       ●   ●   ●           │
│  10  11  12  13  14  15  16        │
│       ●   ●       ●               │
│  17  18  19  20  21  22  23        │
│   ●   ●   ◐   ●       ●   ●       │
│  24  25  26  27  28  29  30        │
│   ●   ●   ●   ●   ●               │
│                                     │
│   ● Completed  ◐ Mood improved     │
└─────────────────────────────────────┘
```

- **Dots**: Small, elegant, not overwhelming
- **Color coding**:
  - Terracotta ●: Activity completed
  - Forest ◐: Mood improved (half-fill or glow)
  - Mustard: Multiple activities (larger dot)
- **Tap day**: Bottom sheet with day detail
- **Swipe**: Month navigation
- **Empty days**: No indicator (not grayed out)

### 4.6 Season Progress Component

```
┌─────────────────────────────────────┐
│                                     │
│         Season: Golden Hour         │
│              ☀️                      │
│                                     │
│   ════════════════════○──────      │
│   500                  800          │
│       523 Moments collected         │
│                                     │
│   277 more to reach Twilight Calm   │
│                                     │
└─────────────────────────────────────┘
```

- **Season icon**: Nature-based emoji or illustration
- **Progress bar**: Gradient from current to next season color
- **Current marker**: Subtle dot on progress track
- **Milestone text**: Encouraging, shows exact distance

---

## 5. User Journey Flows

### 5.1 Authentication Flow

```
┌──────────────────────────────────────────┐
│                                          │
│   Welcome to your journey.               │
│                                          │
│   Sign in to sync your tiny joys         │
│   across all your devices.               │
│                                          │
│   ┌────────────────────────────────────┐│
│   │       Continue with Apple          ││
│   └────────────────────────────────────┘│
│                                          │
│           Skip for now                   │
│                                          │
│   Your activities stay on this device    │
│   until you sign in.                     │
│                                          │
└──────────────────────────────────────────┘
```

**Post-Sign In:**
```
Welcome, [Name]!

Your journey begins.
Let's collect some moments together.

        [Start exploring]
```

### 5.2 Activity Completion Flow

```
User taps "I'll have this"
        ↓
┌─────────────────────┐
│ Before Mood Check   │ ← Skippable
│ (Low/Okay/Good)     │
└─────────────────────┘
        ↓
┌─────────────────────┐
│ Activity Card       │
│ "You're doing this" │
│ [Mark Complete]     │
└─────────────────────┘
        ↓
┌─────────────────────┐
│ After Mood Check    │ ← Skippable
│ (Lower/Same/Better) │
└─────────────────────┘
        ↓
┌─────────────────────┐
│ Quick Feedback      │ ← Skippable
│ (Loved/Nice/Not)    │
└─────────────────────┘
        ↓
┌─────────────────────┐
│ Celebration Moment  │
│ "+15 moments!"      │
│ "Warmth: Cozy ✨"    │
└─────────────────────┘
```

### 5.3 Stamp Unlock Flow

```
User completes 10th activity
        ↓
┌─────────────────────────────────────┐
│                                     │
│        🏅 New Stamp Earned!         │
│                                     │
│         ┌──────────────┐           │
│         │  REGULAR     │           │
│         │   GUEST      │           │
│         └──────────────┘           │
│           (ink press animation)     │
│                                     │
│   "You've completed 10 activities.  │
│    That's dedication!"              │
│                                     │
│         [View Collection]           │
│              Dismiss                │
│                                     │
└─────────────────────────────────────┘
```

### 5.4 Season Up Flow

```
User reaches 500 moments
        ↓
┌─────────────────────────────────────┐
│                                     │
│     ✨ A New Season Begins ✨       │
│                                     │
│          ☀️ Golden Hour             │
│                                     │
│   The afternoon light warms your    │
│   journey. You've collected 500     │
│   moments of tiny joy.              │
│                                     │
│   🎁 Unlocked: "Morning Café" theme │
│                                     │
│         [Continue Journey]          │
│                                     │
└─────────────────────────────────────┘
```

---

## 6. UX Pattern Decisions

### 6.1 Skip Button Consistency

**Rule**: Every optional prompt has a Skip button with these properties:
- Same visual weight as primary actions (not tiny/hidden)
- Positioned at bottom center or clearly visible
- Copy is neutral: "Skip" not "Skip for now" or "Not now"
- No guilt language in surrounding copy

### 6.2 Progress Without Pressure

**Rule**: All progress indicators follow these patterns:
- Show distance to next milestone, not % complete
- Use encouraging language ("277 more to reach...")
- Never show time-based decay urgency ("Losing streak in 2 days!")
- Warmth gauge cools silently; only gentle reminders in notifications

### 6.3 Celebration Moments

**Rule**: Celebrations are:
- Brief (2-3 seconds before dismissable)
- Contain one key stat (+15 moments!)
- Include one warm message
- Never auto-dismiss too fast; always allow tapping through
- Never block the next action

### 6.4 Empty States

**Rule**: Empty states are warm invitations:
- Calendar empty day: No marker, not grayed out
- Stamp locked: Shows what to do, not "LOCKED"
- No activities today: "Ready for a tiny joy?" not "You haven't done anything"
- First launch: Celebration of beginning, not emptiness

---

## 7. Responsive Design & Accessibility

### 7.1 Dynamic Type Support

| Component | Minimum | Maximum | Behavior |
|-----------|---------|---------|----------|
| Mood icons | Fixed 48pt | Fixed 48pt | Scale touch target only |
| Mood labels | 15pt | 24pt | Wrap to two lines if needed |
| Stat numbers | 32pt | 72pt | Container expands |
| Calendar days | 11pt | 17pt | Grid reflows below 13pt |

### 7.2 VoiceOver Labels

| Component | Label Example |
|-----------|---------------|
| Before mood: Low | "Low energy. Button. Double tap to select." |
| Warmth gauge | "Warmth level: Cozy. 3 of 5. 3 more activities to Warm." |
| Locked stamp | "Stamp locked. Regular Guest. Complete 10 activities to earn." |
| Calendar day | "November 15. 2 activities completed. Mood improved." |
| Skip button | "Skip. Button. Continue without answering." |

### 7.3 Reduce Motion Support

When Reduce Motion is enabled:
- Stamp press animation → Instant appear with checkmark
- Warmth gauge fill → Instant state change
- Season transition → Crossfade without particle effects
- Celebration → Static card without pulse

---

## 8. Implementation Guidance

### 8.1 Component Priority Order

1. **Mood Check-In Views** — Core journey flow
2. **Quick Feedback View** — Post-activity reflection
3. **Warmth Gauge** — Visible on profile
4. **Season Progress** — Profile header
5. **Stamp Gallery** — Profile section
6. **Calendar Grid** — History tab enhancement
7. **Day Detail Sheet** — Calendar drill-down

### 8.2 Animation Specifications

| Animation | Duration | Easing | Trigger |
|-----------|----------|--------|---------|
| Mood select | 200ms | easeOut | On tap |
| Skip dismiss | 150ms | easeIn | On tap |
| Stamp press | 400ms | spring(0.7) | On unlock |
| Season reveal | 600ms | easeInOut | On threshold |
| Warmth fill | 300ms | linear | On change |
| Calendar appear | 250ms | easeOut | On month load |

### 8.3 State Management

**Mood Flow State:**
```swift
enum MoodFlowState {
    case inactive
    case beforePrompt
    case inProgress
    case afterPrompt
    case feedbackPrompt
    case celebration
    case complete
}
```

**Gamification State:**
```swift
struct GamificationState {
    var totalMoments: Int
    var currentSeason: Season
    var warmthLevel: WarmthLevel
    var earnedStamps: [Stamp]
    var unlockedContent: [UnlockableContent]
}
```

---

## Appendix

### Related Documents

- Product Requirements: `docs/prd-v2.md`
- Epic Breakdown: `docs/epics-v2.md`
- Architecture: `docs/bmm-architecture-2025-11-29.md`

### Color Theme CSS Variables

```css
:root {
  /* Season colors */
  --season-first-light: #FFECD2;
  --season-morning-dew: #C8D5BB;
  --season-sunlit-path: #F4D03F;
  --season-afternoon-tea: #D4A574;
  --season-golden-hour: #E67E22;
  --season-twilight-calm: #C39BD3;
  --season-starlit: #5B2C6F;
  --season-full-moon: #85929E;
  --season-aurora: #48C9B0;
  --season-eternal-garden: #27AE60;

  /* Mood spectrum */
  --mood-low: #A9CCE3;
  --mood-okay: #D5DBDB;
  --mood-good: #A9DFBF;
  --mood-lower: #F5B7B1;
  --mood-same: #D5D8DC;
  --mood-better: #F9E79F;

  /* Stamp ink */
  --stamp-journey: #A04000;
  --stamp-explorer: #1E8449;
  --stamp-mood: #6C3483;
  --stamp-time: #1B4F72;
  --stamp-seasonal: #873600;
}
```

### Version History

| Date | Version | Changes | Author |
|------|---------|---------|--------|
| 2025-11-29 | 1.0 | Initial UX Design Specification | BMad |
| 2025-12-01 | 2.0 | Added journey components, gamification UX, mood flows | BMad |

---

_This UX Design Specification was created through collaborative design facilitation with a human-centric approach. Every component prioritizes emotional safety, optional engagement, and celebration without pressure._
