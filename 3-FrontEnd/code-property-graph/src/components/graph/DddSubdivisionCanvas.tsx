import { useState, useRef, useCallback, useMemo } from 'react'
import type { GraphNode, GraphEdge } from '../../types'

// ═══════════════════════════════════════════════════════════════════════════
// Configuração das camadas e subdivisões
// ═══════════════════════════════════════════════════════════════════════════

const LAYER_ORDER = ['Domain', 'Application', 'Infrastructure', 'Api']

/** Raio interno de cada anel (Domain começa em 0 = setor de pizza) */
const RING_INNER: Record<string, number> = {
  Domain:         0,
  Application:    288,
  Infrastructure: 474,
  Api:            660,
}

/** Raio externo de cada anel */
const RING_OUTER: Record<string, number> = {
  Domain:         280,
  Application:    466,
  Infrastructure: 652,
  Api:            840,
}

/** Raio onde os nós ficam (centro do anel) */
const NODE_RING_RADIUS: Record<string, number> = {
  Domain:         180,
  Application:    377,
  Infrastructure: 563,
  Api:            750,
}

const LAYER_BASE: Record<string, { color: string; label: string }> = {
  Domain:         { color: '#8b5cf6', label: 'Domain' },
  Application:    { color: '#3b82f6', label: 'Application' },
  Infrastructure: { color: '#14b8a6', label: 'Infrastructure' },
  Api:            { color: '#f97316', label: 'API' },
}

/** Cores predefinidas para subdivisões conhecidas */
const SUB_CONFIG: Record<string, Record<string, { fill: string; stroke: string }>> = {
  Domain: {
    Entities:   { fill: 'rgba(109,40,217,0.22)',  stroke: '#6d28d9' },
    Common:     { fill: 'rgba(139,92,246,0.16)',   stroke: '#8b5cf6' },
    Interfaces: { fill: 'rgba(167,139,250,0.20)',  stroke: '#a78bfa' },
    Enums:      { fill: 'rgba(196,181,253,0.18)',  stroke: '#c4b5fd' },
    Core:       { fill: 'rgba(124,58,237,0.16)',   stroke: '#7c3aed' },
  },
  Application: {
    Features:   { fill: 'rgba(30,64,175,0.22)',    stroke: '#1e40af' },
    Common:     { fill: 'rgba(59,130,246,0.16)',    stroke: '#3b82f6' },
    Mappings:   { fill: 'rgba(96,165,250,0.20)',    stroke: '#60a5fa' },
    Behaviors:  { fill: 'rgba(147,197,253,0.18)',   stroke: '#93c5fd' },
  },
  Infrastructure: {
    Persistence:  { fill: 'rgba(15,118,110,0.22)',  stroke: '#0f766e' },
    Repositories: { fill: 'rgba(20,184,166,0.17)',  stroke: '#14b8a6' },
    Migrations:   { fill: 'rgba(45,212,191,0.18)',  stroke: '#2dd4bf' },
  },
  Api: {
    Controllers:  { fill: 'rgba(194,65,12,0.22)',   stroke: '#c2410c' },
    Middlewares:  { fill: 'rgba(249,115,22,0.17)',   stroke: '#f97316' },
    Filters:      { fill: 'rgba(251,146,60,0.18)',   stroke: '#fb923c' },
  },
}

/** Fallback para subdivisões desconhecidas */
const FALLBACK_COLORS = [
  { fill: 'rgba(100,116,139,0.18)', stroke: '#64748b' },
  { fill: 'rgba(71,85,105,0.16)',   stroke: '#475569' },
  { fill: 'rgba(148,163,184,0.18)', stroke: '#94a3b8' },
  { fill: 'rgba(203,213,225,0.16)', stroke: '#cbd5e1' },
]

const EDGE_STROKE: Record<string, { color: string; dash?: string }> = {
  IMPLEMENTS:     { color: '#10b981' },
  DEPENDS_ON:     { color: '#94a3b8' },
  HTTP_INPUT:     { color: '#f97316', dash: '6 3' },
  HTTP_OUTPUT:    { color: '#f97316', dash: '2 3' },
  HANDLER_INPUT:  { color: '#8b5cf6', dash: '6 3' },
  HANDLER_OUTPUT: { color: '#8b5cf6', dash: '2 3' },
}

const ELEMENT_COLOR: Record<string, string> = {
  Class:     '#6366f1',
  Interface: '#10b981',
  Record:    '#f59e0b',
  Enum:      '#ef4444',
}

