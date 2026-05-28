import { useState, useRef, useEffect, useMemo, useCallback } from 'react'
import type { GraphNode, GraphEdge } from '../../types'

// ═══════════════════════════════════════════════════════════════════════════
// Layout constants
// ═══════════════════════════════════════════════════════════════════════════
const COL_W        = 210   // total column width
const COL_H_PAD    = 10    // horizontal padding inside column
const CARD_W       = COL_W - COL_H_PAD * 2   // = 190
const CARD_H       = 36
const CARD_GAP     = 5
const HEADER_H     = 46
const COL_TOP_PAD  = 8
const COL_GAP      = 22
const WRAP_PAD     = 28

// ═══════════════════════════════════════════════════════════════════════════
// Color themes
// ═══════════════════════════════════════════════════════════════════════════
const LAYER_BG: Record<string, string> = {
  Domain:         '#faf5ff',
  Application:    '#eff6ff',
  Infrastructure: '#f0fdfa',
  Api:            '#fff7ed',
}

const COL_THEME: Record<string, Record<string, { bg: string; border: string; header: string; headerText: string }>> = {
  Domain: {
    Entities:   { bg: '#f5f3ff', border: '#8b5cf6', header: '#6d28d9', headerText: '#fff' },
    Common:     { bg: '#faf5ff', border: '#a78bfa', header: '#8b5cf6', headerText: '#fff' },
    Interfaces: { bg: '#ede9fe', border: '#7c3aed', header: '#7c3aed', headerText: '#fff' },
    Enums:      { bg: '#f8f5ff', border: '#c4b5fd', header: '#a78bfa', headerText: '#fff' },
    Core:       { bg: '#f3f0ff', border: '#9b87f5', header: '#6d28d9', headerText: '#fff' },
  },
  Application: {
    Features:   { bg: '#eff6ff', border: '#3b82f6', header: '#1d4ed8', headerText: '#fff' },
    Common:     { bg: '#f0f9ff', border: '#60a5fa', header: '#3b82f6', headerText: '#fff' },
    Mappings:   { bg: '#e0f2fe', border: '#38bdf8', header: '#0284c7', headerText: '#fff' },
    Behaviors:  { bg: '#f0f9ff', border: '#93c5fd', header: '#2563eb', headerText: '#fff' },
  },
  Infrastructure: {
    Persistence:  { bg: '#f0fdfa', border: '#14b8a6', header: '#0f766e', headerText: '#fff' },
    Repositories: { bg: '#ecfdf5', border: '#34d399', header: '#059669', headerText: '#fff' },
    Migrations:   { bg: '#f0fdfa', border: '#2dd4bf', header: '#0d9488', headerText: '#fff' },
  },
  Api: {
    Controllers:  { bg: '#fff7ed', border: '#f97316', header: '#c2410c', headerText: '#fff' },
    Middlewares:  { bg: '#fff7ed', border: '#fb923c', header: '#ea580c', headerText: '#fff' },
    Filters:      { bg: '#fff7ed', border: '#fdba74', header: '#f97316', headerText: '#fff' },
  },
}

const FALLBACK_COLS = [
  { bg: '#f8fafc', border: '#94a3b8', header: '#475569', headerText: '#fff' },
  { bg: '#f1f5f9', border: '#64748b', header: '#334155', headerText: '#fff' },
  { bg: '#f8fafc', border: '#cbd5e1', header: '#64748b', headerText: '#fff' },
]

const ELEMENT_COLOR: Record<string, string> = {
  Class:     '#6366f1',
  Interface: '#10b981',
  Record:    '#f59e0b',
  Enum:      '#ef4444',
}

const EDGE_COLOR: Record<string, string> = {
  IMPLEMENTS:     '#10b981',
  DEPENDS_ON:     '#94a3b8',
  HTTP_INPUT:     '#f97316',
  HTTP_OUTPUT:    '#f97316',
  HANDLER_INPUT:  '#8b5cf6',
  HANDLER_OUTPUT: '#8b5cf6',
}

