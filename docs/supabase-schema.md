# DailyMenu Community Library - Supabase Schema

## Overview

Supabase PostgreSQL schema for a centralized community activity store with voting, ratings, categories, and moderation.

**Supabase Benefits:**
- Real SQL with JOINs, transactions, aggregates
- Row Level Security (RLS) for fine-grained access control
- Edge Functions for server-side logic
- Real-time subscriptions
- Works cross-platform (iOS, Android, Web)
- Free tier: 500MB database, 2GB transfer, 50K monthly active users

---

## Database Schema

```sql
-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================
-- USERS (extends Supabase auth.users)
-- ============================================
CREATE TABLE public.profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    display_name TEXT,
    avatar_url TEXT,
    apple_user_id TEXT UNIQUE,  -- For Sign in with Apple
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),

    -- Gamification (synced from app)
    total_moments INTEGER DEFAULT 0,
    current_season INTEGER DEFAULT 1,

    -- Moderation
    is_moderator BOOLEAN DEFAULT FALSE,
    is_banned BOOLEAN DEFAULT FALSE
);

-- ============================================
-- CATEGORIES
-- ============================================
CREATE TABLE public.categories (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    slug TEXT UNIQUE NOT NULL,  -- 'starter', 'main', 'dessert', 'low-battery'
    name TEXT NOT NULL,
    description TEXT,
    icon TEXT,  -- SF Symbol name or emoji
    sort_order INTEGER DEFAULT 0
);

-- Seed default categories
INSERT INTO public.categories (slug, name, description, icon, sort_order) VALUES
    ('starter', 'Starters', '5-10 minute quick activities', 'sparkles', 1),
    ('main', 'Mains', '15-30 minute activities', 'fork.knife', 2),
    ('dessert', 'Desserts', '30-60 minute indulgences', 'birthday.cake', 3),
    ('connection', 'Connection', 'Activities with others', 'person.2', 4),
    ('low-battery', 'Low Battery', 'When energy is low', 'battery.25', 5);

-- ============================================
-- ACTIVITIES (Community Library)
-- ============================================
CREATE TABLE public.activities (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

    -- Core fields
    title TEXT NOT NULL,
    description TEXT NOT NULL,
    expected_minutes INTEGER NOT NULL CHECK (expected_minutes > 0),
    energy TEXT NOT NULL CHECK (energy IN ('low', 'okay', 'upForSomething')),
    context TEXT NOT NULL CHECK (context IN ('solo', 'withSomeone', 'either')),
    category_id UUID REFERENCES public.categories(id),
    tags TEXT[] DEFAULT '{}',

    -- Metadata
    submitted_by UUID REFERENCES public.profiles(id),
    source TEXT DEFAULT 'community',  -- 'community', 'official', 'ai-curated'
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),

    -- Moderation
    moderation_status TEXT DEFAULT 'pending'
        CHECK (moderation_status IN ('pending', 'approved', 'rejected', 'flagged')),
    moderated_by UUID REFERENCES public.profiles(id),
    moderated_at TIMESTAMPTZ,
    rejection_reason TEXT,

    -- Aggregated stats (denormalized for performance)
    upvotes INTEGER DEFAULT 0,
    downvotes INTEGER DEFAULT 0,
    vote_score INTEGER GENERATED ALWAYS AS (upvotes - downvotes) STORED,
    rating_sum INTEGER DEFAULT 0,
    rating_count INTEGER DEFAULT 0,
    average_rating DECIMAL(3,2) GENERATED ALWAYS AS (
        CASE WHEN rating_count > 0 THEN rating_sum::DECIMAL / rating_count ELSE 0 END
    ) STORED,
    download_count INTEGER DEFAULT 0,
    report_count INTEGER DEFAULT 0
);

-- Indexes for common queries
CREATE INDEX idx_activities_status ON public.activities(moderation_status);
CREATE INDEX idx_activities_category ON public.activities(category_id);
CREATE INDEX idx_activities_energy ON public.activities(energy);
CREATE INDEX idx_activities_vote_score ON public.activities(vote_score DESC);
CREATE INDEX idx_activities_rating ON public.activities(average_rating DESC);
CREATE INDEX idx_activities_created ON public.activities(created_at DESC);
CREATE INDEX idx_activities_tags ON public.activities USING GIN(tags);

-- ============================================
-- VOTES
-- ============================================
CREATE TABLE public.votes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    activity_id UUID NOT NULL REFERENCES public.activities(id) ON DELETE CASCADE,
    vote_type TEXT NOT NULL CHECK (vote_type IN ('up', 'down')),
    created_at TIMESTAMPTZ DEFAULT NOW(),

    -- One vote per user per activity
    UNIQUE(user_id, activity_id)
);

CREATE INDEX idx_votes_activity ON public.votes(activity_id);

-- ============================================
-- RATINGS
-- ============================================
CREATE TABLE public.ratings (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    activity_id UUID NOT NULL REFERENCES public.activities(id) ON DELETE CASCADE,
    rating INTEGER NOT NULL CHECK (rating BETWEEN 1 AND 5),
    review TEXT,  -- Optional review text
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),

    -- One rating per user per activity
    UNIQUE(user_id, activity_id)
);

CREATE INDEX idx_ratings_activity ON public.ratings(activity_id);

-- ============================================
-- REPORTS (Flagging inappropriate content)
-- ============================================
CREATE TABLE public.reports (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    reporter_id UUID NOT NULL REFERENCES public.profiles(id),
    activity_id UUID NOT NULL REFERENCES public.activities(id) ON DELETE CASCADE,
    reason TEXT NOT NULL CHECK (reason IN (
        'inappropriate', 'spam', 'harmful', 'duplicate', 'other'
    )),
    details TEXT,
    status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'reviewed', 'dismissed')),
    reviewed_by UUID REFERENCES public.profiles(id),
    reviewed_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW(),

    -- One report per user per activity
    UNIQUE(reporter_id, activity_id)
);

-- ============================================
-- USER DOWNLOADS (track which activities users have)
-- ============================================
CREATE TABLE public.user_downloads (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    activity_id UUID NOT NULL REFERENCES public.activities(id) ON DELETE CASCADE,
    downloaded_at TIMESTAMPTZ DEFAULT NOW(),

    UNIQUE(user_id, activity_id)
);

-- ============================================
-- COLLECTIONS (User-created lists)
-- ============================================
CREATE TABLE public.collections (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT,
    is_public BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE public.collection_items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    collection_id UUID NOT NULL REFERENCES public.collections(id) ON DELETE CASCADE,
    activity_id UUID NOT NULL REFERENCES public.activities(id) ON DELETE CASCADE,
    sort_order INTEGER DEFAULT 0,
    added_at TIMESTAMPTZ DEFAULT NOW(),

    UNIQUE(collection_id, activity_id)
);
```