// ═══════════════════════════════════════════════════════════════════════════
// Tipos internos
// ═══════════════════════════════════════════════════════════════════════════

interface SubInfo {
  layer:      string
  name:       string
  nodes:      GraphNode[]
  startAngle: number
  endAngle:   number
  midAngle:   number
  fill:       string
  stroke:     string
}

interface NodePos { node: GraphNode; x: number; y: number }
interface Transform { scale: number; tx: number; ty: number }
interface TooltipState { nodeId: string; sx: number; sy: number }

// ═══════════════════════════════════════════════════════════════════════════
// Helpers
// ═══════════════════════════════════════════════════════════════════════════

/** Extrai o nome da subdivisão a partir do namespace do nó */
function getSubdivision(node: GraphNode): string {
  const ns   = node.namespace ?? ''
  const layer = node.layer ?? ''
  if (!ns || !layer) return 'General'

  // Pattern: ...LayerName.SubdivisionName[....]
  const marker = `.${layer}.`
  const idx = ns.indexOf(marker)
  if (idx !== -1) {
    const after = ns.slice(idx + marker.length)
    const seg = after.split('.')[0]
    if (seg) return seg
  }
  // namespace termina no layer (sem subdivisão)
  if (ns.endsWith(`.${layer}`)) return 'Core'

  // Último segmento do namespace como fallback
  const parts = ns.split('.')
  return parts[parts.length - 1] || 'General'
}

/** Gera o path SVG de um setor anular (annular sector) */
function annularSectorPath(
  innerR: number, outerR: number,
  startAngle: number, endAngle: number,
): string {
  const la  = endAngle - startAngle > Math.PI ? 1 : 0
  const c   = (r: number, a: number) => `${+(r * Math.cos(a)).toFixed(3)},${+(r * Math.sin(a)).toFixed(3)}`

  if (innerR <= 0) {
    // Setor de pizza (Domain)
    return `M 0,0 L ${c(outerR, startAngle)} A ${outerR},${outerR} 0 ${la},1 ${c(outerR, endAngle)} Z`
  }
  return [
    `M ${c(innerR, startAngle)}`,
    `L ${c(outerR, startAngle)}`,
    `A ${outerR},${outerR} 0 ${la},1 ${c(outerR, endAngle)}`,
    `L ${c(innerR, endAngle)}`,
    `A ${innerR},${innerR} 0 ${la},0 ${c(innerR, startAngle)}`,
    'Z',
  ].join(' ')
}

const MIN_SECTOR = (2 * Math.PI) / 24  // ~15° mínimo por setor
const GAP        = 0.055               // gap em radianos entre setores

function computeLayout(nodes: GraphNode[]): {
  subdivisions: SubInfo[]
  positions:    Map<string, NodePos>
} {
  // Agrupamento layer → subdivision → nodes
  const grouped: Record<string, Record<string, GraphNode[]>> = {}
  for (const node of nodes) {
    const layer = LAYER_ORDER.includes(node.layer) ? node.layer : 'Domain'
    const sub   = getSubdivision(node)
    ;(grouped[layer] ??= {})
    ;(grouped[layer][sub] ??= []).push(node)
  }

  const subdivisions: SubInfo[] = []
  const positions    = new Map<string, NodePos>()

  for (const layer of LAYER_ORDER) {
    const subs = Object.entries(grouped[layer] ?? {})
    if (subs.length === 0) continue

    const totalNodes    = subs.reduce((s, [, ns]) => s + ns.length, 0)
    const totalGap      = GAP * subs.length
    const available     = 2 * Math.PI - totalGap

    // Ângulos raw proporcionais aos nós, com mínimo garantido
    const raw = subs.map(([, ns]) =>
      Math.max(MIN_SECTOR, (ns.length / totalNodes) * available),
    )
    const sumRaw = raw.reduce((s, a) => s + a, 0)
    const angles = raw.map(a => (a / sumRaw) * available)

    let cur      = -Math.PI / 2
    let fallIdx  = 0

    subs.forEach(([subName, subNodes], i) => {
      const angle      = angles[i]
      const startAngle = cur
      const endAngle   = cur + angle
      const midAngle   = (startAngle + endAngle) / 2

      const known  = SUB_CONFIG[layer]?.[subName]
      const colors = known ?? FALLBACK_COLORS[fallIdx++ % FALLBACK_COLORS.length]

      subdivisions.push({
        layer, name: subName, nodes: subNodes,
        startAngle, endAngle, midAngle,
        fill: colors.fill, stroke: colors.stroke,
      })

      // Posiciona os nós dentro do setor
      const r = NODE_RING_RADIUS[layer]
      subNodes.forEach((node, k) => {
        const nodeAngle =
          subNodes.length === 1
            ? midAngle
            : startAngle + (angle * (k + 0.5)) / subNodes.length
        positions.set(node.id, {
          node,
          x: Math.round(r * Math.cos(nodeAngle)),
          y: Math.round(r * Math.sin(nodeAngle)),
        })
      })

      cur = endAngle + GAP
    })
  }

  return { subdivisions, positions }
}

