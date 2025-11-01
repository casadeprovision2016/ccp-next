'use client'

import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { createClient } from '@/lib/supabase/client'

export type Donation = {
  id: string
  donor_name: string | null
  amount: number
  donation_type: string | null
  payment_method: string | null
  donation_date: string
  notes: string | null
  receipt_number: string | null
  follow_up_needed: boolean
  created_by: string | null
  created_at: string
  updated_at: string
}

export type DonationInsert = Omit<Donation, 'id' | 'created_at' | 'updated_at'>
export type DonationUpdate = Partial<DonationInsert>

export function useDonations() {
  const supabase = createClient()

  return useQuery({
    queryKey: ['donations'],
    queryFn: async () => {
      const { data, error } = await supabase
        .from('donations')
        .select('*')
        .order('donation_date', { ascending: false })

      if (error) throw error
      return data as Donation[]
    },
  })
}

export function useCreateDonation() {
  const queryClient = useQueryClient()
  const supabase = createClient()

  return useMutation({
    mutationFn: async (donation: DonationInsert) => {
      const { data, error } = await supabase
        .from('donations')
        .insert(donation)
        .select()
        .single()

      if (error) throw error
      return data
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['donations'] })
    },
  })
}

export function useUpdateDonation() {
  const queryClient = useQueryClient()
  const supabase = createClient()

  return useMutation({
    mutationFn: async ({ id, updates }: { id: string; updates: DonationUpdate }) => {
      const { data, error } = await supabase
        .from('donations')
        .update(updates)
        .eq('id', id)
        .select()
        .single()

      if (error) throw error
      return data
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['donations'] })
    },
  })
}

export function useDeleteDonation() {
  const queryClient = useQueryClient()
  const supabase = createClient()

  return useMutation({
    mutationFn: async (id: string) => {
      const { error } = await supabase.from('donations').delete().eq('id', id)

      if (error) throw error
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['donations'] })
    },
  })
}
