import { useState } from 'react'
import { useQuery } from '@tanstack/react-query'
import { AlertOctagon, CheckCircle2 } from 'lucide-react'
import { graphApi } from '../api/graph'

export function ViolationsPage() {
  const [sourceLayer, setSourceLayer] = useState('Domain')
  const [targetLayer, setTargetLayer] = useState('Infrastructure')

  const { data = [], isLoading, refetch } = useQuery({
    queryKey: ['violations', sourceLayer, targetLayer],
    queryFn: () => graphApi.getViolations(sourceLayer, targetLayer),
  })

  return (
    <div style={{ padding: 24, fontFamily: 'Plus Jakarta Sans, system-ui', maxWidth: 800 }}>
      <div style={{ display: 'flex', alignItems: 'center', gap: 10, marginBottom: 24 }}>
        <AlertOctagon size={22} color="#ef4444" />
        <h1 style={{ margin: 0, fontSize: 20, fontWeight: 700, color: '#1e293b' }}>
          Violações de Clean Architecture
        </h1>
      </div>

      {/* Query controls */}
      <div style={{
        background: '#fff', border: '1px solid #e2e8f0', borderRadius: 12,
        padding: 16, marginBottom: 24, display: 'flex', gap: 12, alignItems: 'flex-end',
      }}>
        <div>
          <label style={{ fontSize: 11, fontWeight: 600, color: '#64748b', textTransform: 'uppercase' }}>
            Camada Origem
          </label>
          <input
            value={sourceLayer}
            onChange={(e) => setSourceLayer(e.target.value)}
            style={{ display: 'block', marginTop: 4, padding: '7px 10px', border: '1px solid #e2e8f0', borderRadius: 8, fontSize: 13 }}
          />
        </div>
        <div>
          <label style={{ fontSize: 11, fontWeight: 600, color: '#64748b', textTransform: 'uppercase' }}>
            Camada Proibida
          </label>
          <input
            value={targetLayer}
            onChange={(e) => setTargetLayer(e.target.value)}
            style={{ display: 'block', marginTop: 4, padding: '7px 10px', border: '1px solid #e2e8f0', borderRadius: 8, fontSize: 13 }}
          />
        </div>
        <button
          onClick={() => refetch()}
          style={{
            padding: '8px 20px', background: '#6366f1', color: '#fff',
            border: 'none', borderRadius: 8, cursor: 'pointer', fontSize: 13, fontWeight: 600,
          }}
        >
          Verificar
        </button>
      </div>

      {/* Results */}
      {isLoading ? (
        <p style={{ color: '#64748b' }}>Verificando...</p>
      ) : data.length === 0 ? (
        <div style={{
          display: 'flex', alignItems: 'center', gap: 12,
          background: '#f0fdf4', border: '1px solid #bbf7d0', borderRadius: 12, padding: 20,
        }}>
          <CheckCircle2 size={24} color="#22c55e" />
          <div>
            <div style={{ fontWeight: 700, color: '#15803d' }}>Nenhuma violação encontrada</div>
            <div style={{ fontSize: 13, color: '#4ade80' }}>
              {sourceLayer} não depende de {targetLayer}. Clean Architecture está sendo respeitada!
            </div>
          </div>
        </div>
      ) : (
        <div>
          <div style={{
            background: '#fef2f2', border: '1px solid #fecaca', borderRadius: 8,
            padding: '10px 16px', marginBottom: 12, fontSize: 13, color: '#dc2626', fontWeight: 600,
          }}>
            ⚠️ {data.length} violação(ões) detectada(s): {sourceLayer} → {targetLayer}
          </div>
          {data.map((v, idx) => (
            <div key={idx} style={{
              display: 'flex', alignItems: 'center', gap: 10,
              padding: '10px 14px', background: '#fff',
              border: '1px solid #fee2e2', borderRadius: 8, marginBottom: 6,
            }}>
              <AlertOctagon size={14} color="#ef4444" />
              <span style={{ fontFamily: 'JetBrains Mono', fontSize: 13, color: '#1e293b' }}>
                {v.sourceElementName}
              </span>
              <span style={{ color: '#9ca3af', fontSize: 12 }}>depende de</span>
              <span style={{ fontFamily: 'JetBrains Mono', fontSize: 13, color: '#dc2626' }}>
                {v.forbiddenDependencyName}
              </span>
            </div>
          ))}
        </div>
      )}
    </div>
  )
}