---

## Row Level Security (RLS) Policies

```sql
-- Enable RLS on all tables
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.activities ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.votes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.ratings ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.reports ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_downloads ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.collections ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.collection_items ENABLE ROW LEVEL SECURITY;

-- ============================================
-- PROFILES POLICIES
-- ============================================
CREATE POLICY "Public profiles are viewable by everyone"
    ON public.profiles FOR SELECT
    USING (true);

CREATE POLICY "Users can update own profile"
    ON public.profiles FOR UPDATE
    USING (auth.uid() = id);

-- ============================================
-- ACTIVITIES POLICIES
-- ============================================
CREATE POLICY "Approved activities are viewable by everyone"
    ON public.activities FOR SELECT
    USING (moderation_status = 'approved' OR submitted_by = auth.uid());

CREATE POLICY "Authenticated users can submit activities"
    ON public.activities FOR INSERT
    WITH CHECK (auth.uid() = submitted_by);

CREATE POLICY "Users can update own pending activities"
    ON public.activities FOR UPDATE
    USING (auth.uid() = submitted_by AND moderation_status = 'pending');

CREATE POLICY "Moderators can update any activity"
    ON public.activities FOR UPDATE
    USING (
        EXISTS (
            SELECT 1 FROM public.profiles
            WHERE id = auth.uid() AND is_moderator = true
        )
    );

-- ============================================
-- VOTES POLICIES
-- ============================================
CREATE POLICY "Votes are viewable by everyone"
    ON public.votes FOR SELECT
    USING (true);

CREATE POLICY "Users can vote"
    ON public.votes FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can change own vote"
    ON public.votes FOR UPDATE
    USING (auth.uid() = user_id);

CREATE POLICY "Users can remove own vote"
    ON public.votes FOR DELETE
    USING (auth.uid() = user_id);

-- ============================================
-- RATINGS POLICIES
-- ============================================
CREATE POLICY "Ratings are viewable by everyone"
    ON public.ratings FOR SELECT
    USING (true);

CREATE POLICY "Users can rate activities"
    ON public.ratings FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own rating"
    ON public.ratings FOR UPDATE
    USING (auth.uid() = user_id);

-- ============================================
-- REPORTS POLICIES
-- ============================================
CREATE POLICY "Users can report activities"
    ON public.reports FOR INSERT
    WITH CHECK (auth.uid() = reporter_id);

CREATE POLICY "Users can view own reports"
    ON public.reports FOR SELECT
    USING (auth.uid() = reporter_id);

CREATE POLICY "Moderators can view all reports"
    ON public.reports FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM public.profiles
            WHERE id = auth.uid() AND is_moderator = true
        )
    );
```

