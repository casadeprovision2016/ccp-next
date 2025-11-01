'use client'

import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { createClient } from '@/lib/supabase/client'

export type PastoralVisit = {
  id: string
  member_id: string | null
  visitor_id: string | null
  visit_date: string
  visit_type: string | null
  pastor_id: string | null
  notes: string | null
  follow_up_needed: boolean
  status: string | null
  created_at: string
  updated_at: string
}

export type PastoralVisitInsert = Omit<PastoralVisit, 'id' | 'created_at' | 'updated_at'>
export type PastoralVisitUpdate = Partial<PastoralVisitInsert>

export function usePastoralVisits() {
  const supabase = createClient()

  return useQuery({
    queryKey: ['pastoral-visits'],
    queryFn: async () => {
      const { data, error } = await supabase
        .from('pastoral_visits')
        .select('*')
        .order('visit_date', { ascending: false })

      if (error) throw error
      return data as PastoralVisit[]
    },
  })
}

export function useCreatePastoralVisit() {
  const queryClient = useQueryClient()
  const supabase = createClient()

  return useMutation({
    mutationFn: async (visit: PastoralVisitInsert) => {
      const { data, error } = await supabase
        .from('pastoral_visits')
        .insert(visit)
        .select()
        .single()

      if (error) throw error
      return data
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['pastoral-visits'] })
    },
  })
}

export function useUpdatePastoralVisit() {
  const queryClient = useQueryClient()
  const supabase = createClient()

  return useMutation({
    mutationFn: async ({ id, updates }: { id: string; updates: PastoralVisitUpdate }) => {
      const { data, error } = await supabase
        .from('pastoral_visits')
        .update(updates)
        .eq('id', id)
        .select()
        .single()

      if (error) throw error
      return data
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['pastoral-visits'] })
    },
  })
}

export function useDeletePastoralVisit() {
  const queryClient = useQueryClient()
  const supabase = createClient()

  return useMutation({
    mutationFn: async (id: string) => {
      const { error } = await supabase.from('pastoral_visits').delete().eq('id', id)

      if (error) throw error
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['pastoral-visits'] })
    },
  })
}
