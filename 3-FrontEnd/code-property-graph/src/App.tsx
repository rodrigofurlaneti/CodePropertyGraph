import { BrowserRouter, Routes, Route } from 'react-router-dom'
import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import { ReactQueryDevtools } from '@tanstack/react-query-devtools'
import { AppShell } from './components/layout/AppShell'
import { GraphPage } from './pages/GraphPage'
import { DddArchitecturePage } from './pages/DddArchitecturePage'
import { DddSubdivisionPage } from './pages/DddSubdivisionPage'
import { LayerDetailPage } from './pages/LayerDetailPage'
import { ViolationsPage } from './pages/ViolationsPage'
import {
  LayersPage, ProjectsPage, NamespacesPage,
  DirectoriesPage, CodeElementsPage,
  ApiEndpointsPage, HandlerContractsPage,
} from './pages/EntityPages'

const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      retry: 1,
      staleTime: 30_000,
    },
  },
})

export function App() {
  return (
    <QueryClientProvider client={queryClient}>
      <BrowserRouter>
        <Routes>
          <Route element={<AppShell />}>
            <Route index element={<GraphPage />} />
            <Route path="ddd" element={<DddArchitecturePage />} />
            <Route path="ddd-sub" element={<DddSubdivisionPage />} />
            <Route path="layer-detail" element={<LayerDetailPage />} />
            <Route path="violations" element={<ViolationsPage />} />
            <Route path="layers" element={<LayersPage />} />
            <Route path="projects" element={<ProjectsPage />} />
            <Route path="namespaces" element={<NamespacesPage />} />
            <Route path="directories" element={<DirectoriesPage />} />
            <Route path="code-elements" element={<CodeElementsPage />} />
            <Route path="api-endpoints" element={<ApiEndpointsPage />} />
            <Route path="handler-contracts" element={<HandlerContractsPage />} />
          </Route>
        </Routes>
      </BrowserRouter>
      <ReactQueryDevtools initialIsOpen={false} />
    </QueryClientProvider>
  )
}
