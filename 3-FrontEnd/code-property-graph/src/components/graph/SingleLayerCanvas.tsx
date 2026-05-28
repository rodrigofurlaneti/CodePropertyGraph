import { useMemo, useRef, useState, useEffect, useCallback } from 'react'
import type { GraphNode, GraphEdge } from '../../types'

// ─── Layout constants ──────────────────────────────────────────────────────────
const COL_W      = 236
const CARD_H     = 46
const CARD_W     = 216
const CARD_GAP   = 6
const HEADER_H   = 82
const COL_GAP    = 32
const WRAP_PAD   = 28
const CANVAS_PAD = 32

// ─── Layer colour palettes ─────────────────────────────────────────────────────
const LAYER_PALETTE: Record<string, { primary: string; light: string; bg: string; border: string }> = {
  Domain:         { primary: '#7c3aed', light: '#a78bfa', bg: '#faf5ff', border: '#e9d5ff' },
  Application:    { primary: '#1d4ed8', light: '#60a5fa', bg: '#eff6ff', border: '#bfdbfe' },
  Infrastructure: { primary: '#0f766e', light: '#2dd4bf', bg: '#f0fdfa', border: '#99f6e4' },
  Api:            { primary: '#c2410c', light: '#fb923c', bg: '#fff7ed', border: '#fed7aa' },
}

// ─── Element-type colours ──────────────────────────────────────────────────────
const TYPE_COLOR: Record<string, string> = {
  class:     '#6366f1',
  interface: '#0ea5e9',
  enum:      '#f59e0b',
  record:    '#10b981',
  struct:    '#8b5cf6',
  delegate:  '#ec4899',
  abstract:  '#64748b',
}

function typeColor(t: string) { return TYPE_COLOR[t] ?? '#94a3b8' }

// ─── Subdivision extraction ────────────────────────────────────────────────────
function getSub(node: GraphNode): string {
  const ns = node.namespace ?? ''
  const layer = node.layer ?? ''
  const marker = `.${layer}.`
  const idx = ns.indexOf(marker)
  if (idx === -1) return 'Other'
  const rest = ns.slice(idx + marker.length)
  const dot = rest.indexOf('.')
  return dot === -1 ? rest : rest.slice(0, dot)
}

// ─── Subdivision colour map (stable via layer palette) ─────────────────────────
const SUB_ACCENTS = [
  '#7c3aed','#1d4ed8','#0f766e','#c2410c',
  '#0369a1','#b45309','#15803d','#9333ea',
  '#475569','#be123c',
]

function subAccent(sub: string, index: number): string {
  const presets: Record<string, string> = {
    Entities:       '#7c3aed',
    Interfaces:     '#0369a1',
    Common:         '#475569',
    Features:       '#1d4ed8',
    Handlers:       '#0f766e',
    Mappings:       '#b45309',
    Persistence:    '#0f766e',
    Repositories:   '#15803d',
    Controllers:    '#c2410c',
    Extensions:     '#9333ea',
    Configurations: '#475569',
    Events:         '#be123c',
    ValueObjects:   '#9333ea',
    Services:       '#0369a1',
  }
  return presets[sub] ?? SUB_ACCENTS[index % SUB_ACCENTS.length]
}

// ─── Types ─────────────────────────────────────────────────────────────────────
interface Column {
  sub:    string
  accent: string
  nodes:  GraphNode[]
  x:      number
}

interface Layout {
  columns:   Column[]
  nodeIndex: Map<string, { col: Column; row: number }>
  totalW:    number
  totalH:    number
}

// ─── Layout builder ────────────────────────────────────────────────────────────
function buildLayout(nodes: GraphNode[]): Layout {
  // group by subdivision preserving insertion order
  const colMap = new Map<string, GraphNode[]>()
  for (const n of nodes) {
    const sub = getSub(n)
    if (!colMap.has(sub)) colMap.set(sub, [])
    colMap.get(sub)!.push(n)
  }

  const columns: Column[] = []
  let x = CANVAS_PAD
  let idx = 0
  for (const [sub, colNodes] of colMap) {
    columns.push({ sub, accent: subAccent(sub, idx++), nodes: colNodes, x })
    x += COL_W + COL_GAP
  }

  const nodeIndex = new Map<string, { col: Column; row: number }>()
  for (const col of columns) {
    col.nodes.forEach((n, row) => nodeIndex.set(n.id, { col, row }))
  }

  const maxRows = Math.max(0, ...columns.map(c => c.nodes.length))
  const totalW  = x - COL_GAP + CANVAS_PAD
  const totalH  = CANVAS_PAD + HEADER_H + maxRows * (CARD_H + CARD_GAP) + CARD_GAP + CANVAS_PAD

  return { columns, nodeIndex, totalW, totalH }
}

