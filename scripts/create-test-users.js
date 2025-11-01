#!/usr/bin/env node

/**
 * Script para crear usuarios de prueba en Supabase local
 * Ejecutar: node scripts/create-test-users.js
 */

const SUPABASE_URL = 'http://127.0.0.1:54321'

// Obtener las keys del output de `supabase status`
const SECRET_KEY = 'sb_secret_N7UND0UgjKTVK-Uodkm0Hg_xSvEMPvz' // Usar el Secret key del status

const users = [
  {
    email: 'pastor@casadeprovision.es',
    password: 'P@storCCP_2025-!long-secure-pass',
    user_metadata: {
      name: 'Pastor Principal',
      role: 'admin'
    }
  },
  {
    email: 'admin@casadeprovision.es',
    password: 'Adm1nCasaDeProvis10n#secure-long-pass',
    user_metadata: {
      name: 'Administrador',
      role: 'leader'
    }
  }
]

async function createUsers() {
  console.log('🚀 Creando usuarios de prueba en Supabase...\n')

  for (const user of users) {
    try {
      console.log(`👤 Creando usuario: ${user.email}`)
      
      const response = await fetch(`${SUPABASE_URL}/auth/v1/admin/users`, {
        method: 'POST',
        headers: {
          'apikey': SECRET_KEY,
          'Authorization': `Bearer ${SECRET_KEY}`,
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({
          email: user.email,
          password: user.password,
          email_confirm: true,
          user_metadata: user.user_metadata
        })
      })

      if (response.ok) {
        const data = await response.json()
        console.log(`   ✅ Usuario creado: ${data.email} (ID: ${data.id})`)
      } else {
        const error = await response.text()
        console.log(`   ⚠️  Error: ${error}`)
      }
    } catch (error) {
      console.error(`   ❌ Error creando ${user.email}:`, error.message)
    }
    console.log('')
  }

  console.log('✅ Proceso completado!\n')
  console.log('📋 Credenciales de prueba:')
  console.log('   Pastor (admin):  pastor@casadeprovision.es / P@storCCP_2025-!long-secure-pass')
  console.log('   Admin (leader):  admin@casadeprovision.es / Adm1nCasaDeProvis10n#secure-long-pass\n')
}

createUsers().catch(console.error)
