#!/usr/bin/env node

const SUPABASE_URL = 'http://127.0.0.1:54321'
const SECRET_KEY = 'sb_secret_N7UND0UgjKTVK-Uodkm0Hg_xSvEMPvz'

async function checkProfiles() {
  try {
    const response = await fetch(`${SUPABASE_URL}/rest/v1/profiles?select=*`, {
      headers: {
        'apikey': SECRET_KEY,
        'Authorization': `Bearer ${SECRET_KEY}`,
        'Accept': 'application/json'
      }
    })

    const data = await response.json()
    console.log('📋 Perfiles en la base de datos:')
    console.log(JSON.stringify(data, null, 2))
  } catch (error) {
    console.error('❌ Error:', error.message)
  }
}

checkProfiles()