function trunc(s: string, max = 15): string {
  return s.length > max ? s.slice(0, max - 1) + '…' : s
}

// ═══════════════════════════════════════════════════════════════════════════
// Sub-components SVG
// ═══════════════════════════════════════════════════════════════════════════

/** Desenha os setores coloridos de cada subdivisão */
function ArcSectors({
  subdivisions, selectedSubdivision, onSubClick,
}: {
  subdivisions: SubInfo[]
  selectedSubdivision: string | null
  onSubClick: (key: string | null) => void
}) {
  return (
    <g>
      {subdivisions.map((sub) => {
        const key    = `${sub.layer}::${sub.name}`
        const isSel  = selectedSubdivision === key
        const path   = annularSectorPath(
          RING_INNER[sub.layer], RING_OUTER[sub.layer],
          sub.startAngle, sub.endAngle,
        )
        return (
          <path
            key={key}
            d={path}
            fill={sub.fill}
            stroke={sub.stroke}
            strokeWidth={isSel ? 2.5 : 1}
            strokeLinejoin="round"
            opacity={selectedSubdivision && !isSel ? 0.45 : 1}
            style={{ cursor: 'pointer', transition: 'opacity 0.2s' }}
            onClick={() => onSubClick(isSel ? null : key)}
          />
        )
      })}
    </g>
  )
}

/** Labels de subdivisão posicionados fora de cada setor */
function SectorLabels({ subdivisions }: { subdivisions: SubInfo[] }) {
  return (
    <g>
      {subdivisions.map((sub) => {
        const key    = `${sub.layer}::${sub.name}`
        const outerR = RING_OUTER[sub.layer]
        const la     = outerR + 22
        const lx     = la * Math.cos(sub.midAngle)
        const ly     = la * Math.sin(sub.midAngle)

        // Ancoragem do texto dependendo do quadrante
        const cos    = Math.cos(sub.midAngle)
        const anchor =
          cos > 0.25 ? 'start' : cos < -0.25 ? 'end' : 'middle'
        const sin     = Math.sin(sub.midAngle)
        const baseline =
          sin > 0.25 ? 'hanging' : sin < -0.25 ? 'auto' : 'central'

        // Linha-guia do setor ao label
        const tickX1 = outerR * Math.cos(sub.midAngle)
        const tickY1 = outerR * Math.sin(sub.midAngle)
        const tickX2 = (outerR + 12) * Math.cos(sub.midAngle)
        const tickY2 = (outerR + 12) * Math.sin(sub.midAngle)

        // Só exibe se o setor tem ângulo mínimo para o label caber
        const arcLen = (sub.endAngle - sub.startAngle) * outerR
        if (arcLen < 30) return null

        return (
          <g key={key}>
            <line
              x1={tickX1} y1={tickY1}
              x2={tickX2} y2={tickY2}
              stroke={sub.stroke} strokeWidth={1} opacity={0.7}
            />
            <text
              x={lx} y={ly}
              textAnchor={anchor}
              dominantBaseline={baseline}
              fill={sub.stroke}
              fontSize={11} fontWeight={700}
              fontFamily="Plus Jakarta Sans, system-ui"
              opacity={0.9}
            >
              {sub.name}
            </text>
          </g>
        )
      })}
    </g>
  )
}

