-- Adicionar campo follow_up_needed às tabelas que ainda não têm
-- Funcionalidade OBRIGATÓRIA: Flag "Requiere seguimiento" com badge ⚠️

-- Adicionar follow_up_needed em events
ALTER TABLE events 
ADD COLUMN IF NOT EXISTS follow_up_needed BOOLEAN DEFAULT FALSE;

-- Adicionar follow_up_needed em donations
ALTER TABLE donations 
ADD COLUMN IF NOT EXISTS follow_up_needed BOOLEAN DEFAULT FALSE;

-- Adicionar follow_up_needed em visitors (já tem followed_up, mas vamos adicionar follow_up_needed para consistência)
ALTER TABLE visitors 
ADD COLUMN IF NOT EXISTS follow_up_needed BOOLEAN DEFAULT FALSE;

-- Comentários para documentação
COMMENT ON COLUMN events.follow_up_needed IS 'Indica se o evento requer acompanhamento posterior (badge ⚠️)';
COMMENT ON COLUMN donations.follow_up_needed IS 'Indica se a doação requer acompanhamento (ex: recibo pendente, agradecimento)';
COMMENT ON COLUMN visitors.follow_up_needed IS 'Indica se o visitante requer acompanhamento adicional';

-- Índices para melhorar performance de queries filtradas por follow_up_needed
CREATE INDEX IF NOT EXISTS idx_events_follow_up ON events(follow_up_needed) WHERE follow_up_needed = TRUE;
CREATE INDEX IF NOT EXISTS idx_donations_follow_up ON donations(follow_up_needed) WHERE follow_up_needed = TRUE;
CREATE INDEX IF NOT EXISTS idx_visitors_follow_up ON visitors(follow_up_needed) WHERE follow_up_needed = TRUE;
