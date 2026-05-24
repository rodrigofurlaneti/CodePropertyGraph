import type { GraphData, ArchitectureViolation, Layer, Project, CodeElement, Namespace, Directory, ApiEndpoint, HandlerContract } from '../types'
import { apiClient } from './client'

// Graph
export const graphApi = {
  getGraphData: async (projectId?: number, layerId?: number): Promise<GraphData> => {
    const params = new URLSearchParams()
    if (projectId) params.set('projectId', String(projectId))
    if (layerId) params.set('layerId', String(layerId))
    const { data } = await apiClient.get<GraphData>(`/graph?${params}`)
    return data
  },
  getViolations: async (sourceLayer = 'Domain', targetLayer = 'Infrastructure'): Promise<ArchitectureViolation[]> => {
    const { data } = await apiClient.get<ArchitectureViolation[]>(
      `/graph/violations?sourceLayer=${sourceLayer}&targetLayer=${targetLayer}`
    )
    return data
  },
}

// Layers
export const layersApi = {
  getAll: async (): Promise<Layer[]> => (await apiClient.get<Layer[]>('/layers')).data,
  getById: async (id: number): Promise<Layer> => (await apiClient.get<Layer>(`/layers/${id}`)).data,
  create: async (data: Omit<Layer, 'id'>): Promise<number> => (await apiClient.post<number>('/layers', data)).data,
  update: async (id: number, data: Omit<Layer, 'id'>): Promise<void> => { await apiClient.put(`/layers/${id}`, { id, ...data }) },
  delete: async (id: number): Promise<void> => { await apiClient.delete(`/layers/${id}`) },
}

// Projects
export const projectsApi = {
  getAll: async (): Promise<Project[]> => (await apiClient.get<Project[]>('/projects')).data,
  getById: async (id: number): Promise<Project> => (await apiClient.get<Project>(`/projects/${id}`)).data,
  create: async (data: Omit<Project, 'id'>): Promise<number> => (await apiClient.post<number>('/projects', data)).data,
  update: async (id: number, data: Omit<Project, 'id'>): Promise<void> => { await apiClient.put(`/projects/${id}`, { id, ...data }) },
  delete: async (id: number): Promise<void> => { await apiClient.delete(`/projects/${id}`) },
}

// Namespaces
export const namespacesApi = {
  getAll: async (): Promise<Namespace[]> => (await apiClient.get<Namespace[]>('/namespaces')).data,
  create: async (fullName: string): Promise<number> => (await apiClient.post<number>('/namespaces', { fullName })).data,
  update: async (id: number, fullName: string): Promise<void> => { await apiClient.put(`/namespaces/${id}`, { id, fullName }) },
  delete: async (id: number): Promise<void> => { await apiClient.delete(`/namespaces/${id}`) },
}

// Directories
export const directoriesApi = {
  getAll: async (): Promise<Directory[]> => (await apiClient.get<Directory[]>('/directories')).data,
  create: async (path: string): Promise<number> => (await apiClient.post<number>('/directories', { path })).data,
  update: async (id: number, path: string): Promise<void> => { await apiClient.put(`/directories/${id}`, { id, path }) },
  delete: async (id: number): Promise<void> => { await apiClient.delete(`/directories/${id}`) },
}

// CodeElements
export const codeElementsApi = {
  getAll: async (): Promise<CodeElement[]> => (await apiClient.get<CodeElement[]>('/codeelements')).data,
  getById: async (id: number): Promise<CodeElement> => (await apiClient.get<CodeElement>(`/codeelements/${id}`)).data,
  create: async (data: Omit<CodeElement, 'id' | 'layerName' | 'projectName' | 'namespaceFullName' | 'directoryPath'>): Promise<number> =>
    (await apiClient.post<number>('/codeelements', data)).data,
  update: async (id: number, data: Omit<CodeElement, 'layerName' | 'projectName' | 'namespaceFullName' | 'directoryPath'>): Promise<void> => {
    await apiClient.put(`/codeelements/${id}`, data)
  },
  delete: async (id: number): Promise<void> => { await apiClient.delete(`/codeelements/${id}`) },
}

// ApiEndpoints
export const apiEndpointsApi = {
  getAll: async (): Promise<ApiEndpoint[]> => (await apiClient.get<ApiEndpoint[]>('/apiendpoints')).data,
  create: async (data: Omit<ApiEndpoint, 'id' | 'controllerName' | 'inputName' | 'outputName'>): Promise<number> =>
    (await apiClient.post<number>('/apiendpoints', data)).data,
  delete: async (id: number): Promise<void> => { await apiClient.delete(`/apiendpoints/${id}`) },
}

// HandlerContracts
export const handlerContractsApi = {
  getAll: async (): Promise<HandlerContract[]> => (await apiClient.get<HandlerContract[]>('/handlercontracts')).data,
  create: async (data: Pick<HandlerContract, 'handlerId' | 'inputId' | 'outputId'>): Promise<void> => {
    await apiClient.post('/handlercontracts', data)
  },
  delete: async (handlerId: number): Promise<void> => { await apiClient.delete(`/handlercontracts/${handlerId}`) },
}
