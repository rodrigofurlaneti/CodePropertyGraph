import { useMemo, useState } from 'react'
import { useQuery } from '@tanstack/react-query'
import { AlertTriangle, RefreshCw, Layers } from 'lucide-react'
import { graphApi } from '../api/graph'
import { useGraphStore } from '../store/graphStore'
import { GraphFiltersPanel } from '../components/graph/GraphFiltersPanel'
import { NodeDetailPanel } from '../components/graph/NodeDetailPanel'
import { LayerDetailCanvas } from '../components/graph/LayerDetailCanvas'
import type { GraphNode } from '../types'

const LAYERS = ['Domain', 'Application', 'Infrastructure', 'Api'] as const
type LayerName = typeof LAYERS[number]

const LAYER_COLOR: Record<LayerName, string> = {
  Domain:         '#8b5cf6',
  Application:    '#3b82f6',
  Infrastructure: '#14b8a6',
  Api:            '#f97316',
}

const LAYER_DESC: Record<LayerName, string> = {
  Domain:         'Entidades, Interfaces, Common — núcleo do negócio',
  Application:    'Features, Handlers, Mappings, Common — orquestração',
  Infrastructure: 'Persistence, Repositories — acesso a dados',
  Api:            'Controllers — entrada HTTP',
}

export function LayerDetailPage() {
  const { filters, selectedNodeId, setSelectedNodeId } = useGraphStore()
  const [activeLayer, setActiveLayer] = useState<LayerName>('Domain')

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
        n =>
          n.label.toLowerCase().includes(term) ||
          n.namespace.toLowerCase().includes(term),
      )
    }
    const nodeIds = new Set(nodes.map(n => n.id))
    let edges = data.edges.filter(e => nodeIds.has(e.source) && nodeIds.has(e.target))
    if (filters.showOnlyDirect) edges = edges.filter(e => e.isDirect)
    return { nodes, edges }
  }, [data, filters])

  // Nodes for the active layer only
  const layerNodes = useMemo(
    () => filteredData.nodes.filter(n => n.layer === activeLayer),
    [filteredData.nodes, activeLayer],
  )

  // Edges involving the active layer (at least one endpoint in this layer)
  const layerEdges = useMemo(() => {
    const layerIds = new Set(layerNodes.map(n => n.id))
    return filteredData.edges.filter(
      e => layerIds.has(e.source) || layerIds.has(e.target),
    )
  }, [layerNodes, filteredData.edges])

  const selectedNode = useMemo(
    () => filteredData.nodes.find(n => n.id === selectedNodeId) as GraphNode | undefined,
    [filteredData.nodes, selectedNodeId],
  )

  // When switching layers, deselect if selected node is not in new layer
  const handleLayerSwitch = (layer: LayerName) => {
    setActiveLayer(layer)
    if (selectedNode && selectedNode.layer !== layer) {
      setSelectedNodeId(null)
    }
  }

  const activeColor = LAYER_COLOR[activeLayer]

  return (
    <div style={{ display: 'flex', height: '100%', overflow: 'hidden' }}>
      {/* Sidebar */}
      <GraphFiltersPanel />

      <div style={{ flex: 1, display: 'flex', flexDirection: 'column', overflow: 'hidden' }}>

        {/* Toolbar */}
        <div style={{
          borderBottom: '1px solid #e2e8f0', background: '#fff', flexShrink: 0,
        }}>
          {/* Top row */}
          <div style={{
            padding: '10px 16px',
            display: 'flex', alignItems: 'center', gap: 12,
          }}>
            <Layers size={18} color={activeColor} />
            <span style={{ fontWeight: 700, color: '#1e293b', fontSize: 15 }}>
              Layer Focus
            </span>
            <span style={{
              background: '#f1f5f9', borderRadius: 20, padding: '2px 10px',
              fontSize: 12, color: '#64748b',
            }}>
              {layerNodes.length} elementos
            </span>
            <span style={{
              fontSize: 11, color: '#64748b',
              background: '#f8fafc', border: '1px solid #e2e8f0',
              borderRadius: 20, padding: '2px 10px',
            }}>
              {LAYER_DESC[activeLayer]}
            </span>
            <button
              onClick={() => refetch()}
              style={{
                marginLeft: 'auto', display: 'flex', alignItems: 'center', gap: 6,
                background: '#f8fafc', border: '1px solid #e2e8f0', borderRadius: 8,
                padding: '5px 12px', fontSize: 12, cursor: 'pointer', color: '#374151',
              }}
            >
              <RefreshCw size={13} /> Atualizar
            </button>
          </div>

          {/* Layer tabs */}
          <div style={{
            display: 'flex', gap: 0,
            borderTop: '1px solid #f1f5f9',
          }}>
            {LAYERS.map(layer => {
              const isActive = layer === activeLayer
              const color    = LAYER_COLOR[layer]
              const count    = filteredData.nodes.filter(n => n.layer === layer).length
              return (
                <button
                  key={layer}
                  onClick={() => handleLayerSwitch(layer)}
                  style={{
                    flex: 1, padding: '10px 12px',
                    background: isActive ? '#fff' : '#f8fafc',
                    border: 'none',
                    borderBottom: isActive ? `3px solid ${color}` : '3px solid transparent',
                    cursor: 'pointer',
                    display: 'flex', flexDirection: 'column',
                    alignItems: 'center', gap: 2,
                    transition: 'background 0.15s',
                  }}
                >
                  <span style={{
                    fontSize: 13, fontWeight: isActive ? 700 : 500,
                    color: isActive ? color : '#64748b',
                  }}>
                    {layer}
                  </span>
                  <span style={{
                    fontSize: 10,
                    color: isActive ? color : '#94a3b8',
                    background: isActive ? `${color}18` : '#f1f5f9',
                    borderRadius: 10, padding: '1px 7px', fontWeight: 600,
                  }}>
                    {count}
                  </span>
                </button>
              )
            })}
          </div>
        </div>

        {/* Canvas area */}
        <div style={{ flex: 1, position: 'relative', overflow: 'hidden' }}>
          {isLoading && (
            <div style={{
              position: 'absolute', inset: 0,
              display: 'flex', alignItems: 'center', justifyContent: 'center',
              background: 'rgba(248,250,252,0.85)', zIndex: 10,
            }}>
              <div style={{ textAlign: 'center' }}>
                <div style={{ fontSize: 32, marginBottom: 8 }}>⟳</div>
                <p style={{ color: '#64748b', fontSize: 14 }}>Carregando camada…</p>
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
                    background: activeColor, color: '#fff',
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
            <LayerDetailCanvas
              key={activeLayer}
              layer={activeLayer}
              nodes={layerNodes}
              edges={layerEdges}
              selectedNodeId={selectedNodeId}
              onNodeClick={setSelectedNodeId}
            />
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