/** Rótulos das camadas no lado direito de cada anel */
function LayerLabels() {
  return (
    <g>
      {LAYER_ORDER.map((layer) => {
        const innerR = RING_INNER[layer]
        const outerR = RING_OUTER[layer]
        const midR   = (innerR + outerR) / 2
        const { color, label } = LAYER_BASE[layer]
        return (
          <text key={layer}
            x={midR} y={0}
            textAnchor="middle" dominantBaseline="central"
            fill={color} fontSize={12} fontWeight={800}
            fontFamily="Plus Jakarta Sans, system-ui"
            opacity={0.5}
            style={{ pointerEvents: 'none', userSelect: 'none' }}
            transform={`rotate(90, ${midR}, 0)`}
          >
            {label.toUpperCase()}
          </text>
        )
      })}
    </g>
  )
}

/** Separadores entre os anéis de camada */
function RingSeparators() {
  return (
    <g>
      {LAYER_ORDER.map((layer) => {
        const outerR = RING_OUTER[layer]
        const { color } = LAYER_BASE[layer]
        return (
          <circle key={layer}
            cx={0} cy={0} r={outerR}
            fill="none"
            stroke={color} strokeWidth={2}
            strokeDasharray="12 6"
            opacity={0.3}
          />
        )
      })}
      {/* Núcleo central */}
      <circle cx={0} cy={0} r={16} fill="#0f172a" />
      <circle cx={0} cy={0} r={8}  fill="#8b5cf6" opacity={0.8} />
      <circle cx={0} cy={0} r={4}  fill="#c4b5fd" />
    </g>
  )
}

/** Arestas bezier entre nós */
function EdgeLayer({
  edges, positions, selectedNodeId, selectedSubdivision, subdivisions,
}: {
  edges:               GraphEdge[]
  positions:           Map<string, NodePos>
  selectedNodeId:      string | null
  selectedSubdivision: string | null
  subdivisions:        SubInfo[]
}) {
  // Mapa rápido: nodeId → subdivisionKey
  const nodeSubMap = useMemo(() => {
    const m = new Map<string, string>()
    subdivisions.forEach(sub => {
      const key = `${sub.layer}::${sub.name}`
      sub.nodes.forEach(n => m.set(n.id, key))
    })
    return m
  }, [subdivisions])

  return (
    <g>
      {edges.map((edge) => {
        const src = positions.get(edge.source)
        const tgt = positions.get(edge.target)
        if (!src || !tgt) return null

        const isNodeSel = selectedNodeId === edge.source || selectedNodeId === edge.target
        const isSubSel  = selectedSubdivision !== null && (
          nodeSubMap.get(edge.source) === selectedSubdivision ||
          nodeSubMap.get(edge.target) === selectedSubdivision
        )
        const isHighlighted = isNodeSel || isSubSel

        const stroke = EDGE_STROKE[edge.edgeType] ?? { color: '#94a3b8' }

        // Bezier passando pelo centro (35%)
        const cx1 = src.x * 0.35
        const cy1 = src.y * 0.35
        const cx2 = tgt.x * 0.35
        const cy2 = tgt.y * 0.35
        const d   = `M${src.x},${src.y} C${cx1},${cy1} ${cx2},${cy2} ${tgt.x},${tgt.y}`

        const baseOpacity =
          selectedNodeId || selectedSubdivision ? (isHighlighted ? 0.85 : 0.05) : 0.2

        return (
          <path key={edge.id}
            d={d} fill="none"
            stroke={stroke.color}
            strokeWidth={isHighlighted ? 2 : 1}
            strokeDasharray={stroke.dash}
            opacity={baseOpacity}
            style={{ transition: 'opacity 0.2s, stroke-width 0.15s' }}
          />
        )
      })}
    </g>
  )
}

