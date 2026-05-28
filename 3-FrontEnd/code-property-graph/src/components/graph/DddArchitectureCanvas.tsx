import { useState, useRef, useCallback, useMemo } from 'react'
import type { GraphNode, GraphEdge } from '../../types'

// ─── Configuração das camadas ───────────────────────────────────────────────
const LAYER_ORDER = ['Domain', 'Application', 'Infrastructure', 'Api']

/** Raio onde os nós ficam posicionados em cada anel */
const NODE_RING_RADIUS: Record<string, number> = {
  Domain:         190,
  Application:    370,
  Infrastructure: 555,
  Api:            740,
}

/** Limite externo de cada anel (para o fundo colorido) */
const RING_OUTER: Record<string, number> = {
  Domain:         280,
  Application:    462,
  Infrastructure: 648,
  Api:            840,
}

const LAYER_THEME: Record<string, {
  fill: string; stroke: string; label: string; labelColor: string
}> = {
  Domain:         { fill: 'rgba(139,92,246,0.13)',  stroke: '#8b5cf6', label: 'Domain',         labelColor: '#7c3aed' },
  Application:    { fill: 'rgba(59,130,246,0.10)',  stroke: '#3b82f6', label: 'Application',     labelColor: '#1d4ed8' },
  Infrastructure: { fill: 'rgba(20,184,166,0.10)',  stroke: '#14b8a6', label: 'Infrastructure',  labelColor: '#0f766e' },
  Api:            { fill: 'rgba(249,115,22,0.10)',  stroke: '#f97316', label: 'API',             labelColor: '#c2410c' },
}

const ELEMENT_COLOR: Record<string, string> = {
  Class:     '#6366f1',
  Interface: '#10b981',
  Record:    '#f59e0b',
  Enum:      '#ef4444',
}

const EDGE_STROKE: Record<string, { color: string; dash?: string }> = {
  IMPLEMENTS:     { color: '#10b981' },
  DEPENDS_ON:     { color: '#94a3b8' },
  HTTP_INPUT:     { color: '#f97316', dash: '6 3' },
  HTTP_OUTPUT:    { color: '#f97316', dash: '2 3' },
  HANDLER_INPUT:  { color: '#8b5cf6', dash: '6 3' },
  HANDLER_OUTPUT: { color: '#8b5cf6', dash: '2 3' },
}

// ─── Tipos internos ──────────────────────────────────────────────────────────
interface NodePos { node: GraphNode; x: number; y: number }

interface Transform { scale: number; tx: number; ty: number }

interface TooltipState {
  nodeId: string
  screenX: number
  screenY: number
}

// ─── Helpers ─────────────────────────────────────────────────────────────────
function trunc(s: string, max = 16): string {
  return s.length > max ? s.slice(0, max - 1) + '…' : s
}

function computeLayout(nodes: GraphNode[]): Map<string, NodePos> {
  const byLayer: Record<string, GraphNode[]> = {}
  for (const n of nodes) {
    const l = LAYER_ORDER.includes(n.layer) ? n.layer : 'Domain'
    ;(byLayer[l] ??= []).push(n)
  }

  const posMap = new Map<string, NodePos>()

  for (const layer of LAYER_ORDER) {
    const layerNodes = byLayer[layer] ?? []
    const r = NODE_RING_RADIUS[layer]
    layerNodes.forEach((node, i) => {
      const angle = layerNodes.length === 1
        ? -Math.PI / 2
        : (2 * Math.PI * i) / layerNodes.length - Math.PI / 2
      posMap.set(node.id, {
        node,
        x: Math.round(r * Math.cos(angle)),
        y: Math.round(r * Math.sin(angle)),
      })
    })
  }

  return posMap
}

// ─── Sub-components SVG ───────────────────────────────────────────────────────
function RingBackground() {
  // Desenha de fora para dentro para criar bandas coloridas
  const layers = [...LAYER_ORDER].reverse()
  return (
    <g>
      {layers.map((layer) => {
        const theme = LAYER_THEME[layer]
        const outerR = RING_OUTER[layer]
        return (
          <circle key={layer} cx={0} cy={0} r={outerR}
            fill={theme.fill} stroke={theme.stroke}
            strokeWidth={1.5} strokeDasharray="8 4" opacity={0.9}
          />
        )
      })}
      {/* Centro pulsante para Domain */}
      <circle cx={0} cy={0} r={8} fill="#8b5cf6" opacity={0.6} />
      <circle cx={0} cy={0} r={4} fill="#8b5cf6" />
    </g>
  )
}

