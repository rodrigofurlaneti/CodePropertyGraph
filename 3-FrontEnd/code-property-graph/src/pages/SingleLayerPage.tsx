import { useMemo } from 'react'
import { useParams, Navigate } from 'react-router-dom'
import { useQuery } from '@tanstack/react-query'
import { AlertTriangle, RefreshCw } from 'lucide-react'
import { graphApi } from '../api/graph'
import { useGraphStore } from '../store/graphStore'
import { GraphFiltersPanel } from '../components/graph/GraphFiltersPanel'
import { NodeDetailPanel } from '../components/graph/NodeDetailPanel'
import { SingleLayerCanvas } from '../components/graph/SingleLayerCanvas'
import type { GraphNode } from '../types'

const VALID_LAYERS = ['Domain', 'Application', 'Infrastructure', 'Api'] as const
type LayerName = typeof VALID_LAYERS[number]

const LAYER_META: Record<LayerName, { color: string; bg: string; border: string; desc: string; emoji: string }> = {
  Domain: {
    color: '#7c3aed', bg: '#faf5ff', border: '#e9d5ff',
    desc: 'Entidades, Interfaces, Value Objects, Common — nucleo do negocio',
    emoji: '🟣',
  },
  Application: {
    color: '#1d4ed8', bg: '#eff6ff', border: '#bfdbfe',
    desc: 'Features, Handlers, Mappings, Common — orquestracao de casos de uso',
    emoji: '🔵',
  },
  Infrastructure: {
    color: '#0f766e', bg: '#f0fdfa', border: '#99f6e4',
    desc: 'Persistence, Repositories, Configurations — acesso a dados e infra',
    emoji: '🟢',
  },
  Api: {
    color: '#c2410c', bg: '#fff7ed', border: '#fed7aa',
    desc: 'Controllers, Extensions — entrada HTTP e contratos REST',
    emoji: '🟠',
  },
}

function capitalize(s: string) {
  return s.charAt(0).toUpperCase() + s.slice(1)
}