// ═══════════════════════════════════════════════════════════════════════════
// Helpers
// ═══════════════════════════════════════════════════════════════════════════
function getSubdivision(node: GraphNode): string {
  const ns    = node.namespace ?? ''
  const layer = node.layer ?? ''
  if (!ns || !layer) return 'General'
  const marker = `.${layer}.`
  const idx    = ns.indexOf(marker)
  if (idx !== -1) {
    const seg = ns.slice(idx + marker.length).split('.')[0]
    if (seg) return seg
  }
  if (ns.endsWith(`.${layer}`)) return 'Core'
  const parts = ns.split('.')
  return parts[parts.length - 1] || 'General'
}

interface Column {
  name:      string
  nodes:     GraphNode[]
  colIdx:    number
  theme:     { bg: string; border: string; header: string; headerText: string }
}

interface NodeIndex { colIdx: number; rowIdx: number }

function buildLayout(nodes: GraphNode[], layer: string): {
  columns:   Column[]
  nodeIndex: Map<string, NodeIndex>
} {
  const grouped: Record<string, GraphNode[]> = {}
  for (const n of nodes) {
    const sub = getSubdivision(n)
    ;(grouped[sub] ??= []).push(n)
  }

  const layerThemes = COL_THEME[layer] ?? {}
  let fallbackIdx   = 0
  const columns: Column[] = []
  const nodeIndex   = new Map<string, NodeIndex>()

  Object.entries(grouped).forEach(([name, colNodes], colIdx) => {
    const theme = layerThemes[name] ?? FALLBACK_COLS[fallbackIdx++ % FALLBACK_COLS.length]
    columns.push({ name, nodes: colNodes, colIdx, theme })
    colNodes.forEach((n, rowIdx) => nodeIndex.set(n.id, { colIdx, rowIdx }))
  })

  return { columns, nodeIndex }
}

// Pixel helpers
const colLeft   = (ci: number) => WRAP_PAD + ci * (COL_W + COL_GAP)
const cardTop   = (ri: number) => HEADER_H + COL_TOP_PAD + ri * (CARD_H + CARD_GAP)
const cardCx    = (ci: number) => colLeft(ci) + COL_H_PAD + CARD_W / 2
const cardCy    = (ri: number) => cardTop(ri) + CARD_H / 2
const cardRight = (ci: number) => colLeft(ci) + COL_W - COL_H_PAD / 2
const cardLeftX = (ci: number) => colLeft(ci) + COL_H_PAD / 2

function buildEdgePath(
  src: NodeIndex, tgt: NodeIndex,
): string {
  const sx = cardCx(src.colIdx)
  const sy = cardCy(src.rowIdx)
  const tx = cardCx(tgt.colIdx)
  const ty = cardCy(tgt.rowIdx)

  if (src.colIdx === tgt.colIdx) {
    // Same column — detour to the right
    const ex   = cardRight(src.colIdx) + 18
    const ey1  = sy + (sy < ty ? 14 : -14)
    const ey2  = ty + (sy < ty ? -14 : 14)
    return `M ${sx + CARD_W / 2},${sy} C ${ex},${ey1} ${ex},${ey2} ${tx + CARD_W / 2},${ty}`
  }

  const goRight = tgt.colIdx > src.colIdx
  const srcX = goRight ? cardRight(src.colIdx) : cardLeftX(src.colIdx)
  const tgtX = goRight ? cardLeftX(tgt.colIdx) : cardRight(tgt.colIdx)
  const mid  = (srcX + tgtX) / 2

  return `M ${srcX},${sy} C ${mid},${sy} ${mid},${ty} ${tgtX},${ty}`
}

// ═══════════════════════════════════════════════════════════════════════════
// Sub-components
// ═══════════════════════════════════════════════════════════════════════════

