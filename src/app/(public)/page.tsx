import { createClient } from '@/lib/supabase/server'
import Header from '@/components/home/Header'
import HeroSection from '@/components/home/HeroSection'
import AboutSection from '@/components/home/AboutSection'
import CalendarSection from '@/components/home/CalendarSection'
import LiveStreamSection from '@/components/home/LiveStreamSection'
import DonationsSection from '@/components/home/DonationsSection'
import ContactSection from '@/components/home/ContactSection'
import MisionesSection from '@/components/home/MisionesSection'
import Footer from '@/components/home/Footer'

export default async function Home() {
  const supabase = await createClient()

  // Buscar próximos eventos (scheduled ou ongoing)
  const { data: events } = await supabase
    .from('events')
    .select('*')
    .in('status', ['scheduled', 'ongoing'])
    .order('event_date', { ascending: true })
    .limit(6)

  // Buscar próximas transmisiones (scheduled o live)
  const { data: streams } = await supabase
    .from('streams')
    .select('*')
    .in('status', ['scheduled', 'live'])
    .order('scheduled_date', { ascending: true })
    .limit(3)

  return (
    <div className="min-h-screen">
      <Header />
      <HeroSection />
      <AboutSection />
      <CalendarSection events={events || []} />
      <LiveStreamSection streams={streams || []} />
      <DonationsSection />
      <ContactSection />
      <MisionesSection />
      <Footer />
    </div>
  )
}
