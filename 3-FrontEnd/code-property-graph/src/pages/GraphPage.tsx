import { useMemo } from 'react'
import { useQuery } from '@tanstack/react-query'
import { AlertTriangle, RefreshCw, Network } from 'lucide-react'
import { graphApi } from '../api/graph'
import { useGraphStore } from '../store/graphStore'
import { GraphCanvas } from '../components/graph/GraphCanvas'
import { GraphFiltersPanel } from '../components/graph/GraphFiltersPanel'
import { NodeDetailPanel } from '../components/graph/NodeDetailPanel'
import type { GraphNode } from '../types'

export function GraphPage() {
  const { filters, selectedNodeId, setSelectedNodeId } = useGraphStore()

  const { data, isLoading, isError, refetch } = useQuery({
    queryKey: ['graph', filters.projectId, filters.layerId],
    queryFn: () => graphApi.getGraphData(filters.projectId, filters.layerId),
  })

  const filteredData = useMemo(() => {
    if (!data) return { nodes: [], edges: [] }

    let nodes = data.nodes.filter(
      (n) => filters.elementTypes.includes(n.type)
    )

    if (filters.searchTerm.trim()) {
      const term = filters.searchTerm.toLowerCase()
      nodes = nodes.filter(
        (n) =>
          n.label.toLowerCase().includes(term) ||
          n.namespace.toLowerCase().includes(term)
      )
    }

    const nodeIds = new Set(nodes.map((n) => n.id))
    let edges = data.edges.filter(
      (e) => nodeIds.has(e.source) && nodeIds.has(e.target)
    )

    if (filters.showOnlyDirect) {
      edges = edges.filter((e) => e.isDirect)
    }

    return { nodes, edges }
  }, [data, filters])

  const selectedNode = useMemo(
    () => filteredData.nodes.find((n) => n.id === selectedNodeId) as GraphNode | undefined,
    [filteredData.nodes, selectedNodeId]
  )

  return (
    <div style={{ display: 'flex', height: '100%', overflow: 'hidden' }}>
      {/* Sidebar esquerdo — Filtros */}
      <GraphFiltersPanel />

      {/* Main: grafo */}
      <div style={{ flex: 1, display: 'flex', flexDirection: 'column', position: 'relative' }}>
        {/* Toolbar */}
        <div style={{
          padding: '10px 16px', borderBottom: '1px solid #e2e8f0', background: '#fff',
          display: 'flex', alignItems: 'center', gap: 12,
        }}>
          <Network size={18} color="#6366f1" />
          <span style={{ fontWeight: 700, color: '#1e293b', fontSize: 15 }}>
            Knowledge Graph
          </span>
          <span style={{
            background: '#f1f5f9', borderRadius: 20, padding: '2px 10px',
            fontSize: 12, color: '#64748b',
          }}>
            {filteredData.nodes.length} nós · {filteredData.edges.length} arestas
          </span>
          <button
            onClick={() => refetch()}
            style={{
              marginLeft: 'auto', display: 'flex', alignItems: 'center', gap: 6,
              background: '#f8fafc', border: '1px solid #e2e8f0', borderRadius: 8,
              padding: '5px 12px', fontSize: 12, cursor: 'pointer', color: '#374151',
            }}
          >
            <RefreshCw size={13} />
            Atualizar
          </button>
        </div>

        {/* Canvas */}
        <div style={{ flex: 1, position: 'relative' }}>
          {isLoading && (
            <div style={{
              position: 'absolute', inset: 0, display: 'flex',
              alignItems: 'center', justifyContent: 'center',
              background: 'rgba(248,250,252,0.85)', zIndex: 10,
            }}>
              <div style={{ textAlign: 'center' }}>
                <div style={{ fontSize: 32, marginBottom: 8 }}>⟳</div>
                <p style={{ color: '#64748b', fontSize: 14 }}>Carregando grafo...</p>
              </div>
            </div>
          )}
          {isError && (
            <div style={{
              position: 'absolute', inset: 0, display: 'flex',
              alignItems: 'center', justifyContent: 'center',
            }}>
              <div style={{
                textAlign: 'center', padding: 24,
                background: '#fff', border: '1px solid #fee2e2',
                borderRadius: 12, maxWidth: 360,
              }}>
                <AlertTriangle size={32} color="#ef4444" style={{ marginBottom: 8 }} />
                <p style={{ color: '#dc2626', fontWeight: 600 }}>Erro ao carregar o grafo</p>
                <p style={{ color: '#6b7280', fontSize: 13, marginTop: 4 }}>
                  Verifique se a API está rodando em localhost:5000
                </p>
                <button
                  onClick={() => refetch()}
                  style={{
                    marginTop: 12, padding: '8px 20px',
                    background: '#6366f1', color: '#fff', border: 'none',
                    borderRadius: 8, cursor: 'pointer', fontSize: 13,
                  }}
                >
                  Tentar novamente
                </button>
              </div>
            </div>
          )}
          {data && (
            <GraphCanvas
              data={filteredData}
              onNodeClick={setSelectedNodeId}
            />
          )}
        </div>
      </div>

      {/* Painel direito — Detalhes do nó */}
      {selectedNode && (
        <NodeDetailPanel
          node={selectedNode}
          edges={filteredData.edges}
          allNodes={filteredData.nodes}
          onClose={() => setSelectedNodeId(null)}
        />
      )}
    </div>
  )
}
