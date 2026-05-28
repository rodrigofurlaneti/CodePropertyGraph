import { useCallback, useEffect, useMemo } from 'react'
import {
  ReactFlow,
  Controls,
  MiniMap,
  useNodesState,
  useEdgesState,
  addEdge,
  type Node,
  type Edge,
  type Connection,
  MarkerType,
  Background,
  BackgroundVariant,
} from '@xyflow/react'
import '@xyflow/react/dist/style.css'
import type { GraphData, GraphNode, GraphEdge } from '../../types'
import { CodeElementNode } from './CodeElementNode'
import { SwimlaneLane, type SwimlaneLaneData } from './SwimlaneLane'

// ─── Configuração das camadas ───────────────────────────────────────────────

const LAYER_ORDER = ['Domain', 'Application', 'Infrastructure', 'Api'] as const

const LAYER_CONFIG: Record<
  string,
  { color: string; bg: string; border: string; subtitle: string }
> = {
  Domain: {
    color: '#6d28d9',
    bg: '#faf5ff',
    border: '#ddd6fe',
    subtitle: 'Entidades & Regras',
  },
  Application: {
    color: '#1d4ed8',
    bg: '#eff6ff',
    border: '#bfdbfe',
    subtitle: 'Casos de Uso & Handlers',
  },
  Infrastructure: {
    color: '#0f766e',
    bg: '#f0fdfa',
    border: '#99f6e4',
    subtitle: 'Repositórios & EF Core',
  },
  Api: {
    color: '#c2410c',
    bg: '#fff7ed',
    border: '#fed7aa',
    subtitle: 'Controllers & Endpoints',
  },
}

// ─── Dimensões do layout ─────────────────────────────────────────────────────

const LANE_WIDTH = 310
const LANE_GAP = 20
const LANE_HEADER_H = 52
const LANE_PADDING_X = 24
const LANE_PADDING_TOP = 16
const NODE_W = 262
const NODE_H = 120
const NODE_GAP = 16
const LANE_PADDING_BOTTOM = 32

// ─── Builders ────────────────────────────────────────────────────────────────

function buildSwimlaneNodes(graphNodes: GraphNode[]): Node[] {
  const byLayer: Record<string, GraphNode[]> = {}
  for (const layer of LAYER_ORDER) byLayer[layer] = []

  for (const n of graphNodes) {
    const key = LAYER_ORDER.find((l) => l === n.layer) ?? n.layer
    if (!byLayer[key]) byLayer[key] = []
    byLayer[key].push(n)
  }

  const nodes: Node[] = []

  LAYER_ORDER.forEach((layer, laneIdx) => {
    const children = byLayer[layer] ?? []
    const laneH =
      LANE_HEADER_H +
      LANE_PADDING_TOP +
      Math.max(1, children.length) * (NODE_H + NODE_GAP) -
      NODE_GAP +
      LANE_PADDING_BOTTOM

    const cfg = LAYER_CONFIG[layer] ?? LAYER_CONFIG.Domain
    const laneId = `__lane__${layer}`

    // Background lane node
    const laneData: SwimlaneLaneData = {
      label: layer,
      subtitle: cfg.subtitle,
      color: cfg.color,
      bg: cfg.bg,
      border: cfg.border,
      count: children.length,
    }

    nodes.push({
      id: laneId,
      type: 'swimlaneLane',
      position: { x: laneIdx * (LANE_WIDTH + LANE_GAP), y: 0 },
      style: { width: LANE_WIDTH, height: laneH },
      data: laneData,
      selectable: false,
      draggable: false,
      focusable: false,
      zIndex: 0,
    })

    // Child element nodes
    children.forEach((n, i) => {
      nodes.push({
        id: n.id,
        type: 'codeElement',
        parentId: laneId,
        extent: 'parent',
        position: {
          x: LANE_PADDING_X,
          y: LANE_HEADER_H + LANE_PADDING_TOP + i * (NODE_H + NODE_GAP),
        },
        style: { width: NODE_W },
        data: { ...n },
        zIndex: 2,
      })
    })
  })

  return nodes
}

