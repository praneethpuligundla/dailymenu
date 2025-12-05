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

## 9. Pro Mode: Activity Management

### 9.1 Design Philosophy

Pro Mode transforms users from **consumers to creators**. The aesthetic shifts subtly to convey "workshop" energy — slightly more utilitarian while maintaining warmth. Think: artisan's workbench, not corporate dashboard.

**Tone**: Empowering without overwhelming. "Your menu, your rules."

### 9.2 My Activities View

```
┌─────────────────────────────────────────────────────┐
│                                                      │
│   My Activities                          [+ Create] │
│   ═══════════════                                   │
│                                                      │
│   ┌─── Created by Me ───────────────────────────┐  │
│   │                                              │  │
│   │  ┌────────────────────────────────────────┐ │  │
│   │  │ ✏️  Morning Stretch Ritual              │ │  │
│   │  │     15 min · Low Energy · Solo          │ │  │
│   │  │     ○────────────────────────────────○  │ │  │
│   │  │               swipe to delete →         │ │  │
│   │  └────────────────────────────────────────┘ │  │
│   │                                              │  │
│   │  ┌────────────────────────────────────────┐ │  │
│   │  │ ✏️  Tea Ceremony for One                │ │  │
│   │  │     20 min · Okay · Solo                │ │  │
│   │  └────────────────────────────────────────┘ │  │
│   │                                              │  │
│   └──────────────────────────────────────────────┘  │
│                                                      │
│   ┌─── Imported from AI ────────────────────────┐  │
│   │                                              │  │
│   │  ┌────────────────────────────────────────┐ │  │
│   │  │ 🤖  Cloud Watching                      │ │  │
│   │  │     10 min · Low · Either               │ │  │
│   │  └────────────────────────────────────────┘ │  │
│   │                                              │  │
│   └──────────────────────────────────────────────┘  │
│                                                      │
│   ┌─── Downloaded from Community ───────────────┐  │
│   │                                              │  │
│   │  ┌────────────────────────────────────────┐ │  │
│   │  │ 🌍  Sunset Appreciation    ★ 4.8       │ │  │
│   │  │     30 min · Okay · Either              │ │  │
│   │  └────────────────────────────────────────┘ │  │
│   │                                              │  │
│   └──────────────────────────────────────────────┘  │
│                                                      │
└─────────────────────────────────────────────────────┘
```

**Source Indicators:**
- ✏️ Created by Me — Editable, deletable
- 🤖 AI Import — Editable, can reset to original
- 🌍 Community — Shows rating, can remove from library

### 9.3 Activity Editor Form

```
┌─────────────────────────────────────────────────────┐
│                                                      │
│   Edit Activity                      [Cancel] [Save]│
│   ═════════════                                     │
│                                                      │
│   Title                                              │
│   ┌─────────────────────────────────────────────┐  │
│   │ Morning Stretch Ritual                       │  │
│   └─────────────────────────────────────────────┘  │
│                                                      │
│   Description                                        │
│   ┌─────────────────────────────────────────────┐  │
│   │ A gentle series of stretches to wake up     │  │
│   │ your body and greet the day with intention. │  │
│   └─────────────────────────────────────────────┘  │
│                                                      │
│   Time                                               │
│   ┌────────┐                                        │
│   │ 15 min │  ◀ ─────●───────────── ▶              │
│   └────────┘    5              60                   │
│                                                      │
│   Energy Level                                       │
│   ┌─────────────────────────────────────────────┐  │
│   │  [ Low ]    ( Okay )    ( Up for It )       │  │
│   └─────────────────────────────────────────────┘  │
│                                                      │
│   Context                                            │
│   ┌─────────────────────────────────────────────┐  │
│   │  [ Solo ]    ( With Someone )   ( Either )  │  │
│   └─────────────────────────────────────────────┘  │
│                                                      │
│   Category                                           │
│   ┌─────────────────────────────────────────────┐  │
│   │  Starter ▾                                   │  │
│   └─────────────────────────────────────────────┘  │
│                                                      │
│   Tags                                               │
│   ┌─────────────────────────────────────────────┐  │
│   │  [morning] [movement] [mindful] [+ Add]     │  │
│   └─────────────────────────────────────────────┘  │
│                                                      │
│   Personal Notes (only visible to you)              │
│   ┌─────────────────────────────────────────────┐  │
│   │ Best done before coffee!                     │  │
│   └─────────────────────────────────────────────┘  │
│                                                      │
│   ┌─────────────────────────────────────────────┐  │
│   │  □ Share to Community                        │  │
│   │    Others can discover and try this activity │  │
│   └─────────────────────────────────────────────┘  │
│                                                      │
│             [ Reset to Original ]                   │
│                                                      │
└─────────────────────────────────────────────────────┘
```

