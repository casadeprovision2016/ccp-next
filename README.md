# 🏛️ Centro Cristiano Casa de Provisión - Sistema de Gestión

Sistema web de gestión integral para iglesia construido con **Next.js 15** + **Supabase**.

## 📊 Estado de la Migración

### ✅ Migración Estructural: 100% Completa

Todos los archivos de `old/` (proyecto Vite) fueron migrados exitosamente a la estructura Next.js:

| Componente | Origen (Vite) | Destino (Next.js) | Estado |
|-----------|---------------|-------------------|---------|
| **Páginas** |
| Homepage | `old/pages/Index.tsx` | `src/app/(public)/page.tsx` | ✅ Migrado |
| Login | `old/pages/Login.tsx` | `src/app/(public)/login/page.tsx` | ✅ Migrado |
| Panel | `old/pages/Panel.tsx` | `src/app/(dashboard)/panel/page.tsx` | ✅ Migrado |
| 404 | `old/pages/NotFound.tsx` | `src/app/not-found.tsx` | ✅ Migrado |
| **Componentes Home** | | | **10/10** |
| Secciones públicas | `old/components/*.tsx` | `src/components/home/*.tsx` | ✅ 10 archivos |
| **Componentes Panel** | | | **8/8** |
| Managers | `old/components/panel/*.tsx` | `src/components/panel/*.tsx` | ✅ 8 archivos |
| **Componentes UI** | | | **40+/40+** |
| shadcn/ui | `old/components/ui/*.tsx` | `src/components/*.tsx` | ✅ Todos |
| **Autenticación** |
| Context | `old/contexts/AuthContext.tsx` | `src/hooks/use-auth.ts` | ✅ Adaptado Supabase |
| **Hooks** |
| Utilidades | `old/hooks/*.ts` | `src/hooks/*.ts` | ✅ Migrados |

### ⚠️ Migración Funcional: 60% Completa

La estructura está migrada pero **los componentes aún no se conectan a Supabase**:

| Funcionalidad | Estado | Detalles |
|--------------|--------|----------|
| **Autenticación** | ✅ 100% | Hook `useAuth` adaptado a Supabase Auth |
| **Middleware** | ✅ 100% | Protección de rutas implementada |
| **Queries TanStack** | ⚠️ 14% | Solo `events.ts` creado (1 de 7) |
| **Managers Panel** | ❌ 0% | Todavía usan `localStorage` |
| **Componentes Home** | ❌ 0% | No cargan datos de Supabase |

---

## 🎯 Tech Stack

- **Framework**: Next.js 15.5.6 (App Router)
- **Lenguaje**: TypeScript 5.9
- **UI**: Tailwind CSS v4 + shadcn/ui
- **Backend**: Supabase (PostgreSQL + Auth + Storage)
- **State**: TanStack Query v5 + React hooks
- **Forms**: React Hook Form + Zod
- **Icons**: Lucide React

---

## 🚀 Setup Inicial

### 1. Instalar Dependencias

```bash
npm install
```

### 2. Configurar Supabase Local

```bash
# Iniciar Supabase (primera vez puede tomar 5-10 min)
npx supabase start

# Verificar que esté corriendo
npx supabase status
```

**Output real:**
```
Using project host: supabase.co
Supabase CLI 2.48.3
Loading project ref from file: supabase/.temp/project-ref
Starting database from backup...
Starting containers...
Waiting for health checks...
2025/11/01 14:17:38 HTTP HEAD: http://127.0.0.1:54321/rest-admin/v1/ready
2025/11/01 14:17:38 HTTP HEAD: http://127.0.0.1:54321/functions/v1/_internal/health
2025/11/01 14:17:39 HTTP HEAD: http://127.0.0.1:54321/functions/v1/_internal/health
Started supabase local development setup.

         API URL: http://127.0.0.1:54321
     GraphQL URL: http://127.0.0.1:54321/graphql/v1
  S3 Storage URL: http://127.0.0.1:54321/storage/v1/s3
         MCP URL: http://127.0.0.1:54321/mcp
    Database URL: postgresql://postgres:postgres@127.0.0.1:54322/postgres
      Studio URL: http://127.0.0.1:54323
     Mailpit URL: http://127.0.0.1:54324
 Publishable key: sb_publishable_ACJWlzQHlZjBrEguHvfOxg_3BJgxAaH
      Secret key: sb_secret_N7UND0UgjKTVK-Uodkm0Hg_xSvEMPvz
   S3 Access Key: 625729a08b95bf1b7ff351a663f3a23c
   S3 Secret Key: 850181e4652dd023b7a98c58ae0d2d34bd487ee0cc3254aed6eda37307425907
       S3 Region: local
A new version of Supabase CLI is available: v2.54.11 (currently installed v2.48.3)
We recommend updating regularly for new features and bug fixes: https://supabase.com/docs/guides/cli/getting-started#updating-the-supabase-cli
```

