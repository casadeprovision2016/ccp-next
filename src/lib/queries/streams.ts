'use client'

import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { createClient } from '@/lib/supabase/client'

export type Stream = {
  id: string
  title: string
  description: string | null
  stream_url: string
  platform: string | null
  scheduled_date: string
  status: string | null
  thumbnail_url: string | null
  created_by: string | null
  created_at: string
  updated_at: string
}

export type StreamInsert = Omit<Stream, 'id' | 'created_at' | 'updated_at'>
export type StreamUpdate = Partial<StreamInsert>

export function useStreams() {
  const supabase = createClient()

  return useQuery({
    queryKey: ['streams'],
    queryFn: async () => {
      const { data, error } = await supabase
        .from('streams')
        .select('*')
        .order('scheduled_date', { ascending: true })

      if (error) throw error
      return data as Stream[]
    },
  })
}

export function useCreateStream() {
  const queryClient = useQueryClient()
  const supabase = createClient()

  return useMutation({
    mutationFn: async (stream: StreamInsert) => {
      const { data, error } = await supabase
        .from('streams')
        .insert(stream)
        .select()
        .single()

      if (error) throw error
      return data
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['streams'] })
    },
  })
}

export function useUpdateStream() {
  const queryClient = useQueryClient()
  const supabase = createClient()

  return useMutation({
    mutationFn: async ({ id, updates }: { id: string; updates: StreamUpdate }) => {
      const { data, error } = await supabase
        .from('streams')
        .update(updates)
        .eq('id', id)
        .select()
        .single()

      if (error) throw error
      return data
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['streams'] })
    },
  })
}

export function useDeleteStream() {
  const queryClient = useQueryClient()
  const supabase = createClient()

  return useMutation({
    mutationFn: async (id: string) => {
      const { error } = await supabase.from('streams').delete().eq('id', id)

      if (error) throw error
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['streams'] })
    },
  })
}