function NodeCard({
  node, isSelected, isHighlighted, isDimmed, onClick, onEnter, onLeave,
}: {
  node:          GraphNode
  isSelected:    boolean
  isHighlighted: boolean
  isDimmed:      boolean
  onClick:       () => void
  onEnter:       (e: React.MouseEvent) => void
  onLeave:       () => void
}) {
  const elColor = ELEMENT_COLOR[node.type] ?? '#6366f1'
  const bg = isSelected ? '#dbeafe' : isHighlighted ? '#f0fdf4' : 'white'
  const border = isSelected
    ? '2px solid #3b82f6'
    : isHighlighted
    ? '1.5px solid #10b981'
    : '1px solid #e2e8f0'

  return (
    <div
      onClick={onClick}
      onMouseEnter={onEnter}
      onMouseLeave={onLeave}
      title={node.label + '\n' + node.namespace}
      style={{
        height: CARD_H, width: CARD_W,
        marginBottom: CARD_GAP,
        background: bg,
        border,
        borderRadius: 6,
        padding: '0 10px 0 8px',
        display: 'flex', alignItems: 'center', gap: 7,
        cursor: 'pointer',
        boxShadow: isSelected
          ? '0 0 0 3px rgba(59,130,246,0.25), 0 1px 4px rgba(0,0,0,0.08)'
          : '0 1px 3px rgba(0,0,0,0.06)',
        opacity: isDimmed ? 0.3 : 1,
        transition: 'opacity 0.15s, box-shadow 0.15s',
        flexShrink: 0,
        userSelect: 'none',
      }}
    >
      {/* Element type badge */}
      <span style={{
        width: 20, height: 20, borderRadius: 3,
        background: elColor, color: 'white', flexShrink: 0,
        display: 'flex', alignItems: 'center', justifyContent: 'center',
        fontSize: 10, fontWeight: 700,
      }}>
        {node.type[0]}
      </span>
      {/* Name */}
      <span style={{
        fontSize: 11,
        fontFamily: 'JetBrains Mono, monospace',
        color: isSelected ? '#1e40af' : '#1e293b',
        fontWeight: isSelected ? 700 : 500,
        overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap',
        flex: 1,
      }}>
        {node.label}
      </span>
      {/* Abstract / Sealed indicator */}
      {node.isAbstract && (
        <span style={{ fontSize: 9, color: '#9ca3af', fontStyle: 'italic', flexShrink: 0 }}>abs</span>
      )}
    </div>
  )
}

function SubdivisionColumn({ col, selectedId, highlightedIds, onNodeClick, onNodeEnter, onNodeLeave }: {
  col:             Column
  selectedId:      string | null
  highlightedIds:  Set<string>
  onNodeClick:     (id: string) => void
  onNodeEnter:     (id: string, e: React.MouseEvent) => void
  onNodeLeave:     () => void
}) {
  const { theme, name, nodes } = col
  const hasSel = selectedId !== null || highlightedIds.size > 0

  return (
    <div style={{
      width: COL_W, flexShrink: 0,
      background: theme.bg,
      border: `1.5px solid ${theme.border}`,
      borderRadius: 10,
      overflow: 'visible',
    }}>
      {/* Header */}
      <div style={{
        height: HEADER_H,
        background: theme.header,
        borderRadius: '8px 8px 0 0',
        display: 'flex', alignItems: 'center', justifyContent: 'space-between',
        padding: '0 12px',
      }}>
        <span style={{ color: theme.headerText, fontWeight: 700, fontSize: 13 }}>
          {name}
        </span>
        <span style={{
          background: 'rgba(255,255,255,0.25)', color: theme.headerText,
          borderRadius: 20, padding: '1px 8px', fontSize: 11, fontWeight: 700,
        }}>
          {nodes.length}
        </span>
      </div>

      {/* Cards */}
      <div style={{ padding: `${COL_TOP_PAD}px ${COL_H_PAD}px 12px` }}>
        {nodes.map((node) => {
          const isSel  = selectedId === node.id
          const isHigh = highlightedIds.has(node.id)
          const isDim  = hasSel && !isSel && !isHigh
          return (
            <NodeCard
              key={node.id}
              node={node}
              isSelected={isSel}
              isHighlighted={isHigh}
              isDimmed={isDim}
              onClick={() => onNodeClick(node.id)}
              onEnter={(e) => onNodeEnter(node.id, e)}
              onLeave={onNodeLeave}
            />
          )
        })}
      </div>
    </div>
  )
}