const EDGE_STYLE: Record<string, { stroke: string; dash?: string; width: number }> = {
  IMPLEMENTS:     { stroke: '#10b981', width: 2 },
  DEPENDS_ON:     { stroke: '#6366f1', dash: '5,3', width: 1.5 },
  HTTP_INPUT:     { stroke: '#f97316', dash: '4,2', width: 1.5 },
  HTTP_OUTPUT:    { stroke: '#fb923c', dash: '4,2', width: 1.5 },
  HANDLER_INPUT:  { stroke: '#8b5cf6', dash: '3,3', width: 1.5 },
  HANDLER_OUTPUT: { stroke: '#a78bfa', dash: '3,3', width: 1.5 },
}

function buildFlowEdges(graphEdges: GraphEdge[]): Edge[] {
  return graphEdges.map((e) => {
    const s = EDGE_STYLE[e.edgeType] ?? EDGE_STYLE.DEPENDS_ON
    return {
      id: e.id,
      source: e.source,
      target: e.target,
      label: e.label,
      type: 'smoothstep',
      animated: e.edgeType === 'DEPENDS_ON' && !e.isDirect,
      style: {
        stroke: s.stroke,
        strokeWidth: s.width,
        strokeDasharray: s.dash,
      },
      markerEnd: {
        type: MarkerType.ArrowClosed,
        color: s.stroke,
      },
      labelStyle: { fontSize: 10, fill: '#6b7280', fontFamily: 'Plus Jakarta Sans' },
      labelBgStyle: { fill: '#f9fafb', stroke: '#e5e7eb', strokeWidth: 1 },
      zIndex: 3,
    }
  })
}

// ─── Tipos de nó ─────────────────────────────────────────────────────────────

const nodeTypes = {
  codeElement: CodeElementNode,
  swimlaneLane: SwimlaneLane,
}

// ─── Minimap colors ───────────────────────────────────────────────────────────

const LAYER_COLORS: Record<string, string> = {
  Domain:         '#6d28d9',
  Application:    '#1d4ed8',
  Infrastructure: '#0f766e',
  Api:            '#c2410c',
}

// ─── Componente principal ─────────────────────────────────────────────────────

interface SwimlaneCanvasProps {
  data: GraphData
  onNodeClick?: (nodeId: string) => void
}

export function SwimlaneCanvas({ data, onNodeClick }: SwimlaneCanvasProps) {
  const initialNodes = useMemo(() => buildSwimlaneNodes(data.nodes), [data.nodes])
  const initialEdges = useMemo(() => buildFlowEdges(data.edges), [data.edges])

  const [nodes, setNodes, onNodesChange] = useNodesState(initialNodes)
  const [edges, setEdges, onEdgesChange] = useEdgesState(initialEdges)

  useEffect(() => { setNodes(initialNodes) }, [initialNodes, setNodes])
  useEffect(() => { setEdges(initialEdges) }, [initialEdges, setEdges])

  const onConnect = useCallback(
    (connection: Connection) => setEdges((eds) => addEdge(connection, eds)),
    [setEdges],
  )

  const handleNodeClick = useCallback(
    (_: React.MouseEvent, node: Node) => {
      // Ignora clique nos nodes de fundo (raias)
      if (node.id.startsWith('__lane__')) return
      onNodeClick?.(node.id)
    },
    [onNodeClick],
  )

  return (
    <div style={{ width: '100%', height: '100%', background: '#f1f5f9' }}>
      <ReactFlow
        nodes={nodes}
        edges={edges}
        onNodesChange={onNodesChange}
        onEdgesChange={onEdgesChange}
        onConnect={onConnect}
        onNodeClick={handleNodeClick}
        nodeTypes={nodeTypes}
        fitView
        fitViewOptions={{ padding: 0.08 }}
        attributionPosition="bottom-right"
        minZoom={0.05}
        maxZoom={2}
        nodesDraggable={false}
        nodesConnectable={false}
        elementsSelectable
      >
        <Background
          variant={BackgroundVariant.Lines}
          gap={32}
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
            if (node.id.startsWith('__lane__')) {
              const layer = node.id.replace('__lane__', '')
              return LAYER_COLORS[layer] ?? '#cbd5e1'
            }
            const layer = (node.data as GraphNode).layer
            return LAYER_COLORS[layer] ?? '#6b7280'
          }}
          style={{
            background: '#fff',
            border: '1px solid #e2e8f0',
            borderRadius: 8,
          }}
          maskColor="rgba(241,245,249,0.8)"
        />
      </ReactFlow>
    </div>
  )
}
