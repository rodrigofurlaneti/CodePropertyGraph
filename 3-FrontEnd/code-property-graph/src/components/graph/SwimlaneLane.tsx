import { memo } from 'react'
import type { NodeProps } from '@xyflow/react'

export interface SwimlaneLaneData {
  label: string
  subtitle: string
  color: string
  bg: string
  border: string
  count: number
}

const HEADER_H = 52

function SwimlaneLaneComponent({ data }: NodeProps) {
  const d = data as SwimlaneLaneData

  return (
    <div
      style={{
        width: '100%',
        height: '100%',
        background: d.bg,
        border: `2px solid ${d.border}`,
        borderRadius: 14,
        display: 'flex',
        flexDirection: 'column',
        overflow: 'hidden',
        boxShadow: `0 2px 12px ${d.color}18`,
      }}
    >
      {/* Header */}
      <div
        style={{
          height: HEADER_H,
          background: d.color,
          display: 'flex',
          flexDirection: 'column',
          justifyContent: 'center',
          padding: '0 18px',
          gap: 2,
          flexShrink: 0,
        }}
      >
        <div
          style={{
            color: '#fff',
            fontWeight: 800,
            fontSize: 13,
            letterSpacing: '0.08em',
            textTransform: 'uppercase',
            lineHeight: 1,
          }}
        >
          {d.label}
        </div>
        <div
          style={{
            color: 'rgba(255,255,255,0.7)',
            fontSize: 10,
            fontWeight: 500,
            lineHeight: 1,
          }}
        >
          {d.subtitle} · {d.count} elemento{d.count !== 1 ? 's' : ''}
        </div>
      </div>

      {/* Body (empty — child nodes float here) */}
      <div style={{ flex: 1 }} />
    </div>
  )
}

export const SwimlaneLane = memo(SwimlaneLaneComponent)
SwimlaneLane.displayName = 'SwimlaneLane'
