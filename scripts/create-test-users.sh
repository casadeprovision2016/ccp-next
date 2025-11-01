#!/bin/bash

# Script para crear usuarios de prueba en Supabase local
# Requiere que Supabase esté corriendo (npx supabase start)

echo "🚀 Creando usuarios de prueba en Supabase..."

# Obtener las variables de Supabase
SUPABASE_URL="http://127.0.0.1:54321"
SUPABASE_SERVICE_ROLE_KEY=$(npx supabase status 2>/dev/null | grep "Secret key" | awk '{print $3}')

if [ -z "$SUPABASE_SERVICE_ROLE_KEY" ]; then
  echo "❌ Error: No se pudo obtener la Secret key de Supabase"
  echo "Asegúrate de que Supabase esté corriendo: npx supabase start"
  exit 1
fi

echo "📝 Secret Key obtenida: ${SUPABASE_SERVICE_ROLE_KEY:0:20}..."

# Crear usuario Pastor (admin)
echo "👤 Creando usuario: pastor@casadeprovision.es"
curl -X POST "${SUPABASE_URL}/auth/v1/admin/users" \
  -H "apikey: ${SUPABASE_SERVICE_ROLE_KEY}" \
  -H "Authorization: Bearer ${SUPABASE_SERVICE_ROLE_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "pastor@casadeprovision.es",
    "password": "P@storCCP_2025-!long-secure-pass",
    "email_confirm": true,
    "user_metadata": {
      "name": "Pastor Principal",
      "role": "admin"
    }
  }'

echo ""
echo ""

# Crear usuario Admin (leader)
echo "👤 Creando usuario: admin@casadeprovision.es"
curl -X POST "${SUPABASE_URL}/auth/v1/admin/users" \
  -H "apikey: ${SUPABASE_SERVICE_ROLE_KEY}" \
  -H "Authorization: Bearer ${SUPABASE_SERVICE_ROLE_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "admin@casadeprovision.es",
    "password": "Adm1nCasaDeProvis10n#secure-long-pass",
    "email_confirm": true,
    "user_metadata": {
      "name": "Administrador",
      "role": "leader"
    }
  }'

echo ""
echo ""
echo "✅ Usuarios creados correctamente!"
echo ""
echo "📋 Credenciales de prueba:"
echo "   Pastor (admin):  pastor@casadeprovision.es / P@storCCP_2025-!long-secure-pass"
echo "   Admin (leader):  admin@casadeprovision.es / Adm1nCasaDeProvis10n#secure-long-pass"