function ArrowsOverlay({
  edges, nodeIndex, selectedId, totalWidth, totalHeight,
}: {
  edges:       GraphEdge[]
  nodeIndex:   Map<string, NodeIndex>
  selectedId:  string | null
  totalWidth:  number
  totalHeight: number
}) {
  const usedTypes = useMemo(
    () => [...new Set(edges.map(e => e.edgeType))],
    [edges],
  )

  return (
    <svg
      width={totalWidth} height={totalHeight}
      style={{ position: 'absolute', top: 0, left: 0, pointerEvents: 'none', overflow: 'visible' }}
    >
      <defs>
        {usedTypes.map(t => {
          const color = EDGE_COLOR[t] ?? '#94a3b8'
          return (
            <marker key={t}
              id={`arr-${t}`}
              markerWidth={7} markerHeight={7}
              refX={6} refY={3} orient="auto"
            >
              <path d="M0,0 L0,6 L7,3 z" fill={color} />
            </marker>
          )
        })}
      </defs>

      {edges.map(edge => {
        const src = nodeIndex.get(edge.source)
        const tgt = nodeIndex.get(edge.target)
        if (!src || !tgt) return null

        const isHL = selectedId === edge.source || selectedId === edge.target
        const opacity = selectedId === null ? 0.2 : isHL ? 0.9 : 0.05
        const color = EDGE_COLOR[edge.edgeType] ?? '#94a3b8'
        const path  = buildEdgePath(src, tgt)

        return (
          <path
            key={edge.id}
            d={path}
            fill="none"
            stroke={color}
            strokeWidth={isHL ? 2 : 1}
            opacity={opacity}
            markerEnd={isHL ? `url(#arr-${edge.edgeType})` : undefined}
            style={{ transition: 'opacity 0.15s' }}
          />
        )
      })}
    </svg>
  )
}


function Tooltip({ nodeId, pos, nodes }: {
  nodeId: string
  pos:    { x: number; y: number }
  nodes:  GraphNode[]
}) {
  const node = nodes.find(n => n.id === nodeId)
  if (!node) return null
  return (
    <div style={{
      position: 'fixed', left: pos.x + 14, top: pos.y - 40,
      background: '#0f172a', border: '1px solid #1e293b',
      borderRadius: 8, padding: '8px 12px',
      pointerEvents: 'none', zIndex: 100,
      boxShadow: '0 8px 24px rgba(0,0,0,0.4)', maxWidth: 280,
    }}>
      <div style={{
        color: '#f8fafc', fontWeight: 700, fontSize: 12,
        fontFamily: 'JetBrains Mono, monospace', marginBottom: 4,
        wordBreak: 'break-all',
      }}>
        {node.label}
      </div>
      {[
        ['Tipo',      node.type],
        ['Layer',     node.layer],
        ['Subdivisão', getSubdivision(node)],
        ['Namespace', node.namespace],
      ].map(([l, v]) => (
        <div key={l} style={{ display: 'flex', gap: 6, fontSize: 10, lineHeight: '16px' }}>
          <span style={{ color: '#475569', minWidth: 65 }}>{l}:</span>
          <span style={{
            color: '#94a3b8', fontFamily: 'JetBrains Mono',
            wordBreak: 'break-all',
          }}>{v}</span>
        </div>
      ))}
    </div>
  )
}

// ═══════════════════════════════════════════════════════════════════════════
// Main component
// ═══════════════════════════════════════════════════════════════════════════
export interface LayerDetailCanvasProps {
  layer:          string
  nodes:          GraphNode[]   // already filtered to this layer
  edges:          GraphEdge[]   // edges involving this layer's nodes
  selectedNodeId: string | null
  onNodeClick:    (id: string) => void
}