/** Card de nó SVG */
function NodeCard({
  pos, isSelected, isHovered, onClick, onEnter, onLeave,
}: {
  pos:        NodePos
  isSelected: boolean
  isHovered:  boolean
  onClick:    () => void
  onEnter:    (e: React.MouseEvent) => void
  onLeave:    () => void
}) {
  const { node, x, y } = pos
  const base    = LAYER_BASE[node.layer] ?? LAYER_BASE.Domain
  const elColor = ELEMENT_COLOR[node.type] ?? '#6366f1'
  const W = 136, H = 26
  const active = isSelected || isHovered

  return (
    <g
      transform={`translate(${x},${y})`}
      style={{ cursor: 'pointer' }}
      onClick={onClick}
      onMouseEnter={onEnter}
      onMouseLeave={onLeave}
    >
      {/* Halo de seleção */}
      {active && (
        <rect
          x={-W / 2 - 3} y={-H / 2 - 3}
          width={W + 6} height={H + 6} rx={9}
          fill={isSelected ? base.color : '#000'}
          opacity={isSelected ? 0.3 : 0.1}
        />
      )}
      {/* Card */}
      <rect
        x={-W / 2} y={-H / 2}
        width={W} height={H} rx={5}
        fill="white"
        stroke={active ? base.color : '#e2e8f0'}
        strokeWidth={isSelected ? 2.5 : isHovered ? 1.8 : 1}
      />
      {/* Badge tipo (esquerda) */}
      <rect x={-W / 2} y={-H / 2} width={22} height={H} rx={5} fill={elColor} />
      <rect x={-W / 2 + 16} y={-H / 2} width={6} height={H} fill={elColor} />
      <text
        x={-W / 2 + 11} y={0}
        textAnchor="middle" dominantBaseline="central"
        fill="white" fontSize={9} fontWeight={700}
        fontFamily="Plus Jakarta Sans, system-ui"
      >
        {node.type[0]}
      </text>
      {/* Nome */}
      <text
        x={-W / 2 + 30} y={0}
        dominantBaseline="central"
        fill={isSelected ? '#1e293b' : '#374151'}
        fontSize={10} fontWeight={isSelected ? 700 : 500}
        fontFamily="JetBrains Mono, monospace"
      >
        {trunc(node.label, 14)}
      </text>
    </g>
  )
}

/** Tooltip flutuante */
function Tooltip({ tip, positions }: { tip: TooltipState; positions: Map<string, NodePos> }) {
  const pos = positions.get(tip.nodeId)
  if (!pos) return null
  const { node } = pos
  const W = 240
  const rows: Array<[string, string]> = [
    ['Tipo',      node.type],
    ['Layer',     node.layer],
    ['Subdivisão', getSubdivision(node)],
    ['Projeto',   node.project],
    ['Namespace', node.namespace],
  ]

  return (
    <div style={{
      position: 'absolute', left: tip.sx + 14, top: tip.sy - 70,
      width: W, background: '#0f172a',
      border: '1px solid #1e293b', borderRadius: 8,
      padding: '8px 12px', pointerEvents: 'none', zIndex: 50,
      boxShadow: '0 8px 24px rgba(0,0,0,0.4)',
    }}>
      <div style={{
        color: '#f8fafc', fontWeight: 700, fontSize: 12,
        fontFamily: 'JetBrains Mono, monospace',
        borderBottom: '1px solid #1e293b', paddingBottom: 5, marginBottom: 5,
        wordBreak: 'break-all',
      }}>
        {node.label}
      </div>
      {rows.map(([label, value]) => (
        <div key={label} style={{ display: 'flex', gap: 4, fontSize: 11, lineHeight: '17px' }}>
          <span style={{ color: '#475569', minWidth: 70 }}>{label}:</span>
          <span style={{
            color: '#94a3b8', fontFamily: 'JetBrains Mono, monospace',
            wordBreak: 'break-all', fontSize: 10,
          }}>{value}</span>
        </div>
      ))}
    </div>
  )
}

/** Painel de subdivisão selecionada (contagem de nós) */
function SubdivisionPanel({
  subdivisions, selected,
}: { subdivisions: SubInfo[]; selected: string | null }) {
  if (!selected) return null
  const sub = subdivisions.find(s => `${s.layer}::${s.name}` === selected)
  if (!sub) return null

  const byType = sub.nodes.reduce<Record<string, number>>((acc, n) => {
    acc[n.type] = (acc[n.type] ?? 0) + 1
    return acc
  }, {})

  return (
    <div style={{
      position: 'absolute', top: 56, right: 16,
      background: '#0f172a', border: `2px solid ${sub.stroke}`,
      borderRadius: 10, padding: '12px 16px',
      minWidth: 200, pointerEvents: 'none', zIndex: 20,
    }}>
      <div style={{ color: sub.stroke, fontWeight: 700, fontSize: 13, marginBottom: 4 }}>
        {sub.layer} › {sub.name}
      </div>
      <div style={{ color: '#94a3b8', fontSize: 11, marginBottom: 8 }}>
        {sub.nodes.length} elemento{sub.nodes.length !== 1 ? 's' : ''}
      </div>
      {Object.entries(byType).map(([type, count]) => (
        <div key={type} style={{ display: 'flex', alignItems: 'center', gap: 6, marginBottom: 3 }}>
          <div style={{
            width: 10, height: 10, borderRadius: 2,
            background: ELEMENT_COLOR[type] ?? '#6366f1', flexShrink: 0,
          }} />
          <span style={{ color: '#cbd5e1', fontSize: 11 }}>{type}</span>
          <span style={{
            color: sub.stroke, fontWeight: 700, fontSize: 11,
            fontFamily: 'JetBrains Mono', marginLeft: 'auto',
          }}>{count}</span>
        </div>
      ))}
    </div>
  )
}