---

## Database Functions & Triggers

```sql
-- ============================================
-- AUTO-UPDATE vote counts on activities
-- ============================================
CREATE OR REPLACE FUNCTION update_activity_votes()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        UPDATE public.activities SET
            upvotes = upvotes + CASE WHEN NEW.vote_type = 'up' THEN 1 ELSE 0 END,
            downvotes = downvotes + CASE WHEN NEW.vote_type = 'down' THEN 1 ELSE 0 END
        WHERE id = NEW.activity_id;
        RETURN NEW;
    ELSIF TG_OP = 'UPDATE' THEN
        UPDATE public.activities SET
            upvotes = upvotes
                + CASE WHEN NEW.vote_type = 'up' THEN 1 ELSE 0 END
                - CASE WHEN OLD.vote_type = 'up' THEN 1 ELSE 0 END,
            downvotes = downvotes
                + CASE WHEN NEW.vote_type = 'down' THEN 1 ELSE 0 END
                - CASE WHEN OLD.vote_type = 'down' THEN 1 ELSE 0 END
        WHERE id = NEW.activity_id;
        RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
        UPDATE public.activities SET
            upvotes = upvotes - CASE WHEN OLD.vote_type = 'up' THEN 1 ELSE 0 END,
            downvotes = downvotes - CASE WHEN OLD.vote_type = 'down' THEN 1 ELSE 0 END
        WHERE id = OLD.activity_id;
        RETURN OLD;
    END IF;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_vote_change
    AFTER INSERT OR UPDATE OR DELETE ON public.votes
    FOR EACH ROW EXECUTE FUNCTION update_activity_votes();

-- ============================================
-- AUTO-UPDATE rating stats on activities
-- ============================================
CREATE OR REPLACE FUNCTION update_activity_ratings()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        UPDATE public.activities SET
            rating_sum = rating_sum + NEW.rating,
            rating_count = rating_count + 1
        WHERE id = NEW.activity_id;
        RETURN NEW;
    ELSIF TG_OP = 'UPDATE' THEN
        UPDATE public.activities SET
            rating_sum = rating_sum + NEW.rating - OLD.rating
        WHERE id = NEW.activity_id;
        RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
        UPDATE public.activities SET
            rating_sum = rating_sum - OLD.rating,
            rating_count = rating_count - 1
        WHERE id = OLD.activity_id;
        RETURN OLD;
    END IF;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_rating_change
    AFTER INSERT OR UPDATE OR DELETE ON public.ratings
    FOR EACH ROW EXECUTE FUNCTION update_activity_ratings();

-- ============================================
-- AUTO-UPDATE download count
-- ============================================
CREATE OR REPLACE FUNCTION update_download_count()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE public.activities SET
        download_count = download_count + 1
    WHERE id = NEW.activity_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_download
    AFTER INSERT ON public.user_downloads
    FOR EACH ROW EXECUTE FUNCTION update_download_count();

-- ============================================
-- AUTO-UPDATE report count & flag activity
-- ============================================
CREATE OR REPLACE FUNCTION update_report_count()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE public.activities SET
        report_count = report_count + 1,
        moderation_status = CASE
            WHEN report_count + 1 >= 5 THEN 'flagged'
            ELSE moderation_status
        END
    WHERE id = NEW.activity_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_report
    AFTER INSERT ON public.reports
    FOR EACH ROW EXECUTE FUNCTION update_report_count();

-- ============================================
-- UPDATE timestamps
-- ============================================
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_profiles_updated_at
    BEFORE UPDATE ON public.profiles
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER update_activities_updated_at
    BEFORE UPDATE ON public.activities
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER update_ratings_updated_at
    BEFORE UPDATE ON public.ratings
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();
```