### 3. Configurar Variables de Entorno

Copie las keys del paso anterior a `.env.local`:

```env
NEXT_PUBLIC_SUPABASE_URL=http://127.0.0.1:54321
NEXT_PUBLIC_SUPABASE_ANON_KEY=<tu_anon_key>
SUPABASE_SERVICE_ROLE_KEY=<tu_service_role_key>
```

### 4. Aplicar Seeds

```bash
npx supabase db seed
```

### 5. Crear Usuarios de Prueba

Accede a Supabase Studio: http://127.0.0.1:54323

**Crear Pastor (Admin):**
1. Authentication → Users → Add User
   - Email: `pastor@casadeprovision.es`
   - Password: `P@storCCP_2025-!long-secure-pass`
   - Copiar UUID generado

2. Table Editor → profiles → Insert Row
   - id: (UUID copiado)
   - email: `pastor@casadeprovision.es`
   - name: `Pastor`
   - role: `admin`

**Crear Admin (Leader):**
1. Authentication → Users → Add User
   - Email: `admin@casadeprovision.es`
   - Password: `Adm1nCasaDeProvis10n#secure-long-pass`
   - Copiar UUID

2. Table Editor → profiles → Insert Row
   - id: (UUID copiado)
   - email: `admin@casadeprovision.es`
   - name: `Administrador`
   - role: `leader`

### 6. Iniciar Desarrollo

```bash
npm run dev
```

Abre http://localhost:3000

---

## 📂 Estructura del Proyecto

```
ccp-nextjs/
├── src/
│   ├── app/
│   │   ├── (public)/          # Rutas públicas
│   │   │   ├── page.tsx       # Homepage
│   │   │   └── login/         # Login
│   │   ├── (dashboard)/       # Rutas protegidas
│   │   │   └── panel/         # Panel administrativo
│   │   ├── layout.tsx         # Layout global
│   │   └── not-found.tsx      # Página 404
│   │
│   ├── components/
│   │   ├── home/              # Componentes homepage (10)
│   │   ├── panel/             # Managers panel (8)
│   │   └── *.tsx              # shadcn/ui (40+)
│   │
│   ├── hooks/
│   │   └── use-auth.ts        # Hook autenticación Supabase
│   │
│   ├── lib/
│   │   ├── supabase/
│   │   │   ├── client.ts      # Cliente CSR
│   │   │   └── server.ts      # Cliente SSR
│   │   └── queries/
│   │       └── events.ts      # TanStack Query (ejemplo)
│   │
│   └── middleware.ts          # Protección de rutas
│
├── supabase/
│   ├── migrations/            # Schema SQL
│   └── seed.sql              # Datos iniciales
│
├── old/                       # ⚠️ Código Vite legacy (NO usar)
│
└── public/
    └── image/       # Imágenes
```

---

## 🔧 Tareas Pendientes

### 🔴 Alta Prioridad

#### 1. Crear Queries para Todas las Entidades (6 archivos faltantes)

Basado en `src/lib/queries/events.ts`, crear:

- [ ] `src/lib/queries/members.ts`
- [ ] `src/lib/queries/visitors.ts`
- [ ] `src/lib/queries/donations.ts`
- [ ] `src/lib/queries/pastoral-visits.ts`
- [ ] `src/lib/queries/ministries.ts`
- [ ] `src/lib/queries/streams.ts`