/** Legenda compacta de arestas */
function Legend({ edges }: { edges: GraphEdge[] }) {
  const usedTypes = [...new Set(edges.map(e => e.edgeType))]
  return (
    <div style={{
      position: 'absolute', bottom: 16, left: 16,
      background: 'rgba(15,23,42,0.88)', border: '1px solid #1e293b',
      borderRadius: 10, padding: '10px 14px',
      display: 'flex', flexDirection: 'column', gap: 5,
      pointerEvents: 'none',
    }}>
      <div style={{ color: '#475569', fontSize: 10, fontWeight: 700, letterSpacing: '0.06em', textTransform: 'uppercase', marginBottom: 2 }}>
        Arestas
      </div>
      {usedTypes.map(t => {
        const s = EDGE_STROKE[t] ?? { color: '#94a3b8' }
        return (
          <div key={t} style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
            <svg width={30} height={10}>
              <line x1={0} y1={5} x2={30} y2={5}
                stroke={s.color} strokeWidth={2} strokeDasharray={s.dash} />
            </svg>
            <span style={{ color: '#94a3b8', fontSize: 10, fontFamily: 'JetBrains Mono' }}>{t}</span>
          </div>
        )
      })}
      <div style={{ color: '#475569', fontSize: 10, fontWeight: 700, letterSpacing: '0.06em', textTransform: 'uppercase', marginTop: 6, marginBottom: 2 }}>
        Elementos
      </div>
      {Object.entries(ELEMENT_COLOR).map(([type, color]) => (
        <div key={type} style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
          <div style={{ width: 12, height: 12, borderRadius: 2, background: color, flexShrink: 0 }} />
          <span style={{ color: '#94a3b8', fontSize: 10 }}>{type}</span>
        </div>
      ))}
    </div>
  )
}

// ═══════════════════════════════════════════════════════════════════════════
// Componente principal
// ═══════════════════════════════════════════════════════════════════════════

interface Props {
  nodes:          GraphNode[]
  edges:          GraphEdge[]
  selectedNodeId: string | null
  onNodeClick:    (id: string) => void
}

