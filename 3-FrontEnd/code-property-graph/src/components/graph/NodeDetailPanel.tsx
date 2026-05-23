import { X, Layers, FolderOpen, Package, GitBranch } from 'lucide-react'
import type { GraphNode, GraphEdge } from '../../types'

interface NodeDetailPanelProps {
  node: GraphNode
  edges: GraphEdge[]
  allNodes: GraphNode[]
  onClose: () => void
}

export function NodeDetailPanel({ node, edges, allNodes, onClose }: NodeDetailPanelProps) {
  const nodeMap = Object.fromEntries(allNodes.map((n) => [n.id, n]))

  const outbound = edges.filter((e) => e.source === node.id)
  const inbound = edges.filter((e) => e.target === node.id)

  const TYPE_COLORS: Record<string, string> = {
    Class: '#6366f1', Interface: '#10b981', Record: '#f59e0b', Enum: '#ef4444',
  }
  const color = TYPE_COLORS[node.type] ?? '#6b7280'

  return (
    <div style={{
      width: 300, background: '#fff', borderLeft: '1px solid #e2e8f0',
      display: 'flex', flexDirection: 'column', fontFamily: 'Plus Jakarta Sans, system-ui',
      overflow: 'hidden',
    }}>
      {/* Header */}
      <div style={{
        padding: '14px 16px', borderBottom: '1px solid #f1f5f9',
        background: `linear-gradient(135deg, ${color}15, ${color}05)`,
        display: 'flex', alignItems: 'flex-start', justifyContent: 'space-between',
      }}>
        <div>
          <span style={{
            background: color, color: '#fff', borderRadius: 6,
            padding: '2px 8px', fontSize: 11, fontWeight: 700,
          }}>
            {node.type}
          </span>
          <h3 style={{
            margin: '6px 0 0', fontSize: 14, fontWeight: 700, color: '#1e293b',
            fontFamily: 'JetBrains Mono, monospace',
          }}>
            {node.label}
          </h3>
          {node.isAbstract && <span style={{ fontSize: 10, color: '#6b7280', fontStyle: 'italic' }}>abstract </span>}
          {node.isSealed && <span style={{ fontSize: 10, color: '#6b7280' }}>sealed</span>}
        </div>
        <button onClick={onClose} style={{
          background: 'none', border: 'none', cursor: 'pointer', color: '#9ca3af', padding: 4,
        }}>
          <X size={16} />
        </button>
      </div>

      <div style={{ padding: 16, display: 'flex', flexDirection: 'column', gap: 12, overflow: 'auto', flex: 1 }}>
        {/* Metadata */}
        <Section title="Localização">
          <InfoRow icon={<Layers size={13} color="#8b5cf6" />} label="Camada" value={node.layer} />
          <InfoRow icon={<FolderOpen size={13} color="#f97316" />} label="Projeto" value={node.project} />
          <InfoRow icon={<Package size={13} color="#3b82f6" />} label="Namespace" value={node.namespace} mono />
        </Section>

        {/* Outbound edges */}
        {outbound.length > 0 && (
          <Section title={`Dependências de saída (${outbound.length})`}>
            {outbound.map((e) => (
              <EdgeRow key={e.id} edge={e} target={nodeMap[e.target]} direction="out" />
            ))}
          </Section>
        )}

        {/* Inbound edges */}
        {inbound.length > 0 && (
          <Section title={`Dependências de entrada (${inbound.length})`}>
            {inbound.map((e) => (
              <EdgeRow key={e.id} edge={e} target={nodeMap[e.source]} direction="in" />
            ))}
          </Section>
        )}
      </div>
    </div>
  )
}

function Section({ title, children }: { title: string; children: React.ReactNode }) {
  return (
    <div>
      <div style={{
        fontSize: 10, fontWeight: 700, color: '#94a3b8',
        textTransform: 'uppercase', letterSpacing: '0.06em', marginBottom: 8,
      }}>
        {title}
      </div>
      <div style={{ display: 'flex', flexDirection: 'column', gap: 4 }}>
        {children}
      </div>
    </div>
  )
}

function InfoRow({ icon, label, value, mono }: {
  icon: React.ReactNode; label: string; value: string; mono?: boolean
}) {
  return (
    <div style={{ display: 'flex', gap: 8, alignItems: 'flex-start' }}>
      <span style={{ marginTop: 2, flexShrink: 0 }}>{icon}</span>
      <span style={{ fontSize: 11, color: '#64748b', flexShrink: 0, width: 60 }}>{label}</span>
      <span style={{
        fontSize: 12, color: '#1e293b', fontWeight: 500,
        fontFamily: mono ? 'JetBrains Mono, monospace' : undefined,
        wordBreak: 'break-all',
      }}>
        {value || '—'}
      </span>
    </div>
  )
}

function EdgeRow({ edge, target, direction }: {
  edge: GraphEdge; target?: GraphNode; direction: 'in' | 'out'
}) {
  const isImpl = edge.edgeType === 'IMPLEMENTS'
  return (
    <div style={{
      display: 'flex', alignItems: 'center', gap: 6,
      padding: '5px 8px', borderRadius: 6, background: '#f8fafc',
      border: '1px solid #f1f5f9',
    }}>
      <GitBranch size={12} color={isImpl ? '#10b981' : '#6366f1'} />
      <div style={{ flex: 1, overflow: 'hidden' }}>
        <div style={{
          fontSize: 11, fontWeight: 600, color: '#374151',
          fontFamily: 'JetBrains Mono, monospace',
          textOverflow: 'ellipsis', overflow: 'hidden', whiteSpace: 'nowrap',
        }}>
          {target?.label ?? (direction === 'out' ? edge.target : edge.source)}
        </div>
        <div style={{ fontSize: 10, color: '#9ca3af' }}>
          {edge.label} {!edge.isDirect && '(transitivo)'}
        </div>
      </div>
    </div>
  )
}