---

## Example Queries

```sql
-- ============================================
-- Browse approved activities (with category)
-- ============================================
SELECT
    a.*,
    c.name as category_name,
    c.icon as category_icon,
    p.display_name as submitted_by_name
FROM public.activities a
JOIN public.categories c ON a.category_id = c.id
LEFT JOIN public.profiles p ON a.submitted_by = p.id
WHERE a.moderation_status = 'approved'
ORDER BY a.vote_score DESC, a.created_at DESC
LIMIT 20;

-- ============================================
-- Top rated low-energy activities
-- ============================================
SELECT * FROM public.activities
WHERE moderation_status = 'approved'
    AND energy = 'low'
    AND rating_count >= 5  -- Minimum ratings threshold
ORDER BY average_rating DESC, vote_score DESC
LIMIT 10;

-- ============================================
-- Search activities by tags
-- ============================================
SELECT * FROM public.activities
WHERE moderation_status = 'approved'
    AND tags && ARRAY['relaxing', 'indoor']  -- Has any of these tags
ORDER BY vote_score DESC;

-- ============================================
-- Activities user hasn't downloaded yet
-- ============================================
SELECT a.* FROM public.activities a
WHERE a.moderation_status = 'approved'
    AND NOT EXISTS (
        SELECT 1 FROM public.user_downloads d
        WHERE d.activity_id = a.id AND d.user_id = 'USER_UUID'
    )
ORDER BY a.vote_score DESC
LIMIT 20;

-- ============================================
-- User's vote status on activities
-- ============================================
SELECT
    a.*,
    v.vote_type as user_vote,
    r.rating as user_rating
FROM public.activities a
LEFT JOIN public.votes v ON v.activity_id = a.id AND v.user_id = 'USER_UUID'
LEFT JOIN public.ratings r ON r.activity_id = a.id AND r.user_id = 'USER_UUID'
WHERE a.moderation_status = 'approved';

-- ============================================
-- Moderation queue
-- ============================================
SELECT
    a.*,
    p.display_name as submitted_by_name,
    COUNT(r.id) as report_count
FROM public.activities a
LEFT JOIN public.profiles p ON a.submitted_by = p.id
LEFT JOIN public.reports r ON r.activity_id = a.id
WHERE a.moderation_status IN ('pending', 'flagged')
GROUP BY a.id, p.display_name
ORDER BY a.report_count DESC, a.created_at ASC;
```

---

## Swift Client Example

```swift
import Supabase

// Initialize client
let supabase = SupabaseClient(
    supabaseURL: URL(string: "https://your-project.supabase.co")!,
    supabaseKey: "your-anon-key"
)

// ============================================
// Fetch top activities
// ============================================
struct CommunityActivity: Codable {
    let id: UUID
    let title: String
    let description: String
    let expectedMinutes: Int
    let energy: String
    let context: String
    let tags: [String]
    let upvotes: Int
    let downvotes: Int
    let voteScore: Int
    let averageRating: Double
    let downloadCount: Int
    let categoryName: String?
    let submittedByName: String?
}

func fetchTopActivities() async throws -> [CommunityActivity] {
    let response = try await supabase
        .from("activities")
        .select("""
            *,
            categories(name),
            profiles!submitted_by(display_name)
        """)
        .eq("moderation_status", value: "approved")
        .order("vote_score", ascending: false)
        .limit(20)
        .execute()

    return try response.decoded()
}

// ============================================
// Vote on activity
// ============================================
func vote(activityId: UUID, voteType: String) async throws {
    let userId = supabase.auth.currentUser?.id

    try await supabase
        .from("votes")
        .upsert([
            "user_id": userId,
            "activity_id": activityId,
            "vote_type": voteType
        ])
        .execute()
}

// ============================================
// Submit new activity
// ============================================
func submitActivity(_ activity: NewActivity) async throws {
    let userId = supabase.auth.currentUser?.id

    try await supabase
        .from("activities")
        .insert([
            "title": activity.title,
            "description": activity.description,
            "expected_minutes": activity.expectedMinutes,
            "energy": activity.energy,
            "context": activity.context,
            "category_id": activity.categoryId,
            "tags": activity.tags,
            "submitted_by": userId
        ])
        .execute()
}

// ============================================
// Sign in with Apple
// ============================================
func signInWithApple(idToken: String, nonce: String) async throws {
    try await supabase.auth.signInWithIdToken(
        credentials: .init(
            provider: .apple,
            idToken: idToken,
            nonce: nonce
        )
    )
}
```