// ─── Pixel helpers ─────────────────────────────────────────────────────────────
function cardTop(row: number) {
  return CANVAS_PAD + HEADER_H + row * (CARD_H + CARD_GAP)
}
function cardCy(row: number) { return cardTop(row) + CARD_H / 2 }
function cardLeft(col: Column) { return col.x + WRAP_PAD }
function cardRight(col: Column) { return col.x + WRAP_PAD + CARD_W }

// ─── Edge path builder ─────────────────────────────────────────────────────────
function edgePath(
  src: { col: Column; row: number },
  tgt: { col: Column; row: number },
): string {
  const sx = cardRight(src.col)
  const sy = cardCy(src.row)
  const tx = cardLeft(tgt.col)
  const ty = cardCy(tgt.row)

  if (src.col === tgt.col) {
    // same column — detour to the right
    const rx = cardRight(src.col) + 18
    return `M${sx},${sy} C${rx},${sy} ${rx},${ty} ${tx},${ty}`
  }
  // different columns — horizontal bezier
  const mx = (sx + tx) / 2
  return `M${sx},${sy} C${mx},${sy} ${mx},${ty} ${tx},${ty}`
}

// ─── Tooltip ──────────────────────────────────────────────────────────────────
interface TooltipData { x: number; y: number; node: GraphNode }

// ─── Main component ────────────────────────────────────────────────────────────
interface Props {
  layer:          string
  nodes:          GraphNode[]
  edges:          GraphEdge[]
  selectedNodeId: string | null
  onNodeClick:    (id: string | null) => void
}

