# ETERIUM — Projeto Nação Ubuntu Malawi · Donation Platform

## Visão Geral
Sistema de doações PIX para a Caravana da Saúde 2026 — Malawi.
PWA com seleção de valor, geração de código PIX, upload de comprovante e admin panel.

## Stack
- **Frontend**: HTML/CSS/JS vanilla (sem build) — Vercel static deploy
- **Backend**: Supabase (PostgreSQL + Storage + RLS)
- **Deploy**: Vercel (`vercel --prod`)
- **Impressão**: `print/flyer-a4.html` — abrir no browser → Ctrl+P → A4

## Estrutura
```
malawi/
├── CLAUDE.md
├── index.html          ← PWA principal (doação + PIX)
├── admin/
│   └── index.html      ← Admin panel (requer senha)
├── print/
│   └── flyer-a4.html   ← Página para impressão gráfica A4
├── sql/
│   └── schema.sql      ← Rodar no Supabase SQL Editor
├── public/
│   ├── manifest.json
│   ├── sw.js
│   └── icons/
├── vercel.json
└── .env.example
```

## Setup Rápido

### 1. Supabase
```
1. Criar projeto no supabase.com
2. Abrir SQL Editor → colar conteúdo de sql/schema.sql → Run
3. Em Storage → criar bucket "comprovantes" (público: false)
4. Copiar URL e anon key do projeto
```

### 2. Variáveis de Ambiente
Copiar `.env.example` para `.env` e preencher:
```
SUPABASE_URL=https://xxxx.supabase.co
SUPABASE_ANON_KEY=eyJ...
ADMIN_PASSWORD=sua_senha_admin
```

### 3. Configurar no index.html e admin/index.html
Substituir nos arquivos:
- `SEU_SUPABASE_URL` → URL do projeto Supabase
- `SUA_SUPABASE_ANON_KEY` → anon key
- `SUA_SENHA_ADMIN` → senha do admin

### 4. Deploy
```bash
vercel --prod
```

## Dados PIX
- **Chave PIX**: 06045503830 (CPF)
- **Beneficiário**: Ricardo Alves Marujo
- **Contato doações físicas**: Izabel — (15) 99601-6655

## Fluxo de Doação
1. Usuário acessa a página
2. Escolhe valor (R$500, R$750, R$1.000, R$1.500, R$2.000 ou outro)
3. Código PIX é gerado automaticamente (EMV padrão BACEN)
4. Usuário copia o código ou escaneia o QR
5. Paga no app do banco
6. Preenche nome + telefone + faz upload do comprovante
7. Admin visualiza no painel e confirma

## Comandos úteis (Claude Code)
```bash
# Ver logs Vercel
vercel logs

# Abrir preview local
npx serve . -p 3000

# Imprimir flyer (abrir no Chrome)
open print/flyer-a4.html
```