**Form Design:**
- **Typography**: Slightly monospace for form labels (workshop feel)
- **Validation**: Inline, gentle ("Title needs 3+ characters")
- **Slider**: Custom styled with vintage aesthetic
- **Tags**: Pill-shaped, removable with × button
- **Personal Notes**: Italic style, clearly marked as private

---

## 10. Community Library

### 10.1 Design Philosophy

The Community tab is a **marketplace of tiny joys** — a curated bazaar of activities contributed by fellow journeyers. The aesthetic blends the app's vintage warmth with subtle "social" indicators: votes, ratings, contributor attribution.

**Aesthetic Direction**: "Vintage bulletin board meets modern app store"
- Pinned cards with subtle paper texture
- Hand-written style contributor names
- Star ratings with ink-stamp style
- Warm amber accent for "trending" indicators

### 10.2 Extended Color Palette

```css
:root {
  /* Community-specific colors */
  --community-trending: #D35400;      /* Warm amber for trending */
  --community-new: #2ECC71;           /* Fresh green for new */
  --community-staff-pick: #8E44AD;    /* Purple for curated */
  --community-downloaded: #27AE60;    /* Green checkmark */

  /* Vote colors */
  --vote-up: #E67E22;                 /* Warm orange */
  --vote-down: #95A5A6;               /* Muted gray */
  --vote-active: #D35400;             /* Darker when selected */

  /* Rating stars */
  --star-filled: #F1C40F;             /* Golden yellow */
  --star-empty: #D5D8DC;              /* Light gray */

  /* Pack theme colors */
  --pack-creative: #E74C3C;
  --pack-nature: #27AE60;
  --pack-mindful: #9B59B6;
  --pack-desk: #3498DB;
  --pack-couples: #E91E63;
}
```

### 10.3 Community Browse View

```
┌─────────────────────────────────────────────────────┐
│                                                      │
│   Community                           🔍             │
│   ═════════                                         │
│                                                      │
│   ┌─────────────────────────────────────────────┐  │
│   │  Trending  │  Newest  │  Top Rated  │ Packs │  │
│   └─────────────────────────────────────────────┘  │
│                                                      │
│   Filter: [All ▾]  [Any Energy ▾]  [Any Time ▾]    │
│                                                      │
│   ┌────────────────────┐  ┌────────────────────┐  │
│   │ ░░░░░░░░░░░░░░░░░░ │  │ ░░░░░░░░░░░░░░░░░░ │  │
│   │ 🔥 TRENDING        │  │                     │  │
│   │                     │  │                     │  │
│   │ Sunset Walk         │  │ Desk Plant Care    │  │
│   │ ★★★★★ 4.9 (127)    │  │ ★★★★☆ 4.2 (43)    │  │
│   │                     │  │                     │  │
│   │ 30 min · Low · Solo │  │ 5 min · Low · Solo │  │
│   │                     │  │                     │  │
│   │ ▲ 234    by @maya   │  │ ▲ 89     by @jun   │  │
│   │                     │  │                     │  │
│   │ [+ Add to Menu]     │  │ [+ Add to Menu]     │  │
│   └────────────────────┘  └────────────────────┘  │
│                                                      │
│   ┌────────────────────┐  ┌────────────────────┐  │
│   │                     │  │ ✓ DOWNLOADED       │  │
│   │ Gratitude Moment    │  │                     │  │
│   │ ★★★★★ 4.7 (89)     │  │ Morning Pages      │  │
│   │                     │  │ ★★★★☆ 4.4 (156)   │  │
│   │ 10 min · Okay · Solo│  │                     │  │
│   │                     │  │ 20 min · Okay · Solo│  │
│   │ ▲ 156    by @river  │  │                     │  │
│   │                     │  │ ▲ 312    by @sam   │  │
│   │ [+ Add to Menu]     │  │ [In My Menu ✓]     │  │
│   └────────────────────┘  └────────────────────┘  │
│                                                      │
└─────────────────────────────────────────────────────┘
```

