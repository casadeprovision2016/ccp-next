# Centro Cristiano Casa de Provisión - AI Agent Instructions

## Project Overview
Church management system built with **Next.js 15 (App Router) + Supabase**, featuring a public website and administrative panel for managing events, members, donations, and ministries. Currently in **active migration** from Vite+localStorage to Next.js+PostgreSQL.

## Architecture & Tech Stack

### Core Technologies
- **Framework**: Next.js 15.5.6 (App Router with Turbopack)
- **Runtime**: React 19 + TypeScript 5
- **Database**: Supabase (PostgreSQL + Auth + RLS)
- **UI**: Tailwind CSS v4 + shadcn/ui (40+ components)
- **State**: TanStack Query v5 for server state
- **Forms**: React Hook Form + Zod validation

### Import Path Alias
All imports use `@/` alias mapped to `./src/`:
```typescript
import { Button } from "@/components/button"
import { useAuth } from "@/hooks/use-auth"
import { createClient } from "@/lib/supabase/client"  // CSR
import { createClient } from "@/lib/supabase/server" // SSR
```

### Custom Theme Colors (tailwind.config.ts)
Always use church-specific semantic colors:
- `church-gold` (#B8860B), `church-gold-light`, `church-gold-dark`
- `church-blue` (#4682B4), `church-blue-light`, `church-blue-dark`
- `church-cream`, `church-warm-white`

## Application Structure

### Route Groups (Next.js App Router)
```
src/app/
├── (public)/              # Public routes
│   ├── page.tsx          # Homepage (Server Component)
│   └── login/page.tsx    # Login page
├── (dashboard)/           # Protected routes (middleware-guarded)
│   └── panel/page.tsx    # Admin panel
├── layout.tsx            # Root layout
└── not-found.tsx         # 404 page
```

### Component Organization
```
src/components/
├── *.tsx                  # shadcn/ui components (flat structure)
├── home/                  # Public homepage sections (10 files)
└── panel/                 # Admin managers (8 files + legacy -old.tsx)
```

**Critical Pattern**: Panel managers in `components/panel/` are **Client Components** (`'use client'`) using TanStack Query hooks. Homepage sections in `components/home/` receive props from Server Component parent (`app/(public)/page.tsx`).

## Authentication System

### Supabase Auth (src/hooks/use-auth.ts)
```typescript
const { user, profile, loading, signIn, signOut, isAuthenticated, isAdmin, isLeader } = useAuth()
// user: Supabase User object
// profile: { id, email, name, role: 'admin' | 'leader' | 'member' }
```

**Test Credentials** (must be manually created in Supabase Studio):
```
pastor@casadeprovision.es / P@storCCP_2025-!long-secure-pass → role: admin
admin@casadeprovision.es / Adm1nCasaDeProvis10n#secure-long-pass → role: leader
```

### Middleware Protection (src/middleware.ts)
- Blocks `/panel/*` routes if unauthenticated → redirects to `/login`
- Auto-redirects authenticated users from `/login` to `/panel`
- Uses `@supabase/ssr` for cookie-based session management

## Data Layer Architecture

### Supabase Client Patterns
**Client-side (hooks/components)**:
```typescript
import { createClient } from '@/lib/supabase/client'
const supabase = createClient()
```

**Server-side (Server Components)**:
```typescript
import { createClient } from '@/lib/supabase/server'
const supabase = await createClient()  // Must await!
```

### TanStack Query Pattern (src/lib/queries/)
Only `events.ts` currently implemented. Pattern to replicate for other entities:
```typescript
'use client'
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { createClient } from '@/lib/supabase/client'

export function useEvents() {
  const supabase = createClient()
  return useQuery({
    queryKey: ['events'],
    queryFn: async () => {
      const { data, error } = await supabase.from('events').select('*')
      if (error) throw error
      return data
    }
  })
}

export function useCreateEvent() {
  const queryClient = useQueryClient()
  const supabase = createClient()
  return useMutation({
    mutationFn: async (newEvent) => {
      const { data, error } = await supabase.from('events').insert([newEvent]).select().single()
      if (error) throw error
      return data
    },
    onSuccess: () => queryClient.invalidateQueries({ queryKey: ['events'] })
  })
}
```

### Database Schema (9 tables)
See `supabase/migrations/20250101000000_initial_schema.sql`:
- `profiles` (users with role)
- `events` (church events with follow_up_needed flag)
- `members` (registered members)
- `visitors` (new visitors)
- `donations` (tithes/offerings)
- `pastoral_visits` (pastoral care tracking)
- `ministries` (church departments)
- `live_streams` (YouTube/streaming links)
- `birthdays` (view for upcoming birthdays)

All tables have Row Level Security (RLS) enabled.

## Development Workflows

### Local Development Setup
```bash
npm install
npx supabase start        # First run takes 5-10 min
npx supabase db seed      # Load sample data
npm run dev               # Start Next.js on :3000
```

**Environment Variables** (`.env.local`):
```env
NEXT_PUBLIC_SUPABASE_URL=http://127.0.0.1:54321
NEXT_PUBLIC_SUPABASE_ANON_KEY=<from supabase status>
SUPABASE_SERVICE_ROLE_KEY=<from supabase status>
```

### Key Commands
- `npm run dev` - Start Next.js with Turbopack (port 3000)
- `npm run build` - Production build (validates types)
- `npm run lint` - ESLint (flat config)
- `npx supabase status` - Check DB connection
- `npx supabase db reset` - Reset database
- `npx supabase gen types typescript --local > src/types/database.ts` - Generate types

### Adding New Query Hook
1. Copy `src/lib/queries/events.ts` as template
2. Replace table name and types
3. Export `useEntity`, `useCreateEntity`, `useUpdateEntity`, `useDeleteEntity`
4. Import in panel manager component

### Migrating Panel Manager to Supabase
**Before** (localStorage):
```typescript
const [items, setItems] = useState([])
useEffect(() => {
  const stored = localStorage.getItem('items')
  setItems(stored ? JSON.parse(stored) : [])
}, [])
```

**After** (Supabase):
```typescript
'use client'  // Add this!
import { useItems, useCreateItem } from '@/lib/queries/items'
const { data: items, isLoading } = useItems()
const createItem = useCreateItem()
// ...
await createItem.mutateAsync(formData)
```

**Status**: Only `EventsManager.tsx` fully migrated. 7 managers still use localStorage.

## Critical Constraints

### DO NOT Edit These Files
- `old/` directory - Legacy Vite code (reference only)
- `*-old.tsx` files - Backup copies before migration

### Component Directive Rules
- **Client Components** (use hooks/state): Add `'use client'` at top
- **Server Components** (fetch data): No directive needed (default)
- Panel managers = always Client Components
- Homepage sections = can be either (currently receive props from Server parent)

### Styling Standards
- Use Tailwind utilities only (no custom CSS)
- Primary buttons: `bg-church-gold hover:bg-church-gold-dark text-white`
- Secondary buttons: `border-church-blue text-church-blue hover:bg-church-blue hover:text-white`
- Always use `church-*` colors, never generic blue/gold

## Migration Status

**Structural**: 100% complete (all files moved from Vite to Next.js structure)
**Functional**: ~14% complete (only events.ts query exists, managers still use localStorage)

**Next Tasks**:
1. Create query hooks for 6 remaining entities (members, visitors, donations, pastoral_visits, ministries, streams)
2. Refactor panel managers to use TanStack Query instead of localStorage
3. Add `'use client'` directives to components using React hooks

See `README.md` and `MIGRATION_CHECKLIST.md` for detailed migration tracking.

## Troubleshooting Patterns

- **"localStorage is not defined"**: Component needs `'use client'` directive
- **"Hydration mismatch"**: Client component accessing browser APIs without guards
- **"Module not found: Can't resolve '@/...'"**: Check import path uses `@/` alias
- **RLS error "new row violates row-level security"**: Check user is authenticated or policy is correct
- **Query not updating after mutation**: Verify `invalidateQueries` in mutation `onSuccess`

## Reference Points

- **Query example**: `src/lib/queries/events.ts`
- **Migrated manager**: `src/components/panel/EventsManager.tsx`
- **Auth usage**: `src/hooks/use-auth.ts`
- **Middleware**: `src/middleware.ts`
- **Schema**: `supabase/migrations/20250101000000_initial_schema.sql`
- **Homepage pattern**: `src/app/(public)/page.tsx` (Server Component fetching data)