function RingLabels() {
  return (
    <g>
      {LAYER_ORDER.map((layer) => {
        const theme = LAYER_THEME[layer]
        const r = RING_OUTER[layer] - 14
        return (
          <text key={layer}
            x={0} y={-r}
            textAnchor="middle" dominantBaseline="auto"
            fill={theme.labelColor} fontSize={13} fontWeight={700}
            fontFamily="Plus Jakarta Sans, system-ui"
            opacity={0.85}
          >
            {theme.label}
          </text>
        )
      })}
    </g>
  )
}

function EdgeLayer({
  edges, posMap, selectedNodeId,
}: {
  edges: GraphEdge[]
  posMap: Map<string, NodePos>
  selectedNodeId: string | null
}) {
  return (
    <g>
      {edges.map((edge) => {
        const src = posMap.get(edge.source)
        const tgt = posMap.get(edge.target)
        if (!src || !tgt) return null

        const isHighlighted =
          selectedNodeId === edge.source || selectedNodeId === edge.target
        const stroke = EDGE_STROKE[edge.edgeType] ?? { color: '#94a3b8' }

        // Bezier curvo passando levemente pelo centro
        const cx1 = src.x * 0.35
        const cy1 = src.y * 0.35
        const cx2 = tgt.x * 0.35
        const cy2 = tgt.y * 0.35
        const d = `M${src.x},${src.y} C${cx1},${cy1} ${cx2},${cy2} ${tgt.x},${tgt.y}`

        return (
          <path key={edge.id}
            d={d}
            fill="none"
            stroke={stroke.color}
            strokeWidth={isHighlighted ? 2 : 1}
            strokeDasharray={stroke.dash}
            opacity={isHighlighted ? 0.85 : selectedNodeId ? 0.08 : 0.22}
            style={{ transition: 'opacity 0.2s, stroke-width 0.2s' }}
          />
        )
      })}
    </g>
  )
}

function NodeCard({
  pos, isSelected, isHovered,
  onClick, onMouseEnter, onMouseLeave,
}: {
  pos: NodePos
  isSelected: boolean
  isHovered: boolean
  onClick: () => void
  onMouseEnter: (e: React.MouseEvent) => void
  onMouseLeave: () => void
}) {
  const { node, x, y } = pos
  const layerTheme = LAYER_THEME[node.layer] ?? LAYER_THEME.Domain
  const elemColor = ELEMENT_COLOR[node.type] ?? '#6366f1'
  const typeChar = node.type[0]

  const W = 138, H = 28
  const active = isSelected || isHovered

  return (
    <g
      transform={`translate(${x},${y})`}
      style={{ cursor: 'pointer' }}
      onClick={onClick}
      onMouseEnter={onMouseEnter}
      onMouseLeave={onMouseLeave}
    >
      {/* Shadow */}
      {active && (
        <rect
          x={-W / 2 - 3} y={-H / 2 - 3}
          width={W + 6} height={H + 6}
          rx={9}
          fill={isSelected ? layerTheme.stroke : '#000'}
          opacity={isSelected ? 0.35 : 0.12}
        />
      )}
      {/* Card background */}
      <rect
        x={-W / 2} y={-H / 2}
        width={W} height={H}
        rx={6}
        fill="white"
        stroke={active ? layerTheme.stroke : '#e2e8f0'}
        strokeWidth={isSelected ? 2.5 : isHovered ? 1.8 : 1}
      />
      {/* Type badge (left strip) */}
      <rect
        x={-W / 2} y={-H / 2}
        width={24} height={H}
        rx={6}
        fill={elemColor}
      />
      {/* Square the right side of the badge */}
      <rect
        x={-W / 2 + 18} y={-H / 2}
        width={6} height={H}
        fill={elemColor}
      />
      {/* Type letter */}
      <text
        x={-W / 2 + 12} y={0}
        textAnchor="middle" dominantBaseline="central"
        fill="white" fontSize={10} fontWeight={700}
        fontFamily="Plus Jakarta Sans, system-ui"
      >
        {typeChar}
      </text>
      {/* Name */}
      <text
        x={-W / 2 + 32} y={0}
        dominantBaseline="central"
        fill={isSelected ? layerTheme.labelColor : '#1e293b'}
        fontSize={10} fontWeight={isSelected ? 700 : 500}
        fontFamily="JetBrains Mono, monospace"
      >
        {trunc(node.label, 15)}
      </text>
      {/* Abstract/Sealed markers */}
      {(node.isAbstract || node.isSealed) && (
        <text
          x={W / 2 - 4} y={-H / 2 + 7}
          textAnchor="end"
          fill="#9ca3af" fontSize={8} fontStyle="italic"
        >
          {node.isAbstract ? 'abs' : 'sealed'}
        </text>
      )}
    </g>
  )
}

