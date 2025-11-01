# 🚀 Guia de Deploy - Centro Cristiano Casa de Provisión

## ✅ Checklist Pré-Deploy (Completo)

### 1. ✅ Variáveis de Ambiente
- [x] `.env.example` criado com documentação
- [x] Validação de env vars implementada em `src/lib/env.ts`
- [x] Nunca expor `SUPABASE_SERVICE_ROLE_KEY` no frontend

### 2. ✅ Build e Testes
- [x] `npm run build` executado sem erros
- [x] `npm run lint` sem erros (100% limpo)
- [x] Todas as imagens usando `<Image>` do Next.js
- [x] Console.logs removidos do código de produção

### 3. ✅ Configuração Next.js
- [x] `next.config.ts` configurado com domínios de imagens (Unsplash)
- [x] Middleware protegendo rotas `/panel/*`
- [x] App Router funcionando corretamente

### 4. ✅ SEO e Acessibilidade
- [x] `<html lang="es">` configurado
- [x] Metadados definidos em `layout.tsx`

### 5. ✅ Dashboard Dinâmico
- [x] Estatísticas agora vêm do banco de dados (não hardcoded)
- [x] Query `useDashboardStats()` criada em `src/lib/queries/dashboard.ts`

---

## 🎯 Deploy em Vercel (Recomendado)

### Passo 1: Preparar Supabase Production

1. Acesse [app.supabase.com](https://app.supabase.com)
2. Crie um novo projeto de produção
3. Vá em **Settings > API** e copie:
   - Project URL
   - `anon` public key
   - (Opcional) `service_role` key

4. Rode as migrations:
```bash
npx supabase link --project-ref your-project-ref
npx supabase db push
```

5. Popule o banco com seed (opcional):
```bash
npx supabase db seed
```

6. **Crie usuários admin manualmente** em Supabase Studio:
   - Authentication > Users > Add User
   - Adicione email e senha
   - Na tabela `profiles`, insira o registro com role `admin` ou `leader`

### Passo 2: Deploy no Vercel

1. **Conecte seu repositório:**
```bash
# Se ainda não tem git configurado:
git init
git add .
git commit -m "Preparado para deploy"
git remote add origin https://github.com/seu-usuario/ccp-nextjs.git
git push -u origin main
```

2. **Importe no Vercel:**
   - Acesse [vercel.com](https://vercel.com)
   - New Project > Import Git Repository
   - Selecione o repositório `ccp-nextjs`

3. **Configure Environment Variables:**
   No dashboard do Vercel, adicione:
   ```
   NEXT_PUBLIC_SUPABASE_URL=https://seu-projeto.supabase.co
   NEXT_PUBLIC_SUPABASE_ANON_KEY=sua-chave-anon-aqui
   ```

4. **Deploy:**
   - Clique em "Deploy"
   - Aguarde o build (2-3 minutos)
   - Acesse o site em `https://ccp-nextjs.vercel.app`

### Passo 3: Configurar Domínio Customizado (Opcional)

1. No Vercel, vá em **Settings > Domains**
2. Adicione seu domínio: `casadeprovision.es`
3. Configure DNS conforme instruções
4. SSL automático via Vercel

---

## 🔧 Deploy Alternativo (Netlify, AWS, etc.)

### Netlify

1. Conecte repositório no [netlify.com](https://netlify.com)
2. Build command: `npm run build`
3. Publish directory: `.next`
4. Adicione variáveis de ambiente

### AWS Amplify

1. Conecte repositório no AWS Amplify Console
2. Configure build settings:
```yaml
version: 1
frontend:
  phases:
    preBuild:
      commands:
        - npm install
    build:
      commands:
        - npm run build
  artifacts:
    baseDirectory: .next
    files:
      - '**/*'
  cache:
    paths:
      - node_modules/**/*
```

---

## 🧪 Testes Pós-Deploy

Após o deploy, teste:

- [ ] **Página inicial** carrega corretamente
- [ ] **Login** funciona com credenciais válidas
- [ ] **Painel** está protegido (redireciona para `/login` se não autenticado)
- [ ] **Dashboard** mostra estatísticas reais do banco
- [ ] **CRUD de eventos** funciona (criar, editar, deletar)
- [ ] **CRUD de membros** funciona
- [ ] **CRUD de visitantes** funciona
- [ ] **Widget de follow-up** mostra eventos pendentes
- [ ] **Imagens** carregam corretamente (logo, fotos dos pastores, etc.)
- [ ] **Logout** funciona e redireciona para home

---

## 🐛 Troubleshooting

### Erro: "Missing environment variables"
- Verifique se as variáveis foram adicionadas corretamente na plataforma
- Rebuilde o projeto após adicionar variáveis

### Erro: "Failed to fetch" ou "Network error"
- Verifique se a URL do Supabase está correta
- Verifique se as políticas RLS estão configuradas
- Verifique se o projeto Supabase está ativo

### Imagens não carregam
- Verifique se `next.config.ts` tem os domínios corretos
- Verifique se os arquivos estão em `public/image/`

### Login não funciona
- Verifique se o usuário foi criado no Supabase Auth
- Verifique se o perfil foi criado na tabela `profiles` com role correto
- Verifique se as políticas RLS permitem leitura de profiles

---

## 📊 Monitoramento

Após deploy, configure:

1. **Vercel Analytics** (automático se estiver no Vercel)
2. **Supabase Logs** em Settings > Logs
3. **Alertas de erro** via Sentry (opcional)

---

## 🔒 Segurança

- ✅ Variáveis sensíveis não estão no código
- ✅ RLS ativado em todas as tabelas do Supabase
- ✅ Middleware protege rotas administrativas
- ✅ Service role key não exposta no frontend

---

## 📝 Notas Finais

- **Backup**: Configure backups automáticos no Supabase (Settings > Database > Backups)
- **Monitoramento**: Ative alertas para erros críticos
- **Updates**: Use `git push` para atualizar (Vercel rebuilda automaticamente)

---

**Status Atual**: ✅ Pronto para deploy em produção!
