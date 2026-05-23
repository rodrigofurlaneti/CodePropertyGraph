import { create } from 'zustand'
import type { GraphFilters } from '../types'

interface GraphStore {
  filters: GraphFilters
  selectedNodeId: string | null
  setFilters: (filters: Partial<GraphFilters>) => void
  setSelectedNodeId: (id: string | null) => void
  resetFilters: () => void
}

const defaultFilters: GraphFilters = {
  projectId: undefined,
  layerId: undefined,
  elementTypes: ['Class', 'Interface', 'Record', 'Enum'],
  showOnlyDirect: false,
  searchTerm: '',
}

export const useGraphStore = create<GraphStore>((set) => ({
  filters: defaultFilters,
  selectedNodeId: null,
  setFilters: (partial) =>
    set((state) => ({ filters: { ...state.filters, ...partial } })),
  setSelectedNodeId: (id) => set({ selectedNodeId: id }),
  resetFilters: () => set({ filters: defaultFilters, selectedNodeId: null }),
}))
