-- ============================================================
-- Nação Ubuntu Malawi — Donation Platform
-- Rodar no Supabase SQL Editor
-- ============================================================

-- Tabela de doações
CREATE TABLE IF NOT EXISTS doacoes (
  id            uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  created_at    timestamptz DEFAULT now(),
  nome          text NOT NULL,
  telefone      text,
  email         text,
  valor         numeric(10,2) NOT NULL,
  status        text NOT NULL DEFAULT 'pendente'
                CHECK (status IN ('pendente','confirmado','cancelado')),
  comprovante_url text,
  comprovante_nome text,
  pix_txid      text,
  observacoes   text,
  confirmado_em timestamptz,
  confirmado_por text
);

-- Tabela de configurações (mensagens, metas)
CREATE TABLE IF NOT EXISTS configuracoes (
  id      serial PRIMARY KEY,
  chave   text UNIQUE NOT NULL,
  valor   text
);

-- Tabela de log de admin
CREATE TABLE IF NOT EXISTS admin_log (
  id         serial PRIMARY KEY,
  created_at timestamptz DEFAULT now(),
  acao       text NOT NULL,
  detalhes   jsonb
);

-- Dados iniciais de configuração
INSERT INTO configuracoes (chave, valor) VALUES
  ('meta_valor',    '50000'),
  ('meta_label',    'Meta: R$ 50.000'),
  ('pix_key',       '06432680816'),
  ('pix_name',      'Maria Izabel Moreno de So'),
  ('pix_city',      'SAO PAULO'),
  ('whatsapp_izabel','5515996016655'),
  ('campanha_ativa', 'true')
ON CONFLICT (chave) DO NOTHING;

-- RLS
ALTER TABLE doacoes       ENABLE ROW LEVEL SECURITY;
ALTER TABLE configuracoes ENABLE ROW LEVEL SECURITY;
ALTER TABLE admin_log     ENABLE ROW LEVEL SECURITY;

-- Policies: qualquer um pode inserir doação (anon)
CREATE POLICY "insert_doacoes" ON doacoes
  FOR INSERT TO anon WITH CHECK (true);

-- Leitura pública apenas das configurações
CREATE POLICY "read_config" ON configuracoes
  FOR SELECT TO anon USING (true);

-- Admin (service_role) tem acesso total — não precisa de policy separada

-- Policies para o painel admin (usa anon key com senha client-side)
-- ⚠️ Para produção com dados sensíveis: migrar para Supabase Auth + service_role via Edge Function
CREATE POLICY "read_doacoes" ON doacoes
  FOR SELECT TO anon USING (true);

CREATE POLICY "update_doacoes" ON doacoes
  FOR UPDATE TO anon USING (true) WITH CHECK (true);

-- Admin log: apenas inserção (anon)
CREATE POLICY "insert_admin_log" ON admin_log
  FOR INSERT TO anon WITH CHECK (true);

-- View: resumo de doações por status
CREATE OR REPLACE VIEW resumo_doacoes AS
SELECT
  status,
  COUNT(*)          AS total,
  SUM(valor)        AS valor_total,
  AVG(valor)        AS valor_medio,
  MAX(created_at)   AS ultima_doacao
FROM doacoes
GROUP BY status;

-- View: total confirmado
CREATE OR REPLACE VIEW total_arrecadado AS
SELECT
  COALESCE(SUM(valor), 0) AS total,
  COUNT(*)                 AS qtd
FROM doacoes
WHERE status = 'confirmado';

-- Index para performance
CREATE INDEX IF NOT EXISTS idx_doacoes_status     ON doacoes(status);
CREATE INDEX IF NOT EXISTS idx_doacoes_created_at ON doacoes(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_doacoes_nome       ON doacoes(nome);