**Card Elements:**
- **Trending Badge**: 🔥 with warm orange background
- **Downloaded Badge**: ✓ checkmark in green
- **Rating**: Stars + numeric + count
- **Vote Count**: ▲ with count (no downvote shown on cards)
- **Attribution**: "by @username" in handwritten style
- **Category Color**: Subtle left border in category color

### 10.4 Activity Detail (Community)

```
┌─────────────────────────────────────────────────────┐
│                                                      │
│   ←  Activity Detail                                │
│                                                      │
│   ┌─────────────────────────────────────────────┐  │
│   │                                              │  │
│   │          ☀️  Sunset Walk                    │  │
│   │                                              │  │
│   │      "A simple walk timed with sunset to    │  │
│   │       watch the sky paint itself."          │  │
│   │                                              │  │
│   └─────────────────────────────────────────────┘  │
│                                                      │
│   ┌─────────────────────────────────────────────┐  │
│   │  30 min  │  Low Energy  │  Solo or Together │  │
│   └─────────────────────────────────────────────┘  │
│                                                      │
│   Tags                                               │
│   [outdoor] [nature] [evening] [mindful]            │
│                                                      │
│   ─────────────────────────────────────────────────│
│                                                      │
│   ┌─────────────────────────────────────────────┐  │
│   │                                              │  │
│   │      ▲                    ▼                 │  │
│   │    [ 234 ]              [ 12 ]              │  │
│   │   Upvote               Downvote             │  │
│   │                                              │  │
│   └─────────────────────────────────────────────┘  │
│                                                      │
│   Your Rating                                        │
│   ┌─────────────────────────────────────────────┐  │
│   │                                              │  │
│   │      ★     ★     ★     ★     ☆             │  │
│   │                                              │  │
│   │      Tap to rate this activity              │  │
│   │                                              │  │
│   └─────────────────────────────────────────────┘  │
│                                                      │
│   ─────────────────────────────────────────────────│
│                                                      │
│   Contributed by                                    │
│   ┌─────────────────────────────────────────────┐  │
│   │  @maya · Season 7 · 23 activities shared    │  │
│   └─────────────────────────────────────────────┘  │
│                                                      │
│   ┌─────────────────────────────────────────────┐  │
│   │                                              │  │
│   │          [ + Add to My Menu ]               │  │
│   │                                              │  │
│   └─────────────────────────────────────────────┘  │
│                                                      │
│   ┌─────────────────────────────────────────────┐  │
│   │  ⚑ Report  │  ↗ Share  │  ♡ Save to List  │  │
│   └─────────────────────────────────────────────┘  │
│                                                      │
│   ─────────────────────────────────────────────────│
│                                                      │
│   Recent Reviews (23)                               │
│                                                      │
│   ┌─────────────────────────────────────────────┐  │
│   │  @river · ★★★★★                            │  │
│   │  "This became my evening ritual. So         │  │
│   │   peaceful watching colors change."         │  │
│   │                                   3 days ago│  │
│   └─────────────────────────────────────────────┘  │
│                                                      │
│   ┌─────────────────────────────────────────────┐  │
│   │  @jun · ★★★★☆                              │  │
│   │  "Great activity. Timing with actual sunset │  │
│   │   can be tricky with weather!"              │  │
│   │                                   1 week ago│  │
│   └─────────────────────────────────────────────┘  │
│                                                      │
└─────────────────────────────────────────────────────┘
```