---

## Comparison Summary

| Feature | CloudKit | Supabase |
|---------|----------|----------|
| Vote counting | Manual + race conditions | Automatic via triggers |
| Rating aggregation | Manual calculation | Auto-computed columns |
| Moderation | CloudKit Console only | SQL + can build admin UI |
| Search | Basic `CONTAINS` | Full-text, fuzzy, vectors |
| Access control | Limited | Row Level Security |
| Cross-platform | Apple only | iOS, Android, Web, etc. |
| Offline sync | Built-in | Need to implement |
| Cost | Free (generous) | Free tier, then $25/mo |
| Complexity | Lower | Higher (but more capable) |

---

## Recommendation

**Use Supabase for community library** + **CloudKit for personal sync**:

```
┌─────────────────────────────────────────────────────────┐
│                      DailyMenu                           │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  Personal Data (CloudKit Private)    Community (Supabase)│
│  ┌─────────────────────────────┐    ┌─────────────────┐ │
│  │ • History                   │    │ • Browse        │ │
│  │ • Favorites                 │    │ • Vote/Rate     │ │
│  │ • Gamification              │    │ • Submit        │ │
│  │ • Mood entries              │    │ • Collections   │ │
│  │ • Preferences               │    │ • Moderation    │ │
│  └─────────────────────────────┘    └─────────────────┘ │
│              ↓                              ↓            │
│         iCloud                      PostgreSQL          │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

This gives you the best of both worlds:
- CloudKit for seamless Apple device sync (offline-first, free)
- Supabase for community features (powerful queries, cross-platform ready)

---

## Edge Functions (Server-Side Logic)

### Content Moderation with AI

```typescript
// supabase/functions/moderate-activity/index.ts
import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

serve(async (req) => {
  const { activityId } = await req.json()

  const supabase = createClient(
    Deno.env.get('SUPABASE_URL')!,
    Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
  )

  // Fetch activity
  const { data: activity } = await supabase
    .from('activities')
    .select('*')
    .eq('id', activityId)
    .single()

  // AI moderation check (using OpenAI or Claude)
  const moderationResult = await checkContentSafety(activity.title, activity.description)

  if (moderationResult.flagged) {
    await supabase
      .from('activities')
      .update({
        moderation_status: 'rejected',
        rejection_reason: moderationResult.reason
      })
      .eq('id', activityId)

    return new Response(JSON.stringify({ approved: false, reason: moderationResult.reason }))
  }

  // Auto-approve safe content
  await supabase
    .from('activities')
    .update({ moderation_status: 'approved' })
    .eq('id', activityId)

  return new Response(JSON.stringify({ approved: true }))
})

async function checkContentSafety(title: string, description: string) {
  // Integrate with OpenAI Moderation API or custom checks
  const prohibited = ['spam', 'nsfw', 'harmful']
  const text = `${title} ${description}`.toLowerCase()

  for (const word of prohibited) {
    if (text.includes(word)) {
      return { flagged: true, reason: `Contains prohibited content: ${word}` }
    }
  }

  return { flagged: false }
}
```

### Weekly Digest Email

```typescript
// supabase/functions/weekly-digest/index.ts
serve(async (req) => {
  const supabase = createClient(
    Deno.env.get('SUPABASE_URL')!,
    Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
  )

  // Get trending activities from past week
  const { data: trending } = await supabase
    .from('activities')
    .select('*')
    .eq('moderation_status', 'approved')
    .gte('created_at', new Date(Date.now() - 7 * 24 * 60 * 60 * 1000).toISOString())
    .order('vote_score', { ascending: false })
    .limit(5)

  // Get users who opted in for digest
  const { data: users } = await supabase
    .from('profiles')
    .select('id, display_name, email')
    .eq('digest_enabled', true)

  // Send emails via Resend/SendGrid
  for (const user of users) {
    await sendDigestEmail(user, trending)
  }

  return new Response(JSON.stringify({ sent: users.length }))
})
```

---

## Full-Text Search Setup

```sql
-- Enable full-text search on activities
ALTER TABLE public.activities ADD COLUMN IF NOT EXISTS search_vector tsvector;

