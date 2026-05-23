import { useState } from 'react'
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { Plus, Trash2, Edit2, Check, X } from 'lucide-react'

interface Column<T> {
  key: keyof T
  label: string
  mono?: boolean
}

interface CrudPageProps<T extends { id?: number }> {
  title: string
  queryKey: string[]
  fetchAll: () => Promise<T[]>
  deleteItem: (id: number) => Promise<void>
  columns: Column<T>[]
  renderCreateForm: (onSave: (data: Omit<T, 'id'>) => void, onCancel: () => void) => React.ReactNode
}

export function CrudPage<T extends { id?: number }>({
  title, queryKey, fetchAll, deleteItem, columns, renderCreateForm,
}: CrudPageProps<T>) {
  const [showCreate, setShowCreate] = useState(false)
  const queryClient = useQueryClient()

  const { data = [], isLoading } = useQuery({ queryKey, queryFn: fetchAll })

  const deleteMutation = useMutation({
    mutationFn: deleteItem,
    onSuccess: () => queryClient.invalidateQueries({ queryKey }),
  })

  return (
    <div style={{ padding: 24, fontFamily: 'Plus Jakarta Sans, system-ui', maxWidth: 1000 }}>
      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: 20 }}>
        <h1 style={{ margin: 0, fontSize: 20, fontWeight: 700, color: '#1e293b' }}>{title}</h1>
        <button
          onClick={() => setShowCreate(true)}
          style={{
            display: 'flex', alignItems: 'center', gap: 6,
            background: '#6366f1', color: '#fff', border: 'none',
            borderRadius: 8, padding: '8px 16px', fontSize: 13, fontWeight: 600, cursor: 'pointer',
          }}
        >
          <Plus size={15} />
          Novo
        </button>
      </div>

      {/* Create form */}
      {showCreate && (
        <div style={{
          background: '#fff', border: '1px solid #c7d2fe', borderRadius: 12,
          padding: 20, marginBottom: 20,
        }}>
          <h3 style={{ margin: '0 0 16px', fontSize: 14, color: '#4338ca' }}>Novo registro</h3>
          {renderCreateForm(
            () => { setShowCreate(false); queryClient.invalidateQueries({ queryKey }) },
            () => setShowCreate(false)
          )}
        </div>
      )}

      {/* Table */}
      <div style={{
        background: '#fff', border: '1px solid #e2e8f0', borderRadius: 12, overflow: 'hidden',
      }}>
        {isLoading ? (
          <div style={{ padding: 32, textAlign: 'center', color: '#94a3b8' }}>Carregando...</div>
        ) : data.length === 0 ? (
          <div style={{ padding: 32, textAlign: 'center', color: '#94a3b8' }}>
            Nenhum registro. Clique em "Novo" para começar.
          </div>
        ) : (
          <table style={{ width: '100%', borderCollapse: 'collapse' }}>
            <thead>
              <tr style={{ background: '#f8fafc', borderBottom: '1px solid #e2e8f0' }}>
                <th style={{ padding: '10px 14px', textAlign: 'left', fontSize: 11, fontWeight: 700, color: '#64748b', textTransform: 'uppercase', letterSpacing: '0.05em' }}>
                  ID
                </th>
                {columns.map((col) => (
                  <th key={String(col.key)} style={{ padding: '10px 14px', textAlign: 'left', fontSize: 11, fontWeight: 700, color: '#64748b', textTransform: 'uppercase', letterSpacing: '0.05em' }}>
                    {col.label}
                  </th>
                ))}
                <th style={{ padding: '10px 14px', textAlign: 'right', fontSize: 11, fontWeight: 700, color: '#64748b', textTransform: 'uppercase', letterSpacing: '0.05em' }}>
                  Ações
                </th>
              </tr>
            </thead>
            <tbody>
              {(data as T[]).map((item, idx) => (
                <tr key={item.id ?? idx} style={{ borderBottom: '1px solid #f1f5f9' }}
                  onMouseEnter={(e) => (e.currentTarget.style.background = '#f8fafc')}
                  onMouseLeave={(e) => (e.currentTarget.style.background = 'transparent')}
                >
                  <td style={{ padding: '10px 14px', fontSize: 13, color: '#9ca3af', fontFamily: 'JetBrains Mono' }}>
                    {item.id}
                  </td>
                  {columns.map((col) => (
                    <td key={String(col.key)} style={{
                      padding: '10px 14px', fontSize: 13, color: '#374151',
                      fontFamily: col.mono ? 'JetBrains Mono, monospace' : undefined,
                      maxWidth: 280, overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap',
                    }}>
                      {String(item[col.key] ?? '')}
                    </td>
                  ))}
                  <td style={{ padding: '10px 14px', textAlign: 'right' }}>
                    <button
                      onClick={() => item.id && deleteMutation.mutate(item.id)}
                      style={{
                        background: 'none', border: '1px solid #fee2e2', borderRadius: 6,
                        padding: '4px 8px', cursor: 'pointer', color: '#ef4444',
                      }}
                      title="Deletar"
                    >
                      <Trash2 size={13} />
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        )}
      </div>
    </div>
  )
}

// Form helpers
export function FormField({ label, children }: { label: string; children: React.ReactNode }) {
  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: 4 }}>
      <label style={{ fontSize: 11, fontWeight: 600, color: '#64748b', textTransform: 'uppercase', letterSpacing: '0.05em' }}>
        {label}
      </label>
      {children}
    </div>
  )
}

export const inputStyle: React.CSSProperties = {
  padding: '8px 10px', border: '1px solid #e2e8f0', borderRadius: 8,
  fontSize: 13, background: '#f8fafc', outline: 'none',
  fontFamily: 'Plus Jakarta Sans, system-ui',
}

export function FormActions({ onSave, onCancel }: { onSave: () => void; onCancel: () => void }) {
  return (
    <div style={{ display: 'flex', gap: 8, marginTop: 8 }}>
      <button onClick={onSave} style={{
        display: 'flex', alignItems: 'center', gap: 5,
        background: '#6366f1', color: '#fff', border: 'none', borderRadius: 8,
        padding: '7px 16px', fontSize: 13, fontWeight: 600, cursor: 'pointer',
      }}>
        <Check size={13} /> Salvar
      </button>
      <button onClick={onCancel} style={{
        display: 'flex', alignItems: 'center', gap: 5,
        background: '#f1f5f9', color: '#374151', border: '1px solid #e2e8f0', borderRadius: 8,
        padding: '7px 16px', fontSize: 13, cursor: 'pointer',
      }}>
        <X size={13} /> Cancelar
      </button>
    </div>
  )
}
