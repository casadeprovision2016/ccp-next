-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Tabla de perfiles de usuarios (extiende auth.users)
CREATE TABLE profiles (
  id UUID REFERENCES auth.users ON DELETE CASCADE PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  name TEXT NOT NULL,
  role TEXT NOT NULL CHECK (role IN ('admin', 'leader', 'member')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW())
);

-- Tabla de miembros
CREATE TABLE members (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  full_name TEXT NOT NULL,
  email TEXT,
  phone TEXT,
  address TEXT,
  birth_date DATE,
  baptism_date DATE,
  membership_date DATE,
  status TEXT CHECK (status IN ('active', 'inactive', 'transferred')),
  notes TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW())
);

-- Tabla de visitantes
CREATE TABLE visitors (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  full_name TEXT NOT NULL,
  email TEXT,
  phone TEXT,
  visit_date DATE NOT NULL,
  source TEXT,
  interested_in TEXT[],
  notes TEXT,
  followed_up BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW())
);

-- Tabla de eventos
CREATE TABLE events (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  title TEXT NOT NULL,
  description TEXT,
  event_date TIMESTAMP WITH TIME ZONE NOT NULL,
  end_date TIMESTAMP WITH TIME ZONE,
  location TEXT,
  event_type TEXT CHECK (event_type IN ('service', 'conference', 'outreach', 'meeting', 'other')),
  image_url TEXT,
  status TEXT CHECK (status IN ('scheduled', 'ongoing', 'completed', 'cancelled')) DEFAULT 'scheduled',
  created_by UUID REFERENCES profiles(id),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW())
);

-- Tabla de ministerios
CREATE TABLE ministries (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT,
  leader_id UUID REFERENCES members(id),
  meeting_schedule TEXT,
  status TEXT CHECK (status IN ('active', 'inactive')) DEFAULT 'active',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW())
);

-- Tabla de miembros de ministerios (relación muchos a muchos)
CREATE TABLE ministry_members (
  ministry_id UUID REFERENCES ministries(id) ON DELETE CASCADE,
  member_id UUID REFERENCES members(id) ON DELETE CASCADE,
  joined_date DATE DEFAULT CURRENT_DATE,
  role TEXT,
  PRIMARY KEY (ministry_id, member_id)
);

-- Tabla de donaciones
CREATE TABLE donations (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  donor_name TEXT,
  amount DECIMAL(10, 2) NOT NULL,
  donation_type TEXT CHECK (donation_type IN ('tithe', 'offering', 'mission', 'building', 'other')),
  payment_method TEXT CHECK (payment_method IN ('cash', 'transfer', 'pix', 'card', 'other')),
  donation_date DATE NOT NULL,
  notes TEXT,
  receipt_number TEXT UNIQUE,
  created_by UUID REFERENCES profiles(id),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW())
);

-- Tabla de visitas pastorales
CREATE TABLE pastoral_visits (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  member_id UUID REFERENCES members(id),
  visitor_id UUID REFERENCES visitors(id),
  visit_date DATE NOT NULL,
  visit_type TEXT CHECK (visit_type IN ('home', 'hospital', 'counseling', 'other')),
  pastor_id UUID REFERENCES profiles(id),
  notes TEXT,
  follow_up_needed BOOLEAN DEFAULT FALSE,
  status TEXT CHECK (status IN ('scheduled', 'completed', 'cancelled')) DEFAULT 'scheduled',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW())
);

-- Tabla de transmisiones
CREATE TABLE streams (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  title TEXT NOT NULL,
  description TEXT,
  stream_url TEXT NOT NULL,
  platform TEXT CHECK (platform IN ('youtube', 'facebook', 'vimeo', 'other')),
  scheduled_date TIMESTAMP WITH TIME ZONE NOT NULL,
  status TEXT CHECK (status IN ('scheduled', 'live', 'ended')) DEFAULT 'scheduled',
  thumbnail_url TEXT,
  created_by UUID REFERENCES profiles(id),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW())
);

-- Índices para melhor performance
CREATE INDEX idx_members_birth_date ON members(birth_date);
CREATE INDEX idx_events_date ON events(event_date);
CREATE INDEX idx_donations_date ON donations(donation_date);
CREATE INDEX idx_pastoral_visits_date ON pastoral_visits(visit_date);
CREATE INDEX idx_streams_scheduled_date ON streams(scheduled_date);

-- Row Level Security (RLS)
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE members ENABLE ROW LEVEL SECURITY;
ALTER TABLE visitors ENABLE ROW LEVEL SECURITY;
ALTER TABLE events ENABLE ROW LEVEL SECURITY;
ALTER TABLE ministries ENABLE ROW LEVEL SECURITY;
ALTER TABLE ministry_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE donations ENABLE ROW LEVEL SECURITY;
ALTER TABLE pastoral_visits ENABLE ROW LEVEL SECURITY;
ALTER TABLE streams ENABLE ROW LEVEL SECURITY;

-- Policies para profiles
CREATE POLICY "Users can view own profile" ON profiles FOR SELECT USING (auth.uid() = id);
CREATE POLICY "Users can update own profile" ON profiles FOR UPDATE USING (auth.uid() = id);

-- Policies para leitura pública (eventos e streams para homepage)
CREATE POLICY "Events are viewable by everyone" ON events FOR SELECT USING (status = 'scheduled' OR status = 'ongoing');
CREATE POLICY "Streams are viewable by everyone" ON streams FOR SELECT USING (status = 'scheduled' OR status = 'live');

-- Policies para admin/leader (todas as operações)
CREATE POLICY "Admin can do everything on members" ON members FOR ALL USING (
  EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role IN ('admin', 'leader'))
);

CREATE POLICY "Admin can do everything on visitors" ON visitors FOR ALL USING (
  EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role IN ('admin', 'leader'))
);

CREATE POLICY "Admin can do everything on events" ON events FOR ALL USING (
  EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role IN ('admin', 'leader'))
);

CREATE POLICY "Admin can do everything on ministries" ON ministries FOR ALL USING (
  EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role IN ('admin', 'leader'))
);

CREATE POLICY "Admin can do everything on donations" ON donations FOR ALL USING (
  EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role IN ('admin', 'leader'))
);

CREATE POLICY "Admin can do everything on pastoral_visits" ON pastoral_visits FOR ALL USING (
  EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role IN ('admin', 'leader'))
);

CREATE POLICY "Admin can do everything on streams" ON streams FOR ALL USING (
  EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role IN ('admin', 'leader'))
);

-- Función para atualizar updated_at automaticamente
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = TIMEZONE('utc', NOW());
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Triggers para updated_at
CREATE TRIGGER update_profiles_updated_at BEFORE UPDATE ON profiles FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_members_updated_at BEFORE UPDATE ON members FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_visitors_updated_at BEFORE UPDATE ON visitors FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_events_updated_at BEFORE UPDATE ON events FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_ministries_updated_at BEFORE UPDATE ON ministries FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_donations_updated_at BEFORE UPDATE ON donations FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_pastoral_visits_updated_at BEFORE UPDATE ON pastoral_visits FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_streams_updated_at BEFORE UPDATE ON streams FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