### 10.5 Activity Packs Gallery

```
┌─────────────────────────────────────────────────────┐
│                                                      │
│   Activity Packs                                    │
│   ══════════════                                    │
│                                                      │
│   Unlock themed collections as you progress         │
│                                                      │
│   ┌─────────────────────────────────────────────┐  │
│   │ ████████████████████████████████████████████│  │
│   │ ████████████████████████████████████████████│  │
│   │ ████████  CREATIVE SPARKS  █████████████████│  │
│   │ ████████████████████████████████████████████│  │
│   │                                              │  │
│   │  10 art & music activities to ignite        │  │
│   │  creativity                                  │  │
│   │                                              │  │
│   │  🔓 Unlocked at Season 2                    │  │
│   │  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━○            │  │
│   │  23/50 Moments to unlock                    │  │
│   │                                              │  │
│   └─────────────────────────────────────────────┘  │
│                                                      │
│   ┌─────────────────────────────────────────────┐  │
│   │ ████████████████████████████████████████████│  │
│   │ ████████  NATURE'S MENU  ███████████████████│  │
│   │ ████████████████████████████████████████████│  │
│   │                                              │  │
│   │  10 outdoor activities to reconnect         │  │
│   │                                              │  │
│   │  🔒 Unlocks at Season 3                     │  │
│   │                                              │  │
│   └─────────────────────────────────────────────┘  │
│                                                      │
│   ─────────────────────────────────────────────────│
│                                                      │
│   Free Packs                                        │
│                                                      │
│   ┌─────────────────────────────────────────────┐  │
│   │ ████████  DESK BREAKS  █████████████████████│  │
│   │                                              │  │
│   │  10 quick activities for work breaks        │  │
│   │                                              │  │
│   │  ✓ FREE                 [Download Pack]     │  │
│   │                                              │  │
│   └─────────────────────────────────────────────┘  │
│                                                      │
└─────────────────────────────────────────────────────┘
```

**Pack Card Design:**
- **Cover Image**: Full-bleed with theme color overlay
- **Title**: White text with subtle shadow
- **Lock State**: 🔓 unlockable vs 🔒 locked
- **Progress Bar**: Shows Moments progress to unlock
- **Free Badge**: Green "FREE" indicator

### 10.6 Search Experience

```
┌─────────────────────────────────────────────────────┐
│                                                      │
│   ┌─────────────────────────────────────────────┐  │
│   │ 🔍  Search activities...              ✕     │  │
│   └─────────────────────────────────────────────┘  │
│                                                      │
│   Recent Searches                                    │
│   ┌─────────────────────────────────────────────┐  │
│   │  🕐 meditation    🕐 morning    🕐 outdoor  │  │
│   └─────────────────────────────────────────────┘  │
│                                                      │
│   Popular Categories                                 │
│   ┌────────┐  ┌────────┐  ┌────────┐  ┌────────┐  │
│   │Mindful │  │Movement│  │Creative│  │ Social │  │
│   └────────┘  └────────┘  └────────┘  └────────┘  │
│                                                      │
│   ─────────────────────────────────────────────────│
│                                                      │
│   Searching: "evening ritual"                       │
│                                                      │
│   23 results                                        │
│                                                      │
│   ┌─────────────────────────────────────────────┐  │
│   │  Evening Tea Ceremony        ★ 4.8 (67)    │  │
│   │  "A calming ritual to close the day..."     │  │
│   │  20 min · Low · Solo          ▲ 145         │  │
│   └─────────────────────────────────────────────┘  │
│                                                      │
│   ┌─────────────────────────────────────────────┐  │
│   │  Sunset Journaling           ★ 4.6 (34)    │  │
│   │  "Write down three good things from..."     │  │
│   │  15 min · Okay · Solo         ▲ 89          │  │
│   └─────────────────────────────────────────────┘  │
│                                                      │
│   ─────────────────────────────────────────────────│
│                                                      │
│   No luck? Try browsing by category or             │
│   create your own activity!                         │
│                                                      │
└─────────────────────────────────────────────────────┘
```