function Tooltip({ tip, posMap }: {
  tip: TooltipState
  posMap: Map<string, NodePos>
}) {
  const pos = posMap.get(tip.nodeId)
  if (!pos) return null
  const { node } = pos

  const lines = [
    { label: 'Tipo',       value: node.type },
    { label: 'Layer',      value: node.layer },
    { label: 'Projeto',    value: node.project },
    { label: 'Namespace',  value: node.namespace },
  ]
  const W = 230
  const H = 14 + lines.length * 18 + 10

  // Posição do tooltip (screenX/Y são relativas ao container SVG)
  const sx = tip.screenX
  const sy = tip.screenY

  return (
    <div style={{
      position: 'absolute',
      left: sx + 16,
      top: sy - H / 2,
      width: W,
      background: '#0f172a',
      border: '1px solid #334155',
      borderRadius: 8,
      padding: '8px 12px',
      pointerEvents: 'none',
      zIndex: 50,
      boxShadow: '0 8px 24px rgba(0,0,0,0.35)',
    }}>
      <div style={{
        color: '#f8fafc', fontWeight: 700, fontSize: 12,
        fontFamily: 'JetBrains Mono, monospace',
        marginBottom: 6, borderBottom: '1px solid #334155', paddingBottom: 4,
        wordBreak: 'break-all',
      }}>
        {node.label}
      </div>
      {lines.map(({ label, value }) => (
        <div key={label} style={{
          display: 'flex', gap: 6, fontSize: 11,
          color: '#94a3b8', lineHeight: '18px',
        }}>
          <span style={{ color: '#64748b', minWidth: 70 }}>{label}:</span>
          <span style={{
            color: '#cbd5e1', fontFamily: 'JetBrains Mono, monospace',
            wordBreak: 'break-all',
          }}>{value}</span>
        </div>
      ))}
    </div>
  )
}

function Legend({ edges }: { edges: GraphEdge[] }) {
  const usedTypes = [...new Set(edges.map(e => e.edgeType))]
  return (
    <div style={{
      position: 'absolute', bottom: 16, left: 16,
      background: 'rgba(15,23,42,0.88)', border: '1px solid #1e293b',
      borderRadius: 10, padding: '10px 14px',
      display: 'flex', flexDirection: 'column', gap: 6, pointerEvents: 'none',
    }}>
      <div style={{ color: '#64748b', fontSize: 10, fontWeight: 700, letterSpacing: '0.06em', textTransform: 'uppercase', marginBottom: 2 }}>
        Legenda — Arestas
      </div>
      {usedTypes.map(t => {
        const s = EDGE_STROKE[t] ?? { color: '#94a3b8' }
        return (
          <div key={t} style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
            <svg width={32} height={10}>
              <line x1={0} y1={5} x2={32} y2={5}
                stroke={s.color} strokeWidth={2}
                strokeDasharray={s.dash}
              />
            </svg>
            <span style={{ color: '#94a3b8', fontSize: 10, fontFamily: 'JetBrains Mono' }}>{t}</span>
          </div>
        )
      })}
      {/* Tipos de elemento */}
      <div style={{ color: '#64748b', fontSize: 10, fontWeight: 700, letterSpacing: '0.06em', textTransform: 'uppercase', marginTop: 6, marginBottom: 2 }}>
        Elementos
      </div>
      {Object.entries(ELEMENT_COLOR).map(([type, color]) => (
        <div key={type} style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
          <div style={{ width: 14, height: 14, borderRadius: 3, background: color, flexShrink: 0 }} />
          <span style={{ color: '#94a3b8', fontSize: 10 }}>{type}</span>
        </div>
      ))}
    </div>
  )
}