export function SingleLayerCanvas({ layer, nodes, edges, selectedNodeId, onNodeClick }: Props) {
  const palette   = LAYER_PALETTE[layer] ?? LAYER_PALETTE['Domain']
  const layout    = useMemo(() => buildLayout(nodes), [nodes])

  // pan / zoom
  const [tx, setTx]     = useState(0)
  const [ty, setTy]     = useState(0)
  const [scale, setScale] = useState(1)
  const dragRef           = useRef<{ sx: number; sy: number; tx: number; ty: number } | null>(null)
  const containerRef      = useRef<HTMLDivElement>(null)

  const handleWheel = useCallback((e: WheelEvent) => {
    e.preventDefault()
    setScale(s => Math.min(2, Math.max(0.3, s - e.deltaY * 0.001)))
  }, [])

  useEffect(() => {
    const el = containerRef.current
    if (!el) return
    el.addEventListener('wheel', handleWheel, { passive: false })
    return () => el.removeEventListener('wheel', handleWheel)
  }, [handleWheel])

  const onMouseDown = (e: React.MouseEvent) => {
    if ((e.target as HTMLElement).closest('[data-card]')) return
    dragRef.current = { sx: e.clientX, sy: e.clientY, tx, ty }
  }
  const onMouseMove = (e: React.MouseEvent) => {
    if (!dragRef.current) return
    setTx(dragRef.current.tx + e.clientX - dragRef.current.sx)
    setTy(dragRef.current.ty + e.clientY - dragRef.current.sy)
  }
  const onMouseUp = () => { dragRef.current = null }

  // highlight logic
  const connectedIds = useMemo(() => {
    if (!selectedNodeId) return new Set<string>()
    const s = new Set<string>()
    for (const e of edges) {
      if (e.source === selectedNodeId) s.add(e.target)
      if (e.target === selectedNodeId) s.add(e.source)
    }
    return s
  }, [selectedNodeId, edges])

  const highlightedEdgeIds = useMemo(() => {
    if (!selectedNodeId) return new Set<number>()
    const s = new Set<number>()
    edges.forEach((e, i) => {
      if (e.source === selectedNodeId || e.target === selectedNodeId) s.add(i)
    })
    return s
  }, [selectedNodeId, edges])

  // intra-layer edges
  const nodeIds = useMemo(() => new Set(nodes.map(n => n.id)), [nodes])
  const intraEdges = useMemo(
    () => edges.filter(e => nodeIds.has(e.source) && nodeIds.has(e.target)),
    [edges, nodeIds],
  )

  // tooltip
  const [tooltip, setTooltip] = useState<TooltipData | null>(null)

  return (
    <div
      ref={containerRef}
      style={{ position: 'relative', width: '100%', height: '100%', overflow: 'hidden', cursor: 'grab', userSelect: 'none' }}
      onMouseDown={onMouseDown}
      onMouseMove={onMouseMove}
      onMouseUp={onMouseUp}
      onMouseLeave={onMouseUp}
      onClick={() => { if (!dragRef.current) onNodeClick(null) }}
    >
      {/* Transformed canvas */}
      <div style={{
        position: 'absolute', top: 0, left: 0,
        transform: `translate(${tx}px,${ty}px) scale(${scale})`,
        transformOrigin: '0 0',
        width: layout.totalW, height: layout.totalH,
      }}>

        {/* SVG edges layer */}
        <svg
          style={{ position: 'absolute', inset: 0, width: layout.totalW, height: layout.totalH, pointerEvents: 'none' }}
          xmlns="http://www.w3.org/2000/svg"
        >
          <defs>
            <marker id={`arrow-${layer}`} markerWidth="8" markerHeight="8" refX="6" refY="3" orient="auto">
              <path d="M0,0 L0,6 L8,3 z" fill={palette.primary} opacity="0.7" />
            </marker>
            <marker id={`arrow-dim-${layer}`} markerWidth="8" markerHeight="8" refX="6" refY="3" orient="auto">
              <path d="M0,0 L0,6 L8,3 z" fill="#cbd5e1" opacity="0.5" />
            </marker>
          </defs>

          {intraEdges.map((e, i) => {
            const s = layout.nodeIndex.get(e.source)
            const t = layout.nodeIndex.get(e.target)
            if (!s || !t) return null
            const isHighlighted = highlightedEdgeIds.has(i)
            const isDimmed      = selectedNodeId !== null && !isHighlighted
            return (
              <path
                key={i}
                d={edgePath(s, t)}
                fill="none"
                stroke={isDimmed ? '#e2e8f0' : palette.light}
                strokeWidth={isHighlighted ? 2 : 1}
                strokeOpacity={isDimmed ? 0.3 : isHighlighted ? 1 : 0.55}
                markerEnd={`url(#${isDimmed ? `arrow-dim-${layer}` : `arrow-${layer}`})`}
              />
            )
          })}
        </svg>

        {/* Columns */}
        {layout.columns.map(col => {
          // type breakdown for header
          const typeCount: Record<string, number> = {}
          for (const n of col.nodes) typeCount[n.type] = (typeCount[n.type] ?? 0) + 1

          return (
            <div key={col.sub} style={{ position: 'absolute', left: col.x, top: CANVAS_PAD }}>
              {/* Column background */}
              <div style={{
                width: COL_W, borderRadius: 12,
                border: `1.5px solid ${col.accent}28`,
                background: `${col.accent}07`,
                minHeight: HEADER_H + col.nodes.length * (CARD_H + CARD_GAP) + CARD_GAP,
              }}>
                {/* Header */}
                <div style={{
                  height: HEADER_H, borderRadius: '10px 10px 0 0',
                  background: `${col.accent}18`,
                  borderBottom: `1.5px solid ${col.accent}28`,
                  padding: '10px 14px 8px',
                  display: 'flex', flexDirection: 'column', gap: 4,
                }}>
                  <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
                    <div style={{
                      width: 10, height: 10, borderRadius: 3,
                      background: col.accent, flexShrink: 0,
                    }} />
                    <span style={{ fontWeight: 700, fontSize: 13, color: col.accent, letterSpacing: '-0.01em' }}>
                      {col.sub}
                    </span>
                    <span style={{
                      marginLeft: 'auto', fontSize: 11, fontWeight: 600,
                      background: `${col.accent}20`, color: col.accent,
                      borderRadius: 10, padding: '1px 7px',
                    }}>
                      {col.nodes.length}
                    </span>
                  </div>
                  {/* Type breakdown */}
                  <div style={{ display: 'flex', flexWrap: 'wrap', gap: 3 }}>
                    {Object.entries(typeCount).map(([type, cnt]) => (
                      <span key={type} style={{
                        fontSize: 10, padding: '1px 5px', borderRadius: 4,
                        background: `${typeColor(type)}18`, color: typeColor(type),
                        fontWeight: 600,
                      }}>
                        {type} {cnt}
                      </span>
                    ))}
                  </div>
                </div>

                {/* Node cards */}
                <div style={{ padding: '6px 12px 10px' }}>
                  {col.nodes.map((node) => {
                    const isSelected    = node.id === selectedNodeId
                    const isConnected   = connectedIds.has(node.id)
                    const isDimmed      = selectedNodeId !== null && !isSelected && !isConnected
                    const isHighlighted = isConnected && !isSelected

                    return (
                      <div
                        key={node.id}
                        data-card="1"
                        onClick={e => { e.stopPropagation(); onNodeClick(isSelected ? null : node.id) }}
                        onMouseEnter={e => {
                          const rect = (e.currentTarget as HTMLElement).getBoundingClientRect()
                          setTooltip({ x: rect.right + 8, y: rect.top, node })
                        }}
                        onMouseLeave={() => setTooltip(null)}
                        style={{
                          width: CARD_W, height: CARD_H,
                          marginBottom: CARD_GAP,
                          borderRadius: 8, cursor: 'pointer',
                          display: 'flex', alignItems: 'center', gap: 8,
                          padding: '0 10px',
                          background: isSelected
                            ? `${col.accent}22`
                            : isHighlighted
                              ? `${col.accent}12`
                              : '#fff',
                          border: `1.5px solid ${
                            isSelected ? col.accent
                            : isHighlighted ? `${col.accent}66`
                            : '#e8edf5'
                          }`,
                          boxShadow: isSelected
                            ? `0 0 0 2px ${col.accent}33`
                            : '0 1px 3px rgba(0,0,0,0.05)',
                          opacity: isDimmed ? 0.3 : 1,
                          transition: 'all 0.12s',
                        }}
                      >
                        {/* Type badge */}
                        <div style={{
                          width: 22, height: 22, borderRadius: 5, flexShrink: 0,
                          background: typeColor(node.type),
                          display: 'flex', alignItems: 'center', justifyContent: 'center',
                        }}>
                          <span style={{ fontSize: 9, color: '#fff', fontWeight: 700, fontFamily: 'JetBrains Mono, monospace' }}>
                            {node.type.slice(0, 2).toUpperCase()}
                          </span>
                        </div>

                        {/* Name */}
                        <span style={{
                          fontSize: 12, fontWeight: isSelected ? 700 : 500,
                          color: isSelected ? col.accent : '#1e293b',
                          fontFamily: 'JetBrains Mono, monospace',
                          whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis',
                          flex: 1,
                        }}>
                          {node.label}
                        </span>

                        {isSelected && (
                          <div style={{
                            width: 6, height: 6, borderRadius: 3,
                            background: col.accent, flexShrink: 0,
                          }} />
                        )}
                      </div>
                    )
                  })}
                </div>
              </div>
            </div>
          )
        })}
      </div>

      {/* Tooltip — outside transform, uses fixed coordinates */}
      {tooltip && (
        <div style={{
          position: 'fixed', zIndex: 1000,
          left: tooltip.x, top: tooltip.y,
          background: '#1e293b', color: '#f8fafc',
          borderRadius: 8, padding: '8px 12px',
          fontSize: 12, lineHeight: 1.5,
          pointerEvents: 'none',
          boxShadow: '0 4px 16px rgba(0,0,0,0.25)',
          maxWidth: 300,
        }}>
          <div style={{ fontWeight: 700, fontFamily: 'JetBrains Mono, monospace', marginBottom: 2 }}>
            {tooltip.node.label}
          </div>
          <div style={{ color: '#94a3b8', fontSize: 11 }}>{tooltip.node.namespace}</div>
          <div style={{ marginTop: 4, display: 'flex', gap: 6 }}>
            <span style={{
              fontSize: 10, padding: '1px 6px', borderRadius: 4,
              background: `${typeColor(tooltip.node.type)}30`,
              color: typeColor(tooltip.node.type), fontWeight: 600,
            }}>
              {tooltip.node.type}
            </span>
          </div>
        </div>
      )}

      {/* Zoom controls */}
      <div style={{
        position: 'absolute', bottom: 16, right: 16,
        display: 'flex', flexDirection: 'column', gap: 4,
        zIndex: 10,
      }}>
        {['+', '−', '⟲'].map((label, i) => (
          <button
            key={label}
            onClick={() => {
              if (i === 0) setScale(s => Math.min(2, s + 0.15))
              else if (i === 1) setScale(s => Math.max(0.3, s - 0.15))
              else { setScale(1); setTx(0); setTy(0) }
            }}
            style={{
              width: 32, height: 32, borderRadius: 8,
              border: '1px solid #e2e8f0', background: '#fff',
              cursor: 'pointer', fontSize: 16, fontWeight: 600,
              color: '#374151', boxShadow: '0 1px 4px rgba(0,0,0,0.08)',
              display: 'flex', alignItems: 'center', justifyContent: 'center',
            }}
          >
            {label}
          </button>
        ))}
      </div>

      {/* Scale indicator */}
      <div style={{
        position: 'absolute', bottom: 16, left: 16,
        background: 'rgba(255,255,255,0.9)', borderRadius: 8,
        padding: '4px 10px', fontSize: 11, color: '#64748b',
        border: '1px solid #e2e8f0',
        zIndex: 10,
      }}>
        {Math.round(scale * 100)}%
      </div>
    </div>
  )
}
