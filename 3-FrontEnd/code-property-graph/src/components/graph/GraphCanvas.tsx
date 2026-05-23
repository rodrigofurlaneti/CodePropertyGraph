import { useCallback, useMemo } from 'react'
import {
  ReactFlow, Background, Controls, MiniMap,
  useNodesState, useEdgesState, addEdge,
  type Node, type Edge, type Connection,
  BackgroundVariant, MarkerType,
} from '@xyflow/react'
import '@xyflow/react/dist/style.css'
import type { GraphData, GraphNode, GraphEdge } from '../../types'
import { CodeElementNode } from './CodeElementNode'

const nodeTypes = { codeElement: CodeElementNode }

const LAYER_COLORS: Record<string, string> = {
  Domain:         '#8b5cf6',
  Application:    '#3b82f6',
  Infrastructure: '#14b8a6',
  Api:            '#f97316',
}

function buildFlowNodes(graphNodes: GraphNode[]): Node[] {
  // Auto-layout: group by layer in columns
  const byLayer = graphNodes.reduce<Record<string, GraphNode[]>>((acc, n) => {
    ;(acc[n.layer] ??= []).push(n)
    return acc
  }, {})

  const layers = Object.keys(byLayer)
  const colWidth = 280
  const rowHeight = 150

  return graphNodes.map((n) => {
    const layerIdx = layers.indexOf(n.layer)
    const nodeIdx = byLayer[n.layer].indexOf(n)
    return {
      id: n.id,
      type: 'codeElement',
      position: {
        x: layerIdx * colWidth + (nodeIdx % 2) * 20,
        y: Math.floor(nodeIdx / 1) * rowHeight + 40,
      },
      data: { ...n },
    }
  })
}

function buildFlowEdges(graphEdges: GraphEdge[]): Edge[] {
  return graphEdges.map((e) => ({
    id: e.id,
    source: e.source,
    target: e.target,
    label: e.label,
    type: 'smoothstep',
    animated: e.edgeType === 'DEPENDS_ON' && !e.isDirect,
    style: {
      stroke: e.edgeType === 'IMPLEMENTS' ? '#10b981' : '#6366f1',
      strokeWidth: e.edgeType === 'IMPLEMENTS' ? 2 : 1.5,
      strokeDasharray: e.edgeType === 'IMPLEMENTS' ? undefined : '5,3',
    },
    markerEnd: {
      type: MarkerType.ArrowClosed,
      color: e.edgeType === 'IMPLEMENTS' ? '#10b981' : '#6366f1',
    },
    labelStyle: { fontSize: 10, fill: '#6b7280', fontFamily: 'Plus Jakarta Sans' },
    labelBgStyle: { fill: '#f9fafb', stroke: '#e5e7eb', strokeWidth: 1 },
  }))
}

interface GraphCanvasProps {
  data: GraphData
  onNodeClick?: (nodeId: string) => void
}

export function GraphCanvas({ data, onNodeClick }: GraphCanvasProps) {
  const initialNodes = useMemo(() => buildFlowNodes(data.nodes), [data.nodes])
  const initialEdges = useMemo(() => buildFlowEdges(data.edges), [data.edges])

  const [nodes, , onNodesChange] = useNodesState(initialNodes)
  const [edges, setEdges, onEdgesChange] = useEdgesState(initialEdges)

  const onConnect = useCallback(
    (connection: Connection) => setEdges((eds) => addEdge(connection, eds)),
    [setEdges]
  )

  const handleNodeClick = useCallback(
    (_: React.MouseEvent, node: Node) => onNodeClick?.(node.id),
    [onNodeClick]
  )

  return (
    <div style={{ width: '100%', height: '100%', background: '#f8fafc' }}>
      <ReactFlow
        nodes={nodes}
        edges={edges}
        onNodesChange={onNodesChange}
        onEdgesChange={onEdgesChange}
        onConnect={onConnect}
        onNodeClick={handleNodeClick}
        nodeTypes={nodeTypes}
        fitView
        fitViewOptions={{ padding: 0.2 }}
        attributionPosition="bottom-right"
        minZoom={0.1}
        maxZoom={2}
      >
        <Background
          variant={BackgroundVariant.Dots}
          gap={20}
          size={1}
          color="#e2e8f0"
        />
        <Controls
          style={{
            background: '#fff',
            border: '1px solid #e2e8f0',
            borderRadius: 8,
            boxShadow: '0 2px 8px rgba(0,0,0,0.08)',
          }}
        />
        <MiniMap
          nodeColor={(node) => {
            const layer = (node.data as GraphNode).layer
            return LAYER_COLORS[layer] ?? '#6b7280'
          }}
          style={{
            background: '#fff',
            border: '1px solid #e2e8f0',
            borderRadius: 8,
          }}
          maskColor="rgba(248,250,252,0.8)"
        />
      </ReactFlow>
    </div>
  )
}