-- Generate search vector from title, description, and tags
CREATE OR REPLACE FUNCTION activities_search_vector_update() RETURNS trigger AS $$
BEGIN
  NEW.search_vector :=
    setweight(to_tsvector('english', COALESCE(NEW.title, '')), 'A') ||
    setweight(to_tsvector('english', COALESCE(NEW.description, '')), 'B') ||
    setweight(to_tsvector('english', array_to_string(COALESCE(NEW.tags, '{}'), ' ')), 'C');
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER activities_search_update
  BEFORE INSERT OR UPDATE ON public.activities
  FOR EACH ROW EXECUTE FUNCTION activities_search_vector_update();

-- Create GIN index for fast search
CREATE INDEX idx_activities_search ON public.activities USING GIN(search_vector);

-- Search function
CREATE OR REPLACE FUNCTION search_activities(search_query TEXT)
RETURNS SETOF public.activities AS $$
BEGIN
  RETURN QUERY
  SELECT *
  FROM public.activities
  WHERE moderation_status = 'approved'
    AND search_vector @@ plainto_tsquery('english', search_query)
  ORDER BY ts_rank(search_vector, plainto_tsquery('english', search_query)) DESC;
END;
$$ LANGUAGE plpgsql;
```

**Swift Usage:**
```swift
// Full-text search
func searchActivities(query: String) async throws -> [CommunityActivity] {
    try await supabase.rpc("search_activities", params: ["search_query": query]).execute()
}
```

---

## Real-Time Subscriptions

```swift
// Subscribe to new community activities
func subscribeToNewActivities() {
    let channel = supabase.channel("community-activities")

    channel.on("postgres_changes", filter: .init(
        event: .insert,
        schema: "public",
        table: "activities",
        filter: "moderation_status=eq.approved"
    )) { payload in
        // Handle new activity
        if let activity = try? payload.decodeRecord(as: CommunityActivity.self) {
            self.newActivities.append(activity)
            self.showNewActivityBadge = true
        }
    }

    Task {
        await channel.subscribe()
    }
}

// Subscribe to vote changes on an activity
func subscribeToVotes(activityId: UUID) {
    let channel = supabase.channel("activity-\(activityId)")

    channel.on("postgres_changes", filter: .init(
        event: .all,
        schema: "public",
        table: "votes",
        filter: "activity_id=eq.\(activityId)"
    )) { _ in
        // Refresh vote count
        Task { await self.refreshActivityVotes(activityId) }
    }

    Task {
        await channel.subscribe()
    }
}
```

---

## Curated Collections & Activity Packs

```sql
-- ============================================
-- CURATED PACKS (Official themed collections)
-- ============================================
CREATE TABLE public.activity_packs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    slug TEXT UNIQUE NOT NULL,  -- 'creative-sparks', 'nature-menu'
    name TEXT NOT NULL,
    description TEXT,
    cover_image_url TEXT,
    theme_color TEXT,  -- Hex color for UI

    -- Unlock requirements
    unlock_type TEXT DEFAULT 'free' CHECK (unlock_type IN ('free', 'season', 'purchase')),
    unlock_season INTEGER,  -- Required season to unlock
    unlock_price DECIMAL(10,2),  -- For future IAP

    -- Metadata
    is_featured BOOLEAN DEFAULT FALSE,
    sort_order INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW(),

    -- Stats
    activity_count INTEGER DEFAULT 0,
    download_count INTEGER DEFAULT 0
);

CREATE TABLE public.pack_activities (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    pack_id UUID NOT NULL REFERENCES public.activity_packs(id) ON DELETE CASCADE,
    activity_id UUID NOT NULL REFERENCES public.activities(id) ON DELETE CASCADE,
    sort_order INTEGER DEFAULT 0,

    UNIQUE(pack_id, activity_id)
);

-- Seed official packs
INSERT INTO public.activity_packs (slug, name, description, theme_color, unlock_type, unlock_season, sort_order) VALUES
    ('creative-sparks', 'Creative Sparks', '10 art & music activities to ignite creativity', '#E74C3C', 'season', 2, 1),
    ('nature-menu', 'Nature''s Menu', '10 outdoor activities to reconnect with nature', '#27AE60', 'season', 3, 2),
    ('mindful-moments', 'Mindful Moments', '10 meditation & mindfulness activities', '#9B59B6', 'season', 4, 3),
    ('desk-breaks', 'Desk Breaks', '10 quick activities for work breaks', '#3498DB', 'free', NULL, 4),
    ('couples-evening', 'Couples Evening', '10 activities to share with your partner', '#E91E63', 'season', 5, 5);

