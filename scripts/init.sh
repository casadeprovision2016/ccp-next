#!/bin/bash

echo "🚀 Inicializando Centro Cristiano Casa de Provisión - Next.js + Supabase"
echo ""

# Cores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 1. Verificar se Docker está rodando
echo -e "${BLUE}1. Verificando Docker...${NC}"
if ! docker ps &> /dev/null; then
    echo -e "${YELLOW}⚠️  Docker não está rodando. Por favor, inicie o Docker e tente novamente.${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Docker está rodando${NC}"
echo ""

# 2. Iniciar Supabase
echo -e "${BLUE}2. Iniciando Supabase...${NC}"
npx supabase start

# 3. Exibir credenciais
echo ""
echo -e "${GREEN}✓ Supabase iniciado com sucesso!${NC}"
echo ""
echo -e "${YELLOW}📝 Próximos passos:${NC}"
echo ""
echo "1. Atualize .env.local com as credenciais acima"
echo "2. Acesse Supabase Studio: http://127.0.0.1:54323"
echo "3. Crie usuários em Authentication > Users:"
echo "   - pastor@casadeprovision.es"
echo "   - admin@casadeprovision.es"
echo "4. Execute: npm run dev"
echo "5. Acesse: http://localhost:3000"
echo ""
echo -e "${GREEN}Happy coding! 🎉${NC}"