export function DddSubdivisionCanvas({ nodes, edges, selectedNodeId, onNodeClick }: Props) {
  const containerRef = useRef<HTMLDivElement>(null)
  const dragRef      = useRef<{ sx: number; sy: number; tx: number; ty: number } | null>(null)

  const [transform,          setTransform]          = useState<Transform>({ scale: 0.52, tx: 0, ty: 0 })
  const [tooltip,            setTooltip]            = useState<TooltipState | null>(null)
  const [hoveredId,          setHoveredId]          = useState<string | null>(null)
  const [selectedSub,        setSelectedSub]        = useState<string | null>(null)

  const { subdivisions, positions } = useMemo(() => computeLayout(nodes), [nodes])

  // ── Zoom / Pan ────────────────────────────────────────────────────────────
  const onWheel = useCallback((e: React.WheelEvent) => {
    e.preventDefault()
    setTransform(prev => {
      const delta    = -e.deltaY * 0.001
      const newScale = Math.max(0.18, Math.min(3.5, prev.scale + delta * prev.scale))
      return { ...prev, scale: newScale }
    })
  }, [])

  const onMouseDown = useCallback((e: React.MouseEvent) => {
    if (e.button !== 0) return
    dragRef.current = { sx: e.clientX, sy: e.clientY, tx: transform.tx, ty: transform.ty }
  }, [transform.tx, transform.ty])

  const onMouseMove = useCallback((e: React.MouseEvent) => {
    if (dragRef.current) {
      setTransform(prev => ({
        ...prev,
        tx: dragRef.current!.tx + (e.clientX - dragRef.current!.sx),
        ty: dragRef.current!.ty + (e.clientY - dragRef.current!.sy),
      }))
    }
    // Atualiza tooltip
    if (tooltip && containerRef.current) {
      const r = containerRef.current.getBoundingClientRect()
      setTooltip(t => t ? { ...t, sx: e.clientX - r.left, sy: e.clientY - r.top } : null)
    }
  }, [tooltip])

  const onMouseUp = useCallback(() => { dragRef.current = null }, [])

  // ── Tooltip ───────────────────────────────────────────────────────────────
  const handleNodeEnter = useCallback((nodeId: string, e: React.MouseEvent) => {
    const r = containerRef.current?.getBoundingClientRect()
    if (!r) return
    setHoveredId(nodeId)
    setTooltip({ nodeId, sx: e.clientX - r.left, sy: e.clientY - r.top })
  }, [])

  const handleNodeLeave = useCallback(() => {
    setHoveredId(null)
    setTooltip(null)
  }, [])

  const VB  = 960
  const css = `translate(${transform.tx}px,${transform.ty}px) scale(${transform.scale})`

  return (
    <div
      ref={containerRef}
      style={{ position: 'relative', width: '100%', height: '100%', overflow: 'hidden', background: '#f8fafc' }}
      onWheel={onWheel}
      onMouseDown={onMouseDown}
      onMouseMove={onMouseMove}
      onMouseUp={onMouseUp}
      onMouseLeave={onMouseUp}
    >
      {/* Dica de uso */}
      <div style={{
        position: 'absolute', top: 12, left: '50%', transform: 'translateX(-50%)',
        background: 'rgba(15,23,42,0.75)', color: '#94a3b8',
        borderRadius: 20, padding: '4px 14px', fontSize: 11,
        pointerEvents: 'none', zIndex: 10, whiteSpace: 'nowrap',
      }}>
        Clique no setor para filtrar · Scroll para zoom · Arraste para mover
      </div>

      {/* Botões de controle */}
      <div style={{
        position: 'absolute', top: 12, right: 16, zIndex: 20,
        display: 'flex', gap: 8,
      }}>
        {selectedSub && (
          <button
            onClick={() => setSelectedSub(null)}
            style={{
              background: '#ef4444', color: '#fff', border: 'none',
              borderRadius: 8, padding: '6px 14px', fontSize: 12, cursor: 'pointer',
            }}
          >
            ✕ Limpar filtro
          </button>
        )}
        <button
          onClick={() => setTransform({ scale: 0.52, tx: 0, ty: 0 })}
          style={{
            background: '#1e293b', color: '#f8fafc', border: 'none',
            borderRadius: 8, padding: '6px 14px', fontSize: 12, cursor: 'pointer',
          }}
        >
          ⊡ Centralizar
        </button>
      </div>

      {/* SVG Principal */}
      <svg
        width="100%" height="100%"
        viewBox={`-${VB} -${VB} ${VB * 2} ${VB * 2}`}
        style={{
          transform: css,
          transformOrigin: 'center center',
          cursor: dragRef.current ? 'grabbing' : 'grab',
          display: 'block',
        }}
      >
        {/* 1. Setores coloridos por subdivisão */}
        <ArcSectors
          subdivisions={subdivisions}
          selectedSubdivision={selectedSub}
          onSubClick={setSelectedSub}
        />

        {/* 2. Separadores de anel e núcleo central */}
        <RingSeparators />

        {/* 3. Labels das camadas (rotacionados no anel) */}
        <LayerLabels />

        {/* 4. Labels das subdivisões (fora dos setores) */}
        <SectorLabels subdivisions={subdivisions} />

        {/* 5. Arestas */}
        <EdgeLayer
          edges={edges}
          positions={positions}
          selectedNodeId={selectedNodeId}
          selectedSubdivision={selectedSub}
          subdivisions={subdivisions}
        />

        {/* 6. Nós */}
        {[...positions.values()].map(pos => (
          <NodeCard
            key={pos.node.id}
            pos={pos}
            isSelected={selectedNodeId === pos.node.id}
            isHovered={hoveredId === pos.node.id}
            onClick={() => {
              onNodeClick(pos.node.id)
              setSelectedSub(null)
            }}
            onEnter={(e) => handleNodeEnter(pos.node.id, e)}
            onLeave={handleNodeLeave}
          />
        ))}
      </svg>

      {/* Tooltip */}
      {tooltip && <Tooltip tip={tooltip} positions={positions} />}

      {/* Painel da subdivisão selecionada */}
      <SubdivisionPanel subdivisions={subdivisions} selected={selectedSub} />

      {/* Legenda */}
      <Legend edges={edges} />
    </div>
  )
}
