# 🏛️ Centro Cristiano Casa de Provisión

Sistema interno de gestión pastoral construido con **Next.js 15** y **Supabase**. Este repositorio contiene la versión en migración desde un proyecto Vite heredado, por lo que se debe extremar la protección de credenciales, datos pastorales y configuraciones de despliegue.

> ⚠️ **Norma general:** no compartas capturas de pantalla, registros de consola ni credenciales fuera del equipo autorizado. Si necesitas reportar errores, hazlo en términos generales (ej. “fallo al crear evento”) y nunca incluyas tokens, correos o contraseñas en texto plano.

## 1. Resumen de arquitectura

- **Framework:** Next.js 15.5.6 (App Router + Turbopack)
- **Lenguaje:** TypeScript 5
- **UI:** Tailwind CSS v4 + shadcn/ui
- **Estado y datos:** Supabase (PostgreSQL, Auth, Storage) + TanStack Query v5
- **Autenticación:** Supabase Auth con hook `useAuth`
- **Directorio `old/`:** código Vite legado. Mantener solo como referencia, no modificar.

### Estructura básica

```
src/
├─ app/
│  ├─ (public)/        # Sitio público (home, login, políticas)
│  ├─ (dashboard)/     # Panel protegido
│  └─ layout.tsx       # Layout raíz
├─ components/
│  ├─ home/            # Secciones públicas
│  ├─ panel/           # Managers administrativos
│  └─ ui/              # Componentes shadcn
├─ hooks/              # Hooks (ej. use-auth)
├─ lib/                # Supabase clients + queries
└─ middleware.ts       # Protección de rutas
```

## 2. Puesta en marcha segura

1. **Instala dependencias**
   ```bash
   npm install
   ```
2. **Arranca Supabase local** (requiere CLI instalada)
   ```bash
   npx supabase start
   npx supabase status
   ```
3. **Configura variables de entorno** en `.env.local` (no subir este archivo). Usa los valores que obten- gas de `npx supabase status` o del entorno de producción; nunca dupliques llaves en el repo.
   ```env
   NEXT_PUBLIC_SUPABASE_URL=<url>
   NEXT_PUBLIC_SUPABASE_ANON_KEY=<anon_key>
   SUPABASE_SERVICE_ROLE_KEY=<service_role_key>
   ```
4. **Aplica migraciones y seeds**
   ```bash
   npx supabase db reset   # opción rápida (warning: destruye datos locales)
   npx supabase db seed
   ```
5. **Inicia desarrollo**
   ```bash
   npm run dev
   ```
   Servirá en http://localhost:3000 (no expongas esta URL públicamente si cargas datos reales).

> 💡 Antes de subir cambios, ejecuta `npm run lint` y verifica que no existan secretos en el historial (`git status`, `git diff`).

## 3. Estados de migración

- **Migración estructural:** 100% (todas las rutas y componentes movidos a `src/`).
- **Integración con Supabase:** en progreso. Solo `events` usa TanStack Query por ahora; el resto de managers siguen con `localStorage` y deben migrarse a consultas reales.

| Área | Estado | Próximo paso |
|------|--------|--------------|
| Autenticación & middleware | ✅ | Mantener políticas y tokens seguros |
| Queries TanStack | ⚠️ parcial | Replicar patrón de `events.ts` en `members`, `visitors`, `donations`, `pastoral-visits`, `ministries`, `streams` |
| Managers del panel | ⚠️ | Reemplazar `localStorage` por queries/mutations con invalidación |
| Datos en Home | ⚠️ | Cargar datos reales en `CalendarSection`, `LiveStreamSection`, etc. |

## 4. Buenas prácticas de seguridad

1. **Sin credenciales compartidas:** crear usuarios de prueba manualmente en Supabase Studio y usar contraseñas temporales. Elimina cualquier dato sensible del README, issues o commits.
2. **Variables en archivos seguros:** `.env.local`, `.env.production` o secretos del proveedor. Nunca subir `.env*` al repo.
3. **Logs y capturas:** revisa antes de compartir; busca tokens (`sb_`, `supabase`, `Bearer`) y reemplaza por `<redacted>`.
4. **Dependencias:** mantener `npm audit` al día. Si detectas vulnerabilidades críticas, crea un issue privado inmediatamente.
5. **Control de acceso:** la aplicación maneja datos personales y religiosos; aplica RBAC estricto (`isAdmin`, `isLeader`) y evita exponer endpoints sin middleware.
6. **Ramas de trabajo:** usa ramas por feature y solicita revisión antes de fusionar con `main`.

## 5. Flujo de trabajo recomendado

1. Crear rama: `git checkout -b feat/<descripcion>`
2. Implementar cambios siguiendo las guías de diseño (colores `church-*`, componentes shadcn, `'use client'` cuando correspondan).
3. Ejecutar tests y lint: `npm run lint` (agregar pruebas unitarias cuando exista infraestructura).
4. Revisar que `git diff` no incluya secretos ni datos sensibles.
5. Abrir PR indicando:
   - Resumen técnico
   - Riesgos de seguridad o migraciones
   - Requisitos de despliegue

## 6. Referencias rápidas

- **Supabase CLI:** https://supabase.com/docs/guides/cli
- **Next.js:** https://nextjs.org/docs
- **Tailwind CSS:** https://tailwindcss.com/docs
- **shadcn/ui:** https://ui.shadcn.com
- **TanStack Query:** https://tanstack.com/query/latest

## 7. Contacto interno

- Incidencias de seguridad: avisar al responsable del proyecto por los canales internos acordados.
- Documentación sensible adicional (diagramas, credenciales, manuales de despliegue) está alojada en el repositorio privado del equipo y no debe copiarse aquí.

---

**Estado del proyecto:** Migración funcional en curso.  
**Última revisión de seguridad:** 18 de noviembre de 2025.
