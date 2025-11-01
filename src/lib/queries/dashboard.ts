'use client'

import { useQuery } from '@tanstack/react-query'
import { createClient } from '@/lib/supabase/client'

export function useDashboardStats() {
  const supabase = createClient()

  return useQuery({
    queryKey: ['dashboard-stats'],
    queryFn: async () => {
      const now = new Date()
      const firstDayOfMonth = new Date(now.getFullYear(), now.getMonth(), 1)
      const lastDayOfMonth = new Date(now.getFullYear(), now.getMonth() + 1, 0)

      // Contar eventos deste mês
      const { count: eventsCount } = await supabase
        .from('events')
        .select('*', { count: 'exact', head: true })
        .gte('event_date', firstDayOfMonth.toISOString())
        .lte('event_date', lastDayOfMonth.toISOString())

      // Contar membros ativos
      const { count: membersCount } = await supabase
        .from('members')
        .select('*', { count: 'exact', head: true })
        .eq('status', 'active')

      // Contar visitantes deste mês
      const { count: visitorsCount } = await supabase
        .from('visitors')
        .select('*', { count: 'exact', head: true })
        .gte('visit_date', firstDayOfMonth.toISOString().split('T')[0])
        .lte('visit_date', lastDayOfMonth.toISOString().split('T')[0])

      return {
        eventsThisMonth: eventsCount || 0,
        activeMembers: membersCount || 0,
        visitorsThisMonth: visitorsCount || 0,
      }
    },
  })
}