function LayerStats({ nodes }: { nodes: GraphNode[] }) {
  const stats = LAYER_ORDER.map(layer => ({
    layer,
    count: nodes.filter(n => n.layer === layer).length,
    theme: LAYER_THEME[layer],
  }))
  return (
    <div style={{
      position: 'absolute', bottom: 16, right: 16,
      background: 'rgba(15,23,42,0.88)', border: '1px solid #1e293b',
      borderRadius: 10, padding: '10px 14px',
      display: 'flex', flexDirection: 'column', gap: 4, pointerEvents: 'none',
    }}>
      <div style={{ color: '#64748b', fontSize: 10, fontWeight: 700, letterSpacing: '0.06em', textTransform: 'uppercase', marginBottom: 2 }}>
        Camadas
      </div>
      {stats.map(({ layer, count, theme }) => (
        <div key={layer} style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
          <div style={{ width: 10, height: 10, borderRadius: '50%', background: theme.stroke, flexShrink: 0 }} />
          <span style={{ color: '#94a3b8', fontSize: 10, minWidth: 80 }}>{theme.label}</span>
          <span style={{ color: theme.labelColor, fontSize: 10, fontWeight: 700, fontFamily: 'JetBrains Mono' }}>{count}</span>
        </div>
      ))}
    </div>
  )
}

// ─── Componente principal ─────────────────────────────────────────────────────
interface DddArchitectureCanvasProps {
  nodes: GraphNode[]
  edges: GraphEdge[]
  selectedNodeId: string | null
  onNodeClick: (id: string) => void
}