**Patrón a seguir:**
```typescript
// src/lib/queries/members.ts
'use client'
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { createClient } from '@/lib/supabase/client'

export function useMembers() {
  const supabase = createClient()
  return useQuery({
    queryKey: ['members'],
    queryFn: async () => {
      const { data, error } = await supabase
        .from('members')
        .select('*')
        .order('created_at', { ascending: false })
      if (error) throw error
      return data
    }
  })
}

export function useCreateMember() {
  const queryClient = useQueryClient()
  const supabase = createClient()
  return useMutation({
    mutationFn: async (newMember) => {
      const { data, error } = await supabase
        .from('members')
        .insert([newMember])
        .select()
        .single()
      if (error) throw error
      return data
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['members'] })
    }
  })
}

// useUpdateMember, useDeleteMember...
```

#### 2. Refatorar Managers do Panel (8 archivos)

Todos los managers en `src/components/panel/*.tsx` deben:

1. **Añadir** `'use client'` al inicio
2. **Importar** queries correspondientes
3. **Reemplazar** `useState` con localStorage por `useQuery`
4. **Reemplazar** funciones CRUD por `useMutation`

**Ejemplo: EventsManager.tsx**

```diff
+ 'use client'
- import { useState, useEffect } from 'react'
+ import { useEvents, useCreateEvent, useUpdateEvent, useDeleteEvent } from '@/lib/queries/events'

export default function EventsManager() {
-  const [events, setEvents] = useState([])
-  const [loading, setLoading] = useState(true)
+  const { data: events, isLoading } = useEvents()
+  const createEvent = useCreateEvent()
+  const updateEvent = useUpdateEvent()
+  const deleteEvent = useDeleteEvent()

-  useEffect(() => {
-    const stored = localStorage.getItem('events')
-    setEvents(stored ? JSON.parse(stored) : [])
-    setLoading(false)
-  }, [])

   const handleCreate = async (formData) => {
-    const newEvent = { id: Date.now().toString(), ...formData }
-    const updated = [...events, newEvent]
-    setEvents(updated)
-    localStorage.setItem('events', JSON.stringify(updated))
+    await createEvent.mutateAsync(formData)
   }

-  if (loading) return <div>Cargando...</div>
+  if (isLoading) return <div>Cargando...</div>

   return (
     // ... rest of component
   )
}
```

**Managers a actualizar:**
- [ ] `EventsManager.tsx`
- [ ] `MembersManager.tsx`
- [ ] `VisitorsManager.tsx`
- [ ] `DonationsManager.tsx`
- [ ] `PastoralVisitsManager.tsx`
- [ ] `MinistriesManager.tsx`
- [ ] `StreamsManager.tsx`
- [ ] `BirthdaysList.tsx`

#### 3. Actualizar Componentes Home (fetch de datos)

Componentes como `CalendarSection.tsx` y `LiveStreamSection.tsx` necesitan cargar datos reales:

**Opción 1: Server Component (recomendado)**
```typescript
// src/app/(public)/page.tsx
import { createClient } from '@/lib/supabase/server'
import CalendarSection from '@/components/home/CalendarSection'

export default async function Home() {
  const supabase = await createClient()
  const { data: events } = await supabase
    .from('events')
    .select('*')
    .order('date', { ascending: true })
    .limit(5)

  return (
    <div>
      <CalendarSection events={events} />
      {/* ... */}
    </div>
  )
}
```

**Opción 2: Client Component con useQuery**
```typescript
// src/components/home/CalendarSection.tsx
'use client'
import { useEvents } from '@/lib/queries/events'

export default function CalendarSection() {
  const { data: events } = useEvents()
  // ...
}
```

### 🟡 Media Prioridad

- [ ] Añadir `'use client'` a componentes que usen hooks React
- [ ] Convertir tags `<img>` a `<Image>` de Next.js
- [ ] Reemplazar `<Link>` de react-router por `<Link>` de Next.js
- [ ] Añadir tipos TypeScript para schemas de Supabase:
  ```bash
  npx supabase gen types typescript --local > src/types/database.ts
  ```

### 🟢 Baja Prioridad

- [ ] Optimizar imágenes con `next/image`
- [ ] Añadir loading states mejorados
- [ ] Implementar error boundaries
- [ ] Añadir tests (Vitest + React Testing Library)
- [ ] SEO metadata personalizado