-- ============================================
-- USER PACK UNLOCKS
-- ============================================
CREATE TABLE public.user_pack_unlocks (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    pack_id UUID NOT NULL REFERENCES public.activity_packs(id) ON DELETE CASCADE,
    unlocked_at TIMESTAMPTZ DEFAULT NOW(),
    unlock_method TEXT DEFAULT 'season',  -- 'season', 'purchase', 'promo'

    UNIQUE(user_id, pack_id)
);
```

---

## Pro Mode: Activity Management

```sql
-- ============================================
-- USER CUSTOM ACTIVITIES (Pro Mode)
-- ============================================
-- Custom activities are stored in main activities table with source='user-created'
-- Additional metadata for user-created activities

CREATE TABLE public.user_activity_edits (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    activity_id UUID NOT NULL REFERENCES public.activities(id) ON DELETE CASCADE,

    -- User's personal overrides (NULL = use original)
    custom_title TEXT,
    custom_description TEXT,
    custom_minutes INTEGER,
    custom_energy TEXT,
    custom_category_id UUID REFERENCES public.categories(id),
    custom_tags TEXT[],

    -- Personal notes
    personal_notes TEXT,

    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),

    UNIQUE(user_id, activity_id)
);

-- View that merges original + user customizations
CREATE OR REPLACE VIEW user_activities AS
SELECT
    a.id,
    COALESCE(e.custom_title, a.title) as title,
    COALESCE(e.custom_description, a.description) as description,
    COALESCE(e.custom_minutes, a.expected_minutes) as expected_minutes,
    COALESCE(e.custom_energy, a.energy) as energy,
    COALESCE(e.custom_category_id, a.category_id) as category_id,
    COALESCE(e.custom_tags, a.tags) as tags,
    e.personal_notes,
    a.source,
    e.user_id,
    a.created_at,
    COALESCE(e.updated_at, a.updated_at) as updated_at
FROM public.activities a
LEFT JOIN public.user_activity_edits e ON a.id = e.activity_id;
```

**Swift Pro Mode API:**
```swift
// Create custom activity
func createCustomActivity(_ activity: CustomActivity) async throws -> UUID {
    let userId = supabase.auth.currentUser?.id

    let result = try await supabase
        .from("activities")
        .insert([
            "title": activity.title,
            "description": activity.description,
            "expected_minutes": activity.expectedMinutes,
            "energy": activity.energy,
            "context": activity.context,
            "category_id": activity.categoryId,
            "tags": activity.tags,
            "submitted_by": userId,
            "source": "user-created",
            "moderation_status": "approved"  // User's own activities auto-approved
        ])
        .select("id")
        .single()
        .execute()

    return result.id
}

// Edit existing activity (personal override)
func editActivity(activityId: UUID, edits: ActivityEdits) async throws {
    let userId = supabase.auth.currentUser?.id

    try await supabase
        .from("user_activity_edits")
        .upsert([
            "user_id": userId,
            "activity_id": activityId,
            "custom_title": edits.title,
            "custom_description": edits.description,
            "custom_minutes": edits.minutes,
            "custom_energy": edits.energy,
            "custom_tags": edits.tags,
            "personal_notes": edits.notes
        ])
        .execute()
}

// Delete custom activity
func deleteCustomActivity(activityId: UUID) async throws {
    let userId = supabase.auth.currentUser?.id

    // Only allow deleting user's own activities
    try await supabase
        .from("activities")
        .delete()
        .eq("id", activityId)
        .eq("submitted_by", userId)
        .eq("source", "user-created")
        .execute()
}

// Get user's activities with customizations
func getMyActivities() async throws -> [UserActivity] {
    let userId = supabase.auth.currentUser?.id

    return try await supabase
        .from("user_activities")
        .select("*")
        .or("submitted_by.eq.\(userId),user_id.eq.\(userId)")
        .execute()
        .decoded()
}
```

---

## API Rate Limiting & Caching

```sql
-- ============================================
-- API REQUEST LOGGING (for rate limiting)
-- ============================================
CREATE TABLE public.api_requests (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES public.profiles(id),
    endpoint TEXT NOT NULL,
    request_count INTEGER DEFAULT 1,
    window_start TIMESTAMPTZ DEFAULT NOW(),

    UNIQUE(user_id, endpoint, window_start)
);

