import { memo } from 'react'
import { Handle, Position } from '@xyflow/react'
import type { NodeProps } from '@xyflow/react'
import type { GraphNode } from '../../types'

const ELEMENT_COLORS: Record<string, { bg: string; border: string; text: string; badge: string }> = {
  Class:     { bg: '#eef2ff', border: '#6366f1', text: '#3730a3', badge: '#6366f1' },
  Interface: { bg: '#ecfdf5', border: '#10b981', text: '#065f46', badge: '#10b981' },
  Record:    { bg: '#fffbeb', border: '#f59e0b', text: '#92400e', badge: '#f59e0b' },
  Enum:      { bg: '#fef2f2', border: '#ef4444', text: '#991b1b', badge: '#ef4444' },
}

const LAYER_COLORS: Record<string, string> = {
  Domain:         '#8b5cf6',
  Application:    '#3b82f6',
  Infrastructure: '#14b8a6',
  Api:            '#f97316',
}

type CodeElementNodeData = GraphNode & Record<string, unknown>

export const CodeElementNode = memo(({ data, selected }: NodeProps<CodeElementNodeData>) => {
  const colors = ELEMENT_COLORS[data.type] ?? ELEMENT_COLORS.Class
  const layerColor = LAYER_COLORS[data.layer] ?? '#6b7280'

  return (
    <div
      style={{
        background: colors.bg,
        border: `2px solid ${selected ? '#1d4ed8' : colors.border}`,
        borderRadius: 10,
        padding: '10px 14px',
        minWidth: 180,
        maxWidth: 240,
        boxShadow: selected
          ? `0 0 0 3px #bfdbfe, 0 4px 12px rgba(0,0,0,0.15)`
          : '0 2px 8px rgba(0,0,0,0.08)',
        transition: 'all 0.15s ease',
        fontFamily: 'Plus Jakarta Sans, system-ui, sans-serif',
      }}
    >
      <Handle type="target" position={Position.Top} style={{ background: colors.border, width: 8, height: 8 }} />

      {/* Header: Layer badge */}
      <div style={{ display: 'flex', alignItems: 'center', gap: 6, marginBottom: 6 }}>
        <span style={{
          background: layerColor, color: '#fff',
          borderRadius: 4, padding: '1px 6px',
          fontSize: 10, fontWeight: 600, letterSpacing: '0.03em',
        }}>
          {data.layer}
        </span>
        {data.isAbstract && (
          <span style={{ fontSize: 9, color: '#6b7280', fontStyle: 'italic' }}>abstract</span>
        )}
        {data.isSealed && (
          <span style={{ fontSize: 9, color: '#6b7280' }}>sealed</span>
        )}
      </div>

      {/* Element type badge + name */}
      <div style={{ display: 'flex', alignItems: 'flex-start', gap: 6 }}>
        <span style={{
          background: colors.badge, color: '#fff',
          borderRadius: 4, padding: '2px 7px',
          fontSize: 10, fontWeight: 700, flexShrink: 0, marginTop: 1,
        }}>
          {data.type[0]}
        </span>
        <span style={{
          color: colors.text, fontWeight: 600, fontSize: 13,
          lineHeight: 1.3, wordBreak: 'break-word',
          fontFamily: 'JetBrains Mono, monospace',
        }}>
          {data.label}
        </span>
      </div>

      {/* Namespace */}
      <div style={{
        marginTop: 6, fontSize: 10, color: '#9ca3af',
        fontFamily: 'JetBrains Mono, monospace',
        whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis',
      }} title={data.namespace}>
        {data.namespace}
      </div>

      <Handle type="source" position={Position.Bottom} style={{ background: colors.border, width: 8, height: 8 }} />
    </div>
  )
})

CodeElementNode.displayName = 'CodeElementNode'