---

## 📜 Comandos Útiles

```bash
# Desarrollo
npm run dev                        # Iniciar Next.js (puerto 3000)
npm run build                      # Build para producción
npm run start                      # Servidor producción
npm run lint                       # ESLint

# Supabase
npx supabase start                 # Iniciar DB local
npx supabase stop                  # Detener DB
npx supabase status                # Ver estado
npx supabase db reset              # Reset completo
npx supabase db seed               # Aplicar seeds
npx supabase db push               # Deploy migrations
npx supabase gen types typescript --local > src/types/database.ts  # Generar tipos
```

---

## 🗄️ Schema de Base de Datos

9 tablas principales (ver `supabase/migrations/20250101000000_initial_schema.sql`):

| Tabla | Descripción | RLS |
|-------|-------------|-----|
| `profiles` | Usuarios (admin/leader/member) | ✅ |
| `events` | Eventos/actividades iglesia | ✅ |
| `members` | Miembros registrados | ✅ |
| `visitors` | Visitantes nuevos | ✅ |
| `donations` | Donaciones/ofrendas | ✅ |
| `pastoral_visits` | Visitas pastorales | ✅ |
| `ministries` | Ministerios de la iglesia | ✅ |
| `live_streams` | Transmisiones en vivo | ✅ |
| `birthdays` | Vista de cumpleaños (view) | ✅ |

---

## 🔐 Autenticación

### Credenciales de Prueba

| Usuario | Email | Password | Rol |
|---------|-------|----------|-----|
| Pastor | `pastor@casadeprovision.es` | `P@storCCP_2025-!long-secure-pass` | `admin` |
| Admin | `admin@casadeprovision.es` | `Adm1nCasaDeProvis10n#secure-long-pass` | `leader` |

### Uso del Hook `useAuth`

```typescript
'use client'
import { useAuth } from '@/hooks/use-auth'

export default function MyComponent() {
  const { 
    user,          // Usuario Supabase
    profile,       // { id, email, name, role }
    loading,       // Estado carga
    signIn,        // (email, password) => Promise
    signOut,       // () => Promise
    isAuthenticated,  // boolean
    isAdmin,       // role === 'admin'
    isLeader       // role === 'leader'
  } = useAuth()

  if (loading) return <div>Cargando...</div>
  if (!isAuthenticated) return <div>Por favor inicia sesión</div>

  return <div>Bienvenido, {profile?.name}</div>
}
```

---

## 🎨 Tema Personalizado

Colores definidos en `tailwind.config.ts`:

```typescript
colors: {
  'church-gold': '#B8860B',
  'church-gold-light': '#DAA520',
  'church-gold-dark': '#8B6914',
  'church-blue': '#4682B4',
  'church-blue-light': '#5F9CC5',
  'church-blue-dark': '#2F5A7E',
  'church-cream': '#FFF8DC',
  'church-warm-white': '#FAF9F6',
}
```

**Uso:**
```tsx
<button className="bg-church-gold hover:bg-church-gold-dark text-white">
  Acción Principal
</button>
```

---

## 📚 Recursos

- [Next.js Docs](https://nextjs.org/docs)
- [Supabase Docs](https://supabase.com/docs)
- [TanStack Query](https://tanstack.com/query/latest)
- [shadcn/ui](https://ui.shadcn.com)
- [Tailwind CSS](https://tailwindcss.com)

---

## 🤝 Contribuir

Este proyecto está en fase de migración activa. Antes de hacer cambios:

1. ❌ **NO editar archivos en `old/`** (código legacy)
2. ✅ **Trabajar solo en `src/`**
3. ✅ Seguir los patrones de queries establecidos
4. ✅ Añadir `'use client'` cuando uses hooks React
5. ✅ Usar colores `church-*` en lugar de colores genéricos

---

## 📄 Licencia

Proyecto privado - Centro Cristiano Casa de Provisión

---

**Estado del Proyecto**: 🚧 En migración activa  
**Última actualización**: 1 de noviembre de 2025  
**Próximo milestone**: Completar queries y refactorizar managers (60% → 100%)