-- Rate limit check function
CREATE OR REPLACE FUNCTION check_rate_limit(
    p_user_id UUID,
    p_endpoint TEXT,
    p_max_requests INTEGER DEFAULT 100,
    p_window_minutes INTEGER DEFAULT 60
) RETURNS BOOLEAN AS $$
DECLARE
    v_count INTEGER;
    v_window_start TIMESTAMPTZ;
BEGIN
    v_window_start := date_trunc('hour', NOW()) +
        (EXTRACT(MINUTE FROM NOW())::INTEGER / p_window_minutes) * INTERVAL '1 minute' * p_window_minutes;

    -- Upsert request count
    INSERT INTO public.api_requests (user_id, endpoint, request_count, window_start)
    VALUES (p_user_id, p_endpoint, 1, v_window_start)
    ON CONFLICT (user_id, endpoint, window_start)
    DO UPDATE SET request_count = api_requests.request_count + 1
    RETURNING request_count INTO v_count;

    RETURN v_count <= p_max_requests;
END;
$$ LANGUAGE plpgsql;
```

---

## Offline Sync Strategy

```swift
// LocalActivityCache.swift
import CoreData

class LocalActivityCache {
    static let shared = LocalActivityCache()

    private let cacheKey = "community_activities_cache"
    private let cacheTimestampKey = "community_activities_timestamp"
    private let cacheDuration: TimeInterval = 3600 // 1 hour

    // Check if cache is valid
    var isCacheValid: Bool {
        guard let timestamp = UserDefaults.standard.object(forKey: cacheTimestampKey) as? Date else {
            return false
        }
        return Date().timeIntervalSince(timestamp) < cacheDuration
    }

    // Get cached activities
    func getCachedActivities() -> [CommunityActivity]? {
        guard isCacheValid,
              let data = UserDefaults.standard.data(forKey: cacheKey),
              let activities = try? JSONDecoder().decode([CommunityActivity].self, from: data) else {
            return nil
        }
        return activities
    }

    // Cache activities
    func cacheActivities(_ activities: [CommunityActivity]) {
        if let data = try? JSONEncoder().encode(activities) {
            UserDefaults.standard.set(data, forKey: cacheKey)
            UserDefaults.standard.set(Date(), forKey: cacheTimestampKey)
        }
    }

    // Queue offline action for sync
    func queueOfflineAction(_ action: OfflineAction) {
        var queue = getOfflineQueue()
        queue.append(action)
        saveOfflineQueue(queue)
    }

    // Process offline queue when online
    func processOfflineQueue() async {
        let queue = getOfflineQueue()
        guard !queue.isEmpty else { return }

        for action in queue {
            do {
                switch action.type {
                case .vote:
                    try await CommunityService.shared.vote(
                        activityId: action.activityId,
                        voteType: action.payload["voteType"] as! String
                    )
                case .rate:
                    try await CommunityService.shared.rate(
                        activityId: action.activityId,
                        rating: action.payload["rating"] as! Int
                    )
                case .download:
                    try await CommunityService.shared.markDownloaded(action.activityId)
                }
            } catch {
                // Keep in queue if failed
                continue
            }
        }

        clearOfflineQueue()
    }
}

struct OfflineAction: Codable {
    let id: UUID
    let type: ActionType
    let activityId: UUID
    let payload: [String: Any]
    let createdAt: Date

    enum ActionType: String, Codable {
        case vote, rate, download
    }
}
```

---

## Environment Configuration

```swift
// Config.swift
enum Environment {
    case development
    case staging
    case production

    static var current: Environment {
        #if DEBUG
        return .development
        #else
        return .production
        #endif
    }

    var supabaseURL: String {
        switch self {
        case .development: return "https://dev-project.supabase.co"
        case .staging: return "https://staging-project.supabase.co"
        case .production: return "https://prod-project.supabase.co"
        }
    }

    var supabaseAnonKey: String {
        switch self {
        case .development: return ProcessInfo.processInfo.environment["SUPABASE_DEV_KEY"] ?? ""
        case .staging: return ProcessInfo.processInfo.environment["SUPABASE_STAGING_KEY"] ?? ""
        case .production: return ProcessInfo.processInfo.environment["SUPABASE_PROD_KEY"] ?? ""
        }
    }
}

// Initialize Supabase client
let supabase = SupabaseClient(
    supabaseURL: URL(string: Environment.current.supabaseURL)!,
    supabaseKey: Environment.current.supabaseAnonKey
)