export function LayerDetailCanvas({
  layer, nodes, edges, selectedNodeId, onNodeClick,
}: LayerDetailCanvasProps) {
  const scrollRef = useRef<HTMLDivElement>(null)
  const [tooltip, setTooltip] = useState<{ nodeId: string; x: number; y: number } | null>(null)

  const { columns, nodeIndex } = useMemo(
    () => buildLayout(nodes, layer),
    [nodes, layer],
  )

  // IDs connected to the selected node (for highlighting)
  const highlightedIds = useMemo(() => {
    if (!selectedNodeId) return new Set<string>()
    const ids = new Set<string>()
    edges.forEach(e => {
      if (e.source === selectedNodeId) ids.add(e.target)
      if (e.target === selectedNodeId) ids.add(e.source)
    })
    return ids
  }, [selectedNodeId, edges])

  // Only intra-layer edges for the arrow overlay
  const intraEdges = useMemo(() => {
    const ids = new Set(nodes.map(n => n.id))
    return edges.filter(e => ids.has(e.source) && ids.has(e.target))
  }, [nodes, edges])

  const maxRows    = Math.max(1, ...columns.map(c => c.nodes.length))
  const totalH     = HEADER_H + COL_TOP_PAD + maxRows * (CARD_H + CARD_GAP) + WRAP_PAD + 16
  const totalW     = WRAP_PAD * 2 + columns.length * COL_W + Math.max(0, columns.length - 1) * COL_GAP

  const handleNodeEnter = useCallback((nodeId: string, e: React.MouseEvent) => {
    setTooltip({ nodeId, x: e.clientX, y: e.clientY })
  }, [])

  const handleNodeLeave = useCallback(() => setTooltip(null), [])

  useEffect(() => {
    // Scroll to selected node
    if (!selectedNodeId || !scrollRef.current) return
    const idx = nodeIndex.get(selectedNodeId)
    if (!idx) return
    const scrollLeft = colLeft(idx.colIdx) - 40
    scrollRef.current.scrollTo({ left: scrollLeft, behavior: 'smooth' })
  }, [selectedNodeId, nodeIndex])

  if (columns.length === 0) {
    return (
      <div style={{
        display: 'flex', alignItems: 'center', justifyContent: 'center',
        height: '100%', color: '#94a3b8', fontSize: 14,
      }}>
        Nenhum elemento encontrado para esta camada com os filtros atuais.
      </div>
    )
  }

  return (
    <div
      ref={scrollRef}
      style={{
        position: 'relative', width: '100%', height: '100%',
        overflowX: 'auto', overflowY: 'auto',
        background: LAYER_BG[layer] ?? '#f8fafc',
      }}
    >
      {/* Relative container for columns + SVG overlay */}
      <div style={{ position: 'relative', width: totalW, minHeight: totalH }}>

        {/* SVG arrows (behind columns? no — use pointer-events none so cards stay clickable) */}
        <ArrowsOverlay
          edges={intraEdges}
          nodeIndex={nodeIndex}
          selectedId={selectedNodeId}
          totalWidth={totalW}
          totalHeight={totalH}
        />

        {/* Columns */}
        <div style={{
          position: 'relative', zIndex: 1,
          display: 'flex', gap: COL_GAP,
          padding: `${WRAP_PAD}px`,
          alignItems: 'flex-start',
        }}>
          {columns.map(col => (
            <SubdivisionColumn
              key={col.name}
              col={col}
              selectedId={selectedNodeId}
              highlightedIds={highlightedIds}
              onNodeClick={onNodeClick}
              onNodeEnter={handleNodeEnter}
              onNodeLeave={handleNodeLeave}
            />
          ))}
        </div>
      </div>

      {/* Tooltip */}
      {tooltip && (
        <Tooltip nodeId={tooltip.nodeId} pos={tooltip} nodes={nodes} />
      )}

      {/* Cross-layer connections legend (bottom-right) */}
      <div style={{
        position: 'sticky', bottom: 12, left: '100%',
        width: 'fit-content', marginLeft: 'auto',
        background: 'rgba(15,23,42,0.82)', border: '1px solid #1e293b',
        borderRadius: 8, padding: '6px 12px', marginRight: 12,
        pointerEvents: 'none',
      }}>
        <div style={{ fontSize: 10, color: '#475569', fontWeight: 700, textTransform: 'uppercase', marginBottom: 3 }}>
          Relacionamentos
        </div>
        {[...new Set(intraEdges.map(e => e.edgeType))].map(t => (
          <div key={t} style={{ display: 'flex', alignItems: 'center', gap: 6, marginBottom: 2 }}>
            <svg width={24} height={8}>
              <line x1={0} y1={4} x2={24} y2={4}
                stroke={EDGE_COLOR[t] ?? '#94a3b8'} strokeWidth={2} />
            </svg>
            <span style={{ color: '#94a3b8', fontSize: 10, fontFamily: 'JetBrains Mono' }}>{t}</span>
          </div>
        ))}
        <div style={{ color: '#64748b', fontSize: 10, marginTop: 4 }}>
          ↗ = ligações externas
        </div>
      </div>
    </div>
  )
}
