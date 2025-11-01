'use client'

import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { createClient } from '@/lib/supabase/client'

export type Visitor = {
  id: string
  full_name: string
  email: string | null
  phone: string | null
  visit_date: string
  source: string | null
  interested_in: string[] | null
  notes: string | null
  followed_up: boolean
  follow_up_needed: boolean
  created_at: string
  updated_at: string
}

export type VisitorInsert = Omit<Visitor, 'id' | 'created_at' | 'updated_at'>
export type VisitorUpdate = Partial<VisitorInsert>

export function useVisitors() {
  const supabase = createClient()

  return useQuery({
    queryKey: ['visitors'],
    queryFn: async () => {
      const { data, error } = await supabase
        .from('visitors')
        .select('*')
        .order('visit_date', { ascending: false })

      if (error) throw error
      return data as Visitor[]
    },
  })
}

export function useCreateVisitor() {
  const queryClient = useQueryClient()
  const supabase = createClient()

  return useMutation({
    mutationFn: async (visitor: VisitorInsert) => {
      const { data, error } = await supabase
        .from('visitors')
        .insert(visitor)
        .select()
        .single()

      if (error) throw error
      return data
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['visitors'] })
    },
  })
}

export function useUpdateVisitor() {
  const queryClient = useQueryClient()
  const supabase = createClient()

  return useMutation({
    mutationFn: async ({ id, updates }: { id: string; updates: VisitorUpdate }) => {
      const { data, error } = await supabase
        .from('visitors')
        .update(updates)
        .eq('id', id)
        .select()
        .single()

      if (error) throw error
      return data
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['visitors'] })
    },
  })
}

export function useDeleteVisitor() {
  const queryClient = useQueryClient()
  const supabase = createClient()

  return useMutation({
    mutationFn: async (id: string) => {
      const { error } = await supabase.from('visitors').delete().eq('id', id)

      if (error) throw error
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['visitors'] })
    },
  })
}
