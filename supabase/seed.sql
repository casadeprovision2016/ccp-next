-- Dados de exemplo para desenvolvimento

-- NOTA: Para crear usuarios de prueba, ejecuta estos comandos en Supabase Studio o usa el script de inicialización:
-- 1. Ir a Authentication > Users > Add User
-- 2. Crear usuarios:
--    - pastor@casadeprovision.es con contraseña segura y metadata: {"name": "Pastor Principal", "role": "admin"}
--    - admin@casadeprovision.es con contraseña segura y metadata: {"name": "Administrador", "role": "leader"}
-- 
-- Los perfiles se crearán automáticamente con el trigger on_auth_user_created

INSERT INTO members (full_name, email, phone, birth_date, status) VALUES
  ('João Silva', 'joao@example.com', '(11) 98765-4321', '1985-03-15', 'active'),
  ('Maria Santos', 'maria@example.com', '(11) 98765-4322', '1990-07-22', 'active'),
  ('Pedro Costa', 'pedro@example.com', '(11) 98765-4323', '1988-11-10', 'active'),
  ('Ana Oliveira', 'ana@example.com', '(11) 98765-4324', '1992-05-28', 'active');

INSERT INTO events (title, description, event_date, event_type, status) VALUES
  ('Culto de Domingo', 'Culto dominical às 10h', '2025-11-07 10:00:00+00', 'service', 'scheduled'),
  ('Conferência Anual', 'Conferência de avivamento', '2025-11-15 19:00:00+00', 'conference', 'scheduled'),
  ('Reunião de Oração', 'Reunião semanal de oração', '2025-11-05 19:00:00+00', 'meeting', 'scheduled');

INSERT INTO ministries (name, description, status) VALUES
  ('Louvor e Adoração', 'Ministério de música e adoração', 'active'),
  ('Jovens', 'Ministério da juventude', 'active'),
  ('Crianças', 'Ministério infantil', 'active');

INSERT INTO streams (title, description, stream_url, platform, scheduled_date, status) VALUES
  ('Culto ao Vivo - Domingo', 'Transmissão do culto dominical', 'https://youtube.com/live/example', 'youtube', '2025-11-07 10:00:00+00', 'scheduled'),
  ('Conferência Online', 'Transmissão da conferência', 'https://youtube.com/live/example2', 'youtube', '2025-11-15 19:00:00+00', 'scheduled');

INSERT INTO visitors (full_name, email, phone, visit_date, source, notes) VALUES
  ('Carlos Mendes', 'carlos@example.com', '(11) 98765-5555', '2025-11-03', 'Convite', 'Interessado em participar do ministério de jovens'),
  ('Juliana Lima', 'juliana@example.com', '(11) 98765-6666', '2025-11-04', 'Redes Sociais', 'Primeira visita');