export function DddArchitectureCanvas({
  nodes, edges, selectedNodeId, onNodeClick,
}: DddArchitectureCanvasProps) {
  const containerRef = useRef<HTMLDivElement>(null)
  const [transform, setTransform] = useState<Transform>({ scale: 0.55, tx: 0, ty: 0 })
  const [tooltip, setTooltip] = useState<TooltipState | null>(null)
  const [hoveredId, setHoveredId] = useState<string | null>(null)
  const dragRef = useRef<{ startX: number; startY: number; startTx: number; startTy: number } | null>(null)

  // Layout computation
  const posMap = useMemo(() => computeLayout(nodes), [nodes])

  // ─── Zoom / Pan ────────────────────────────────────────────────────────────
  const handleWheel = useCallback((e: React.WheelEvent) => {
    e.preventDefault()
    setTransform(prev => {
      const delta = -e.deltaY * 0.001
      const newScale = Math.max(0.2, Math.min(3, prev.scale + delta * prev.scale))
      return { ...prev, scale: newScale }
    })
  }, [])

  const handleMouseDown = useCallback((e: React.MouseEvent) => {
    if (e.button !== 0) return
    dragRef.current = {
      startX: e.clientX,
      startY: e.clientY,
      startTx: transform.tx,
      startTy: transform.ty,
    }
  }, [transform.tx, transform.ty])

  const handleMouseMove = useCallback((e: React.MouseEvent) => {
    if (!dragRef.current) return
    const dx = e.clientX - dragRef.current.startX
    const dy = e.clientY - dragRef.current.startY
    setTransform(prev => ({
      ...prev,
      tx: dragRef.current!.startTx + dx,
      ty: dragRef.current!.startTy + dy,
    }))
  }, [])

  const handleMouseUp = useCallback(() => {
    dragRef.current = null
  }, [])

  const handleFitView = useCallback(() => {
    setTransform({ scale: 0.55, tx: 0, ty: 0 })
  }, [])

  // ─── Tooltip ───────────────────────────────────────────────────────────────
  const handleNodeEnter = useCallback((nodeId: string, e: React.MouseEvent) => {
    const rect = containerRef.current?.getBoundingClientRect()
    if (!rect) return
    setHoveredId(nodeId)
    setTooltip({
      nodeId,
      screenX: e.clientX - rect.left,
      screenY: e.clientY - rect.top,
    })
  }, [])

  const handleNodeLeave = useCallback(() => {
    setHoveredId(null)
    setTooltip(null)
  }, [])

  // ─── SVG size ─────────────────────────────────────────────────────────────
  const VB = 900  // metade do viewBox; total = 1800x1800
  const svgViewBox = `-${VB} -${VB} ${VB * 2} ${VB * 2}`

  const svgTransform =
    `translate(${transform.tx}px, ${transform.ty}px) scale(${transform.scale})`

  return (
    <div
      ref={containerRef}
      style={{ position: 'relative', width: '100%', height: '100%', overflow: 'hidden', background: '#f8fafc' }}
      onWheel={handleWheel}
      onMouseDown={handleMouseDown}
      onMouseMove={handleMouseMove}
      onMouseUp={handleMouseUp}
      onMouseLeave={handleMouseUp}
    >
      {/* Hint */}
      <div style={{
        position: 'absolute', top: 12, left: '50%', transform: 'translateX(-50%)',
        background: 'rgba(15,23,42,0.7)', color: '#94a3b8',
        borderRadius: 20, padding: '4px 14px', fontSize: 11,
        pointerEvents: 'none', zIndex: 10,
      }}>
        Scroll para zoom · Arraste para mover · Clique no nó para detalhes
      </div>

      {/* Fit button */}
      <button
        onClick={handleFitView}
        style={{
          position: 'absolute', top: 12, right: 12, zIndex: 20,
          background: '#1e293b', color: '#f8fafc', border: 'none',
          borderRadius: 8, padding: '6px 14px', fontSize: 12,
          cursor: 'pointer', display: 'flex', alignItems: 'center', gap: 6,
        }}
      >
        ⊡ Centralizar
      </button>

      {/* SVG */}
      <svg
        width="100%" height="100%"
        viewBox={svgViewBox}
        style={{
          transform: svgTransform,
          transformOrigin: 'center center',
          cursor: dragRef.current ? 'grabbing' : 'grab',
          display: 'block',
        }}
      >
        <defs>
          <filter id="nodeShadow" x="-20%" y="-20%" width="140%" height="140%">
            <feDropShadow dx={0} dy={2} stdDeviation={3} floodOpacity={0.12} />
          </filter>
          {/* Marcadores de seta para arestas */}
          {Object.entries(EDGE_STROKE).map(([type, s]) => (
            <marker key={type}
              id={`arrow-${type}`}
              markerWidth={8} markerHeight={8}
              refX={7} refY={3}
              orient="auto"
            >
              <path d="M0,0 L0,6 L8,3 z" fill={s.color} />
            </marker>
          ))}
        </defs>

        {/* 1. Fundo com anéis */}
        <RingBackground />

        {/* 2. Labels das camadas */}
        <RingLabels />

        {/* 3. Arestas (abaixo dos nós) */}
        <EdgeLayer edges={edges} posMap={posMap} selectedNodeId={selectedNodeId} />

        {/* 4. Nós */}
        {[...posMap.values()].map(pos => (
          <NodeCard
            key={pos.node.id}
            pos={pos}
            isSelected={selectedNodeId === pos.node.id}
            isHovered={hoveredId === pos.node.id}
            onClick={() => onNodeClick(pos.node.id)}
            onMouseEnter={(e) => handleNodeEnter(pos.node.id, e)}
            onMouseLeave={handleNodeLeave}
          />
        ))}
      </svg>

      {/* Tooltip */}
      {tooltip && <Tooltip tip={tooltip} posMap={posMap} />}

      {/* Legenda */}
      <Legend edges={edges} />

      {/* Stats por camada */}
      <LayerStats nodes={nodes} />
    </div>
  )
}
