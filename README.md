# 🌍 Nação Ubuntu Malawi — Plataforma de Arrecadação

> Plataforma PWA de doações PIX para a **Caravana da Saúde 2026** em Malawi, África.

---

## Sobre o Projeto

Sistema completo de arrecadação com geração de código PIX (padrão EMV/BACEN), upload de comprovante, painel administrativo e flyer imprimível.

## Estrutura

```
arrecadação-malawi/
├── index.html              ← PWA de doação (rota principal)
├── admin/
│   └── index.html          ← Painel admin com senha
├── print/
│   └── flyer-a4.html       ← Flyer A4 para impressão
├── sql/
│   └── schema.sql          ← Schema Supabase (rodar no SQL Editor)
├── public/
│   ├── manifest.json       ← PWA manifest
│   ├── sw.js               ← Service Worker (cache offline)
│   └── icons/              ← Ícones PWA (192x192, 512x512)
├── vercel.json             ← Security headers
├── .env.example            ← Template de variáveis
└── .gitignore
```

## Stack

| Camada | Tecnologia |
|--------|-----------|
| Frontend | HTML5 + CSS3 + JavaScript vanilla (sem build) |
| Backend | Supabase (PostgreSQL + Storage + RLS) |
| PIX | EMV padrão BACEN com CRC-16 |
| PWA | Service Worker + Web App Manifest |
| Deploy | Vercel (static) |

## Fluxo de Doação

```
1. Usuário acessa /
2. Seleciona valor (R$500 / R$750 / R$1.000 / R$1.500 / R$2.000 ou outro)
3. PIX code gerado automaticamente (EMV + QR Code)
4. Usuário paga no app do banco
5. Faz upload do comprovante + nome + telefone
6. Admin confirma em /admin/
```

## Setup

### 1. Supabase

```
1. Criar projeto em supabase.com
2. SQL Editor → colar sql/schema.sql → Run
3. Storage → criar bucket "comprovantes" (público: false)
4. Copiar Project URL e anon key
```

### 2. Configurar credenciais

Nos arquivos `index.html` e `admin/index.html`, substituir:

```js
const SUPABASE_URL  = 'SEU_SUPABASE_URL'       // ← URL do projeto
const SUPABASE_KEY  = 'SUA_SUPABASE_ANON_KEY'  // ← anon key
const ADMIN_PWD     = 'SUA_SENHA_ADMIN'         // ← apenas em admin/index.html
```

### 3. Deploy

```bash
vercel --prod
```

## Dados PIX

| Campo | Valor |
|-------|-------|
| Chave | `06045503830` (CPF) |
| Beneficiário | Ricardo Alves Marujo |
| Cidade | Votorantim |
| Descrição | Malawi Saude |

## Contato para doações físicas

**Izabel** — WhatsApp: [(15) 99601-6655](https://wa.me/5515996016655)

## Painel Admin

Acesse `/admin/` e insira a senha configurada em `ADMIN_PWD`.

Funcionalidades:
- Dashboard com total arrecadado, meta e KPIs
- Listagem de doações (pendentes / confirmadas / canceladas)
- Visualização de comprovante
- Confirmar ou cancelar doação

## Nota de Segurança

A autenticação do admin é feita por senha client-side (adequado para campanhas pequenas). Para escalar com dados sensíveis, migrar para Supabase Auth + service_role key via Edge Function.

## Comandos úteis

```bash
# Servir localmente
npx serve . -p 3000

# Abrir flyer para impressão
start print/flyer-a4.html

# Ver logs do deploy
vercel logs
```

---

*Projeto desenvolvido por ZR Agency IA · 2026*