### 10.7 Submit to Community Flow

```
┌─────────────────────────────────────────────────────┐
│                                                      │
│   Share to Community                                │
│   ══════════════════                                │
│                                                      │
│   ┌─────────────────────────────────────────────┐  │
│   │                                              │  │
│   │  You're sharing:                            │  │
│   │                                              │  │
│   │  "Morning Stretch Ritual"                   │  │
│   │   15 min · Low Energy · Solo                │  │
│   │                                              │  │
│   └─────────────────────────────────────────────┘  │
│                                                      │
│   Before submitting, please confirm:                │
│                                                      │
│   ☑️  This activity is appropriate for all ages    │
│   ☑️  I created this or have permission to share   │
│   ☑️  It doesn't contain personal information      │
│                                                      │
│   ─────────────────────────────────────────────────│
│                                                      │
│   What happens next:                                │
│                                                      │
│   1. Your activity goes to our review queue        │
│   2. We'll check it within 24 hours                │
│   3. Once approved, it appears in Community        │
│   4. You'll earn the "Contributor" stamp!          │
│                                                      │
│   ┌─────────────────────────────────────────────┐  │
│   │                                              │  │
│   │         [ Submit for Review ]               │  │
│   │                                              │  │
│   └─────────────────────────────────────────────┘  │
│                                                      │
│                   Cancel                            │
│                                                      │
└─────────────────────────────────────────────────────┘
```

**Submission Confirmation:**
```
┌─────────────────────────────────────────────────────┐
│                                                      │
│              ✓ Submitted!                           │
│                                                      │
│   Your activity is in the review queue.            │
│                                                      │
│   We'll notify you when it's approved              │
│   (usually within 24 hours).                       │
│                                                      │
│   Track your submissions in                         │
│   Profile → My Submissions                          │
│                                                      │
│             [ View My Submissions ]                 │
│                                                      │
│                    Done                             │
│                                                      │
└─────────────────────────────────────────────────────┘
```

### 10.8 Community Component Specifications

| Component | Animation | Duration | Notes |
|-----------|-----------|----------|-------|
| Vote button tap | Scale bounce + color fill | 150ms | Optimistic UI - immediate visual feedback |
| Star rating | Sequential fill with delay | 50ms per star | Left-to-right cascade |
| Card download | Checkmark draw animation | 300ms | Line draws in, then fills |
| Search results | Staggered fade-in | 75ms delay each | Top to bottom cascade |
| Pack unlock | Burst particles + scale | 800ms | Celebration moment |

### 10.9 Offline Behavior

| State | Visual Treatment |
|-------|------------------|
| Cached browsing | Normal display with "Last updated X ago" |
| No cache | Empty state: "Connect to explore community" |
| Offline vote | Ghost state + "Will sync when online" |
| Offline download | Disabled with "Requires connection" |

---

## Appendix

### Related Documents

- Product Requirements: `docs/prd-v2.md`
- Epic Breakdown: `docs/epics-v2.md`
- Architecture: `docs/bmm-architecture-2025-11-29.md`
- Supabase Schema: `docs/supabase-schema.md`

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
| 2025-12-04 | 2.1 | Added Pro Mode and Community Library UX components | BMad |

---

_This UX Design Specification was created through collaborative design facilitation with a human-centric approach. Every component prioritizes emotional safety, optional engagement, and celebration without pressure._