export function SingleLayerPage() {
  const { layerName } = useParams<{ layerName: string }>()
  const layer = capitalize(layerName ?? '') as LayerName

  if (!VALID_LAYERS.includes(layer as LayerName)) {
    return <Navigate to="/layer/domain" replace />
  }

  const { filters, selectedNodeId, setSelectedNodeId } = useGraphStore()

  const { data, isLoading, isError, refetch } = useQuery({
    queryKey: ['graph', filters.projectId, filters.layerId],
    queryFn:  () => graphApi.getGraphData(filters.projectId, filters.layerId),
  })

  const filteredData = useMemo(() => {
    if (!data) return { nodes: [], edges: [] }
    let nodes = data.nodes.filter(n => filters.elementTypes.includes(n.type))
    if (filters.searchTerm.trim()) {
      const term = filters.searchTerm.toLowerCase()
      nodes = nodes.filter(
        n => n.label.toLowerCase().includes(term) || n.namespace.toLowerCase().includes(term),
      )
    }
    const nodeIds = new Set(nodes.map(n => n.id))
    let edges = data.edges.filter(e => nodeIds.has(e.source) && nodeIds.has(e.target))
    if (filters.showOnlyDirect) edges = edges.filter(e => e.isDirect)
    return { nodes, edges }
  }, [data, filters])

  // Only this layer's nodes
  const layerNodes = useMemo(
    () => filteredData.nodes.filter(n => n.layer === layer),
    [filteredData.nodes, layer],
  )

  // Intra-layer edges (both endpoints in layer)
  const layerNodeIds = useMemo(() => new Set(layerNodes.map(n => n.id)), [layerNodes])
  const layerEdges = useMemo(
    () => filteredData.edges.filter(e => layerNodeIds.has(e.source) && layerNodeIds.has(e.target)),
    [filteredData.edges, layerNodeIds],
  )

  const selectedNode = useMemo(
    () => filteredData.nodes.find(n => n.id === selectedNodeId) as GraphNode | undefined,
    [filteredData.nodes, selectedNodeId],
  )

  const meta = LAYER_META[layer]

  // Count subdivisions
  const subCounts = useMemo(() => {
    const m = new Map<string, number>()
    for (const n of layerNodes) {
      const ns = n.namespace ?? ''
      const marker = `.${layer}.`
      const idx = ns.indexOf(marker)
      let sub = 'Other'
      if (idx !== -1) {
        const rest = ns.slice(idx + marker.length)
        const dot = rest.indexOf('.')
        sub = dot === -1 ? rest : rest.slice(0, dot)
      }
      m.set(sub, (m.get(sub) ?? 0) + 1)
    }
    return m
  }, [layerNodes, layer])

  return (
    <div style={{ display: 'flex', height: '100%', overflow: 'hidden' }}>
      {/* Sidebar */}
      <GraphFiltersPanel />

      <div style={{ flex: 1, display: 'flex', flexDirection: 'column', overflow: 'hidden' }}>

        {/* Top banner */}
        <div style={{
          background: meta.bg,
          borderBottom: `1px solid ${meta.border}`,
          flexShrink: 0,
        }}>
          {/* Title row */}
          <div style={{
            padding: '12px 20px 8px',
            display: 'flex', alignItems: 'center', gap: 12,
          }}>
            <div style={{
              width: 36, height: 36, borderRadius: 10,
              background: meta.color, display: 'flex',
              alignItems: 'center', justifyContent: 'center',
              boxShadow: `0 2px 8px ${meta.color}40`,
              flexShrink: 0,
            }}>
              <span style={{ fontSize: 17 }}>{meta.emoji}</span>
            </div>
            <div>
              <div style={{ fontWeight: 800, fontSize: 16, color: meta.color, lineHeight: 1.2 }}>
                {layer} Layer
              </div>
              <div style={{ fontSize: 11, color: '#64748b', marginTop: 1 }}>
                {meta.desc}
              </div>
            </div>

            {/* Stats pills */}
            <div style={{ marginLeft: 'auto', display: 'flex', alignItems: 'center', gap: 8 }}>
              <span style={{
                background: `${meta.color}15`, color: meta.color,
                borderRadius: 20, padding: '3px 12px', fontSize: 12, fontWeight: 600,
              }}>
                {layerNodes.length} elementos
              </span>
              <span style={{
                background: '#f1f5f9', color: '#64748b',
                borderRadius: 20, padding: '3px 12px', fontSize: 12,
              }}>
                {layerEdges.length} arestas
              </span>
              <span style={{
                background: '#f1f5f9', color: '#64748b',
                borderRadius: 20, padding: '3px 12px', fontSize: 12,
              }}>
                {subCounts.size} subdivisoes
              </span>
              <button
                onClick={() => refetch()}
                style={{
                  display: 'flex', alignItems: 'center', gap: 6,
                  background: '#fff', border: `1px solid ${meta.border}`, borderRadius: 8,
                  padding: '5px 12px', fontSize: 12, cursor: 'pointer', color: '#374151',
                }}
              >
                <RefreshCw size={13} /> Atualizar
              </button>
            </div>
          </div>

          {/* Subdivision summary chips */}
          {subCounts.size > 0 && (
            <div style={{
              padding: '0 20px 10px',
              display: 'flex', flexWrap: 'wrap', gap: 6,
            }}>
              {[...subCounts.entries()].map(([sub, cnt]) => (
                <span key={sub} style={{
                  fontSize: 11, padding: '2px 9px', borderRadius: 20,
                  background: '#fff', border: `1px solid ${meta.border}`,
                  color: '#374151', fontWeight: 500,
                }}>
                  {sub} <span style={{ color: meta.color, fontWeight: 700 }}>{cnt}</span>
                </span>
              ))}
            </div>
          )}
        </div>

        {/* Canvas area */}
        <div style={{ flex: 1, position: 'relative', overflow: 'hidden', background: '#f8fafc' }}>
          {isLoading && (
            <div style={{
              position: 'absolute', inset: 0,
              display: 'flex', alignItems: 'center', justifyContent: 'center',
              background: 'rgba(248,250,252,0.9)', zIndex: 10,
            }}>
              <div style={{ textAlign: 'center' }}>
                <div style={{ fontSize: 32, marginBottom: 8 }}>⟳</div>
                <p style={{ color: '#64748b', fontSize: 14 }}>Carregando camada {layer}…</p>
              </div>
            </div>
          )}

          {isError && (
            <div style={{
              position: 'absolute', inset: 0,
              display: 'flex', alignItems: 'center', justifyContent: 'center',
            }}>
              <div style={{
                textAlign: 'center', padding: 24,
                background: '#fff', border: '1px solid #fee2e2',
                borderRadius: 12, maxWidth: 360,
              }}>
                <AlertTriangle size={32} color="#ef4444" style={{ marginBottom: 8 }} />
                <p style={{ color: '#dc2626', fontWeight: 600 }}>Erro ao carregar</p>
                <button
                  onClick={() => refetch()}
                  style={{
                    marginTop: 12, padding: '8px 20px',
                    background: meta.color, color: '#fff',
                    border: 'none', borderRadius: 8,
                    cursor: 'pointer', fontSize: 13,
                  }}
                >
                  Tentar novamente
                </button>
              </div>
            </div>
          )}

          {data && (
            <SingleLayerCanvas
              key={layer}
              layer={layer}
              nodes={layerNodes}
              edges={layerEdges}
              selectedNodeId={selectedNodeId}
              onNodeClick={setSelectedNodeId}
            />
          )}

          {data && layerNodes.length === 0 && (
            <div style={{
              position: 'absolute', inset: 0,
              display: 'flex', alignItems: 'center', justifyContent: 'center',
            }}>
              <div style={{ textAlign: 'center', color: '#94a3b8' }}>
                <div style={{ fontSize: 40, marginBottom: 8 }}>◻</div>
                <p style={{ fontSize: 14 }}>Nenhum elemento encontrado para esta camada</p>
              </div>
            </div>
          )}
        </div>
      </div>

      {/* Detail panel */}
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
