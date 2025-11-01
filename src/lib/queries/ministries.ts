'use client'

import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { createClient } from '@/lib/supabase/client'

export type Ministry = {
  id: string
  name: string
  description: string | null
  leader_id: string | null
  meeting_schedule: string | null
  status: string | null
  created_at: string
  updated_at: string
}

export type MinistryInsert = Omit<Ministry, 'id' | 'created_at' | 'updated_at'>
export type MinistryUpdate = Partial<MinistryInsert>

export function useMinistries() {
  const supabase = createClient()

  return useQuery({
    queryKey: ['ministries'],
    queryFn: async () => {
      const { data, error } = await supabase
        .from('ministries')
        .select('*')
        .order('name', { ascending: true })

      if (error) throw error
      return data as Ministry[]
    },
  })
}

export function useCreateMinistry() {
  const queryClient = useQueryClient()
  const supabase = createClient()

  return useMutation({
    mutationFn: async (ministry: MinistryInsert) => {
      const { data, error } = await supabase
        .from('ministries')
        .insert(ministry)
        .select()
        .single()

      if (error) throw error
      return data
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['ministries'] })
    },
  })
}

export function useUpdateMinistry() {
  const queryClient = useQueryClient()
  const supabase = createClient()

  return useMutation({
    mutationFn: async ({ id, updates }: { id: string; updates: MinistryUpdate }) => {
      const { data, error } = await supabase
        .from('ministries')
        .update(updates)
        .eq('id', id)
        .select()
        .single()

      if (error) throw error
      return data
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['ministries'] })
    },
  })
}

export function useDeleteMinistry() {
  const queryClient = useQueryClient()
  const supabase = createClient()

  return useMutation({
    mutationFn: async (id: string) => {
      const { error } = await supabase.from('ministries').delete().eq('id', id)

      if (error) throw error
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['ministries'] })
    },
  })
}
